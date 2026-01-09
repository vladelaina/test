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

## VitePress Configuration

- [ ] Use `ignoreDeadLinks: true` to prevent build failures on broken/dead links
- [ ] VitePress does NOT auto-generate sidebar - need custom script or manual config
- [ ] `sidebar: 'auto'` does NOT work like Docusaurus - only shows current page headings
- [ ] Output directory is `.vitepress/dist` (not `build`)
- [ ] Use `srcDir: 'docs'` to specify source directory
- [ ] Exclude `node_modules` in content backup

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

## Multi-Language Support

- [ ] VitePress/Docusaurus i18n is static - requires manual translation files
- [ ] No automatic translation built-in
- [ ] Options: browser translation, or integrate translation API (costs money)
- [ ] Structure: `docs/en/`, `docs/zh/` etc. for each language
