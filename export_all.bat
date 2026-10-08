
powershell -Command "gci -r -inc *.java,*.jsp,*.js,*.css,README.md | ForEach-Object { '`n===== ' + $_.FullName + ' =====`n'; Get-Content -Encoding UTF8 $_ } | Out-File -Encoding UTF8 all.txt"