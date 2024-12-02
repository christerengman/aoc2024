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
