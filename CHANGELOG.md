## 0.5.0 - Added LiveCode server support
* Merged with the "revigniter-livecode" package for Atom
  * Added support for LiveCode server script files (`.lc` and `.irev`)

Thanks to Adam Robertson for converting LiveCode server support from the
original TextMate grammars.

## 0.4.0 - Improvements to completion
* Greatly-improved autocomplete support
  * Correctly suggest handler, variable, constant, and type names, and
    known keywords
* Minor syntax highlighting bugfixes

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
