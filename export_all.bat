
powershell -Command "New-Item -ItemType Directory -Force build | Out-Null; gci -r -inc *.java,*.jsp,*.js,*.css,README.md | Where-Object { $_.FullName -notmatch '\\build\\' } | ForEach-Object { '`n===== ' + $_.FullName + ' =====`n'; Get-Content -Encoding UTF8 $_ } | Out-File -Encoding UTF8 build\all.txt"
