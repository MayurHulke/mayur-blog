#!/bin/bash

# Script to create a new blog post

# Check if a title is provided
if [ $# -eq 0 ]; then
  echo "Error: Please provide a post title"
  echo "Usage: ./new-post.sh \"Your Post Title\""
  exit 1
fi

# Convert title to slug
slug=$(echo "$1" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')

# Create post with hugo
hugo new "posts/$slug.md"

# Open the file in the default editor (optional)
# Uncomment the line below to automatically open the file
# open "content/posts/$slug.md"

echo "Post created at content/posts/$slug.md"
echo "To preview: hugo server -D"
echo "To publish: set draft: false in the frontmatter" 