<!-- -----------------------------------------------------------
 ! SPDX-License-Identifier: GFDL-1.3-or-later
 ! -------------------------------------------------------------
 ! Doc Type      : Markdown
 ! Doc Name      : 01-Develop.md
 ! Doc Authors   : Aoran Zeng <ccmywish@qq.com>
 ! Contributors  :  Nul None  <nul@none.org>
 !               |
 ! Created On    : <2025-07-21>
 ! Last Modified : <2025-07-21>
 ! ---------------------------------------------------------- -->

# Develop `rawstr4c`

## Dependencies and Dev environment

Please install these first:

  1. [rakudo]

**Please make sure to use the dev branch for development**

```bash
git clone https://gitee.com/RubyMetric/rawstr4c.git -b dev
```

<br>



## Run

```bash
raku -Ilib ./bin/rawstr4c
```

We can install the distribution locally also.

```bash
zef install .

rawstr4c --help

zef uninstall rawstr4c
```

<br>



## Debug

```bash
rawstr4c --debug
# Note: there must be an = between option value and option
rawstr4c --debug=parser
rawstr4c --debug=generator
```

<br>



## Test

Run test scripts

```bash
cd test

raku ./xx-file.rakutest
```

<br>



[rakudo]: https://rakudo.org/
