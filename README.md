# LiveCode Language package for Atom

![LiveCode Community Logo](http://livecode.com/wp-content/uploads/2015/02/livecode-logo.png)

This is a language package for Atom that provides support for editing
[LiveCode](http://livecode.com/) source code.

LiveCode is an open source platform provides a way to build applications for
mobile, desktop and server platforms. The visual workflow allows the user to
develop apps "live", using a powerful and uniquely-accessible language syntax.

The LiveCode server syntax and revIgniter snippets were converted from the
TextMate bundles available from the [revIgniter](http://revigniter.com/)
website.

## Supported languages

Currently, this package supports editing:

* LiveCode Builder source code in `.lcb` files
* LiveCode server source code in `.lc` and `.irev` files
* LiveCode Script source code in `.livecodescript` files, where the shebang line
contains `livecode` or the first line contains an Emacs mode comment
`# -*- mode:livecodescript -*-`

The package provides syntax highlighting, highlighting and indentation support
for all the supported languages.

It also provides snippets to enhance LiveCode server script and revIgniter
script development.

For LiveCode Script there are quite a number of autocomplete snippets generated
from the LiveCode documentation.

## Installation

Install the `language-livecode` package from the "Install Packages and Themes"
view in Atom's "Settings" window.

You may also wish to install the [revIgniter theme](https://atom.io/themes/revigniter-syntax)
for Atom.

## Script Error Checking

This package provides a linter for LiveCode Script and Server to highlight and describe
script compilation errors on the fly.

![Linter In Action](http://ecove.on-rev.com/linter.gif)

Dependencies:

 * The [linter package](https://atom.io/packages/linter) needs to be installed
 * LiveCode 7.1+ Server engine for the platform it is being run on must be accessible

The default setting assumes you have installed the LiveCode Server engine somewhere
on the current `$PATH` with the name `livecode-server`. However, you can enter any
path or name you choose via the package settings.

For LiveCode Server the linter will only check for errors within the scope of
the file being edited. If for example a variable re-declarition error is caused
by the inclusion of another file that error won't be detected.

The linter supports an optional explicit variables mode which can be turned on
via the package settings.

## Authors

* Ralf Bitter
* Peter Brett
* Adam Robertson
* Monte Goulding

## Reporting bugs and contributing

Please report any problems to the [GitHub issues tracker]( https://github.com/peter-b/atom-language-livecode/issues).
