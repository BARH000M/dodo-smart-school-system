param([Parameter(Mandatory=$true)][string]$OutputDirectory,[switch]$ApprovedDisposableOrDodo)
$ErrorActionPreference='Stop'
if(!$ApprovedDisposableOrDodo){throw 'Confirm approved DODO database; never back up unrelated projects.'}
if(!$env:DODO_DATABASE_URI){throw 'Set DODO_DATABASE_URI securely in this PowerShell session; do not commit it.'}
if(!(Get-Command pg_dump -ErrorAction SilentlyContinue)){throw 'Install PostgreSQL client tools first.'}
New-Item -ItemType Directory -Path $OutputDirectory -Force|Out-Null
$out=Join-Path $OutputDirectory ("dodo-$(Get-Date -Format yyyyMMdd-HHmmss).dump")
& pg_dump --dbname=$env:DODO_DATABASE_URI --format=custom --no-owner --no-acl --file=$out
if($LASTEXITCODE -ne 0){throw 'Backup failed'}
& pg_restore --list $out | Out-Null
if($LASTEXITCODE -ne 0){throw 'Archive unreadable'}
Get-Item $out
Write-Host 'Archive reads successfully; restoration has NOT been tested. Protect this file.'
