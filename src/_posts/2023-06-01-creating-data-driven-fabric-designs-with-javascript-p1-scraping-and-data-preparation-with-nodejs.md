---
title: Creating data-driven fabric designs with JavaScript - P1. scraping and data
  preparation with Node.js
slug: creating-data-driven-fabric-designs-with-javascript-p1-scraping-and-data-preparation-with-nodejs
createdAt: 2023-06-01 17:40:58.000000000 Z
updatedAt: 2023-07-20 16:12:48.000000000 Z
publishedAt: 2023-06-01 22:15:07.000000000 Z
FeatureImage: "/images/2023/06/cover-nowords-1.png"
date: 2023-06-01 22:15:07 UTC
layout: post
categories: creating-with-data
---

This screencast is part 1 of 2. It shows how to scrape imagery and data from the [USDA's online collection of pomological watercolours](https://naldc.nal.usda.gov/usda_pomological_watercolor?per_page=100). This sets up an imageset to be used in the generative pattern designer. For more context on the project, you can read my [previous post](<%= url_for("_posts/2023-05-23-fruit-of-the-algorthim-a-generative-fabric-designer.md") %>).

The scraping is done using NodeJS with the [node-fetch](https://www.npmjs.com/package/node-fetch) and [cheerio](https://cheerio.js.org/) libraries. Once all the images and accompanying data are gathered we further process the images by cropping them slightly (10 pixels each way). To this end I demonstrate using [ImageMagick](https://imagemagick.org/)'s 'chop' command.

You can find [the code used in the screencast in the following gist](https://gist.github.com/digitalWestie/c6ade9ed9b2bff2927e9ddb72bb71ce8#file-scraping-fruit-pictures-md).


<!-- GHOST_RECOVERED_EMBEDS -->
<figure class="kg-card kg-embed-card"><iframe width="575" height="325" src="https://www.youtube.com/embed/fzI2PFEm_Mw?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen title="Creating data-driven fabric designs with JavaScript (p1. Scraping and data preparation with NodeJS)"></iframe></figure>

<!-- /GHOST_RECOVERED_EMBEDS -->
