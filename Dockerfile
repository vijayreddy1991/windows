FROM mcr.microsoft.com/windows/servercore:ltsc2019
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ADD ./install.ps1 C:/Users/ContainerAdministrator/AppData/Local/Temp
RUN C:/Users/ContainerAdministrator/AppData/Local/Temp/install.ps1
