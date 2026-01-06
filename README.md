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

## Deployment

You can deploy Bridgetown sites on hosts like Render or Vercel as well as traditional web servers by simply building and copying the output folder to your HTML root.

> Read the [Bridgetown Deployment Documentation](https://www.bridgetownrb.com/docs/deployment) for more information.
