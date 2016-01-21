--
--  ZanyBlue, an Ada library and framework for finite element analysis.
--
--  Copyright (c) 2012, Michael Rohan <mrohan@zanyblue.com>
--  All rights reserved.
--
--  Redistribution and use in source and binary forms, with or without
--  modification, are permitted provided that the following conditions
--  are met:
--
--    * Redistributions of source code must retain the above copyright
--      notice, this list of conditions and the following disclaimer.
--
--    * Redistributions in binary form must reproduce the above copyright
--      notice, this list of conditions and the following disclaimer in the
--      documentation and/or other materials provided with the distribution.
--
--    * Neither the name of ZanyBlue nor the names of its contributors may
--      be used to endorse or promote products derived from this software
--      without specific prior written permission.
--
--  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
--  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
--  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
--  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
--  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
--  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
--  TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
--  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
--  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
--  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
--  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--

with Ada.Command_Line;
with AUnit.Assertions;
with AUnit.Reporter.Text;
with GNAT.Regexp;
with ZanyBlue.OS;
with ZanyBlue.Text;
with ZanyBlue.Test.Reporter_XML;
with ZanyBlue.Wide_Directories;

package body ZanyBlue.Test is

   use AUnit;
   use AUnit.Assertions;
   use ZanyBlue.OS;
   use ZanyBlue.Text;

   procedure Load_Command_Line;

   type String_Access is access String;
   CL_Initialized : Boolean := False;
   CL_Use_XML : Boolean := False;
   CL_Top_Directory : String_Access := null;
   Text_Reporter : AUnit.Reporter.Text.Text_Reporter;
   XML_Reporter : ZanyBlue.Test.Reporter_XML.XML_Reporter;

   function Base_Log_Name (Test_Area : Wide_String;
                           Test_Name : Wide_String) return Wide_String;
   function Matched (Left : Wide_String; Right : Wide_String) return Boolean;

   -----------------
   -- Add_Routine --
   -----------------

   procedure Add_Routine (Test    : in out Test_Case'Class;
                          Routine : Test_Routine;
                          Name    : String) is
   begin
      Test.Add_Routine (Routine_Spec'(Routine, Format (Name)));
   end Add_Routine;

   -------------------
   -- Base_Log_Name --
   -------------------

   function Base_Log_Name (Test_Area : Wide_String;
                           Test_Name : Wide_String) return Wide_String is
   begin
      return Test_Src_Directory (Test_Area) & "/" & Test_Name;
   end Base_Log_Name;

   --------------------
   -- Check_Log_File --
   --------------------

   procedure Check_Log_File (Test    : in out AUnit.Test_Cases.Test_Case'Class;
                             Test_Area : Wide_String;
                             Test_Name : Wide_String;
                             Message   : Wide_String) is
   begin
      WAssert (Test, Compare_Log_File (Test_Area, Test_Name), Message);
   end Check_Log_File;

   -----------------
   -- Check_Value --
   -----------------

   procedure Check_Value (Test      : in out AUnit.Test_Cases.Test_Case'Class;
                          Generated : Wide_String;
                          Expected  : Wide_String;
                          Message   : Wide_String := "Failure") is
   begin
      WAssert (Test, Generated = Expected,
               Message & ": """ & Generated & """ /= """ & Expected & """");
   end Check_Value;

   -------------------
   -- Compare_Files --
   -------------------

   function Compare_Files (Name_A, Name_B : Wide_String) return Boolean is

      use Ada.Wide_Text_IO;

      File_A : File_Type;
      File_B : File_Type;
      Result : Boolean := True;

   begin
      Wide_Open (File_A, In_File, Name_A);
      Wide_Open (File_B, In_File, Name_B);
      while not (End_Of_File (File_A) or End_Of_File (File_B)) loop
         if not Matched (Get_Line (File_A), Get_Line (File_B)) then
            Close (File_A);
            Close (File_B);
            return False;
         end if;
      end loop;
      Result := not (End_Of_File (File_A) xor End_Of_File (File_B));
      Close (File_A);
      Close (File_B);
      return Result;
   end Compare_Files;

   ----------------------
   -- Compare_Log_File --
   ----------------------

   function Compare_Log_File (Test_Area : Wide_String;
                              Test_Name : Wide_String) return Boolean is

      use ZanyBlue.Wide_Directories;

      RefLog : constant Wide_String := Test_RefLog_Name (Test_Area, Test_Name);
      GenLog : constant Wide_String := Test_Log_Name (Test_Area, Test_Name);
      Result : Boolean;

   begin
      Result := Compare_Files (RefLog, GenLog);
      if Result then
         --  Log file matched, delete the generated file
         Wide_Delete_File (GenLog);
      end if;
      return Result;
   end Compare_Log_File;

   ---------------------
   -- Create_Log_File --
   ---------------------

   procedure Create_Log_File (File      : in out Ada.Wide_Text_IO.File_Type;
                              Test_Area : Wide_String;
                              Test_Name : Wide_String) is
      use Ada.Wide_Text_IO;
      Base_Name : constant Wide_String := Base_Log_Name (Test_Area, Test_Name);
   begin
      Wide_Create (File, Base_Name & ".out");
   end Create_Log_File;

   -------------
   -- Discard --
   -------------

   procedure Discard (Value : String) is
      pragma Unreferenced (Value);
   begin
      null;
   end Discard;

   -------------
   -- Discard --
   -------------

   procedure Discard (Wide_Value : Wide_String) is
      pragma Unreferenced (Wide_Value);
   begin
      null;
   end Discard;

   -------------
   -- Discard --
   -------------

   procedure Discard (Value : Integer) is
      pragma Unreferenced (Value);
   begin
      null;
   end Discard;

   -------------
   -- Discard --
   -------------

   procedure Discard (Value : in Float) is
      pragma Unreferenced (Value);
   begin
      null;
   end Discard;

   -------------
   -- Discard --
   -------------

   procedure Discard (Value : in Ada.Calendar.Time) is
      pragma Unreferenced (Value);
   begin
      null;
   end Discard;

   -------------
   -- Discard --
   -------------

   procedure Discard (Value : in Boolean) is
      pragma Unreferenced (Value);
   begin
      null;
   end Discard;

   -----------------------
   -- Load_Command_Line --
   -----------------------

   procedure Load_Command_Line is
      use Ada.Command_Line;
      Index : Positive := 1;
   begin
      if not CL_Initialized then
         while Index <= Argument_Count loop
            if Argument (Index) = "-X" then
               CL_Use_XML := True;
            elsif Argument (Index) = "-T" then
               Index := Index + 1;
               if Index > Argument_Count then
                  raise Usage_Error with "missing -T argument";
               end if;
               CL_Top_Directory := new String'(Argument (Index));
            else
               raise Usage_Error with "unknown argument: " & Argument (Index);
            end if;
            Index := Index + 1;
         end loop;
         CL_Initialized := True;
      end if;
   end Load_Command_Line;

   -------------
   -- Matched --
   -------------

   function Matched (Left : Wide_String; Right : Wide_String) return Boolean is
      use GNAT.Regexp;
      Left_S : constant String := To_UTF8 (Left);
      Right_S : constant String := To_UTF8 (Right);
   begin
      return Left = Right or else Match (Right_S, Compile (Left_S));
   end Matched;

   -----------------------------
   -- Reporter_Implementation --
   -----------------------------

   function Reporter_Implementation return AUnit.Reporter.Reporter'Class is
   begin
      if Use_XML then
         return XML_Reporter;
      else
         return Text_Reporter;
      end if;
   end Reporter_Implementation;

   --------------------
   -- Restore_Output --
   --------------------

   procedure Restore_Output (Output : in out Ada.Wide_Text_IO.File_Type) is
   begin
      Ada.Wide_Text_IO.Close (Output);
      Restore_Output;
   end Restore_Output;

   --------------------
   -- Restore_Output --
   --------------------

   procedure Restore_Output is
   begin
      Set_Output (Ada.Wide_Text_IO.Standard_Output);
   end Restore_Output;

   ----------------
   -- Set_Output --
   ----------------

   procedure Set_Output (Output    : in out Ada.Wide_Text_IO.File_Type;
                         Test_Area : Wide_String;
                         Test_Name : Wide_String) is
   begin
      Create_Log_File (Output, Test_Area, Test_Name);
      Set_Output (Output);
   end Set_Output;

   ------------------
   -- Test_In_Name --
   ------------------

   function Test_In_Name (Test_Area : Wide_String;
                          Test_Name : Wide_String) return Wide_String is
   begin
      return Base_Log_Name (Test_Area, Test_Name) & ".in";
   end Test_In_Name;

   -------------------
   -- Test_Log_Name --
   -------------------

   function Test_Log_Name (Test_Area : Wide_String;
                           Test_Name : Wide_String) return Wide_String is
   begin
      return Base_Log_Name (Test_Area, Test_Name) & ".out";
   end Test_Log_Name;

   ----------------------
   -- Test_RefLog_Name --
   ----------------------

   function Test_RefLog_Name (Test_Area : Wide_String;
                              Test_Name : Wide_String) return Wide_String is
   begin
      return Base_Log_Name (Test_Area, Test_Name) & ".log";
   end Test_RefLog_Name;

   ------------------------
   -- Test_Src_Directory --
   ------------------------

   function Test_Src_Directory (Test_Area : Wide_String) return Wide_String is
   begin
      return ZanyBlue.Test.Top_Directory & "/src/test/unittest/"
                                         & Test_Area;
   end Test_Src_Directory;

   -------------------
   -- Top_Directory --
   -------------------

   function Top_Directory return Wide_String is
   begin
      Load_Command_Line;
      if CL_Top_Directory = null then
         raise Usage_Error with "no top level directory defined (-T)";
      end if;
      return To_Wide_String (CL_Top_Directory.all);
   end Top_Directory;

   -------------
   -- Use_XML --
   -------------

   function Use_XML return Boolean is
   begin
      Load_Command_Line;
      return CL_Use_XML;
   end Use_XML;

   -------------
   -- WAssert --
   -------------

   procedure WAssert (Test      : in out AUnit.Test_Cases.Test_Case'Class;
                      Condition : Boolean;
                      Message : Wide_String) is
      pragma Unreferenced (Test);
   begin
      --  GNAT AUnit 2010 marks Assert as Obsolete
      --  GNAT AUnit 2011 requires its
      --  Suppress warnings on it use to support AUnit 2010.
      pragma Warnings (Off, Assert);
      Assert (Condition, To_UTF8 (Message));
   end WAssert;

end ZanyBlue.Test;