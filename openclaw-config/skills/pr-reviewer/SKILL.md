---
name: pr-reviewer
description: "Automated GitHub Pull Request reviewer with comprehensive checks. Use when reviewing PRs for code quality, security, tests, documentation, and best practices."
metadata:
  {
    "openclaw":
      {
        "emoji": "👀",
        "requires": { "bins": ["gh"] },
        "install":
          [
            {
              "id": "brew",
              "kind": "brew",
              "formula": "gh",
              "bins": ["gh"],
              "label": "Install GitHub CLI (brew)",
            },
            {
              "id": "apt",
              "kind": "apt",
              "package": "gh",
              "bins": ["gh"],
              "label": "Install GitHub CLI (apt)",
            },
          ],
      },
  }
---

# PR Reviewer Skill

Automated GitHub Pull Request reviewer with comprehensive checks for code quality, security, tests, and documentation.

## When to Use

- Reviewing pull requests for quality
- Checking for security issues
- Ensuring test coverage
- Validating documentation
- Enforcing coding standards

## Quick Start

Review a specific PR:

```bash
gh pr view 123 --repo owner/repo --json number,title,body,files
```

## Review Checklist

### Code Quality
- [ ] Code follows project conventions
- [ ] No obvious bugs or logic errors
- [ ] Proper error handling
- [ ] No hardcoded secrets or credentials
- [ ] Efficient algorithms and data structures

### Security
- [ ] No SQL injection vulnerabilities
- [ ] No XSS vulnerabilities
- [ ] Proper input validation
- [ ] No exposed sensitive data
- [ ] Secure dependencies

### Testing
- [ ] Tests included for new features
- [ ] Tests cover edge cases
- [ ] All tests pass
- [ ] No test coverage regressions

### Documentation
- [ ] Code comments where needed
- [ ] README updated if applicable
- [ ] API documentation updated
- [ ] Changelog updated

## Commands

### Get PR Details

```bash
gh pr view <number> --repo <owner/repo> --json number,title,body,author,createdAt,files
```

### List Changed Files

```bash
gh pr diff <number> --repo <owner/repo> --name-only
```

### View Full Diff

```bash
gh pr diff <number> --repo <owner/repo>
```

### Check CI Status

```bash
gh pr checks <number> --repo <owner/repo>
```

### Review PR

```bash
gh pr review <number> --repo <owner/repo> --approve --body "LGTM!"
```

## Best Practices

1. Always check the PR description for context
2. Review files in logical order (models → controllers → views → tests)
3. Test the changes locally if possible
4. Provide constructive feedback
5. Approve only when confident in the changes

## Automated Checks

Use with linting and security tools:

```bash
# Run linter
npm run lint

# Run security scan
npm audit

# Run tests
npm test

# Check test coverage
npm run test:coverage
```
