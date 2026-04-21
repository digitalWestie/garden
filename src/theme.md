---
layout: page
title: Theme
---

# Theme Playground

Use this page to quickly test color combinations, rhythm, and component balance for the Liturgical Machine system.

## Palette

<section class="theme-preview-grid">
  <article class="theme-swatch theme-swatch-canvas">
    <strong>Canvas</strong>
    <code>--canvas #F5F2E9</code>
  </article>
  <article class="theme-swatch theme-swatch-dark-canvas">
    <strong>Dark Canvas</strong>
    <code>--dark-canvas #BEA971</code>
  </article>
  <article class="theme-swatch theme-swatch-grid-line">
    <strong>Grid Line</strong>
    <code>--grid-line #E0D7C1</code>
  </article>
  <article class="theme-swatch theme-swatch-accent-gold">
    <strong>Accent Gold</strong>
    <code>--accent-gold #D4AF37</code>
  </article>
  <article class="theme-swatch theme-swatch-ink">
    <strong>Ink</strong>
    <code>--ink #333333</code>
  </article>
  <article class="theme-swatch theme-swatch-ultramarine">
    <strong>Ultramarine</strong>
    <code>--ultramarine #002FA7</code>
  </article>
  <article class="theme-swatch theme-swatch-indigo-void">
    <strong>Indigo Void</strong>
    <code>--indigo-void #0040E4</code>
  </article>
  <article class="theme-swatch theme-swatch-contrast-rust">
    <strong>Contrast Rust</strong>
    <code>--contrast-rust #A84D3B</code>
  </article>
</section>

## Mechanical Frame + Type

<section class="theme-surface">
  <h3>Olivetti Ledger Block</h3>
  <p>
    Headers use the slab serif stack while body copy and interface text use the monospace stack.
    The frame is flat, precise, and shadowless.
  </p>
  <p>
    <a href="#">Primary link state</a> and <a href="#">accent hover/focus</a> should stay restrained against the paper field.
  </p>
</section>

## Divine Dither Samples

<section class="theme-dither-grid">
  <article class="theme-panel">
    <h3>Default Dither</h3>
    <p>Indigo-to-ultramarine with subtle dot texture.</p>
  </article>
  <article class="theme-panel u-contrast-anchor">
    <h3>With Rust Anchor</h3>
    <p>Warm structural edge for selective emphasis.</p>
  </article>
</section>

## Status Anchor

<p class="theme-status u-contrast-anchor">
  Current Status: Stable draft. Use rust only as a sparse structural cue.
</p>

## Dark Canvas Surface

<section class="theme-dark-canvas-demo">
  <h3>Dark Canvas Panel</h3>
  <p>
    This panel uses <code>--dark-canvas</code> as a warmer substrate for testing typography and contrast.
  </p>
</section>

## Dark Canvas Basis Preview

<section class="theme-dark-basis">
  <h3>Site Region on Dark Canvas</h3>
  <p>
    This block remaps local theme values so <code>--dark-canvas</code> acts as the base field with a softened structural grid.
  </p>
  <div class="theme-dark-panel">
    <p>
      Framed panel sample with body copy, <a href="#">link behavior</a>, and standard border language.
    </p>
  </div>
  <p class="theme-status u-contrast-anchor">
    Current Status: Dark-canvas baseline with rust anchor.
  </p>
</section>


## Dithred Background with SVG Noise

<svg width="0" height="0" aria-hidden="true">
  <filter id="grainy" x="0" y="0" width="100%" height="100%">
    <feTurbulence type="fractalNoise" baseFrequency=".737"></feTurbulence>
    <feColorMatrix type="saturate" values="0"></feColorMatrix>
    <feBlend mode="multiply" in="SourceGraphic"></feBlend>
  </filter>
</svg>

<div class="grained">
</div>
