$ErrorActionPreference = "Stop"

# Install choco
Set-ExecutionPolicy Bypass -Scope Process -Force
$env:chocolateyUseWindowsCompression = 'true'
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

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

# Installing Python 3
Install-ChocoPackage python3

refreshenv

Write-PackageInstall pip
python -m ensurepip
python -m pip install --upgrade pip

Write-PackageInstall virtualenv
python -m pip install -q virtualenv==20.0.25

Write-PackageInstall pyOpenSSL
python -m pip install -q pyOpenSSL==19.1.0

# Installing Git
$GIT_VERSION = "2.27.0"
Install-ChocoPackage  -package git -options --version=$GIT_VERSION
Update-SessionEnvironment

# Google Cloud SDK
$CLOUD_SDKREPO = "298.0.0"

Write-PackageInstall gcloud
(New-Object Net.WebClient).DownloadFile("https://storage.googleapis.com/cloud-sdk-release/google-cloud-sdk-$CLOUD_SDKREPO-windows-x86_64.zip", "$env:Temp\google-cloud-sdk.zip")
Expand-Archive -Path $env:Temp\google-cloud-sdk.zip -DestinationPath "C:\Program Files (x86)\Google\Cloud SDK\"
cmd.exe /c "C:\Program Files (x86)\Google\Cloud SDK\google-cloud-sdk\install.bat" --quiet --path-update=false

$oldSysPath = (Get-Itemproperty -path 'hklm:\system\currentcontrolset\control\session manager\environment' -Name Path).Path
$newSysPath = $oldSysPath + ";C:\Program Files (x86)\Google\Cloud SDK\google-cloud-sdk\bin;"

Set-ItemProperty -path 'hklm:\system\currentcontrolset\control\session manager\environment' -Name Path -Value $newSysPath

# AWS CLI
$AWS_VERSION = "2.0.28"
Install-ChocoPackage -package awscli -options --version=$AWS_VERSION

# AWS EB CLI
$AWSEBCLI_VERSION = "3.18.1"
python -m pip install awsebcli=="$AWSEBCLI_VERSION"

# Azure CLI
$AZURE_CLI_VERSION = "2.8.0"
Install-ChocoPackage  -package azure-cli -options --version=$AZURE_CLI_VERSION

# JFrog CLI
$JFROG_VERSION = "1.38.0"
Install-ChocoPackage  -package jfrog-cli -options --version=$JFROG_VERSION

# jq
$JQ_VERSION = "1.6"
Install-ChocoPackage  -package jq -options --version=$JQ_VERSION

# Kubernetes CLI
$KUBECTL_VERSION = "1.18.5"
Install-ChocoPackage  -package kubernetes-cli -options --version=$KUBECTL_VERSION

# Helm
$HELM3_VERSION = "3.2.4"
Install-ChocoPackage  -package kubernetes-helm -options --version=$HELM3_VERSION,-m,-force
[Environment]::SetEnvironmentVariable("HELM3_PATH", "C:\ProgramData\chocolatey\lib\kubernetes-helm.$HELM3_VERSION\tools\windows-amd64\helm.exe", [System.EnvironmentVariableTarget]::Machine)

$HELM2_VERSION = "2.16.1"
Install-ChocoPackage  -package kubernetes-helm -options --version=$HELM2_VERSION,-m,-force

# Packer
$PK_VERSION = "1.6.0"
Install-ChocoPackage  -package packer -options --version=$PK_VERSION

# Terraform
$TF_VERSION = "0.12.26"
Install-ChocoPackage  -package terraform -options --version=$TF_VERSION

[Environment]::SetEnvironmentVariable("CLOUDSDK_PYTHON", "C:\Python38\python.exe", [System.EnvironmentVariableTarget]::Machine)
