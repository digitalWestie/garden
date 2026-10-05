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
    <% visit_href = nil %>
    <% visit_target = nil %>
    <% visit_rel = nil %>
    <% if link_raw.present? %>
      <% if link_raw.to_s.start_with?("http://", "https://") %>
        <% visit_href = link_raw.to_s %>
        <% visit_target = "_blank" %>
        <% visit_rel = "noopener noreferrer" %>
      <% else %>
        <% visit_href = relative_url(link_raw) %>
      <% end %>
    <% end %>

    <% dialog_id = "project-dialog-#{File.basename(project.relative_path.to_s, ".*")}" %>
    <% image_path = project.data.featureImage %>
    <% image_url = image_path.present? ? relative_url(image_path) : nil %>
    <% categories = project.data.categories %>
    <% categories = [categories].flatten.compact.reject(&:blank?) %>
    <% excerpt_text = project.data.excerpt.to_s.strip %>
    <% excerpt_text = strip_html(excerpt_text).gsub(/\s+/, " ").strip if excerpt_text.present? %>
    <% excerpt_text = "#{excerpt_text[0, 157]}..." if excerpt_text.length > 160 %>
    <% body_source = project.content.to_s.strip %>
    <% body_html = body_source.present? ? markdownify(body_source) : "" %>
    <% has_dialog = body_source.present? || visit_href.present? %>

    <% date_label = project.data["date_range"].presence %>

    <article class="content-card" role="listitem">
      <% if has_dialog %>
        <button
          type="button"
          class="content-card-image-link"
          data-project-dialog-open="<%= dialog_id %>"
          aria-haspopup="dialog"
          aria-controls="<%= dialog_id %>"
          aria-label="View details for <%= project.data.title %>"
        >
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
      <% if has_dialog %>
        </button>
      <% else %>
        </div>
      <% end %>

      <div class="content-card-body">
        <h2 class="content-card-title">
          <% if has_dialog %>
            <button
              type="button"
              data-project-dialog-open="<%= dialog_id %>"
              aria-haspopup="dialog"
              aria-controls="<%= dialog_id %>"
            ><%= project.data.title %></button>
          <% else %>
            <%= project.data.title %>
          <% end %>
        </h2>

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

      <% if has_dialog %>
        <dialog class="project-dialog" id="<%= dialog_id %>" aria-labelledby="<%= dialog_id %>-title">
          <div class="project-dialog-panel">
            <form method="dialog" class="project-dialog-close-form">
              <button type="submit" class="project-dialog-close" aria-label="Close <%= project.data.title %>">×</button>
            </form>

            <h2 class="project-dialog-title" id="<%= dialog_id %>-title"><%= project.data.title %></h2>

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

            <% if body_html.present? %>
              <div class="project-dialog-body">
                <%= body_html %>
              </div>
            <% end %>

            <% if visit_href.present? %>
              <p class="project-dialog-visit">
                <a href="<%= visit_href %>"<% if visit_target %> target="<%= visit_target %>"<% end %><% if visit_rel %> rel="<%= visit_rel %>"<% end %>>Visit project</a>
              </p>
            <% end %>
          </div>
        </dialog>
      <% end %>
    </article>
  <% end %>
</div>
