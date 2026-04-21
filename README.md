# Rory Gianni's Digital Garden

Rory Gianni's digital garden / personal site. The plan is to use markdown and obsidian to write and publish my thoughts and ideas.

Built with [Bridgetown](https://www.bridgetownrb.com), a Ruby-powered static site generator.

## Development

To start your site in development mode, run:

```sh
bin/bridgetown start
```

Then navigate to [localhost:4000](http://localhost:4000/)!

### Commands

```sh
# sync garden from obsidian
bin/sync-garden

# running locally
bin/bridgetown start

# build & deploy to production
bin/bridgetown deploy

# load the site up within a Ruby console (IRB)
bin/bridgetown console
```

> Learn more: [Bridgetown CLI Documentation](https://www.bridgetownrb.com/docs/command-line-usage)

## Content Management

### Working with Markdown

**Location**: Markdown files can be placed in:
- `src/` - For regular pages (e.g., `src/about.md`, `src/index.md`)
- `src/_posts/` - For blog posts (must follow naming: `YYYY-MM-DD-title.md`)

**Workflow for Markdown Pages**:
1. Create a new `.md` file in `src/` (e.g., `src/my-page.md`)
2. Add front matter at the top:
   ```markdown
   ---
   layout: page
   title: My Page Title
   ---
   
   Your markdown content here...
   ```
3. The file will be automatically processed and available at `/my-page/`

### Working with HTML

**Location**: HTML files can be placed directly in `src/` (e.g., `src/custom-page.html`)

**Workflow for HTML Pages**:
1. Create a new `.html` file in `src/` (e.g., `src/custom-page.html`)
2. Add front matter at the top (optional, for layout):
   ```html
   ---
   layout: default
   title: Custom Page
   ---
   
   <h1>My Custom HTML Page</h1>
   <p>You can write pure HTML here...</p>
   ```
3. Or write pure HTML without front matter - it will be copied as-is to the output
4. The file will be available at `/custom-page.html`

### Working with Assets (Images, Files, etc.)

**Location**: Assets should be placed in `src/` directory structure:
- `src/images/` - For images (recommended)
- `src/` - For any other static files (PDFs, documents, etc.)

**Workflow for Images**:
1. Add images to `src/images/` (or create subdirectories like `src/images/photos/`)
2. Reference images in your markdown:
   ```markdown
   ![Alt text](/images/my-image.jpg)
   ```
3. Or in HTML:
   ```html
   <img src="/images/my-image.jpg" alt="Description">
   ```
4. Images are automatically copied to the output directory during build

**Workflow for Other Static Files**:
1. Place files in `src/` (e.g., `src/documents/my-file.pdf`)
2. Link to them in your content:
   ```markdown
   [Download PDF](/documents/my-file.pdf)
   ```
3. Files are automatically copied to the output directory

### Content Organization Tips

- **Organize by topic**: Create subdirectories in `src/` for different content types
- **Use collections**: Set up custom collections in `bridgetown.config.yml` for specialized content types
- **Front matter**: Use front matter to add metadata, custom layouts, and permalinks
- **Obsidian compatibility**: Markdown files can be written in Obsidian and synced to `src/` or `src/_posts/`

### Garden Sync from Obsidian

The site includes a dedicated `garden` section and a sync command for selected notes from your Obsidian vault.

**Default paths**:
- Source vault: `~/obsidian-main`
- Include rules: `.garden-include`
- Destination: `src/garden/`

Run:

```sh
bin/sync-garden
```

Useful options:

```sh
bin/sync-garden --dry-run
bin/sync-garden --verbose
bin/sync-garden --source ~/obsidian-main --rules .garden-include
```

`bin/sync-garden` reads gitignore-style patterns from `.garden-include`:
- regular lines are **includes**
- lines beginning with `!` are **excludes**
- blank lines and `# comments` are ignored

After syncing (non-dry-run), the command also:

- runs [`bin/_garden_markdown_transform.rb`](bin/_garden_markdown_transform.rb) (Ruby, via `bundle exec ruby`) to adjust Obsidian syntax in note bodies (skips `**/index.md`):
  - image embeds `![[path/to/file]]` → Markdown `![](…)` (relative to the note when the file exists)
  - wikilinks `[[Note]]`, `[[folder/Note]]`, `[[Note|label]]`, `[[Note#Heading]]`, and block refs `[[Note#^id]]` → Markdown links using **root-relative URLs** under [`base_path`](config/initializers.rb), then the **basename of the sync folder** (e.g. `src/garden` → `/rgianni-site/garden/Drafts/My%20Note/`) so they work from any page depth; heading → `#slug`; duplicate titles warn and pick a deterministic file; unresolved links stay as `[[…]]` with a warning
- `bin/sync-garden` parses `base_path` from `config/initializers.rb` for those URLs. Override with **`GARDEN_SITE_BASE_PATH`** if needed. Override the path segment with **`GARDEN_URL_SEGMENT`** if the published URL prefix differs from the folder name. If you ever switch pages to file-style output (`.html` instead of trailing `/`), set **`GARDEN_PAGE_URL_SUFFIX=.html`** for wikilink targets.
- adds minimal front matter to synced markdown files that do not already start with YAML (skips `**/index.md`): `layout: obsidian`, `title` (humanized from the `.md` basename), and **`filename`** (a **normalized** slug of that basename: lowercase, runs of non-alphanumeric characters become a single hyphen, e.g. `First question.md` → `first-question.md`). Files that already begin with `---` are left unchanged, so they will not gain `filename` until you add it yourself or strip front matter and re-sync.
- **Breadcrumbs:** pages under `src/garden/` (and `src/garden.md`) show a trail above the content, e.g. `home / garden / Drafts / my-note.md`, with ` / ` between parts. Folder `index.md` pages end on the folder title (e.g. `Drafts`); notes end on `filename` from front matter, or the same normalized slug from the source basename if `filename` is missing.
- writes `src/garden/<Folder>/index.md` for each top-level folder under `src/garden/`, listing **all** `.md` notes under that folder **recursively** (excluding only that folder’s `index.md`), with relative links like `./Sub/My%20Note/`
- updates the `<!-- BEGIN:GARDEN_LINKS -->` block in `src/garden.md` with **folder** links (`./garden/<Folder>/`), plus an optional **Root notes** subsection for `.md` files sitting directly under `src/garden/`

**Permalinks (Bridgetown):** the top-level `permalink` setting applies to **posts**. The **pages** collection (including `src/garden/`) defaults to directory-style URLs (`/:locale/:path/`). Using `collections pages: { permalink: "/:locale/:path.*" }` flattens many routes (e.g. `garden.html` instead of `garden/index.html`); this project keeps the default pages permalink and relies on base-path wikilinks instead. See [Permalinks | Bridgetown](https://www.bridgetownrb.com/docs/content/permalinks).

Typical workflow:

1. Update `.garden-include`
2. Run `bin/sync-garden`
3. Review changes in `src/garden/`, per-folder `index.md` files, and `src/garden.md`
4. Commit synced markdown/assets as source content

Bridgetown then converts markdown to HTML at build time and publishes `output/` during deploy.

## Deployment

This site is deployed to [GitHub Pages](https://digitalwestie.github.io/rgianni-site/) using GitHub Actions.

### Automated Deployment

The site automatically builds and deploys when you push to the `deploy` branch. The GitHub Actions workflow (`.github/workflows/deploy.yml`) handles:

1. Building the site with Ruby and Node.js
2. Running `bundle exec rake deploy`
3. Deploying the `output` folder to GitHub Pages

### Manual Deployment

To build the site locally:

```sh
bundle exec rake deploy
```

This will create the static site in the `output/` directory.

### Other Deployment Options

You can also deploy Bridgetown sites on hosts like Render or Vercel as well as traditional web servers by simply building and copying the output folder to your HTML root.

> Read the [Bridgetown Deployment Documentation](https://www.bridgetownrb.com/docs/deployment) for more information.
