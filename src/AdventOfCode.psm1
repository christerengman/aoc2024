function Get-Input {
  param (
    [int]$Day
  )

  $path = Join-Path $PSScriptRoot ('../input/{0:d2}.txt' -f $Day)

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

function Get-Answer03 {
  $a1 = 0
  $re1 = [regex]::new('mul\(([0-9]+),([0-9]+)\)')

  $s = (Get-Input -Day 3) -join ''
  $re1.Matches($s) | ForEach-Object {
    $x = [int]$_.Groups[1].Value
    $y = [int]$_.Groups[2].Value
    $a1 += $x * $y
  }

  $a2 = 0
  $re2 = [regex]::new("don't\(\).*?(do\(\)|$)")
  $s2 = $re2.Replace($s, '')
  $re1.Matches($s2) | ForEach-Object {
    $x = [int]$_.Groups[1].Value
    $y = [int]$_.Groups[2].Value
    $a2 += $x * $y
  }

  return $a1, $a2
}

function Get-Answer04 {
  $i = Get-Input -Day 4
  $sep = '[\w,]'
  $south = $i[0].Length
  $southeast = $south + 1
  $southwest = $south - 1

  $s = $i -join ','

  return (
    (
      @(
        'XMAS' # ➡️
        'SAMX' # ⬅️
        "(?=X$sep{$south}M$sep{$south}A$sep{$south}S)" # ⬇️
        "(?=S$sep{$south}A$sep{$south}M$sep{$south}X)" # ⬆️
        "(?=X$sep{$southeast}M$sep{$southeast}A$sep{$southeast}S)" # ↘️
        "(?=S$sep{$southeast}A$sep{$southeast}M$sep{$southeast}X)" # ↖️
        "(?=X$sep{$southwest}M$sep{$southwest}A$sep{$southwest}S)" # ↙️
        "(?=S$sep{$southwest}A$sep{$southwest}M$sep{$southwest}X)" # ↗️
      ) | ForEach-Object { [regex]::Matches($s, $_).Count } | Measure-Object -Sum | Select-Object -ExpandProperty Sum
    ),
    (
      @(
        "(?=M\wM$sep{$southwest}A$sep{$southwest}S\wS)" # M M
        "(?=S\wM$sep{$southwest}A$sep{$southwest}S\wM)" # S M
        "(?=S\wS$sep{$southwest}A$sep{$southwest}M\wM)" # S S
        "(?=M\wS$sep{$southwest}A$sep{$southwest}M\wS)" # M S
      ) | ForEach-Object { [regex]::Matches($s, $_).Count } | Measure-Object -Sum | Select-Object -ExpandProperty Sum
    )
  )
}

function Get-Answer05 {
  $a1 = $a2 = 0
  $rules = @{}

  Get-Input -Day 5 | ForEach-Object {
    $x, $y = $_ -split '\|'
    if ($y) {
      $rules[$x] += , $y
    }
    $pages = $_ -split ','
    if ($pages.Length -gt 1) {
      for ($i = 0; $i -lt $pages.Count - 1; $i++) {
        $page = $pages[$i]
        $nextPage = $pages[$i + 1]
        if ($rules[$page] -notcontains $nextPage) {
          # Incorrect order - fix it!
          $ordered = $pages.Clone()
          for ($j = 0; $j -lt $ordered.Count - 1; ) {
            $p = $ordered[$j]
            $np = $ordered[$j + 1]
            if ($rules[$p] -notcontains $np) {
              $t = $p
              $ordered[$j] = $np
              $ordered[$j + 1] = $t
              $j = 0
            }
            else {
              $j++
            }
          }
          $a2 += $ordered[($ordered.Count - 1) / 2]

          return
        }
      }
      $a1 += $pages[($pages.Count - 1) / 2]
    }
  }

  return $a1, $a2
}

function Get-Answer06 {
  $data = Get-Input -Day 6
  $width = $data[0].Length
  $wall = '|'
  $track = 'X'
  $obstruction = '#'
  $dirs = [ordered]@{
    '^' = - ($width + $wall.Length)
    '>' = 1
    'v' = $width + $wall.Length
    '<' = -1
  }
  $player = [regex]::new('[\^>v<]')

  $a2 = 0
  for ($i = -1; $i -lt $board.Length; $i++) {
    $board = ($data -join $wall).ToCharArray()
    $history = [char[]]::new($board.Length)

    if ($i -gt -1) {
      if ($board[$i] -in ($dirs.Keys + $wall + $obstruction)) {
        continue
      }
      $board[$i] = $obstruction
    }

    $pos = $player.Match([string]::new($board))
    $index = $pos.Index
    $dir = $pos.Value
    while ($true) {
      $newIndex = $index + $dirs[$dir]

      # Stop if caught in a loop
      if ($history[$index] -eq $dir) {
        $a2++

        break
      }

      # Stop if leaving the board
      if ($board[$newIndex] -eq $wall -or $newIndex -lt 0 -or $newIndex -ge $board.Length) {
        $board[$index] = $track
        break
      }

      # Turn on obstruction
      if ($board[$newIndex] -eq $obstruction) {
        $newDir = $dirs.Keys[($dirs.Keys.IndexOf($dir) + 1) % 4]
        $board[$index] = $newDir
        $dir = $newDir

        continue
      }

      # Move
      $board[$newIndex] = $dir

      # Track
      $board[$index] = $track
      $history[$index] = $dir

      $index = $newIndex
    }
    if ($i -eq -1) {
      $a1 = ($board | Group-Object | Where-Object Name -eq $track).Count
    }
  }

  return $a1, $a2
}

function Get-Answer07 {

  function Find-Result {
    param (
      [decimal]$result,
      [decimal[]]$numbers,
      [string[]]$ops,
      [decimal]$expected
    )

    if ($result -gt $expected) {
      return
    }

    if ($numbers.Length -eq 0) {
      if ($result -eq $expected) {
        return $result
      }
      else {
        return
      }
    }

    $first, $rest = $numbers

    $params = @{
      numbers  = $rest
      ops      = $ops
      expected = $expected
    }

    switch ($ops) {
      '*' { Find-Result @params -result ($result * $first) }
      '+' { Find-Result @params -result ($result + $first) }
      '||' { Find-Result @params -result ([decimal]"$result$first") }
    }
  }

  $funcDef = ${function:Find-Result}.ToString()

  Get-Input -Day 7 |
  ForEach-Object {
    $testValue, $numStr = $_ -split ': '
    [PSCustomObject]@{
      TestValue = [decimal] $testValue
      Numbers   = ($numStr -split ' ').ForEach({ [decimal] $_ })
    }
  } |
  ForEach-Object -ThrottleLimit 1000 -Parallel {
    ${function:Find-Result} = $using:funcDef
    $first, $rest = $_.Numbers
    [PSCustomObject]@{
      A = Find-Result -result $first -numbers $rest -ops @('*', '+') -expected $_.TestValue | Select-Object -Unique
      B = Find-Result -result $first -numbers $rest -ops @('*', '+', '||') -expected $_.TestValue | Select-Object -Unique
    }
  } |
  Measure-Object -Sum -Property A, B |
  Select-Object -ExpandProperty Sum
}

function Get-Answer08 {
  $lines = Get-Input -Day 8
  $width = $lines[0].Length
  $map = $lines -join ''
  $nodes1 = , '.' * $map.Length
  $nodes2 = , '.' * $map.Length

  $antennas = [regex]::new('\w').Matches($map)

  # Loop through all antennas
  foreach ($a in $antennas) {
    $f = $a.Value
    $i = $a.Index
    $x1 = $i % $width
    $y1 = [math]::Truncate($i / $width)

    # Find matching antennas with same frequency
    foreach ($b in $antennas.Where({ $_.Value -ceq $f -and $_.Index -ne $i })) {
      $j = $b.Index
      $x2 = $j % $width
      $y2 = [math]::Truncate($j / $width)

      $dx = $x2 - $x1
      $dy = $y2 - $y1

      # Find all antinodes on the line between the antennas (in one direction)
      $n = 0;
      $isOnMap = $true
      do {
        $x3 = $x1 + $n * $dx
        $y3 = $y1 + $n * $dy

        if ($x3 -ge 0 -and $x3 -lt $width -and $y3 -ge 0 -and $y3 -lt $width) {
          $k = $y3 * $width + $x3
          if ($n -eq 2) {
            $nodes1[$k] = '#'
          }

          $nodes2[$k] = '#'
        }
        else {
          $isOnMap = $false
        }
        $n++;
      } while ($isOnMap)
    }
  }

  return (
    $nodes1.Where({ $_ -eq '#' }).Count,
    $nodes2.Where({ $_ -eq '#' }).Count
  )
}

function Get-Answer09 {
  $map = Get-Input -Day 9
  $blocks = $map -split '(\d)' -ne '' | ForEach-Object { $Script:i = 0 } { , ($i % 2 -eq 0 ? $i / 2 : '.') * [int]$_; $i++ }

  for ($i = $blocks.Count - 1; $i -ge 0; $i--) {
    $j = [array]::IndexOf($blocks, '.')
    if ($j -gt $i) {
      break
    }

    # Move
    $block = $blocks[$i]
    $blocks[$i] = '.'
    $blocks[$j] = $block
  }

  $checksum = 0
  for ($i = 0; $i -lt $blocks.Count; $i++) {
    if ($blocks[$i] -eq '.') {
      continue
    }
    $checksum += $i * $blocks[$i]
  }

  return $checksum
}
