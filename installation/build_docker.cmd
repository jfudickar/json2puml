set EXE='..\source\win64\release\json2puml.exe'
for /f %%i in ('powershell "(Get-Item -path %EXE%).VersionInfo.FileVersion"') do set ver=%%i
echo %ver%

rmdir /s /q ..\docker\src\json2puml\samples
dir ..\docker\src\json2puml\samples\*.* /s
xcopy ..\samples\*.json ..\docker\src\json2puml\samples /s /e /i /y

rmdir /s /q docker
mkdir docker
xcopy ..\docker\* docker /s /e /i /y
copy ..\source\linux64\release\json2puml*. docker\src\json2puml\bin
rmdir /s /q docker\logs
rmdir /s /q docker\output
del docker\.gitignore /s
del docker\.dockerignore /s
del docker\*formatted.json /s
del docker\*.log /s
del docker\*.url /s
cd docker
tar -c -f ..\output\json2puml.docker.%ver%.tar * 
cd ..\output
"c:\Program Files\7-Zip\7z.exe" a -tzip json2puml.docker.%ver%.tar.zip json2puml.docker.%ver%.tar
cd ..


