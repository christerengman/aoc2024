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
}