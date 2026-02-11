---
name: obsidian
description: "Personal Knowledge Management with Obsidian. Use for note-taking, knowledge graphs, task management, and building a second brain."
metadata:
  {
    "openclaw":
      {
        "emoji": "🧠",
        "requires": {},
        "install": [],
      },
  }
---

# Obsidian Skill

Personal Knowledge Management with Obsidian for note-taking, building knowledge graphs, and creating a second brain.

## When to Use

- Taking notes
- Building a knowledge base
- Managing tasks and projects
- Creating documentation
- Building a second brain

## Core Concepts

### Notes as Files

Obsidian stores notes as plain Markdown files:

```markdown
---
tags: [project, ai]
date: 2024-01-15
---

# AI Project Notes

## Ideas

- [[Machine Learning]] integration
- Natural language processing
- Computer vision

## Resources

- [OpenAI Documentation](https://platform.openai.com)
- [Hugging Face](https://huggingface.co)

## Tasks

- [ ] Research models
- [ ] Build prototype
- [ ] Test with users
```

### Links

Create connections between notes:

```markdown
[[Another Note]]
[[Another Note|Display Text]]
[[Another Note#Section]]
```

### Tags

Organize with tags:

```markdown
#project #ai #research
```

## Folder Structure

```
📁 Vault/
├── 📁 00 Inbox/          # Quick capture
├── 📁 01 Projects/       # Active projects
├── 📁 02 Areas/          # Ongoing areas
├── 📁 03 Resources/      # Reference material
├── 📁 04 Archives/       # Completed items
├── 📁 Templates/         # Note templates
└── 📄 README.md          # Vault overview
```

## Templates

### Project Template

```markdown
---
tags: [project]
created: {{date}}
status: active
---

# {{title}}

## Overview

Brief description of the project.

## Goals

- Goal 1
- Goal 2

## Tasks

- [ ] Task 1
- [ ] Task 2

## Notes

### {{date}}

Initial notes...

## Resources

- [[Related Note]]
- [External Link](url)
```

### Daily Note Template

```markdown
---
tags: [daily]
date: {{date}}
---

# {{date}}

## Morning

- 

## Afternoon

- 

## Evening

- 

## Notes

- 

## Tasks Created

- [ ] 
```

## Plugins

### Essential Plugins

1. **Dataview**: Query notes like a database
2. **Templater**: Advanced templates
3. **Git**: Version control
4. **Kanban**: Visual task boards
5. **Excalidraw**: Diagrams

### Dataview Examples

```dataview
TABLE file.mtime AS "Modified"
FROM #project
WHERE status = "active"
SORT file.mtime DESC
```

```dataview
TASK
FROM #project
WHERE !completed
GROUP BY file.name
```

## Workflows

### Zettelkasten Method

1. **Fleeting Notes**: Quick capture
2. **Literature Notes**: Process sources
3. **Permanent Notes**: Create atomic ideas
4. **Structure Notes**: Index and connect

### PARA Method

- **Projects**: Active with deadline
- **Areas**: Ongoing responsibilities
- **Resources**: Reference material
- **Archives**: Completed/inactive

## Best Practices

1. **Atomic Notes**: One idea per note
2. **Clear Titles**: Make them searchable
3. **Link Liberally**: Connect related concepts
4. **Regular Review**: Process inbox weekly
5. **Back Up**: Sync with Git or cloud
6. **Consistent Tags**: Use standardized tags
7. **Daily Notes**: Capture thoughts daily

## Sync Options

- **Obsidian Sync**: Official paid sync
- **Git**: Free, version controlled
- **iCloud/Dropbox**: Simple file sync
- **Self-hosted**: Nextcloud, Syncthing

## Mobile Usage

- Quick capture to inbox
- Review daily notes
- Check task lists
- Read reference material

## Integration

- Import from Notion, Evernote, Roam
- Export to PDF, HTML
- Publish to web (Obsidian Publish)
- API for automation
