---
title: 'Fruit of the algorithm: Generative fabric design'
slug: fruit-of-the-algorthim-a-generative-fabric-designer
createdAt: 2023-05-21 20:12:10.000000000 Z
updatedAt: 2023-06-19 14:52:58.000000000 Z
publishedAt: 2023-05-23 16:14:37.000000000 Z
FeatureImage: "/images/2023/05/Screenshot-from-2023-05-22-13-18-43.png"
date: 2023-05-23 16:14:37 UTC
layout: post
categories: creating-with-data
---

This shirt was designed by code.

![](<%= relative_url "/images/2023/05/IMG_20230523_141738-1.jpg" %>)

![](<%= relative_url "/images/2023/05/IMG_20230523_142626.jpg" %>)

![](<%= relative_url "/images/2023/05/IMG_20230523_142317.jpg" %>)

More accurately, the fabric pattern was composed with the help of a generative design tool. It randomly selected and arranged images from the US Dept. of Agriculture's Pomological Watercolour collection to visualise hundreds (if not thousands and thousands) of different shirt designs.

In my upcoming screencasts I'll re-create the steps to create [this generative design tool](https://creating-with-data.glitch.me/shirt-designer). For the moment, I'll explain the what and the why.

Indeed, why?

Well, many digital creative types feel the need to see some of their work realised into something physical. I'm no different, and during Covid-19 lockdown, I decided to take on a side-project to flex creative muscles that could be seen in the real world.

It was around this time I discovered there exist various services that do small runs of fabric printing.  As a picky shopper always frustrated by lack of stock, I began to think about getting something made, but what?

![](<%= relative_url "/images/2023/05/image-5.png" %>)

A Twitter bot by [Parker Higgins](https://twitter.com/xor) called ' [old fruit pictures](https://twitter.com/pomological)' put me on to the gorgeous watercolours held by the USDA. Terrific source material!

### Designing with code

> "I suppose it is tempting, if the only tool you have is a hammer, to treat everything as if it were a nail." - [Abraham Maslow](https://en.wikipedia.org/wiki/Law_of_the_instrument)

As soon as I discovered the archive I began by writing a scraper for the data in NodeJS using the very handy [Cheerio HTML parsing library](https://cheerio.js.org/). Helpfully, all the image names in the archive carry the same ID as you'd use to address their entries on the web.

The first version of the shirt visualiser was a scrappy combination of CSS, jQuery and a CC0 image of a shirt I found somewhere on the web. The 'Botanical wear generator' began with a 'Refresh' button that would randomise the images and arrangement of each pattern. Over time I added controls to shift patterns, vary sizing, and filter down to favourite images. It's [over here if you'd like to try it](https://generative-shirts.glitch.me/).

0:00

/

1×

By hitting that refresh button lots (and lots) of times I discovered:

- The archive has lots of pictures showing rotten fruit and diseases (ew)
- Apples are way overrepresented and there are some duplicates (boring)
- There aren't enough leaves (some more green would be nice)

I also began to notice some particularly striking images, and used the favouriting feature to narrow down generations to ensure only certain images were included.

![](<%= relative_url "/images/2023/05/image.png" %>)The final 3 showing [lemons](https://naldc.nal.usda.gov/catalog/POM00006422), [oranges](https://naldc.nal.usda.gov/catalog/POM00006332), and [pears](https://naldc.nal.usda.gov/catalog/POM00007144)

### Printing and tailoring

Once I had a pattern I was happy with, I downloaded the high resolution versions of the pictures. I arranged and normalised the colours of the images using photoshop. Before submitting to the printers, I briefly researched best practices for printing. It was at this point (rather late in the day) that I discovered that unidirectional designs more fabric to be available for cutting! This meant I needed to order an extra metre of fabric to ensure there was enough for tailoring.

For printing, I used a service called [Elobina](https://www.elobina.co.uk/), and had them send the fabric on to my tailor, [Elom Doussey](https://www.instagram.com/elomdousseytailoring/?hl=en). This was a little scary as I had no idea how well the printing process would turn out. Thankfully, both Elobina and my Elom did a great job!

![](<%= relative_url "/images/2023/05/result_154857.jpg" %>)

### The 2023 Remake

This was a fun project to work on so I decided to revive and remake the pattern designer as a Creating with Data project.

This version takes a different approach to the original, in that it takes after generative design software seen in architecture that helps visualise different possibilities side-by-side:

![](<%= relative_url "/images/2023/05/whyusegen3.gif" %>)Bionic Partition for Airbus - [Why should I use Generative Design?](https://www.generativedesign.org/01-introduction/01-02_generative-design/01-02-02_why-should-i-use-generative-design)

This version does just that.

0:00

/

1×

Since we can see lots of options I've decided not to bother reproducing all the controls in this version, and just leave in a 'generate more' button.

Among the changes I've decided to make in this remake, has been to address the way fabric patterns are drawn onto the generated shirts. In the original tool patterns were projected on the shirts as if by a projector throwing light on a wall. This is nothing like how a shirt looks once its sewn together!

![](<%= relative_url "/images/2023/05/transp_papaya.png" %>)

Tailors work from pattern cutting diagrams where bodice, arms, etc. are cut separately. There's specialised software out there that does this sort of thing, but we can do the same with a little SVG knowhow.

### Coming soon

_EDIT: [Part 1 code and video have been published!](<%= url_for("_posts/2023-06-01-creating-data-driven-fabric-designs-with-javascript-p1-scraping-and-data-preparation-with-nodejs.md") %>)_

_EDIT II: [Part 2 has been published!](<%= url_for("_posts/2023-06-19-creating-data-driven-fabric-designs-with-javascript-part-2.md") %>)_

I'll be publishing two videos tutorials on this very remake. In part 1 we'll explore the dataset, then do some data gathering and prep with a NodeJS script. Part 2 will get into the real generative design part with some SVG and D3js magic.

If that sounds good to you hit subscribe on the channel or join the newsletter here.

I look forward to flexing those creative + tech muscles together. 💪
