<!-- -----------------------------------------------------------
 ! SPDX-License-Identifier: GFDL-1.3-or-later
 ! -------------------------------------------------------------
 ! Doc Type      : Markdown
 ! Doc Name      : README.md
 ! Doc Authors   : Aoran Zeng <ccmywish@qq.com>
 ! Contributors  :  Nul None  <nul@none.org>
 !               |
 ! Created On    : <2025-07-12>
 ! Last Modified : <2025-08-09>
 ! ---------------------------------------------------------- -->

# rawstr4c

rawstr4c - Raw strings for the C programming language

<br>

**The key innovation of `rawstr4c` is its use of a Markdown file to explicitly define raw strings inside code blocks — allowing you to fully leverage your editor’s syntax highlighting feature to beautifully render them!**

<br>

> [!NOTE]
> `rawstr4c` was originally developed for [chsrc], and is now maintained as a subproject of it. [chsrc] benefits greatly from `rawstr4c`.

<br>



## Why implemented in [Raku]?

Because **Raku** is the **RAw strings Kungfu Utility**!

`rawstr4c` has no module dependencies by design — just install [Rakudo] via your package manager and you're ready to go. Lightweight, hassle-free, and **a perfect excuse to explore Raku, the language you can have fun with**.

<br>



## Why do we still need it when we have `R"()"`

Until now (2025-07), the C language does not have raw strings in its current ISO standard, but **both `GCC` and `Clang` have already implemented the extension `R"()"`**. In fact, it is enabled by default in `GCC`.

However, there are several reasons why we still need `rawstr4c`:

1. `R"()"` is just an extension. Many projects that strictly adhere to `-std=c*` cannot use it
2. Many C compilers may not implement this extension, limiting the choice of C compilers for projects
3. `LLVM` only supports this extension after July 2024; versions prior to that do not support it

Even if direct raw strings support is added in future C standards like `C3x` or `C4x`, `rawstr4c` still remains meaningful, because when raw strings are written directly in source code files, they cannot be properly highlighted according to the content.

In [chsrc], we use both the native `R"()"` form and also `rawstr4c` to get the maximum flexibility and maintainability.

<br>



## Install

[![rawstr4c on Raku Land](https://raku.land/zef:ccmywish/rawstr4c/badges/version)](https://raku.land/zef:ccmywish/rawstr4c)

1. Install [Rakudo] (bundled with `zef`)
2. Then run:

```bash
$ zef install rawstr4c
```

<br>



## Usage

```bash
$ rawstr4c --help
```

You need to write a Markdown file (default `rawstr4c.md`) to record raw strings and configure `rawstr4c`. See below for configuration syntax.

<br>



## Convention

A configuration file should use this order:

1. section title
2. description of the variable
3. configuration block (configblock)
4. configuration block (configblock) comments
5. code block (codeblock) (raw string)
6. comments for the content of the code block (codeblock)

<br>



## Configuration Syntax

```markdown

- config-item1 = `:mode`

- config-item2 = `true|false|yes|no`

- config-item3 = `string value`

```

Configuration items always start with `-`, followed by the configuration item name and an `=`. The right-hand value must be wrapped with ``` `` ```.

Note: if the value is not arbitrarily given by the user, it should be set as a mode type, using `:` as a prefix.

<br>



## Configuration Items

Note: unless otherwise specified, the first item is the default value

- output =

  - `:terminal` = output to terminal
  - `:macro` = output as a `.h` file, defined as macro
  - `:global-variable` = output a `.h` file and corresponding `.c` file, defined as global variable
  - `:global-variable-only-header` = output only as a `.h` file, defined as global variable

- output-h-file =

  Custom generated header filename, default value is `rawstr4c.h`

- output-c-file =

  Custom generated C filename, default value is `rawstr4c.c`

- translate =

  - `:escape` = escape only
  - `:oct` = octal
  - `:hex` = hexadecimal

- postfix =

  - `:use-language` = use the language of the codeblock
  - `your string` = use a custom string as suffix

- name =

  Generated variable name, includes prefix and suffix by default. If this configuration item is not given, the section title will be used

- name-literally = `false` | `true`

  Ignore other configuration items and use `name` directly as the variable name

- namespace =

  Serves as a prefix after `prefix` and before variable name `name`, affecting nested sections

- no-prefix = `false` | `true`

  Whether the variable name uses prefix

- no-postfix = `false` | `true`

  Whether the variable name uses postfix

<br>



[Raku]:   https://raku.org/
[Rakudo]: https://rakudo.org/
[chsrc]:  https://github.com/RubyMetric/chsrc
