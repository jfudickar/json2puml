; Script generated by the Inno Script Studio Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Json2Puml"
#define MyAppVersion GetVersionNumbersString("..\source\Win64\Release\json2puml.exe")
#define MyAppPublisher "Jens Fudickar"
#define MyAppExeName "json2puml.exe"
#define plantumljarversion "1.2023.0"
#define plantumljarlink "https://github.com/plantuml/plantuml/releases/download/v1.2023.0/" 
#define plantumljarfile "plantuml-1.2023.0.jar"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{719E1A9B-383B-48FF-AE30-2907DBAE82B1}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={userpf}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
Compression=lzma
SolidCompression=yes
OutputBaseFilename={#MyAppName}.setup.{#MyAppVersion}
CreateUninstallRegKey=true
UsePreviousAppDir=true
UsePreviousGroup=true
WizardStyle=modern
AlwaysShowGroupOnReadyPage=True
AlwaysShowDirOnReadyPage=True
AppCopyright=(c) by Jens Fudickar in 2023
VersionInfoVersion={#MyAppVersion}
VersionInfoCompany=Softwaredevelopment Jens Fudickar
VersionInfoDescription=Json2Puml Installation File
VersionInfoCopyright=(c) by Jens Fudickar in 2023
PrivilegesRequired=lowest
DisableDirPage=no
ShowLanguageDialog=no
DisableWelcomePage=False
ShowTasksTreeLines=True
ChangesEnvironment=True

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "..\source\Win64\Release\json2puml.exe"; DestDir: "{app}\bin"; Flags: ignoreversion; Components: Windows
Source: "..\source\Win64\Release\json2pumlui.exe"; DestDir: "{app}\bin"; Flags: ignoreversion; Components: Windows
Source: "..\source\Win64\Release\json2pumlservice.exe"; DestDir: "{app}\bin"; Flags: ignoreversion; Components: Windows
Source: "..\source\Win64\Release\json2pumlwindowsservice.exe"; DestDir: "{app}\bin"; Flags: ignoreversion; Components: Windows
Source: "cmdfiles\*install_json2pumlwindowsservice.cmd"; DestDir: "{app}\bin"; Flags: ignoreversion; Components: Windows
Source: "..\source\Linux64\Release\json2puml"; DestDir: "{app}\bin\linux"; Flags: ignoreversion; Components: Linux
Source: "..\source\Linux64\Release\json2pumlservice"; DestDir: "{app}\bin\linux"; Flags: ignoreversion; Components: Linux
Source: "..\source\Linux64\Release\json2puml"; DestDir: "{app}\docker\src\json2puml\bin\"; Flags: ignoreversion; Components: Docker
Source: "..\source\Linux64\Release\json2pumlservice"; DestDir: "{app}\docker\src\json2puml\bin\"; Flags: ignoreversion; Components: Docker
Source: "..\documentation\json2puml documentation.pdf"; DestDir: "{app}\documentation"; Flags: ignoreversion; Components: Documentation
Source: "..\documentation\json2puml introduction.pdf"; DestDir: "{app}\documentation"; Flags: ignoreversion; Components: Documentation
Source: "..\documentation\release-notes.txt"; DestDir: "{app}\documentation"; Flags: ignoreversion; Components: Documentation
Source: "..\documentation\json2puml.yaml"; DestDir: "{app}\documentation"; Flags: ignoreversion; Components: Documentation
Source: "..\documentation\*.md"; DestDir: "{app}\documentation"; Flags: ignoreversion; Components: Documentation

Source: "{tmp}\{#plantumljarfile}"; DestDir: "{app}\plantuml"; Flags: external; Tasks: downloadPlantUml

; NOTE: Don't use "Flags: ignoreversion" on any shared system files
Source: "..\samples\*.cmd"; DestDir: "{app}\samples"; Components: Samples
Source: "..\samples\*.md"; DestDir: "{app}\samples"; Components: Samples
Source: "..\samples\swapi\*.json"; DestDir: "{app}\samples\swapi"; Components: Samples
Source: "..\samples\swapi\*.cmd"; DestDir: "{app}\samples\swapi"; Components: Samples
Source: "..\samples\swapi\*.md"; DestDir: "{app}\samples\swapi"; Components: Samples
Source: "..\samples\jsonplaceholder\*.json"; DestDir: "{app}\samples\jsonplaceholder"; Components: Samples
Source: "..\samples\jsonplaceholder\*.cmd"; DestDir: "{app}\samples\jsonplaceholder"; Components: Samples
Source: "..\samples\jsonplaceholder\*.md"; DestDir: "{app}\samples\jsonplaceholder"; Components: Samples
Source: "..\samples\tmf\tmf_definition.json"; DestDir: "{app}\samples\tmf"; Components: Samples
Source: "..\samples\tmf\tmf-productdetail.json"; DestDir: "{app}\samples\tmf"; Components: Samples
Source: "..\samples\tmf\*.md"; DestDir: "{app}\samples\tmf"; Components: Samples
Source: "..\samples\service\*.md"; DestDir: "{app}\samples\service"; Components: Samples
Source: "..\samples\service\*.json"; DestDir: "{app}\samples\service"; Components: Samples
Source: "..\samples\service\*.cmd"; DestDir: "{app}\samples\service"; Components: Samples; Excludes: "*vm.cmd" 
Source: "..\samples\service\*.md"; DestDir: "{app}\samples\service"; Components: Samples
Source: "..\samples\tvmaze\*.json"; DestDir: "{app}\samples\tvmaze"; Components: Samples
Source: "..\samples\tvmaze\*.cmd"; DestDir: "{app}\samples\tvmaze"; Components: Samples
Source: "..\samples\tvmaze\*.md"; DestDir: "{app}\samples\tvmaze"; Components: Samples
Source: "..\samples\spacex\*.json"; DestDir: "{app}\samples\spacex"; Components: Samples
Source: "..\samples\spacex\*.cmd"; DestDir: "{app}\samples\spacex"; Components: Samples
Source: "..\samples\spacex\*.md"; DestDir: "{app}\samples\spacex"; Components: Samples
Source: "..\configuration\json2pumlcurlauthentication.json"; DestDir: "{app}\samples"
Source: "..\docker\*"; DestDir: "{app}\docker"; Flags: createallsubdirs recursesubdirs; Components: Docker; Excludes: ".gitignore,json2puml*.,*.url"

[Icons]
Name: "{group}\Release Notes"; Filename: "{app}\documentation\release-notes.txt"
Name: "{group}\Json2Puml Introduction"; Filename: "{app}\documentation\json2puml introduction.pdf"
Name: "{group}\Json2Puml Documentation"; Filename: "{app}\documentation\json2puml documentation.pdf"

[ThirdParty]           
UseRelativePaths=True

[Run]
;Filename: "{app}\documentation\release-notes.txt"; Flags: nowait postinstall unchecked shellexec skipifsilent; Description: "Show Release Notes"
Filename: "{app}\documentation\json2puml introduction.pdf"; Flags: nowait postinstall unchecked shellexec skipifsilent; Description: "Show Introduction"
Filename: "{app}\documentation\json2puml documentation.pdf"; Flags: nowait postinstall unchecked shellexec skipifsilent; Description: "Show Documentation"

[Dirs]
Name: "{app}\bin"
Name: "{app}\bin\linux"; Components: Linux
Name: "{app}\documentation"; Components: Documentation
Name: "{app}\plantuml"; Tasks: downloadPlantUml
Name: "{app}\samples"; Components: Samples
Name: "{app}\samples\tmf"; Components: Samples
Name: "{app}\samples\swapi"; Components: Samples
Name: "{app}\samples\jsonplaceholder"; Components: Samples
Name: "{app}\samples\service"; Components: Samples
Name: "{app}\samples\service\result"; Components: Samples
Name: "{app}\samples\tvmaze"; Components: Samples
Name: "{app}\samples\spacex"; Components: Samples
Name: "{app}\docker"; Components: Docker

[Registry]
Root: "HKCU"; Subkey: "Environment"; ValueType: string; ValueName: "PlantUmlJarFile"; ValueData: "{app}\plantuml\{#plantumljarfile}"; Flags: uninsdeletevalue; Tasks: downloadPlantUml
Root: "HKCU"; Subkey: "Environment"; ValueType: string; ValueName: "Json2PumlDefinitionFile"; Flags: uninsdeletevalue createvalueifdoesntexist
Root: "HKCU"; Subkey: "Environment"; ValueType: string; ValueName: "Json2PumlCurlAuthenticationFile"; Flags: uninsdeletevalue createvalueifdoesntexist
Root: "HKCU"; Subkey: "Environment"; ValueType: string; ValueName: "Json2PumlConfigurationFile"; Flags: uninsdeletevalue createvalueifdoesntexist

[Tasks]
Name: "envPath"; Description: "Add bin directory to PATH variable"
Name: "downloadPlantUml"; Description: "Download PlantUML v{#plantumljarversion} Jar File"

[Components]
Name: "Windows"; Description: "Windows Executables"; Types: full compact custom
Name: "Linux"; Description: "Linux Executables"; Types: custom full
Name: "Docker"; Description: "Docker Scripts"; Types: custom full
Name: "Documentation"; Description: "Documentation Files"; Types: custom full
Name: "Samples"; Description: "Sample Files"; Types: custom full

[Code]
const EnvironmentKey = 'Environment';

procedure EnvAddPath(instlPath: string);
var
    Paths: string;
begin
  { Retrieve current path (use empty string if entry not exists) }
  if not RegQueryStringValue(HKEY_CURRENT_USER, EnvironmentKey, 'Path', Paths) then
  begin
    Log(Format('Regkey [%s\%s] not found', [EnvironmentKey, 'Path']));
    Paths := '';
  end;

  if Paths = '' then
    Paths := instlPath + ';'
  else
  begin
    { Skip if string already found in path }
    if Pos(';' + Uppercase(instlPath) + ';',  ';' + Uppercase(Paths) + ';') > 0 then exit;
    if Pos(';' + Uppercase(instlPath) + '\;', ';' + Uppercase(Paths) + ';') > 0 then exit;

    { Append App Install Path to the end of the path variable }
    Log(Format('Right(Paths, 1): [%s]', [Paths[length(Paths)]]));
    if Paths[length(Paths)] = ';' then
      Paths := Paths + instlPath + ';'  { don't double up ';' in env(PATH) }
    else
      Paths := Paths + ';' + instlPath + ';' ;
  end;

  { Overwrite (or create if missing) path environment variable }
  if RegWriteStringValue(HKEY_CURRENT_USER, EnvironmentKey, 'Path', Paths) then 
    Log(Format('The [%s] added to PATH: [%s]', [instlPath, Paths]))
  else 
    Log(Format('Error while adding the [%s] to PATH: [%s]', [instlPath, Paths]));
end;

procedure EnvRemovePath(instlPath: string);
var
    Paths: string;
    P, Offset, DelimLen: Integer;
begin
    { Skip if registry entry not exists }
    if not RegQueryStringValue(HKEY_CURRENT_USER, EnvironmentKey, 'Path', Paths) then
        exit;

    { Skip if string not found in path }
    DelimLen := 1;     { Length(';') }
    P := Pos(';' + Uppercase(instlPath) + ';', ';' + Uppercase(Paths) + ';');
    if P = 0 then
    begin
        { perhaps instlPath lives in Paths, but terminated by '\;' }
        DelimLen := 2; { Length('\;') }
        P := Pos(';' + Uppercase(instlPath) + '\;', ';' + Uppercase(Paths) + ';');
        if P = 0 then exit;
    end;

    { Decide where to start string subset in Delete() operation. }
    if P = 1 then
        Offset := 0
    else
        Offset := 1;
    { Update path variable }
    Delete(Paths, P - Offset, Length(instlPath) + DelimLen);

    { Overwrite path environment variable }
    if RegWriteStringValue(HKEY_CURRENT_USER, EnvironmentKey, 'Path', Paths)
    then Log(Format('The [%s] removed from PATH: [%s]', [instlPath, Paths]))
    else Log(Format('Error while removing the [%s] from PATH: [%s]', [instlPath, Paths]));
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
 if (CurStep = ssPostInstall) and WizardIsTaskSelected('envPath') then 
   EnvAddPath(ExpandConstant('{app}') +'\bin');
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usPostUninstall then 
    EnvRemovePath(ExpandConstant('{app}') +'\bin');
end;

var
  DownloadPage: TDownloadWizardPage;

function OnDownloadProgress(const Url, FileName: String; const Progress, ProgressMax: Int64): Boolean;
begin
  if Progress = ProgressMax then
    Log(Format('Successfully downloaded file to {tmp}: %s', [FileName]));
  Result := True;
end;

procedure InitializeWizard;
begin
  DownloadPage := CreateDownloadPage(SetupMessage(msgWizardPreparing), SetupMessage(msgPreparingDesc), @OnDownloadProgress);
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  if (CurPageID = wpReady) and WizardIsTaskSelected('downloadPlantUml') then 
  begin
    DownloadPage.Clear;
    DownloadPage.Add('{#plantumljarlink}{#plantumljarfile}', '{#plantumljarfile}', '');
    DownloadPage.Show;
    try
      try
        DownloadPage.Download; // This downloads the files to {tmp}
        Result := True;
      except
        if DownloadPage.AbortedByUser then
          Log('Aborted by user.')
        else
          SuppressibleMsgBox(AddPeriod(GetExceptionMessage), mbCriticalError, MB_OK, IDOK);
        Result := False;
      end;
    finally
      DownloadPage.Hide;
    end;
  end else
    Result := True;
end;
