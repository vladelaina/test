# Docship Theme Development Checklist

## Markdown Compatibility

- [ ] Use `markdown.format: 'md'` instead of MDX to avoid JSX parsing errors (Docusaurus)
  - Users may have `${}`, `<>`, `{}` in their markdown content
  - MDX will treat these as JSX expressions and fail
- [ ] VitePress is more lenient with `${}` but `{{ }}` will be treated as Vue template
- [ ] Don't restrict filenames - users can use any name like `temp.md`
- [ ] Handle files with special characters in content gracefully

## Docusaurus Configuration

- [ ] Don't use `navbar.logo` without `logo.src` - it will throw validation error
- [ ] Remove `sidebarPath` to let Docusaurus auto-generate sidebar from file structure
- [ ] Use `onBrokenLinks: 'ignore'` to prevent build failures on broken links
- [ ] Use `markdown.hooks.onBrokenMarkdownLinks: 'ignore'` (new location in v3.9+)
- [ ] Don't include deprecated options like root-level `onBrokenMarkdownLinks`
- [ ] For local search, use `@easyops-cn/docusaurus-search-local` (no API key needed)
- [ ] Algolia search requires API key - not suitable for generic themes

## VitePress Configuration

- [ ] Use `ignoreDeadLinks: true` to prevent build failures on broken/dead links
- [ ] VitePress does NOT auto-generate sidebar - need custom script or manual config
- [ ] `sidebar: 'auto'` does NOT work like Docusaurus - only shows current page headings
- [ ] Output directory is `.vitepress/dist` (not `build`)
- [ ] Use `srcDir: 'docs'` to specify source directory
- [ ] Exclude `node_modules` in content backup
- [ ] For local search, use `search: { provider: 'local' }` (built-in)
- [ ] `logo.link` does NOT support external URLs - need custom theme to override

## Sidebar Generation (VitePress)

- [ ] Write custom Node.js script to scan directory and generate sidebar config
- [ ] Sort entries: files first, then directories (or vice versa for consistency)
- [ ] Skip files starting with `.` or `_`
- [ ] Skip `index.md` from sidebar items (it's the folder landing page)
- [ ] Capitalize first letter and replace `-` with spaces for display text

## Homepage Selection Logic

Priority order:
1. `docs/index.md` or `content/index.md` - explicit homepage
2. `docs/README.md` or `content/README.md` - common convention
3. First `.md` file (sorted alphabetically) - fallback

- [ ] Always use `sort` before `head -1` for consistent results
- [ ] For Docusaurus: check if `slug: /` already exists before adding frontmatter
- [ ] For VitePress: `index.md` is automatically the homepage, no frontmatter needed

## GitHub Actions / Reusable Workflows

- [ ] Reusable workflows MUST be in `.github/workflows/` directory
- [ ] Use `on: workflow_call` for workflows that should only be called by others
- [ ] Caller workflow must declare `permissions` for the called workflow to use
- [ ] Remove `push` and `workflow_dispatch` triggers if workflow should not run directly

## Content Backup

- [ ] Exclude `README.md` from root (usually not documentation)
- [ ] Exclude hidden directories (`.git`, `.github`, etc.)
- [ ] Exclude `node_modules` directory
- [ ] Copy all user folders to preserve structure
- [ ] Handle empty content directory - create default welcome page

## Build & Deploy

- [ ] GitHub Pages keeps old version online during build (atomic deployment)
- [ ] First deployment shows blank page until complete - this is normal
- [ ] Public repos have unlimited GitHub Actions minutes
- [ ] Add npm cache to speed up builds: `actions/cache@v4` with `~/.npm` path

## Shell Script Best Practices (GitHub Actions)

- [ ] Don't use `sed -i '1s/^/...\n.../'` - `\n` may not work on all systems
- [ ] Don't use heredoc (`<< EOF`) inside YAML `run:` blocks - causes syntax errors
- [ ] Use `printf '%s\n' 'line1' 'line2'` for multi-line content
- [ ] Use temp files + `cat` + `mv` to prepend content to files
- [ ] Always quote variables: `"$TARGET"` not `$TARGET`

## Logo & Branding

- [ ] Use `https://github.com/USERNAME.png` to get user/org avatar
- [ ] VitePress: need custom theme (`enhanceApp`) to make logo link to external URL
- [ ] Docusaurus: `logo.href` + `logo.target: '_blank'` works for external links
- [ ] Set favicon with `head: [['link', { rel: 'icon', href: '...' }]]` (VitePress)
- [ ] Docusaurus favicon can be external URL directly

## Testing Scenarios

Before releasing a theme, test with:
- [ ] Empty repository (no markdown files)
- [ ] Single markdown file
- [ ] Nested folder structure
- [ ] Files with `${}` syntax in content
- [ ] Files with JSX-like syntax `<Component />`
- [ ] Files with curly braces `{}`
- [ ] Files with `{{ }}` Vue template syntax (VitePress specific)
- [ ] Unicode/special characters in filenames
- [ ] Very long filenames
- [ ] Files starting with `_` (usually ignored by default)
- [ ] Files containing `localhost` URLs (dead link check)
- [ ] Repository without `index.md` (homepage fallback logic)

## Starlight (Astro) Configuration

- [ ] Use `npm create astro@latest -- --template starlight` for correct project structure
- [ ] Starlight v0.33.0+ changed `social` config from object to array format
  - Old: `social: { github: 'url' }`
  - New: `social: [{ icon: 'github', label: 'GitHub', href: 'url' }]`
- [ ] Every `.md` file MUST have `title` in frontmatter - Starlight will fail without it
- [ ] Sidebar `slug` must be lowercase - uppercase will cause "slug does not exist" error
- [ ] `autogenerate: { directory: '.' }` doesn't work well - use specific directory names
- [ ] Content goes in `src/content/docs/` directory
- [ ] Output directory is `dist`
- [ ] Use `.mdx` extension for index file if needed

## Rspress Configuration

- [ ] Public assets go in `docs/public/` (not project root `public/`)
- [ ] Sidebar `items` must be an array, not `'auto'` string
- [ ] Output directory is `doc_build`
- [ ] Exclude `public` directory from sidebar generation
- [ ] Config file is `rspress.config.ts` (TypeScript)

## Common Errors & Solutions

| Error | Cause | Solution |
|-------|-------|----------|
| `navbar.logo.src is required` | Using `logo` without `src` | Remove `logo` or add `src` |
| `Could not parse expression with acorn` | MDX parsing `${}` as JSX | Use `markdown.format: 'md'` |
| `workflow is not reusable` | Missing `workflow_call` trigger | Add `on: workflow_call` |
| `requesting pages: write but only allowed none` | Caller missing permissions | Add `permissions` to caller |
| `onBrokenMarkdownLinks deprecated` | Old config location | Move to `markdown.hooks` |
| `Found dead link` (VitePress) | Broken links in markdown | Use `ignoreDeadLinks: true` |
| `sidebar: 'auto' not working` | VitePress doesn't auto-generate | Write custom sidebar script |
| `Page Not Found` on homepage | Missing `slug: /` frontmatter | Add frontmatter to first doc |
| `here-document delimited by end-of-file` | Heredoc in YAML run block | Use `printf` instead |
| `social: Expected array, received object` | Starlight v0.33.0+ API change | Use array format for social links |
| `title: Required` (Starlight) | Missing frontmatter title | Auto-add title from filename |
| `slug does not exist` (Starlight) | Uppercase slug in sidebar | Convert slug to lowercase |
| `Entry docs → 404 was not found` | No valid index page | Ensure index.md/mdx exists with frontmatter |
| `item.items.map is not a function` | Rspress sidebar `items: 'auto'` | Use array of items, not string |
| `Failed to read favicon` (Rspress) | Wrong public directory path | Put assets in `docs/public/` |

## Multi-Language Support

- [ ] VitePress/Docusaurus i18n is static - requires manual translation files
- [ ] No automatic translation built-in
- [ ] Options: browser translation, or integrate translation API (costs money)
- [ ] Structure: `docs/en/`, `docs/zh/` etc. for each language
