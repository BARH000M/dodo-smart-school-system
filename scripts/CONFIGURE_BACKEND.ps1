param([Parameter(Mandatory=$true)][string]$ProjectRef,[Parameter(Mandatory=$true)][string]$PublishableKey,[switch]$Overwrite)
$ErrorActionPreference='Stop'
if($ProjectRef -notmatch '^[a-z0-9]{20}$'){throw 'Use the exact new DODO project reference.'}
if(@('aeryusbrulqdxjdynwfh','tvkohamtxrkppwcfsuex','mgibjusuglafbnlrkbep') -contains $ProjectRef){throw 'SAI backend references are forbidden for DODO.'}
if($PublishableKey -notmatch '^sb_publishable_[A-Za-z0-9_-]+$'){throw 'Use a publishable key, not a secret or service-role key.'}
$root=Split-Path -Parent $PSScriptRoot
$web=Join-Path $root 'web\.env.local';$mobile=Join-Path $root 'mobile\config\live.json';$target=Join-Path $root 'supabase\target.local.json'
foreach($f in @($web,$mobile,$target)){if((Test-Path $f) -and -not $Overwrite){throw "File already exists: $f. Review it before using -Overwrite."}}
$url="https://$ProjectRef.supabase.co"
$enc=[Text.UTF8Encoding]::new($false)
[IO.File]::WriteAllText($web,"VITE_SUPABASE_URL=$url`nVITE_SUPABASE_PUBLISHABLE_KEY=$PublishableKey`n",$enc)
[IO.File]::WriteAllText($mobile,(@{SUPABASE_URL=$url;SUPABASE_PUBLISHABLE_KEY=$PublishableKey}|ConvertTo-Json),$enc)
[IO.File]::WriteAllText($target,(@{project_ref=$ProjectRef}|ConvertTo-Json),$enc)
Write-Host 'Local configuration written. No remote changes.'
