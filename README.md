# LiveCode language package for Atom

![LiveCode Community Logo](http://livecode.com/wp-content/uploads/2015/02/livecode-logo.png)

This is a language package that lets you edit [LiveCode](http://livecode.com/)
source code in the Atom editor.  It adds support for:

* LiveCode Builder source code (`.lcb`)
* LiveCode server source code (`.lc` and `.irev`)
* LiveCode script-only stacks (`.livecodescript`)

## Installing

Using the Atom package manager:

* Visit Atom's "Settings" view, and go to the "Install" tab
* Use the search field to search for the **language-livecode** package
* Click "Install"

See also the [Atom Packages](https://atom.io/docs/v1.0.19/using-atom-atom-packages)
section in the Atom Flight Manual for more info, including how to install
packages from the command line.

## Configuration

The settings for LiveCode integration can also be modified using Atom's
"Settings" view.  Go to the "Packages" tab, find the **language-livecode**
package, and click its "Settings" button.

See also the
[Package Settings](https://atom.io/docs/v1.0.19/using-atom-atom-packages#package-settings)
section in the Atom Flight Manual.

## Usage

**language-livecode** integrates LiveCode editing into the Atom editor.  Note
that it doesn't make Atom behave like the LiveCode IDE, and it doesn't
integrate with or replace the LiveCode IDE's script editor.

### Syntax highlighting and indentation

The package adds automatic syntax highlighting and indentation for all of the
supported LiveCode language types.

The optional [revigniter-syntax](https://atom.io/themes/revigniter-syntax)
can be installed to provide a colour theme that's tailored for LiveCode source
code.

### Autocompletion

The package also includes autocompletion support for symbols in the current
file, along with snippets for many common LiveCode Builder and LiveCode Script
syntax elements.

### Script error checking ("linting")

If you have the [linter](https://atom.io/packages/linter) package installed,
you can enable script error checking support.  This highlights and describes
script compilation errors as you work.

![Linter in action](http://ecove.on-rev.com/linter.gif)

#### LiveCode Script linting

You will need to
[download LiveCode server](https://downloads.livecode.com/livecode) and install
(by unzipping it somewhere appropriate).  LiveCode Server 7.1.0 or later is
required.

Next, go to the package settings and put the full path to the LiveCode server
program that you just extracted (e.g. `/path/to/livecode-community-server`)
into the "LiveCode Server Engine Path" setting.

It's often useful to enable the "Explicit Variables" setting to get an error
when you use a variable name that you haven't declared with `local` or
`global`.

**Note:** When checking LiveCode Server source files, the linter will only
check for errors in the file currently being edited.  If, for example, the file
you're editing includes another file and that inclusion causes a variable
re-declaration error, the linter will not detect it.

#### LiveCode Builder linting

**Warning:** Linting for LiveCode Builder source code is **experimental**.

You need LiveCode 8 installed to use LiveCode Builder linting.  The LiveCode
IDE's installation location contains the LiveCode Builder compiler, called
**lc-compile**.  In the package settings, set the "Compiler Path for LiveCode
Builder" to the full path to the compiler (e.g. `/path/to/lc-compile`).

The LiveCode Builder compiler also needs to know where to find the `.lci`
interface files which provide the built-in modules' interface information.
These are usually located in a `modules` directory near the **lc-compile**
program in the LiveCode IDE's installation location.  You should put this
path in the "Module Paths For LiveCode Builder" setting.

If you are working on a complex project and you need **lc-compile** to look for
`.lci` files in multiple places, you can put multiple paths in the "Module
Paths for LiveCode Builder" setting, separated by `;` characters.

**Notes:** The linting step will automatically create a `.lci` working
directory in the directory where the LCB file is located.  The linter puts the
interface files for the files that are being linted in that directory.  You may
get dependency errors if you edit an LCB module which has dependencies before
editing the module that it depends on, because the `.lci` working directory
will have missing interface files.

## Authors

* Ralf Bitter
* Peter Brett
* Monte Goulding
* Adam Robertson

The LiveCode server syntax and revIgniter snippets were converted from the
TextMate bundles available from the [revIgniter](http://revigniter.com/)
website.

## Reporting bugs and contributing

Please report any problems to the [GitHub issues tracker]( https://github.com/livecode/atom-language-livecode/issues).
