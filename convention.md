# Project conventions

## Maintaining this file

- When the user states a project convention, add it to this file as part of the same task.
- Read and follow this file before making project changes.
- Keep conventions concise and organized by topic. Update existing entries when a convention changes instead of adding conflicting or duplicate rules.
- Record conventions the user provides; do not treat one-off requests or inferred preferences as permanent conventions.
- If a new instruction clearly replaces an existing convention, update the existing entry. If the conflict is unclear, ask for clarification.

## Implementation conventions

- Avoid unnecessary code comments, including documentation that merely describes an obvious property or behavior. Add a comment only when it explains important, non-obvious information needed to understand or maintain the code.
- Add the following header to every new source file, using the actual filename, author name `Abolfazl`, and the file's creation date in `YYYY/MM/DD` format. Preserve the original creation date when editing existing files. This required header is an exception to the rule against unnecessary comments. Use equivalent comment syntax for file types that do not support `//`; do not add invalid comments to formats that do not support them.

  ```swift
  //
  //  <Filename.swift>
  //  Ewano
  //
  //  Created by Abolfazl on <YYYY/MM/DD>.
  //
  ```

## Commit message convention

- Review changes before every commit and choose the prefix matching their actual purpose:
  - New features or functionality: `Feature - Implement ...`
  - Bug fixes: `Bug Fix - Fixed ...`
  - Refactoring without behavior changes: `Refactor - ...`
- Keep messages concise, descriptive, and in English, using the wording above.
- Do not use other prefixes, including `feat:`, `fix:`, or `refactor:`.
- Avoid mixing unrelated changes in a single commit when they can be separated.
- Apply these rules to every commit without requiring further instructions.

Examples:

- `Feature - Implement top-up history`
- `Feature - Implement phone number validation`
- `Bug Fix - Fixed incorrect charge amount calculation`
- `Bug Fix - Fixed top-up history loading issue`
- `Refactor - Simplify TopupViewModel logic`
- `Refactor - Extract payment logic into a separate use case`
