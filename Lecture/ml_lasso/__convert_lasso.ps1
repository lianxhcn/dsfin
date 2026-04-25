$ErrorActionPreference = 'Stop'

$baseDir = 'd:\github_lianxh\dsfin\Lecture\ml_lasso'
$enc = [System.Text.UTF8Encoding]::new($false)
$srcPath = Join-Path $baseDir 'chp56_Lasso.tex'
$preparedPath = Join-Path $baseDir '__Lasso_src_prepared.tex'
$mainTexPath = Join-Path $baseDir '__Lasso_mainonly.tex'
$mainQmdPath = Join-Path $baseDir '__Lasso_mainonly.qmd'
$draftPath = Join-Path $baseDir 'Lasso_lec.qmd'

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
                    if ($depth -gt 1) {
                        [void]$argBuilder.Append($ch)
                    }
                }
                elseif ($ch -eq '}' -and $prev -ne '\') {
                    $depth--
                    if ($depth -gt 0) {
                        [void]$argBuilder.Append($ch)
                    }
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
                    if ($depth -gt 1) {
                        [void]$arg1Builder.Append($ch)
                    }
                }
                elseif ($ch -eq '}' -and $prev -ne '\') {
                    $depth--
                    if ($depth -gt 0) {
                        [void]$arg1Builder.Append($ch)
                    }
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
                    if ($depth -gt 1) {
                        [void]$arg2Builder.Append($ch)
                    }
                }
                elseif ($ch -eq '}' -and $prev -ne '\') {
                    $depth--
                    if ($depth -gt 0) {
                        [void]$arg2Builder.Append($ch)
                    }
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

$text = [System.IO.File]::ReadAllText($srcPath, $enc)
$text = [regex]::Replace($text, '(?s)\\iffalse.*?\\fi', '')
$text = $text -replace '\\section\(([^\r\n\)]*)\)', '\section{$1}'
$text = $text -replace '\\minitoc', ''
$text = $text -replace '\\setcounter\{minitocdepth\}\{[^}]*\}', ''
$text = $text -replace '\\index\{[^}]*\}', ''

$text = Replace-OneArg $text 'MakeUppercase' { param($arg) $arg }
$text = Replace-OneArg $text 'bfseries' { param($arg) $arg }
$text = Replace-OneArg $text 'texttt' { param($arg) $arg }
$text = Replace-TwoArg $text 'textcolor' { param($color, $label) $label }
$text = Replace-TwoArg $text 'href' { param($url, $label) $label }
$text = Replace-OneArg $text 'footnote' { param($arg) ' (note: ' + ($arg -replace '\s+', ' ').Trim() + ')' }
$text = [regex]::Replace($text, '\\vspace\{[^}]*\}', '')
$text = [regex]::Replace($text, '(?m)^\s*\$\\circ\$\s*\r?\n?', '')
$text = $text -replace '\\small', ''

[System.IO.File]::WriteAllText($preparedPath, $text, $enc)

$preparedLines = [System.IO.File]::ReadAllLines($preparedPath, $enc)
$refIndex = -1
for ($idx = 0; $idx -lt $preparedLines.Length; $idx++) {
    if ($preparedLines[$idx] -match '^\\section\{参考文献\}') {
        $refIndex = $idx
        break
    }
}

if ($refIndex -lt 0) {
    for ($idx = 0; $idx -lt $preparedLines.Length; $idx++) {
        if ($preparedLines[$idx] -match '^Acemoglu, D\., S\. Johnson, and J\. A\. Robinson\.') {
            $refIndex = $idx
            break
        }
    }
}

if ($refIndex -lt 0) {
    throw 'References split marker not found in prepared TeX.'
}

[System.IO.File]::WriteAllLines($mainTexPath, $preparedLines[0..($refIndex - 1)], $enc)

& 'D:\Pandoc\pandoc.exe' --wrap=none --from=latex --to=markdown+tex_math_dollars --output=$mainQmdPath $mainTexPath

$mainContent = [System.IO.File]::ReadAllText($mainQmdPath, $enc).TrimEnd()
$refLines = $preparedLines[($refIndex + 1)..($preparedLines.Length - 1)] |
    Where-Object { $_ -notmatch '^\\small\s*$' }
$refContent = ($refLines -join "`r`n").Trim()

$finalBuilder = New-Object System.Text.StringBuilder
[void]$finalBuilder.AppendLine($mainContent)
[void]$finalBuilder.AppendLine()
[void]$finalBuilder.AppendLine('# References')
[void]$finalBuilder.AppendLine()
[void]$finalBuilder.AppendLine($refContent)

[System.IO.File]::WriteAllText($draftPath, $finalBuilder.ToString(), $enc)