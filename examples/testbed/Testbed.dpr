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

program Testbed;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  UTestbed in 'UTestbed.pas',
  UFunctions in 'UFunctions.pas',
  Callisto in '..\..\src\Callisto.pas';

begin
  RunTests();
end.
