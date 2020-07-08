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

# NVM - Note: This installs a more recent version of nvm.portable than $NVM_VERSION.
$NVM_VERSION = "1.1.5"
Install-ChocoPackage  -package nvm -options --version=$NVM_VERSION

refreshenv

# NodeJS
$NODE_VERSION = "8.17.0"
nvm install $NODE_VERSION
nvm use $NODE_VERSION
