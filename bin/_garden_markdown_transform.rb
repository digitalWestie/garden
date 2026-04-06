#!/usr/bin/env ruby
# frozen_string_literal: true

# Transforms Obsidian syntax in garden markdown (body only; YAML front matter preserved):
# - ![[path]] image embeds -> Markdown ![](relative_path)
# - [[note]] wikilinks -> Markdown [label](ABSOLUTE_PATH_UNDER_BASE_PATH)
#
# Wikilink targets use site base_path + /{basename(GARDEN_DIR)}/... (URL-encoded) so links work
# from any page depth. Matches Bridgetown output under src/<name>/.
# Override base path: ENV["GARDEN_SITE_BASE_PATH"] or second CLI arg (default: /rgianni-site).
# Page URL suffix: ENV["GARDEN_PAGE_URL_SUFFIX"] (default "/" for directory-style pretty URLs).
# URL segment after base_path: basename of GARDEN_DIR, or ENV["GARDEN_URL_SEGMENT"].
#
# Skips index.md. Unresolved wikilinks are left unchanged (warning to stderr).

require "pathname"

garden_root = File.expand_path(ARGV[0] || abort("usage: _garden_markdown_transform.rb GARDEN_DIR [BASE_PATH]"))

# Published URL segment under src/ (e.g. .../src/garden -> "garden"). Override with GARDEN_URL_SEGMENT.
url_path_segment =
  if ENV.key?("GARDEN_URL_SEGMENT") && !ENV["GARDEN_URL_SEGMENT"].to_s.strip.empty?
    ENV["GARDEN_URL_SEGMENT"].strip
  else
    File.basename(garden_root)
  end
url_path_segment_encoded = url_path_segment.gsub(" ", "%20")

base_path =
  if ENV.key?("GARDEN_SITE_BASE_PATH")
    ENV["GARDEN_SITE_BASE_PATH"].to_s
  elsif ARGV[1] && !ARGV[1].strip.empty?
    ARGV[1].strip
  else
    "/rgianni-site"
  end

page_suffix = ENV.fetch("GARDEN_PAGE_URL_SUFFIX", "/")

module GardenMarkdownTransform
  EMBED_RE = /!\[\[([^\]]+)\]\]/
  WIKILINK_RE = /(?<!!)\[\[([^\]]+)\]\]/

  module_function

  def split_front_matter(text)
    return [nil, text] unless text.start_with?("---\n")

    idx = text.index("\n---\n", 4)
    return [nil, text] unless idx

    fm_block = text[0...(idx + 5)]
    body = text[(idx + 5)..]
    [fm_block, body]
  end

  def build_note_index(root)
    by_rel = {}
    by_base = Hash.new { |h, k| h[k] = [] }

    Dir.glob(File.join(root, "**", "*.md")).each do |abs|
      next unless File.file?(abs)
      next if File.basename(abs) == "index.md"

      rel = Pathname.new(abs).relative_path_from(Pathname.new(root)).to_s.tr("\\", "/")
      rel_no_ext = rel.sub(/\.md\z/i, "")
      by_rel[rel_no_ext] = abs
      by_base[File.basename(abs, ".md")] << abs
    end

    [by_rel, by_base]
  end

  def rel_path_for_embed(note_path, garden_root, inner)
    inner = inner.split("|", 2).first.strip.tr("\\", "/").sub(%r{\A/}, "")
    target = File.join(garden_root, inner)
    if File.file?(target)
      note_dir = File.dirname(note_path)
      Pathname.new(target).relative_path_from(Pathname.new(note_dir)).cleanpath.to_s.tr("\\", "/")
    else
      inner
    end
  end

  def resolve_target_path(path_part, garden_root, by_rel, by_base)
    path_part = path_part.strip.tr("\\", "/")
    return nil if path_part.empty?

    direct = File.join(garden_root, "#{path_part}.md")
    return direct if File.file?(direct)

    return by_rel[path_part] if by_rel.key?(path_part)

    matches = by_base[path_part] || []
    case matches.size
    when 1
      matches.first
    when 0
      all = by_base.values.flatten.uniq
      ci = all.select { |p| File.basename(p, ".md").casecmp?(path_part) }
      case ci.size
      when 1
        ci.first
      when 0
        warn "Wikilink unresolved: [[#{path_part}]]"
        nil
      else
        chosen = ci.sort.first
        warn "Wikilink ambiguous (case-insensitive) '#{path_part}': #{ci.size} matches, using #{chosen}"
        chosen
      end
    else
      chosen = matches.sort.first
      warn "Wikilink ambiguous '#{path_part}': #{matches.size} matches, using #{chosen}"
      chosen
    end
  end

  def slug_heading(text)
    text.downcase.gsub(/[^\p{L}\p{N}\s-]/u, "").gsub(/\s+/, "-").gsub(/-+/, "-").delete_prefix("-").delete_suffix("-")
  end

  def build_fragment(fragment_raw)
    return "" if fragment_raw.nil? || fragment_raw.strip.empty?

    frag = fragment_raw.strip
    return "##{frag}" if frag.start_with?("^")

    "##{slug_heading(frag)}"
  end

  # Directory-style: suffix "/" -> /base/<segment>/foo/bar/ ; file-style: .html on leaf
  def absolute_href_for_wikilink(base_path, target_abs, garden_root, fragment, page_suffix, segment_encoded)
    rel = Pathname.new(target_abs).relative_path_from(Pathname.new(garden_root)).to_s.tr("\\", "/").sub(/\.md\z/i, "")
    encoded = rel.split("/").map { |s| s.gsub(" ", "%20") }.join("/")

    bp = base_path.to_s.sub(%r{\A/}, "").chomp("/")
    sfx = page_suffix.to_s

    core =
      if bp.empty?
        "/#{segment_encoded}/#{encoded}#{sfx}"
      else
        "/#{bp}/#{segment_encoded}/#{encoded}#{sfx}"
      end
    core.gsub!(%r{//+}, "/")
    "#{core}#{fragment}"
  end

  def default_wikilink_label(path_part)
    path_part.split("/").last.tr("_", " ")
  end

  def transform_wikilink(inner, garden_root, by_rel, by_base, base_path, page_suffix, segment_encoded)
    link_inner = inner.split("|", 2)
    target_spec = link_inner[0].strip
    label_override = link_inner[1]&.strip

    path_part, frag_raw = target_spec.split("#", 2)
    target_abs = resolve_target_path(path_part, garden_root, by_rel, by_base)
    return nil if target_abs.nil?

    fragment = build_fragment(frag_raw)
    href = absolute_href_for_wikilink(base_path, target_abs, garden_root, fragment, page_suffix, segment_encoded)
    label =
      if label_override && !label_override.strip.empty?
        label_override.strip
      else
        default_wikilink_label(path_part)
      end
    "[#{label}](#{href})"
  end

  def transform_body(body, note_path, garden_root, by_rel, by_base, base_path, page_suffix, segment_encoded)
    out = body.gsub(EMBED_RE) do
      inner = Regexp.last_match(1)
      rel = rel_path_for_embed(note_path, garden_root, inner)
      "![](#{rel})"
    end

    out.gsub(WIKILINK_RE) do
      inner = Regexp.last_match(1)
      replacement = transform_wikilink(inner, garden_root, by_rel, by_base, base_path, page_suffix, segment_encoded)
      replacement || Regexp.last_match(0)
    end
  end
end

by_rel, by_base = GardenMarkdownTransform.build_note_index(garden_root)

changed = 0
Dir.glob(File.join(garden_root, "**", "*.md")).sort.each do |path|
  next if File.basename(path) == "index.md"

  content = File.read(path, encoding: "UTF-8")
  fm, body = GardenMarkdownTransform.split_front_matter(content)
  new_body = GardenMarkdownTransform.transform_body(
    body, path, garden_root, by_rel, by_base, base_path, page_suffix, url_path_segment_encoded
  )
  next if new_body == body

  File.write(path, "#{fm}#{new_body}", encoding: "UTF-8")
  changed += 1
end

warn "Garden markdown transform: #{changed} file(s) updated."
