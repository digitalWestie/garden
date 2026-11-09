---
layout: landing
title: Home
description: >-
  Technical partner for design-led studios and agencies. I help turn research, insight, and vision into working software without losing the thinking that makes the work distinctive.
featureImage: /images/peach-headshot.jpg
---

<div class="landing-frame">
  <section class="landing-hero">
    <h1 class="landing-hero__headline"><em>Technical partner for design-led teams</em></h1>
    <figure class="landing-hero__visual">
      <img src="<%= relative_url '/images/peach-headshot.jpg' %>" alt="Portrait of Rory Gianni" width="800" height="1000" />
    </figure>
    <div class="landing-hero__copy">
      <p class="landing-hero__support">
      Hello, I'm Rory. I help design-led teams turn research, insight, and vision into working software - without losing the thinking that makes the work distinctive.</p>
      <a class="landing-hero__cta" href="mailto:<%= site.metadata.email %>">Let's talk</a>
    </div>
  </section>
</div>

<div class="landing-clients" role="list" aria-label="Organisations Rory has worked with">
  <img role="listitem" src="<%= relative_url '/images/client-logos/logo-013.png' %>" alt="Consul Democracy" width="241" height="63" />
  <img role="listitem" src="<%= relative_url '/images/client-logos/logo-007.png' %>" alt="OpenActive" width="129" height="84" />
  <img role="listitem" src="<%= relative_url '/images/client-logos/logo-000.png' %>" alt="Urban Tide" width="234" height="74" />
  <img role="listitem" src="<%= relative_url '/images/client-logos/logo-006.png' %>" alt="Fringe Society" width="149" height="78" />
  <img role="listitem" src="<%= relative_url '/images/client-logos/logo-003.png' %>" alt="Open Data Institute" width="247" height="82" />
  <img role="listitem" src="<%= relative_url '/images/client-logos/logo-008.png' %>" alt="Health and Social Care Alliance Scotland" width="128" height="141" />
  <img role="listitem" src="<%= relative_url '/images/client-logos/logo-012.png' %>" alt="Nesta" width="233" height="102" />
  <img role="listitem" src="<%= relative_url '/images/client-logos/logo-014.png' %>" alt="Design Informatics" width="192" height="90" />
  <img role="listitem" src="<%= relative_url '/images/client-logos/logo-002.png' %>" alt="Tesco Bank" width="233" height="53" />
  <img role="listitem" src="<%= relative_url '/images/client-logos/logo-005.png' %>" alt="Insight Innovate" width="159" height="79" />
  <img role="listitem" src="<%= relative_url '/images/client-logos/logo-011.png' %>" alt="Lumi" width="184" height="66" />
</div>

<section class="landing-section landing-section--band" id="what">
  <div class="landing-section__inner">
    <h2>Bringing design thinking to life</h2>
    <p class="landing-section__lead">
      Your work starts with careful research, sharp thinking, and a clear point of view. It deserves technical delivery that carries the vision into working systems.
    </p>

    <p class="landing-section__lead">
      I’ve spent 15+ years working independently as a technology consultant and full-stack developer, taking early ideas through to production for startups, agencies, universities, and the public sector. Alongside delivery, I’ve trained and mentored teams in software development and open data, collaborating closely with design practitioners on design-led research and civic-tech projects.
    </p>
  </div>

  <div class="landing-accent-orb" aria-hidden="true"></div>
</section>

<section class="landing-section landing-who" id="who" style="position: relative;">
  <span class="landing-label">Who I work with</span>
  <div class="landing-who__layout" style="position: relative;">
    <div class="landing-who__copy">
      <h2>Teams taking on complex digital work</h2>
      <p class="landing-section__lead">Studios, agencies, and consultancies that put research and design first.</p>
    </div>
    <ul class="landing-list landing-who__list">
      <li>Digital product studios</li>
      <li>Service design agencies</li>
      <li>Innovation consultancies</li>
    </ul>
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
        <h2>Shaping a proposal or planning a project?</h2>
        <div class="landing-contact">
          <p class="landing-section__lead">If you’ve got something brilliant in motion, get in touch. I can add a technical voice to a tender, or capacity alongside your team.</p>
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
