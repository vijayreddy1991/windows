$ErrorActionPreference = "Stop"

Set-ExecutionPolicy Bypass -Scope Process -Force

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

Write-Output "Installing mingw-get"

Expand-Archive mingw-get.zip -DestinationPath  C:\MinGW
Remove-Item -Force mingw-get.zip

# Update the system path
$oldSysPath = (Get-Itemproperty -path 'hklm:\system\currentcontrolset\control\session manager\environment' -Name Path).Path
$newSysPath = $oldSysPath + ";C:\MinGW\bin;"
Set-ItemProperty -path 'hklm:\system\currentcontrolset\control\session manager\environment' -Name Path -Value $newSysPath

# Update the current path
$env:Path += ";C:\MinGW\bin;"

Write-Output "Installing gcc"
mingw-get install gcc

# Go
$GOVER = "1.13.7"
$GO_DOWNLOAD_URL = "https://dl.google.com/go/go$GOVER.windows-amd64.zip"
$GO_DOWNLOAD_SHA = "03befd335ee9ddf1d10cae52e84eb5a37408b8e105acc1c29e30bbbbd8143749"

Write-Output "Downloading Go $GOVER"
Invoke-WebRequest $GO_DOWNLOAD_URL -OutFile Go.zip

if ((Get-FileHash Go.zip -Algorithm sha256).Hash -ne $GO_DOWNLOAD_SHA) {
  Write-Output 'CHECKSUM VERIFICATION FAILED!'
  exit 1
} else {
  Write-Output 'Verified checksum'
}

Write-Output "Installing Go $GOVER"

Expand-Archive Go.zip -DestinationPath C:\
Remove-Item -Force go.zip

# Update the system path
$oldSysPath = (Get-Itemproperty -path 'hklm:\system\currentcontrolset\control\session manager\environment' -Name Path).Path
$newSysPath = $oldSysPath + ";C:\Go\bin;"
Set-ItemProperty -path 'hklm:\system\currentcontrolset\control\session manager\environment' -Name Path -Value $newSysPath

# Update the current path
$env:Path += ";C:\Go\bin;"

Write-Output "Installing Go Tools"
go install -a std
go get -u github.com/tools/godep

Write-Output "Installations complete"
