call "C:\Program Files (x86)\Embarcadero\Studio\23.0\bin\rsvars.bat"
cd ..\source\

msbuild json2pumlapps.groupproj /p:config=Release /p:platform=Win32
msbuild json2pumlapps.groupproj /p:config=Release /p:platform=Win64
msbuild json2puml.dproj /p:config=Release /p:platform=Linux64
msbuild json2pumlservice.dproj /p:config=Release /p:platform=Linux64

cd ..\installation\
