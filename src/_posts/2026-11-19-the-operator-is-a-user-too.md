---
layout: post
title: "The operator is a user too"
date: 2026-11-19 12:00:00 +0000
categories: programming,product,development
slug: the-operator-is-a-user-too
excerpt: "On building first versions, and why I keep asking about the month after launch."
published: true
---

You've launched. The product looks great, users are signing up, and then the emails start. Someone needs a refund. A post needs taking down. An investor wants a demo on Thursday. And the only way to do any of it is to ask the developer to poke the database.

I've been that developer more times than I'd like to admit.

## Everyone plans the product, hardly anyone plans the running of it

I love the early conversations. Sitting across the table from someone with a vision, hashing out what matters and how it turns into working software. Not everyone comes with details, but almost everyone has thought hard about:

- How it should feel to use
- What steps a user goes through
- What the outcomes should be

Then I ask about the operational side, and I start to feel like the killjoy at a party.

"We'll need some sort of admin panel I suppose…" is generally about as far as it goes.

Early on, before I'd learned to expect this, I'd end up as the stand-in operator for software I'd just launched. Not a great use of anyone's budget.

## The person running it is a user too

Being user-centred is good. But the person who updates content, moderates posts, and answers support emails is a user too. They just don't get a persona on the wall.

It's worth treating them like any other user. Ask:

- **Who are they?** A founder at midnight? A part-time admin? A support team of five?
- **What do they do, and how often?** Daily moderation, weekly reports, monthly billing checks.
- **What happens when it goes wrong?** Can they fix a mistake themselves, or do they need to call someone?

A quick exercise: write out "a week in the life of the operator", the same way you'd write a user journey. Anything on that list without a screen behind it is either a feature to build or a job someone will be doing by hand.

## Launch isn't the only goal

The hard focus is usually the launch. Fair enough, it's important. But it can overshadow the other jobs the software needs to do, like being shown to investors or prospective customers.

That requirement often turns up as one innocent-sounding line:

> "Easily spin up an example workspace, with assets, to show off the benefits of the software."

Sounds simple. It isn't. "Demo mode" is a parallel set of behaviours that runs right through the application:

- Skipped form validations
- Accelerated flows (no waiting three days for an email sequence)
- Separate user privileges
- Example data that looks real but doesn't leak into reporting

Spotted early, that's a design decision. Spotted the week before a pitch, it's a mess of hacks.

## The killjoy questions I ask now

These days I go full killjoy, and nobody's worse off for it. Here's what I ask before a line of code gets written:

- **What happens a month, or a year, after launch?**
- **Who will sit down and operate this?** What do they need to do daily, weekly, monthly?
- **Will you be demoing it?** Will you need example data, or a resettable demo account?
- **How will you know it's working?** Which numbers do you want to see, and who needs to see them?
- **What do you need control over?** Pricing, feature flags, user permissions, content?
- **What will you be selling?** Tiers, trials, discount codes, team plans?
- **Have you budgeted for maintenance?** Security updates and dependency upgrades don't stop at launch.

If you're planning a build, try answering these before your first meeting with a developer. You'll get a better estimate, and you'll spend a lot less time emailing them after launch.

---

*Speaking of maintenance, a PSA for Ruby friends: upgrade to 4.0.10, 3.4.13, or 3.3.14 to fix a bunch of vulnerabilities. Details in the [Ruby security advisory](https://www.ruby-lang.org/en/news/2026/11/18/multiple-vulnerabilities-in-regexp-and-string/).*
