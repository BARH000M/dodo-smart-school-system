param([ValidateSet('debug','release')][string]$Mode='debug',[switch]$Bundle)
$ErrorActionPreference='Stop'
$root=Split-Path -Parent $PSScriptRoot
$cfg="$root\mobile\config\live.json"
if(!(Test-Path $cfg)){throw 'Run CONFIGURE_BACKEND.ps1 first.'}
if($Bundle -and $Mode -ne 'release'){throw 'AAB requires release mode.'}
if($Mode -eq 'release'){throw 'Release signing is not yet implemented. Follow docs/deployment/ANDROID_RELEASE.md and update this gate after verified signing.'}
Push-Location "$root\mobile"
try {
 if(!(Test-Path 'android')){throw 'Run SETUP.ps1 to generate Flutter native project first'}
 $format=if($Bundle){'appbundle'}else{'apk'}
 & flutter build $format "--$Mode" '--dart-define-from-file=config/live.json';if($LASTEXITCODE -ne 0){throw 'Android build failed'}
 if($Bundle){Get-Item 'build\app\outputs\bundle\release\app-release.aab'}else{Get-Item "build\app\outputs\flutter-apk\app-$Mode.apk"}
} finally {Pop-Location}
