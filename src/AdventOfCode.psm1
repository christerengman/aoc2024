function Get-Input {
    param (
        [int]$Day
    )

    $path = Join-Path $PSScriptRoot ("../input/{0:d2}.txt" -f $Day)

    return Get-Content $path
}

function Get-Answer01 {
    [int[]] $a = @()
    [int[]] $b = @()

    Get-Input -Day 1 | ForEach-Object {
        $x, $y = $_ -split ' +'
        $a += $x
        $b += $y
    }

    $a = $a | Sort-Object
    $b = $b | Sort-Object

    $d = 0
    $s = 0
    for ($i = 0; $i -lt $a.Count; $i++) {
        $x = $a[$i]
        $d += [math]::Abs($x - $b[$i])
        $s += $x * [array]::FindAll($b, [Predicate[int]] { $args[0] -eq $x }).Count
    }

    return $d, $s
}

function Get-Answer02 {
    $a1 = $a2 = 0
    Get-Input -Day 2 |
    ForEach-Object {
        [System.Collections.ArrayList]$y = $_ -split ' '

        :outer for ($j = -1; $j -lt $y.Count; $j++) {
            $x = $y.Clone()
            if ($j -ge 0) {
                $x.RemoveAt($j)
            }
            $prevDiff = 0
            for ($i = 1; $i -lt $x.Count; $i++) {
                $diff = $x[$i] - $x[$i - 1]
                if ($prevDiff * $diff -lt 0 -or $diff -eq 0 -or [Math]::Abs($diff) -gt 3 ) {
                    continue outer
                }
                $prevDiff = $diff
            }
            if ($j -eq -1) {
                $a1++
            }
            $a2++
            break
        }
    }

    return $a1, $a2
}
