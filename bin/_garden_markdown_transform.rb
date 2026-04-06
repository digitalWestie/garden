#!/usr/bin/env ruby
# frozen_string_literal: true

# Converts Obsidian image embeds ![[path]] to Markdown ![](relative_path).
# Skips index.md files. Respects YAML front matter when present.

require "pathname"

garden_root = File.expand_path(ARGV[0] || abort("usage: _garden_markdown_transform.rb GARDEN_DIR"))

EMBED_RE = /!\[\[([^\]]+)\]\]/

def split_front_matter(text)
  return [nil, text] unless text.start_with?("---\n")

  idx = text.index("\n---\n", 4)
  return [nil, text] unless idx

  fm_block = text[0...(idx + 5)]
  body = text[(idx + 5)..]
  [fm_block, body]
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

def transform_body(body, note_path, garden_root)
  body.gsub(EMBED_RE) do
    rel = rel_path_for_embed(note_path, garden_root, Regexp.last_match(1))
    "![](#{rel})"
  end
end

def process_file(path, garden_root)
  return false if File.basename(path) == "index.md"

  content = File.read(path, encoding: "UTF-8")
  fm, body = split_front_matter(content)
  new_body = transform_body(body, path, garden_root)
  return false if new_body == body

  File.write(path, "#{fm}#{new_body}", encoding: "UTF-8")
  true
end

changed = 0
Dir.glob(File.join(garden_root, "**", "*.md")).sort.each do |path|
  changed += 1 if process_file(path, garden_root)
end

warn "Obsidian embed conversion: #{changed} file(s) updated."
