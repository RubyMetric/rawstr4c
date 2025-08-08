# ---------------------------------------------------------------
# SPDX-License-Identifier: Artistic-2.0
# ---------------------------------------------------------------
# File Name     : Config.rakumod
# File Authors  : Aoran Zeng <ccmywish@qq.com>
# Contributors  :  Nul None  <nul@none.org>
# Created On    : <2025-08-08>
# Last Modified : <2025-08-08>
#
# Internal representation for raw config
# ---------------------------------------------------------------

#| 不能用 Bool，只能用 Boolean
my enum RS4CType < RS4C-Nil RS4C-String RS4C-Mode RS4C-Bool >;

#| 配置项的值
class RS4CValue is export {
  has RS4CType $.type;
  has Str      $.raw-value;
  has Any      $.parsed-value;

  #| $raw-text 为 undefined 的情况只有一种，那就是内部刻意生成
  method new(Str $input-text) {
    my $type;
    my $parsed-value;

    my $raw-value = $input-text;

    # 明确区分空字符串和无值情况
    # 这种情况不可能是用户写的(并没有nil这个字面量)
    if ! $input-text.defined {
      $type = RS4C-Nil;
      $parsed-value = Nil;
      $raw-value = "<internal-rs4c-nil>"; # 一个完全用不到的值，但是由于 $.raw-value 类型是字符串，所以必须随便给一个值
    }
    else {
      # wrtd: 不要试图在这里利用 given when 统一处理未定义的值，因为会一直报错
      given $input-text {
        when /^ ':' (.+) $/ {
          # 模式值 :mode
          $type = RS4C-Mode;
          $parsed-value = ~$0;
        }
        when /^ ('true'|'false'|'yes'|'no') $/ {
          # 特殊字面量 - true/false/yes/no 都是 literal
          $type = RS4C-Bool;
          $parsed-value = ~$0 ~~ /^('true'|'yes')$/ ?? True !! False;
        }
        # 输入为空时被当做是字符串类型
        default {
          # 普通字符串
          $type = RS4C-String;
          $parsed-value = $input-text;
        }
      }
    }
    self.bless(:$type, :$raw-value, :$parsed-value);
  }

  # 获得适合调用者接受的值
  method value() {
    given $.type {
      when RS4C-Nil | RS4C-String | RS4C-Bool | RS4C-Mode  { return $.parsed-value; }
      default { die "Unknown config value type: {$.type}"; }
    }
  }

  # 这些函数防止开发者写错类型
  method nil-value() {
    return self.value if $.type == RS4C-Nil;
    die "The config value type should be RS4C-Nil, but it is: {$.type}";
  }

  method string-value() {
    return self.value if $.type == RS4C-String;
    die "The config value type should be RS4C-String, but it is: {$.type}";
  }

  method bool-value() {
    return self.value if $.type == RS4C-Bool;
    die "The config value type should be RS4C-Bool, but it is: {$.type}";
  }

  method mode-value() {
    return self.value if $.type == RS4C-Mode;
    die "The config value type should be RS4C-Mode, but it is: {$.type}";
  }


  # 类型检查方法
  method is-nil()  { return $.type == RS4C-Nil; }
  method is-mode() { return $.type == RS4C-Mode; }
  method is-bool() { return $.type == RS4C-Bool; }
  method is-string() { return $.type == RS4C-String; }
}
