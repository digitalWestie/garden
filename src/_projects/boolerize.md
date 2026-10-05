---
title: Boolerize
date: 2025-03-22
categories:
  - ruby-on-rails
  - svelte-js
  - browser-extension
featureImage: /images/projects/boolerize.png
excerpt: Boolerize is a browser extension that helps recruiters find candidates.
projectUrl: https://boolerize.com
---

[Boolerize](https://www.boolerize.com/) helps recruiters find candidates faster with a library of Boolean searches, save/reuse workflows, and (upcoming) AI refinement. I built and operate the full product: a Rails 8 API/backend and a cross-browser extension.

**Backend** - Rails API with Postgres, Redis, Meilisearch, JWT auth, Stripe/AppSumo licensing, and Kamal/Docker deployment (including accessories such as Meilisearch).

**Extension** - WXT + TypeScript + Svelte. It talks to the backend API and, on LinkedIn and recruiter surfaces, uses content scripts and background workers to parse SSR/DOM state (profile URLs, filters, pagination) and to read/parse search payloads that power the Boolean search workflows.
