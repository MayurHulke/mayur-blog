# Writing Blog Posts for Mayur's Blog

This guide will help you quickly create and publish blog posts for your Hugo-based blog.

## Creating a New Post

### Method 1: Using the script (recommended)

Run the following command from the terminal:

```bash
./new-post.sh "Your Post Title"
```

This will:
1. Create a new Markdown file with the correct frontmatter
2. Convert your title to a URL-friendly slug
3. Place the file in the correct location

### Method 2: Manual Hugo command

```bash
hugo new posts/your-post-slug.md
```

## Post Frontmatter

Each post begins with YAML frontmatter that looks like this:

```yaml
---
title: "Your Post Title"
date: 2023-11-27T15:30:45-08:00
tags: ["tag1", "tag2"]
draft: true
description: "A brief description of your post"
ShowReadingTime: true
---
```

Important fields:
- **title**: The title of your post
- **date**: Automatically filled, but you can adjust it
- **tags**: Add relevant tags (make them specific and consistent)
- **draft**: Set to `false` when ready to publish
- **description**: A brief summary that appears in previews

## Writing Content

Write your content in Markdown below the frontmatter. Common formatting:

### Headers

```markdown
## Second-level heading
### Third-level heading
```

### Text formatting

```markdown
**Bold text**
*Italic text*
~~Strikethrough~~
```

### Links

```markdown
[Link text](https://example.com)
```

### Images

```markdown
![Alt text](/images/your-image.png)
```

Place images in the `static/images/` directory.

### Code blocks

````markdown
```python
def hello_world():
    print("Hello, world!")
```
````

### Math equations

```markdown
Inline math: $E = mc^2$

Block math:
$$
f(x) = \int_{-\infty}^{\infty} \hat{f}(\xi) e^{2\pi i \xi x} d\xi
$$
```

## Previewing Your Post

```bash
hugo server -D
```

This runs a local server with draft posts included. Visit http://localhost:1313/ to see your site.

## Publishing

1. Set `draft: false` in the frontmatter
2. Commit and push your changes to GitHub
3. The GitHub Actions workflow will automatically build and deploy your site

## Tips for Better Posts

1. Use descriptive titles
2. Add relevant tags to make posts discoverable
3. Include a clear introduction and conclusion
4. Break long content into sections with headers
5. Use images to illustrate concepts
6. Preview your post locally before publishing
7. Run a spellcheck before committing 