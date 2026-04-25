$ErrorActionPreference = 'Stop'

$path = 'd:\github_lianxh\dsfin\Lecture\ml_lasso\Lasso_lec.qmd'
$enc = [System.Text.UTF8Encoding]::new($false)
$lines = [System.IO.File]::ReadAllLines($path, $enc)
$out = New-Object System.Collections.Generic.List[string]

$i = 0
while ($i -lt $lines.Length) {
    $line = $lines[$i]
    $trim = $line.Trim()

    $line = [regex]::Replace($line, '\{\\color\{[^}]+\}\{([^}]*)\}\}', '$1')
    $line = [regex]::Replace($line, '^\s*\$\\circ\$\s*', '- ')
    $line = [regex]::Replace($line, '\s*\($', '')
    $trim = $line.Trim()

    if ($trim -match '^(\\def|\\renewcommand|\{\s*\\def)') {
        $i++
        continue
    }

    if ($line.Contains('^[')) {
        $current = $line.Replace('^[', ' (').TrimEnd()
        $i++
        $parts = New-Object System.Collections.Generic.List[string]

        while ($i -lt $lines.Length) {
            $next = $lines[$i]
            $nextTrim = $next.Trim()
            if ($nextTrim -eq '') {
                break
            }
            if ($nextTrim.StartsWith('#')) {
                break
            }
            if ($nextTrim.StartsWith('![](')) {
                break
            }
            if ($nextTrim -match '^(\\def|\\renewcommand|\{\s*\\def)') {
                $i++
                continue
            }
            [void]$parts.Add($nextTrim)
            $i++
        }

        if ($parts.Count -gt 0) {
            $current = ($current + ' ' + (($parts -join ' ').Trim()) + ')').Trim()
        }
        else {
            $current = ($current + ')').Trim()
        }

        [void]$out.Add($current)
        continue
    }

    [void]$out.Add($line)
    $i++
}

$final = New-Object System.Collections.Generic.List[string]
$prevBlank = $false
foreach ($entry in $out) {
    $isBlank = [string]::IsNullOrWhiteSpace($entry)
    if ($isBlank -and $prevBlank) {
        continue
    }
    [void]$final.Add($entry)
    $prevBlank = $isBlank
}

[System.IO.File]::WriteAllLines($path, $final, $enc)