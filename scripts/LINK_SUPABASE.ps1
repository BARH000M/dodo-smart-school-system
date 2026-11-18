param([switch]$Apply,[string]$ConfirmProjectRef)
$ErrorActionPreference='Stop'
$root=Split-Path -Parent $PSScriptRoot
$cfg=Get-Content "$root\supabase\target.local.json" -Raw|ConvertFrom-Json
$ref=$cfg.project_ref
if($ref -notmatch '^[a-z0-9]{20}$' -or @('aeryusbrulqdxjdynwfh','tvkohamtxrkppwcfsuex','mgibjusuglafbnlrkbep') -contains $ref){throw 'Invalid DODO target'}
if($ConfirmProjectRef -ne $ref){throw 'Explicitly confirm the exact new DODO project ref.'}
Push-Location $root
try {
 & supabase link --project-ref $ref; if($LASTEXITCODE -ne 0){throw 'Link failed'}
 & supabase migration list; if($LASTEXITCODE -ne 0){throw 'Migration list failed'}
 & supabase db push --dry-run; if($LASTEXITCODE -ne 0){throw 'Dry run failed'}
 if($Apply){$approval=Read-Host "Type APPLY-$ref to authorize reviewed migrations";if($approval -ne "APPLY-$ref"){throw 'Not approved'};& supabase db push;if($LASTEXITCODE -ne 0){throw 'Migration failed'}}
} finally {Pop-Location}
