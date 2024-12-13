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

unit UFunctions;

interface

uses
  System.SysUtils,
  Callisto;


type

  { TVector }
  TVector = record
    x: Single;
    y: Single;
    z: Single;
  end;

  { testbed1 }
  testbed1 = class
    class procedure AutoSetup(const ALua: ICallisto);
    class procedure test1(const AContext: ICallistoContext);
  end;

  { testbed2 }
  testbed2 = class
  public
    procedure AutoSetup(const ALua: ICallisto);
    procedure test1(const AContext: ICallistoContext);
  end;

  { testbed3 }
  testbed3 = class
    class procedure AutoSetup(const ALua: ICallisto);
    class procedure vector(const AContext: ICallistoContext);
    class procedure test2(const AContext: ICallistoContext);
  end;

  { misc }
  misc = class
    class procedure test1(const AContext: ICallistoContext);
    class procedure test2(const AContext: ICallistoContext);
  end;

implementation

{ --- testbed1 -------------------------------------------------------------- }
class procedure testbed1.AutoSetup(const ALua: ICallisto);
begin
  ALua.PrintLn('', []);
  ALua.PrintLn('testbed1.AutoSetup', []);
  ALua.SetVariable('variable1', 'this is variable1');
end;

class procedure testbed1.test1(const AContext: ICallistoContext);
var
  s: string;
begin
  s := AContext.GetValue(vtString, 1);
  AContext.Lua.PrintLn('running "testbed1.test1": %s', [s]);
end;

{ --- testbed2 -------------------------------------------------------------- }
procedure testbed2.AutoSetup(const ALua: ICallisto);
begin
  ALua.PrintLn('', []);
  ALua.PrintLn('testbed2.AutoSetup', []);
  ALua.SetVariable('variable2', 'this is variable2');
end;

procedure testbed2.test1(const AContext: ICallistoContext);
var
  i: Integer;
begin
  i := AContext.GetValue(vtInteger, 1);
  AContext.Lua.PrintLn('int arg 1: %d', [i]);
end;

{ --- testbed3 -------------------------------------------------------------- }
class procedure testbed3.AutoSetup(const ALua: ICallisto);
begin
  ALua.PrintLn('', []);
  ALua.PrintLn('testbed3.AutoSetup', []);
  ALua.SetVariable('variable3', 'this is variable3');
end;

class procedure testbed3.vector(const AContext: ICallistoContext);
var
  v: TVector;
begin
  v.x := 0;
  v.y := 0;
  v.z := 0;

  if AContext.ArgCount = 3 then
  begin
    v.x := AContext.GetValue(vtDouble, 1);
    v.y := AContext.GetValue(vtDouble, 2);
    v.z := AContext.GetValue(vtDouble, 3);
  end;

  AContext.PushValue(LuaTable);
  AContext.SetTableFieldValue('x', v.x, 1);
  AContext.SetTableFieldValue('y', v.y, 1);
  AContext.SetTableFieldValue('z', v.z, 1);
end;

class procedure testbed3.test2(const AContext: ICallistoContext);
var
  s: string;
begin
  s := AContext.GetValue(vtString, 1);
  AContext.Lua.PrintLn('running "testbed3.test2": %s', [s]);
end;

{ --- misc ------------------------------------------------------------------ }
class procedure misc.test1(const AContext: ICallistoContext);
var
  s: string;
  i: Integer;
begin
  if AContext.ArgCount = 2 then
    begin
      s := AContext.GetValue(vtString, 1);
      i := AContext.GetValue(vtInteger, 2);
      AContext.Lua.PrintLn('(host) misc.test1 - param1: "%s", param2: %d', [s, i]);
    end
  else
    begin
      AContext.Lua.PrintLn('(host) misc.test1', []);
    end;
end;

class procedure misc.test2(const AContext: ICallistoContext);
var
  s: string;
begin
  if AContext.ArgCount = 1 then
  begin
    s := AContext.GetValue(vtString, 1);
    AContext.Lua.PrintLn('(host) misc.test2("%s")', [s]);
  end;
end;



end.
