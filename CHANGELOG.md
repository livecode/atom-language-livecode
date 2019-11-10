## 0.7.0 - Upgrade to Linter V2
* Linting is broken since the release of Linter 2. Adjusted
  lib/main.coffee and package.json accordingly. (PR #37)
* Corrected scope for highlighting in mixed (HTML/iRev)
  environment. (PR #38)
* Adjusted revIgniter grammar and snippets to revIgniter modifications
  up to version 2.1.0. (PR #39)
* Updated indent rules (PR #35)

## 0.6.1 - Improvements to documentation and LiveCode Script support
* Revised, expanded and generally improved documentation (issue #19)
* Improved LiveCode Script support
  * Support for `if...then...else...` syntax
  * Better indentation in `switch` blocks
  * Restore completion of symbols from the current file (issue #18)
  * Don't clobber autocomplete settings (issue #16)
  * Improved variable & constant capturing
* Restored support for linting revIgniter files

## 0.6.0 - Linting and script-only stacks
* LiveCode Script grammar and snippets generated from documentation
* Support for script-only stacks (`.livecodescript`)
* Linting & syntax checking for LiveCode Script files
* Initial linting support for LiveCode Builder source files

## 0.5.1 - Minor documentation updates

## 0.5.0 - Added LiveCode server support
* Merged with the "revigniter-livecode" package for Atom
  * Added support for LiveCode server script files (`.lc` and `.irev`)
* Greatly-improved LCB autocomplete support
  * Correctly suggest handler, variable, constant, and type names, and known
    keywords
* Minor LCB syntax highlighting bugfixes

Thanks to Adam Robertson for converting LiveCode server support from the
original TextMate grammars.

## 0.3.0 - Snippet support
* Add basic snippets for commonly-used blocks. These work with Atom's new
  built-in autocomplete support.
  * "if" and "if … else"
  * "repeat"
  * "handler"
  * "module", "library" and "widget"
* Minor syntax highlighting bugfix

## 0.2.0 - Updates to LCB syntax highlighting
* Add detection of "metadata" and "property" declarations
* Add "undefined" and "the empty <x>" as language constants
* Various minor improvements and bug fixes

## 0.1.0 - Initial development preview
* Basic support for LiveCode Builder
  * Syntax highlighting
  * Indentation rules for "if", "handler" and "repeat" blocks
