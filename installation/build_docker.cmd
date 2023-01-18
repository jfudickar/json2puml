set EXE='..\source\win64\release\json2puml.exe'
for /f %%i in ('powershell "(Get-Item -path %EXE%).VersionInfo.FileVersion"') do set ver=%%i
echo %ver%

rmdir /s /q docker
mkdir docker
xcopy ..\docker\* docker /s /e /i /y
copy ..\source\linux64\release\json2puml*. docker\src\json2puml\bin
rmdir /s /q docker\logs
rmdir /s /q docker\output
del docker\.gitignore /s
del docker\*.log /s
del docker\*.url /s
cd output
tar -c -f json2puml.docker.%ver%.tar ..\docker\* 
zip json2puml.docker.%ver%.tar.zip json2puml.docker.%ver%.tar
cd ..

