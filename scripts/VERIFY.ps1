$ErrorActionPreference='Stop'
$root=Split-Path -Parent $PSScriptRoot
function Check([string]$exe,[string[]]$argsList){ & $exe @argsList; if($LASTEXITCODE -ne 0){throw "$exe failed ($LASTEXITCODE)"} }
Push-Location $root
try { Check node @('--test','scripts/contracts.test.mjs'); Check npm @('run','build') } finally {Pop-Location}
Push-Location "$root\mobile"
try {Check flutter @('analyze'); Check flutter @('test')} finally {Pop-Location}
