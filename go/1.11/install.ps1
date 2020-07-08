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
$GOVER = "1.11.13"
$GO_DOWNLOAD_URL = "https://dl.google.com/go/go$GOVER.windows-amd64.zip"
$GO_DOWNLOAD_SHA = "55752de84439d0ed744ad681ae0915314516e69091fb86cab9701628ce3a65ff"

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

$CGO_ENABLED = 0

Write-Output "Installing Go Tools"
go install -a std
go get -u github.com/tools/godep

Write-Output "Installations complete"
