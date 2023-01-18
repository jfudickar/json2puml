rmdir /s /q ..\docker\logs
mkdir ..\docker\logs
rmdir /s /q ..\docker\output
mkdir ..\docker\output
rmdir /s /q ..\docker\src\json2puml\logs
mkdir ..\docker\src\json2puml\logs
rmdir /s /q ..\docker\src\json2puml\output
mkdir ..\docker\src\json2puml\output
rmdir /s /q ..\docker\src\json2puml\samples
mkdir ..\docker\src\json2puml\samples
xcopy ..\samples\*.json ..\docker\src\json2puml\samples /e /i /y
rmdir /s /q  ..\docker\src\json2puml\samples\tmf\data
rmdir /s /q  ..\docker\src\json2puml\samples\service