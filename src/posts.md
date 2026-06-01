---
layout: page
title: Posts
bodyClass: "wide-layout"
---

# Posts

<div class="content-card-grid" role="list">
  <% collections.posts.select(&:published?).each do |post| %>
    <% image_path = post.data.featureImage %>
    <% image_url = image_path.present? ? relative_url(image_path) : nil %>
    <% categories = post.data.categories %>
    <% categories = [categories].flatten.compact.reject(&:blank?) %>
    <% excerpt_source = post.data.excerpt.presence || post.content.to_s %>
    <% excerpt_text = strip_html(excerpt_source).gsub(/\s+/, " ").strip %>
    <% excerpt_text = "#{excerpt_text[0, 157]}..." if excerpt_text.length > 160 %>

    <article class="content-card" role="listitem">
      <a class="content-card-image-link" href="<%= post.relative_url %>" aria-label="Read <%= post.data.title %>">
        <% if image_url.present? %>
          <img class="content-card-image" src="<%= image_url %>" alt="" loading="lazy" decoding="async" />
        <% else %>
          <div class="content-card-image content-card-image-fallback" aria-hidden="true">
            <img class="content-card-fallback-logo" src="<%= relative_url '/images/logo.svg' %>" alt="" loading="lazy" decoding="async" />
          </div>
        <% end %>
      </a>

      <div class="content-card-body">
        <h2 class="content-card-title">
          <a href="<%= post.relative_url %>"><%= post.data.title %></a>
        </h2>

        <% if post.date.present? %>
          <p class="content-card-date">
            <time datetime="<%= post.date.iso8601 %>"><%= post.date.strftime("%-d %b %Y") %></time>
          </p>
        <% end %>

        <% if categories.any? %>
          <p class="content-card-categories"><%= categories.join(", ") %></p>
        <% end %>

        <% if excerpt_text.present? %>
          <p class="content-card-excerpt"><%= excerpt_text %></p>
        <% end %>
      </div>
    </article>
  <% end %>
</div>
