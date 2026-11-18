$ErrorActionPreference='Stop'
Set-Location (Split-Path -Parent $PSScriptRoot)
npm run dev
if($LASTEXITCODE -ne 0){throw 'Web developer server failed'}
