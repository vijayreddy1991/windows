$ErrorActionPreference = "Stop"

Set-ExecutionPolicy Bypass -Scope Process -Force

$env:chocolateyUseWindowsCompression = 'true'
$env:ChocolateyInstall = Convert-Path "$((Get-Command choco).path)\..\.."
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"

choco config set --name="'stopOnFirstPackageFailure'" --value="'true'"

function Write-PackageInstall($package) {
  Write-Output ""
  Write-Output "----------------------------------------------"
  Write-Output "Installing $package"
  Write-Output "----------------------------------------------"
  Write-Output ""
}
function Install-ChocoPackage($package, $options) {
  Write-PackageInstall $package
  choco install -y $package $options
  if ($LastExitCode -ne 0) {
     throw 'Error installing with Chocolatey'
  }
}

# .NET SDK
$DOTNET_SDK_VERSION = "3.1.102"
Install-ChocoPackage  -package dotnetcore-sdk -options --version=$DOTNET_SDK_VERSION
