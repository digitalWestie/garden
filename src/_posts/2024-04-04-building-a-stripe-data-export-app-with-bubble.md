---
title: Building a Stripe data export app with Bubble
slug: building-a-stripe-data-export-app-with-bubble
createdAt: 2024-04-03 15:29:18.000000000 Z
updatedAt: 2024-04-04 16:54:59.000000000 Z
publishedAt: 2024-04-04 16:42:59.000000000 Z
FeatureImage: "/images/2024/04/Screenshot-from-2024-04-04-17-31-18.png"
date: 2024-04-04 16:42:59 UTC
layout: post
categories: creating-with-data
---

Over the past few weeks I've been dabbling with Nocode tool [Bubble.io](https://bubble.io/). I've played with Make, Airtable, and IFTTT before, but nothing as involved as Bubble. As a developer, Nocode holds two attractions, the promise of accelerated development, and second, the opportunity to empower non-technical colleagues.

![](<%= relative_url "/images/2024/04/image-38.png" %>)

### Introducing Timely Exports

To learn, I decided to set myself a project - an app to periodically email an export of data, ' [Timely Exports](https://post-emu.bubbleapps.io/version-test)'. Recently, I've been working with the Stripe API a bit so I went with Stripe as the platform. The ideal workflow for this app was: user signs up to the app, chooses what resource they'd like to export (e.g. Customers, Checkout Sessions etc) and then choose how frequently they'd like to receive email exports. Done.

[![](<%= relative_url "/images/2024/04/image-39.png" %>)](https://docs.stripe.com/api/customers/list) An example response from the Stripe Customers API endpoint

With Bubble, you more or less immediately have an application deployed with user accounts and email integration. The User account including login / sign-up forms are available right from the start. This means that save for UI details/branding, you can jump into implementing business logic straight away.

### v0 Implementation Plan

All this application really needs to know is a little about the Stripe account in question (i.e. a name plus API key), and the details of what to export (resource name and periodicity).

But before jumping into setting up recurring events or allowing the user to select a resource, I needed to check I could achieve the following:

1. Allow the user to provide their (restricted) API key
2. Successfully call the Stripe API
3. Flatten the JSON response into a tabular CSV string
4. Save the string to a file
5. Attach said file to an email and send it

### Making Stripe API requests with Bubble

![](<%= relative_url "/images/2024/04/image-19.png" %>)

There are lots of Stripe plugins for Bubble with API actions ready to go. However, I quickly found that few support all the capabilities of the API. This meant I needed to hand roll an API action to retrieve say, a list of customers. The way this is done in Bubble is you use the API connector plugin and configure the endpoints using a form.

This seemed simple enough. Fill in the form for each API request using the docs [Stripe API docs](https://docs.stripe.com/api/customers/list) for reference.

![](<%= relative_url "/images/2024/04/image-21-1.png" %>)Retrieve a list of customers

In Bubble, the form is setup so that the authentication method is shared across all endpoints with credentials saved in advance so you don't provide them when it comes to invoking the API action.

![](<%= relative_url "/images/2024/04/image-22.png" %>)

![](<%= relative_url "/images/2024/04/image-23.png" %>)

Stripe requests are authenticated by using HTTP Basic Auth and using the secret key as the username, and leaving the password blank (no idea why they've gone down that route).

### Hitting the Nocode wall

The above is sensible enough, but not at all what I wanted!

The token should be provided when we invoke the API action - just like any other parameter (e.g. 'limit' in this case). Unfortunately, it doesn't look like this plugin allows for passing auth details when you invoke API actions.

However, the API builder plugin allows you to pass in request header information. Among other things, this is what most of the various authentication methods actually do. The HTTP Basic Auth method Base64 encodes the username and password so you end up with an Authorization header that's something like this:

![](<%= relative_url "/images/2024/04/image-24.png" %>)Encode "this\_is\_your\_api\_secret:in\_stripe\_this\_blank" on base64encode.org and you'll see where the above string comes from

I was almost away to see if there was a way to Base64 encode until I remembered a simpler way to use basic auth. Prepending the user:pass combo with '@' in front of the domain:

![](<%= relative_url "/images/2024/04/image-25.png" %>)

Using square brackets here means Bubble understands that part as a parameter. Problem solved!

Using the initialize call button I was able to see that I could succesfully call the Stripe API. It seems Bubble requires you to do this so it can anticipate the contents of the API response.

### Flattening the JSON response

The next step was translating JSON into a 'flattened' tabular format that would make sense as a CSV.

![](<%= relative_url "/images/2024/04/image-26.png" %>)

I found a plugin for this, but for whatever reason I couldn't get it to work. I flailed around trying to see if I could cobble together a few Bubble actions to achieve building a CSV string but that turned out to be pretty onerous. Also, it was fixed to the 'Customer' API response rather than being abstract. At this point I decided to see if I could inject some code via my own plugin.

I thought this was going to be a huge hassle, but what's nice about plugins in bubble is that many plugins are openly readable and you can see exactly how they're written.

Using a few examples helped me jump into writing a JSON to CSV string function in JS that I could invoke in an action workflow where the input would be the raw response (as text), parse it, then flatten it into a CSV using the JSON keys as headers. For laziness/speed reasons I decided to ignore nested keys.

![](<%= relative_url "/images/2024/04/image-27.png" %>)

Aside from the raw body text, this function can take in a path specifier. This was to provide a bit of flexibility so you can tell the function where the collection is to turn into a CSV. For this purpose I require [the 'jsonpath' package](https://www.npmjs.com/package/jsonpath) that helps you navigate JSON objects using a path string.

There's one other parameter this plugin action takes, and that's 'encode\_output'. This is an option to Base64 encode the output which comes into play for file uploads in Bubble.

### What happened to the nocode?

I know. I know. There probably was a Nocode option out there for achieving this. From what I've gathered, full on nocoders would probably turn to looping in outside services like Make and Zapier in order to achieve bits of logic that aren't available in Bubble. I get the impression that any one nocode tool can only get you 80% of the way before you hit a wall.

Anyway, I digress.

### File Uploads

The next step was to take the result of this function, a big long string, and upload it as a file. Bubble has a 'Upload as CSV' action, but it demands that you specify an object / collection of objects from your db to upload. Once again I needed to figure out something myself. This is where the forums were very helpful. I discovered a thread that explained Bubble's file upload API. Using this I was able to construct an API action to upload to Bubble's file storage.

![](<%= relative_url "/images/2024/04/image-28.png" %>)

Bubble's file upload API expects 'contents' text to be Base64 encoded so that's why I added that option in the JSON to CSV action.

![](<%= relative_url "/images/2024/04/image-29.png" %>)

![](<%= relative_url "/images/2024/04/image-30.png" %>)

This is what the workflow looks like, chaining together the results of the various steps up to the API call action.

### Sending Email

Sending email using Bubble is dead easy! There's an inbuilt action. The bit that wasn't immediately clear was how to attach the newly uploaded file.

It turns out the response body of the upload API request has the URL to the file. This is what you need to provide in order to attach a file in the email action. Simple enough.

Here's the workflow and UI ended up with.

![](<%= relative_url "/images/2024/04/image-31.png" %>)

![](<%= relative_url "/images/2024/04/image-32.png" %>)

![](<%= relative_url "/images/2024/04/image-36.png" %>)

![](<%= relative_url "/images/2024/04/image-34.png" %>)

I added a Test button that doesn't do the upload step, but rather just displays the unencoded CSV text.

Since I don't want to end up storing anyone's data, I added a final workflow step to delete the uploaded file.

### The End Result

A spreadsheet, in my email inbox. Much Wow. These are the headings you get out of it. There'd be a few more if I bothered to sort out the nested object keys:

```
id  object  address balance created currency  default_currency  default_source  delinquent  description discount  email invoice_prefix  invoice_settings  livemode  metadata  name  phone preferred_locales shipping  tax_exempt  test_clock

```

![](<%= relative_url "/images/2024/04/image-37.png" %>)An example customer export spreadsheet

If you'd like to try this app for yourself head over to [https://post-emu.bubbleapps.io/version-test](https://post-emu.bubbleapps.io/version-test)

### Next Steps

In order to fulfil the original project vision, I'll need to provide a few more Stripe resource options for export (e.g. Checkout Sessions, Events etc.), and then persist the user's 'Export Configurations'  to the database.

The workflow itself remains more or less the same, but I belive it becomes what Bubble calls a backend workflow in order to be invoked as a recurring event. I know Bubble has provision for recurring events so I feel like the above isn't far off. What I don't know, however, is how to securely store my users' API keys. A cursory look through the plugins does reveal a few encryption options though so it seems doable.

### Some thoughts on Nocode

While playing around with Bubble on this project and a few other 'hello worlds' I hit several walls. This, in some senses, isn't dissimilar to my experiences learning new (code-based) frameworks. Each framework has assumptions built-in for ease and to accelerate development. The flip-side of this is that when they don't match these backfire and slow you down.

Like any technology, the trick is to know what you can and cannot easily do in order to be productive.
