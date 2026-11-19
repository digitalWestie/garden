---
layout: post
title: "The operator is a user too"
date: 2026-11-19 12:00:00 +0000
categories: programming,product,development
slug: the-operator-is-a-user-too
featureImage: "/images/2026/pexels-muratak-30964840-bw.jpg"
featureImageStyle: "background-size: contain; background-repeat: no-repeat; background-color: #111; background-position: center;"
excerpt: "On building first versions, and why I keep asking about the month after launch."
published: true
---

The product launch has been fabulous! Now you have your first few users. You've worked hard, but now the real fun and games begin:

- Someone needs a refund
- A sign-up option needs removing
- An investor wants a demo on Thursday

Unfortunately, the only way to do any of it is for a developer to poke around the database.

### Everyone plans the product, hardly anyone plans the running of it

Many times I've sat across the table from someone with a vision, hashing out what matters and how that'll look as a software product. I certainly enjoy these early conversations, it's a creative process. Not everyone comes with all the details, but almost everyone has in mind what key points will look like for their target user. They'll know what outcomes they are trying to achieve.

At some point, I ask about the operational side, and I start to feel like the killjoy at a party.

"We'll need some sort of admin panel I suppose…" is generally about as far as it goes.

A less-experienced me did not anticipate the imbalance in how much people consider the operational side of products. The result was me becoming the stand-in operator for software I'd just launched. Sometimes that amounted to 5 minutes, but sometimes it was much more, and caused friction between me and my clients.

Being user-centred is good. But the person who updates content, moderates posts, and answers support emails is a user too. Even people who are fairly hands-off are users too, they need reports, or need to demo the software. Their personas don't make it on to the wall.

### Launch isn't the only goal

The hard focus is usually the launch, which is fair enough. But it can overshadow the other jobs the software needs to do, like being shown to investors or prospective customers.

That requirement often turns up as an afterthought, something like:

> "We need to easily spin up an example workspace, with logo, example users, and content, to show off the benefits of the software."

It sounds simple enough but it's not. "Demo mode" is a parallel set of behaviours that runs right through the application:

- Skipped form validations
- Accelerated flows (no waiting three days for an email sequence)
- Separate user privileges
- Example data that looks real but doesn't show up in reports

Building this in from the start is much easier than retrofitting, and can even be helpful when it comes to alternative purposes such as testing. Try to speedrun this the week before a sales demo and it becomes a right mess.

### The killjoy questions I ask now

These days I go full killjoy. I ask questions like:

- What happens a month, or a year, after launch?
- Who will sit down and operate this? What do they need to do daily, weekly, monthly?
- Will you be demoing it? Will you need example data, or a resettable demo account?
- How will you know it's working? Which numbers do you want to see, and who needs to see them?
- What will you be selling and can you control these tiers, trials, discounts etc?
- What else do you need control over? Feature flags, user permissions, content?
- Have you budgeted for maintenance? Security updates and dependency upgrades don't stop at launch.

If you're planning on building something, try answering these before your first developer meeting. You'll get a better estimate, and you'll spend a lot less time emailing them after launch. If you'd like me to be that killjoy for you, then I'm happy to have a quick chat about what you're trying to do.

---

*Header photo (edited to B&W): [Murat Ak on Pexels](https://www.pexels.com/photo/relaxing-by-the-bosphorus-with-scenic-ferry-30964840/).*

*Speaking of maintenance, a PSA for Ruby friends: upgrade to 4.0.10, 3.4.13, or 3.3.14 to fix a bunch of vulnerabilities. Details in the [Ruby security advisory](https://www.ruby-lang.org/en/news/2026/11/18/multiple-vulnerabilities-in-regexp-and-string/).*
