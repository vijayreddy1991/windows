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

echo "======================= Installing mingw-get ======================"

# MinGW
$MINGWGET_DOWNLOAD_URL = "https://osdn.net/projects/mingw/downloads/68260/mingw-get-0.6.3-mingw32-pre-20170905-1-bin.zip"
$MINGWGET_DOWNLOAD_SHA = "2ab8efd7c7d1fc8eaf8b2fa4da4eef8f3e47768284c021599bc7435839a046df"

Write-Output "Downloading mingw-get"
Invoke-WebRequest $MINGWGET_DOWNLOAD_URL -OutFile mingw-get.zip -UseBasicParsing -UserAgent "curl/7.37.0"
if ((Get-FileHash mingw-get.zip -Algorithm sha256).Hash -ne $MINGWGET_DOWNLOAD_SHA) {
  Write-Output 'CHECKSUM VERIFICATION FAILED!'
  exit 1
} else {
  Write-Output 'Verified checksum'
}

Expand-Archive mingw-get.zip -DestinationPath  C:\MinGW
Remove-Item -Force mingw-get.zip

# Update the system path
$oldSysPath = (Get-Itemproperty -path 'hklm:\system\currentcontrolset\control\session manager\environment' -Name Path).Path
$newSysPath = $oldSysPath + ";C:\MinGW\bin;"
Set-ItemProperty -path 'hklm:\system\currentcontrolset\control\session manager\environment' -Name Path -Value $newSysPath

# Update the current path
$env:Path += ";C:\MinGW\bin;"

echo "======================= Installing gcc 9.2.* ======================"
mingw-get install gcc="9.2.*" g++="9.2.*"
gcc --version


echo "=================== Install packages for cpp ======================"
mingw-get install mingw32-make

# CLANG
$LLVM_VERSION = "8.0.0"
Install-ChocoPackage  -package llvm -options --version=$LLVM_VERSION

refreshenv
clang --version

Write-Output "============= Installations complete ==========="
