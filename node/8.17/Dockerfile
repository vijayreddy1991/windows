ARG version
FROM jfpip.jfrog.io/jfrog/pipelines-w19:${VERSION}
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN New-Item -Path "C:/Users/ContainerAdministrator/AppData/Local/Temp/" -Name "node" -ItemType "directory"
ADD ./install.ps1 C:/Users/ContainerAdministrator/AppData/Local/Temp/node
RUN C:/Users/ContainerAdministrator/AppData/Local/Temp/node/install.ps1
