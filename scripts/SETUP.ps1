$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
function Run-Checked { param([string]$exe,[string[]]$arguments); & $exe @arguments; if($LASTEXITCODE -ne 0){throw "$exe failed ($LASTEXITCODE)"} }
foreach($cmd in @('git','node','npm','flutter')){if(-not (Get-Command $cmd -ErrorAction SilentlyContinue)){throw "Install $cmd first"}}
Copy-Item "$root\contracts\modules.json" "$root\mobile\assets\modules.json" -Force
Push-Location "$root\web"
try {if(Test-Path package-lock.json){Run-Checked npm @('ci')}else{Run-Checked npm @('install')}; Run-Checked npm @('test'); Run-Checked npm @('run','build')} finally {Pop-Location}
& "$PSScriptRoot\PREPARE_MOBILE.ps1"
Write-Host 'Setup complete. Configure only the new DODO Supabase project. No remote mutation has been performed.'
