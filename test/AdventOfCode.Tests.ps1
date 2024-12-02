BeforeAll {
  $Script:ModuleName = "AdventOfCode"
  Import-Module $PSScriptRoot/../src/$Script:ModuleName.psm1 -Force
}

Describe "AdventOfCode" {
  
  Context "Day 1" {
    It "Should be correct" {
      InModuleScope $Script:ModuleName {
        Mock Get-Input { @'
3   4
4   3
2   5
1   3
3   9
3   3
'@ -split "`n" }

        $a, $b = Get-Answer01
        $a | Should -Be 11
        $b | Should -Be 31
      }
    }
  }

  Context "Day 2" {
    It "Should be correct" {
      InModuleScope $Script:ModuleName {
        Mock Get-Input { @'
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
'@ -split "`n" }

        $a, $b = Get-Answer02
        $a | Should -Be 2
        $b | Should -Be 4
      }
    }
  }
}