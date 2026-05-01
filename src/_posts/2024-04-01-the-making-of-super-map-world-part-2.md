---
title: The making of Super Map World - Part 2. Core Architecture
slug: the-making-of-super-map-world-part-2
createdAt: 2024-03-11 16:11:49.000000000 Z
updatedAt: 2024-04-01 15:15:10.000000000 Z
publishedAt: 2024-04-01 15:01:22.000000000 Z
FeatureImage: "/images/2024/04/image-2-3.png"
date: 2024-04-01 15:01:22 UTC
layout: post
categories: creating-with-data
---

_This is the 2nd post in a series about building [Super Map World](https://supermap.world/) (SMW). SMW is a web-application featuring over 17,000 maps and map graphics. They're free and they're customisable using a map edit feature. Head [over here for the first post](<%= url_for("_posts/2024-02-21-the-making-of-super-map-world-part-1.md") %>) of the series._

![](<%= relative_url "/images/2024/04/image-17.png" %>)

To spend as much time focused on the core of the application I needed a simple template that would cut out the fiddling with project setup. My focus was on figuring out how to best represent and store the generatively designed maps from my prototype.

I wanted something that would get me started with user accounts, email integration, and all the other bits and pieces that make web-applications work. My two main requirements were, 1. nothing over-engineered, and 2. nothing relying on libraries that I wasn't somewhat familiar with.

### A Quickstart with Speedrail

Using Github search for Rails templates I eventually came across Speedrail. Speedrail was made by Ryan Kulp for his ' [Founder/Hacker](https://www.founderhacker.com/)' coding and product-launch course. It pretty much ticked all the boxes for me in my search for a simple, modern, Rails 7 template featuring:

- Devise for authentication
- Tailwind CSS
- Stripe for payments
- Rspec for testing
- Postmark for email
- Importmap for managing libraries

Getting started with Speedrail was a matter of cloning the repo, running the rename command `bin/speedrail new_app_name`, configuring environment variables in `config/application.yml`, then using it as you would any Rails application.

### Core architecture

The most important part of any web-application is its data architecture. The question now was how to store the various elements I had in my prototype, namely, map styles, and the generatively designed maps themselves.

![](<%= relative_url "/images/2024/04/image-8.png" %>)Map of Switzerland showing district boundaries

I needed something that could capture all the possible variations in a map rendering. Properties of a map can include several things including:

- geographic data i.e. the file it was rendered from, resolution, recommended projection
- source metadata e.g. where data was sourced, licencing details
- projection i.e. is it mercator, orthographic, something else?
- theme i.e. colours, shadows, graticule yes/no, borders yes/no, etc.
- location details e.g. centre point coordinates, name of the location
- visual adjustments e.g. margins and offset

It took me a while to come up with a schema that could represent all this while being 1. normalised, and efficent in database terms, and 2. easily indexed and searchable.

I came up with a 4 part system for capturing maps:

- MapStyle – represents all the styling information that could be applied to rendering a map.
- MapConfig – represents a source of geographic data and its relevent metadata.
- MapFraming – represents how the geographic data is framed and projected. This means projection plus any adjustments such as rotation, scaling, or margins.
- MapRendering – represents the rendering or a final image generated from all these factors. It has a number, a slug, and ties together these above representations via associations.

![](<%= relative_url "/images/2024/04/image-2.png" %>)ER diagram of how they fit together

While the above architecture seems clear now, I only thought about having MapStyle, MapConfig, and MapRendering. I couldn't figure out whether the framing information should sit with MapStyle or with MapRendering. I passed it back and forth quite a bit until I realised I was dealing with something that deserved a life of its own.

![](<%= relative_url "/images/2024/04/theImage.png" %>)

![](<%= relative_url "/images/2024/04/684635.png" %>)

![](<%= relative_url "/images/2024/04/138139.png" %>)

Essentially, a MapFraming tells us how to use the geographic data to depict something then MapStyle provides the theme.

To illustrate the relationships between these different models, let's consider the above 3 images or 'renderings'. They all share the same data, represented by the MapConfig. The two maps on the right share the same MapFraming, they are both orthographic projections, rotated to be centred on India. They don't share the same MapStyle, unlike the two on the left that do.

Representing the above in the database there's 1 MapConfig, 2 MapFramings, 2 MapStyles, and 3 MapRenderings

In the Super Map World database there are around 450 MapFramings, and roughly 87 different styles. The combination of the two means  (450 x 87) we can generate 39150 different renderings.

### Locations and searching

You may have noticed in the ER diagram that MapFraming has a location\_id. Location is associated with MapFraming. Its a model I use to support the search feature. The location table has been populated with countries and their ISO codes.

That said, the model isn't restricted to countries. It's intended to support any location on the globe that could be depicted with a map. Technically, a river or a city or a mountain could be the focul point of a map on SMW.

![](<%= relative_url "/images/2024/04/image-9.png" %>)

Currently, I have 'The World' as an entry in the location table because a world Mercator map isn't really depicting anything other than the world itself.

This location name information helps generate slug and description of map renderings. If you go to a map rendering's page on SMW, you'll notice this used in the description field along with the projection, boundary details (if any), and colour choice.

![](<%= relative_url "/images/2024/04/image-10.png" %>)

### Reasonable Colors

Reading through the description field you might wonder where the colour names come from. In the previous post, I explained the style generator randomly selected from a list of CSS colour names in order to come up with a theme. If you know your CSS names you'll notice these names don't exist in the CSS colour set.

After my initial prototype, I decided to ditch CSS colour names as they aren't quite uniform in their distribution. Thankfully, I came across ' [Reasonable Colors](https://reasonable.work/colors/)' by [Matthew Howell](https://www.matthewhowell.net/).

![](<%= relative_url "/images/2024/04/image-11.png" %>)

What's neat about this project is its simplicty and approach to accessibility and contrast.

> because this is all built within the LCH color space and [the relative luminance](https://www.w3.org/TR/WCAG20/#relativeluminancedef) for each shade is pinned within certain ranges, those contrast rules work across all 24 color sets. Mix and match shades from any color, even the grays.

Each colour comes with 6 pre-defined shades. For SMW, it provided a comprehensive yet manageable set of colours to choose from.

![](<%= relative_url "/images/2024/04/image-13.png" %>)

Constraining to this set also meant it wasn't too onerous to come up with a few extra colour names to make the descriptions a little more interesting. More importantly, it meant I could come up with a search feature that wouldn't demand the user to put in hex or rgb codes.

When you click on a colour on the search, or on a map rendering page it'll use the colour name plus shade index to query map styles and associated map renderings.

![](<%= relative_url "/images/2024/04/image-14.png" %>)Colour search - note the ?colour=amber-2 in the query string

### JSONB fields

Looking at the ER diagram you might also be wondering where exactly all this theme information is being stored given MapStyle only has 6 fields. Answer: it's all stuffed in the 'body' field.

That might sound horrible but I quite like it for this case. You see SMW uses PostgreSQL, and PostgreSQL supports what's called a 'JSONB' field where you can store arbitrary JSON objects. In my previous SMW post, I described my approach to generating map styles and the schema I came up with. Not wanting to alter or flatten this into a collection of relational DB tables, I opted to keep it as is, in a JSONB field.

What's neat about this is its flexible and we can still use Postgres to query values in there. I do use a custom Rails validator to ensure nothing funny goes on.

Here's how I query map renderings for a given colour or colour shade combination in map\_rendering.rb:

![](<%= relative_url "/images/2024/04/image-16.png" %>)

When a map style is generated I include a list of the colours and shades used in the style. This makes for handy reference and indexing. I realise it might be worth extracting this information out into a field of its own for faster indexing. For the moment, it seems to work fine.

### Next up: data and rendering

Aside from map styles I haven't quite explained where I got the geographic data from, and how that goes on a journey to becoming the map renderings you see on SMW. If that post doesn't get too extensive I'll cover a bit of the Stimulus and d3 JavaScript that brings things together.

_Btw, if you haven't already, do play around with [SMW](https://supermap.world/)! Feedback is appreciated! You can also find [SMW on Instagram](https://www.instagram.com/supermapworld/)._

_I will be extra grateful if you could share with your carto, map, or graphic-design inclined friends. This can contribute to the post on SEO / marketing (even though I don't have much to teach in that regard)._
