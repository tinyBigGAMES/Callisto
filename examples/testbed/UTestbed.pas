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

unit UTestbed;

interface

uses
  System.SysUtils,
  System.IOUtils,
  System.Classes,
  Callisto,
  UFunctions;

procedure RunTests();

implementation

// Utility procedure to pause the console for user input.
// This procedure writes a message to the console and waits for the user
// to press the ENTER key before proceeding.
procedure Pause();
begin
  WriteLn; // Print a blank line for spacing.
  Write('Press ENTER to continue...'); // Display the message to the user.
  ReadLn; // Wait for the user to press ENTER.
  WriteLn; // Print another blank line for spacing.
end;

// Callback procedure executed before resetting the TCallisto instance.
// Parameters:
//   AUserData: Pointer to user-defined data, typically pointing to the TCallisto instance.
procedure OnBeforeReset(const AUserData: Pointer);
var
  LCallisto: TCallisto; // Local variable to hold the TCallisto instance.
begin
  if not Assigned(AUserData) then Exit; // Check if AUserData is nil. If so, exit immediately.
  LCallisto := TCallisto(AUserData); // Cast the pointer to the TCallisto instance.
  LCallisto.PrintLn('OnBeforeReset', []); // Log that the callback was executed.
end;

// Callback procedure executed after resetting the TCallisto instance.
// Parameters:
//   AUserData: Pointer to user-defined data, typically pointing to the TCallisto instance.
procedure OnAfterReset(const AUserData: Pointer);
var
  LCallisto: TCallisto; // Local variable to hold the TCallisto instance.
begin
  if not Assigned(AUserData) then Exit; // Check if AUserData is nil. If so, exit immediately.
  LCallisto := TCallisto(AUserData); // Cast the pointer to the TCallisto instance.
  LCallisto.PrintLn('OnAfterReset', []); // Log that the callback was executed.
end;

// Test procedure that demonstrates the basic setup, use, and cleanup of TCallisto.
// This procedure is a template for using TCallisto effectively in projects.
procedure Test00();
var
  LCallisto: TCallisto; // Local variable to hold the TCallisto instance.
begin
  try
    LCallisto := TCallisto.Create(); // Create a new instance of TCallisto.
    try
      // Register callbacks for the "before reset" and "after reset" events.
      LCallisto.SetBeforeResetCallback(OnBeforeReset, LCallisto);
      LCallisto.SetAfterResetCallback(OnAfterReset, LCallisto);
      // Add a search path where Lua scripts can be located.
      LCallisto.AddSearchPath('.\res\scripts');
      // Additional code for TCallisto functionality can be added here.
    finally
      LCallisto.Free(); // Ensure the TCallisto instance is properly freed.
    end;
  except
    on E: Exception do
      WriteLn('Error: ', E.Message); // Handle exceptions and display error messages.
  end;
end;

// Test procedure that demonstrates loading and executing Lua scripts in various ways.
// This includes loading scripts from strings, files, and memory buffers, both with and without AutoRun.
procedure Test01();
var
  LCallisto: TCallisto; // Local variable to hold the TCallisto instance.
  LBuffer: TStringStream; // Memory stream used to store Lua scripts in memory.
begin
  try
    LCallisto := TCallisto.Create(); // Create a new instance of TCallisto.
    try
      // Register the callback for the "before reset" event.
      LCallisto.SetBeforeResetCallback(OnBeforeReset, LCallisto);
      // Add a search path where Lua scripts can be located.
      LCallisto.AddSearchPath('.\res\scripts');

      // Example 1: Load and execute a Lua script directly from a string with AutoRun enabled.
      LCallisto.PrintLn('LoadString, AutoRun = True', []); // Log the operation.
      LCallisto.PrintLn('---------------------------', []); // Separator for output clarity.
      LCallisto.LoadString('print("Hello World! (AutoRun)")'); // Load the script and execute automatically.

      // Example 2: Load a Lua script string without AutoRun and execute it manually.
      LCallisto.PrintLn('LoadString, AutoRun = False', []); // Log the operation.
      LCallisto.PrintLn('---------------------------', []); // Separator for output clarity.
      LCallisto.LoadString('print("Hello World! (No AutoRun)")', False); // Load the script without AutoRun.
      LCallisto.Run; // Manually execute the script.

      // Example 3: Load a Lua script from a file and execute it automatically.
      LCallisto.PrintLn('LoadFile, AutoRun = True', []); // Log the operation.
      LCallisto.PrintLn('---------------------------', []); // Separator for output clarity.
      LCallisto.LoadFile('Example01.lua'); // Load and execute the script from a file.

      // Example 4: Load a Lua script from a file without AutoRun and execute it manually.
      LCallisto.PrintLn('LoadFile, AutoRun = False', []); // Log the operation.
      LCallisto.PrintLn('---------------------------', []); // Separator for output clarity.
      LCallisto.LoadFile('.\res\scripts\Example01.lua', False); // Load the script without AutoRun.
      LCallisto.Run; // Manually execute the script.

      // Example 5: Load Lua script from a memory buffer.
      LBuffer := TStringStream.Create('print("Lua running from a buffer!")'); // Create a buffer with Lua code.
      try
        // Load and execute Lua script from the buffer with AutoRun enabled.
        LCallisto.PrintLn('LoadBuffer, AutoRun = True', []); // Log the operation.
        LCallisto.PrintLn('---------------------------', []); // Separator for output clarity.
        LCallisto.LoadBuffer(LBuffer.Memory, LBuffer.Size); // Load and execute the script from the buffer.

        // Load Lua script from the buffer without AutoRun and execute it manually.
        LCallisto.PrintLn('LoadBuffer, AutoRun = False', []); // Log the operation.
        LCallisto.PrintLn('---------------------------', []); // Separator for output clarity.
        LCallisto.LoadBuffer(LBuffer.Memory, LBuffer.Size, False); // Load the script without AutoRun.
        LCallisto.Run; // Manually execute the script.
      finally
        LBuffer.Free(); // Ensure the memory buffer is properly freed.
      end;
    finally
      LCallisto.Free(); // Ensure the TCallisto instance is properly freed.
    end;
  except
    on E: Exception do
      WriteLn('Error: ', E.Message); // Handle exceptions and display error messages.
  end;
end;

// Test procedure to demonstrate defining and retrieving Lua variables.
procedure Test02();
var
  LCallisto: TCallisto; // Local variable to hold the TCallisto instance.
  LVal: TCallistoValue; // Holder for Lua variables.
begin
  try
    LCallisto := TCallisto.Create(); // Create a new instance of TCallisto.
    try
      // Register the callback for the "before reset" event.
      LCallisto.SetBeforeResetCallback(OnBeforeReset, LCallisto);

      // Add a search path where Lua scripts can be located.
      LCallisto.AddSearchPath('.\res\scripts');

      // Define variables in Lua from Delphi.
      LCallisto.SetVariable('var_string', '"My Name"');  // Define a string variable.
      LCallisto.SetVariable('var_integer', 4321);         // Define an integer variable.
      LCallisto.SetVariable('var_number', 12.34);         // Define a number variable.
      LCallisto.SetVariable('var_boolean', true);         // Define a boolean variable.

      // Load and execute a Lua script file.
      LCallisto.LoadFile('.\res\scripts\Example02.lua');

      // Retrieve and display variables defined in Lua.
      LVal := LCallisto.GetVariable('var_string', vtString); // Retrieve a string variable.
      LCallisto.PrintLn('var_string: %s, a string value', [LVal.AsString]); // Display the value.

      LVal := LCallisto.GetVariable('var_integer', vtInteger); // Retrieve an integer variable.
      LCallisto.PrintLn('var_integer: %d, an integer value', [LVal.AsInteger]); // Display the value.

      LVal := LCallisto.GetVariable('var_number', vtDouble); // Retrieve a number variable.
      LCallisto.PrintLn('var_number: %3.2f, a number value', [LVal.AsNumber]); // Display the value.

      LVal := LCallisto.GetVariable('var_boolean', vtBoolean); // Retrieve a boolean variable.
      LCallisto.PrintLn('var_boolean: %s, a boolean value', [BoolToStr(LVal.AsBoolean, True)]); // Display the value.
    finally
      LCallisto.Free(); // Ensure the TCallisto instance is properly freed.
    end;
  except
    on E: Exception do
      WriteLn('Error: ', E.Message); // Handle exceptions and display error messages.
  end;
end;


// Test procedure that demonstrates debugging Lua scripts and looping constructs.
procedure Test03();
const
  LCode =
  '''
  dbg() -- start debugging here
  for i = 1, 10 do
      print(i) -- Print numbers from 1 to 10
  end
  ''';
var
  LCallisto: TCallisto; // Local variable to hold the TCallisto instance.
begin
  try
    LCallisto := TCallisto.Create(); // Create a new instance of TCallisto.
    try
      // Register the callback for the "before reset" event.
      LCallisto.SetBeforeResetCallback(OnBeforeReset, LCallisto);
      // Add a search path where Lua scripts can be located.
      LCallisto.AddSearchPath('.\res\scripts');
      // Load and execute the Lua code as a string.
      LCallisto.LoadString(LCode);
    finally
      LCallisto.Free(); // Ensure the TCallisto instance is properly freed.
    end;
  except
    on E: Exception do
      WriteLn('Error: ', E.Message); // Handle exceptions and display error messages.
  end;
end;

// Test procedure demonstrating payload creation and manipulation in TCallisto.
procedure Test04();
var
  LCallisto: TCallisto; // Local variable to hold the TCallisto instance.
begin
  try
    LCallisto := TCallisto.Create(); // Create a new instance of TCallisto.
    try
      // Register callbacks for reset events.
      LCallisto.SetBeforeResetCallback(OnBeforeReset, LCallisto);
      LCallisto.SetAfterResetCallback(OnAfterReset, LCallisto);

      // Add a search path where Lua scripts can be located.
      LCallisto.AddSearchPath('.\res\scripts');

      // Reset TCallisto to its default state.
      LCallisto.Reset();

      // Save the payload as an executable file.
      if LCallisto.SavePayloadExe('Payload.exe') then
      begin
        // Store compiled Lua script into the payload executable.
        if LCallisto.StorePayload('.\res\scripts\compiled.lua', 'Payload.exe') then
        begin
          // Update the icon of the payload executable.
          if LCallisto.UpdatePayloadIcon('Payload.exe', '.\res\icons\cog.ico') then
            LCallisto.PrintLn('Added icon "%s" to "Payload.exe"', ['.\res\icons\cog.ico']);

          // Attempt to update payload executable version information.
          if LCallisto.UpdatePayloadVersionInfo('Payload.exe', 1, 0, 0, 'Payload', 'Payload', 'Payload.exe', 'tinyBigGAMES LLC', 'Copyright (c) 2024-present, tinyBigGAMES LLC') then
            LCallisto.PrintLn('Added version info to "Payload.exe"', []);
        end;
      end;
    finally
      LCallisto.Free(); // Ensure the TCallisto instance is properly freed.
    end;
  except
    on E: Exception do
      WriteLn('Error: ', E.Message); // Handle exceptions and display error messages.
  end;
end;

// Test procedure demonstrating manual routine registration and global function calls.
procedure Test05();
var
  LCallisto: TCallisto;
  LVal: TCallistoValue;
  LObj: testbed2;
begin
  try
    LCallisto := TCallisto.Create();
    try
      LCallisto.SetBeforeResetCallback(OnBeforeReset, LCallisto);
      LCallisto.SetBeforeResetCallback(OnAfterReset, LCallisto);
      LCallisto.AddSearchPath('.\res\scripts');

      // Step 1: Manually register a routine and call it directly from Lua
      LCallisto.RegisterRoutine('misc.test1', misc, @misc.test1); // Register the 'test1' routine in the 'misc' namespace
      LCallisto.Call('misc.test1', ['this works', 777]);          // Call the registered routine with parameters

      // Step 2: Automatically register all class routines as global Lua functions
      LCallisto.RegisterRoutines(testbed1);                      // Register all methods of 'testbed1' globally
      LVal := LCallisto.GetVariable('variable1', vtString);      // Retrieve a global variable set by Lua
      LCallisto.PrintLn('(host) variable1: %s', [LVal.AsString]);      // Display the retrieved variable
      LCallisto.Call('test1', ['this works!']);                  // Call the 'test1' method registered globally

      // Step 3: Automatically register all class routines under a Lua table named after the class
      LCallisto.RegisterRoutines('', testbed3);                  // Register all methods of 'testbed3' under its table
      LVal := LCallisto.GetVariable('variable3', vtString);      // Retrieve a variable set in the 'testbed3' table
      LCallisto.PrintLn('(host) variable3: %s', [LVal.AsString]);      // Display the retrieved variable
      LCallisto.Call('testbed3.test2', ['this works also!']);    // Call the 'test2' method from the 'testbed3' table

      // Step 4: Register an object instance as a global Lua object
      LObj := testbed2.Create;                              // Create an instance of 'testbed2'
      LCallisto.RegisterRoutines('', LObj, 'myObj');             // Register the object instance as 'myObj' in Lua
      LCallisto.Call('myObj.test1', [2020]);                     // Call the 'test1' method on the 'myObj' instance
      LObj.Free();                                          // Free the object instance to release resources
    finally
      LCallisto.Free();
    end;
  except
    on E: Exception do
    begin
      WriteLn('Error: ', E.Message);
    end;
  end;
end;

// Test procedure demonstrating module loading using 'require'.
procedure Test06();
const
  LCode =
  '''
  print("load Lua modual using 'require' command...")
  local mm = require("mymath")  -- Load the 'mymath' module
  mm.add(5,5)                   -- Call the 'add' function from the module
  ''';
var
  LCallisto: TCallisto; // Lua wrapper object
begin
  LCallisto := TCallisto.Create(); // Create the Lua wrapper instance
  try
    try
      // Add a search path to locate Lua modules required by the script
      LCallisto.AddSearchPath('.\res\scripts');

      // Load the Lua code as a string and execute it
      LCallisto.LoadString(LCode);
    except
      on E: Exception do
      begin
        // Handle and display any exceptions that occur during execution
        LCallisto.PrintLn(E.Message, []);
      end;
    end;
  finally
    // Ensure that the Lua instance is properly freed, even if an exception occurs
    LCallisto.Free();
  end;
end;

// Test procedure demonstrating module loading using 'import'.
procedure Test07();
const
  LCode =
  '''
  print("load Lua modual using 'import' command...")
  local mm = import("./res/scripts/mymath.lua")  -- Import the 'mymath.lua' script
  mm.add(50,50)                                  -- Call the 'add' function from the script
  ''';
var
  LLua: TCallisto; // Lua wrapper object
begin
  LLua := TCallisto.Create(); // Create the Lua wrapper instance
  try
    try
      // Add a search path to locate Lua scripts used in the `import` command
      LLua.AddSearchPath('.\res\scripts');

      // Load the Lua code as a string and execute it
      LLua.LoadString(LCode);
    except
      on E: Exception do
      begin
        // Handle and display any exceptions that occur during execution
        LLua.PrintLn(E.Message, []);
      end;
    end;
  finally
    // Ensure that the Lua instance is properly freed, even if an exception occurs
    LLua.Free();
  end;
end;

// Test procedure demonstrating compiling Lua to bytecode and executing it.
procedure Test08();
var
  LLua: TCallisto;        // Local variable to hold the TCallisto instance.
  LStream: TMemoryStream; // Memory stream for storing compiled Lua bytecode
begin
  LLua := TCallisto.Create(); // Create the Lua wrapper instance
  try
    try
      // Add a search path to locate Lua scripts
      LLua.AddSearchPath('.\res\scripts');

      // Create a memory stream to store the compiled bytecode
      LStream := TMemoryStream.Create();
      try
        // Compile the Lua script file into the memory stream
        LLua.CompileToStream('.\res\scripts\Example03.lua', LStream, False);

        // Load the compiled Lua bytecode from the memory stream
        LLua.LoadBuffer(LStream.Memory, LStream.Size);

      finally
        // Free the memory stream after loading the bytecode
        LStream.Free();
      end;
    except
      on E: Exception do
      begin
        // Handle and display any exceptions that occur during compilation or execution
        LLua.PrintLn(E.Message, []);
      end;
    end;
  finally
    // Ensure that the Lua instance is properly freed, even if an exception occurs
    LLua.Free();
  end;
end;

// Main procedure to run the tests.
// This procedure initializes the TCallisto instance, checks for payload execution,
// and runs specific test procedures based on a predefined test number.
procedure RunTests();
var
  LCallisto: TCallisto; // Local variable to hold the TCallisto instance.
  LNum: Integer;        // Variable to determine which test to execute.
begin
  // Create a new instance of TCallisto.
  LCallisto := TCallisto.Create();
  try
    // Check if the payload should be executed directly.
    // If RunPayload returns true, exit the procedure as the payload execution is handled.
    if LCallisto.RunPayload() then
      Exit;
  finally
    // Ensure the TCallisto instance is properly freed, even if an exception occurs.
    LCallisto.Free();
  end;

  // Set the test number to execute. Change this value to run different tests.
  LNum := 01;

  // Use a case statement to execute the corresponding test procedure based on LNum.
  case LNum of
    01: Test01(); // Execute Test01.
    02: Test02(); // Execute Test02.
    03: Test03(); // Execute Test03.
    04: Test04(); // Execute Test04.
    05: Test05(); // Execute Test05.
    06: Test06(); // Execute Test06.
    07: Test07(); // Execute Test07.
    08: Test08(); // Execute Test08.
  end;

  // Pause execution to allow the user to review the output before the console closes.
  Pause();
end;


end.
