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

with ZanyBlue.Text.Locales;
with ZanyBlue.Text.Strings;

separate (ZanyBlue.Test.Text.Arguments.Suites)
procedure T_0003 (R : in out AUnit.Test_Cases.Test_Case'Class) is

   use ZanyBlue.Text.Locales;
   use ZanyBlue.Text.Strings;

   Locale : constant Locale_Type := Make_Locale ("");
   List : Argument_List;

begin
   WAssert (R, List.Length = 0,
            "Length of emtpy list is not 0");
   Append (List, +String'("String#0"));
   WAssert (R, List.Length = 1,
            "Length is not 1");
   Append (List, +String'("String#1"));
   WAssert (R, List.Length = 2,
            "Length is not 2");
   Append (List, +String'("String#2"));
   WAssert (R, List.Length = 3,
            "Length is not 3");
   Append (List, +String'("String#3"));
   WAssert (R, List.Length = 4,
            "Length is not 4");
   WAssert (R, List.Format (0, "", "", Locale, False) = "String#0",
            "Unexpected Format (#0)");
   WAssert (R, List.Format (1, "", "", Locale, False) = "String#1",
            "Unexpected Format (#1)");
   WAssert (R, List.Format (2, "", "", Locale, False) = "String#2",
            "Unexpected Format (#2)");
   WAssert (R, List.Format (3, "", "", Locale, False) = "String#3",
            "Unexpected Format (#3)");
end T_0003;