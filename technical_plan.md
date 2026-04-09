# Technical Plan

## Status
**Phase:** Planning

## Requirements Summary
This issue is for clean validation of the Claude CLI after fixing the API key configuration. The goal is to verify whether the planning phase still hangs/gets stuck after the API key fix.

The validation-test.js currently throws an intentional error. This needs to be fixed to properly test the Claude CLI functionality with valid API key configuration.

## Technical Design

### Current State Analysis
- `apps/api-server/.env` contains placeholder OpenAI API keys: `sk-harness-kanban-devcontainer-placeholder`
- `validation-test.js` currently throws an intentional error for testing purposes
- The Claude CLI integration relies on the `OPENAI_API_KEY` environment variable

### Proposed Changes

1. **Fix validation-test.js**
   - Remove the intentional error throw
   - Add proper test logic to verify API key configuration
   - Add test to verify Claude CLI planning phase executes without hanging

2. **API Key Configuration**
   - The placeholder API key in `.env` files needs to be replaced with a valid key or proper error handling
   - Add validation to ensure the API key is properly configured before attempting API calls

3. **Error Handling**
   - Add timeout mechanism to detect if planning phase hangs
   - Add clear error messages when API key is invalid or missing

## Implementation Steps
1. [ ] Update `validation-test.js` to remove intentional error and add proper validation logic
2. [ ] Add API key validation to prevent hanging when key is invalid
3. [ ] Add timeout mechanism for planning phase detection
4. [ ] Test the clean run to verify planning phase completes successfully

## Review Checklist
- [ ] Code follows project conventions
- [ ] Error handling is appropriate
- [ ] The validation test passes with a valid API key
- [ ] The validation test fails gracefully with an invalid/missing API key

## Notes
- The main concern is ensuring the planning phase doesn't hang indefinitely when there's an API key issue
- The fix should provide clear feedback about configuration problems
