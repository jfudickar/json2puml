call "C:\Program Files (x86)\Embarcadero\Studio\22.0\bin\rsvars.bat"
cd ..\source\

msbuild json2pumlapps.groupproj /p:config=Release /p:platform=Win32
msbuild json2pumlapps.groupproj /p:config=Release /p:platform=Win64
msbuild json2pumlapps.groupproj /p:config=Release /p:platform=Linux64


cd ..\installation\
