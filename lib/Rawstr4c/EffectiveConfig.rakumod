# ---------------------------------------------------------------
# SPDX-License-Identifier: Artistic-2.0
# ---------------------------------------------------------------
# File Name     : EffectiveConfig.rakumod
# File Authors  : Aoran Zeng <ccmywish@qq.com>
# Contributors  :  Nul None  <nul@none.org>
# Created On    : <2025-07-16>
# Last Modified : <2025-08-09>
#
# Represent a section's effective configuration
# ---------------------------------------------------------------

use Rawstr4c::Config;
use Rawstr4c::Parser;

unit package Rawstr4c;

#| 一个 section 的配置 (基于层次化结构而形成的最终真正生效的配置)
class EffectiveSessionConfig is export {

  has Rawstr4c::Parser::Section $.section;

  method new($section) {
    self.bless(:$section);
  }

  #| 从当前 section 开始，向上遍历父节点查找配置项
  #|
  #| @param $default 注意，这里要使用配置项值的语法!
  #|
  method get-inherited-config($key, Str $default?) {
    my $current = $.section;
    while $current {
      if $current.configblock.exist($key) {

        return $current.configblock.get($key);
      }
      $current = $current.parent;
    }
    # 如果都没找到，生成一个新值
    # 当 $default 为空时，生成的是 RS4C-Nil
    return RS4CValue.new($default);
  }


  #| 非层次化读取，仅读取当前 section 自己的配置项
  #|
  #| @param $default 注意，这里要使用配置项值的语法!
  #|
  method get-direct-config($key, Str $default?) {

    if $.section.configblock.exist($key) {
      return $.section.configblock.get($key);
    }

    if ! $default.defined {
      # say "DEBUG: Key <$key> is undefined";
    }
    return RS4CValue.new($default);
  }


  # ============================================================

  # 返回当前 section 的 各种配置
  # 注意，这些函数全部都返回 ConfigValue's-Value 实例

  #| RS4C-Mode
  method translate-mode() {
    return self.get-inherited-config('translate', ':escape');
  }

  #| RS4C-Mode
  method output-mode() {
    return self.get-inherited-config('output', ':terminal');
  }

  #| RS4C-String
  method prefix() {
    return self.get-inherited-config('prefix', '_rawstr4c');
  }

  #| RS4C-String
  method postfix() {
    # RS4C-Mode 或 RS4C-String
    my $config-postfix = self.get-inherited-config('postfix', ':use-language');

    my $language = self.language.string-value;
    my $postfix;

    if $config-postfix.is-mode() && $config-postfix.mode-value() eq 'use-language' {
      $postfix = 'in_' ~ $language;
    } else {
      # 如果不是模式，那就是用户给了一个具体的字符串
      $postfix = $config-postfix.string-value();
    }

    return RS4CValue.new($postfix);
  }

  #| RS4C-Bool
  method no-prefix() {
    return self.get-inherited-config('no-prefix', 'false');
  }

  #| RS4C-Bool
  method no-postfix() {
    return self.get-inherited-config('no-postfix', 'false');
  }

  #| RS4C-String
  method language() {
    # RS4C-String 或 RS4C-Nil
    my $config-language = self.get-direct-config('language');

    my Str $lang;

    if $config-language.is-nil {
      # codeblock 没有写语言，就给 Unknown
      $lang = 'Unknown';
    } else {
      $lang = $config-language.string-value;
    }
    return RS4CValue.new($lang);
  }


  #| RS4C-String
  method name() {
    # RS4C-String 或 RS4C-Nil
    my $config-name = self.get-direct-config('name');

    my $name;

    if $config-name.is-nil {
      $name = $.section.title.lc
    } else {
      $name = $config-name.string-value;
    }
    return RS4CValue.new($name);
  }

  #| RS4C-Bool
  method name-literally() {
    return self.get-direct-config('name-literally', 'false');
  }


  # RS4C-String
  method namespace() {
    my $config-namespace = self.get-direct-config('namespace', '');

    my $current-namespace = $config-namespace.string-value;

    # 嵌套增加
    my $parent = $.section.parent;
    while $parent {
      if $parent.configblock.exist('namespace') {
        $current-namespace = $parent.configblock.get('namespace').string-value ~ $current-namespace;
      } else {
        # 空字符串
        $current-namespace =  '' ~ $current-namespace;
      }
      $parent = $parent.parent;
    }
    return RS4CValue.new($current-namespace);
  }


  #| RS4C-Bool
  method debug() {
    return self.get-inherited-config('debug', 'false');
  }


  #| RS4C-String
  method output-h-file() {
    return self.get-inherited-config('output-h-file', 'rawstr4c.h');
  }


  #| RS4C-String
  method output-c-file() {
    return self.get-inherited-config('output-c-file', 'rawstr4c.c');
  }
}
