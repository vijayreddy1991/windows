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

# Gradle
$GRADLE_VERSION = "6.0.1"
Install-ChocoPackage  -package gradle -options --version=$GRADLE_VERSION

# Maven
$APACHE_MAVEN = "3.6.3"
Install-ChocoPackage  -package maven -options --version=$APACHE_MAVEN

# Ant
$APACHE_ANT = "1.10.7"
$ANT_DOWNLOAD_URL = "http://ftp.heanet.ie/mirrors/www.apache.org/dist//ant/binaries/apache-ant-$APACHE_ANT-bin.zip"
$ANT_DOWNLOAD_SHA = "4afbf7d474b38da07992e820f22f2979e28fa8db71997ccb8ee63fe5cb32478fe26e1675feabb70321af24f25a37747c0f6d198a9e43ba747b65e3f8076f3dff"

Write-Output "Downloading Ant $APACHE_ANT"
Invoke-WebRequest $ANT_DOWNLOAD_URL -OutFile Ant.zip

if ((Get-FileHash Ant.zip -Algorithm sha512).Hash -ne $ANT_DOWNLOAD_SHA) {
  Write-Output 'CHECKSUM VERIFICATION FAILED!'
  exit 1
} else {
  Write-Output 'Verified checksum'
}

Write-Output "Installing Ant $APACHE_ANT"

Expand-Archive Ant.zip -DestinationPath C:\
Remove-Item -Force Ant.zip

# Update the system path
$oldSysPath = (Get-Itemproperty -path 'hklm:\system\currentcontrolset\control\session manager\environment' -Name Path).Path
$newSysPath = $oldSysPath + ";C:\apache-ant-1.10.7\bin;"
Set-ItemProperty -path 'hklm:\system\currentcontrolset\control\session manager\environment' -Name Path -Value $newSysPath

Set-ItemProperty -path 'hklm:\system\currentcontrolset\control\session manager\environment' -Name ANT_HOME -Value "C:\apache-ant-1.10.7"


# Java
$JAVA_VERSION = "8.232.9"
Install-ChocoPackage  -package openjdk8 -options --version=$JAVA_VERSION
