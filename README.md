<!-- -----------------------------------------------------------
 ! SPDX-License-Identifier: GFDL-1.3-or-later
 ! -------------------------------------------------------------
 ! Doc Type      : Markdown
 ! Doc Name      : README.md
 ! Doc Authors   : Aoran Zeng <ccmywish@qq.com>
 ! Contributors  :  Nul None  <nul@none.org>
 !               |
 ! Created On    : <2025-07-12>
 ! Last Modified : <2025-07-21>
 ! ---------------------------------------------------------- -->

# rawstr4c

Use this tool when you need to write and maintain complex C language strings (raw strings for C). **It saves you from the nightmare of one-off string generation tools, turning you into a professional raw strings maintainer.**

By using a separate `rawstr4c.md` file, you explicitly record raw strings inside code blocks, along with the rules for generating variable names. By checking this file into your repository, you can continuously iterate on it.

**The core innovation of `rawstr4c` is to use a Markdown file — allowing you to take advantage of your editor’s Markdown syntax highlighting feature to highlight your raw strings!**

> [!NOTE]
> This tool was originally developed as and now maintained as a subproject of [chsrc] (which proudly benefits greatly from it)

<br>



## Install

![zef](https://raku.land/zef:ccmywish/rawstr4c/badges/version)

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

Configuration items always start with `-`, followed by the configuration item name and an `=`, and the right-hand value must be wrapped with ``` `` ```.

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

  Custom generated c filename, default value is `rawstr4c.c`

- translate =

  - `:escape` = escape only
  - `:oct` = octal
  - `:hex` = hexadecimal

- postfix =

  - `:use-language` = use the language of the codeblock
  - `your string` = use a custom string as suffix

- name =

  Generated variable name, will include prefix and suffix by default. If this configuration item is not given, the section title will be used

- name-literally = `false` | `true`

  Ignore other configuration items and directly use `name` as the variable name

- namespace =

  Will serve as a prefix after `prefix` and before variable name `name`, affecting the next level section

- keep-prefix = `true` | `false`

  Whether the variable name uses prefix

- keep-postfix = `true` | `false`

  Whether the variable name uses postfix

<br>



[chsrc]: https://github.com/RubyMetric/chsrc
