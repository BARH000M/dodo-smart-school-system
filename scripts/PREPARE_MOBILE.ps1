$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
function Run-Checked { param([string]$exe,[string[]]$arguments); & $exe @arguments; if($LASTEXITCODE -ne 0){throw "$exe failed ($LASTEXITCODE)"} }
if(-not (Get-Command flutter -ErrorAction SilentlyContinue)){throw 'Install Flutter stable first'}
Copy-Item "$root\contracts\modules.json" "$root\mobile\assets\modules.json" -Force
# Generate native scaffolding in a disposable folder; never overwrite custom Flutter source.
$temp = Join-Path ([IO.Path]::GetTempPath()) ("dodo-scaffold-" + [guid]::NewGuid())
try {
 if((!(Test-Path "$root\mobile\android")) -or (!(Test-Path "$root\mobile\ios"))) {
  Run-Checked flutter @('create','--platforms=android,ios','--org','com.dodo','--project-name','dodo_smart_school_system',$temp)
  foreach($platform in @('android','ios')) {if(!(Test-Path "$root\mobile\$platform")){Copy-Item "$temp\$platform" "$root\mobile\$platform" -Recurse}}
  if(!(Test-Path "$root\mobile\.metadata")){Copy-Item "$temp\.metadata" "$root\mobile\.metadata"}
  $manifest="$root\mobile\android\app\src\main\AndroidManifest.xml"
  $text=[IO.File]::ReadAllText($manifest)
  $text=$text.Replace('android:label="dodo_smart_school_system"','android:label="DODO SMART SCHOOL SYSTEM"')
  if(!$text.Contains('android.permission.INTERNET')){$text=$text.Replace('<application','<uses-permission android:name="android.permission.INTERNET" />' + "`n    <application")}
  [IO.File]::WriteAllText($manifest,$text,[Text.UTF8Encoding]::new($false))
  $plist="$root\mobile\ios\Runner\Info.plist"
  $text=[IO.File]::ReadAllText($plist)
  $text=[regex]::Replace($text,'(<key>CFBundleDisplayName</key>\s*<string>)[^<]*(</string>)','${1}DODO SMART SCHOOL SYSTEM${2}')
  [IO.File]::WriteAllText($plist,$text,[Text.UTF8Encoding]::new($false))
 }
} finally {if(Test-Path $temp){Remove-Item $temp -Recurse -Force}}
Push-Location "$root\mobile"
try {Run-Checked flutter @('pub','get');Run-Checked flutter @('analyze');Run-Checked flutter @('test')} finally {Pop-Location}
Write-Host 'Mobile preparation complete. No remote changes.'
