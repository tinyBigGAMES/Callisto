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

 BSD 3-Clause License

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the copyright holder nor the names of its
    contributors may be used to endorse or promote products derived from
    this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.

 ------------------------------------------------------------------------------
 This project uses the following open-source libraries:
  - LuaJIT (https://github.com/LuaJIT/LuaJIT)

 ------------------------------------------------------------------------------

 Callisto Usage Notes
 ===================
 1. Script Commands/Variables:
    - Callisto.version       - Callisto version (string)
    - Callisto.luaJitVersion - LuaJIT version (string)
    - Callisto.luaVersion    - Lua version (string)
    - dbg()                  - Place in your Lua source to invoke the
                               interactive debugger

 2. Prerequisites
    - Delphi 12.2 or higher
    - Windows 10 or higher
    - Tested on Windows 11 64-bit (23H2), Delphi 12.2

 3. Lua Garbage Collection (GC) Management
    Effective memory management is crucial for maintaining optimal performance
    in applications that embed Lua. Callisto provides a set of routines to
    control and monitor Lua's garbage collector (GC) directly from Delphi.
    Below are detailed explanations of these routines, including when and how
    to use them.

 3.1. SetGCStepSize(const AStep: Integer)
      What It Does:
        Sets the step multiplier for Lua's garbage collector. The step
        multiplier determines the amount of work the GC performs in each
        incremental step, influencing its aggressiveness.

      When to Use It:
        - Performance Optimization: Increase the step size to make GC
          more aggressive if memory usage is high.
        - Reducing Latency: Decrease the step size to spread GC workload,
          minimizing pauses in performance-critical applications.
        - Memory-Constrained Environments: Adjust step size to better manage
         limited memory resources.

       How to Use It:
         // Example: Setting the GC step size to 200%
         SetGCStepSize(200);

           Parameters:
             - AStep: A positive integer representing the GC step multiplier.
                      Lua's default is typically around 200. Higher values make
                      GC more aggressive.

      Considerations:
        - Balance: Too high a value may increase CPU usage, while too low
          may lead to inadequate garbage collection.
        - Testing: Experiment with different values to find the optimal
          balance for your application.

 3.2. GetGCStepSize(): Integer
        What It Does:
          Retrieves the current step multiplier value of Lua's garbage
          collector, allowing you to monitor the GC's configuration.

        When to Use It:
          - Monitoring: Keep track of the current GC settings.
          - Debugging: Diagnose memory-related issues by understanding GC
            behavior.
          - Dynamic Adjustments: Inform further adjustments based on runtime
            conditions.

        How to Use It:
          var
            CurrentStepSize: Integer;
          begin
            CurrentStepSize := GetGCStepSize();
            ShowMessage('Current GC Step Size: ' + IntToStr(CurrentStepSize));
          end;

       Returns:
         - An integer representing the current GC step multiplier.

      Considerations:
        - Regularly check to ensure GC is configured as intended, especially
          in complex applications.

 3.3. GetGCMemoryUsed(): Integer
        What It Does:
          Returns the amount of memory currently used by Lua's garbage
          collector, measured in bytes.

      When to Use It:
        - Memory Monitoring: Track memory usage trends to identify leaks or
          excessive consumption.
        - Performance Tuning: Use memory usage data to adjust GC settings.
        - Resource Management: Ensure memory usage stays within acceptable
          limits in constrained environments.

      How to Use It:
        var
          MemoryUsed: Integer;
        begin
          MemoryUsed := GetGCMemoryUsed();
          ShowMessage('Lua GC Memory Used: ' + IntToStr(MemoryUsed) +
           ' bytes');
        end;

      Returns:
        - An integer representing the memory usage of Lua's GC in bytes.

      Considerations:
        - Combine memory data with GC step size and performance metrics for
          informed memory management decisions.

 3.4. CollectGarbage()
        What It Does:
          Initiates an immediate garbage collection cycle in Lua, forcing the
          GC to reclaim memory from unused objects.

        When to Use It:
          - Explicit Memory Management: Trigger GC during moments when
            temporary pauses are acceptable, such as after loading large
            datasets.
          - Resource Cleanup: Free up memory promptly after operations that
            generate significant temporary objects.
          - Manual Control: Supplement automated GC triggers to maintain
           optimal performance.

        How to Use It:
          begin
            CollectGarbage();
            ShowMessage('Lua garbage collection cycle initiated.');
          end;

        Considerations:
          - Performance Impact: Forcing GC can cause temporary pauses; use
            judiciously to avoid negatively impacting user experience.
          - Timing: Identify suitable application moments, like idle times, to
            perform manual GC.
          - Complementary Use: Combine manual GC with automated settings for
            balanced memory management.

        Detailed Guidance on Using Lua GC Management Routines

          Overview of Lua's Garbage Collector
            Lua's incremental garbage collector automatically manages memory by
            reclaiming unused objects in small steps to prevent long pauses.
            Adjusting the GC's behavior can optimize memory usage and
            application responsiveness.

          Best Practices and Considerations
            1. Understand Lua's GC Mechanics:
               - Familiarize yourself with Lua's incremental garbage collection
                 to make informed adjustments.

            2. Avoid Overusing Manual GC Triggers:
                 - Excessive CollectGarbage calls can degrade performance. Use
                   them sparingly.

            3. Monitor Application Performance:
                 - Assess the impact of GC adjustments on both memory usage and
                   responsiveness.

            4. Test Across Scenarios:
                 - Different workloads may respond differently to GC settings.
                   Conduct thorough testing.

            5. Handle GC States Appropriately:
                 - Ensure your application manages state changes introduced by
                   garbage collection, especially with weak references.

            6. Stay Updated with Lua Versions:
                 - GC behavior may vary between Lua versions. Ensure
                   compatibility with the Lua version used by Callisto.

         Example Usage in a Delphi Application
           Below is a practical example demonstrating how to integrate and
           utilize the GC management routines within a Delphi application
           interfacing with Lua via Callisto.

           uses
             Callisto;

           Usage Example:
             procedure TForm1.ButtonOptimizeGCClick(Sender: TObject);
             begin
               try
                 // Set GC step size to 150%
                 SetGCStepSize(150);
                 ShowMessage('GC Step Size set to 150%.');

                 // Retrieve and display current step size
                 ShowMessage('Current GC Step Size: ' +
                   IntToStr(GetGCStepSize()));

                 // Check memory usage
                 ShowMessage('Lua GC Memory Used: ' +
                   IntToStr(GetGCMemoryUsed()) + ' bytes');

                // Force a garbage collection cycle
                CollectGarbage();
                ShowMessage('Garbage collection cycle initiated.');
              except
                on E: Exception do
                  ShowMessage('Error: ' + E.Message);
                end;
             end;

         Additional Notes
           - Lua Integration: Ensure that the Lua state (LuaState) is correctly
             initialized and managed within your application.

           - Error Handling: Implement robust error handling to manage
             scenarios where GC operations might fail or behave unexpectedly.

           - Performance Considerations: Adjusting the GC's step size can
             significantly impact application performance and memory usage.
             Test different configurations to identify the optimal settings for
             your use case.

 4.0 The provided code is a Command Line Interface (CLI) utility for the
     Callisto Lua scripting library, designed to facilitate the execution,
     initialization, and building of Lua-based projects in Delphi. The main
     class, `TCCLI`, integrates with the `Callisto` library and provides
     methods for running Lua scripts, initializing project configurations,
     and building project executables with embedded Lua bytecode, icons, and
     version information.

     To use this utility:
       1. Run Lua Scripts: Execute the command `ccli run <script.lua>`
           to load and execute a specified Lua script.
       2. Initialize Projects: Use the command `ccli init <project-name>`
          to create a project configuration file (`.ini`) with default settings
          for source, executable, and icon files.
       3. Build Projects: Use `ccli build <project-name>` to compile the
          project, embedding the Lua script as bytecode into the executable,
          adding an icon, and updating version information.

     The utility starts with the `RunCCLI` procedure, which parses
     command-line arguments and dispatches them to the corresponding methods
     in `TCCLI`. The `Execute` method dynamically interprets the command and
     arguments, displaying usage instructions for invalid inputs. With
     detailed logging and error handling, this CLI tool offers a robust
     mechanism for managing Lua-based projects directly from the command line.

 5.0 Feature: Dot Notation for Global Variables and Table Access

     Overview:
     The TCallisto class provides the methods SetVariable and GetVariable to
     facilitate the definition and retrieval of Lua variables. Beyond
     supporting global variable manipulation, these methods also allow seamless
     access to nested Lua tables using dot notation. This makes it
     straightforward to interact with complex table structures in Lua from
     Delphi.

     Dot Notation Behavior:
       SetVariable: Automatically creates or updates a nested table structure
                    based on the dot-separated path provided in the variable
                    name. Each segment of the path corresponds to a table, and
                    the final segment represents the variable to be set within
                    the deepest table.

       GetVariable: Retrieves the value of a variable within a nested table
                    structure by interpreting the dot-separated path.

     Example Usage
     1. Setting a Global Variable:
          Callisto.SetVariable('GlobalVar', 'Hello World');
          This sets GlobalVar in Lua's global scope to the value "Hello World".

     2. Setting a Nested Table Value:
          Callisto.SetVariable('Config.Display.Resolution', '1920x1080');
          If Config or Config.Display tables do not exist, they are
          automatically created. The Resolution field in the Config.Display
          table is set to "1920x1080".

     3. Retrieving a Global Variable:
          var
            LValue: string;
          begin
            LValue := Callisto.GetVariable('GlobalVar');
          end;
          Retrieves the value of GlobalVar, which is "Hello World".

     4. Retrieving a Nested Table Value:
          var
            LResolution: string;
          begin
            LResolution := Callisto.GetVariable('Config.Display.Resolution');
          end;
          Retrieves the value of Config.Display.Resolution, which is
          "1920x1080".

     Notes:
     - Automatic Table Creation:
         When using SetVariable, any intermediate tables that do not exist will
         be automatically created.
     - Error Handling:
         If GetVariable encounters a path where an expected table or variable
         does not exist, it should handle this gracefully and return nil or an
         appropriate error.

     Benefits
     - Simplifies interaction with Lua tables, enabling complex data structures
       to be accessed or modified with minimal code.
     - Reduces boilerplate code for creating or navigating nested tables in
       Lua.

 ------------------------------------------------------------------------------

>>> CHANGELOG <<<

Version 0.1.0
-------------
  - Initial release.

===============================================================================}

unit Callisto;

{$IF CompilerVersion >= 36.0}
  // Code specific to Delphi Athens (12.2) and above
{$ELSE}
  {$MESSAGE ERROR 'This code requires  Delphi Athens (12.2) or later'}
{$IFEND}

{$IFNDEF WIN64}
  // Generates a compile-time error if the target platform is not Win64
  {$MESSAGE Error 'Unsupported platform'}
{$ENDIF}

{$Z4}  // Sets the enumeration size to 4 bytes
{$A8}  // Sets the alignment for record fields to 8 bytes

{$WARN SYMBOL_DEPRECATED OFF}
{$WARN SYMBOL_PLATFORM OFF}

{$WARN UNIT_PLATFORM OFF}
{$WARN UNIT_DEPRECATED OFF}

interface

{$REGION ' USES '}
uses
  WinApi.Windows,
  System.Types,
  System.Math,
  System.Classes,
  System.IOUtils,
  System.AnsiStrings,
  System.Generics.Collections,
  System.SysUtils,
  System.TypInfo,
  System.RTTI;
{$ENDREGION}

{$REGION ' CALLISTO '}
const
  /// <summary>
  /// Specifies the current version of the Callisto library.
  /// </summary>
  CALLISTO_VERSION = '0.1.0';

type
  /// <summary>
  /// Defines the various data types that can be represented within the Lua environment.
  /// These types closely mirror the fundamental types within Lua itself, facilitating seamless interoperability between Delphi and Lua.
  /// </summary>
  TCallistoType = (
    ctNone = -1, /// <summary>Indicates an undefined or invalid type.</summary>
    ctNil = 0, /// <summary>Represents the Lua 'nil' type, signifying the absence of a value.</summary>
    ctBoolean = 1, /// <summary>Represents a boolean value, which can be either 'true' or 'false'.</summary>
    ctLightUserData = 2, /// <summary>Represents a light user data object, which is a raw pointer managed by the Delphi application.</summary>
    ctNumber = 3, /// <summary>Represents a numerical value, typically a double-precision floating-point number.</summary>
    ctString = 4, /// <summary>Represents a string of characters.</summary>
    ctTable = 5, /// <summary>Represents a Lua table, a versatile associative array that can hold any Lua type.</summary>
    ctFunction = 6, /// <summary>Represents a Lua function, a callable block of code.</summary>
    ctUserData = 7, /// <summary>Represents a user data object, which is a block of memory managed by the Delphi application.</summary>
    ltThread = 8 /// <summary>Represents a Lua thread, an independent thread of execution within the Lua environment.</summary>
  );

  /// <summary>
  /// An alias for the Lua table type, providing a more Delphi-centric name for this fundamental Lua data structure.
  /// </summary>
  TCallistoTable = (LuaTable);

  /// <summary>
  /// Enumerates the possible value types that can be held within a <see cref="TCallistoValue"/> record.
  /// This enumeration provides a type-safe way to interact with the variant-like <see cref="TCallistoValue"/> structure.
  /// </summary>
  TCallistoValueType = (
    vtInteger, /// <summary>Indicates an integer value.</summary>
    vtDouble, /// <summary>Indicates a double-precision floating-point value.</summary>
    vtString, /// <summary>Indicates a string value.</summary>
    vtTable, /// <summary>Indicates a Lua table value.</summary>
    vtPointer, /// <summary>Indicates a pointer value.</summary>
    vtBoolean /// <summary>Indicates a boolean value.</summary>
  );

  /// <summary>
  /// A variant-like record capable of holding different data types, mirroring the dynamic typing nature of Lua.
  /// This structure facilitates the exchange of data between Delphi and Lua, accommodating the various types supported by both environments.
  /// </summary>
  TCallistoValue = record
    /// <summary>
    /// Specifies the actual type of the value stored in the record.
    /// This field is crucial for correctly interpreting the data held within the <see cref="TCallistoValue"/>.
    /// </summary>
    AsType: TCallistoValueType;

    /// <summary>
    /// Implicitly converts an Integer to a <see cref="TCallistoValue"/>.
    /// </summary>
    /// <param name="AValue">The Integer value to convert.</param>
    /// <returns>A <see cref="TCallistoValue"/> holding the Integer value.</returns>
    class operator Implicit(const AValue: Integer): TCallistoValue;

    /// <summary>
    /// Implicitly converts a Double to a <see cref="TCallistoValue"/>.
    /// </summary>
    /// <param name="AValue">The Double value to convert.</param>
    /// <returns>A <see cref="TCallistoValue"/> holding the Double value.</returns>
    class operator Implicit(const AValue: Double): TCallistoValue;

    /// <summary>
    /// Implicitly converts a null-terminated string (PChar) to a <see cref="TCallistoValue"/>.
    /// </summary>
    /// <param name="AValue">The null-terminated string to convert.</param>
    /// <returns>A <see cref="TCallistoValue"/> holding the string value.</returns>
    class operator Implicit(const AValue: System.PChar): TCallistoValue;

    /// <summary>
    /// Implicitly converts a <see cref="TCallistoTable"/> to a <see cref="TCallistoValue"/>.
    /// </summary>
    /// <param name="AValue">The <see cref="TCallistoTable"/> value to convert.</param>
    /// <returns>A <see cref="TCallistoValue"/> holding the <see cref="TCallistoTable"/> value.</returns>
    class operator Implicit(const AValue: TCallistoTable): TCallistoValue;

    /// <summary>
    /// Implicitly converts a Pointer to a <see cref="TCallistoValue"/>.
    /// </summary>
    /// <param name="AValue">The Pointer value to convert.</param>
    /// <returns>A <see cref="TCallistoValue"/> holding the Pointer value.</returns>
    class operator Implicit(const AValue: Pointer): TCallistoValue;

    /// <summary>
    /// Implicitly converts a Boolean to a <see cref="TCallistoValue"/>.
    /// </summary>
    /// <param name="AValue">The Boolean value to convert.</param>
    /// <returns>A <see cref="TCallistoValue"/> holding the Boolean value.</returns>
    class operator Implicit(const AValue: Boolean): TCallistoValue;

    /// <summary>
    /// Implicitly converts a <see cref="TCallistoValue"/> to an Integer.
    /// </summary>
    /// <param name="AValue">The <see cref="TCallistoValue"/> to convert.</param>
    /// <returns>The Integer value held by the <see cref="TCallistoValue"/>.</returns>
    class operator Implicit(const AValue: TCallistoValue): Integer;

    /// <summary>
    /// Implicitly converts a <see cref="TCallistoValue"/> to a Double.
    /// </summary>
    /// <param name="AValue">The <see cref="TCallistoValue"/> to convert.</param>
    /// <returns>The Double value held by the <see cref="TCallistoValue"/>.</returns>
    class operator Implicit(const AValue: TCallistoValue): Double;

    /// <summary>
    /// Implicitly converts a <see cref="TCallistoValue"/> to a null-terminated string (PChar).
    /// </summary>
    /// <param name="AValue">The <see cref="TCallistoValue"/> to convert.</param>
    /// <returns>The null-terminated string held by the <see cref="TCallistoValue"/>.</returns>
    class operator Implicit(const AValue: TCallistoValue): System.PChar;

    /// <summary>
    /// Implicitly converts a <see cref="TCallistoValue"/> to a Pointer.
    /// </summary>
    /// <param name="AValue">The <see cref="TCallistoValue"/> to convert.</param>
    /// <returns>The Pointer value held by the <see cref="TCallistoValue"/>.</returns>
    class operator Implicit(const AValue: TCallistoValue): Pointer;

    /// <summary>
    /// Implicitly converts a <see cref="TCallistoValue"/> to a Boolean.
    /// </summary>
    /// <param name="AValue">The <see cref="TCallistoValue"/> to convert.</param>
    /// <returns>The Boolean value held by the <see cref="TCallistoValue"/>.</returns>
    class operator Implicit(const AValue: TCallistoValue): Boolean;

    case Integer of
      0: (AsInteger: Integer); /// <summary>Holds an Integer value when <see cref="AsType"/> is <see cref="vtInteger"/>.</summary>
      1: (AsNumber: Double); /// <summary>Holds a Double value when <see cref="AsType"/> is <see cref="vtDouble"/>.</summary>
      2: (AsString: System.PChar); /// <summary>Holds a null-terminated string when <see cref="AsType"/> is <see cref="vtString"/>.</summary>
      3: (AsTable: TCallistoTable); /// <summary>Holds a <see cref="TCallistoTable"/> when <see cref="AsType"/> is <see cref="vtTable"/>.</summary>
      4: (AsPointer: Pointer); /// <summary>Holds a Pointer value when <see cref="AsType"/> is <see cref="vtPointer"/>.</summary>
      5: (AsBoolean: Boolean); /// <summary>Holds a Boolean value when <see cref="AsType"/> is <see cref="vtBoolean"/>.</summary>
  end;

  /// <summary>
  /// Defines the signature for callback procedures invoked during the Lua state reset process.
  /// This callback allows developers to perform actions or cleanup tasks before or after the Lua state is reset.
  /// </summary>
  /// <param name="AUserData">A pointer to user-defined data, providing context to the callback.</param>
  TCallistoResetCallback = procedure(const AUserData: Pointer);

  /// <summary>
  /// The core interface for interacting with the Lua environment.
  /// Provides methods for loading and executing Lua code, managing variables, and registering Delphi routines for use in Lua.
  /// </summary>
  ICallisto = interface;

  /// <summary>
  /// Provides an interface for interacting with the Lua context, particularly the Lua stack.
  /// This interface enables access to parameters passed to Lua functions and facilitates data exchange between Delphi and Lua.
  /// </summary>
  ICallistoContext = interface
    ['{6AEC306C-45BC-4C65-A0E1-044739DED1EB}']

    /// <summary>
    /// Retrieves the number of arguments passed to the current Lua function.
    /// This method is crucial for understanding the context of a Lua function call from within Delphi.
    /// </summary>
    /// <returns>The number of arguments passed to the Lua function.</returns>
    function ArgCount(): Integer;

    /// <summary>
    /// Retrieves the number of values pushed onto the Lua stack within the current context.
    /// This is useful for tracking the state of the Lua stack during interactions with Lua from Delphi.
    /// </summary>
    /// <returns>The number of values pushed onto the Lua stack.</returns>
    function PushCount(): Integer;

    /// <summary>
    /// Clears the Lua stack, removing all values pushed onto it within the current context.
    /// This is often used to clean up the stack after a Lua function call or before pushing new values.
    /// </summary>
    procedure ClearStack();

    /// <summary>
    /// Pops a specified number of values from the Lua stack.
    /// This method is used to remove values from the stack, typically after they have been processed.
    /// </summary>
    /// <param name="ACount">The number of values to pop from the stack.</param>
    procedure PopStack(const ACount: Integer);

    /// <summary>
    /// Retrieves the <see cref="TCallistoType"/> of a value at a specific index on the Lua stack.
    /// This method allows inspection of the type of data present on the Lua stack.
    /// </summary>
    /// <param name="AIndex">The index of the value on the stack (1-based).</param>
    /// <returns>The <see cref="TCallistoType"/> of the value at the specified index.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    function GetStackType(const AIndex: Integer): TCallistoType;

    /// <summary>
    /// Retrieves a value of a specified <see cref="TCallistoValueType"/> from a specific index on the Lua stack.
    /// This method handles the extraction and conversion of Lua values to a format suitable for Delphi.
    /// </summary>
    /// <param name="AType">The expected <see cref="TCallistoValueType"/> of the value.</param>
    /// <param name="AIndex">The index of the value on the stack (1-based).</param>
    /// <returns>The <see cref="TCallistoValue"/> retrieved from the Lua stack.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call or if the retrieved value's type does not match the expected <paramref name="AType"/>.</exception>
    function GetValue(const AType: TCallistoValueType; const AIndex: Integer): TCallistoValue;

    /// <summary>
    /// Pushes a <see cref="TCallistoValue"/> onto the Lua stack.
    /// This method handles the conversion of Delphi data to a format suitable for Lua.
    /// </summary>
    /// <param name="AValue">The <see cref="TCallistoValue"/> to push onto the stack.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    procedure PushValue(const AValue: TCallistoValue);

    /// <summary>
    /// Sets the value of a field within a Lua table at a specific index on the Lua stack.
    /// This method allows modification of Lua tables from Delphi, using a string key to identify the field.
    /// </summary>
    /// <param name="AName">The name of the field to set.</param>
    /// <param name="AValue">The <see cref="TCallistoValue"/> to assign to the field.</param>
    /// <param name="AIndex">The index of the table on the stack (1-based).</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    procedure SetTableFieldValue(const AName: string; const AValue: TCallistoValue; const AIndex: Integer); overload;

    /// <summary>
    /// Retrieves the value of a field within a Lua table at a specific index on the Lua stack.
    /// This method handles the extraction and conversion of Lua table field values to a format suitable for Delphi.
    /// </summary>
    /// <param name="AName">The name of the field to retrieve.</param>
    /// <param name="AType">The expected <see cref="TCallistoValueType"/> of the field's value.</param>
    /// <param name="AIndex">The index of the table on the stack (1-based).</param>
    /// <returns>The <see cref="TCallistoValue"/> retrieved from the Lua table field.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call or if the retrieved value's type does not match the expected <paramref name="AType"/>.</exception>
    function GetTableFieldValue(const AName: string; const AType: TCallistoValueType; const AIndex: Integer): TCallistoValue; overload;

    /// <summary>
    /// Sets the value of an element within a Lua table at a specific index on the Lua stack, using an integer key.
    /// This method allows modification of Lua tables from Delphi, using an integer index to identify the element.
    /// </summary>
    /// <param name="AName">The name of the table (used for error reporting).</param>
    /// <param name="AValue">The <see cref="TCallistoValue"/> to assign to the element.</param>
    /// <param name="AIndex">The index of the table on the stack (1-based).</param>
    /// <param name="AKey">The integer key of the element to set.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    procedure SetTableIndexValue(const AName: string; const AValue: TCallistoValue; const AIndex: Integer; const AKey: Integer);

    /// <summary>
    /// Retrieves the value of an element within a Lua table at a specific index on the Lua stack, using an integer key.
    /// This method handles the extraction and conversion of Lua table element values to a format suitable for Delphi.
    /// </summary>
    /// <param name="AName">The name of the table (used for error reporting).</param>
    /// <param name="AType">The expected <see cref="TCallistoValueType"/> of the element's value.</param/// <param name="AIndex">The index of the table on the stack (1-based).</param>
    /// <param name="AKey">The integer key of the element to retrieve.</param>
    /// <returns>The <see cref="TCallistoValue"/> retrieved from the Lua table element.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call or if the retrieved value's type does not match the expected <paramref name="AType"/>.</exception>
    function GetTableIndexValue(const aName: string; const AType: TCallistoValueType; const AIndex: Integer; const AKey: Integer): TCallistoValue;

    /// <summary>
    /// Returns the associated <see cref="ICallisto"/> instance.
    /// This provides access to the core Lua environment from the context.
    /// </summary>
    /// <returns>The <see cref="ICallisto"/> instance associated with this context.</returns>
    function Lua(): ICallisto;
  end;

  /// <summary>
  /// Defines the signature for Delphi procedures that can be registered and called as Lua functions.
  /// This type acts as a bridge between Delphi and Lua, allowing Delphi code to be executed within the Lua environment.
  /// </summary>
  /// <param name="ALua">The <see cref="ICallistoContext"/> providing access to the Lua environment and stack.</param>
  TCallistoFunction = procedure(const ALua: ICallistoContext) of object;

  /// <summary>
  /// The core interface for interacting with the Lua environment.
  /// Provides methods for loading and executing Lua code, managing variables, and registering Delphi routines for use in Lua.
  /// </summary>
  ICallisto = interface
    ['{671FAB20-00F2-4C81-96A6-6F675A37D00B}']

    /// <summary>
    /// Retrieves the callback procedure invoked before the Lua state is reset.
    /// This callback allows for cleanup or preparation tasks before the Lua environment is reinitialized.
    /// </summary>
    /// <returns>The <see cref="TCallistoResetCallback"/> procedure set as the before reset callback.</returns>
    function GetBeforeResetCallback(): TCallistoResetCallback;

    /// <summary>
    /// Sets the callback procedure to be invoked before the Lua state is reset.
    /// </summary>
    /// <param name="AHandler">The <see cref="TCallistoResetCallback"/> procedure to be called before reset.</param>
    /// <param name="AUserData">A pointer to user-defined data that will be passed to the callback.</param>
    procedure SetBeforeResetCallback(const AHandler: TCallistoResetCallback; const AUserData: Pointer);

    /// <summary>
    /// Retrieves the callback procedure invoked after the Lua state is reset.
    /// This callback allows for initialization or setup tasks after the Lua environment is reinitialized.
    /// </summary>
    /// <returns>The <see cref="TCallistoResetCallback"/> procedure set as the after reset callback.</returns>
    function GetAfterResetCallback(): TCallistoResetCallback;

    /// <summary>
    /// Sets the callback procedure to be invoked after the Lua state is reset.
    /// </summary>
    /// <param name="AHandler">The <see cref="TCallistoResetCallback"/> procedure to be called after reset.</param>
    /// <param name="AUserData">A pointer to user-defined data that will be passed to the callback.</param>
    procedure SetAfterResetCallback(const AHandler: TCallistoResetCallback; const AUserData: Pointer);

    /// <summary>
    /// Resets the Lua state, clearing the environment and reinitializing it to its default state.
    /// This method effectively restarts the Lua environment, discarding any previously loaded code or data.
    /// </summary>
    procedure Reset();

    /// <summary>
    /// Adds a directory to the Lua search path.
    /// This allows Lua to locate and load modules from the specified directory.
    /// </summary>
    /// <param name="APath">The directory path to add to the Lua search path.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs while adding the search path.</exception>
    procedure AddSearchPath(const APath: string);

    /// <summary>
    /// Prints a formatted string to the standard output (console) using Lua's string formatting capabilities.
    /// This method leverages Lua's string.format function to provide flexible and convenient output formatting.
    /// </summary>
    /// <param name="AText">The format string, potentially containing placeholders for the arguments.</param>
    /// <param name="AArgs">An array of const values to be inserted into the format string placeholders.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call or string formatting.</exception>
    procedure Print(const AText: string; const AArgs: array of const);

    /// <summary>
    /// Prints a formatted string to the standard output (console), followed by a newline, using Lua's string formatting capabilities.
    /// This method is similar to <see cref="Print"/> but adds a newline character at the end of the output.
    /// </summary>
    /// <param name="AText">The format string, potentially containing placeholders for the arguments.</param>
    /// <param name="AArgs">An array of const values to be inserted into the format string placeholders.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call or string formatting.</exception>
    procedure PrintLn(const AText: string; const AArgs: array of const);

    /// <summary>
    /// Loads Lua code from a stream.
    /// This method allows loading Lua code from various sources, such as files or memory streams.
    /// </summary>
    /// <param name="AStream">The stream containing the Lua code.</param>
    /// <param name="ASize">The size of the Lua code in bytes. If 0, the entire stream is read.</param>
    /// <param name="AAutoRun">If True, the loaded code is automatically executed.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during loading or execution of the Lua code.</exception>
    procedure LoadStream(const AStream: TStream; const ASize: NativeUInt = 0; const AAutoRun: Boolean = True);

    /// <summary>
    /// Loads Lua code from a file.
    /// This method provides a convenient way to load and optionally execute Lua code from a file.
    /// </summary>
    /// <param name="AFilename">The path to the Lua file.</param>
    /// <param name="AAutoRun">If True, the loaded code is automatically executed.</param>
    /// <returns>True if the file was loaded successfully, False otherwise.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during loading or execution of the Lua code.</exception>
    function LoadFile(const AFilename: string; const AAutoRun: Boolean = True): Boolean;

    /// <summary>
    /// Loads Lua code from a string.
    /// This method allows loading Lua code directly from a Delphi string.
    /// </summary>
    /// <param name="AData">The string containing the Lua code.</param>
    /// <param name="AAutoRun">If True, the loaded code is automatically executed.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during loading or execution of the Lua code.</exception>
    procedure LoadString(const AData: string; const AAutoRun: Boolean = True);

    /// <summary>
    /// Loads Lua code from a memory buffer.
    /// This method allows loading Lua code from a raw memory buffer.
    /// </summary>
    /// <param name="AData">A pointer to the memory buffer containing the Lua code.</param>
    /// <param name="ASize">The size of the Lua code in bytes.</param>
    /// <param name="AAutoRun">If True, the loaded code is automatically executed.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during loading or execution of the Lua code.</exception>
    procedure LoadBuffer(const AData: Pointer; const ASize: NativeUInt; const AAutoRun: Boolean = True);

    /// <summary>
    /// Runs the previously loaded Lua code.
    /// This method is used to execute Lua code that has been loaded using methods like <see cref="LoadFile"/>, <see cref="LoadString"/>, etc.
    /// </summary>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the execution of the Lua code.</exception>
    procedure Run();

    /// <summary>
    /// Checks if a Lua routine (function) with the specified name exists.
    /// </summary>
    /// <param name="AName">The name of the Lua routine to check for.</param>
    /// <returns>True if the routine exists, False otherwise.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    function RoutineExist(const AName: string): Boolean;

    /// <summary>
    /// Calls a Lua routine (function) with the specified name and parameters.
    /// This method handles the pushing of parameters onto the Lua stack, the function call, and the retrieval of the return value.
    /// </summary>
    /// <param name="AName">The name of the Lua routine to call.</param>
    /// <param name="AParams">An array of <see cref="TCallistoValue"/> representing the parameters to pass to the Lua routine.</param>
    /// <returns>A <see cref="TCallistoValue"/> representing the return value of the Lua routine.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    function Call(const AName: string; const AParams: array of TCallistoValue): TCallistoValue; overload;

    /// <summary>
    /// Prepares a Lua routine (function) for calling by pushing it onto the stack.
    /// This method is used in conjunction with the <see cref="Call(const)"/> overload to perform calls with a variable number of arguments.
    /// </summary>
    /// <param name="AName">The name of the Lua routine to prepare for calling.</param>
    /// <returns>True if the routine was successfully pushed onto the stack, False otherwise.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    function PrepCall(const AName: string): Boolean;

    /// <summary>
    /// Calls a Lua routine (function) that has been previously prepared using <see cref="PrepCall"/>.
    /// This overload allows specifying the number of parameters to pass to the function.
    /// </summary>
    /// <param name="aParamCount">The number of parameters to pass to the Lua routine.</param>
    /// <returns>A <see cref="TCallistoValue"/> representing the return value of the Lua routine.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    function Call(const aParamCount: Integer): TCallistoValue; overload;

    /// <summary>
    /// Checks if a Lua global variable with the specified name exists.
    /// </summary>
    /// <param name="AName">The name of the Lua global variable to check for.</param>
    /// <returns>True if the variable exists, False otherwise.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    function VariableExist(const AName: string): Boolean;

    /// <summary>
    /// Sets the value of a Lua global variable.
    /// This method allows modification of Lua global variables from Delphi.
    /// </summary>
    /// <param name="AName">The name of the Lua global variable to set.</param>
    /// <param name="AValue">The <see cref="TCallistoValue"/> to assign to the variable.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    procedure SetVariable(const AName: string; const AValue: TCallistoValue);

    /// <summary>
    /// Retrieves the value of a Lua global variable.
    /// This method handles the extraction and conversion of Lua variable values to a format suitable for Delphi.
    /// </summary>
    /// <param name="AName">The name of the Lua global variable to retrieve.</param>
    /// <param name="AType">The expected <see cref="TCallistoValueType"/> of the variable's value.</param>
    /// <returns>A <see cref="TCallistoValue"/> representing the value of the Lua global variable.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call or if the retrieved value's type does not match the expected <paramref name="AType"/>.</exception>
    function GetVariable(const AName: string; const AType: TCallistoValueType): TCallistoValue;

    /// <summary>
    /// Registers a Delphi procedure as a Lua routine (function), using raw function pointers.
    /// This overload provides a low-level mechanism for registering Delphi code that can be called from Lua.
    /// </summary>
    /// <param name="AName">The name by which the routine will be accessible in Lua.</param>
    /// <param name="AData">A pointer to data that will be passed to the registered function.</param>
    /// <param name="ACode">A pointer to the Delphi procedure to be registered.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    procedure RegisterRoutine(const AName: string; const AData: Pointer; const aCode: Pointer); overload;

    /// <summary>
    /// Registers a Delphi procedure as a Lua routine (function).
    /// This overload provides a more convenient way to register Delphi code that can be called from Lua, using the <see cref="TCallistoFunction"/> type.
    /// </summary>
    /// <param name="AName">The name by which the routine will be accessible in Lua.</param>
    /// <param name="ARoutine">The <see cref="TCallistoFunction"/> procedure to be registered.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    procedure RegisterRoutine(const AName: string; const aRoutine: TCallistoFunction); overload;

    /// <summary>
    /// Registers all public methods of a Delphi class as Lua routines.
    /// This method provides a way to automatically expose the functionality of a Delphi class to Lua.
    /// </summary>
    /// <param name="AClass">The class whose public methods will be registered as Lua routines.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    procedure RegisterRoutines(const AClass: TClass); overload;

    /// <summary>
    /// Registers all public methods of a Delphi object as Lua routines.
    /// This method provides a way to automatically expose the functionality of a Delphi object to Lua.
    /// </summary>
    /// <param name="AObject">The object whose public methods will be registered as Lua routines.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    procedure RegisterRoutines(const AObject: TObject); overload;

    /// <summary>
    /// Registers all public methods of a Delphi class as Lua routines within a specific table hierarchy.
    /// This method allows organizing registered routines within Lua tables, creating a structured API.
    /// </summary>
    /// <param name="ATables">A period-separated string specifying the table hierarchy where the routines will be registered (e.g., "MyAPI.Utils").</param>
    /// <param name="AClass">The class whose public methods will be registered as Lua routines.</param>
    /// <param name="ATableName">An optional name for the table that will directly hold the routines. If empty, the class name is used.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    procedure RegisterRoutines(const ATables: string; const AClass: TClass; const ATableName: string = ''); overload;

    /// <summary>
    /// Registers all public methods of a Delphi object as Lua routines within a specific table hierarchy.
    /// This method allows organizing registered routines within Lua tables, creating a structured API.
    /// </summary>
    /// <param name="ATables">A period-separated string specifying the table hierarchy where the routines will be registered (e.g., "MyAPI.Utils").</param>
    /// <param name="AObject">The object whose public methods will be registered as Lua routines.</param>
    /// <param name="ATableName">An optional name for the table that will directly hold the routines. If empty, the object's class name is used.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    procedure RegisterRoutines(const ATables: string; const AObject: TObject; const ATableName: string = ''); overload;

    /// <summary>
    /// Updates the arguments on the Lua stack, starting from a specified index.
    /// This method is typically used to modify the arguments passed to a Lua function from Delphi.
    /// </summary>
    /// <param name="AStartIndex">The starting index (1-based) of the arguments to update.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    procedure UpdateArgs(const AStartIndex: Integer);

    /// <summary>
    /// Sets the step size for Lua's garbage collector.
    /// This influences how aggressively Lua reclaims unused memory.
    /// </summary>
    /// <param name="AStep">The step size for the garbage collector.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    procedure SetGCStepSize(const AStep: Integer);

    /// <summary>
    /// Retrieves the current step size of Lua's garbage collector.
    /// </summary>
    /// <returns>The current garbage collector step size.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    function GetGCStepSize(): Integer;

    /// <summary>
    /// Retrieves the amount of memory currently used by Lua.
    /// This provides insight into Lua's memory consumption.
    /// </summary>
    /// <returns>The amount of memory used by Lua in kilobytes.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    function GetGCMemoryUsed(): Integer;

    /// <summary>
    /// Performs a full garbage collection cycle in Lua.
    /// This forces Lua to reclaim all unused memory.
    /// </summary>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    procedure CollectGarbage();

    /// <summary>
    /// Compiles Lua code from a file and saves the resulting bytecode to a stream.
    /// This allows pre-compiling Lua code for faster loading and execution.
    /// </summary>
    /// <param name="AFilename">The path to the Lua file to compile.</param>
    /// <param name="AStream">The stream to which the compiled bytecode will be saved.</param>
    /// <param name="ACleanOutput">If True, the output bytecode is stripped of debugging information.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during compilation or saving of the bytecode.</exception>
    procedure CompileToStream(const AFilename: string; const AStream: TStream; const ACleanOutput: Boolean);

    /// <summary>
    /// Checks if a Lua payload exists within the current executable.
    /// A payload is a Lua bytecode chunk embedded within the executable.
    /// </summary>
    /// <returns>True if a Lua payload exists, False otherwise.</returns>
    function PayloadExist(): Boolean;

    /// <summary>
    /// Runs the embedded Lua payload, if it exists.
    /// </summary>
    /// <returns>True if the payload was found and executed successfully, False otherwise.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the execution of the Lua payload.</exception>
    function RunPayload(): Boolean;

    /// <summary>
    /// Saves the current Lua state as an executable file with an embedded Lua payload.
    /// This creates a standalone executable that includes the Lua environment and the specified payload.
    /// </summary>
    /// <param name="AFilename">The path to the executable file to create.</param>
    /// <returns>True if the executable was created successfully, False otherwise.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the creation of the executable.</exception>
    function SavePayloadExe(const AFilename: string): Boolean;

    /// <summary>
    /// Stores a Lua payload within an existing executable file.
    /// This embeds a Lua bytecode chunk within the specified executable.
    /// </summary>
    /// <param name="ASourceFilename">The path to the source executable file.</param>
    /// <param name="AEXEFilename">The path to the target executable file where the payload will be stored.</param>
    /// <returns>True if the payload was stored successfully, False otherwise.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the payload storage process.</exception>
    function StorePayload(const ASourceFilename, AEXEFilename: string): Boolean;

    /// <summary>
    /// Updates the icon of an executable file.
    /// This allows customization of the executable's appearance.
    /// </summary>
    /// <param name="AEXEFilename">The path to the executable file whose icon will be updated.</param>
    /// <param name="AIconFilename">The path to the icon file (.ico) to use.</param>
    /// <returns>True if the icon was updated successfully, False otherwise.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the icon update process.</exception>
    function UpdatePayloadIcon(const AEXEFilename, AIconFilename: string): Boolean;

    /// <summary>
    /// Updates the version information of an executable file.
    /// This allows setting details like product name, description, company, etc.
    /// </summary>
    /// <param name="AEXEFilename">The path to the executable file whose version information will be updated.</param>
    /// <param name="AMajor">The major version number.</param>
    /// <param name="AMinor">The minor version number.</param>
    /// <param name="APatch">The patch version number.</param>
    /// <param name="AProductName">The product name.</param>
    /// <param name="ADescription">The product description.</param>
    /// <param name="AFilename">The original filename.</param>
    /// <param name="ACompanyName">The company name.</param>
    /// <param name="ACopyright">The copyright information.</param>
    /// <returns>True if the version information was updated successfully, False otherwise.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the version information update process.</exception>
    function UpdatePayloadVersionInfo(const AEXEFilename: string; const AMajor, AMinor, APatch: Word; const AProductName, ADescription, AFilename, ACompanyName, ACopyright: string): Boolean;
  end;

  /// <summary>
  /// Forward declaration for the <see cref="TCallisto"/> class, which provides a concrete implementation of the <see cref="ICallisto"/> interface.
  /// </summary>
  TCallisto = class;

  /// <summary>
  /// Forward declaration for the <see cref="TCallistoContext"/> class, which provides a concrete implementation of the <see cref="ICallistoContext"/> interface.
  /// </summary>
  TCallistoContext = class;

  /// <summary>
  /// A generic exception class for errors that occur within the Callisto library.
  /// This exception is used to signal various error conditions related to Lua integration.
  /// </summary>
  ECallistoException = class(Exception);

  /// <summary>
  /// Provides a context for interacting with the Lua environment, particularly the Lua stack.
  /// This class facilitates data exchange between Delphi and Lua, handling parameter passing and value retrieval.
  /// </summary>
  TCallistoContext = class(TNoRefCountObject, ICallistoContext)
  protected
    /// <summary>
    /// A reference to the associated <see cref="TCallisto"/> instance, providing access to the core Lua environment.
    /// </summary>
    FLua: TCallisto;

    /// <summary>
    /// Tracks the number of values pushed onto the Lua stack within the current context.
    /// </summary>
    FPushCount: Integer;

    /// <summary>
    /// A flag indicating whether a value has been pushed onto the stack during the current operation.
    /// </summary>
    FPushFlag: Boolean;

    /// <summary>
    /// Performs setup operations for the context.
    /// </summary>
    procedure Setup();

    /// <summary>
    /// Performs checks to ensure the context is in a valid state.
    /// </summary>
    procedure Check();

    /// <summary>
    /// Increments the stack push count.
    /// </summary>
    procedure IncStackPushCount();

    /// <summary>
    /// Performs cleanup operations for the context.
    /// </summary>
    procedure Cleanup();

    /// <summary>
    /// Pushes a Lua table onto the stack for setting a value within a nested table structure.
    /// </summary>
    /// <param name="AName">An array of strings representing the nested table structure.</param>
    /// <param name="AIndex">The starting index on the stack.</param>
    /// <param name="AStackIndex">The resulting stack index of the target table.</param>
    /// <param name="AFieldNameIndex">The index within the <paramref name="AName"/> array of the final field name.</param>
    /// <returns>True if the table was successfully pushed, False otherwise.</returns>
    function PushTableForSet(const AName: array of string; const AIndex: Integer; var AStackIndex: Integer; var AFieldNameIndex: Integer): Boolean;

    /// <summary>
    /// Pushes a Lua table onto the stack for retrieving a value from within a nested table structure.
    /// </summary>
    /// <param name="AName">An array of strings representing the nested table structure.</param>
    /// <param name="AIndex">The starting index on the stack.</param>
    /// <param name="AStackIndex">The resulting stack index of the target table.</param>
    /// <param name="AFieldNameIndex">The index within the <paramref name="AName"/> array of the final field name.</param>
    /// <returns>True if the table was successfully pushed, False otherwise.</returns>
    function PushTableForGet(const AName: array of string; const AIndex: Integer; var AStackIndex: Integer; var AFieldNameIndex: Integer): Boolean;

  public
    /// <summary>
    /// Creates a new instance of the <see cref="TCallistoContext"/> class.
    /// </summary>
    /// <param name="ALua">The associated <see cref="TCallisto"/> instance.</param>
    constructor Create(const ALua: TCallisto);

    /// <summary>
    /// Destroys the <see cref="TCallistoContext"/> instance, performing any necessary cleanup.
    /// </summary>
    destructor Destroy(); override;

    /// <summary>
    /// Retrieves the number of arguments passed to the current Lua function.
    /// </summary>
    /// <returns>The number of arguments passed to the Lua function.</returns>
    function ArgCount(): Integer;

    /// <summary>
    /// Retrieves the number of values pushed onto the Lua stack within the current context.
    /// </summary>
    /// <returns>The number of values pushed onto the Lua stack.</returns>
    function PushCount(): Integer;

    /// <summary>
    /// Clears the Lua stack, removing all values pushed onto it within the current context.
    /// </summary>
    procedure ClearStack();

    /// <summary>
    /// Pops a specified number of values from the Lua stack.
    /// </summary>
    /// <param name="ACount">The number of values to pop from the stack.</param>
    procedure PopStack(const ACount: Integer);

    /// <summary>
    /// Retrieves the <see cref="TCallistoType"/> of a value at a specific index on the Lua stack.
    /// </summary>
    /// <param name="AIndex">The index of the value on the stack (1-based).</param>
    /// <returns>The <see cref="TCallistoType"/> of the value at the specified index.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    function GetStackType(const AIndex: Integer): TCallistoType;

    /// <summary>
    /// Retrieves a value of a specified <see cref="TCallistoValueType"/> from a specific index on the Lua stack.
    /// </summary>
    /// <param name="AType">The expected <see cref="TCallistoValueType"/> of the value.</param>
    /// <param name="AIndex">The index of the value on the stack (1-based).</param>
    /// <returns>The <see cref="TCallistoValue"/> retrieved from the Lua stack.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call or if the retrieved value's type does not match the expected <paramref name="AType"/>.</exception>
    function GetValue(const AType: TCallistoValueType; const AIndex: Integer): TCallistoValue; overload;

    /// <summary>
    /// Pushes a <see cref="TCallistoValue"/> onto the Lua stack.
    /// </summary>
    /// <param name="AValue">The <see cref="TCallistoValue"/> to push onto the stack.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    procedure PushValue(const AValue: TCallistoValue); overload;

    /// <summary>
    /// Sets the value of a field within a Lua table at a specific index on the Lua stack.
    /// </summary>
    /// <param name="AName">The name of the field to set.</param>
    /// <param name="AValue">The <see cref="TCallistoValue"/> to assign to the field.</param>
    /// <param name="AIndex">The index of the table on the stack (1-based).</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    procedure SetTableFieldValue(const AName: string; const AValue: TCallistoValue; const AIndex: Integer); overload;

    /// <summary>
    /// Retrieves the value of a field within a Lua table at a specific index on the Lua stack.
    /// </summary>
    /// <param name="AName">The name of the field to retrieve.</param>
    /// <param name="AType">The expected <see cref="TCallistoValueType"/> of the field's value.</param>
    /// <param name="AIndex">The index of the table on the stack (1-based).</param>
    /// <returns>The <see cref="TCallistoValue"/> retrieved from the Lua table field.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call or if the retrieved value's type does not match the expected <paramref name="AType"/>.</exception>
    function GetTableFieldValue(const AName: string; const AType: TCallistoValueType; const AIndex: Integer): TCallistoValue; overload;

    /// <summary>
    /// Sets the value of an element within a Lua table at a specific index on the Lua stack, using an integer key.
    /// </summary>
    /// <param name="AName">The name of the table (used for error reporting).</param>
    /// <param name="AValue">The <see cref="TCallistoValue"/> to assign to the element.</param>
    /// <param name="AIndex">The index of the table on the stack (1-based).</param>
    /// <param name="AKey">The integer key of the element to set.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    procedure SetTableIndexValue(const AName: string; const AValue: TCallistoValue; const AIndex: Integer; const AKey: Integer);

    /// <summary>
    /// Retrieves the value of an element within a Lua table at a specific index on the Lua stack, using an integer key.
    /// </summary>
    /// <param name="AName">The name of the table (used for error reporting).</param>
    /// <param name="AType">The expected <see cref="TCallistoValueType"/> of the element's value.</param>
    /// <param name="AIndex">The index of the table on the stack (1-based).</param>
    /// <param name="AKey">The integer key of the element to retrieve.</param>
    /// <returns>The <see cref="TCallistoValue"/> retrieved from the Lua table element.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call or if the retrieved value's type does not match the expected <paramref name="AType"/>.</exception>
    function GetTableIndexValue(const AName: string; const AType: TCallistoValueType; const AIndex: Integer; const AKey: Integer): TCallistoValue;

    /// <summary>
    /// Returns the associated <see cref="ICallisto"/> instance.
    /// </summary>
    /// <returns>The <see cref="ICallisto"/> instance associated with this context.</returns>
    function Lua(): ICallisto;
  end;

  /// <summary>
  /// Provides a high-level wrapper around the Lua environment, facilitating interaction with Lua from Delphi.
  /// This class encapsulates the Lua state and provides methods for loading and executing Lua code, managing variables, and registering Delphi routines.
  /// </summary>
  TCallisto = class(TNoRefCountObject, ICallisto)
  protected type
    /// <summary>
    /// A generic record type for storing a callback handler and associated user data.
    /// </summary>
    /// <typeparam name="T">The type of the callback handler.</typeparam>
    TCallback<T> = record
      /// <summary>
      /// The callback handler procedure.
      /// </summary>
      Handler: T;

      /// <summary>
      /// A pointer to user-defined data associated with the callback.
      /// </summary>UserData: Pointer;
      UserData: Pointer;
    end;

  protected
    /// <summary>
    /// A pointer to the underlying Lua state.
    /// </summary>
    FState: Pointer;

    /// <summary>
    /// The associated <see cref="TCallistoContext"/> instance, providing access to the Lua stack and context.
    /// </summary>
    FContext: TCallistoContext;

    /// <summary>
    /// The step size for Lua's garbage collector.
    /// </summary>
    FGCStep: Integer;

    /// <summary>
    /// The callback procedure invoked before the Lua state is reset.
    /// </summary>
    FOnBeforeReset: TCallback<TCallistoResetCallback>;

    /// <summary>
    /// The callback procedure invoked after the Lua state is reset.
    /// </summary>
    FOnAfterReset: TCallback<TCallistoResetCallback>;

    /// <summary>
    /// Opens and initializes the Lua state.
    /// </summary>
    procedure Open();

    /// <summary>
    /// Closes and destroys the Lua state.
    /// </summary>
    procedure Close();

    /// <summary>
    /// Checks for Lua errors and raises an exception if one occurred.
    /// </summary>
    /// <param name="AError">The error code returned by a Lua API call.</param>
    /// <exception cref="ECallistoException">Thrown if <paramref name="AError"/> indicates an error.</exception>
    procedure CheckLuaError(const AError: Integer);

    /// <summary>
    /// Pushes the global table onto the Lua stack for setting a global variable.
    /// </summary>
    /// <param name="AName">An array of strings representing the nested table structure for the global variable.</param>
    /// <param name="AIndex">The resulting stack index of the target table.</param>
    /// <returns>True if the global table was successfully pushed, False otherwise.</returns>
    function PushGlobalTableForSet(const AName: array of string; var AIndex: Integer): Boolean;

    /// <summary>
    /// Pushes the global table onto the Lua stack for retrieving a global variable.
    /// </summary>
    /// <param name="AName">An array of strings representing the nested table structure for the global variable.</param>
    /// <param name="AIndex">The resulting stack index of the target table.</param>
    /// <returns>True if the global table was successfully pushed, False otherwise.</returns>
    function PushGlobalTableForGet(const AName: array of string; var AIndex: Integer): Boolean;

    /// <summary>
    /// Pushes a Delphi <see cref="TValue"/> onto the Lua stack.
    /// </summary>
    /// <param name="AValue">The <see cref="TValue"/> to push onto the stack.</param>
    procedure PushTValue(const AValue: System.RTTI.TValue);

    /// <summary>
    /// Calls a Lua function with the specified parameters.
    /// </summary>
    /// <param name="AParams">An array of <see cref="TValue"/> representing the parameters to pass to the Lua function.</param>
    /// <returns>A <see cref="TValue"/> representing the return value of the Lua function.</returns>
    function CallFunction(const AParams: array of TValue): TValue;

    /// <summary>
    /// Saves the current Lua bytecode to a stream.
    /// </summary>
    /// <param name="AStream">The stream to which the bytecode will be saved.</param>
    procedure SaveByteCode(const AStream: TStream);

    /// <summary>
    /// Loads Lua bytecode from a stream.
    /// </summary>
    /// <param name="AStream">The stream containing the Lua bytecode.</param>
    /// <param name="AName">The name to assign to the loaded chunk.</param>
    /// <param name="AAutoRun">If True, the loaded code is automatically executed.</param>
    procedure LoadByteCode(const AStream: TStream; const AName: string; const AAutoRun: Boolean = True);

    /// <summary>
    /// Bundles a Lua script file into an executable with an embedded Lua payload.
    /// </summary>
    /// <param name="AInFilename">The path to the Lua script file.</param>
    /// <param name="AOutFilename">The path to the output executable file.</param>
    procedure Bundle(const AInFilename: string; const AOutFilename: string);

    /// <summary>
    /// Pushes a <see cref="TCallistoValue"/> onto the Lua stack.
    /// </summary>
    /// <param name="AValue">The <see cref="TCallistoValue"/> to push onto the stack.</param>
    procedure PushLuaValue(const AValue: TCallistoValue);

    /// <summary>
    /// Retrieves a <see cref="TCallistoValue"/> from the Lua stack at the specified index.
    /// </summary>
    /// <param name="AIndex">The index of the value on the stack (1-based).</param>
    /// <returns>The <see cref="TCallistoValue"/> retrieved from the stack.</returns>
    function GetLuaValue(const AIndex: Integer): TCallistoValue;

    /// <summary>
    /// Performs a Lua function call with the specified parameters.
    /// </summary>
    /// <param name="AParams">An array of <see cref="TCallistoValue"/> representing the parameters to pass to the Lua function.</param>
    /// <returns>A <see cref="TCallistoValue"/> representing the return value of the Lua function.</returns>
    function DoCall(const AParams: array of TCallistoValue): TCallistoValue; overload;

    /// <summary>
    /// Performs a Lua function call with a specified number of parameters already on the stack.
    /// </summary>
    /// <param name="AParamCount">The number of parameters on the stack to pass to the Lua function.</param>
    /// <returns>A <see cref="TCallistoValue"/> representing the return value of the Lua function.</returns>
    function DoCall(const AParamCount: Integer): TCallistoValue; overload;

    /// <summary>
    /// Cleans up the Lua stack by removing any leftover values.
    /// </summary>
    procedure CleanStack();

    /// <summary>
    /// Invokes the "OnBeforeReset" callback.
    /// </summary>
    procedure OnBeforeReset();

    /// <summary>
    /// Invokes the "OnAfterReset" callback.
    /// </summary>
    procedure OnAfterReset();

    /// <summary>
    /// Provides read-only access to the underlying Lua state.
    /// </summary>
    property State: Pointer read FState;

    /// <summary>
    /// Provides read-only access to the associated <see cref="TCallistoContext"/> instance.
    /// </summary>
    property Context: TCallistoContext read FContext;

  public
    /// <summary>
    /// Creates a new instance of the <see cref="TCallisto"/> class, initializing the Lua environment.
    /// </summary>
    constructor Create(); virtual;

    /// <summary>
    /// Destroys the <see cref="TCallisto"/> instance, releasing the Lua state and performing cleanup.
    /// </summary>
    destructor Destroy(); override;

    // Reset

    /// <summary>
    /// Retrieves the callback procedure invoked before the Lua state is reset.
    /// </summary>
    /// <returns>The <see cref="TCallistoResetCallback"/> procedure set as the before reset callback.</returns>
    function GetBeforeResetCallback(): TCallistoResetCallback;

    /// <summary>
    /// Sets the callback procedure to be invoked before the Lua state is reset.
    /// </summary>
    /// <param name="AHandler">The <see cref="TCallistoResetCallback"/> procedure to be called before reset.</param>
    /// <param name="AUserData">A pointer to user-defined data that will be passed to the callback.</param>
    procedure SetBeforeResetCallback(const AHandler: TCallistoResetCallback; const AUserData: Pointer);

    /// <summary>
    /// Retrieves the callback procedure invoked after the Lua state is reset.
    /// </summary>
    /// <returns>The <see cref="TCallistoResetCallback"/> procedure set as the after reset callback.</returns>
    function GetAfterResetCallback(): TCallistoResetCallback;

    /// <summary>
    /// Sets the callback procedure to be invoked after the Lua state is reset.
    /// </summary>
    /// <param name="AHandler">The <see cref="TCallistoResetCallback"/> procedure to be called after reset.</param>
    /// <param name="AUserData">A pointer to user-defined data that will be passed to the callback.</param>
    procedure SetAfterResetCallback(const AHandler: TCallistoResetCallback; const AUserData: Pointer);

    /// <summary>
    /// Resets the Lua state, clearing the environment and reinitializing it to its default state.
    /// </summary>
    procedure Reset();

    // Misc

    /// <summary>
    /// Adds a directory to the Lua search path.
    /// </summary>
    /// <param name="APath">The directory path to add to the Lua search path.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs while adding the search path.</exception>
    procedure AddSearchPath(const APath: string);

    // Console

    /// <summary>
    /// Prints a formatted string to the standard output (console) using Lua's string formatting capabilities.
    /// </summary>
    /// <param name="AText">The format string, potentially containing placeholders for the arguments.</param>
    /// <param name="AArgs">An array of const values to be inserted into the format string placeholders.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call or string formatting.</exception>
    procedure Print(const AText: string; const AArgs: array of const);

    /// <summary>
    /// Prints a formatted string to the standard output (console), followed by a newline, using Lua's string formatting capabilities.
    /// </summary>
    /// <param name="AText">The format string, potentially containing placeholders for the arguments.</param>
    /// <param name="AArgs">An array of const values to be inserted into the format string placeholders.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call or string formatting.</exception>
    procedure PrintLn(const AText: string; const AArgs: array of const);

    // Loading

    /// <summary>
    /// Loads Lua code from a stream.
    /// </summary>
    /// <param name="AStream">The stream containing the Lua code.</param>
    /// <param name="ASize">The size of the Lua code in bytes. If 0, the entire stream is read.</param>
    /// <param name="AAutoRun">If True, the loaded code is automatically executed.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during loading or execution of the Lua code.</exception>
    procedure LoadStream(const AStream: TStream; const ASize: NativeUInt = 0; const AAutoRun: Boolean = True);

    /// <summary>
    /// Loads Lua code from a file.
    /// </summary>
    /// <param name="AFilename">The path to the Lua file.</param>
    /// <param name="AAutoRun">If True, the loaded code is automatically executed.</param>
    /// <returns>True if the file was loaded successfully, False otherwise.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during loading or execution of the Lua code.</exception>
    function LoadFile(const AFilename: string; const AAutoRun: Boolean = True): Boolean;

    /// <summary>
    /// Loads Lua code from a string.
    /// </summary>
    /// <param name="AData">The string containing the Lua code.</param>
    /// <param name="AAutoRun">If True, the loaded code is automatically executed.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during loading or execution of the Lua code.</exception>
    procedure LoadString(const AData: string; const AAutoRun: Boolean = True);

    /// <summary>
    /// Loads Lua code from a memory buffer.
    /// </summary>
    /// <param name="AData">A pointer to the memory buffer containing the Lua code.</param>
    /// <param name="ASize">The size of the Lua code in bytes.</param>
    /// <param name="AAutoRun">If True, the loaded code is automatically executed.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during loading or execution of the Lua code.</exception>
    procedure LoadBuffer(const AData: Pointer; const ASize: NativeUInt; const AAutoRun: Boolean = True);

    // Execution

    /// <summary>
    /// Calls a Lua routine (function) with the specified name and parameters.
    /// </summary>
    /// <param name="AName">The name of the Lua routine to call.</param>
    /// <param name="AParams">An array of <see cref="TCallistoValue"/> representing the parameters to pass to the Lua routine.</param>
    /// <returns>A <see cref="TCallistoValue"/> representing the return value of the Lua routine.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    function Call(const AName: string; const AParams: array of TCallistoValue): TCallistoValue; overload;

    /// <summary>
    /// Prepares a Lua routine (function) for calling by pushing it onto the stack.
    /// </summary>
    /// <param name="AName">The name of the Lua routine to prepare for calling.</param>
    /// <returns>True if the routine was successfully pushed onto the stack, False otherwise.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    function PrepCall(const AName: string): Boolean;

    /// <summary>
    /// Calls a Lua routine (function) that has been previously prepared using <see cref="PrepCall"/>.
    /// </summary>
    /// <param name="AParamCount">The number of parameters to pass to the Lua routine.</param>
    /// <returns>A <see cref="TCallistoValue"/> representing the return value of the Lua routine.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    function Call(const AParamCount: Integer): TCallistoValue; overload;

    /// <summary>
    /// Runs the previously loaded Lua code.
    /// </summary>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the execution of the Lua code.</exception>
    procedure Run();

    // Routine/Variable exists

    /// <summary>
    /// Checks if a Lua routine (function) with the specified name exists.
    /// </summary>
    /// <param name="AName">The name of the Lua routine to check for.</param>
    /// <returns>True if the routine exists, False otherwise.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    function RoutineExist(const AName: string): Boolean;

    /// <summary>
    /// Checks if a Lua global variable with the specified name exists.
    /// </summary>
    /// <param name="AName">The name of the Lua global variable to check for.</param>
    /// <returns>True if the variable exists, False otherwise.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    function VariableExist(const AName: string): Boolean;

    // Global variables

    /// <summary>
    /// Sets the value of a Lua global variable.
    /// </summary>
    /// <param name="AName">The name of the Lua global variable to set.</param>
    /// <param name="AValue">The <see cref="TCallistoValue"/> to assign to the variable.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    procedure SetVariable(const AName: string; const AValue: TCallistoValue);

    /// <summary>
    /// Retrieves the value of a Lua global variable.
    /// </summary>
    /// <param name="AName">The name of the Lua global variable to retrieve.</param>
    /// <param name="AType">The expected <see cref="TCallistoValueType"/> of the variable's value.</param>
    /// <returns>A <see cref="TCallistoValue"/> representing the value of the Lua global variable.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call or if the retrieved value's type does not match the expected <paramref name="AType"/>.</exception>
    function GetVariable(const AName: string; const AType: TCallistoValueType): TCallistoValue;

    // Register routines

    /// <summary>
    /// Registers a Delphi procedure as a Lua routine (function), using raw function pointers.
    /// </summary>
    /// <param name="AName">The name by which the routine will be accessible in Lua.</param>
    /// <param name="AData">A pointer to data that will be passed to the registered function.</param>
    ////// <param name="ACode">A pointer to the Delphi procedure to be registered.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    procedure RegisterRoutine(const AName: string; const AData: Pointer; const ACode: Pointer); overload;

    /// <summary>
    /// Registers a Delphi procedure as a Lua routine (function).
    /// </summary>
    /// <param name="AName">The name by which the routine will be accessible in Lua.</param>
    /// <param name="ARoutine">The <see cref="TCallistoFunction"/> procedure to be registered.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    procedure RegisterRoutine(const AName: string; const ARoutine: TCallistoFunction); overload;

    // Auto-register routines

    /// <summary>
    /// Registers all public methods of a Delphi class as Lua routines.
    /// </summary>
    /// <param name="AClass">The class whose public methods will be registered as Lua routines.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    procedure RegisterRoutines(const AClass: TClass); overload;

    /// <summary>
    /// Registers all public methods of a Delphi object as Lua routines.
    /// </summary>
    /// <param name="AObject">The object whose public methods will be registered as Lua routines.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    procedure RegisterRoutines(const AObject: TObject); overload;

    /// <summary>
    /// Registers all public methods of a Delphi class as Lua routines within a specific table hierarchy.
    /// </summary>
    /// <param name="ATables">A period-separated string specifying the table hierarchy where the routines will be registered (e.g., "MyAPI.Utils").</param>
    /// <param name="AClass">The class whose public methods will be registered as Lua routines.</param>
    /// <param name="ATableName">An optional name for the table that will directly hold the routines. If empty, the class name is used.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    procedure RegisterRoutines(const ATables: string; const AClass: TClass; const ATableName: string = ''); overload;

    /// <summary>
    /// Registers all public methods of a Delphi object as Lua routines within a specific table hierarchy.
    /// </summary>
    /// <param name="ATables">A period-separated string specifying the table hierarchy where the routines will be registered (e.g., "MyAPI.Utils").</param>
    /// <param name="AObject">The object whose public methods will be registered as Lua routines.</param>
    /// <param name="ATableName">An optional name for the table that will directly hold the routines. If empty, the object's class name is used.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    procedure RegisterRoutines(const ATables: string; const AObject: TObject; const ATableName: string = ''); overload;


    /// <summary>
    /// Updates the arguments on the Lua stack, starting from a specified index.
    /// </summary>
    /// <param name="AStartIndex">The starting index (1-based) of the arguments to update.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    procedure UpdateArgs(const AStartIndex: Integer);

    // Garbage collection

    /// <summary>
    /// Sets the step size for Lua's garbage collector.
    /// </summary>
    /// <param name="AStep">The step size for the garbage collector.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    procedure SetGCStepSize(const AStep: Integer);

    /// <summary>
    /// Retrieves the current step size of Lua's garbage collector.
    /// </summary>
    /// <returns>The current garbage collector step size.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    function GetGCStepSize(): Integer;

    /// <summary>
    /// Retrieves the amount of memory currently used by Lua.
    /// </summary>
    /// <returns>The amount of memory used by Lua in kilobytes.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    function GetGCMemoryUsed(): Integer;

    /// <summary>
    /// Performs a full garbage collection cycle in Lua.
    /// </summary>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the Lua API call.</exception>
    procedure CollectGarbage();

    // Compilation

    /// <summary>
    /// Compiles Lua code from a file and saves the resulting bytecode to a stream.
    /// </summary>
    /// <param name="AFilename">The path to the Lua file to compile.</param>
    /// <param name="AStream">The stream to which the compiled bytecode will be saved.</param>
    /// <param name="ACleanOutput">If True, the output bytecode is stripped of debugging information.</param>
    /// <exception cref="ECallistoException">Thrown if an error occurs during compilation or saving of the bytecode.</exception>
    procedure CompileToStream(const AFilename: string; const AStream: TStream; const ACleanOutput: Boolean);

    // Payload

    /// <summary>
    /// Checks if a Lua payload exists within the current executable.
    /// </summary>
    /// <returns>True if a Lua payload exists, False otherwise.</returns>
    function PayloadExist(): Boolean;

    /// <summary>
    /// Runs the embedded Lua payload, if it exists.
    /// </summary>
    /// <returns>True if the payload was found and executed successfully, False otherwise.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the execution of the Lua payload.</exception>
    function RunPayload(): Boolean;

    /// <summary>
    /// Saves the current Lua state as an executable file with an embedded Lua payload.
    /// </summary>
    /// <param name="AFilename">The path to the executable file to create.</param>
    /// <returns>True if the executable was created successfully, False otherwise.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the creation of the executable.</exception>
    function SavePayloadExe(const AFilename: string): Boolean;

    /// <summary>
    /// Stores a Lua payload within an existing executable file.
    /// </summary>
    /// <param name="ASourceFilename">The path to the source executable file.</param>
    /// <param name="AEXEFilename">The path to the target executable file where the payload will be stored.</param>
    /// <returns>True if the payload was stored successfully, False otherwise.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the payload storage process.</exception>
    function StorePayload(const ASourceFilename, AEXEFilename: string): Boolean;

    // Resources

    /// <summary>
    /// Updates the icon of an executable file.
    /// </summary>
    /// <param name="AEXEFilename">The path to the executable file whose icon will be updated.</param>
    /// <param name="AIconFilename">The path to the icon file (.ico) to use.</param>
    /// <returns>True if the icon was updated successfully, False otherwise.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the icon update process.</exception>
    function UpdatePayloadIcon(const AEXEFilename, AIconFilename: string): Boolean;

    /// <summary>
    /// Updates the version information of an executable file.
    /// </summary>
    /// <param name="AEXEFilename">The path to the executable file whose version information will be updated.</param>
    /// <param name="AMajor">The major version number.</param>
    /// <param name="AMinor">The minor version number.</param>
    /// <param name="APatch">The patch version number.</param>
    /// <param name="AProductName">The product name.</param>
    /// <param name="ADescription">The product description.</param>
    /// <param name="AFilename">The original filename.</param>
    /// <param name="ACompanyName">The company name.</param>
    /// <param name="ACopyright">The copyright information.</param>
    /// <returns>True if the version information was updated successfully, False otherwise.</returns>
    /// <exception cref="ECallistoException">Thrown if an error occurs during the version information update process.</exception>
    function UpdatePayloadVersionInfo(const AEXEFilename: string; const AMajor, AMinor, APatch: Word; const AProductName, ADescription, AFilename, ACompanyName, ACopyright: string): Boolean;
  end;

{$ENDREGION}

implementation

{$REGION ' COMMON '}
var
  Marshaller: TMarshaller;

function EnableVirtualTerminalProcessing(): DWORD;
var
  HOut: THandle;
  LMode: DWORD;
begin
  HOut := GetStdHandle(STD_OUTPUT_HANDLE);
  if HOut = INVALID_HANDLE_VALUE then
  begin
    Result := GetLastError;
    Exit;
  end;

  if not GetConsoleMode(HOut, LMode) then
  begin
    Result := GetLastError;
    Exit;
  end;

  LMode := LMode or ENABLE_VIRTUAL_TERMINAL_PROCESSING;
  if not SetConsoleMode(HOut, LMode) then
  begin
    Result := GetLastError;
    Exit;
  end;

  Result := 0;  // Success
end;

function HasConsoleOutput: Boolean;
var
  Stdout: THandle;
begin
  Stdout := GetStdHandle(Std_Output_Handle);
  Win32Check(Stdout <> Invalid_Handle_Value);
  Result := Stdout <> 0;
end;

function IsValidWin64PE(const AFilePath: string): Boolean;
var
  LFile: TFileStream;
  LDosHeader: TImageDosHeader;
  LPEHeaderOffset: DWORD;
  LPEHeaderSignature: DWORD;
  LFileHeader: TImageFileHeader;
begin
  Result := False;

  if not FileExists(AFilePath) then
    Exit;

  LFile := TFileStream.Create(AFilePath, fmOpenRead or fmShareDenyWrite);
  try
    // Check if file is large enough for DOS header
    if LFile.Size < SizeOf(TImageDosHeader) then
      Exit;

    // Read DOS header
    LFile.ReadBuffer(LDosHeader, SizeOf(TImageDosHeader));

    // Check DOS signature
    if LDosHeader.e_magic <> IMAGE_DOS_SIGNATURE then // 'MZ'
      Exit;

      // Validate PE header offset
    LPEHeaderOffset := LDosHeader._lfanew;
    if LFile.Size < LPEHeaderOffset + SizeOf(DWORD) + SizeOf(TImageFileHeader) then
      Exit;

    // Seek to the PE header
    LFile.Position := LPEHeaderOffset;

    // Read and validate the PE signature
    LFile.ReadBuffer(LPEHeaderSignature, SizeOf(DWORD));
    if LPEHeaderSignature <> IMAGE_NT_SIGNATURE then // 'PE\0\0'
      Exit;

   // Read the file header
    LFile.ReadBuffer(LFileHeader, SizeOf(TImageFileHeader));

    // Check if it is a 64-bit executable
    if LFileHeader.Machine <> IMAGE_FILE_MACHINE_AMD64 then   Exit;

    // If all checks pass, it's a valid Win64 PE file
    Result := True;
  finally
    LFile.Free;
  end;
end;

function AddResFromMemory(const aModuleFile: string; const aName: string; aData: Pointer; aSize: Cardinal): Boolean;
var
  LHandle: THandle;
begin
  Result := False;
  if not TFile.Exists(aModuleFile) then Exit;
  LHandle := WinApi.Windows.BeginUpdateResourceW(PWideChar(aModuleFile), False);
  if LHandle <> 0 then
  begin
    WinApi.Windows.UpdateResourceW(LHandle, RT_RCDATA, PChar(aName), 1033 {ENGLISH, ENGLISH_US}, aData, aSize);
    Result := WinApi.Windows.EndUpdateResourceW(LHandle, False);
  end;
end;

function ResourceExists(aInstance: THandle; const aResName: string): Boolean;
begin
  Result := Boolean((FindResource(aInstance, PChar(aResName), RT_RCDATA) <> 0));
end;

function RemoveBOM(const AString: string): string; overload;
const
  UTF8BOM: array[0..2] of Byte = ($EF, $BB, $BF);
var
  LBytes: TBytes;
begin
  // Convert the input string to a byte array
  LBytes := TEncoding.UTF8.GetBytes(AString);

  // Check for UTF-8 BOM at the beginning
  if (Length(LBytes) >= 3) and
     (LBytes[0] = UTF8BOM[0]) and
     (LBytes[1] = UTF8BOM[1]) and
     (LBytes[2] = UTF8BOM[2]) then
  begin
    // Remove the BOM by copying the bytes after it
    Result := TEncoding.UTF8.GetString(LBytes, 3, Length(LBytes) - 3);
  end
  else
  begin
    // Return the original string if no BOM is detected
    Result := AString;
  end;
end;

function RemoveBOM(const ABytes: TBytes): TBytes; overload;
const
  UTF8BOM: array[0..2] of Byte = ($EF, $BB, $BF);
  UTF16LEBOM: array[0..1] of Byte = ($FF, $FE);
  UTF16BEBOM: array[0..1] of Byte = ($FE, $FF);
var
  LStartIndex: Integer;
begin
  Result := ABytes;

  // Check for UTF-8 BOM
  if (Length(ABytes) >= 3) and
     (ABytes[0] = UTF8BOM[0]) and
     (ABytes[1] = UTF8BOM[1]) and
     (ABytes[2] = UTF8BOM[2]) then
  begin
    LStartIndex := 3; // Skip the UTF-8 BOM
  end
  // Check for UTF-16 LE BOM
  else if (Length(ABytes) >= 2) and
          (ABytes[0] = UTF16LEBOM[0]) and
          (ABytes[1] = UTF16LEBOM[1]) then
  begin
    LStartIndex := 2; // Skip the UTF-16 LE BOM
  end
  // Check for UTF-16 BE BOM
  else if (Length(ABytes) >= 2) and
          (ABytes[0] = UTF16BEBOM[0]) and
          (ABytes[1] = UTF16BEBOM[1]) then
  begin
    LStartIndex := 2; // Skip the UTF-16 BE BOM
  end
  else
  begin
    Exit; // No BOM found, return the original array
  end;

  // Create a new array without the BOM
  Result := Copy(ABytes, LStartIndex, Length(ABytes) - LStartIndex);
end;

function AsUTF8(const AText: string; const ARemoveBOM: Boolean=False): Pointer;
var
  LText: string;
begin
  if ARemoveBOM then
    LText := RemoveBOM(AText)
  else
    LText := AText;
  Result := Marshaller.AsUtf8(LText).ToPointer;
end;

procedure UpdateIconResource(const AExeFilePath, AIconFilePath: string);
type
  TIconDir = packed record
    idReserved: Word;  // Reserved, must be 0
    idType: Word;      // Resource type, 1 for icons
    idCount: Word;     // Number of images in the file
  end;
  PIconDir = ^TIconDir;

  TGroupIconDirEntry = packed record
    bWidth: Byte;            // Width of the icon (0 means 256)
    bHeight: Byte;           // Height of the icon (0 means 256)
    bColorCount: Byte;       // Number of colors in the palette (0 if more than 256)
    bReserved: Byte;         // Reserved, must be 0
    wPlanes: Word;           // Color planes
    wBitCount: Word;         // Bits per pixel
    dwBytesInRes: Cardinal;  // Size of the image data
    nID: Word;               // Resource ID of the icon
  end;

  TGroupIconDir = packed record
    idReserved: Word;  // Reserved, must be 0
    idType: Word;      // Resource type, 1 for icons
    idCount: Word;     // Number of images in the file
    Entries: array[0..0] of TGroupIconDirEntry; // Variable-length array
  end;

  TIconResInfo = packed record
    bWidth: Byte;            // Width of the icon (0 means 256)
    bHeight: Byte;           // Height of the icon (0 means 256)
    bColorCount: Byte;       // Number of colors in the palette (0 if more than 256)
    bReserved: Byte;         // Reserved, must be 0
    wPlanes: Word;           // Color planes (should be 1)
    wBitCount: Word;         // Bits per pixel
    dwBytesInRes: Cardinal;  // Size of the image data
    dwImageOffset: Cardinal; // Offset of the image data in the file
  end;
  PIconResInfo = ^TIconResInfo;

var
  LUpdateHandle: THandle;
  LIconStream: TMemoryStream;
  LIconDir: PIconDir;
  LIconGroup: TMemoryStream;
  LIconRes: PByte;
  LIconID: Word;
  I: Integer;
  LGroupEntry: TGroupIconDirEntry;
begin

  if not FileExists(AExeFilePath) then
    raise Exception.Create('The specified executable file does not exist.');

  if not FileExists(AIconFilePath) then
    raise Exception.Create('The specified icon file does not exist.');

  LIconStream := TMemoryStream.Create;
  LIconGroup := TMemoryStream.Create;
  try
    // Load the icon file
    LIconStream.LoadFromFile(AIconFilePath);

    // Read the ICONDIR structure from the icon file
    LIconDir := PIconDir(LIconStream.Memory);
    if LIconDir^.idReserved <> 0 then
      raise Exception.Create('Invalid icon file format.');

    // Begin updating the executable's resources
    LUpdateHandle := BeginUpdateResource(PChar(AExeFilePath), False);
    if LUpdateHandle = 0 then
      raise Exception.Create('Failed to begin resource update.');

    try
      // Process each icon image in the .ico file
      LIconRes := PByte(LIconStream.Memory) + SizeOf(TIconDir);
      for I := 0 to LIconDir^.idCount - 1 do
      begin
        // Assign a unique resource ID for the RT_ICON
        LIconID := I + 1;

        // Add the icon image data as an RT_ICON resource
        if not UpdateResource(LUpdateHandle, RT_ICON, PChar(LIconID), LANG_NEUTRAL,
          Pointer(PByte(LIconStream.Memory) + PIconResInfo(LIconRes)^.dwImageOffset),
          PIconResInfo(LIconRes)^.dwBytesInRes) then
          raise Exception.CreateFmt('Failed to add RT_ICON resource for image %d.', [I]);

        // Move to the next icon entry
        Inc(LIconRes, SizeOf(TIconResInfo));
      end;

      // Create the GROUP_ICON resource
      LIconGroup.Clear;
      LIconGroup.Write(LIconDir^, SizeOf(TIconDir)); // Write ICONDIR header

      LIconRes := PByte(LIconStream.Memory) + SizeOf(TIconDir);
      // Write each GROUP_ICON entry
      for I := 0 to LIconDir^.idCount - 1 do
      begin
        // Populate the GROUP_ICON entry
        LGroupEntry.bWidth := PIconResInfo(LIconRes)^.bWidth;
        LGroupEntry.bHeight := PIconResInfo(LIconRes)^.bHeight;
        LGroupEntry.bColorCount := PIconResInfo(LIconRes)^.bColorCount;
        LGroupEntry.bReserved := 0;
        LGroupEntry.wPlanes := PIconResInfo(LIconRes)^.wPlanes;
        LGroupEntry.wBitCount := PIconResInfo(LIconRes)^.wBitCount;
        LGroupEntry.dwBytesInRes := PIconResInfo(LIconRes)^.dwBytesInRes;
        LGroupEntry.nID := I + 1; // Match resource ID for RT_ICON

        // Write the populated GROUP_ICON entry to the stream
        LIconGroup.Write(LGroupEntry, SizeOf(TGroupIconDirEntry));

        // Move to the next ICONDIRENTRY
        Inc(LIconRes, SizeOf(TIconResInfo));
      end;

      // Add the GROUP_ICON resource to the executable
      if not UpdateResource(LUpdateHandle, RT_GROUP_ICON, 'MAINICON', LANG_NEUTRAL,
        LIconGroup.Memory, LIconGroup.Size) then
        raise Exception.Create('Failed to add RT_GROUP_ICON resource.');

      // Commit the resource updates
      if not EndUpdateResource(LUpdateHandle, False) then
        raise Exception.Create('Failed to commit resource updates.');
    except
      EndUpdateResource(LUpdateHandle, True); // Discard changes on failure
      raise;
    end;
  finally
    LIconStream.Free;
    LIconGroup.Free;
  end;
end;

procedure UpdateVersionInfoResource(const PEFilePath: string; const AMajor, AMinor, APatch: Word; const AProductName, ADescription, AFilename, ACompanyName, ACopyright: string);
type
  { TVSFixedFileInfo }
  TVSFixedFileInfo = packed record
    dwSignature: DWORD;        // e.g. $FEEF04BD
    dwStrucVersion: DWORD;     // e.g. $00010000 for version 1.0
    dwFileVersionMS: DWORD;    // e.g. $00030075 for version 3.75
    dwFileVersionLS: DWORD;    // e.g. $00000031 for version 0.31
    dwProductVersionMS: DWORD; // Same format as dwFileVersionMS
    dwProductVersionLS: DWORD; // Same format as dwFileVersionLS
    dwFileFlagsMask: DWORD;    // = $3F for version "0011 1111"
    dwFileFlags: DWORD;        // e.g. VFF_DEBUG | VFF_PRERELEASE
    dwFileOS: DWORD;           // e.g. VOS_NT_WINDOWS32
    dwFileType: DWORD;         // e.g. VFT_APP
    dwFileSubtype: DWORD;      // e.g. VFT2_UNKNOWN
    dwFileDateMS: DWORD;       // file date
    dwFileDateLS: DWORD;       // file date
  end;

  { TStringPair }
  TStringPair = record
    Key: string;
    Value: string;
  end;

var
  LHandleUpdate: THandle;
  LVersionInfoStream: TMemoryStream;
  LFixedInfo: TVSFixedFileInfo;
  LDataPtr: Pointer;
  LDataSize: Integer;
  LStringFileInfoStart, LStringTableStart, LVarFileInfoStart: Int64;
  LStringPairs: array of TStringPair;
  LVErsion: string;
  LMajor, LMinor,LPatch: Word;
  LVSVersionInfoStart: Int64;
  LPair: TStringPair;
  LStringInfoEnd, LStringStart: Int64;
  LStringEnd, LFinalPos: Int64;
  LTranslationStart: Int64;

  procedure AlignStream(const AStream: TMemoryStream; const AAlignment: Integer);
  var
    LPadding: Integer;
    LPadByte: Byte;
  begin
    LPadding := (AAlignment - (AStream.Position mod AAlignment)) mod AAlignment;
    LPadByte := 0;
    while LPadding > 0 do
    begin
      AStream.WriteBuffer(LPadByte, 1);
      Dec(LPadding);
    end;
  end;

  procedure WriteWideString(const AStream: TMemoryStream; const AText: string);
  var
    LWideText: WideString;
  begin
    LWideText := WideString(AText);
    AStream.WriteBuffer(PWideChar(LWideText)^, (Length(LWideText) + 1) * SizeOf(WideChar));
  end;

  procedure SetFileVersionFromString(const AVersion: string; out AFileVersionMS, AFileVersionLS: DWORD);
  var
    LVersionParts: TArray<string>;
    LMajor, LMinor, LBuild, LRevision: Word;
  begin
    // Split the version string into its components
    LVersionParts := AVersion.Split(['.']);
    if Length(LVersionParts) <> 4 then
      raise Exception.Create('Invalid version string format. Expected "Major.Minor.Build.Revision".');

    // Parse each part into a Word
    LMajor := StrToIntDef(LVersionParts[0], 0);
    LMinor := StrToIntDef(LVersionParts[1], 0);
    LBuild := StrToIntDef(LVersionParts[2], 0);
    LRevision := StrToIntDef(LVersionParts[3], 0);

    // Set the high and low DWORD values
    AFileVersionMS := (DWORD(LMajor) shl 16) or DWORD(LMinor);
    AFileVersionLS := (DWORD(LBuild) shl 16) or DWORD(LRevision);
  end;

begin
  LMajor := EnsureRange(AMajor, 0, MaxWord);
  LMinor := EnsureRange(AMinor, 0, MaxWord);
  LPatch := EnsureRange(APatch, 0, MaxWord);
  LVersion := Format('%d.%d.%d.0', [LMajor, LMinor, LPatch]);

  SetLength(LStringPairs, 8);
  LStringPairs[0].Key := 'CompanyName';
  LStringPairs[0].Value := ACompanyName;
  LStringPairs[1].Key := 'FileDescription';
  LStringPairs[1].Value := ADescription;
  LStringPairs[2].Key := 'FileVersion';
  LStringPairs[2].Value := LVersion;
  LStringPairs[3].Key := 'InternalName';
  LStringPairs[3].Value := ADescription;
  LStringPairs[4].Key := 'LegalCopyright';
  LStringPairs[4].Value := ACopyright;
  LStringPairs[5].Key := 'OriginalFilename';
  LStringPairs[5].Value := AFilename;
  LStringPairs[6].Key := 'ProductName';
  LStringPairs[6].Value := AProductName;
  LStringPairs[7].Key := 'ProductVersion';
  LStringPairs[7].Value := LVersion;

  // Initialize fixed info structure
  FillChar(LFixedInfo, SizeOf(LFixedInfo), 0);
  LFixedInfo.dwSignature := $FEEF04BD;
  LFixedInfo.dwStrucVersion := $00010000;
  LFixedInfo.dwFileVersionMS := $00010000;
  LFixedInfo.dwFileVersionLS := $00000000;
  LFixedInfo.dwProductVersionMS := $00010000;
  LFixedInfo.dwProductVersionLS := $00000000;
  LFixedInfo.dwFileFlagsMask := $3F;
  LFixedInfo.dwFileFlags := 0;
  LFixedInfo.dwFileOS := VOS_NT_WINDOWS32;
  LFixedInfo.dwFileType := VFT_APP;
  LFixedInfo.dwFileSubtype := 0;
  LFixedInfo.dwFileDateMS := 0;
  LFixedInfo.dwFileDateLS := 0;

  // SEt MS and LS for FileVersion and ProductVersion
  SetFileVersionFromString(LVersion, LFixedInfo.dwFileVersionMS, LFixedInfo.dwFileVersionLS);
  SetFileVersionFromString(LVersion, LFixedInfo.dwProductVersionMS, LFixedInfo.dwProductVersionLS);

  LVersionInfoStream := TMemoryStream.Create;
  try
    // VS_VERSION_INFO
    LVSVersionInfoStart := LVersionInfoStream.Position;

    LVersionInfoStream.WriteData<Word>(0);  // Length placeholder
    LVersionInfoStream.WriteData<Word>(SizeOf(TVSFixedFileInfo));  // Value length
    LVersionInfoStream.WriteData<Word>(0);  // Type = 0
    WriteWideString(LVersionInfoStream, 'VS_VERSION_INFO');
    AlignStream(LVersionInfoStream, 4);

    // VS_FIXEDFILEINFO
    LVersionInfoStream.WriteBuffer(LFixedInfo, SizeOf(TVSFixedFileInfo));
    AlignStream(LVersionInfoStream, 4);

    // StringFileInfo
    LStringFileInfoStart := LVersionInfoStream.Position;
    LVersionInfoStream.WriteData<Word>(0);  // Length placeholder
    LVersionInfoStream.WriteData<Word>(0);  // Value length = 0
    LVersionInfoStream.WriteData<Word>(1);  // Type = 1
    WriteWideString(LVersionInfoStream, 'StringFileInfo');
    AlignStream(LVersionInfoStream, 4);

    // StringTable
    LStringTableStart := LVersionInfoStream.Position;
    LVersionInfoStream.WriteData<Word>(0);  // Length placeholder
    LVersionInfoStream.WriteData<Word>(0);  // Value length = 0
    LVersionInfoStream.WriteData<Word>(1);  // Type = 1
    WriteWideString(LVersionInfoStream, '040904B0'); // Match Delphi's default code page
    AlignStream(LVersionInfoStream, 4);

    // Write string pairs
    for LPair in LStringPairs do
    begin
      LStringStart := LVersionInfoStream.Position;

      LVersionInfoStream.WriteData<Word>(0);  // Length placeholder
      LVersionInfoStream.WriteData<Word>((Length(LPair.Value) + 1) * 2);  // Value length
      LVersionInfoStream.WriteData<Word>(1);  // Type = 1
      WriteWideString(LVersionInfoStream, LPair.Key);
      AlignStream(LVersionInfoStream, 4);
      WriteWideString(LVersionInfoStream, LPair.Value);
      AlignStream(LVersionInfoStream, 4);

      LStringEnd := LVersionInfoStream.Position;
      LVersionInfoStream.Position := LStringStart;
      LVersionInfoStream.WriteData<Word>(LStringEnd - LStringStart);
      LVersionInfoStream.Position := LStringEnd;
    end;

    LStringInfoEnd := LVersionInfoStream.Position;

    // Write StringTable length
    LVersionInfoStream.Position := LStringTableStart;
    LVersionInfoStream.WriteData<Word>(LStringInfoEnd - LStringTableStart);

    // Write StringFileInfo length
    LVersionInfoStream.Position := LStringFileInfoStart;
    LVersionInfoStream.WriteData<Word>(LStringInfoEnd - LStringFileInfoStart);

    // Start VarFileInfo where StringFileInfo ended
    LVarFileInfoStart := LStringInfoEnd;
    LVersionInfoStream.Position := LVarFileInfoStart;

    // VarFileInfo header
    LVersionInfoStream.WriteData<Word>(0);  // Length placeholder
    LVersionInfoStream.WriteData<Word>(0);  // Value length = 0
    LVersionInfoStream.WriteData<Word>(1);  // Type = 1 (text)
    WriteWideString(LVersionInfoStream, 'VarFileInfo');
    AlignStream(LVersionInfoStream, 4);

    // Translation value block
    LTranslationStart := LVersionInfoStream.Position;
    LVersionInfoStream.WriteData<Word>(0);  // Length placeholder
    LVersionInfoStream.WriteData<Word>(4);  // Value length = 4 (size of translation value)
    LVersionInfoStream.WriteData<Word>(0);  // Type = 0 (binary)
    WriteWideString(LVersionInfoStream, 'Translation');
    AlignStream(LVersionInfoStream, 4);

    // Write translation value
    LVersionInfoStream.WriteData<Word>($0409);  // Language ID (US English)
    LVersionInfoStream.WriteData<Word>($04B0);  // Unicode code page

    LFinalPos := LVersionInfoStream.Position;

    // Update VarFileInfo block length
    LVersionInfoStream.Position := LVarFileInfoStart;
    LVersionInfoStream.WriteData<Word>(LFinalPos - LVarFileInfoStart);

    // Update translation block length
    LVersionInfoStream.Position := LTranslationStart;
    LVersionInfoStream.WriteData<Word>(LFinalPos - LTranslationStart);

    // Update total version info length
    LVersionInfoStream.Position := LVSVersionInfoStart;
    LVersionInfoStream.WriteData<Word>(LFinalPos);

    LDataPtr := LVersionInfoStream.Memory;
    LDataSize := LVersionInfoStream.Size;

    // Update the resource
    LHandleUpdate := BeginUpdateResource(PChar(PEFilePath), False);
    if LHandleUpdate = 0 then
      RaiseLastOSError;

    try
      if not UpdateResourceW(LHandleUpdate, RT_VERSION, MAKEINTRESOURCE(1),
         MAKELANGID(LANG_NEUTRAL, SUBLANG_NEUTRAL), LDataPtr, LDataSize) then
        RaiseLastOSError;

      if not EndUpdateResource(LHandleUpdate, False) then
        RaiseLastOSError;
    except
      EndUpdateResource(LHandleUpdate, True);
      raise;
    end;
  finally
    LVersionInfoStream.Free;
  end;
end;

{$ENDREGION}

{$REGION ' LUAJIT API '}

const
  LUAJIT_VERSION = 'LuaJIT 2.1.1732813678';
  LUA_RELEASE = 'Lua 5.1.4';

  LUA_REGISTRYINDEX = (-10000);
  LUA_GLOBALSINDEX = (-10002);

  LUA_TNIL = 0;
  LUA_TBOOLEAN = 1;
  LUA_TLIGHTUSERDATA = 2;
  LUA_TNUMBER = 3;
  LUA_TSTRING = 4;
  LUA_TTABLE = 5;
  LUA_TFUNCTION = 6;
  LUA_TUSERDATA = 7;

  LUA_OK = 0;

  LUA_ERRRUN = 2;
  LUA_ERRSYNTAX = 3;
  LUA_ERRMEM = 4;
  LUA_ERRERR = 5;

  LUA_MULTRET = (-1);

  LUA_GCCOUNT = 3;
  LUA_GCSTEP = 5;

type
  Plua_State = Pointer;
  lua_Number = Double;
  lua_Integer = NativeInt;
  lua_CFunction = function(L: Plua_State): Integer; cdecl;
  lua_Writer = function(L: Plua_State; const p: Pointer; sz: NativeUInt; ud: Pointer): Integer; cdecl;

var
  luaL_loadbufferx: function(L: Plua_State; const buff: PUTF8Char; sz: NativeUInt; const name: PUTF8Char; const mode: PUTF8Char): Integer; cdecl;
  lua_pcall: function(L: Plua_State; nargs: Integer; nresults: Integer; errfunc: Integer): Integer; cdecl;
  lua_error: function(L: Plua_State): Integer; cdecl;
  lua_getfield: procedure(L: Plua_State; idx: Integer; const k: PUTF8Char); cdecl;
  lua_pushstring: procedure(L: Plua_State; const s: PUTF8Char); cdecl;
  lua_setfield: procedure(L: Plua_State; idx: Integer; const k: PUTF8Char); cdecl;
  luaL_loadfile: function(L: Plua_State; const filename: PUTF8Char): Integer; cdecl;
  lua_touserdata: function(L: Plua_State; idx: Integer): Pointer; cdecl;
  lua_pushnil: procedure(L: Plua_State); cdecl;
  luaL_error: function(L: Plua_State; const fmt: PUTF8Char): Integer varargs; cdecl;
  lua_insert: procedure(L: Plua_State; idx: Integer); cdecl;
  lua_remove: procedure(L: Plua_State; idx: Integer); cdecl;
  lua_type: function(L: Plua_State; idx: Integer): Integer; cdecl;
  luaL_loadstring: function(L: Plua_State; const s: PUTF8Char): Integer; cdecl;
  lua_pushinteger: procedure(L: Plua_State; n: lua_Integer); cdecl;
  lua_pushnumber: procedure(L: Plua_State; n: lua_Number); cdecl;
  lua_pushboolean: procedure(L: Plua_State; b: Integer); cdecl;
  lua_pushcclosure: procedure(L: Plua_State; fn: lua_CFunction; n: Integer); cdecl;
  lua_createtable: procedure(L: Plua_State; narr: Integer; nrec: Integer); cdecl;
  lua_settop: procedure(L: Plua_State; idx: Integer); cdecl;
  lua_gettop: function(L: Plua_State): Integer; cdecl;
  luaL_loadbuffer: function(L: Plua_State; const buff: PUTF8Char; sz: NativeUInt; const name: PUTF8Char): Integer; cdecl;
  lua_dump: function(L: Plua_State; writer: lua_Writer; data: Pointer): Integer; cdecl;
  lua_pushlightuserdata: procedure(L: Plua_State; p: Pointer); cdecl;
  lua_toboolean: function(L: Plua_State; idx: Integer): Integer; cdecl;
  lua_pushvalue: procedure(L: Plua_State; idx: Integer); cdecl;
  lua_tolstring: function(L: Plua_State; idx: Integer; len: PNativeUInt): PUTF8Char; cdecl;
  lua_tonumber: function(L: Plua_State; idx: Integer): lua_Number; cdecl;
  luaL_checklstring: function(L: Plua_State; numArg: Integer; l_: PNativeUInt): PUTF8Char; cdecl;
  luaL_newstate: function(): Plua_State; cdecl;
  luaL_openlibs: procedure(L: Plua_State); cdecl;
  lua_close: procedure(L: Plua_State); cdecl;
  lua_tointeger: function(L: Plua_State; idx: Integer): lua_Integer; cdecl;
  lua_isstring: function(L: Plua_State; idx: Integer): Integer; cdecl;
  lua_gc: function(L: Plua_State; what: Integer; data: Integer): Integer; cdecl;
  lua_rawseti: procedure(L: Plua_State; idx: Integer; n: Integer); cdecl;
  lua_rawgeti: procedure(L: Plua_State; idx: Integer; n: Integer); cdecl;
  lua_atpanic: function(L: Plua_State; panicf: lua_CFunction): lua_CFunction; cdecl;
  //luaL_newmetatable: function(L: Plua_State; const tname: PUTF8Char): Integer; cdecl; external;
  //lua_rawset: procedure(L: Plua_State; idx: Integer); cdecl; external;
  //lua_setmetatable: function(L: Plua_State; objindex: Integer): Integer; cdecl; external;
  //lua_newuserdataL function(L: Plua_State; sz: NativeUInt): Pointer; cdecl; external;
  //lua_getmetatable: function(L: Plua_State; objindex: Integer): Integer; cdecl; external;
  //lua_iscfunction: function(L: Plua_State; idx: Integer): Integer; cdecl; external;
  //lua_isnumber: function(L: Plua_State; idx: Integer): Integer; cdecl;


{ compatibility }
function lua_istable(L: Plua_State; N: Integer): Boolean;
begin
  Result := lua_type(L, N) = LUA_TTABLE;
end;

function lua_isfunction(aState: Pointer; n: Integer): Boolean;
begin
  Result := Boolean(lua_type(aState, n) = LUA_TFUNCTION);
end;

function lua_isvariable(aState: Pointer; n: Integer): Boolean;
var
  aType: Integer;
begin
  aType := lua_type(aState, n);

  if (aType = LUA_TBOOLEAN) or (aType = LUA_TLIGHTUSERDATA) or (aType = LUA_TNUMBER) or (aType = LUA_TSTRING) then
    Result := True
  else
    Result := False;
end;

procedure lua_newtable(aState: Pointer);
begin
  lua_createtable(aState, 0, 0);
end;

procedure lua_pop(aState: Pointer; n: Integer);
begin
  lua_settop(aState, -n - 1);
end;

function lua_getglobal(L: Plua_State; const AName: PAnsiChar): Integer;
begin
  // Get the value directly from the globals table
  lua_getfield(L, LUA_GLOBALSINDEX, AName);

  // Return the type of the value
  Result := lua_type(L, -1);
end;

procedure lua_setglobal(aState: Pointer; aName: PAnsiChar);
begin
  lua_setfield(aState, LUA_GLOBALSINDEX, aName);
end;

procedure lua_pushcfunction(aState: Pointer; aFunc: lua_CFunction);
begin
  lua_pushcclosure(aState, aFunc, 0);
end;

//procedure lua_register(aState: Pointer; aName: PAnsiChar; aFunc: lua_CFunction);
//begin
//  lua_pushcfunction(aState, aFunc);
//  lua_setglobal(aState, aName);
//end;

function lua_isnil(aState: Pointer; n: Integer): Boolean;
begin
  Result := Boolean(lua_type(aState, n) = LUA_TNIL);
end;

function lua_tostring(aState: Pointer; idx: Integer): string;
begin
  Result := string(lua_tolstring(aState, idx, nil));
end;

function luaL_dofile(aState: Pointer; aFilename: PAnsiChar): Integer;
Var
  Res: Integer;
begin
  Res := luaL_loadfile(aState, aFilename);
  if Res = 0 then
    Res := lua_pcall(aState, 0, 0, 0);
  Result := Res;
end;

function luaL_dostring(aState: Pointer; aStr: PAnsiChar): Integer;
Var
  Res: Integer;
begin
  Res := luaL_loadstring(aState, aStr);
  if Res = 0 then
    Res := lua_pcall(aState, 0, 0, 0);
  Result := Res;
end;

function luaL_dobuffer(aState: Pointer; aBuffer: Pointer; aSize: NativeUInt;
  aName: PAnsiChar): Integer;
var
  Res: Integer;
begin
  Res := luaL_loadbuffer(aState, aBuffer, aSize, aName);
  if Res = 0 then
    Res := lua_pcall(aState, 0, 0, 0);
  Result := Res;
end;

function lua_upvalueindex(i: Integer): Integer;
begin
  Result := LUA_GLOBALSINDEX - i;
end;

function luaL_checkstring(L: Plua_State; n: Integer): PAnsiChar;
begin
  Result := luaL_checklstring(L, n, nil);
end;

procedure luaL_requiref(L: Plua_State; modname: PAnsiChar; openf: lua_CFunction; glb: Integer);
begin
  lua_pushcfunction(L, openf);  // Push the module loader function
  lua_pushstring(L, modname);   // Push module name as argument

  // Use pcall instead of call for error handling
  if lua_pcall(L, 1, 1, 0) <> 0 then
  begin
    // Get error message and raise
    raise ECallistoException.CreateFmt('Error loading module "%s": %s',
      [modname, string(lua_tostring(L, -1))]);
  end;

  // Get _LOADED table from registry
  lua_getfield(L, LUA_REGISTRYINDEX, '_LOADED');
  if not lua_istable(L, -1) then
  begin
    lua_pop(L, 2);  // Pop module and non-table value
    raise ECallistoException.Create('_LOADED is not a table');
  end;

  // Store module in _LOADED[modname]
  lua_pushvalue(L, -2);        // Copy the module
  lua_setfield(L, -2, modname);
  lua_pop(L, 1);              // Pop _LOADED table

  // If global is requested, set it
  if glb <> 0 then
  begin
    lua_pushvalue(L, -1);     // Copy the module again
    lua_setglobal(L, modname);
  end;
end;

function luaL_getmetatable(L: Plua_State; const ATableName: PAnsiChar): Boolean;
begin
  // Get the metatable directly from the registry
  lua_getfield(L, LUA_REGISTRYINDEX, ATableName);

  // Check if the field exists and is a table
  Result := lua_type(L, -1) = LUA_TTABLE;
  if not Result then
    lua_pop(L, 1); // Remove the nil value from the stack if not found
end;

(*
function lua_isinteger(L: Plua_State; AIndex: Integer): Boolean;
var
  LNumber: lua_Number;
  LIntValue: Int64;
begin
  // First check if it's a number
  if lua_isnumber(L, AIndex) = 0 then
    Exit(False);

  // Get the number
  LNumber := lua_tonumber(L, AIndex);

  // Try to convert to integer and back, then compare
  LIntValue := Trunc(LNumber);
  Result := (LNumber = LIntValue) and
            (LIntValue >= -9223372036854775808.0) and  // Min Int64
            (LIntValue <= 9223372036854775807.0);      // Max Int64
end;
*)

procedure lua_updateargs(L: Plua_State; StartIndex: Integer);
var
  I: Integer;
begin
  // Delete the existing 'arg' table by assigning nil to it
  lua_pushnil(L);
  lua_setglobal(L, 'arg');

  // Create a new 'arg' table
  lua_newtable(L);

  // Populate the 'arg' table starting from StartIndex
  for I := StartIndex to ParamCount do
  begin
    lua_pushstring(L, PAnsiChar(UTF8Encode(ParamStr(I)))); // Push each argument as UTF-8 string
    lua_rawseti(L, -2, I - StartIndex);                    // Set table index (starting from 0)
  end;

  // Assign the new table to the global 'arg'
  lua_setglobal(L, 'arg');
end;

{$HINTS OFF}
function LuaPanic(L: Plua_State): Integer; cdecl;
begin
  // Get the error message from the Lua stack
  if LongBool(lua_isstring(L, -1)) then
    raise ECallistoException.Create('Lua panic: ' + string(lua_tostring(L, -1)))
  else
    raise ECallistoException.Create('Lua panic occurred without error message.');

  // Return value to conform to the Lua API; this will not be executed
  Result := 0;
end;
{$HINTS ON}

{$REGION ' LUA DEBUGGER '}
const
  DEBUGGER_LUA =
'''
--[[---------------------------------------------------------------------------
Acknowledgment:
   This code is based on the original debugger.lua project by
   slembcke, available at:
     https://github.com/slembcke/debugger.lua
   Credit goes to the original developer for their foundational work, which
   this unit builds upon.
-----------------------------------------------------------------------------]]

local dbg = {}

-- ANSI Colors
local COLOR_GRAY = string.char(27) .. "[90m"
local COLOR_RED = string.char(27) .. "[91m"
local COLOR_BLUE = string.char(27) .. "[94m"
local COLOR_YELLOW = string.char(27) .. "[33m"
local COLOR_RESET = string.char(27) .. "[0m"
local GREEN_CARET = string.char(27) .. "[92m => " .. COLOR_RESET

-- Check for Windows
local function is_windows()
    return package.config:sub(1,1) == '\\'
end

-- Check if colors are supported
local function supports_colors()
    if is_windows() then
        -- Windows 10+ supports ANSI colors
        local version = os.getenv("WINVER") or os.getenv("VERSION")
        return version ~= nil
    else
        -- Unix-like systems
        return os.getenv("TERM") and os.getenv("TERM") ~= "dumb"
    end
end

-- Disable colors if terminal doesn't support them
if not supports_colors then
    COLOR_GRAY = ""
    COLOR_RED = ""
    COLOR_BLUE = ""
    COLOR_YELLOW = ""
    COLOR_RESET = ""
    GREEN_CARET = " => "
end

-- State tracking
local current_frame = 0
local step_mode = nil
local current_func = nil
local last_cmd = "h"  -- Move last_cmd to file scope

-- Source cache
local source_cache = {}

local function pretty(obj, max_depth)
    max_depth = max_depth or 3
    local function pp(obj, depth)
        if depth > max_depth then return tostring(obj) end
        if type(obj) == "string" then return string.format("%q", obj) end
        if type(obj) ~= "table" then return tostring(obj) end
        local mt = getmetatable(obj)
        if mt and mt.__tostring then return tostring(obj) end

        local parts = {}
        for k, v in pairs(obj) do
            local key = type(k) == "string" and k or "[" .. pp(k, depth) .. "]"
            table.insert(parts, key .. " = " .. pp(v, depth + 1))
        end
        return "{" .. table.concat(parts, ", ") .. "}"
    end
    return pp(obj, 1)
end

local function get_locals(level)
    local vars = {}
    local i = 1
    while true do
        local name, value = debug.getlocal(level, i)
        if not name then break end
        if name:sub(1, 1) ~= "(" then  -- Skip internal variables
            vars[name] = value
        end
        i = i + 1
    end
    return vars
end

local function get_upvalues(func)
    local vars = {}
    local i = 1
    while true do
        local name, value = debug.getupvalue(func, i)
        if not name then break end
        vars[name] = value
        i = i + 1
    end
    return vars
end

local function get_source_lines(info)
    if source_cache[info.source] then
        return source_cache[info.source]
    end

    local lines = {}
    if info.source:sub(1, 1) == "@" then
        local file = io.open(info.source:sub(2))
        if file then
            for line in file:lines() do
                table.insert(lines, line)
            end
            file:close()
        end
    else
        for line in info.source:gmatch("[^\n]+") do
            table.insert(lines, line)
        end
    end
    source_cache[info.source] = lines
    return lines
end

local function get_short_src(source)
    if source:sub(1, 1) == "@" then
        return source:sub(2)  -- Remove @ prefix
    end
    -- For non-file sources, return just "[string]"
    return "[string]"
end

local function print_break_location(info, reason)
    reason = reason or "dbg()"
    local short_src = get_short_src(info.source)
    local prefix = reason and (COLOR_YELLOW .. "break via " .. COLOR_RED .. reason .. GREEN_CARET) or ""
    print(string.format("%s%s%s:%s%d%s in %s",
        prefix,
        COLOR_BLUE, short_src,
        COLOR_YELLOW, info.currentline,
        COLOR_RESET,
        info.name or "main chunk"
    ))
end

local function print_frame_source(info, context_lines)
    context_lines = context_lines or 2
    local lines = get_source_lines(info)
    if not lines then return end

    local line_num = info.currentline
    for i = math.max(1, line_num - context_lines),
             math.min(#lines, line_num + context_lines) do
        local marker = i == line_num and GREEN_CARET or "    "
        print(string.format(COLOR_GRAY .. "% 4d%s%s",
            i, marker, lines[i] .. COLOR_RESET))
    end
end

local function evaluate_expression(expr, level)
    if not expr or expr == "" then
        print(COLOR_RED .. "Usage: p <expression>" .. COLOR_RESET)
        return
    end

    local locals = get_locals(level)
    local info = debug.getinfo(level, "f")
    local upvalues = get_upvalues(info.func)

    -- Create environment with locals, upvalues, and globals
    local env = setmetatable(locals, {__index = _G})
    for k, v in pairs(upvalues) do env[k] = v end

    local chunk, err = load("return " .. expr, "=expr", "t", env)
    if not chunk then
        print(COLOR_RED .. "Error: " .. err .. COLOR_RESET)
        return
    end

    local success, result = pcall(chunk)
    if not success then
        print(COLOR_RED .. "Error: " .. result .. COLOR_RESET)
        return
    end

    print(COLOR_BLUE .. expr .. GREEN_CARET .. pretty(result))
end

local function print_locals(level)
    local locals = get_locals(level)
    local info = debug.getinfo(level, "f")
    local upvalues = get_upvalues(info.func)

    print(COLOR_BLUE .. "Local variables:" .. COLOR_RESET)
    local sorted_locals = {}
    for name, value in pairs(locals) do
        table.insert(sorted_locals, {name = name, value = value})
    end
    table.sort(sorted_locals, function(a, b) return a.name < b.name end)

    for _, var in ipairs(sorted_locals) do
        print(string.format("  %s = %s", var.name, pretty(var.value)))
    end

    if next(upvalues) then
        print(COLOR_BLUE .. "\nUpvalues:" .. COLOR_RESET)
        local sorted_upvalues = {}
        for name, value in pairs(upvalues) do
            table.insert(sorted_upvalues, {name = name, value = value})
        end
        table.sort(sorted_upvalues, function(a, b) return a.name < b.name end)

        for _, var in ipairs(sorted_upvalues) do
            print(string.format("  %s = %s", var.name, pretty(var.value)))
        end
    end
end

local function print_help()
    local help = {
        {cmd = "<return>", desc = "re-run last command"},
        {cmd = "c(ontinue)", desc = "continue execution"},
        {cmd = "s(tep)", desc = "step forward by one line (into functions)"},
        {cmd = "n(ext)", desc = "step forward by one line (skipping over functions)"},
        {cmd = "f(inish)", desc = "step forward until exiting the current function"},
        {cmd = "u(p)", desc = "move up the stack by one frame"},
        {cmd = "d(own)", desc = "move down the stack by one frame"},
        {cmd = "w(here) [count]", desc = "print source code around the current line"},
        {cmd = "p(rint) [expr]", desc = "evaluate expression and print the result"},
        {cmd = "t(race)", desc = "print the stack trace"},
        {cmd = "l(ocals)", desc = "print the function arguments, locals and upvalues"},
        {cmd = "h(elp)", desc = "print this message"},
        {cmd = "q(uit)", desc = "halt execution"},
    }

    for _, item in ipairs(help) do
        print(string.format("%s%s%s%s%s",
            COLOR_BLUE, item.cmd,
            COLOR_YELLOW, GREEN_CARET, item.desc))
    end
end

local function print_stack_trace()
    local level = 1
    print(COLOR_BLUE .. "Stack trace:" .. COLOR_RESET)
    while true do
        local info = debug.getinfo(level, "Snl")
        if not info then break end

        local is_current = level == current_frame + 2
        local marker = is_current and GREEN_CARET or "    "
        local name = info.name or "<unknown>"
        local source = get_short_src(info.source)

        print(string.format(COLOR_GRAY .. "% 4d%s%s:%d in %s",
            level - 1, marker, source, info.currentline, name))

        level = level + 1
    end
end

-- Debug hook
local function debug_hook(event, line)

    if event ~= "line" then return end

    if step_mode == "over" and current_func then
        local info = debug.getinfo(2, "f")
        if info.func ~= current_func then return end
    end

    local info = debug.getinfo(2, "Snl")
    if not info then return end

    print_break_location(info)
    print_frame_source(info)

    while true do
        io.write(COLOR_RED .. "dbg> " .. COLOR_RESET)
        local input = io.read()
        if not input then return end

        -- Handle empty input - reuse last command
        if input == "" then
            input = last_cmd
        else
            last_cmd = input  -- Update last_cmd only for non-empty input
        end

        local cmd, args = input:match("^(%S+)%s*(.*)")
        cmd = cmd or ""

        if cmd == "c" then
            step_mode = nil
            debug.sethook()
            return
        elseif cmd == "s" then
            step_mode = "into"
            return
        elseif cmd == "n" then
            step_mode = "over"
            current_func = debug.getinfo(2, "f").func
            return
        elseif cmd == "f" then
            step_mode = "out"
            current_func = debug.getinfo(2, "f").func
            return
        elseif cmd == "l" then
            print_locals(2 + current_frame)
        elseif cmd == "t" then
            print_stack_trace()
        elseif cmd == "w" then
            local count = tonumber(args) or 5
            print_frame_source(info, count)
        elseif cmd == "u" then
            local new_frame = current_frame + 1
            local frame_info = debug.getinfo(new_frame + 2, "Snl")
            if frame_info then
                current_frame = new_frame
                print_break_location(frame_info)
                print_frame_source(frame_info)
            else
                print("Already at top of stack")
            end
        elseif cmd == "d" then
            if current_frame > 0 then
                current_frame = current_frame - 1
                local frame_info = debug.getinfo(current_frame + 2, "Snl")
                print_break_location(frame_info)
                print_frame_source(frame_info)
            else
                print("Already at bottom of stack")
            end
        elseif cmd == "p" then
            evaluate_expression(args, 2 + current_frame)
        elseif cmd == "h" then
            print_help()
        elseif cmd == "q" then
            os.exit(0)
        else
            print(COLOR_RED .. "Unknown command. Type 'h' for help." .. COLOR_RESET)
        end
    end
end

-- Make dbg callable
setmetatable(dbg, {
    __call = function(_, condition)
        if condition then return end
        current_frame = 0
        step_mode = "into"
        debug.sethook(debug_hook, "l")
    end
})

-- Expose API
dbg.pretty = pretty
dbg.pretty_depth = 3
dbg.auto_where = false

return dbg
''';

function luaopen_debugger(lua: Plua_State): Integer; cdecl;
begin
  if (luaL_loadbufferx(lua, DEBUGGER_LUA, Length(DEBUGGER_LUA), '<debugger.lua>', nil) <> 0) or
     (lua_pcall(lua, 0, LUA_MULTRET, 0) <> 0) then
    lua_error(lua);
  Result := 1;
end;

const
  MODULE_NAME: PAnsiChar = 'DEBUGGER_LUA_MODULE';
  MSGH: PAnsiChar = 'DEBUGGER_LUA_MSGH';

procedure dbg_setup(lua: Plua_State; name: PAnsiChar; globalName: PAnsiChar; readFunc: lua_CFunction; writeFunc: lua_CFunction); cdecl;
begin
  // Check that the module name was not already defined.
  lua_getfield(lua, LUA_REGISTRYINDEX, MODULE_NAME);
  Assert(lua_isnil(lua, -1) or (System.AnsiStrings.StrComp(name, luaL_checkstring(lua, -1)) = 0));
  lua_pop(lua, 1);

  // Push the module name into the registry.
  lua_pushstring(lua, name);
  lua_setfield(lua, LUA_REGISTRYINDEX, MODULE_NAME);

  // Preload the module
  luaL_requiref(lua, name, luaopen_debugger, 0);

  // Insert the msgh function into the registry.
  lua_getfield(lua, -1, 'msgh');
  lua_setfield(lua, LUA_REGISTRYINDEX, MSGH);

  if Assigned(readFunc) then
  begin
    lua_pushcfunction(lua, readFunc);
    lua_setfield(lua, -2, 'read');
  end;

  if Assigned(writeFunc) then
  begin
    lua_pushcfunction(lua, writeFunc);
    lua_setfield(lua, -2, 'write');
  end;

  if globalName <> nil then
  begin
    lua_setglobal(lua, globalName);
  end else
  begin
    lua_pop(lua, 1);
  end;
end;

procedure dbg_setup_default(lua: Plua_State); cdecl;
begin
  dbg_setup(lua, 'debugger', 'dbg', nil, nil);
end;

function dbg_pcall(lua: Plua_State; nargs: Integer; nresults: Integer; msgh: Integer): Integer; cdecl;
begin
  // Call regular lua_pcall() if a message handler is provided.
  if msgh <> 0 then
    Exit(lua_pcall(lua, nargs, nresults, msgh));

  // Grab the msgh function out of the registry.
  lua_getfield(lua, LUA_REGISTRYINDEX, PUTF8Char(MSGH));
  if lua_isnil(lua, -1) then
    luaL_error(lua, 'Tried to call dbg_call() before calling dbg_setup().');

  // Move the error handler just below the function.
  msgh := lua_gettop(lua) - (1 + nargs);
  lua_insert(lua, msgh);

  // Call the function.
  Result := lua_pcall(lua, nargs, nresults, msgh);

  // Remove the debug handler.
  lua_remove(lua, msgh);
end;

function dbg_dofile(lua: Plua_State; filename: PAnsiChar): Integer;
begin
  Result := luaL_loadfile(lua, filename);
  if Result = 0 then
    Result := dbg_pcall(lua, 0, LUA_MULTRET, 0);
end;
{$ENDREGION}

{$ENDREGION}

{$REGION ' CALLISTO '}

{$REGION ' LUA CODE '}
const cLOADER_LUA : array[1..436] of Byte = (
$2D, $2D, $20, $55, $74, $69, $6C, $69, $74, $79, $20, $66, $75, $6E, $63, $74,
$69, $6F, $6E, $20, $66, $6F, $72, $20, $68, $61, $76, $69, $6E, $67, $20, $61,
$20, $77, $6F, $72, $6B, $69, $6E, $67, $20, $69, $6D, $70, $6F, $72, $74, $20,
$66, $75, $6E, $63, $74, $69, $6F, $6E, $0A, $2D, $2D, $20, $46, $65, $65, $6C,
$20, $66, $72, $65, $65, $20, $74, $6F, $20, $75, $73, $65, $20, $69, $74, $20,
$69, $6E, $20, $79, $6F, $75, $72, $20, $6F, $77, $6E, $20, $70, $72, $6F, $6A,
$65, $63, $74, $73, $0A, $28, $66, $75, $6E, $63, $74, $69, $6F, $6E, $28, $29,
$0A, $20, $20, $20, $20, $6C, $6F, $63, $61, $6C, $20, $73, $63, $72, $69, $70,
$74, $5F, $63, $61, $63, $68, $65, $20, $3D, $20, $7B, $7D, $3B, $0A, $20, $20,
$20, $20, $66, $75, $6E, $63, $74, $69, $6F, $6E, $20, $69, $6D, $70, $6F, $72,
$74, $28, $6E, $61, $6D, $65, $29, $0A, $20, $20, $20, $20, $20, $20, $20, $20,
$69, $66, $20, $73, $63, $72, $69, $70, $74, $5F, $63, $61, $63, $68, $65, $5B,
$6E, $61, $6D, $65, $5D, $20, $3D, $3D, $20, $6E, $69, $6C, $20, $74, $68, $65,
$6E, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $73, $63,
$72, $69, $70, $74, $5F, $63, $61, $63, $68, $65, $5B, $6E, $61, $6D, $65, $5D,
$20, $3D, $20, $6C, $6F, $61, $64, $66, $69, $6C, $65, $28, $6E, $61, $6D, $65,
$29, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $65, $6E, $64, $0A, $20, $20,
$20, $20, $20, $20, $20, $20, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $69,
$66, $20, $73, $63, $72, $69, $70, $74, $5F, $63, $61, $63, $68, $65, $5B, $6E,
$61, $6D, $65, $5D, $20, $7E, $3D, $20, $6E, $69, $6C, $20, $74, $68, $65, $6E,
$0A, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $72, $65, $74,
$75, $72, $6E, $20, $73, $63, $72, $69, $70, $74, $5F, $63, $61, $63, $68, $65,
$5B, $6E, $61, $6D, $65, $5D, $28, $29, $0A, $20, $20, $20, $20, $20, $20, $20,
$20, $65, $6E, $64, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $65, $72, $72,
$6F, $72, $28, $22, $46, $61, $69, $6C, $65, $64, $20, $74, $6F, $20, $6C, $6F,
$61, $64, $20, $73, $63, $72, $69, $70, $74, $20, $22, $20, $2E, $2E, $20, $6E,
$61, $6D, $65, $29, $0A, $20, $20, $20, $20, $65, $6E, $64, $0A, $65, $6E, $64,
$29, $28, $29, $0A
);

const cLUABUNDLE_LUA : array[1..3478] of Byte = (
$28, $66, $75, $6E, $63, $74, $69, $6F, $6E, $28, $61, $72, $67, $73, $29, $0D,
$0A, $6C, $6F, $63, $61, $6C, $20, $6D, $6F, $64, $75, $6C, $65, $73, $20, $3D,
$20, $7B, $7D, $0D, $0A, $6D, $6F, $64, $75, $6C, $65, $73, $5B, $27, $61, $70,
$70, $2F, $62, $75, $6E, $64, $6C, $65, $5F, $6D, $61, $6E, $61, $67, $65, $72,
$2E, $6C, $75, $61, $27, $5D, $20, $3D, $20, $66, $75, $6E, $63, $74, $69, $6F,
$6E, $28, $2E, $2E, $2E, $29, $0D, $0A, $2D, $2D, $20, $43, $6C, $61, $73, $73,
$20, $66, $6F, $72, $20, $63, $6F, $6C, $6C, $65, $63, $74, $69, $6E, $67, $20,
$74, $68, $65, $20, $66, $69, $6C, $65, $27, $73, $20, $63, $6F, $6E, $74, $65,
$6E, $74, $20, $61, $6E, $64, $20, $62, $75, $69, $6C, $64, $69, $6E, $67, $20,
$61, $20, $62, $75, $6E, $64, $6C, $65, $20, $66, $69, $6C, $65, $0D, $0A, $6C,
$6F, $63, $61, $6C, $20, $73, $6F, $75, $72, $63, $65, $5F, $70, $61, $72, $73,
$65, $72, $20, $3D, $20, $69, $6D, $70, $6F, $72, $74, $28, $22, $61, $70, $70,
$2F, $73, $6F, $75, $72, $63, $65, $5F, $70, $61, $72, $73, $65, $72, $2E, $6C,
$75, $61, $22, $29, $0D, $0A, $0D, $0A, $72, $65, $74, $75, $72, $6E, $20, $66,
$75, $6E, $63, $74, $69, $6F, $6E, $28, $65, $6E, $74, $72, $79, $5F, $70, $6F,
$69, $6E, $74, $29, $0D, $0A, $20, $20, $20, $20, $6C, $6F, $63, $61, $6C, $20,
$73, $65, $6C, $66, $20, $3D, $20, $7B, $7D, $0D, $0A, $20, $20, $20, $20, $6C,
$6F, $63, $61, $6C, $20, $66, $69, $6C, $65, $73, $20, $3D, $20, $7B, $7D, $0D,
$0A, $20, $20, $20, $20, $0D, $0A, $20, $20, $20, $20, $2D, $2D, $20, $53, $65,
$61, $72, $63, $68, $65, $73, $20, $74, $68, $65, $20, $67, $69, $76, $65, $6E,
$20, $66, $69, $6C, $65, $20, $72, $65, $63, $75, $72, $73, $69, $76, $65, $6C,
$79, $20, $66, $6F, $72, $20, $69, $6D, $70, $6F, $72, $74, $20, $66, $75, $6E,
$63, $74, $69, $6F, $6E, $20, $63, $61, $6C, $6C, $73, $0D, $0A, $20, $20, $20,
$20, $73, $65, $6C, $66, $2E, $70, $72, $6F, $63, $65, $73, $73, $5F, $66, $69,
$6C, $65, $20, $3D, $20, $66, $75, $6E, $63, $74, $69, $6F, $6E, $28, $66, $69,
$6C, $65, $6E, $61, $6D, $65, $29, $0D, $0A, $20, $20, $20, $20, $20, $20, $20,
$20, $6C, $6F, $63, $61, $6C, $20, $70, $61, $72, $73, $65, $72, $20, $3D, $20,
$73, $6F, $75, $72, $63, $65, $5F, $70, $61, $72, $73, $65, $72, $28, $66, $69,
$6C, $65, $6E, $61, $6D, $65, $29, $0D, $0A, $20, $20, $20, $20, $20, $20, $20,
$20, $66, $69, $6C, $65, $73, $5B, $66, $69, $6C, $65, $6E, $61, $6D, $65, $5D,
$20, $3D, $20, $70, $61, $72, $73, $65, $72, $2E, $63, $6F, $6E, $74, $65, $6E,
$74, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $0D, $0A, $20, $20, $20,
$20, $20, $20, $20, $20, $66, $6F, $72, $20, $5F, $2C, $20, $66, $20, $69, $6E,
$20, $70, $61, $69, $72, $73, $28, $70, $61, $72, $73, $65, $72, $2E, $69, $6E,
$63, $6C, $75, $64, $65, $73, $29, $20, $64, $6F, $0D, $0A, $20, $20, $20, $20,
$20, $20, $20, $20, $20, $20, $20, $20, $73, $65, $6C, $66, $2E, $70, $72, $6F,
$63, $65, $73, $73, $5F, $66, $69, $6C, $65, $28, $66, $29, $0D, $0A, $20, $20,
$20, $20, $20, $20, $20, $20, $65, $6E, $64, $0D, $0A, $20, $20, $20, $20, $65,
$6E, $64, $0D, $0A, $20, $20, $20, $20, $0D, $0A, $20, $20, $20, $20, $2D, $2D,
$20, $43, $72, $65, $61, $74, $65, $20, $61, $20, $62, $75, $6E, $64, $6C, $65,
$20, $66, $69, $6C, $65, $20, $77, $68, $69, $63, $68, $20, $63, $6F, $6E, $74,
$61, $69, $6E, $73, $20, $74, $68, $65, $20, $64, $65, $74, $65, $63, $74, $65,
$64, $20, $66, $69, $6C, $65, $73, $0D, $0A, $20, $20, $20, $20, $73, $65, $6C,
$66, $2E, $62, $75, $69, $6C, $64, $5F, $62, $75, $6E, $64, $6C, $65, $20, $3D,
$20, $66, $75, $6E, $63, $74, $69, $6F, $6E, $28, $64, $65, $73, $74, $5F, $66,
$69, $6C, $65, $29, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $6C, $6F,
$63, $61, $6C, $20, $66, $69, $6C, $65, $20, $3D, $20, $69, $6F, $2E, $6F, $70,
$65, $6E, $28, $64, $65, $73, $74, $5F, $66, $69, $6C, $65, $2C, $20, $22, $77,
$22, $29, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $0D, $0A, $20, $20,
$20, $20, $20, $20, $20, $20, $66, $69, $6C, $65, $3A, $77, $72, $69, $74, $65,
$28, $22, $28, $66, $75, $6E, $63, $74, $69, $6F, $6E, $28, $61, $72, $67, $73,
$29, $5C, $6E, $22, $29, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $66,
$69, $6C, $65, $3A, $77, $72, $69, $74, $65, $28, $22, $6C, $6F, $63, $61, $6C,
$20, $6D, $6F, $64, $75, $6C, $65, $73, $20, $3D, $20, $7B, $7D, $5C, $6E, $22,
$29, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $0D, $0A, $20, $20, $20,
$20, $20, $20, $20, $20, $2D, $2D, $20, $43, $72, $65, $61, $74, $65, $20, $61,
$20, $73, $6F, $72, $74, $65, $64, $20, $6C, $69, $73, $74, $20, $6F, $66, $20,
$6B, $65, $79, $73, $20, $73, $6F, $20, $74, $68, $65, $20, $6F, $75, $74, $70,
$75, $74, $20, $77, $69, $6C, $6C, $20, $62, $65, $20, $74, $68, $65, $20, $73,
$61, $6D, $65, $20, $77, $68, $65, $6E, $20, $74, $68, $65, $20, $69, $6E, $70,
$75, $74, $20, $64, $6F, $65, $73, $20, $6E, $6F, $74, $20, $63, $68, $61, $6E,
$67, $65, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $6C, $6F, $63, $61,
$6C, $20, $66, $69, $6C, $65, $6E, $61, $6D, $65, $73, $20, $3D, $20, $7B, $7D,
$0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $66, $6F, $72, $20, $66, $69,
$6C, $65, $6E, $61, $6D, $65, $2C, $20, $5F, $20, $69, $6E, $20, $70, $61, $69,
$72, $73, $28, $66, $69, $6C, $65, $73, $29, $20, $64, $6F, $0D, $0A, $20, $20,
$20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $74, $61, $62, $6C, $65, $2E,
$69, $6E, $73, $65, $72, $74, $28, $66, $69, $6C, $65, $6E, $61, $6D, $65, $73,
$2C, $20, $66, $69, $6C, $65, $6E, $61, $6D, $65, $29, $0D, $0A, $20, $20, $20,
$20, $20, $20, $20, $20, $65, $6E, $64, $0D, $0A, $20, $20, $20, $20, $20, $20,
$20, $20, $74, $61, $62, $6C, $65, $2E, $73, $6F, $72, $74, $28, $66, $69, $6C,
$65, $6E, $61, $6D, $65, $73, $29, $0D, $0A, $20, $20, $20, $20, $20, $20, $20,
$20, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $2D, $2D, $20, $41, $64,
$64, $20, $66, $69, $6C, $65, $73, $20, $61, $73, $20, $6D, $6F, $64, $75, $6C,
$65, $73, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $66, $6F, $72, $20,
$5F, $2C, $20, $66, $69, $6C, $65, $6E, $61, $6D, $65, $20, $69, $6E, $20, $70,
$61, $69, $72, $73, $28, $66, $69, $6C, $65, $6E, $61, $6D, $65, $73, $29, $20,
$64, $6F, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20,
$66, $69, $6C, $65, $3A, $77, $72, $69, $74, $65, $28, $22, $6D, $6F, $64, $75,
$6C, $65, $73, $5B, $27, $22, $29, $0D, $0A, $20, $20, $20, $20, $20, $20, $20,
$20, $20, $20, $20, $20, $66, $69, $6C, $65, $3A, $77, $72, $69, $74, $65, $28,
$66, $69, $6C, $65, $6E, $61, $6D, $65, $29, $0D, $0A, $20, $20, $20, $20, $20,
$20, $20, $20, $20, $20, $20, $20, $66, $69, $6C, $65, $3A, $77, $72, $69, $74,
$65, $28, $22, $27, $5D, $20, $3D, $20, $66, $75, $6E, $63, $74, $69, $6F, $6E,
$28, $2E, $2E, $2E, $29, $5C, $6E, $22, $29, $0D, $0A, $20, $20, $20, $20, $20,
$20, $20, $20, $20, $20, $20, $20, $66, $69, $6C, $65, $3A, $77, $72, $69, $74,
$65, $28, $66, $69, $6C, $65, $73, $5B, $66, $69, $6C, $65, $6E, $61, $6D, $65,
$5D, $29, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20,
$66, $69, $6C, $65, $3A, $77, $72, $69, $74, $65, $28, $22, $5C, $6E, $22, $29,
$0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $66, $69,
$6C, $65, $3A, $77, $72, $69, $74, $65, $28, $22, $65, $6E, $64, $5C, $6E, $22,
$29, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $65, $6E, $64, $0D, $0A,
$20, $20, $20, $20, $20, $20, $20, $20, $66, $69, $6C, $65, $3A, $77, $72, $69,
$74, $65, $28, $22, $66, $75, $6E, $63, $74, $69, $6F, $6E, $20, $69, $6D, $70,
$6F, $72, $74, $28, $6E, $29, $5C, $6E, $22, $29, $0D, $0A, $20, $20, $20, $20,
$20, $20, $20, $20, $66, $69, $6C, $65, $3A, $77, $72, $69, $74, $65, $28, $22,
$72, $65, $74, $75, $72, $6E, $20, $6D, $6F, $64, $75, $6C, $65, $73, $5B, $6E,
$5D, $28, $74, $61, $62, $6C, $65, $2E, $75, $6E, $70, $61, $63, $6B, $28, $61,
$72, $67, $73, $29, $29, $5C, $6E, $22, $29, $0D, $0A, $20, $20, $20, $20, $20,
$20, $20, $20, $66, $69, $6C, $65, $3A, $77, $72, $69, $74, $65, $28, $22, $65,
$6E, $64, $5C, $6E, $22, $29, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20,
$0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $66, $69, $6C, $65, $3A, $77,
$72, $69, $74, $65, $28, $22, $6C, $6F, $63, $61, $6C, $20, $65, $6E, $74, $72,
$79, $20, $3D, $20, $69, $6D, $70, $6F, $72, $74, $28, $27, $22, $20, $2E, $2E,
$20, $65, $6E, $74, $72, $79, $5F, $70, $6F, $69, $6E, $74, $20, $2E, $2E, $20,
$22, $27, $29, $5C, $6E, $22, $29, $0D, $0A, $20, $20, $20, $20, $20, $20, $20,
$20, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $66, $69, $6C, $65, $3A,
$77, $72, $69, $74, $65, $28, $22, $65, $6E, $64, $29, $28, $7B, $2E, $2E, $2E,
$7D, $29, $22, $29, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $66, $69,
$6C, $65, $3A, $66, $6C, $75, $73, $68, $28, $29, $0D, $0A, $20, $20, $20, $20,
$20, $20, $20, $20, $66, $69, $6C, $65, $3A, $63, $6C, $6F, $73, $65, $28, $29,
$0D, $0A, $20, $20, $20, $20, $65, $6E, $64, $0D, $0A, $20, $20, $20, $20, $0D,
$0A, $20, $20, $20, $20, $72, $65, $74, $75, $72, $6E, $20, $73, $65, $6C, $66,
$0D, $0A, $65, $6E, $64, $0D, $0A, $65, $6E, $64, $0D, $0A, $6D, $6F, $64, $75,
$6C, $65, $73, $5B, $27, $61, $70, $70, $2F, $6D, $61, $69, $6E, $2E, $6C, $75,
$61, $27, $5D, $20, $3D, $20, $66, $75, $6E, $63, $74, $69, $6F, $6E, $28, $2E,
$2E, $2E, $29, $0D, $0A, $2D, $2D, $20, $4D, $61, $69, $6E, $20, $66, $75, $6E,
$63, $74, $69, $6F, $6E, $20, $6F, $66, $20, $74, $68, $65, $20, $70, $72, $6F,
$67, $72, $61, $6D, $0D, $0A, $6C, $6F, $63, $61, $6C, $20, $62, $75, $6E, $64,
$6C, $65, $5F, $6D, $61, $6E, $61, $67, $65, $72, $20, $3D, $20, $69, $6D, $70,
$6F, $72, $74, $28, $22, $61, $70, $70, $2F, $62, $75, $6E, $64, $6C, $65, $5F,
$6D, $61, $6E, $61, $67, $65, $72, $2E, $6C, $75, $61, $22, $29, $0D, $0A, $0D,
$0A, $72, $65, $74, $75, $72, $6E, $20, $66, $75, $6E, $63, $74, $69, $6F, $6E,
$28, $61, $72, $67, $73, $29, $0D, $0A, $20, $20, $20, $20, $69, $66, $20, $23,
$61, $72, $67, $73, $20, $3D, $3D, $20, $31, $20, $61, $6E, $64, $20, $61, $72,
$67, $73, $5B, $31, $5D, $20, $3D, $3D, $20, $22, $2D, $76, $22, $20, $74, $68,
$65, $6E, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $70, $72, $69, $6E,
$74, $28, $22, $6C, $75, $61, $62, $75, $6E, $64, $6C, $65, $20, $76, $30, $2E,
$30, $31, $22, $29, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $6F, $73,
$2E, $65, $78, $69, $74, $28, $29, $0D, $0A, $20, $20, $20, $20, $65, $6C, $73,
$65, $69, $66, $20, $23, $61, $72, $67, $73, $20, $7E, $3D, $20, $32, $20, $74,
$68, $65, $6E, $0D, $0A, $20, $20, $20, $20, $20, $20, $20, $20, $70, $72, $69,
$6E, $74, $28, $22, $75, $73, $61, $67, $65, $3A, $20, $6C, $75, $61, $62, $75,
$6E, $64, $6C, $65, $20, $69, $6E, $20, $6F, $75, $74, $22, $29, $0D, $0A, $20,
$20, $20, $20, $20, $20, $20, $20, $6F, $73, $2E, $65, $78, $69, $74, $28, $29,
$0D, $0A, $20, $20, $20, $20, $65, $6E, $64, $0D, $0A, $20, $20, $20, $20, $0D,
$0A, $20, $20, $20, $20, $6C, $6F, $63, $61, $6C, $20, $69, $6E, $66, $69, $6C,
$65, $20, $3D, $20, $61, $72, $67, $73, $5B, $31, $5D, $0D, $0A, $20, $20, $20,
$20, $6C, $6F, $63, $61, $6C, $20, $6F, $75, $74, $66, $69, $6C, $65, $20, $3D,
$20, $61, $72, $67, $73, $5B, $32, $5D, $0D, $0A, $20, $20, $20, $20, $6C, $6F,
$63, $61, $6C, $20, $62, $75, $6E, $64, $6C, $65, $20, $3D, $20, $62, $75, $6E,
$64, $6C, $65, $5F, $6D, $61, $6E, $61, $67, $65, $72, $28, $69, $6E, $66, $69,
$6C, $65, $29, $0D, $0A, $20, $20, $20, $20, $62, $75, $6E, $64, $6C, $65, $2E,
$70, $72, $6F, $63, $65, $73, $73, $5F, $66, $69, $6C, $65, $28, $69, $6E, $66,
$69, $6C, $65, $2C, $20, $62, $75, $6E, $64, $6C, $65, $29, $0D, $0A, $20, $20,
$20, $20, $0D, $0A, $20, $20, $20, $20, $62, $75, $6E, $64, $6C, $65, $2E, $62,
$75, $69, $6C, $64, $5F, $62, $75, $6E, $64, $6C, $65, $28, $6F, $75, $74, $66,
$69, $6C, $65, $29, $0D, $0A, $65, $6E, $64, $0D, $0A, $65, $6E, $64, $0D, $0A,
$6D, $6F, $64, $75, $6C, $65, $73, $5B, $27, $61, $70, $70, $2F, $73, $6F, $75,
$72, $63, $65, $5F, $70, $61, $72, $73, $65, $72, $2E, $6C, $75, $61, $27, $5D,
$20, $3D, $20, $66, $75, $6E, $63, $74, $69, $6F, $6E, $28, $2E, $2E, $2E, $29,
$0D, $0A, $2D, $2D, $20, $43, $6C, $61, $73, $73, $20, $66, $6F, $72, $20, $65,
$78, $74, $72, $61, $63, $74, $69, $6E, $67, $20, $69, $6D, $70, $6F, $72, $74,
$20, $66, $75, $6E, $63, $74, $69, $6F, $6E, $20, $63, $61, $6C, $6C, $73, $20,
$66, $72, $6F, $6D, $20, $73, $6F, $75, $72, $63, $65, $20, $66, $69, $6C, $65,
$73, $0D, $0A, $72, $65, $74, $75, $72, $6E, $20, $66, $75, $6E, $63, $74, $69,
$6F, $6E, $28, $66, $69, $6C, $65, $6E, $61, $6D, $65, $29, $0D, $0A, $20, $20,
$20, $20, $6C, $6F, $63, $61, $6C, $20, $66, $69, $6C, $65, $20, $3D, $20, $69,
$6F, $2E, $6F, $70, $65, $6E, $28, $66, $69, $6C, $65, $6E, $61, $6D, $65, $2C,
$20, $22, $72, $22, $29, $0D, $0A, $20, $20, $20, $20, $69, $66, $20, $66, $69,
$6C, $65, $20, $3D, $3D, $20, $6E, $69, $6C, $20, $74, $68, $65, $6E, $0D, $0A,
$20, $20, $20, $20, $20, $20, $20, $20, $65, $72, $72, $6F, $72, $28, $22, $46,
$69, $6C, $65, $20, $6E, $6F, $74, $20, $66, $6F, $75, $6E, $64, $3A, $20, $22,
$20, $2E, $2E, $20, $66, $69, $6C, $65, $6E, $61, $6D, $65, $29, $0D, $0A, $20,
$20, $20, $20, $65, $6E, $64, $0D, $0A, $20, $20, $20, $20, $6C, $6F, $63, $61,
$6C, $20, $66, $69, $6C, $65, $5F, $63, $6F, $6E, $74, $65, $6E, $74, $20, $3D,
$20, $66, $69, $6C, $65, $3A, $72, $65, $61, $64, $28, $22, $2A, $61, $22, $29,
$0D, $0A, $20, $20, $20, $20, $66, $69, $6C, $65, $3A, $63, $6C, $6F, $73, $65,
$28, $29, $0D, $0A, $20, $20, $20, $20, $6C, $6F, $63, $61, $6C, $20, $69, $6E,
$63, $6C, $75, $64, $65, $64, $5F, $66, $69, $6C, $65, $73, $20, $3D, $20, $7B,
$7D, $0D, $0A, $20, $20, $20, $20, $0D, $0A, $20, $20, $20, $20, $2D, $2D, $20,
$53, $65, $61, $72, $63, $68, $20, $66, $6F, $72, $20, $69, $6D, $70, $6F, $72,
$74, $28, $29, $20, $63, $61, $6C, $6C, $73, $20, $77, $69, $74, $68, $20, $64,
$6F, $62, $75, $6C, $65, $20, $71, $75, $6F, $74, $65, $73, $20, $28, $21, $29,
$0D, $0A, $20, $20, $20, $20, $66, $6F, $72, $20, $66, $20, $69, $6E, $20, $73,
$74, $72, $69, $6E, $67, $2E, $67, $6D, $61, $74, $63, $68, $28, $66, $69, $6C,
$65, $5F, $63, $6F, $6E, $74, $65, $6E, $74, $2C, $20, $27, $69, $6D, $70, $6F,
$72, $74, $25, $28, $5B, $22, $5C, $27, $5D, $28, $5B, $5E, $5C, $27, $22, $5D,
$2D, $29, $5B, $22, $5C, $27, $5D, $25, $29, $27, $29, $20, $64, $6F, $0D, $0A,
$20, $20, $20, $20, $20, $20, $20, $20, $74, $61, $62, $6C, $65, $2E, $69, $6E,
$73, $65, $72, $74, $28, $69, $6E, $63, $6C, $75, $64, $65, $64, $5F, $66, $69,
$6C, $65, $73, $2C, $20, $66, $29, $0D, $0A, $20, $20, $20, $20, $65, $6E, $64,
$0D, $0A, $20, $20, $20, $20, $0D, $0A, $20, $20, $20, $20, $73, $65, $6C, $66,
$20, $3D, $20, $7B, $7D, $0D, $0A, $20, $20, $20, $20, $73, $65, $6C, $66, $2E,
$66, $69, $6C, $65, $6E, $61, $6D, $65, $20, $3D, $20, $66, $69, $6C, $65, $6E,
$61, $6D, $65, $0D, $0A, $20, $20, $20, $20, $73, $65, $6C, $66, $2E, $63, $6F,
$6E, $74, $65, $6E, $74, $20, $3D, $20, $66, $69, $6C, $65, $5F, $63, $6F, $6E,
$74, $65, $6E, $74, $0D, $0A, $20, $20, $20, $20, $73, $65, $6C, $66, $2E, $69,
$6E, $63, $6C, $75, $64, $65, $73, $20, $3D, $20, $69, $6E, $63, $6C, $75, $64,
$65, $64, $5F, $66, $69, $6C, $65, $73, $0D, $0A, $20, $20, $20, $20, $72, $65,
$74, $75, $72, $6E, $20, $73, $65, $6C, $66, $0D, $0A, $65, $6E, $64, $0D, $0A,
$65, $6E, $64, $0D, $0A, $6D, $6F, $64, $75, $6C, $65, $73, $5B, $27, $6C, $75,
$61, $62, $75, $6E, $64, $6C, $65, $2E, $6C, $75, $61, $27, $5D, $20, $3D, $20,
$66, $75, $6E, $63, $74, $69, $6F, $6E, $28, $2E, $2E, $2E, $29, $0D, $0A, $2D,
$2D, $20, $45, $6E, $74, $72, $79, $20, $70, $6F, $69, $6E, $74, $20, $6F, $66,
$20, $74, $68, $65, $20, $70, $72, $6F, $67, $72, $61, $6D, $2E, $0D, $0A, $2D,
$2D, $20, $4F, $6E, $6C, $79, $20, $62, $61, $73, $69, $63, $20, $73, $74, $75,
$66, $66, $20, $69, $73, $20, $73, $65, $74, $20, $75, $70, $20, $68, $65, $72,
$65, $2C, $20, $74, $68, $65, $20, $61, $63, $74, $75, $61, $6C, $20, $70, $72,
$6F, $67, $72, $61, $6D, $20, $69, $73, $20, $69, $6E, $20, $61, $70, $70, $2F,
$6D, $61, $69, $6E, $2E, $6C, $75, $61, $0D, $0A, $6C, $6F, $63, $61, $6C, $20,
$61, $72, $67, $73, $20, $3D, $20, $7B, $2E, $2E, $2E, $7D, $0D, $0A, $0D, $0A,
$2D, $2D, $20, $43, $68, $65, $63, $6B, $20, $69, $66, $20, $77, $65, $20, $61,
$72, $65, $20, $61, $6C, $72, $65, $61, $64, $79, $20, $62, $75, $6E, $64, $6C,
$65, $64, $0D, $0A, $69, $66, $20, $69, $6D, $70, $6F, $72, $74, $20, $3D, $3D,
$20, $6E, $69, $6C, $20, $74, $68, $65, $6E, $0D, $0A, $20, $20, $20, $20, $64,
$6F, $66, $69, $6C, $65, $28, $22, $75, $74, $69, $6C, $2F, $6C, $6F, $61, $64,
$65, $72, $2E, $6C, $75, $61, $22, $29, $0D, $0A, $65, $6E, $64, $0D, $0A, $0D,
$0A, $69, $6D, $70, $6F, $72, $74, $28, $22, $61, $70, $70, $2F, $6D, $61, $69,
$6E, $2E, $6C, $75, $61, $22, $29, $28, $61, $72, $67, $73, $29, $0D, $0A, $65,
$6E, $64, $0D, $0A, $66, $75, $6E, $63, $74, $69, $6F, $6E, $20, $69, $6D, $70,
$6F, $72, $74, $28, $6E, $29, $0D, $0A, $72, $65, $74, $75, $72, $6E, $20, $6D,
$6F, $64, $75, $6C, $65, $73, $5B, $6E, $5D, $28, $74, $61, $62, $6C, $65, $2E,
$75, $6E, $70, $61, $63, $6B, $28, $61, $72, $67, $73, $29, $29, $0D, $0A, $65,
$6E, $64, $0D, $0A, $6C, $6F, $63, $61, $6C, $20, $65, $6E, $74, $72, $79, $20,
$3D, $20, $69, $6D, $70, $6F, $72, $74, $28, $27, $6C, $75, $61, $62, $75, $6E,
$64, $6C, $65, $2E, $6C, $75, $61, $27, $29, $0D, $0A, $65, $6E, $64, $29, $28,
$7B, $2E, $2E, $2E, $7D, $29
);
{$ENDREGION}

const
  cLuaAutoSetup = 'AutoSetup';

function LuaWrapperClosure(const aState: Pointer): Integer; cdecl;
var
  LMethod: TMethod;
  LClosure: TCallistoFunction absolute LMethod;
  LLua: TCallisto;
begin
  // get lua object
  LLua := lua_touserdata(aState, lua_upvalueindex(1));

  // get lua class routine
  LMethod.Code := lua_touserdata(aState, lua_upvalueindex(2));
  LMethod.Data := lua_touserdata(aState, lua_upvalueindex(3));

  // init the context
  LLua.Context.Setup;

  // call class routines
  LClosure(LLua.Context);

  // return result count
  Result := LLua.Context.PushCount;

  // clean up stack
  LLua.Context.Cleanup;
end;

function LuaWrapperWriter(aState: Plua_State; const aBuffer: Pointer; aSize: NativeUInt; aData: Pointer): Integer; cdecl;
var
  LStream: TStream;
begin
  LStream := TStream(aData);
  try
    LStream.WriteBuffer(aBuffer^, aSize);
    Result := 0;
  except
    on E: EStreamError do
      Result := 1;
  end;
end;

{ TLuaValue }
class operator TCallistoValue.Implicit(const AValue: Integer): TCallistoValue;
begin
  Result.AsType := vtInteger;
  Result.AsInteger := AValue;
end;

class operator TCallistoValue.Implicit(const AValue: Double): TCallistoValue;
begin
  Result.AsType := vtDouble;
  Result.AsNumber := AValue;
end;

class operator TCallistoValue.Implicit(const AValue: System.PChar): TCallistoValue;
begin
  Result.AsType := vtString;
  Result.AsString := AValue;
end;

class operator TCallistoValue.Implicit(const AValue: TCallistoTable): TCallistoValue;
begin
  Result.AsType := vtTable;
  Result.AsTable := AValue;
end;

class operator TCallistoValue.Implicit(const AValue: Pointer): TCallistoValue;
begin
  Result.AsType := vtPointer;
  Result.AsPointer := AValue;
end;

class operator TCallistoValue.Implicit(const AValue: Boolean): TCallistoValue;
begin
  Result.AsType := vtBoolean;
  Result.AsBoolean := AValue;
end;

class operator TCallistoValue.Implicit(const AValue: TCallistoValue): Integer;
begin
  Result := AValue.AsInteger;
end;

class operator TCallistoValue.Implicit(const AValue: TCallistoValue): Double;
begin
  Result := AValue.AsNumber;
end;

var TLuaValue_Implicit_LValue: string = '';
class operator TCallistoValue.Implicit(const AValue: TCallistoValue): System.PChar;
begin
  TLuaValue_Implicit_LValue := AValue.AsString;
  Result := PChar(TLuaValue_Implicit_LValue);
end;

class operator TCallistoValue.Implicit(const AValue: TCallistoValue): Pointer;
begin
  Result := AValue.AsPointer
end;

class operator TCallistoValue.Implicit(const AValue: TCallistoValue): Boolean;
begin
  Result := AValue.AsBoolean;
end;

{ Routines }
function ParseTableNames(const aNames: string): TStringDynArray;
var
  LItems: TArray<string>;
  LI: Integer;
begin
  LItems := aNames.Split(['.']);
  SetLength(Result, Length(LItems));
  for LI := 0 to High(LItems) do
  begin
    Result[LI] := LItems[LI];
  end;
end;

{ TLuaContext }
procedure TCallistoContext.Setup();
begin
  FPushCount := 0;
  FPushFlag := True;
end;

procedure TCallistoContext.Check();
begin
  if FPushFlag then
  begin
    FPushFlag := False;
    ClearStack;
  end;
end;

procedure TCallistoContext.IncStackPushCount();
begin
  Inc(FPushCount);
end;

procedure TCallistoContext.Cleanup();
begin
  if FPushFlag then
  begin
    ClearStack;
  end;
end;

function TCallistoContext.PushTableForSet(const AName: array of string; const AIndex: Integer; var AStackIndex: Integer; var AFieldNameIndex: Integer): Boolean;
var
  LMarshall: TMarshaller;
  LI: Integer;
begin
  Result := False;

  // validate name array size
  AStackIndex := Length(AName);
  if AStackIndex < 1 then  Exit;

  // validate return aStackIndex and aFieldNameIndex
  if Length(AName) = 1 then
    AFieldNameIndex := 0
  else
    AFieldNameIndex := Length(AName) - 1;

  // table does not exist, exit
  if lua_type(FLua.State, AIndex) <> LUA_TTABLE then Exit;

  // process sub tables
  for LI := 0 to AStackIndex - 1 do
  begin
    // check if table at field aIndex[i] exits
    lua_getfield(FLua.State, LI + AIndex, LMarshall.AsAnsi(AName[LI]).ToPointer);

    // table field does not exists, create a new one
    if lua_type(FLua.State, -1) <> LUA_TTABLE then
    begin
      // clean up stack
      lua_pop(FLua.State, 1);

      // push new table
      lua_newtable(FLua.State);

      // set new table a field
      lua_setfield(FLua.State, LI + AIndex, LMarshall.AsAnsi(AName[LI]).ToPointer);

      // push field table back on stack
      lua_getfield(FLua.State, LI + AIndex, LMarshall.AsAnsi(AName[LI]).ToPointer);
    end;
  end;

  Result := True;
end;

function TCallistoContext.PushTableForGet(const AName: array of string; const AIndex: Integer; var AStackIndex: Integer; var AFieldNameIndex: Integer): Boolean;
var
  LMarshall: TMarshaller;
  LI: Integer;
begin
  Result := False;

  // validate name array size
  AStackIndex := Length(AName);
  if AStackIndex < 1 then  Exit;

  // validate return aStackIndex and aFieldNameIndex
  if AStackIndex = 1 then
    AFieldNameIndex := 0
  else
    AFieldNameIndex := AStackIndex - 1;

  // table does not exist, exit
  if lua_type(FLua.State, AIndex) <> LUA_TTABLE then  Exit;

  // process sub tables
  for LI := 0 to AStackIndex - 2 do
  begin
    // check if table at field aIndex[i] exits
    lua_getfield(FLua.State, LI + AIndex, LMarshall.AsAnsi(AName[LI]).ToPointer);

    // table field does not exists, create a new one
    if lua_type(FLua.State, -1) <> LUA_TTABLE then Exit;
  end;

  Result := True;
end;

constructor TCallistoContext.Create(const ALua: TCallisto);
begin
  FLua := ALua;
  FPushCount := 0;
  FPushFlag := False;
end;

destructor TCallistoContext.Destroy();
begin
  FLua := nil;
  FPushCount := 0;
  FPushFlag := False;
  inherited;
end;

function TCallistoContext.ArgCount(): Integer;
begin
  Result := lua_gettop(FLua.State);
end;

function TCallistoContext.PushCount: Integer;
begin
  Result := FPushCount;
end;

procedure TCallistoContext.ClearStack();
begin
  lua_pop(FLua.State, lua_gettop(FLua.State));
  FPushCount := 0;
  FPushFlag := False;
end;

procedure TCallistoContext.PopStack(const ACount: Integer);
begin
  lua_pop(FLua.State, ACount);
end;

function TCallistoContext.GetStackType(const AIndex: Integer): TCallistoType;
begin
  Result := TCallistoType(lua_type(FLua.State, AIndex));
end;

var TLuaContext_GetValue_LStr: string = '';
function TCallistoContext.GetValue(const AType: TCallistoValueType; const AIndex: Integer): TCallistoValue;
begin
  Result := Default(TCallistoValue);
  case AType of
    vtInteger:
      begin
        Result.AsInteger := lua_tointeger(FLua.State, AIndex);
      end;
    vtDouble:
      begin
        Result.AsNumber := lua_tonumber(FLua.State, AIndex);
      end;
    vtString:
      begin
        TLuaContext_GetValue_LStr := lua_tostring(FLua.State, AIndex);
        Result := PChar(TLuaContext_GetValue_LStr);
      end;
    vtPointer:
      begin
        Result.AsPointer := lua_touserdata(FLua.State, AIndex);
      end;
    vtBoolean:
      begin
        Result.AsBoolean := Boolean(lua_toboolean(FLua.State, AIndex));
      end;
  else
    begin

    end;
  end;
end;

procedure TCallistoContext.PushValue(const AValue: TCallistoValue);
var
  LMarshall: TMarshaller;
begin
  Check;

  case AValue.AsType of
    vtInteger:
      begin
        lua_pushinteger(FLua.State, AValue);
      end;
    vtDouble:
      begin
        lua_pushnumber(FLua.State, AValue);
      end;
    vtString:
      begin
        lua_pushstring(FLua.State, LMarshall.AsAnsi(AValue.AsString).ToPointer);
      end;
    vtTable:
      begin
        lua_newtable(FLua.State);
      end;
    vtPointer:
      begin
        lua_pushlightuserdata(FLua.State, AValue);
      end;
    vtBoolean:
      begin
        lua_pushboolean(FLua.State, AValue.AsBoolean.ToInteger);
      end;
  end;

  IncStackPushCount();
end;

procedure TCallistoContext.SetTableFieldValue(const AName: string; const AValue: TCallistoValue; const AIndex: Integer);
var
  LMarshall: TMarshaller;
  LStackIndex: Integer;
  LFieldNameIndex: Integer;
  LItems: TStringDynArray;
  LOk: Boolean;
begin
  LItems := ParseTableNames(AName);
  if not PushTableForSet(LItems, AIndex, LStackIndex, LFieldNameIndex) then Exit;
  LOk := True;

  case AValue.AsType of
    vtInteger:
      begin
        lua_pushinteger(FLua.State, AValue);
      end;
    vtDouble:
      begin
        lua_pushnumber(FLua.State, AValue);
      end;
    vtString:
      begin
        lua_pushstring(FLua.State, LMarshall.AsAnsi(AValue.AsString).ToPointer);
      end;
    vtPointer:
      begin
        lua_pushlightuserdata(FLua.State, AValue);
      end;
    vtBoolean:
      begin
        lua_pushboolean(FLua.State, AValue.AsBoolean.ToInteger);
      end;
  else
    begin
      LOk := False;
    end;
  end;

  if LOk then
  begin
    lua_setfield(FLua.State, LStackIndex + (AIndex - 1),
      LMarshall.AsAnsi(LItems[LFieldNameIndex]).ToPointer);
  end;

  PopStack(LStackIndex);
end;

var TLuaContext_GetTableFieldValue_LStr: string = '';
function TCallistoContext.GetTableFieldValue(const AName: string; const AType: TCallistoValueType; const AIndex: Integer): TCallistoValue;
var
  LMarshall: TMarshaller;
  LStackIndex: Integer;
  LFieldNameIndex: Integer;
  LItems: TStringDynArray;
begin
  LItems := ParseTableNames(AName);
  if not PushTableForGet(LItems, AIndex, LStackIndex, LFieldNameIndex) then
    Exit;
  lua_getfield(FLua.State, LStackIndex + (AIndex - 1),
    LMarshall.AsAnsi(LItems[LFieldNameIndex]).ToPointer);

  case AType of
    vtInteger:
      begin
        Result.AsInteger := lua_tointeger(FLua.State, -1);
      end;
    vtDouble:
      begin
        Result.AsNumber := lua_tonumber(FLua.State, -1);
      end;
    vtString:
      begin
        TLuaContext_GetTableFieldValue_LStr := lua_tostring(FLua.State, -1);
        Result := PChar(TLuaContext_GetTableFieldValue_LStr);
      end;
    vtPointer:
      begin
        Result.AsPointer := lua_touserdata(FLua.State, -1);
      end;
    vtBoolean:
      begin
        Result.AsBoolean := Boolean(lua_toboolean(FLua.State, -1));
      end;
  end;

  PopStack(LStackIndex);
end;

procedure TCallistoContext.SetTableIndexValue(const AName: string; const AValue: TCallistoValue; const AIndex: Integer; const AKey: Integer);
var
  LMarshall: TMarshaller;
  LStackIndex: Integer;
  LFieldNameIndex: Integer;
  LItems: TStringDynArray;
  LOk: Boolean;

  procedure LPushValue;
  begin
    LOk := True;

    case AValue.AsType of
      vtInteger:
        begin
          lua_pushinteger(FLua.State, AValue);
        end;
      vtDouble:
        begin
          lua_pushnumber(FLua.State, AValue);
        end;
      vtString:
        begin
          lua_pushstring(FLua.State, LMarshall.AsAnsi(AValue.AsString).ToPointer);
        end;
      vtPointer:
        begin
          lua_pushlightuserdata(FLua.State, AValue);
        end;
      vtBoolean:
        begin
          lua_pushboolean(FLua.State, AValue.AsBoolean.ToInteger);
        end;
    else
      begin
        LOk := False;
      end;
    end;
  end;

begin
  LItems := ParseTableNames(AName);
  if Length(LItems) > 0 then
    begin
      if not PushTableForGet(LItems, AIndex, LStackIndex, LFieldNameIndex) then  Exit;
      LPushValue;
      if LOk then
        lua_rawseti (FLua.State, LStackIndex + (AIndex - 1), AKey);
    end
  else
    begin
      LPushValue;
      if LOk then
      begin
        lua_rawseti (FLua.State, AIndex, AKey);
      end;
      LStackIndex := 0;
    end;

    PopStack(LStackIndex);
end;

var TLuaContext_GetTableIndexValue_LStr: string = '';
function TCallistoContext.GetTableIndexValue(const AName: string; const AType: TCallistoValueType; const AIndex: Integer; const AKey: Integer): TCallistoValue;
var
  LStackIndex: Integer;
  LFieldNameIndex: Integer;
  LItems: TStringDynArray;
begin
  LItems := ParseTableNames(AName);
  if Length(LItems) > 0 then
    begin
      if not PushTableForGet(LItems, AIndex, LStackIndex, LFieldNameIndex) then Exit;
      lua_rawgeti (FLua.State, LStackIndex + (AIndex - 1), AKey);
    end
  else
    begin
      lua_rawgeti (FLua.State, AIndex, AKey);
      LStackIndex := 0;
    end;

  case AType of
    vtInteger:
      begin
        Result.AsInteger := lua_tointeger(FLua.State, -1);
      end;
    vtDouble:
      begin
        Result.AsNumber := lua_tonumber(FLua.State, -1);
      end;
    vtString:
      begin
        TLuaContext_GetTableIndexValue_LStr := lua_tostring(FLua.State, -1);
        Result := PChar(TLuaContext_GetTableIndexValue_LStr);
      end;
    vtPointer:
      begin
        Result.AsPointer := lua_touserdata(FLua.State, -1);
      end;
    vtBoolean:
      begin
        Result.AsBoolean := Boolean(lua_toboolean(FLua.State, -1));
      end;
  end;

  PopStack(LStackIndex);
end;

function  TCallistoContext.Lua(): ICallisto;
begin
  Result := Self.FLua;
end;


{ TLua }
procedure TCallisto.Open();
begin
  if FState <> nil then Exit;
  FState := luaL_newstate;
  SetGCStepSize(200);
  luaL_openlibs(FState);
  LoadBuffer(@cLOADER_LUA, Length(cLOADER_LUA));
  FContext := TCallistoContext.Create(Self);

  SetVariable('Callisto.luaVersion', GetVariable('jit.version', vtString));
  SetVariable('Callisto.version', CALLISTO_VERSION);

  dbg_setup_default(FState);

  // Set the panic handler
  lua_atpanic(FState, @LuaPanic);
end;

procedure TCallisto.Close();
begin
  if FState = nil then Exit;
  FreeAndNil(FContext);
  lua_close(FState);
  FState := nil;
end;

procedure TCallisto.CheckLuaError(const AError: Integer);
var
  LErr: string;
begin
  if FState = nil then Exit;

  case AError of
    // success
    0:
      begin

      end;
    // a runtime error.
    LUA_ERRRUN:
      begin
        LErr := lua_tostring(FState, -1);
        lua_pop(FState, 1);
        raise ECallistoException.CreateFmt('Runtime error [%s]', [LErr]);
      end;
    // memory allocation error. For such errors, Lua does not call the error handler function.
    LUA_ERRMEM:
      begin
        LErr := lua_tostring(FState, -1);
        lua_pop(FState, 1);
        raise ECallistoException.CreateFmt('Memory allocation error [%s]', [LErr]);
      end;
    // error while running the error handler function.
    LUA_ERRERR:
      begin
        LErr := lua_tostring(FState, -1);
        lua_pop(FState, 1);
        raise ECallistoException.CreateFmt
          ('Error while running the error handler function [%s]', [LErr]);
      end;
    LUA_ERRSYNTAX:
      begin
        LErr := lua_tostring(FState, -1);
        lua_pop(FState, 1);
        raise ECallistoException.CreateFmt('Syntax Error [%s]', [LErr]);
      end
  else
    begin
      LErr := lua_tostring(FState, -1);
      lua_pop(FState, 1);
      raise ECallistoException.CreateFmt('Unknown Error [%s]', [LErr]);
    end;
  end;
end;

function TCallisto.PushGlobalTableForSet(const AName: array of string; var AIndex: Integer): Boolean;
var
  LMarshall: TMarshaller;
  LI: Integer;
begin
  Result := False;

  if FState = nil then Exit;

  if Length(AName) < 2 then Exit;

  AIndex := Length(AName) - 1;

  // check if global table exists
  lua_getglobal(FState, LMarshall.AsAnsi(AName[0]).ToPointer);

  // table does not exist, create new one
  if lua_type(FState, lua_gettop(FState)) <> LUA_TTABLE then
  begin
    // clean up stack
    lua_pop(FState, 1);

    // create new table
    lua_newtable(FState);

    // make it global
    lua_setglobal(FState, LMarshall.AsAnsi(AName[0]).ToPointer);

    // push global table back on stack
    lua_getglobal(FState, LMarshall.AsAnsi(AName[0]).ToPointer);
  end;

  // process tables in global table at index 1+
  // global table on stack, process remaining tables
  for LI := 1 to AIndex - 1 do
  begin
    // check if table at field aIndex[i] exits
    lua_getfield(FState, LI, LMarshall.AsAnsi(AName[LI]).ToPointer);

    // table field does not exists, create a new one
    if lua_type(FState, -1) <> LUA_TTABLE then
    begin
      // clean up stack
      lua_pop(FState, 1);

      // push new table
      lua_newtable(FState);

      // set new table a field
      lua_setfield(FState, LI, LMarshall.AsAnsi(AName[LI]).ToPointer);

      // push field table back on stack
      lua_getfield(FState, LI, LMarshall.AsAnsi(AName[LI]).ToPointer);
    end;
  end;

  Result := True;
end;

function TCallisto.PushGlobalTableForGet(const AName: array of string; var AIndex: Integer): Boolean;
var
  LMarshall: TMarshaller;
  LI: Integer;
begin
  // assume false
  Result := False;

  if FState = nil then Exit;

  // check for valid table name count
  if Length(AName) < 2 then Exit;

  // init stack index
  AIndex := Length(AName) - 1;

  // lookup global table
  lua_getglobal(FState, LMarshall.AsAnsi(AName[0]).ToPointer);

  // check of global table exits
  if lua_type(FState, lua_gettop(FState)) = LUA_TTABLE then
  begin
    // process tables in global table at index 1+
    // global table on stack, process remaining tables
    for LI := 1 to AIndex - 1 do
    begin
      // get table at field aIndex[i]
      lua_getfield(FState, LI, LMarshall.AsAnsi(AName[LI]).ToPointer);

      // table field does not exists, exit
      if lua_type(FState, -1) <> LUA_TTABLE then
      begin
        // table name does not exit so we are out of here with an error
        Exit;
      end;
    end;
  end;

  // all table names exits we are good
  Result := True;
end;

procedure TCallisto.PushTValue(const AValue: System.RTTI.TValue);
var
  LUtf8s: RawByteString;
begin
  if FState = nil then Exit;

  case AValue.Kind of
    tkUnknown, tkChar, tkSet, tkMethod, tkVariant, tkArray, tkProcedure, tkRecord, tkInterface, tkDynArray, tkClassRef:
      begin
        lua_pushnil(FState);
      end;
    tkInteger:
      lua_pushinteger(FState, AValue.AsInteger);
    tkEnumeration:
      begin
        if AValue.IsType<Boolean> then
        begin
          if AValue.AsBoolean then
            lua_pushboolean(FState, Ord(True))
          else
            lua_pushboolean(FState, Ord(False));
        end
        else
          lua_pushinteger(FState, AValue.AsInteger);
      end;
    tkFloat:
      lua_pushnumber(FState, AValue.AsExtended);
    tkString, tkWChar, tkLString, tkWString, tkUString:
      begin
        LUtf8s := UTF8Encode(AValue.AsString);
        lua_pushstring(FState, PAnsiChar(LUtf8s));
      end;
    //tkClass:
    //  lua_pushlightuserdata(FState, Pointer(aValue.AsObject));
    tkInt64:
      lua_pushnumber(FState, AValue.AsInt64);
    //tkPointer:
    //  lua_pushlightuserdata(FState, Pointer(aValue.AsObject));
  end;
end;

function TCallisto.CallFunction(const AParams: array of TValue): TValue;
var
  LP: System.RTTI.TValue;
  LR: Integer;
begin
  if FState = nil then Exit;

  for LP in AParams do
    PushTValue(LP);
  LR := lua_pcall(FState, Length(AParams), 1, 0);
  CheckLuaError(LR);
  lua_pop(FState, 1);
  case lua_type(FState, -1) of
    LUA_TNIL:
      begin
        Result := nil;
      end;

    LUA_TBOOLEAN:
      begin
        Result := Boolean(lua_toboolean(FState, -1));
      end;

    LUA_TNUMBER:
      begin
        Result := lua_tonumber(FState, -1);
      end;

    LUA_TSTRING:
      begin
        Result := lua_tostring(FState, -1);
      end;
  else
    Result := nil;
  end;
end;

procedure TCallisto.Bundle(const AInFilename: string; const AOutFilename: string);
var
  LInFilename: string;
  LOutFilename: string;
begin
  if FState = nil then Exit;

  if AInFilename.IsEmpty then  Exit;
  if AOutFilename.IsEmpty then Exit;
  LInFilename := AInFilename.Replace('\', '/');
  LOutFilename := AOutFilename.Replace('\', '/');
  LoadBuffer(@cLUABUNDLE_LUA, Length(cLUABUNDLE_LUA), False);
  DoCall([PChar(LInFilename), PChar(LOutFilename)]);
end;

procedure TCallisto.OnBeforeReset();
begin
  if Assigned(FOnBeforeReset.Handler) then
  begin
    FOnBeforeReset.Handler(FOnBeforeReset.UserData);
  end;
end;

procedure TCallisto.OnAfterReset();
begin
  if Assigned(FOnAfterReset.Handler) then
  begin
    FOnAfterReset.Handler(FOnAfterReset.UserData);
  end;
end;

constructor TCallisto.Create();
begin
  inherited;

  FState := nil;
  Open;
end;

destructor TCallisto.Destroy();
begin
  Close();
  inherited;
end;

function  TCallisto.GetBeforeResetCallback(): TCallistoResetCallback;
begin
  Result := FOnBeforeReset.Handler;
end;

procedure TCallisto.SetBeforeResetCallback(const AHandler: TCallistoResetCallback; const AUserData: Pointer);
begin
  FOnBeforeReset.Handler := AHandler;
  FOnBeforeReset.UserData := AUserData;
end;

function  TCallisto.GetAfterResetCallback(): TCallistoResetCallback;
begin
  Result := FOnAfterReset.Handler;
end;

procedure TCallisto.SetAfterResetCallback(const AHandler: TCallistoResetCallback; const AUserData: Pointer);
begin
  FOnAfterReset.Handler := AHandler;
  FOnAfterReset.UserData := AUserData;
end;

procedure TCallisto.Reset();
begin
  if FState = nil then Exit;

  OnBeforeReset();
  Close;
  Open;
  OnAfterReset();
end;

procedure TCallisto.AddSearchPath(const APath: string);
var
  LPathToAdd: string;
  LCurrentPath: string;
begin
  if not Assigned(FState) then Exit;

  // Check if APath already ends with "?.lua"
  if APath.EndsWith('?.lua') then
    LPathToAdd := APath
  else
    LPathToAdd := IncludeTrailingPathDelimiter(APath) + '?.lua';

  // Retrieve the current package.path
  lua_getglobal(FState, 'package'); // Get the "package" table
  if not lua_istable(FState, -1) then
    raise Exception.Create('"package" is not a table in the Lua state');

  lua_getfield(FState, -1, 'path'); // Get the "package.path" field
  if LongBool(lua_isstring(FState, -1)) then
    LCurrentPath := string(lua_tostring(FState, -1))
  else
    LCurrentPath := ''; // Default to empty if "path" is not set

  lua_pop(FState, 1); // Pop the "package.path" field

  // Check if the path is already included
  if Pos(LPathToAdd, LCurrentPath) = 0 then
  begin
    // Append the new path if not already included
    LCurrentPath := LPathToAdd + ';' + LCurrentPath;

    // Update package.path
    lua_pushstring(FState, AsUTF8(LCurrentPath)); // Push the updated path
    lua_setfield(FState, -2, 'path'); // Update "package.path"
  end;

  lua_pop(FState, 1); // Pop the "package" table
end;

function TCallisto.LoadFile(const AFilename: string; const AAutoRun: Boolean): Boolean;
var
  LMarshall: TMarshaller;
  LErr: string;
  LRes: Integer;
begin
  Result := False;
  if not Assigned(FState) then Exit;

  if AFilename.IsEmpty then Exit;

  if not TFile.Exists(AFilename) then Exit;
  if AAutoRun then
    LRes := luaL_dofile(FState, LMarshall.AsUtf8(AFilename).ToPointer)
  else
    LRes := luaL_loadfile(FState, LMarshall.AsUtf8(AFilename).ToPointer);
  if LRes <> 0 then
  begin
    LErr := lua_tostring(FState, -1);
    lua_pop(FState, 1);
    raise ECallistoException.Create(LErr);
  end;

  Result := True;
end;

procedure TCallisto.LoadString(const AData: string; const AAutoRun: Boolean);
var
  LMarshall: TMarshaller;
  LErr: string;
  LRes: Integer;
  LData: string;
begin
  if not Assigned(FState) then Exit;

  LData := AData;
  if LData.IsEmpty then Exit;

  if AAutoRun then
    LRes := luaL_dostring(FState, LMarshall.AsAnsi(LData).ToPointer)
  else
    LRes := luaL_loadstring(FState, LMarshall.AsAnsi(LData).ToPointer);

  if LRes <> 0 then
  begin
    LErr := lua_tostring(FState, -1);
    lua_pop(FState, 1);
    raise ECallistoException.Create(LErr);
  end;
end;

procedure TCallisto.LoadStream(const AStream: TStream; const ASize: NativeUInt; const AAutoRun: Boolean);
var
  LMemStream: TMemoryStream;
  LSize: NativeUInt;
begin
  if not Assigned(FState) then Exit;

  LMemStream := TMemoryStream.Create;
  try
    if ASize = 0 then
      LSize := AStream.Size
    else
      LSize := ASize;
    LMemStream.Position := 0;
    LMemStream.CopyFrom(AStream, LSize);
    LoadBuffer(LMemStream.Memory, LMemStream.size, AAutoRun);
  finally
    FreeAndNil(LMemStream);
  end;
end;

procedure TCallisto.LoadBuffer(const AData: Pointer; const ASize: NativeUInt; const AAutoRun: Boolean);
var
  LMemStream: TMemoryStream;
  LRes: Integer;
  LErr: string;
  LSize: NativeUInt;
begin
  if not Assigned(FState) then Exit;

  LMemStream := TMemoryStream.Create;
  try
    LMemStream.Write(AData^, ASize);
    LMemStream.Position := 0;
    LSize := LMemStream.Size;
    if AAutoRun then
      LRes := luaL_dobuffer(FState, LMemStream.Memory, LSize, 'LoadBuffer')
    else
      LRes := luaL_loadbuffer(FState, LMemStream.Memory, LSize, 'LoadBuffer');
  finally
    FreeAndNil(LMemStream);
  end;

  if LRes <> 0 then
  begin
    LErr := lua_tostring(FState, -1);
    lua_pop(FState, 1);
    raise ECallistoException.Create(LErr);
  end;
end;

procedure TCallisto.SaveByteCode(const AStream: TStream);
var
  LRet: Integer;
begin
  if not Assigned(FState) then Exit;

  if lua_type(FState, lua_gettop(FState)) <> LUA_TFUNCTION then Exit;

  try
    LRet := lua_dump(FState, LuaWrapperWriter, AStream);
    if LRet <> 0 then
      raise ECallistoException.CreateFmt('lua_dump returned code %d', [LRet]);
  finally
    lua_pop(FState, 1);
  end;
end;

procedure TCallisto.LoadByteCode(const AStream: TStream; const AName: string; const AAutoRun: Boolean);
var
  LRes: NativeUInt;
  LErr: string;
  LMemStream: TMemoryStream;
  LMarshall: TMarshaller;
begin
  if not Assigned(FState) then Exit;
  if not Assigned(AStream) then Exit;
  if AStream.size <= 0 then Exit;

  LMemStream := TMemoryStream.Create;

  try
    LMemStream.CopyFrom(AStream, AStream.size);

    if AAutoRun then
    begin
      LRes := luaL_dobuffer(FState, LMemStream.Memory, LMemStream.size,
        LMarshall.AsAnsi(AName).ToPointer)
    end
    else
      LRes := luaL_loadbuffer(FState, LMemStream.Memory, LMemStream.size,
        LMarshall.AsAnsi(AName).ToPointer);
  finally
    LMemStream.Free;
  end;

  if LRes <> 0 then
  begin
    LErr := lua_tostring(FState, -1);
    lua_pop(FState, 1);
    raise ECallistoException.Create(LErr);
  end;
end;

procedure TCallisto.PushLuaValue(const AValue: TCallistoValue);
begin
  if not Assigned(FState) then Exit;

  case AValue.AsType of
    vtInteger:
      begin
        lua_pushinteger(FState, AValue.AsInteger);
      end;
    vtDouble:
      begin
        lua_pushnumber(FState, AValue.AsNumber);
      end;
    vtString:
      begin
        lua_pushstring(FState, PAnsiChar(UTF8Encode(AValue.AsString)));
      end;
    vtPointer:
      begin
        lua_pushlightuserdata(FState, AValue.AsPointer);
      end;
    vtBoolean:
      begin
        lua_pushboolean(FState, AValue.AsBoolean.ToInteger);
      end;
  else
    begin
      lua_pushnil(FState);
    end;
  end;
end;

var TLua_GetLuaValue_LStr: string = '';
function TCallisto.GetLuaValue(const AIndex: Integer): TCallistoValue;
begin
  Result := Default(TCallistoValue);

  if not Assigned(FState) then Exit;

  case lua_type(FState, AIndex) of
    LUA_TNIL:
      begin
        Result := nil;
      end;

    LUA_TBOOLEAN:
      begin
        Result.AsBoolean := Boolean(lua_toboolean(FState, AIndex));
      end;

    LUA_TNUMBER:
      begin
        Result.AsNumber := lua_tonumber(FState, AIndex);
      end;

    LUA_TSTRING:
      begin
        TLua_GetLuaValue_LStr := lua_tostring(FState, AIndex);
        Result := PChar(TLua_GetLuaValue_LStr);
      end;
  else
    begin
      Result := Default(TCallistoValue);
    end;
  end;
end;

function TCallisto.DoCall(const AParams: array of TCallistoValue): TCallistoValue;
var
  LValue: TCallistoValue;
  LRes: Integer;
begin
  if not Assigned(FState) then Exit;

  for LValue in AParams do
  begin
    PushLuaValue(LValue);
  end;

  LRes := lua_pcall(FState, Length(AParams), 1, 0);
  CheckLuaError(LRes);
  Result := GetLuaValue(-1);
end;

function TCallisto.DoCall(const AParamCount: Integer): TCallistoValue;
var
  LRes: Integer;
begin
  Result := nil;
  if not Assigned(FState) then Exit;

  LRes := lua_pcall(FState, AParamCount, 1, 0);
  CheckLuaError(LRes);
  Result := GetLuaValue(-1);
  CleanStack();
end;

procedure TCallisto.CleanStack();
begin
  if FState = nil then Exit;

  lua_pop(FState, lua_gettop(FState));
end;

function TCallisto.Call(const AName: string; const AParams: array of TCallistoValue): TCallistoValue;
var
  LMarshall: TMarshaller;
  LIndex: Integer;
  LItems: TStringDynArray;
begin
  Result := nil;
  if not Assigned(FState) then Exit;

  if AName.IsEmpty then Exit;

  CleanStack();

  LItems := ParseTableNames(AName);

  if Length(LItems) > 1 then
    begin
      if not PushGlobalTableForGet(LItems, LIndex) then
      begin
        CleanStack;
        Exit;
      end;

      lua_getfield(FState,  LIndex, LMarshall.AsAnsi(LItems[LIndex]).ToPointer);
    end
  else
    begin
      lua_getglobal(FState, LMarshall.AsAnsi(LItems[0]).ToPointer);
    end;

  if not lua_isnil(FState, lua_gettop(FState)) then
  begin
    if lua_isfunction(FState, -1) then
    begin
      Result := DoCall(AParams);
    end;
  end;

  CleanStack();
end;

function TCallisto.PrepCall(const AName: string): Boolean;
var
  LMarshall: TMarshaller;
  LIndex: Integer;
  LItems: TStringDynArray;
begin
  Result := False;
  if not Assigned(FState) then Exit;

  if AName.IsEmpty then Exit;

  CleanStack;

  LItems := ParseTableNames(AName);

  if Length(LItems) > 1 then
    begin
      if not PushGlobalTableForGet(LItems, LIndex) then
      begin
        CleanStack;
        Exit;
      end;

      lua_getfield(FState,  LIndex, LMarshall.AsAnsi(LItems[LIndex]).ToPointer);
    end
  else
    begin
      lua_getglobal(FState, LMarshall.AsAnsi(LItems[0]).ToPointer);
    end;

  Result := True;
end;

function TCallisto.Call(const AParamCount: Integer): TCallistoValue;
begin
  Result := nil;
  if not Assigned(FState) then Exit;

  if not lua_isnil(FState, lua_gettop(FState)) then
  begin
    if lua_isfunction(FState, -1) then
    begin
      Result := DoCall(AParamCount);
    end;
  end;
end;

function TCallisto.RoutineExist(const AName: string): Boolean;
var
  LMarshall: TMarshaller;
  LIndex: Integer;
  LItems: TStringDynArray;
  LCount: Integer;
  LName: string;
begin
  Result := False;
  if not Assigned(FState) then Exit;

  LName := AName;
  if LName.IsEmpty then  Exit;

  LItems := ParseTableNames(LName);

  LCount := Length(LItems);

  if LCount > 1 then
    begin
      if not PushGlobalTableForGet(LItems, LIndex) then
      begin
        CleanStack;
        Exit;
      end;
      lua_getfield(FState, LIndex, LMarshall.AsAnsi(LItems[LIndex]).ToPointer);
    end
  else
    begin
      lua_getglobal(FState, LMarshall.AsAnsi(LName).ToPointer);
    end;

  if not lua_isnil(FState, lua_gettop(FState)) then
  begin
    if lua_isfunction(FState, -1) then
    begin
      Result := True;
    end;
  end;

  CleanStack();
end;

procedure TCallisto.Run;
var
  LErr: string;
  LRes: Integer;
begin
  if not Assigned(FState) then Exit;

  // Check if the stack has any values
  if lua_gettop(FState) = 0 then
    raise ECallistoException.Create('Lua stack is empty. Nothing to run.');

  // Check if the top of the stack is a function
  if lua_type(FState, lua_gettop(FState)) <> LUA_TFUNCTION then
    raise ECallistoException.Create('Top of the stack is not a callable function.');

  // Call the function on the stack
  LRes := lua_pcall(FState, 0, LUA_MULTRET, 0);

  // Handle errors from pcall
  if LRes <> LUA_OK then
  begin
    LErr := lua_tostring(FState, -1);
    lua_pop(FState, 1);
    raise ECallistoException.Create(LErr);
  end;
end;


function TCallisto.VariableExist(const AName: string): Boolean;
var
  LMarshall: TMarshaller;
  LIndex: Integer;
  LItems: TStringDynArray;
  LCount: Integer;
  LName: string;
begin
  Result := False;
  if not Assigned(FState) then Exit;

  LName := AName;
  if LName.IsEmpty then Exit;

  LItems := ParseTableNames(LName);
  LCount := Length(LItems);

  if LCount > 1 then
    begin
      if not PushGlobalTableForGet(LItems, LIndex) then
      begin
        CleanStack;
        Exit;
      end;
      lua_getfield(FState, LIndex, LMarshall.AsAnsi(LItems[LIndex]).ToPointer);
    end
  else if LCount = 1 then
    begin
      lua_getglobal(FState, LMarshall.AsAnsi(LName).ToPointer);
    end
  else
    begin
      Exit;
    end;

  if not lua_isnil(FState, lua_gettop(FState)) then
  begin
    Result := lua_isvariable(FState, -1);
  end;

  CleanStack();
end;

var TLua_GetVariable_LStr: string = '';
function TCallisto.GetVariable(const AName: string; const AType: TCallistoValueType): TCallistoValue;
var
  LMarshall: TMarshaller;
  LIndex: Integer;
  LItems: TStringDynArray;
  LCount: Integer;
  LName: string;
begin
  Result := Default(TCallistoValue);
  if not Assigned(FState) then Exit;

  LName := AName;
  if LName.IsEmpty then Exit;

  LItems := ParseTableNames(LName);
  LCount := Length(LItems);

  if LCount > 1 then
    begin
      if not PushGlobalTableForGet(LItems, LIndex) then
      begin
        CleanStack;
        Exit;
      end;
      lua_getfield(FState, LIndex, LMarshall.AsAnsi(LItems[LIndex]).ToPointer);
    end
  else if LCount = 1 then
    begin
      lua_getglobal(FState, LMarshall.AsAnsi(LName).ToPointer);
    end
  else
    begin
      Exit;
    end;

  case AType of
    vtInteger:
      begin
        Result.AsInteger := lua_tointeger(FState, -1);
      end;
    vtDouble:
      begin
        Result.AsNumber := lua_tonumber(FState, -1);
      end;
    vtString:
      begin
        TLua_GetVariable_LStr := lua_tostring(FState, -1);
        Result := PChar(TLua_GetVariable_LStr);
      end;
    vtPointer:
      begin
        Result.AsPointer := lua_touserdata(FState, -1);
      end;
    vtBoolean:
      begin
        Result.AsBoolean := Boolean(lua_toboolean(FState, -1));
      end;
  end;

  CleanStack();
end;

procedure TCallisto.SetVariable(const AName: string; const AValue: TCallistoValue);
var
  LMarshall: TMarshaller;
  LIndex: Integer;
  LItems: TStringDynArray;
  LOk: Boolean;
  LCount: Integer;
  LName: string;
begin
  if not Assigned(FState) then Exit;

  LName := AName;
  if LName.IsEmpty then Exit;

  LItems := ParseTableNames(AName);
  LCount := Length(LItems);

  if LCount > 1 then
    begin
      if not PushGlobalTableForSet(LItems, LIndex) then
      begin
        CleanStack;
        Exit;
      end;
    end
  else if LCount < 1 then
    begin
      Exit;
    end;

  LOk := True;

  case AValue.AsType of
    vtInteger:
      begin
        lua_pushinteger(FState, AValue);
      end;
    vtDouble:
      begin
        lua_pushnumber(FState, AValue);
      end;
    vtString:
      begin
        lua_pushstring(FState, LMarshall.AsUtf8(AValue).ToPointer);
      end;
    vtPointer:
      begin
        lua_pushlightuserdata(FState, AValue);
      end;
    vtBoolean:
      begin
        lua_pushboolean(FState, AValue.AsBoolean.ToInteger);
      end;
  else
    begin
      LOk := False;
    end;
  end;

  if LOk then
  begin
    if LCount > 1 then
      begin
        lua_setfield(FState, LIndex, LMarshall.AsAnsi(LItems[LIndex]).ToPointer)
      end
    else
      begin
        lua_setglobal(FState, LMarshall.AsAnsi(LName).ToPointer);
      end;
  end;

  CleanStack();
end;

procedure TCallisto.RegisterRoutine(const AName: string; const ARoutine: TCallistoFunction);
var
  LMethod: TMethod;
  LMarshall: TMarshaller;
  LIndex: Integer;
  LNames: array of string;
  LI: Integer;
  LItems: TStringDynArray;
  LCount: Integer;
begin
  if not Assigned(FState) then Exit;
  if AName.IsEmpty then Exit;

  // parse table LNames in table.table.xxx format
  LItems := ParseTableNames(AName);

  LCount := Length(LItems);

  SetLength(LNames, Length(LItems));

  for LI := 0 to High(LItems) do
  begin
    LNames[LI] := LItems[LI];
  end;

  // init sub table LNames
  if LCount > 1 then
    begin
      // push global table to stack
      if not PushGlobalTableForSet(LNames, LIndex) then
      begin
        CleanStack;
        Exit;
      end;

      // push closure
      LMethod.Code := TMethod(ARoutine).Code;
      LMethod.Data := TMethod(ARoutine).Data;
      lua_pushlightuserdata(FState, Self);
      lua_pushlightuserdata(FState, LMethod.Code);
      lua_pushlightuserdata(FState, LMethod.Data);
      lua_pushcclosure(FState, @LuaWrapperClosure, 3);

      // add field to table
      lua_setfield(FState, -2, LMarshall.AsAnsi(LNames[LIndex]).ToPointer);

      CleanStack();
    end
  else if (LCount = 1) then
    begin
      // push closure
      LMethod.Code := TMethod(ARoutine).Code;
      LMethod.Data := TMethod(ARoutine).Data;
      lua_pushlightuserdata(FState, Self);
      lua_pushlightuserdata(FState, LMethod.Code);
      lua_pushlightuserdata(FState, LMethod.Data);
      lua_pushcclosure(FState, @LuaWrapperClosure, 3);

      // set as global
      lua_setglobal(FState, LMarshall.AsAnsi(LNames[0]).ToPointer);
    end;
end;

procedure TCallisto.RegisterRoutine(const AName: string; const AData: Pointer; const ACode: Pointer);
var
  LMarshall: TMarshaller;
  LIndex: Integer;
  LNames: array of string;
  LI: Integer;
  LItems: TStringDynArray;
  LCount: Integer;
begin
  if not Assigned(FState) then Exit;
  if AName.IsEmpty then Exit;

  // parse table LNames in table.table.xxx format
  LItems := ParseTableNames(AName);

  LCount := Length(LItems);

  SetLength(LNames, Length(LItems));

  for LI := 0 to High(LItems) do
  begin
    LNames[LI] := LItems[LI];
  end;

  // init sub table LNames
  if LCount > 1 then
    begin
      // push global table to stack
      if not PushGlobalTableForSet(LNames, LIndex) then
      begin
        CleanStack;
        Exit;
      end;

      // push closure
      lua_pushlightuserdata(FState, Self);
      lua_pushlightuserdata(FState, ACode);
      lua_pushlightuserdata(FState, AData);
      lua_pushcclosure(FState, @LuaWrapperClosure, 3);

      // add field to table
      lua_setfield(FState, -2, LMarshall.AsAnsi(LNames[LIndex]).ToPointer);

      CleanStack();
    end
  else if (LCount = 1) then
    begin
      // push closure
      lua_pushlightuserdata(FState, Self);
      lua_pushlightuserdata(FState, ACode);
      lua_pushlightuserdata(FState, AData);
      lua_pushcclosure(FState, @LuaWrapperClosure, 3);

      // set as global
      lua_setglobal(FState, LMarshall.AsAnsi(LNames[0]).ToPointer);
    end;
end;

procedure TCallisto.RegisterRoutines(const AClass: TClass);
var
  LRttiContext: TRttiContext;
  LRttiType: TRttiType;
  LRttiMethod: TRttiMethod;
  LMethodAutoSetup: TRttiMethod;

  LRttiParameters: TArray<System.Rtti.TRttiParameter>;
  LMethod: TMethod;
  LMarshall: TMarshaller;
begin
  if not Assigned(FState) then Exit;

  LRttiType := LRttiContext.GetType(AClass);
  LMethodAutoSetup := nil;

  for LRttiMethod in LRttiType.GetMethods do
  begin
    if (LRttiMethod.MethodKind <> mkClassProcedure) then continue;
    if (LRttiMethod.Visibility <> mvPublic) then continue;

    LRttiParameters := LRttiMethod.GetParameters;

    // check for public AutoSetup class function
    if SameText(LRttiMethod.Name, cLuaAutoSetup) then
    begin
      if (Length(LRttiParameters) = 1) and (Assigned(LRttiParameters[0].ParamType)) and (LRttiParameters[0].ParamType.TypeKind = tkInterface) and (TRttiInterfaceType(LRttiParameters[0].ParamType).GUID = ICallisto) then
      begin
        // call auto setup for this class
        // LRttiMethod.Invoke(aClass, [Self]);
        LMethodAutoSetup := LRttiMethod;
      end;
      continue;
    end;

    { Check if one parameter of type ILuaContext is present }
    if (Length(LRttiParameters) = 1) and (Assigned(LRttiParameters[0].ParamType)) and (LRttiParameters[0].ParamType.TypeKind = tkInterface) and (TRttiInterfaceType(LRttiParameters[0].ParamType).GUID = ICallistoContext) then
    begin
      // push closure
      LMethod.Code := LRttiMethod.CodeAddress;
      LMethod.Data := AClass;
      lua_pushlightuserdata(FState, Self);
      lua_pushlightuserdata(FState, LMethod.Code);
      lua_pushlightuserdata(FState, LMethod.Data);
      lua_pushcclosure(FState, @LuaWrapperClosure, 3);

      // add field to table
      lua_setglobal(FState, LMarshall.AsAnsi(LRttiMethod.Name).ToPointer);
    end;
  end;

  // clean up stack
  CleanStack();

  // invoke autosetup?
  if Assigned(LMethodAutoSetup) then
  begin
    // call auto setup LMethod
    LMethodAutoSetup.Invoke(AClass, [Self]);

    // clean up stack
    CleanStack();
  end;
end;

procedure TCallisto.RegisterRoutines(const AObject: TObject);
var
  LRttiContext: TRttiContext;
  LRttiType: TRttiType;
  LRttiMethod: TRttiMethod;
  LMethodAutoSetup: TRttiMethod;
  LRttiParameters: TArray<System.Rtti.TRttiParameter>;
  LMethod: TMethod;
  LMarshall: TMarshaller;
begin
  if not Assigned(FState) then Exit;

  LRttiType := LRttiContext.GetType(AObject.ClassType);
  LMethodAutoSetup := nil;
  for LRttiMethod in LRttiType.GetMethods do
  begin
    if (LRttiMethod.MethodKind <> mkProcedure) then  continue;
    if (LRttiMethod.Visibility <> mvPublic) then continue;

    LRttiParameters := LRttiMethod.GetParameters;

    // check for public AutoSetup class function
    if SameText(LRttiMethod.Name, cLuaAutoSetup) then
    begin
      if (Length(LRttiParameters) = 1) and (Assigned(LRttiParameters[0].ParamType)) and (LRttiParameters[0].ParamType.TypeKind = tkInterface) and (TRttiInterfaceType(LRttiParameters[0].ParamType).GUID = ICallisto) then
      begin
        // call auto setup for this class
        LMethodAutoSetup := LRttiMethod;
      end;
      continue;
    end;

    { Check if one parameter of type ILuaContext is present }
    if (Length(LRttiParameters) = 1) and (Assigned(LRttiParameters[0].ParamType)) and (LRttiParameters[0].ParamType.TypeKind = tkInterface) and (TRttiInterfaceType(LRttiParameters[0].ParamType).GUID = ICallistoContext) then
    begin
      // push closure
      LMethod.Code := LRttiMethod.CodeAddress;
      LMethod.Data := AObject;
      lua_pushlightuserdata(FState, Self);
      lua_pushlightuserdata(FState, LMethod.Code);
      lua_pushlightuserdata(FState, LMethod.Data);
      lua_pushcclosure(FState, @LuaWrapperClosure, 3);

      // add field to table
      lua_setglobal(FState, LMarshall.AsAnsi(LRttiMethod.Name).ToPointer);
    end;
  end;

  // clean up stack
  CleanStack();

  // invoke autosetup?
  if Assigned(LMethodAutoSetup) then
  begin
    // call auto setup LMethod
    LMethodAutoSetup.Invoke(AObject, [Self]);

    // clean up stack
    CleanStack();
  end;
end;

procedure TCallisto.RegisterRoutines(const ATables: string; const AClass: TClass; const ATableName: string);
var
  LRttiContext: TRttiContext;
  LRttiType: TRttiType;
  LRttiMethod: TRttiMethod;
  LMethodAutoSetup: TRttiMethod;

  LRttiParameters: TArray<System.Rtti.TRttiParameter>;
  LMethod: TMethod;
  LMarshall: TMarshaller;
  LIndex: Integer;
  LNames: array of string;
  TblName: string;
  LI: Integer;
  LItems: TStringDynArray;
  LLastIndex: Integer;
begin
  if not Assigned(FState) then Exit;

  // init the routines table name
  if ATableName.IsEmpty then
    TblName := AClass.ClassName
  else
    TblName := ATableName;

  // parse table LNames in table.table.xxx format
  LItems := ParseTableNames(ATables);

  // init sub table LNames
  if Length(LItems) > 0 then
  begin
    SetLength(LNames, Length(LItems) + 2);

    for LI := 0 to High(LItems) do
    begin
      LNames[LI] := LItems[LI];
    end;

    LLastIndex := Length(LItems);

    // set last as table name for functions
    LNames[LLastIndex] := TblName;
    LNames[LLastIndex + 1] := TblName;
  end
  else
  begin
    SetLength(LNames, 2);
    LNames[0] := TblName;
    LNames[1] := TblName;
  end;

  // push global table to stack
  if not PushGlobalTableForSet(LNames, LIndex) then
  begin
    CleanStack();
    Exit;
  end;

  LRttiType := LRttiContext.GetType(AClass);
  LMethodAutoSetup := nil;
  for LRttiMethod in LRttiType.GetMethods do
  begin
    if (LRttiMethod.MethodKind <> mkClassProcedure) then
      continue;
    if (LRttiMethod.Visibility <> mvPublic) then
      continue;

    LRttiParameters := LRttiMethod.GetParameters;

    // check for public AutoSetup class function
    if SameText(LRttiMethod.Name, cLuaAutoSetup) then
    begin
      if (Length(LRttiParameters) = 1) and (Assigned(LRttiParameters[0].ParamType)) and (LRttiParameters[0].ParamType.TypeKind = tkInterface) and (TRttiInterfaceType(LRttiParameters[0].ParamType).GUID = ICallisto) then
      begin
        // call auto setup for this class
        // LRttiMethod.Invoke(aClass, [Self]);
        LMethodAutoSetup := LRttiMethod;
      end;
      continue;
    end;

    { Check if one parameter of type ILuaContext is present }
    if (Length(LRttiParameters) = 1) and (Assigned(LRttiParameters[0].ParamType)) and (LRttiParameters[0].ParamType.TypeKind = tkInterface) and (TRttiInterfaceType(LRttiParameters[0].ParamType).GUID = ICallistoContext) then
    begin
      // push closure
      LMethod.Code := LRttiMethod.CodeAddress;
      LMethod.Data := AClass;
      lua_pushlightuserdata(FState, Self);
      lua_pushlightuserdata(FState, LMethod.Code);
      lua_pushlightuserdata(FState, LMethod.Data);
      lua_pushcclosure(FState, @LuaWrapperClosure, 3);

      // add field to table
      lua_setfield(FState, -2, LMarshall.AsAnsi(LRttiMethod.Name).ToPointer);
    end;
  end;

  // clean up stack
  CleanStack();

  // invoke autosetup?
  if Assigned(LMethodAutoSetup) then
  begin
    // call auto setup LMethod
    LMethodAutoSetup.Invoke(AClass, [Self]);

    // clean up stack
    CleanStack();
  end;
end;

procedure TCallisto.RegisterRoutines(const ATables: string; const AObject: TObject; const ATableName: string);
var
  LRttiContext: TRttiContext;
  LRttiType: TRttiType;
  LRttiMethod: TRttiMethod;
  LMethodAutoSetup: TRttiMethod;
  LRttiParameters: TArray<System.Rtti.TRttiParameter>;
  LMethod: TMethod;
  LMarshall: TMarshaller;
  LIndex: Integer;
  LNames: array of string;
  TblName: string;
  LI: Integer;
  LItems: TStringDynArray;
  LLastIndex: Integer;
begin
  if not Assigned(FState) then Exit;

  // init the routines table name
  if ATableName.IsEmpty then
    TblName := AObject.ClassName
  else
    TblName := ATableName;

  // parse table LNames in table.table.xxx format
  LItems := ParseTableNames(ATables);

  // init sub table LNames
  if Length(LItems) > 0 then
    begin
      SetLength(LNames, Length(LItems) + 2);

      LLastIndex := 0;
      for LI := 0 to High(LItems) do
      begin
        LNames[LI] := LItems[LI];
        LLastIndex := LI;
      end;

      // set last as table name for functions
      LNames[LLastIndex] := TblName;
      LNames[LLastIndex + 1] := TblName;
    end
  else
    begin
      SetLength(LNames, 2);
      LNames[0] := TblName;
      LNames[1] := TblName;
    end;

  // push global table to stack
  if not PushGlobalTableForSet(LNames, LIndex) then
  begin
    CleanStack();
    Exit;
  end;

  LRttiType := LRttiContext.GetType(AObject.ClassType);
  LMethodAutoSetup := nil;
  for LRttiMethod in LRttiType.GetMethods do
  begin
    if (LRttiMethod.MethodKind <> mkProcedure) then continue;
    if (LRttiMethod.Visibility <> mvPublic) then continue;

    LRttiParameters := LRttiMethod.GetParameters;

    // check for public AutoSetup class function
    if SameText(LRttiMethod.Name, cLuaAutoSetup) then
    begin
      if (Length(LRttiParameters) = 1) and (Assigned(LRttiParameters[0].ParamType)) and (LRttiParameters[0].ParamType.TypeKind = tkInterface) and (TRttiInterfaceType(LRttiParameters[0].ParamType).GUID = ICallisto) then
      begin
        // call auto setup for this class
        // LRttiMethod.Invoke(aObject.ClassType, [Self]);
        LMethodAutoSetup := LRttiMethod;
      end;
      continue;
    end;

    { Check if one parameter of type ILuaContext is present }
    if (Length(LRttiParameters) = 1) and (Assigned(LRttiParameters[0].ParamType)) and (LRttiParameters[0].ParamType.TypeKind = tkInterface) and (TRttiInterfaceType(LRttiParameters[0].ParamType).GUID = ICallistoContext) then
    begin
      // push closure
      LMethod.Code := LRttiMethod.CodeAddress;
      LMethod.Data := AObject;
      lua_pushlightuserdata(FState, Self);
      lua_pushlightuserdata(FState, LMethod.Code);
      lua_pushlightuserdata(FState, LMethod.Data);
      lua_pushcclosure(FState, @LuaWrapperClosure, 3);

      // add field to table
      lua_setfield(FState, -2, LMarshall.AsAnsi(LRttiMethod.Name).ToPointer);
    end;
  end;

  // clean up stack
  CleanStack();

  // invoke autosetup?
  if Assigned(LMethodAutoSetup) then
  begin
    // call auto setup LMethod
    LMethodAutoSetup.Invoke(AObject, [Self]);

    // clean up stack
    CleanStack();
  end;
end;

procedure TCallisto.CompileToStream(const AFilename: string; const AStream: TStream; const ACleanOutput: Boolean);
var
  LInFilename: string;
  LBundleFilename: string;
begin
  if not Assigned(FState) then Exit;

  LInFilename := AFilename;
  LBundleFilename := TPath.GetFileNameWithoutExtension(LInFilename) + '_bundle.lua';
  LBundleFilename := TPath.Combine(TPath.GetDirectoryName(LInFilename), LBundleFilename);
  Bundle(LInFilename, LBundleFilename);
  LoadFile(PChar(LBundleFilename), False);
  SaveByteCode(AStream);
  CleanStack;

  if ACleanOutput then
  begin
    if TFile.Exists(LBundleFilename) then
    begin
      TFile.Delete(LBundleFilename);
    end;
  end;
end;

const
  PAYLOADID = 'fa12d33b4ed84bc6a6dc4c2fd07a31e8';

function TCallisto.PayloadExist(): Boolean;
begin
  Result := False;
  if not Assigned(FState) then Exit;

  Result := ResourceExists(HInstance, PAYLOADID);
end;

function TCallisto.SavePayloadExe(const AFilename: string): Boolean;
  var
    LDestinationDir: string;
begin
  // Extract the directory portion of the destination path
  LDestinationDir := TPath.GetDirectoryName(AFilename);

  // Create the directory if it doesn't exist
  if not LDestinationDir.IsEmpty and not TDirectory.Exists(LDestinationDir) then
    TDirectory.CreateDirectory(LDestinationDir);

  // Perform the file copy
  TFile.Copy(ParamStr(0), AFilename, True);

  Result := TFile.Exists(AFilename);
end;

function TCallisto.StorePayload(const ASourceFilename, AEXEFilename: string): Boolean;
var
  LStream: TMemoryStream;
begin
  Result := False;
  if not Assigned(FState) then Exit;

  if not TFile.Exists(ASourceFilename) then Exit;
  if not TFile.Exists(AEXEFilename) then Exit;
  if not IsValidWin64PE(AEXEFilename) then Exit;

  LStream := TMemoryStream.Create();
  try
    CompileToStream(ASourceFilename, LStream, True);
    if LStream.Size > 0 then
    begin
      Result := AddResFromMemory(AEXEFilename, PAYLOADID, LStream.Memory, LStream.Size);
    end;
  finally
    LStream.Free();
  end;
end;

function TCallisto.UpdatePayloadIcon(const AEXEFilename, AIconFilename: string): Boolean;
begin
  Result := False;
  if not TFile.Exists(AEXEFilename) then Exit;
  if not TFile.Exists(AIconFilename) then Exit;
  if not IsValidWin64PE(AEXEFilename) then Exit;
  UpdateIconResource(AEXEFilename, AIconFilename);
  Result := True;
end;

function TCallisto.UpdatePayloadVersionInfo(const AEXEFilename: string; const AMajor,
  AMinor, APatch: Word; const AProductName, ADescription, AFilename,
  ACompanyName, ACopyright: string): Boolean;
begin
  Result := False;
  if not TFile.Exists(AEXEFilename) then Exit;
  if not IsValidWin64PE(AEXEFilename) then Exit;
  UpdateVersionInfoResource(AEXEFilename, AMajor, AMinor, APatch, AProductName,
    ADescription, AFilename, ACompanyName, ACopyright);
  Result := True;
end;

function TCallisto.RunPayload(): Boolean;
var
  LResStream: TResourceStream;
  LErr: string;
  LRes: Integer;
begin
  Result := False;
  if not Assigned(FState) then Exit;

  if not PayloadExist() then Exit;

  Reset();

  LResStream := TResourceStream.Create(HInstance, PAYLOADID, RT_RCDATA);
  try
    LoadBuffer(LResStream.Memory, LResStream.Size, False);
    LResStream.Free();
    LResStream := nil;
  finally
    if Assigned(LResStream) then
      LResStream.Free();
  end;

  // Check if the stack has any values
  if lua_gettop(FState) = 0 then
    raise ECallistoException.Create('Lua stack is empty. Nothing to run.');

  // Check if the top of the stack is a function
  if lua_type(FState, lua_gettop(FState)) <> LUA_TFUNCTION then
    raise ECallistoException.Create('Top of the stack is not a callable function.');

  // Call the function on the stack
  LRes := lua_pcall(FState, 0, LUA_MULTRET, 0);

  // Handle errors from pcall
  if LRes <> LUA_OK then
  begin
    LErr := lua_tostring(FState, -1);
    lua_pop(FState, 1);
    raise ECallistoException.Create(LErr);
  end;

  Result := True;
end;

procedure TCallisto.UpdateArgs(const AStartIndex: Integer);
var
  LStartIndex: Integer;
begin
  if not Assigned(FState) then Exit;

  LStartIndex := EnsureRange(AStartIndex, 0, ParamCount-1);
  lua_updateargs(FState, LStartIndex);
end;

procedure TCallisto.SetGCStepSize(const AStep: Integer);
begin
  FGCStep := AStep;
end;

function TCallisto.GetGCStepSize(): Integer;
begin
  Result := FGCStep;
end;

function TCallisto.GetGCMemoryUsed(): Integer;
begin
  Result := 0;
  if not Assigned(FState) then Exit;

  Result := lua_gc(FState, LUA_GCCOUNT, FGCStep);
end;

procedure TCallisto.CollectGarbage();
begin
  if not Assigned(FState) then Exit;

  lua_gc(FState, LUA_GCSTEP, FGCStep);
end;

procedure TCallisto.Print(const AText: string; const AArgs: array of const);
begin
  if not HasConsoleOutput() then Exit;
  Write(Format(AText, AArgs));
end;

procedure TCallisto.PrintLn(const AText: string; const AArgs: array of const);
begin
  if not HasConsoleOutput() then Exit;
  WriteLn(Format(AText, AArgs));
end;
{$ENDREGION}

{$REGION ' DLL LOADER '}

{$R Callisto.res}

var
  DepsDLLHandle: THandle = 0;
  DepsDLLFilename: string = '';

procedure UnloadDLL();
begin
  // unload deps DLL
  if DepsDLLHandle <> 0 then
  begin
    FreeLibrary(DepsDLLHandle);
    TFile.Delete(DepsDLLFilename);
    DepsDLLHandle := 0;
    DepsDLLFilename := '';
  end;
end;

function LoadDLL(var AError: string): Boolean;
var
  LResStream: TResourceStream;

  function d55a860b2915413c84d3620b9cbee959(): string;
  const
    CValue = 'b87deef5bbfd43c3a07379e26f4dec9b';
  begin
    Result := CValue;
  end;

  procedure SetError(const AText: string);
  begin
    AError := AText;
  end;

  function HasEnoughDiskSpace(const APath: string; ARequiredSpace: Int64): Boolean;
  var
    LFreeAvailable: Int64;
    LTotalSpace: Int64;
    LTotalFree: Int64;
  begin
    Result := GetDiskFreeSpaceEx(PChar(APath), LFreeAvailable, LTotalSpace, @LTotalFree) and
              (LFreeAvailable >= ARequiredSpace);
  end;

begin
  Result := False;
  AError := 'Failed to load LuaJIT DLL';

  // load deps DLL
  if DepsDLLHandle <> 0 then Exit(True);
  try
    if not Boolean((FindResource(HInstance, PChar(d55a860b2915413c84d3620b9cbee959()), RT_RCDATA) <> 0)) then
    begin
      SetError('Failed to find Deps DLL resource');
      Exit;
    end;
    LResStream := TResourceStream.Create(HInstance, d55a860b2915413c84d3620b9cbee959(), RT_RCDATA);
    try
      LResStream.Position := 0;
      DepsDLLFilename := TPath.Combine(TPath.GetTempPath,
        TPath.ChangeExtension(TPath.GetGUIDFileName.ToLower, '.'));
      if not HasEnoughDiskSpace(TPath.GetDirectoryName(DepsDLLFilename), LResStream.Size) then
      begin
        AError := 'Not enough disk space to extract the Deps DLL';
        Exit;
      end;

      LResStream.SaveToFile(DepsDLLFilename);
      if not TFile.Exists(DepsDLLFilename) then
      begin
        SetError('Failed to find extracted Deps DLL');
        Exit;
      end;
      DepsDLLHandle := LoadLibrary(PChar(DepsDLLFilename));
      if DepsDLLHandle = 0 then
      begin
        SetError('Failed to load extracted Deps DLL: ' + SysErrorMessage(GetLastError));
        Exit;
      end;

      {$REGION ' GET EXPORTS '}
      // get exports
      luaL_loadbufferx := GetProcAddress(DepsDLLHandle, 'luaL_loadbufferx');
      lua_pcall := GetProcAddress(DepsDLLHandle, 'lua_pcall');
      lua_error := GetProcAddress(DepsDLLHandle, 'lua_error');
      lua_getfield := GetProcAddress(DepsDLLHandle, 'lua_getfield');
      lua_pushstring := GetProcAddress(DepsDLLHandle, 'lua_pushstring');
      lua_setfield := GetProcAddress(DepsDLLHandle, 'lua_setfield');
      luaL_loadfile := GetProcAddress(DepsDLLHandle, 'luaL_loadfile');
      lua_touserdata := GetProcAddress(DepsDLLHandle, 'lua_touserdata');
      lua_pushnil := GetProcAddress(DepsDLLHandle, 'lua_pushnil');
      luaL_error := GetProcAddress(DepsDLLHandle, 'luaL_error');
      lua_insert := GetProcAddress(DepsDLLHandle, 'lua_insert');
      lua_remove := GetProcAddress(DepsDLLHandle, 'lua_remove');
      lua_type := GetProcAddress(DepsDLLHandle, 'lua_type');
      luaL_loadstring := GetProcAddress(DepsDLLHandle, 'luaL_loadstring');
      lua_pushinteger := GetProcAddress(DepsDLLHandle, 'lua_pushinteger');
      lua_pushnumber := GetProcAddress(DepsDLLHandle, 'lua_pushnumber');
      lua_pushboolean := GetProcAddress(DepsDLLHandle, 'lua_pushboolean');
      lua_pushcclosure := GetProcAddress(DepsDLLHandle, 'lua_pushcclosure');
      lua_createtable := GetProcAddress(DepsDLLHandle, 'lua_createtable');
      lua_settop := GetProcAddress(DepsDLLHandle, 'lua_settop');
      lua_gettop := GetProcAddress(DepsDLLHandle, 'lua_gettop');
      luaL_loadbuffer := GetProcAddress(DepsDLLHandle, 'luaL_loadbuffer');
      lua_dump := GetProcAddress(DepsDLLHandle, 'lua_dump');
      lua_pushlightuserdata := GetProcAddress(DepsDLLHandle, 'lua_pushlightuserdata');
      lua_toboolean := GetProcAddress(DepsDLLHandle, 'lua_toboolean');
      lua_pushvalue := GetProcAddress(DepsDLLHandle, 'lua_pushvalue');
      lua_tolstring := GetProcAddress(DepsDLLHandle, 'lua_tolstring');
      lua_tonumber := GetProcAddress(DepsDLLHandle, 'lua_tonumber');
      luaL_checklstring := GetProcAddress(DepsDLLHandle, 'luaL_checklstring');
      luaL_newstate := GetProcAddress(DepsDLLHandle, 'luaL_newstate');
      luaL_openlibs := GetProcAddress(DepsDLLHandle, 'luaL_openlibs');
      lua_close := GetProcAddress(DepsDLLHandle, 'lua_close');
      lua_tointeger := GetProcAddress(DepsDLLHandle, 'lua_tointeger');
      lua_isstring := GetProcAddress(DepsDLLHandle, 'lua_isstring');
      lua_gc := GetProcAddress(DepsDLLHandle, 'lua_gc');
      lua_rawseti := GetProcAddress(DepsDLLHandle, 'lua_rawseti');
      lua_rawgeti := GetProcAddress(DepsDLLHandle, 'lua_rawgeti');
      lua_atpanic := GetProcAddress(DepsDLLHandle, 'lua_atpanic');
      {$ENDREGION}

      Result := True;
    finally
      LResStream.Free();
    end;
  except
    on E: Exception do
      SetError('Unexpected error: ' + E.Message);
  end;
end;

{$ENDREGION}

{$REGION ' UNIT INIT '}
initialization
var
  LError: string;
begin
  ReportMemoryLeaksOnShutdown := True;
  SetConsoleCP(CP_UTF8);
  SetConsoleOutputCP(CP_UTF8);
  EnableVirtualTerminalProcessing();
  if not LoadDLL(LError) then
  begin
    MessageBox(0, PChar(LError), 'Critical Initialization Error', MB_ICONERROR);
    Halt(1); // Exit the application with a non-zero exit code to indicate failure
  end;
end;

finalization
begin
  try
    UnloadDLL();
  except
    on E: Exception do
    begin
      MessageBox(0, PChar(E.Message), 'Critical Shutdown Error', MB_ICONERROR);
    end;
  end;
end;
{$ENDREGION}

end.


