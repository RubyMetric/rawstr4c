# ---------------------------------------------------------------
# SPDX-License-Identifier: GPL-3.0-or-later
# ---------------------------------------------------------------
# Script Name    : distribution.ps1
# Script Authors : Aoran Zeng <ccmywish@qq.com>
# Created On     : <2025-07-21>
# Last Modified  : <2025-07-21>
#
# rawstr4c distribution file (tar.gz) operator
#
# Usage:
#
# Be sure we're at the root directory of the repository, then run:
#
#       .\tool\distribution.ps1 -clean     # 清理 test 目录中的 .c/.h 文件
#       .\tool\distribution.ps1 -make      # 清理并创建发布包
#       .\tool\distribution.ps1 -show      # 显示发布包内容
#       .\tool\distribution.ps1 -upload    # 上传已存在的发布包到 fez
# ---------------------------------------------------------------

param(
  [switch]$clean,
  [switch]$make,
  [switch]$upload,
  [switch]$show
)

# 获取相对路径的函数
function Get-RelativePath($item) {
  # K:\chsrc\tool\rawstr4c
  # K:\chsrc\tool\rawstr4c\our-dist-file
  # 注意我们必须要删掉这里的\，这就是 +1 的原因
  return $item.FullName.Substring((Get-Location).Path.Length + 1)
}

# 清理函数：删除 test 目录中的 .c 和 .h 文件
function Invoke-Clean {
  Write-Host "清理 test 目录中的 .c 和 .h 文件..." -ForegroundColor Yellow
  if (Test-Path "test") {
    $cfiles = Get-ChildItem test -Recurse -Include "*.c", "*.h"
    if ($cfiles.Count -gt 0) {
      $cfiles | ForEach-Object {
        Write-Host "删除: $($_.FullName)" -ForegroundColor Gray
        Remove-Item $_.FullName -Force
      }
      Write-Host "已删除 $($cfiles.Count) 个文件" -ForegroundColor Green
    } else {
      Write-Host "test 目录中没有找到 .c 或 .h 文件" -ForegroundColor Green
    }
  } else {
    Write-Host "test 目录不存在" -ForegroundColor Yellow
  }
}

# 打包函数：创建发布包
function Invoke-Make {
  Write-Host "开始创建发布包..." -ForegroundColor Yellow

  # 先执行清理
  Invoke-Clean

  $files = @()

  # 添加 lib 目录（排除 .precomp）
  $files += Get-ChildItem lib -Recurse | Where-Object { $_.FullName -notlike "*\.precomp*" } | ForEach-Object { Get-RelativePath $_ }

  # 添加其他目录
  $files += Get-ChildItem bin, doc, test -Recurse | ForEach-Object { Get-RelativePath $_ }

  # 添加根目录文件
  $rootFiles = @('META6.json', 'LICENSE', 'README.md', 'Changes')
  foreach ($file in $rootFiles) {
    if (Test-Path $file) {
      $files += $file
    }
  }

  # 打包
  $archiveName = "rawstr4c-$(Get-Date -Format 'yyyyMMdd').tar.gz"
  $files | tar -czf $archiveName -T -

  Write-Host "打包完成: $archiveName" -ForegroundColor Green
  return $archiveName
}

# 上传函数：上传发布包到 fez
function Invoke-Upload {
  # 查找最新的发布包
  $archives = Get-ChildItem "rawstr4c-*.tar.gz" | Sort-Object LastWriteTime -Descending

  if ($archives.Count -eq 0) {
    Write-Error "没有找到发布包文件，请先运行 -make 创建发布包"
    exit 1
  }

  $latestArchive = $archives[0].Name
  Write-Host "找到发布包: $latestArchive" -ForegroundColor Green
  Write-Host "正在上传到 fez..." -ForegroundColor Yellow

  try {
    fez upload --file $latestArchive
    Write-Host "上传成功!" -ForegroundColor Green
  } catch {
    Write-Error "上传失败: $_"
    exit 1
  }
}

# 显示包内容函数：显示发布包的内容
function Invoke-Show {
  # 查找最新的发布包
  $archives = Get-ChildItem "rawstr4c-*.tar.gz" | Sort-Object LastWriteTime -Descending

  if ($archives.Count -eq 0) {
    Write-Error "没有找到发布包文件，请先运行 -make 创建发布包"
    exit 1
  }

  $latestArchive = $archives[0].Name
  Write-Host "发布包内容: $latestArchive" -ForegroundColor Green
  Write-Host "----------------------------------------" -ForegroundColor Gray

  try {
    tar -tzf $latestArchive
  } catch {
    Write-Error "无法读取发布包内容: $_"
    exit 1
  }

  Write-Host "----------------------------------------" -ForegroundColor Gray
  $fileInfo = Get-Item $latestArchive
  Write-Host "文件大小: $([math]::Round($fileInfo.Length / 1KB, 2)) KB" -ForegroundColor Cyan
  Write-Host "创建时间: $($fileInfo.CreationTime)" -ForegroundColor Cyan
}

# 显示帮助信息
function Show-Help {
  Write-Host @"
rawstr4c distribution operator

Usage:

  .\tool\distribution.ps1 -clean     # 清理 test 目录中的 .c/.h 文件
  .\tool\distribution.ps1 -make      # 清理并创建发布包
  .\tool\distribution.ps1 -show      # 显示发布包内容
  .\tool\distribution.ps1 -upload    # 上传已存在的发布包到 fez

"@
}

# 主逻辑
$cleanInt = if ($clean) { 1 } else { 0 }
$makeInt = if ($make) { 1 } else { 0 }
$uploadInt = if ($upload) { 1 } else { 0 }
$showInt = if ($show) { 1 } else { 0 }
$actionCount = $cleanInt + $makeInt + $uploadInt + $showInt

if ($actionCount -eq 0) {
  Show-Help
  exit 0
}

if ($actionCount -gt 1) {
  Write-Error "只能指定一个操作参数"
  Show-Help
  exit 1
}

if ($clean) {
  Invoke-Clean
}
elseif ($make) {
  Invoke-Make
}
elseif ($show) {
  Invoke-Show
}
elseif ($upload) {
  Invoke-Upload
}

