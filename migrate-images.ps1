# Script to migrate remote images to local static folder
$postsDir = "F:\Blog netfly\feline-living-collective\content\posts"
$imagesDir = "F:\Blog netfly\feline-living-collective\static\images\posts"
$userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"

# Create images directory if it doesn't exist
if (-not (Test-Path $imagesDir)) {
    New-Item -ItemType Directory -Force -Path $imagesDir | Out-Null
}

# Get all markdown files
$files = Get-ChildItem $postsDir -Filter "*.md"

foreach ($file in $files) {
    Write-Host "Processing $($file.Name)..."
    $content = Get-Content $file.FullName -Raw
    $originalContent = $content

    # 1. Handle Frontmatter Image
    $fmPattern = 'image: "(https?://[^"]+)"'
    # Also match already local paths that might have * to fix them
    $fmPatternLocal = 'image: "(/images/posts/[^"]+)"'
    
    # Fix remote
    $fmMatches = [regex]::Matches($content, $fmPattern)
    foreach ($match in $fmMatches) {
        $url = $match.Groups[1].Value
        if ($url -notmatch "medium.com") { continue }
        
        $filename = $url.Split("/")[-1].Split("?")[0]
        $filename = $filename -replace '\*', '_' # Sanitize
        if ($filename -notmatch "\.") { $filename = "$filename.jpg" }
        
        $localPath = Join-Path $imagesDir $filename
        $relPath = "/images/posts/$filename"

        try {
            if (-not (Test-Path $localPath)) {
                Write-Host "  Downloading Cover $filename..."
                curl.exe -L $url -o $localPath -H "User-Agent: $userAgent" --silent --show-error
            }
            $content = $content.Replace($url, $relPath)
        }
        catch { Write-Error "Failed cover download: $_" }
    }
    
    # Fix broken local paths (with *)
    $content = $content -replace 'image: "/images/posts/([^\"]*)\*([^\"]*)"', 'image: "/images/posts/$1_$2"'

    # 2. Handle Body Images (Convert to Shortcode)
    
    # Fix existing shortcodes (remote or broken local)
    $scPattern = '\{\{< img src="([^"]+)" alt="([^"]*)" >\}\}'
    $scMatches = [regex]::Matches($content, $scPattern)
    foreach ($match in $scMatches) {
        $fullMatch = $match.Value
        $url = $match.Groups[1].Value
        $alt = $match.Groups[2].Value
        
        # If it's remote Medium URL
        if ($url -match "medium.com") {
            $filename = $url.Split("/")[-1].Split("?")[0]
            $filename = $filename -replace '\*', '_' # Sanitize
            if ($filename -notmatch "\.") { $filename = "$filename.jpg" }
            $localPath = Join-Path $imagesDir $filename
            $relPath = "/images/posts/$filename"

            try {
                if (-not (Test-Path $localPath)) {
                    Write-Host "  Downloading SC $filename..."
                    curl.exe -L $url -o $localPath -H "User-Agent: $userAgent" --silent --show-error
                }
                $newShortcode = "{{< img src=`"$relPath`" alt=`"$alt`" >}}"
                $content = $content.Replace($fullMatch, $newShortcode)
            }
            catch { Write-Error "Failed SC download" }
        }
        # If it's local but has * (broken)
        elseif ($url -match "\*") {
            $newUrl = $url -replace '\*', '_'
            $newShortcode = "{{< img src=`"$newUrl`" alt=`"$alt`" >}}"
            $content = $content.Replace($fullMatch, $newShortcode)
        }
    }

    # Save if changed
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
        Write-Host "  Updated $($file.Name)"
    }
}
