del /s ..\samples\*formatted*
call prepare_docker_dir.cmd
call build_docker.cmd
"c:\Program Files (x86)\Inno Setup 6\Compil32.exe" /cc json2pumlsetup.iss

set EXE='..\source\win64\release\json2puml.exe'
for /f %%i in ('powershell "(Get-Item -path %EXE%).VersionInfo.FileVersion"') do set ver=%%i
echo %ver%

output\Json2Puml.setup.%ver%.exe /silent