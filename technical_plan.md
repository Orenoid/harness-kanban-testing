# Technical Plan

## Status
**Phase:** Planning

## Requirements Summary
Update `README.md` by appending, at the end of the file, the exact title of the article at `https://openai.com/index/harness-engineering/`. The title must be determined using Chrome DevTools MCP. If MCP is unavailable or fails, stop and report the blocker instead of proceeding with content changes.

## Technical Design
- Target file:
  - `README.md` (single documentation file update)
- Content source and extraction:
  - Use Chrome DevTools MCP to open `https://openai.com/index/harness-engineering/`.
  - Read the page title from the document title metadata (`<title>`) and/or the visible article heading (`<h1>`), then select the exact article title text to append.
- File update behavior:
  - Preserve all existing README content.
  - Add a newline if needed, then append one new line containing the article title at EOF.
- Validation/test coverage:
  - Manual check that the appended line is the final line in `README.md`.
  - Manual check that the text matches the extracted article title exactly (case, spacing, punctuation).
  - Confirm no unintended changes to other files.
- Integration points:
  - Chrome DevTools MCP (external dependency for content lookup).
  - Local git workflow for change tracking.
- Operational considerations:
  - If MCP connection, navigation, or title extraction fails, halt implementation and report the issue in the related work item before editing README.

## Implementation Steps
1. [ ] Use Chrome DevTools MCP to load the target OpenAI page and capture the exact article title.
2. [ ] Append the captured title as the last line of `README.md`, preserving current content.
3. [ ] Verify final file state and prepare commit/PR notes documenting MCP usage and outcome.

## Review Checklist
Before marking complete, verify all items from the project's Review Rules in AGENTS.md or equivalent guidance.

## Notes
No AGENTS.md or CLAUDE.md guidance file was found in the repository at planning time; default conventions are used for branch naming and commit style.
