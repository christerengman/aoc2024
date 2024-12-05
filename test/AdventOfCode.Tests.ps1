BeforeAll {
  $ModuleName = "AdventOfCode"
  Import-Module $PSScriptRoot/../src/$ModuleName.psm1 -Force
}

Describe "AdventOfCode" {

  Context "Day 1" {
    It "Should be correct" {
      InModuleScope $ModuleName {
        Mock Get-Input { @'
3   4
4   3
2   5
1   3
3   9
3   3
'@ -split [Environment]::NewLine }

        $a, $b = Get-Answer01
        $a | Should -Be 11
        $b | Should -Be 31
      }
    }
  }

  Context "Day 2" {
    It "Should be correct" {
      InModuleScope $ModuleName {
        Mock Get-Input { @'
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
'@ -split [Environment]::NewLine }

        $a, $b = Get-Answer02
        $a | Should -Be 2
        $b | Should -Be 4
      }
    }
  }

  Context "Day 3" {
    It "Should be correct" {
      InModuleScope $ModuleName {
        Mock Get-Input { @'
xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
'@ }

        $a, $b = Get-Answer03
        $a | Should -Be 161

        Mock Get-Input { @'
xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
'@ }

        $a, $b = Get-Answer03
        $b | Should -Be 48
      }
    }
  }
}

Context "Day 4" {
  It "Should be correct" {
    InModuleScope $ModuleName {
      Mock Get-Input { @'
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
'@ -split [Environment]::NewLine }

      $a, $b = Get-Answer04
      $a | Should -Be 18
      $b | Should -Be 9
    }
  }
}

Context "Day 5" {
  It "Should be correct" {
    InModuleScope $ModuleName {
      Mock Get-Input { @'
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
'@ -split [Environment]::NewLine }

      $a, $b = Get-Answer05
      $a | Should -Be 143
      $b | Should -Be 123
    }
  }
}
