---
layout: post
title:  "Reviving Programmer Happiness"
date:   2026-11-06 12:00:00 +0000
categories: programming,ruby,development
slug: reviving-programmer-happiness
featureImage: "/images/2026/why_city.png"
featureImageStyle: "background-size: contain; background-position: center;"
excerpt: "On the intersection of code, squishy feelings, and tokens"
published: true
---

<% slot :aside, transform: false do %>
  <%= render Shared::DeskWindow.new(
    id: "what-the-hell",
    title: "whoami",
    init: :inactive,
    activate_at: "#rob-bowley-quote",
    activate_as: :expanded,
    style: "max-width: 400px;",
    persist: true
  ) do %>
    <p style="font-style: italic; font-family: monospace;">Maybe I shouldn’t have let “developer” or “coder” fuse to my sense of self?<br/>Then again, what the hell? I spent years mastering this shit.</p>
  <% end %>
<% end %>

Plenty of people who were happy in their jobs no longer are. The transition to agentic coding has sent emotional shockwaves through the development community. 

Not everyone is upset though; some are quite happy. One way to look at it is that developers fall into two camps: the creators and the engineers. The creator is excited by what they can get out of the box; the engineer enjoys the constant discovery and learning that comes from inside it. So coding agents have delighted the creators and bereaved the engineers.

<blockquote id="rob-bowley-quote">
<p>Working through hard problems and watching something I'd built come to life. For ten years, it was part of my identity.</p>
<p>- <a href="https://lnkd.in/p/eMSxaD9w">Rob Bowley</a></p>
</blockquote>

Of course, the two camps are an oversimplification. Most of us live somewhere on the spectrum. I’d call myself a creator, but over the years I’ve drifted engineerwards, and my own feelings are mixed.

I think we need to address these feelings. Whenever they’re raised, there’s inevitably a variation of “move or die” swimming in the comments below. It’s callous and unhelpful. It also demonstrates ignorance about how people work and see their work.

### Human vs. machine-centric design

In the mid-90s the design goal for programming languages usually revolved around technical constraints e.g. RAM or portability. Ruby creator Yukihiro Matsumoto decided otherwise, and raised the flag of "programmer happiness". He argued a programming language should minimise the stress and cognitive load on the person writing the code. This was long before the term "Developer Experience" was coined.

In 2012 Fabian Fagerholm and Jürgen Münch wrote _Developer Experience: Concept and Definition_. They defined developer experience as how developers think and feel about their activities. Drawing on psychology’s old division of mind into cognition, affect, and conation, they put affect (feeling, emotion) on equal footing with how developers understand their tools and how they judge the value of their contributions.

> I no longer feel inspired to contribute to a commons that’s being strip-mined by massive corporations to feed the very machines whose unthinking output pollutes it. When people claim that it’s no longer sustainable to write code by hand, they’re not _entirely_ wrong, but only in the same way that it’s no longer sustainable to sleep in a bed once someone has taken a shit in it.
>
> \- Paul Battley, [Why I'm no longer updating this repository](https://po-ru.com/2026/10/18/why-im-no-longer-updating-this-repository)

The latest tools are generating more code, but they’re also hacking away at feelings of belonging, ownership and shared purpose. It has me wondering what will emerge as the next flagship of programmer happiness, and what we can do for each other in the meantime.