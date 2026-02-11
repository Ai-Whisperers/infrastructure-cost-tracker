# Coordinating Repository Structure

> **Purpose:** Complete guide for structuring the AI startup's coordinating repository that enables AI to manage projects, generate tickets, and track work

## Table of Contents

1. [Overview](#overview)
2. [Repository Structure](#repository-structure)
3. [File Descriptions](#file-descriptions)
4. [AI Workflow](#ai-workflow)
5. [Idea Management](#idea-management)
6. [Ticket System](#ticket-system)
7. [Knowledge Base](#knowledge-base)
8. [CI/CD Integration](#cicd-integration)
9. [Setup Instructions](#setup-instructions)

---

## 1. Overview

### Purpose

The coordinating repository ("brain") serves as:
- **Single source of truth** for all projects
- **AI instruction manual** for how the company works
- **Idea catalog** with synergy detection
- **Ticket generation** source for all work
- **Knowledge base** for AI context

### Design Principles

1. **AI-First:** All structure designed for AI understanding
2. **Human-Readable:** Markdown for all documentation
3. **Machine-Processable:** JSON/YAML for data
4. **Git-Based:** Version controlled, collaborative
5. **Searchable:** Clear structure, semantic naming

---

## 2. Repository Structure

```
ai-startup-coordination/
├── 📄 README.md                          # Company overview, AI instructions
├── 📄 BUSINESS_PLAN.md                   # Living business plan
├── 📄 ORCHESTRATION.md                   # AI coordination rules
├── 📄 ROADMAP.md                         # Company roadmap
│
├── 📁 projects/                          # All projects
│   ├── project-alpha/
│   │   ├── README.md
│   │   ├── user-stories/
│   │   │   ├── epic-001.md
│   │   │   ├── story-001.md
│   │   │   └── task-001.md
│   │   ├── specs/
│   │   ├── code/
│   │   └── docs/
│   │
│   ├── project-beta/
│   │   └── ...
│   │
│   └── project-gamma/
│       └── ...
│
├── 📁 ideas/                             # Idea catalog
│   ├── ideas.json                       # All ideas in structured format
│   ├── ideas.yaml
│   ├── categorized/
│   │   ├── product-ideas/
│   │   ├── marketing-ideas/
│   │   ├── technical-ideas/
│   │   └── business-ideas/
│   ├── synergies/
│   └── backlog/
│
├── 📁 knowledge/                         # Knowledge base
│   ├── company-policies/
│   ├── technical-docs/
│   ├── market-research/
│   └── competitors/
│
├── 📁 tickets/                           # All tickets
│   ├── active/
│   ├── ready/
│   ├── in-progress/
│   └── done/
│
├── 📁 docs/                              # Documentation
│   ├── architecture/
│   ├── processes/
│   └── onboarding/
│
├── 📁 scripts/                           # Utility scripts
│   ├── generate-ticket.sh
│   ├── analyze-idea.sh
│   └── sync-linear.sh
│
├── 📁 .ai/                              # AI-specific configuration
│   ├── system-prompt.md
│   ├── agent-configs/
│   └── prompts/
│
├── 📁 .github/
│   ├── workflows/
│   └── ISSUE_TEMPLATE/
│
├── 📁 config/                           # Configuration files
│   ├── linear.yaml
│   ├── qdrant.yaml
│   └── openrouter.yaml
│
├── 📄 .gitignore
├── 📄 .gitattributes
├── 📄 docker-compose.yml
├── 📄 package.json
└── 📄 turbo.json
```

---

## 3. File Descriptions

### Root Files

#### README.md

```markdown
# Company Name

> One-line company description

## Our Mission

Brief mission statement

## Our Values

1. **AI-First** - AI does the heavy lifting
2. **Human Oversight** - Humans guide and review
3. **Transparency** - Open communication
4. **Continuous Learning** - Always improving

## Quick Links

- [Business Plan](./BUSINESS_PLAN.md)
- [Roadmap](./ROADMAP.md)
- [Projects](./projects/)
- [Ideas](./ideas/)
- [Knowledge Base](./knowledge/)

## AI Instructions

> For AI agents working with this repository

### Your Role

You are an AI assistant helping this company build products. Your responsibilities:
1. Generate user stories and tasks from requirements
2. Write clean, tested code
3. Research and analyze markets
4. Suggest improvements and synergies
5. Document your work

### Workflow

1. Read the [Orchestration Guide](./ORCHESTRATION.md)
2. Check the [Roadmap](./ROADMAP.md)
3. Find related work in [Projects](./projects/)
4. Create tickets as needed
5. Write code and tests
6. Document changes

### Important Notes

- Always review before making changes
- Ask for clarification when needed
- Follow the [Coding Standards](./docs/coding-standards.md)
```

#### BUSINESS_PLAN.md

```markdown
# Business Plan

> Living document - updated regularly by AI and humans

## Executive Summary

2-3 paragraph executive summary

## Problem Statement

What problem are we solving?

## Solution

How do we solve it?

## Target Market

Who is this for?

## Business Model

How do we make money?

## Competition

Who are we competing with?

## Go-to-Market Strategy

How do we reach customers?

## Financial Projections

Revenue, costs, and projections

## Team

Who is working on this?

## Timeline

Key milestones
```

#### ORCHESTRATION.md

```markdown
# Orchestration Guide

> How AI agents should coordinate in this repository

## Overview

This guide explains how AI agents work together in this company.

## Coordination Principles

1. **Single Source of Truth** - The coordinating repo is the source
2. **Transparent Communication** - All work is visible
3. **Human-in-the-Loop** - Humans review and approve
4. **Continuous Improvement** - Always learning and adapting

## AI Agent Types

### Coder Agent
- Writes code
- Creates pull requests
- Writes tests
- Location: `/projects/{project}/code/`

### Planner Agent
- Generates user stories
- Creates tasks
- Tracks progress
- Location: `/projects/{project}/user-stories/`

### Researcher Agent
- Analyzes markets
- Studies competitors
- Documents findings
- Location: `/knowledge/`

### Writer Agent
- Creates content
- Writes documentation
- Manages marketing
- Location: `/docs/`

## Workflow

### 1. Idea to Project

```
Idea → AI Analysis → Human Approval → Project Creation → Development
```

### 2. Project Development

```
Requirements → User Stories → Tasks → Code → Tests → Review → Merge
```

### 3. Continuous Improvement

```
Feedback → Analysis → Improvements → Documentation
```

## Communication Channels

- Slack/Discord for real-time chat
- GitHub Issues for tracking
- Linear for project management
- Notion for documentation
```

### ROADMAP.md

```markdown
# Company Roadmap

> Strategic roadmap - updated quarterly

## Vision

Where we want to be in 3-5 years

## Year 1 Goals

1. [ ] Launch MVP
2. [ ] Get first 100 customers
3. [ ] Reach $100K ARR
4. [ ] Scale team to 10 people

## Quarter Goals

### Q1 2026
- [ ] Complete core product
- [ ] Launch beta
- [ ] Get 10 beta users

### Q2 2026
- [ ] Launch publicly
- [ ] Get 50 customers
- [ ] Reach $20K ARR

## Monthly Milestones

### January 2026
- Week 1: Complete architecture
- Week 2: Build core features
- Week 3: User testing
- Week 4: Launch beta

## Progress Tracking

- Last updated: 2026-02-01
- Next review: 2026-03-01
```

---

## 4. Project Structure

### Example Project: project-alpha

```
projects/project-alpha/
├── README.md
├── user-stories/
│   ├── epic-001.md
│   ├── story-001.md
│   ├── story-002.md
│   └── task-001.md
├── specs/
│   ├── architecture.md
│   └── api-spec.yaml
├── code/
│   ├── src/
│   │   ├── index.ts
│   │   └── ...
│   ├── tests/
│   └── package.json
├── docs/
│   └── ...
└── .ai/
    └── context.md
```

#### Project README.md

```markdown
# Project Alpha

> Brief project description

## Overview

Longer description of what this project does

## Goals

1. Goal 1
2. Goal 2
3. Goal 3

## Features

- Feature 1
- Feature 2
- Feature 3

## Architecture

High-level architecture overview

## Dependencies

- External dependencies
- Internal dependencies (other projects)

## Getting Started

```bash
git clone https://github.com/org/project-alpha.git
cd project-alpha
npm install
npm run dev
```

## Related

- [Epic 001: User Authentication](./user-stories/epic-001.md)
- [Architecture Spec](./specs/architecture.md)
- [API Spec](./specs/api-spec.yaml)
```

#### Epic Example

```markdown
---
id: epic-001
title: User Authentication System
status: in-progress
priority: high
created: 2026-02-01
due: 2026-02-28
---

# User Authentication System

## Description

Implement a complete authentication system with email/password, OAuth, and session management.

## Goals

1. Allow users to sign up with email/password
2. Allow users to sign in with Google
3. Implement secure session management
4. Support password reset flow

## User Stories

- [Story 001: Email Sign Up](./story-001.md)
- [Story 002: Email Sign In](./story-002.md)
- [Story 003: Google OAuth](./story-003.md)
- [Story 004: Password Reset](./story-004.md)

## Technical Notes

- Use JWT for tokens
- Store password hashes with bcrypt
- Use Passport.js for OAuth
- Rate limiting on auth endpoints

## Acceptance Criteria

- [ ] All auth endpoints documented
- [ ] Security audit passed
- [ ] Tests cover 90% of code
- [ ] Performance < 200ms response
```

#### User Story Example

```markdown
---
id: story-001
title: User Sign Up with Email
status: ready
priority: high
epic: epic-001
estimate: 5 story points
created: 2026-02-01
---

# User Sign Up with Email

**As a** new user
**I want to** create an account using my email address
**So that** I can access the platform's features

## Description

Users should be able to sign up with email, password, and name.

## Acceptance Criteria

- [ ] User can enter email, password, and name
- [ ] Email format is validated
- [ ] Password strength is checked (min 8 chars, mixed case, numbers)
- [ ] Duplicate email is detected
- [ ] Confirmation email is sent
- [ ] User account is created after confirmation

## Technical Notes

- Use Zod for validation
- Send confirmation via SendGrid
- Hash password with bcrypt (cost factor 12)
- Rate limit: 5 requests/hour/IP

## Tasks

- [Task 001: Create sign-up API endpoint](./task-001.md)
- [Task 002: Implement email validation](./task-002.md)
- [Task 003: Create confirmation email flow](./task-003.md)

## Related

- Epic: [epic-001](./epic-001.md)
- Spec: [API Spec](../specs/api-spec.yaml)
```

#### Task Example

```markdown
---
id: task-001
title: Create sign-up API endpoint
status: in-progress
priority: high
story: story-001
assignee: ai-coder
estimate: 3 hours
created: 2026-02-01
due: 2026-02-05
---

# Create Sign-up API Endpoint

## Description

Implement the POST /api/auth/signup endpoint.

## Requirements

- Accept: email, password, name
- Validate input
- Check for existing user
- Create user record
- Send confirmation email
- Return success response

## Implementation

```typescript
// src/auth/signup.ts
import { z } from 'zod';
import { createUser, sendConfirmationEmail } from '../services';
import { hash } from 'bcrypt';

const signupSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
  name: z.string().min(2).max(100),
});

export async function signup(req: Request): Promise<Response> {
  const data = signupSchema.parse(req.body);
  
  // Check for existing user
  const existing = await getUserByEmail(data.email);
  if (existing) {
    throw new Error('User already exists');
  }
  
  // Hash password
  const passwordHash = await hash(data.password, 12);
  
  // Create user
  const user = await createUser({
    email: data.email,
    passwordHash,
    name: data.name,
  });
  
  // Send confirmation
  await sendConfirmationEmail(user);
  
  return Response.json({ success: true, userId: user.id });
}
```

## Testing

```typescript
// tests/auth/signup.test.ts
describe('POST /api/auth/signup', () => {
  it('creates a new user', async () => {
    const response = await request(app)
      .post('/api/auth/signup')
      .send({ email: 'test@example.com', password: 'Password123', name: 'Test' });
    
    expect(response.status).toBe(201);
    expect(response.body.success).toBe(true);
  });
});
```

## Related

- Story: [story-001](./story-001.md)
- Spec: [API Spec](../specs/api-spec.yaml)
```

---

## 5. Idea Management

### ideas.json Structure

```json
{
  "version": "1.0",
  "last_updated": "2026-02-10T00:00:00Z",
  "total_ideas": 150,
  "by_category": {
    "product": 45,
    "marketing": 35,
    "technical": 40,
    "business": 30
  },
  "by_status": {
    "backlog": 80,
    "evaluated": 40,
    "approved": 20,
    "in_progress": 8,
    "completed": 2
  },
  "ideas": [
    {
      "id": "idea-001",
      "title": "AI-Powered Project Management Tool",
      "category": "product",
      "status": "evaluated",
      "priority": "high",
      "embedding": [0.1, 0.2, 0.3, ...],
      "synergies": ["idea-042", "idea-015"],
      "tags": ["AI", "PM", "SaaS"],
      "created": "2026-02-01",
      "updated": "2026-02-10"
    }
  ],
  "synergy_pairs": [
    {
      "idea_1": "idea-001",
      "idea_2": "idea-042",
      "synergy_type": "integration",
      "strength": "high",
      "description": "AI Code Review Tool could integrate with PM tool"
    }
  ]
}
```

### Idea File Structure

```markdown
---
id: idea-001
title: AI-Powered Project Management Tool
category: product
status: evaluated
priority: high
tags: [AI, Project Management, SaaS]
created: 2026-02-01
updated: 2026-02-10
author: Human / AI
---

# AI-Powered Project Management Tool

## Summary
An AI-first project management tool where AI automatically generates tickets from conversations.

## Problem Statement
Current project management tools require manual ticket creation and tracking.

## Proposed Solution
Build a PM tool that uses AI to listen to conversations and automatically extract tasks.

## Target Market
- Startups (10-100 employees)
- Remote teams
- AI-first companies

## Market Size
- Total Addressable Market: $5B
- Serviceable Available Market: $500M

## Competitors
- Linear - $8/user/mo, good UX but no AI
- Asana - $11/user/mo, some AI features

## Our Advantage
- AI-first from day one
- Seamless AI agent integration

## Required Features
- [ ] Conversation-to-ticket conversion
- [ ] AI-powered estimation
- [ ] Automatic progress tracking

## Technical Requirements
- Frontend: React + TypeScript
- Backend: Node.js + PostgreSQL
- AI: Claude API + OpenRouter

## Estimated Effort
| Phase | Duration | Cost |
|-------|----------|------|
| MVP | 4 weeks | $3,000 |
| Beta | 4 weeks | $3,000 |

## Synergies
- **IDEA-042** (AI Code Review Tool) → Could integrate
- **IDEA-015** (AI Testing Tool) → Could use for automatic tests

## Next Steps
1. Create detailed spec document
2. Design architecture
3. Build MVP
```

---

## 6. Ticket System

### Ticket Structure

```
tickets/
├── active/
│   ├── bug-001.md
│   ├── feature-001.md
│   ├── task-001.md
│   └── chore-001.md
├── ready/
├── in-progress/
├── in-review/
└── done/
```

### Ticket Example

```markdown
---
id: feature-001
title: Add dark mode support
type: feature
status: ready
priority: medium
estimate: 3 story points
assignee: ai-coder
project: project-alpha
created: 2026-02-01
due: 2026-02-15
---

# Add Dark Mode Support

## Description
Users should be able to switch between light and dark themes.

## Requirements
- Toggle in settings
- Respect system preference
- Persist preference
- Support all pages

## Acceptance Criteria
- [ ] Dark mode toggle in settings
- [ ] System preference detected
- [ ] Preference saved to localStorage
- [ ] All pages support dark mode
- [ ] No visual bugs in dark mode

## Technical Notes
- Use CSS variables
- Support @media (prefers-color-scheme)
- Consider accessibility

## Related
- Project: project-alpha
- Design: Figma link
```

---

## 7. Knowledge Base

### Knowledge Structure

```
knowledge/
├── company-policies/
│   ├── code-review-policy.md
│   ├── ai-usage-policy.md
│   └── communication-policy.md
├── technical-docs/
│   ├── architecture/
│   ├── api/
│   └── infrastructure/
├── market-research/
│   ├── competitors/
│   └── trends/
└── processes/
    ├── onboarding.md
    └── offboarding.md
```

### Knowledge Article Example

```markdown
# Code Review Policy

## Purpose

Ensure code quality through systematic review.

## Policy

1. All code must be reviewed before merge
2. Review within 24 hours
3. At least 1 approval required
4. CI must pass

## Checklist

- [ ] Code follows style guide
- [ ] Tests included
- [ ] Documentation updated
- [ ] No linting errors
- [ ] Security considerations addressed

## AI Review

AI agents should review code for:
- Style consistency
- Potential bugs
- Performance issues
- Security vulnerabilities

## Human Review

Humans should review for:
- Business logic correctness
- User experience
- Architecture decisions
```

---

## 8. CI/CD Integration

### GitHub Actions Workflow

Create `.github/workflows/ai-ticket-generation.yml`:

```yaml
name: AI Ticket Generation

on:
  issue_comment:
    types: [created]
  workflow_dispatch:
    inputs:
      description:
        required: true
        type: string

jobs:
  generate-tickets:
    runs-on: ubuntu-latest
    if: contains(github.event.comment.body, '/generate')

    steps:
      - name: Checkout repo
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install dependencies
        run: npm ci

      - name: Generate tickets
        run: |
          node scripts/generate-ticket.js \
            --issue="${{ github.event.issue.number }}" \
            --comment="${{ github.event.comment.body }}"
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      - name: Create Pull Request
        uses: peter-evans/create-pull-request@v6
        with:
          title: "AI Generated Tickets"
          body: "Generated from issue #${{ github.event.issue.number }}"
          branch: ai/tickets/${{ github.event.issue.number }}
```

### Linear Sync

Create `scripts/sync-linear.js`:

```javascript
import { LinearClient } from '@linear/sdk';

const linear = new LinearClient({ apiKey: process.env.LINEAR_API_KEY });

export async function syncTickets() {
  // Get all tickets from repository
  const tickets = await getTicketsFromRepo();

  // Sync to Linear
  for (const ticket of tickets) {
    const issue = await linear.createIssue({
      teamId: process.env.LINEAR_TEAM_ID,
      title: ticket.title,
      description: ticket.content,
      labelIds: [ticket.type],
      priority: ticket.priority,
    });

    console.log(`Created Linear issue: ${issue.id}`);
  }
}
```

---

## 9. Setup Instructions

### Initial Setup

```bash
# 1. Create repository from template
gh repo create ai-startup-coordination --template .

# 2. Clone repository
git clone git@github.com:your-org/ai-startup-coordination.git
cd ai-startup-coordination

# 3. Install dependencies
npm install

# 4. Configure environment
cp .env.example .env
# Edit .env with your API keys

# 5. Initialize submodules (if any)
git submodule update --init --recursive

# 6. Run setup script
npm run setup

# 7. Verify structure
npm run verify
```

### Daily Workflow

```bash
# 1. Pull latest changes
git pull origin main

# 2. Check for new ideas
npm run ideas:check

# 3. Sync with Linear
npm run linear:sync

# 4. Generate tickets for new requirements
npm run tickets:generate -- --description="New feature request"

# 5. Start working
# (Use Cursor with OpenClaw for development)
```

### AI Prompt for Ticket Generation

```markdown
# Generate Tickets from Requirements

## Context
You are working in the coordinating repository for an AI startup.

## Input
{USER_REQUEST}

## Instructions
1. Analyze the request
2. Break down into user stories (2-5)
3. Break down each story into tasks (3-7 per story)
4. Include acceptance criteria
5. Estimate complexity (XS, S, M, L, XL)
6. Identify dependencies

## Output Format
Create markdown files in:
- /projects/{project}/user-stories/story-{NNN}.md
- /projects/{project}/user-stories/task-{NNN}.md

## Example Output
See existing examples in /projects/
```

---

**Document Information**
- Created: February 2026
- Version: 1.0
- Status: Production Ready
