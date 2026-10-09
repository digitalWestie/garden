---
layout: landing
title: Rory Gianni
---

<div class="landing-frame">
  <section class="landing-hero">
    <div class="landing-hero__copy">
      <p class="landing-hero__name">Hello, I'm Rory</p>
      <h1 class="landing-hero__headline"><em>Technical partner for design-led teams</em></h1>
      <p class="landing-hero__support">Human-centred design creates rich insight. I help make sure it doesn't get lost in technical design and implementation.</p>
      <a class="landing-hero__cta" href="mailto:<%= site.metadata.email %>">Get in touch</a>
    </div>
    <figure class="landing-hero__visual">
      <img src="<%= relative_url '/images/peach-headshot.jpg' %>" alt="Portrait of Rory Gianni" width="800" height="1000" />
    </figure>
  </section>
</div>

<section class="landing-section landing-section--band" id="what">
  <div class="landing-section__inner">
    <h2>Complementing design practice with technical expertise</h2>
    <p class="landing-section__lead">
      I've been working independently for 15+ years as technology consultant and full-stack developer; taking early ideas through to production for startups, agencies, universities, and the public sector. Alongside delivery I’ve trained and mentored others in software development and open data. I’ve collaborated closely with design practitioners in design-led research and civic tech projects.
    </p>
  </div>

  <div class="landing-accent-orb" aria-hidden="true"></div>
</section>

<section class="landing-section landing-who" id="who" style="position: relative;">


  <span class="landing-label">Who I work with</span>
  <div class="landing-who__layout" style="position: relative;">
    <div class="landing-who__copy">
      <h2>Design-led studios that need serious technical delivery</h2>
      <p class="landing-section__lead">I partner with teams that are design- or strategy-led and take on complex digital work.</p>
    </div>
    <ul class="landing-list landing-who__list">
      <li>Digital product studios</li>
      <li>Service design agencies</li>
      <li>Innovation consultancies</li>
    </ul>

    <figure style="left: 0;" class="landing-who__clients">
      <img src="<%= relative_url '/images/clients.jpeg' %>" alt="Logos of organisations Rory has worked with" />
    </figure>
  </div>
</section>


<section class="landing-section landing-section--band-light landing-section--has-photo" id="services">
  <div class="landing-section__bg-photo" aria-hidden="true">
    <img src="<%= relative_url '/images/2023/05/Screenshot-from-2023-05-30-17-15-15.png' %>" alt="" />
  </div>
  <div class="landing-section__inner">
    <h2>Services</h2>
    <p class="landing-section__lead">From early technical judgment through to hands-on delivery.</p>

    <div class="content-card-grid landing-service-grid" role="list">
      <article class="content-card landing-service-card" role="listitem">
        <div class="content-card-body">
          <h3 class="content-card-title">Technical consultancy</h3>
          <p class="content-card-excerpt">Scope, feasibility, and estimates for proposals and tenders — plus architecture guidance that keeps design insight intact.</p>
        </div>
      </article>

      <article class="content-card landing-service-card" role="listitem">
        <div class="content-card-body">
          <h3 class="content-card-title">Training and upskilling</h3>
          <p class="content-card-excerpt">Workshops and coaching that help teams move from early ideas to working software with more confidence.</p>
        </div>
      </article>

      <article class="content-card landing-service-card" role="listitem">
        <div class="content-card-body">
          <h3 class="content-card-title">Full stack development</h3>
          <p class="content-card-excerpt">Hands-on delivery of digital products, internal tools, and integrations.</p>
        </div>
      </article>
    </div>
  </div>
</section>


<div class="landing-frame-small">
  <section class="landing-section landing-contact-section" id="contact">
    <span class="landing-label">Contact</span>
    <div class="landing-contact-layout">
      <figure class="landing-contact__visual">
        <img src="<%= relative_url '/images/moon-profile-d.png' %>" alt="Portrait of Rory looking toward a glowing orb" width="400" height="400" />
      </figure>
      <div class="landing-contact__copy">
        <h2>Want a technical partner on a proposal or a build?</h2>
        <div class="landing-contact">
          <p class="landing-section__lead">If you’re weighing what to commit to, or need capacity that fits alongside your team, get in touch.</p>
          <a class="landing-contact__cta" href="mailto:<%= site.metadata.email %>"><%= site.metadata.email %></a>
        </div>
      </div>
    </div>
  </section>
</div>

<!--
Parked for later — How I work / Ways of working


<section class="landing-section landing-section--band-light" id="problem">
  <div class="landing-section__inner">
    <h2>Approach</h2>

    <p class="landing-section__lead">Digital products and the services they support are the accumulation of hundreds of small decisions: on data architecture, edge cases, system constraints, future roadmap, and more. Making those decisions needs to be informed by relationships and lessons gained from your practice.</p>

    <ul class="landing-list">
      <li>Where possible, participate in workshops and client engagements to gain deep understanding of context</li>
      <li>Support your team in seeing opportunities from a technical perspective</li>
      <li>Treat design research as material to build with</li>
    </ul>
  </div>
</section>


<section class="landing-section landing-section--band" id="how">
  <div class="landing-accent-orb" aria-hidden="true"></div>
  <div class="landing-section__inner">
    <span class="landing-label">How I work</span>
    <h2>From proposal to delivery</h2>
    <p class="landing-section__lead">Early input on tenders and proposals: sense-checking what’s buildable, shaping scope, and estimates you can quote with confidence. Then delivery on complex builds, with your team and with clients when that’s useful.</p>
    <ul class="landing-list">
      <li>Technical voice in the room before commitments are made</li>
      <li>Capacity that scales with your pipeline, without a full-time hire</li>
      <li>Someone who treats design research as material to build with, not a vague brief to reinvent</li>
      (also: workshops, client-facing context, opportunities as well as feasibility)
    </ul>
  </div>
</section>

<section class="landing-section" id="ways">
  <span class="landing-label">Ways of working</span>
  <h2>Embedded with your team, or more independently</h2>
  <p class="landing-section__lead">Sometimes the best fit is sitting inside your studio’s rhythm: workshops, stand-ups, and shared tools. Sometimes it’s cleaner if I take a defined slice of the technical work and report in at agreed points. Either way I can be client-facing when that helps.</p>
  <ul class="landing-list">
    <li>Embedded: day-to-day alongside designers and delivery leads</li>
    <li>Independent: clear ownership of a technical workstream, with regular check-ins</li>
    <li>Flexible by project: many engagements mix both as the work moves from proposal to build</li>
  </ul>
</section>
-->
