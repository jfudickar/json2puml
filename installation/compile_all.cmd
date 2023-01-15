call "C:\Program Files (x86)\Embarcadero\Studio\22.0\bin\rsvars.bat"
cd e:\Delphi\Projects\json2puml.git\source\

msbuild json2pumlapps.groupproj /p:config=Release /p:platform=Win32
msbuild json2pumlapps.groupproj /p:config=Debug /p:platform=Win32
msbuild json2pumlapps.groupproj /p:config=Release /p:platform=Win64
msbuild json2pumlapps.groupproj /p:config=Debug /p:platform=Win64
msbuild json2pumlapps.groupproj /p:config=Release /p:platform=Linux64


cd e:\Delphi\Projects\json2puml.git\installation\
