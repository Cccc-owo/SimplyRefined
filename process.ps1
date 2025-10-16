param(
    [string]$Directory = "./mods/"
)

# 检查目录是否存在
if (-not (Test-Path -Path $Directory)) {
    Write-Host "错误: 目录 '$Directory' 不存在!" -ForegroundColor Red
    exit 1
}

# 获取所有 TOML 文件
$tomlFiles = Get-ChildItem -Path $Directory -Filter "*.toml" -Recurse -File

if ($tomlFiles.Count -eq 0) {
    Write-Host "在目录 '$Directory' 中未找到任何 .toml 文件" -ForegroundColor Yellow
    exit 0
}

Write-Host "找到 $($tomlFiles.Count) 个 .toml 文件" -ForegroundColor Green

# 计数器
$modifiedCount = 0

foreach ($file in $tomlFiles) {
    Write-Host "正在处理: $($file.FullName)" -ForegroundColor Cyan
    
    # 读取文件内容
    $content = Get-Content -Path $file.FullName -Raw
    
    # 检查是否需要替换
    if ($content -match 'side = "server"') {
        # 执行替换
        $newContent = $content -replace 'side = "server"', 'side = "both"'
        
        # 写回文件
        Set-Content -Path $file.FullName -Value $newContent -NoNewline
        
        Write-Host "已更新: $($file.FullName)" -ForegroundColor Green
        $modifiedCount++
    } else {
        Write-Host "无需修改: $($file.FullName)" -ForegroundColor Gray
    }
}

Write-Host "处理完成! 共修改了 $modifiedCount 个文件" -ForegroundColor Green