# frozen_string_literal: true

require "cgi"

class Shared::GardenBreadcrumb < Bridgetown::Component
  def initialize(resource:)
    @resource = resource
  end

  def render?
    garden_resource?
  end

  def crumbs
    @crumbs ||= build_crumbs
  end

  private

  def garden_resource?
    rp = @resource.relative_path.to_s.tr("\\", "/")
    rp == "garden.md" || rp.start_with?("garden/")
  end

  def garden_hub?
    @resource.relative_path.to_s.tr("\\", "/") == "garden.md"
  end

  def folder_index?
    rp = @resource.relative_path
    rp.basename.to_s == "index.md" && rp.to_s.tr("\\", "/").start_with?("garden/")
  end

  def url_segments
    url = @resource.relative_url.to_s.chomp("/")
    base = @resource.site.base_path.to_s.chomp("/")
    rest =
      if base.empty?
        url
      else
        url.delete_prefix(base)
      end
    rest = rest.sub(%r{\A/+}, "")
    rest.split("/").reject(&:empty?).map { |s| CGI.unescape(s) }
  end

  def humanize_segment(name)
    name.tr("_", " ").tr("-", " ")
  end

  def leaf_label(_segments)
    if garden_hub?
      @resource.data.title.to_s.presence || "Garden"
    elsif folder_index?
      @resource.data.title.to_s.presence ||
        humanize_segment(@resource.relative_path.dirname.basename.to_s)
    else
      fn = @resource.data[:filename] || @resource.data["filename"]
      fn.to_s.presence || normalized_filename_from_stem(@resource.relative_path.basename(".*").to_s)
    end
  end

  # Matches bin/sync-garden slug for generated `filename` when front matter omits it.
  def normalized_filename_from_stem(stem)
    s = stem.downcase.gsub(/[^a-z0-9]+/, "-").delete_prefix("-").delete_suffix("-").squeeze("-")
    s = "note" if s.empty?
    "#{s}.md"
  end

  def build_crumbs
    segs = url_segments
    return [] if segs.empty?

    items = [{ label: "home", href: "/", current: false }]

    # Linked ancestors: all but the last URL segment
    (0...(segs.length - 1)).each do |i|
      prefix = "/#{segs[0..i].join("/")}/"
      items << { label: segs[i], href: prefix, current: false }
    end

    items << { label: leaf_label(segs), href: nil, current: true }
    items
  end
end
