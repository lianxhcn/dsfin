$ErrorActionPreference = 'Stop'

$baseDir = 'd:\github_lianxh\dsfin\Lecture\ml_lasso'
$srcPath = Join-Path $baseDir 'chp56_Lasso.tex'
$slidesPath = Join-Path $baseDir 'Lasso_slides.md'
$outPath = Join-Path $baseDir 'Lasso_lec.qmd'
$enc = [System.Text.UTF8Encoding]::new($false)

function Replace-OneArg {
    param(
        [string]$InputText,
        [string]$CommandName,
        [scriptblock]$Formatter
    )

    $builder = New-Object System.Text.StringBuilder
    $needle = '\' + $CommandName + '{'
    $i = 0

    while ($i -lt $InputText.Length) {
        if ($i -le $InputText.Length - $needle.Length -and $InputText.Substring($i, $needle.Length) -eq $needle) {
            $j = $i + $needle.Length
            $depth = 1
            $argBuilder = New-Object System.Text.StringBuilder

            while ($j -lt $InputText.Length -and $depth -gt 0) {
                $ch = $InputText[$j]
                $prev = if ($j -gt 0) { $InputText[$j - 1] } else { [char]0 }
                if ($ch -eq '{' -and $prev -ne '\') {
                    $depth++
                    if ($depth -gt 1) { [void]$argBuilder.Append($ch) }
                }
                elseif ($ch -eq '}' -and $prev -ne '\') {
                    $depth--
                    if ($depth -gt 0) { [void]$argBuilder.Append($ch) }
                }
                else {
                    [void]$argBuilder.Append($ch)
                }
                $j++
            }

            [void]$builder.Append((& $Formatter $argBuilder.ToString()))
            $i = $j
            continue
        }

        [void]$builder.Append($InputText[$i])
        $i++
    }

    return $builder.ToString()
}

function Replace-TwoArg {
    param(
        [string]$InputText,
        [string]$CommandName,
        [scriptblock]$Formatter
    )

    $builder = New-Object System.Text.StringBuilder
    $needle = '\' + $CommandName + '{'
    $i = 0

    while ($i -lt $InputText.Length) {
        if ($i -le $InputText.Length - $needle.Length -and $InputText.Substring($i, $needle.Length) -eq $needle) {
            $j = $i + $needle.Length
            $depth = 1
            $arg1Builder = New-Object System.Text.StringBuilder

            while ($j -lt $InputText.Length -and $depth -gt 0) {
                $ch = $InputText[$j]
                $prev = if ($j -gt 0) { $InputText[$j - 1] } else { [char]0 }
                if ($ch -eq '{' -and $prev -ne '\') {
                    $depth++
                    if ($depth -gt 1) { [void]$arg1Builder.Append($ch) }
                }
                elseif ($ch -eq '}' -and $prev -ne '\') {
                    $depth--
                    if ($depth -gt 0) { [void]$arg1Builder.Append($ch) }
                }
                else {
                    [void]$arg1Builder.Append($ch)
                }
                $j++
            }

            if ($j -ge $InputText.Length -or $InputText[$j] -ne '{') {
                [void]$builder.Append($InputText[$i])
                $i++
                continue
            }

            $j++
            $depth = 1
            $arg2Builder = New-Object System.Text.StringBuilder

            while ($j -lt $InputText.Length -and $depth -gt 0) {
                $ch = $InputText[$j]
                $prev = if ($j -gt 0) { $InputText[$j - 1] } else { [char]0 }
                if ($ch -eq '{' -and $prev -ne '\') {
                    $depth++
                    if ($depth -gt 1) { [void]$arg2Builder.Append($ch) }
                }
                elseif ($ch -eq '}' -and $prev -ne '\') {
                    $depth--
                    if ($depth -gt 0) { [void]$arg2Builder.Append($ch) }
                }
                else {
                    [void]$arg2Builder.Append($ch)
                }
                $j++
            }

            [void]$builder.Append((& $Formatter $arg1Builder.ToString() $arg2Builder.ToString()))
            $i = $j
            continue
        }

        [void]$builder.Append($InputText[$i])
        $i++
    }

    return $builder.ToString()
}

function Strip-Comments {
    param([string]$Line)

    $builder = New-Object System.Text.StringBuilder
    for ($i = 0; $i -lt $Line.Length; $i++) {
        $ch = $Line[$i]
        $prev = if ($i -gt 0) { $Line[$i - 1] } else { [char]0 }
        if ($ch -eq '%' -and $prev -ne '\') {
            break
        }
        [void]$builder.Append($ch)
    }
    return $builder.ToString()
}

function Expand-Macros {
    param(
        [string]$Text,
        [hashtable]$Macros
    )

    $result = $Text
    foreach ($key in ($Macros.Keys | Sort-Object Length -Descending)) {
        $result = $result.Replace(('\' + $key), $Macros[$key])
    }
    return $result
}

function Clean-Inline {
    param([string]$Text)

    $result = $Text
    $result = $result -replace '\\label\{[^}]+\}', ''
    $result = $result -replace '\\index\{[^}]+\}', ''
    $result = $result -replace '\\vspace\{[^}]*\}', ''
    $result = $result -replace '\\noindent\s*', ''
    $result = $result -replace '\\hline\s*', ''
    $result = $result -replace '\\quad\s*', ' '
    $result = $result -replace '\\%', '%'
    $result = $result -replace '\\_', '_'
    $result = $result -replace '\\&', '&'
    $result = $result -replace '\\#', '#'
    $result = $result.TrimEnd()
    return $result
}

function Resolve-Image {
    param(
        [string]$RawPath,
        [hashtable]$LocalImages,
        [hashtable]$SlideImages
    )

    $candidate = $RawPath.Trim()
    $candidate = $candidate -replace '\\', '/'
    $candidate = $candidate.Trim('{}')
    $candidate = $candidate.Trim()

    if ([string]::IsNullOrWhiteSpace($candidate)) {
        return ''
    }

    $candidateKey = $candidate.ToLowerInvariant()
    $candidateBase = [System.IO.Path]::GetFileNameWithoutExtension($candidate).ToLowerInvariant()

    if ($LocalImages.ContainsKey($candidateKey)) { return $LocalImages[$candidateKey] }
    if ($SlideImages.ContainsKey($candidateKey)) { return $SlideImages[$candidateKey] }
    if ($LocalImages.ContainsKey($candidateBase)) { return $LocalImages[$candidateBase] }
    if ($SlideImages.ContainsKey($candidateBase)) { return $SlideImages[$candidateBase] }

    foreach ($ext in @('.png', '.jpg', '.jpeg', '.gif', '.webp')) {
        if ($LocalImages.ContainsKey($candidateBase + $ext)) { return $LocalImages[$candidateBase + $ext] }
        if ($SlideImages.ContainsKey($candidateBase + $ext)) { return $SlideImages[$candidateBase + $ext] }
    }

    return $candidate
}

function Convert-FigureBlock {
    param(
        [string[]]$BlockLines,
        [hashtable]$Macros,
        [hashtable]$LocalImages,
        [hashtable]$SlideImages
    )

    $blockText = Expand-Macros (($BlockLines | ForEach-Object { Strip-Comments $_ }) -join "`n") $Macros
    $blockText = Clean-Inline $blockText

    $imageMatches = [regex]::Matches($blockText, '\\includegraphics(?:\[[^\]]*\])?\{([^}]+)\}')
    if ($imageMatches.Count -eq 0) { return @() }

    $caption = ''
    $captionMatch = [regex]::Match($blockText, '\\caption\{([\s\S]*?)\}')
    if ($captionMatch.Success) {
        $caption = Clean-Inline $captionMatch.Groups[1].Value.Replace('\\', ' ')
    }

    $label = ''
    $labelMatch = [regex]::Match($blockText, '\\label\{([^}]+)\}')
    if ($labelMatch.Success) {
        $label = $labelMatch.Groups[1].Value.Trim()
    }

    $out = New-Object System.Collections.Generic.List[string]
    foreach ($match in $imageMatches) {
        $resolved = Resolve-Image $match.Groups[1].Value $LocalImages $SlideImages
        if (-not [string]::IsNullOrWhiteSpace($resolved)) {
            [void]$out.Add('![](' + $resolved + ')')
        }
    }

    if (-not [string]::IsNullOrWhiteSpace($caption)) {
        [void]$out.Add('')
        [void]$out.Add($caption)
    }
    if (-not [string]::IsNullOrWhiteSpace($label)) {
        [void]$out.Add('')
        [void]$out.Add('<!-- label: ' + $label + ' -->')
    }

    return $out
}

function Convert-EquationBlock {
    param([string[]]$BlockLines)

    $out = New-Object System.Collections.Generic.List[string]
    [void]$out.Add('$$')
    foreach ($line in $BlockLines) {
        if ($line -match '^\s*\\begin\{equation\}' -or $line -match '^\s*\\end\{equation\}') {
            continue
        }
        $clean = Strip-Comments $line
        $clean = $clean -replace '\\label\{[^}]+\}', ''
        $clean = $clean.TrimEnd()
        if ($clean -ne '') {
            [void]$out.Add($clean)
        }
    }
    [void]$out.Add('$$')
    return $out
}

$slideImages = @{}
if (Test-Path $slidesPath) {
    $slideText = [System.IO.File]::ReadAllText($slidesPath, $enc)
    foreach ($match in [regex]::Matches($slideText, '!\[[^\]]*\]\(([^)]+)\)')) {
        $url = $match.Groups[1].Value.Trim()
        $baseName = [System.IO.Path]::GetFileName($url).ToLowerInvariant()
        $baseNoExt = [System.IO.Path]::GetFileNameWithoutExtension($url).ToLowerInvariant()
        if (-not $slideImages.ContainsKey($baseName)) { $slideImages[$baseName] = $url }
        if (-not $slideImages.ContainsKey($baseNoExt)) { $slideImages[$baseNoExt] = $url }
    }
}

$localImages = @{}
Get-ChildItem -Path $baseDir -Recurse -File | ForEach-Object {
    $relative = $_.FullName.Substring($baseDir.Length + 1).Replace('\', '/')
    $fileName = $_.Name.ToLowerInvariant()
    $baseNoExt = [System.IO.Path]::GetFileNameWithoutExtension($_.Name).ToLowerInvariant()
    if (-not $localImages.ContainsKey($fileName)) { $localImages[$fileName] = $relative }
    if (-not $localImages.ContainsKey($baseNoExt)) { $localImages[$baseNoExt] = $relative }
    if (-not $localImages.ContainsKey($relative.ToLowerInvariant())) { $localImages[$relative.ToLowerInvariant()] = $relative }
}

$text = [System.IO.File]::ReadAllText($srcPath, $enc)
$text = [regex]::Replace($text, '(?s)\\iffalse.*?\\fi', '')
$text = Replace-OneArg $text 'MakeUppercase' { param($arg) $arg }
$text = Replace-OneArg $text 'bfseries' { param($arg) '**' + $arg + '**' }
$text = Replace-OneArg $text 'textbf' { param($arg) '**' + $arg + '**' }
$text = Replace-OneArg $text 'emph' { param($arg) '*' + $arg + '*' }
$text = Replace-OneArg $text 'texttt' { param($arg) '`' + $arg + '`' }
$text = Replace-OneArg $text 'footnote' { param($arg) ' (' + (($arg -replace '\s+', ' ').Trim()) + ')' }
$text = Replace-OneArg $text 'index' { param($arg) '' }
$text = Replace-TwoArg $text 'href' { param($url, $label) '[' + $label + '](' + $url + ')' }
$text = Replace-TwoArg $text 'textcolor' { param($color, $label) $label }
$text = $text -replace '\\minitoc', ''
$text = $text -replace '\\setcounter\{minitocdepth\}\{[^}]*\}', ''
$text = $text -replace '\\vspace\{[^}]*\}', ''
$text = $text -replace '\\subfigbottomskip\s*=\s*[^\r\n]+', ''
$text = $text -replace '\\subfigcapskip\s*=\s*[^\r\n]+', ''
$text = $text -replace '\\section\(([^\r\n\)]*)\)', '\section{$1}'

$lines = $text -split "`r?`n"
$macros = @{}
$output = New-Object System.Collections.Generic.List[string]
$envStack = New-Object System.Collections.Generic.List[string]
$figureBuffer = New-Object System.Collections.Generic.List[string]
$equationBuffer = New-Object System.Collections.Generic.List[string]
$inFigure = $false
$inEquation = $false

foreach ($rawLine in $lines) {
    $rawClean = Strip-Comments $rawLine

    if ($rawClean -match '\\def\\([A-Za-z]+)\{([^}]*)\}') {
        foreach ($match in [regex]::Matches($rawClean, '\\def\\([A-Za-z]+)\{([^}]*)\}')) {
            $macros[$match.Groups[1].Value] = $match.Groups[2].Value
        }
        continue
    }

    if ($rawClean -match '^\s*\\renewcommand' -or $rawClean -match '^\s*\\def\b' -or $rawClean -match '^\s*\{\s*\\def') {
        continue
    }

    $line = Expand-Macros $rawClean $macros

    $line = Expand-Macros $line $macros
    $trim = $line.Trim()

    if ($inFigure) {
        [void]$figureBuffer.Add($line)
        if ($trim -match '^\\end\{figure\}') {
            foreach ($item in Convert-FigureBlock $figureBuffer.ToArray() $macros $localImages $slideImages) {
                [void]$output.Add($item)
            }
            [void]$output.Add('')
            $figureBuffer.Clear()
            $inFigure = $false
        }
        continue
    }

    if ($inEquation) {
        [void]$equationBuffer.Add($line)
        if ($trim -match '^\\end\{equation\}') {
            foreach ($item in Convert-EquationBlock $equationBuffer.ToArray()) {
                [void]$output.Add($item)
            }
            [void]$output.Add('')
            $equationBuffer.Clear()
            $inEquation = $false
        }
        continue
    }

    if ($trim -eq '') {
        [void]$output.Add('')
        continue
    }

    if ($trim -match '^\\begin\{figure\}') {
        $inFigure = $true
        [void]$figureBuffer.Add($line)
        continue
    }

    if ($trim -match '^\\begin\{equation\}') {
        $inEquation = $true
        [void]$equationBuffer.Add($line)
        continue
    }

    if ($trim -match '^\\begin\{itemize\}') {
        [void]$envStack.Add('itemize')
        continue
    }

    if ($trim -match '^\\begin\{enumerate\}') {
        [void]$envStack.Add('enumerate')
        continue
    }

    if ($trim -match '^\\end\{itemize\}' -or $trim -match '^\\end\{enumerate\}') {
        if ($envStack.Count -gt 0) { $envStack.RemoveAt($envStack.Count - 1) }
        [void]$output.Add('')
        continue
    }

    if ($trim -match '^\\item\s*(.*)$') {
        $itemText = Clean-Inline $matches[1]
        $marker = if ($envStack.Count -gt 0 -and $envStack[$envStack.Count - 1] -eq 'enumerate') { '1.' } else { '-' }
        [void]$output.Add($marker + ' ' + $itemText)
        continue
    }

    if ($trim -match '^\\(chapter|section|subsection|subsubsection)\{(.+?)\}(.*)$') {
        $kind = $matches[1]
        $title = Clean-Inline $matches[2]
        $rest = $matches[3]
        $label = ''
        $labelMatch = [regex]::Match($rest, '\\label\{([^}]+)\}')
        if ($labelMatch.Success) { $label = $labelMatch.Groups[1].Value }
        $prefix = switch ($kind) {
            'chapter' { '#' }
            'section' { '##' }
            'subsection' { '###' }
            default { '####' }
        }
        [void]$output.Add($prefix + ' ' + $title)
        if ($label -ne '') {
            [void]$output.Add('')
            [void]$output.Add('<!-- label: ' + $label + ' -->')
        }
        [void]$output.Add('')
        continue
    }

    if ($trim -match '^\\(centering|small|newpage|minitoc|noindent|hline|renewcommand)\b') { continue }
    if ($trim -match '^\\(subfigure|includegraphics|caption|label)\b') { continue }
    if ($trim -match '^\\(begin|end)\{(aligned|gathered|scope|tikzpicture)\}') {
        [void]$output.Add($trim)
        continue
    }
    if ($trim -match '^\{\s*$' -or $trim -match '^\}\s*$') { continue }

    $cleanLine = Clean-Inline $line
    if ($cleanLine -ne '') {
        [void]$output.Add($cleanLine)
    }
}

$finalLines = New-Object System.Collections.Generic.List[string]
$previousBlank = $false
foreach ($line in $output) {
    $isBlank = [string]::IsNullOrWhiteSpace($line)
    if ($isBlank -and $previousBlank) { continue }
    [void]$finalLines.Add($line)
    $previousBlank = $isBlank
}

[System.IO.File]::WriteAllLines($outPath, $finalLines, $enc)