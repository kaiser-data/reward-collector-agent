# Opens dashboard.html filled in with this agent's run logs and newest grades. Windows twin of dashboard.sh.
# Type it yourself in Claude Code:
#
#   ! powershell -ExecutionPolicy Bypass -File .claude/dashboard.ps1
#
# Claude Code keeps one run log per session in %USERPROFILE%\.claude\projects\<this folder's path, every
# character other than a letter or digit turned into ->. This finds that folder, every grades.md under
# drafts\tests and the checklists in drafts\tests\checklists, and writes a copy of dashboard.html with
# them inside to your temp folder, outside this folder, so the logs can never be pushed with it.
# Nothing leaves your laptop.

$here = Split-Path -Parent $PSScriptRoot
$config = if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR } else { Join-Path $HOME ".claude" }
$projects = Join-Path $config "projects"
$logs = Join-Path $projects ($here -replace '[^A-Za-z0-9]', '-')
# Not under that name: find the logs that say they ran in this folder (JSON writes each \ as \\).
if (-not (Test-Path $logs)) {
  $cwd = '"cwd":"' + $here.Replace('\', '\\') + '"'
  $found = Get-ChildItem (Join-Path $projects "*\*.jsonl") -ErrorAction SilentlyContinue |
    Select-String -SimpleMatch -List $cwd | Select-Object -First 1
  if ($found) { $logs = Split-Path -Parent $found.Path }
}
if (-not (Test-Path $logs)) {
  Write-Output "No run logs for $here yet. Run one of your jobs in Claude Code here first, then type this again."
  exit 1
}
$grades = @(Get-ChildItem (Join-Path $here "drafts\tests") -Recurse -Filter grades.md -ErrorAction SilentlyContinue)
$checklists = @(Get-ChildItem (Join-Path $here "drafts\tests\checklists\case-*.md") -ErrorAction SilentlyContinue)
$newest = $grades | Sort-Object LastWriteTime -Descending | Select-Object -First 1
$out = Join-Path ([IO.Path]::GetTempPath()) "my-agent-dashboard.html"
$marker = "<!-- dashboard.sh puts the run logs and grades here -->"

# One file as a block the page reads and never runs. Every "<" becomes the JSON escape backslash-u003c
# (built from two pieces below), so nothing in a file can end the block; in a log's JSON that is the same
# character, and the page turns it back for the grades.
$escaped = '\' + 'u003c'
function Block($attr, $name, $path) {
  $text = [IO.File]::ReadAllText($path).Replace('<', $escaped)
  "<script type=`"text/plain`" $attr=`"$name`">`n$text`n</script>`n"
}

$page = [IO.File]::ReadAllText((Join-Path $here "dashboard.html"))
$at = $page.IndexOf($marker) + $marker.Length
$logFiles = @(Get-ChildItem (Join-Path $logs "*.jsonl")) + @(Get-ChildItem (Join-Path $logs "*\subagents\*.jsonl"))
$filled = @(foreach ($f in $logFiles) {
  Block "data-log" ("logs/" + $f.FullName.Substring($logs.Length + 1).Replace('\', '/')) $f.FullName
}) + @(foreach ($g in $grades) {
  Block "data-grades" ($g.FullName.Substring($here.Length + 1).Replace('\', '/') -replace '["<>&]', '') $g.FullName
}) + @(foreach ($c in $checklists) {
  Block "data-checklist" ($c.FullName.Substring($here.Length + 1).Replace('\', '/') -replace '["<>&]', '') $c.FullName
})
[IO.File]::WriteAllText($out, $page.Substring(0, $at) + "`n" + ($filled -join "") + $page.Substring($at))

Write-Output "Run logs: $logs"
Write-Output ("Newest grades: " + $(if ($newest) { $newest.FullName } else { "none yet (step C4 makes them)" }))
Start-Process $out
