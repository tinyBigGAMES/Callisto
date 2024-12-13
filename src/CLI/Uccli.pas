{===============================================================================
   ____      _ _ _     _
  / ___|__ _| | (_)___| |_ ___™
 | |   / _` | | | / __| __/ _ \
 | |__| (_| | | | \__ \ || (_) |
  \____\__,_|_|_|_|___/\__\___/
    Lua scripting for Delphi

 Copyright © 2024-present tinyBigGAMES™ LLC
 All Rights Reserved.

 https://github.com/tinyBigGAMES/Callisto

===============================================================================}

unit Uccli;

interface

uses
  WinApi.Windows,
  System.SysUtils,
  System.IOUtils,
  System.Classes,
  System.IniFiles,
  Callisto;

type
  { TCCLI }
  TCCLI = class
  private
    FLua: TCallisto;
    procedure RunScript(const AFilename: string);
    procedure InitProject(const AProjectName: string);
    procedure BuildProject(const AProjectName: string);
    procedure ShowBanner;
    procedure ShowUsage(const ACommand: string = '');
  public
    property Lua: TCallisto read FLua;
    constructor Create(); virtual;
    destructor Destroy(); override;
    procedure Print(const AText: string; const AArgs: array of const);
    procedure PrintLn(const AText: string; const AArgs: array of const);
    procedure Execute(const AArgs: TArray<string>);
  end;

procedure RunCCLI();

implementation

procedure RunCCLI();
var
  LCli: TCCLI;
  LArgs: TArray<string>;
  I: Integer;
begin

  LCli := TCCLI.Create;
  try
    // Try to run payload and exit
    if LCli.Lua.RunPayload() then
      Exit;

    // Populate Args array with command-line arguments
    SetLength(LArgs, ParamCount);
    for I := 1 to ParamCount do
      LArgs[I - 1] := ParamStr(I);

    LCli.Execute(LArgs); // Pass the arguments to Execute
  finally
    LCli.Free;
  end;
end;

function GetExeVersion(const AExePath: string): string;
var
  LSize, LHandle: DWORD;
  LBuffer: Pointer;
  LVersionInfo: Pointer;
  LFixedFileInfo: PVSFixedFileInfo;
  LVerSize: UINT;
  LMajor, LMinor, LRelease, LBuild: Word;
begin
  Result := '';

  if not FileExists(AExePath) then
    raise Exception.CreateFmt('File not found: %s', [AExePath]);

  LSize := GetFileVersionInfoSize(PChar(AExePath), LHandle);
  if LSize = 0 then
    Exit;

  GetMem(LBuffer, LSize);
  try
    if not GetFileVersionInfo(PChar(AExePath), LHandle, LSize, LBuffer) then
      Exit;

    if VerQueryValue(LBuffer, '\', LVersionInfo, LVerSize) then
    begin
      LFixedFileInfo := PVSFixedFileInfo(LVersionInfo);
      LMajor := HiWord(LFixedFileInfo.dwFileVersionMS);
      LMinor := LoWord(LFixedFileInfo.dwFileVersionMS);
      LRelease := HiWord(LFixedFileInfo.dwFileVersionLS);
      LBuild := LoWord(LFixedFileInfo.dwFileVersionLS);
      //Result := Format('%d.%d.%d.%d', [LMajor, LMinor, LRelease, LBuild]);
      Result := Format('%d.%d.%d', [LMajor, LMinor, LRelease, LBuild]);
    end;
  finally
    FreeMem(LBuffer);
  end;
end;

{ Tjlu }
constructor TCCLI.Create();
begin
  inherited;
  FLua := TCallisto.Create();
end;

destructor TCCLI.Destroy();
begin
  FLua.Free();
  inherited;
end;

procedure TCCLI.Print(const AText: string; const AArgs: array of const);
begin
  FLua.Print(AText, AArgs);
end;

procedure TCCLI.PrintLn(const AText: string; const AArgs: array of const);
begin
  FLua.PrintLn(AText, AArgs);
end;

procedure TCCLI.Execute(const AArgs: TArray<string>);
begin
  if Length(AArgs) = 0 then
  begin
    ShowBanner;
    Exit;
  end;

  if (Length(AArgs) = 2) and (SameText(AArgs[1], '--help') or SameText(AArgs[1], '-h')) then
  begin
    ShowUsage(AArgs[0]);
    Exit;
  end;

  if SameText(AArgs[0], 'run') then
  begin
    if Length(AArgs) < 2 then
      ShowUsage('run')
    else
      RunScript(AArgs[1]);
  end
  else if SameText(AArgs[0], 'init') then
  begin
    if Length(AArgs) < 2 then
      ShowUsage('init')
    else
      InitProject(AArgs[1]);
  end
  else if SameText(AArgs[0], 'build') then
  begin
    if Length(AArgs) < 2 then
      ShowUsage('build')
    else
      BuildProject(AArgs[1]);
  end
  else
  begin
    Writeln('Error: Unknown command "' + AArgs[0] + '".');
    ShowBanner;
  end;
end;

procedure TCCLI.ShowBanner;
begin
  PrintLn('Callisto CLI Utility v%s', [CALLISTO_VERSION]);
  PrintLn('Copyright © 2024-present tinyBigGAMES™ LLC', []);
  PrintLn('All Rights Reserved.', []);
  PrintLn('', []);
  PrintLn('Usage:', []);
  PrintLn('  ccli <command> [arguments]', []);
  PrintLn('', []);
  PrintLn('Commands:', []);
  PrintLn('  run    Run the specified Lua script.', []);
  PrintLn('  init   Initialize a project file (.ini file).', []);
  PrintLn('  build  Build the project using the project file.', []);
  PrintLn('', []);
  PrintLn('Use "ccli <command> --help" for more information about a command.', []);
end;

procedure TCCLI.ShowUsage(const ACommand: string);
begin
  if SameText(ACommand, 'run') then
  begin
    PrintLn('Run a Lua script.', []);
    PrintLn('', []);
    PrintLn('Usage:', []);
    PrintLn('  ccli run <script.lua>', []);
    PrintLn('', []);
    PrintLn('Arguments:', []);
    PrintLn('  <script.lua>    The Lua script to execute.', []);
    PrintLn('', []);
    PrintLn('Example:', []);
    PrintLn('  ccli run main.lua', []);
  end
  else if SameText(ACommand, 'init') then
  begin
    PrintLn('Initialize a new project by creating a .ini file.', []);
    PrintLn('', []);
    PrintLn('Usage:', []);
    PrintLn('  ccli init <project-name>', []);
    PrintLn('', []);
    PrintLn('Arguments:', []);
    PrintLn('  <project-name>    The name of the project (used to generate the .ini file).', []);
    PrintLn('', []);
    PrintLn('Example:', []);
    PrintLn('  ccli init test', []);
  end
  else if SameText(ACommand, 'build') then
  begin
    PrintLn('Build the project using the specified .ini file.', []);
    PrintLn('', []);
    PrintLn('Usage:', []);
    PrintLn('  ccli build <project-name>', []);
    PrintLn('', []);
    PrintLn('Arguments:', []);
    PrintLn('  <project-name>    The name of the project (used to locate the .ini file).', []);
    PrintLn('', []);
    PrintLn('Example:', []);
    PrintLn('  ccli build test', []);
  end
  else
  begin
    ShowBanner;
  end;
end;

procedure TCCLI.RunScript(const AFilename: string);
var
  LFilename: string;
begin
  try
    FLua.Reset();

    LFilename := Tpath.ChangeExtension(AFilename, 'lua');

    if not TFile.Exists(LFilename) then
    begin
      PrintLn('Error: File "%s" found.', [LFilename]);
      Exit;
    end;

    PrintLn('Running script: "%s"', [LFilename]);
    FLua.UpdateArgs(2); // skip 'ccli run' on the commandline
    FLua.LoadFile(LFilename);
  except
    on E: Exception do
    begin
      // Handle and display any exceptions that occur during testing
      PrintLn('Error: %s', [E.Message]);
    end;
  end;
end;

procedure TCCLI.InitProject(const AProjectName: string);
var
  LFileName: string;
  LIniFile: TIniFile;
  LResponse: string;
begin
  try
    LFileName := TPath.GetFullPath(TPath.ChangeExtension(AProjectName, 'ini'));

    if TFile.Exists(LFileName) then
    begin
      Print('Project file "%s" already exists. '#10'Do you want to overwrite it? (yes/no)', [LFileName]);
      ReadLn(LResponse);
      if (not SameText(LResponse, 'yes')) and (not SameText(LResponse, 'y')) then
      begin
        PrintLn('Operation cancelled.', []);
        Exit;
      end;
      TFile.Delete(LFileName);
    end;

    PrintLn('Initializing project: %s', [AProjectName]);
    LIniFile := TIniFile.Create(LFilename);
    try
      LiniFile.WriteString('PROJECT', 'Src', 'project.lua');
      LiniFile.WriteString('PROJECT', 'Exe', 'project.exe');
      LiniFile.WriteString('PROJECT', 'Icon', 'project.ico');

      LiniFile.WriteInteger('VERSIONINFO', 'Major', 1);
      LiniFile.WriteInteger('VERSIONINFO', 'Minor', 0);
      LiniFile.WriteInteger('VERSIONINFO', 'Patch', 0);

      LiniFile.WriteString('VERSIONINFO', 'ProductName', 'ProductName');
      LiniFile.WriteString('VERSIONINFO', 'Description', 'Description');
      LiniFile.WriteString('VERSIONINFO', 'Filename',     'ProductFilename');
      LiniFile.WriteString('VERSIONINFO', 'CompanyName',  'CompanyName');
      LiniFile.WriteString('VERSIONINFO', 'Copyright',    'Copyright');

      LIniFile.UpdateFile();
      if TFile.Exists(LFilename) then
        PrintLn('Project file "%s" created.', [LFileName])
      else
        PrintLn('Failed to create project file "%s".', [LFileName])
    finally
      LIniFile.Free();
    end;
  except
    on E: Exception do
    begin
      PrintLn('Error: %s', [E.Message]);
    end;
  end;
end;

procedure TCCLI.BuildProject(const AProjectName: string);
var
  LFileName: string;
  LIniFile: TIniFile;
  LSrcFilename: string;
  LExeFilename: string;
  LIconFilename: string;
  LMajor: Word;
  LMinor: Word;
  LPatch: Word;
  LProductName: string;
  LProductFilename: string;
  LDescription: string;
  LCompanyName: string;
  LCopyright: string;

  procedure CopyFileAndCreateDirs(const ASource, ADestination: string);
  var
    LDestinationDir: string;
  begin
    // Extract the directory portion of the destination path
    LDestinationDir := TPath.GetDirectoryName(ADestination);

    // Create the directory if it doesn't exist
    if not LDestinationDir.IsEmpty and not TDirectory.Exists(LDestinationDir) then
      TDirectory.CreateDirectory(LDestinationDir);

    // Perform the file copy
    TFile.Copy(ASource, ADestination, True);
  end;

begin
  try
    LFileName := TPath.GetFullPath(TPath.ChangeExtension(AProjectName, 'ini'));
    if not TFile.Exists(LFileName) then
    begin
      PrintLn('Error: Project file "%s" not found.', [LFileName]);
      Exit;
    end;

    PrintLn('Building project: %s', [AProjectName]);
    LIniFile := TIniFile.Create(LFilename);
    try
      LSrcFilename := LiniFile.ReadString('PROJECT', 'Src', 'project.lua');
      LExeFilename := LiniFile.ReadString('PROJECT', 'Exe', 'project.exe');
      LIconFilename := LiniFile.ReadString('PROJECT', 'Icon', 'project.ico');

      LMajor := LiniFile.ReadInteger('VERSIONINFO', 'Major', 1);
      LMinor := LiniFile.ReadInteger('VERSIONINFO', 'Minor', 0);
      LPatch := LiniFile.ReadInteger('VERSIONINFO', 'Patch', 0);

      LProductName := LiniFile.ReadString('VERSIONINFO', 'ProductName', 'ProductName');
      LDescription := LiniFile.ReadString('VERSIONINFO', 'Description', 'Description');

      LProductFilename := LiniFile.ReadString('VERSIONINFO', 'Filename',     'ProductFilename');
      LCompanyName := LiniFile.ReadString('VERSIONINFO', 'CompanyName',  'CompanyName');
      LCopyright := LiniFile.ReadString('VERSIONINFO', 'Copyright',    'Copyright');


      // Copy executable to create a payload
      PrintLn('Generating "%s"...', [LExeFilename]);
      CopyFileAndCreateDirs(ParamStr(0), LExeFilename);

      if TFile.Exists(LExeFilename) then
        begin
          // Attempt to store compiled Lua bytecode into the payload executable
          if FLua.StorePayload(LSrcFilename, LExeFilename) then
            begin
              // Attempt to update payload EXE main icon
              PrintLn('Saved bytecode to "%s"', [LExeFilename]);
              if FLua.UpdatePayloadIcon(LExeFilename, LIconFilename) then
                FLua.PrintLn('Added icon "%s" to "%s..."', [LIconFilename, LExeFilename]);

              // Attemp to update payload EXE version information
              if FLua.UpdatePayloadVersionInfo(LExeFilename, LMajor, LMinor,
                LPatch, LProductName, LDescription,
                TPath.GetFileName(LExeFilename),
                LCompanyName,
                LCopyright) then
                FLua.PrintLn('Added version info to "%s".', [LExeFilename]);
            end
          else
            FLua.PrintLn('Failed to save bytecode to "%s."', [LExeFilename]);
        end
      else
        FLua.PrintLn('Failed to create "%s".', [LExeFilename]);


    finally
      LIniFile.Free();
    end;
  except
    on E: Exception do
    begin
      PrintLn('Error: %s', [E.Message]);
    end;
  end;
end;


end.
