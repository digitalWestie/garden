---
layout: page
title: Projects
bodyClass: "wide-layout"
---

# Projects

Selected professional and personal projects.

<div class="content-card-grid" role="list">
  <% collections.projects.each do |project| %>
    <% link_raw = project.data["projectUrl"].presence || project.data["project_url"].presence %>
    <% card_href = nil %>
    <% link_target = nil %>
    <% link_rel = nil %>
    <% if link_raw.present? %>
      <% if link_raw.to_s.start_with?("http://", "https://") %>
        <% card_href = link_raw.to_s %>
        <% link_target = "_blank" %>
        <% link_rel = "noopener noreferrer" %>
      <% else %>
        <% card_href = relative_url(link_raw) %>
      <% end %>
    <% end %>

    <% image_path = project.data.featureImage %>
    <% image_url = image_path.present? ? relative_url(image_path) : nil %>
    <% categories = project.data.categories %>
    <% categories = [categories].flatten.compact.reject(&:blank?) %>
    <% excerpt_source = project.data.excerpt.presence || project.content.to_s %>
    <% excerpt_text = strip_html(excerpt_source).gsub(/\s+/, " ").strip %>
    <% excerpt_text = "#{excerpt_text[0, 157]}..." if excerpt_text.length > 160 %>

    <article class="content-card" role="listitem">
      <% if card_href.present? %>
        <a class="content-card-image-link" href="<%= card_href %>" aria-label="Visit <%= project.data.title %>"<% if link_target %> target="<%= link_target %>"<% end %><% if link_rel %> rel="<%= link_rel %>"<% end %>>
      <% else %>
        <div class="content-card-image-link">
      <% end %>
        <% if image_url.present? %>
          <img class="content-card-image" src="<%= image_url %>" alt="" loading="lazy" decoding="async" />
        <% else %>
          <div class="content-card-image content-card-image-fallback" aria-hidden="true">
            <img class="content-card-fallback-logo" src="<%= relative_url '/images/logo.svg' %>" alt="" loading="lazy" decoding="async" />
          </div>
        <% end %>
      <% if card_href.present? %>
        </a>
      <% else %>
        </div>
      <% end %>

      <div class="content-card-body">
        <h2 class="content-card-title">
          <% if card_href.present? %>
            <a href="<%= card_href %>"<% if link_target %> target="<%= link_target %>"<% end %><% if link_rel %> rel="<%= link_rel %>"<% end %>><%= project.data.title %></a>
          <% else %>
            <%= project.data.title %>
          <% end %>
        </h2>

        <% date_label = project.data["date_range"].presence %>
        <% if date_label.present? %>
          <p class="content-card-date"><%= date_label %></p>
        <% elsif project.date.present? %>
          <p class="content-card-date">
            <time datetime="<%= project.date.strftime("%Y") %>"><%= project.date.strftime("%Y") %></time>
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
