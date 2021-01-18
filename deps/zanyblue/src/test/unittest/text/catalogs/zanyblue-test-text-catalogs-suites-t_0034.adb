--
--  ZanyBlue, an Ada library and framework for finite element analysis.
--
--  Copyright (c) 2012, 2018, Michael Rohan <mrohan@zanyblue.com>
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

with ZanyBlue.Test.Text.Catalogs.Xmpl_Data1;

separate (ZanyBlue.Test.Text.Catalogs.Suites)
procedure T_0034 (T : in out Test_Case'Class) is

   use ZanyBlue.Test.Text.Catalogs.Xmpl_Data1;
   pragma Warnings (Off, ZanyBlue.Test.Text.Catalogs.Xmpl_Data1);

   L_en_US      : constant Locale_Type := Make_Locale ("en_US");
   Catalog      : Catalog_Type;
   First, Last  : Positive;

begin
   Catalog := Create;
   Use_Single_Pool (Catalog);
   Check_Value (T, Get_Pool (Catalog), "", "Expected an empty pool");
   Add (Catalog, "myfac1", "mykey1", "abcd", L_en_US);
   Check_Value (T, Get_Text (Catalog, "myfac1", "mykey1", L_en_US), "abcd",
           "Expected myfac1/mykey1 = abcde");
   Add (Catalog, "myfac1", "mykey2", "efgh", L_en_US);
   Check_Value (T, Get_Text (Catalog, "myfac1", "mykey2", L_en_US), "efgh",
           "Expected myfac1/mykey2 = efgh");
   Add (Catalog, "myfac2", "mykey1", "xyz", L_en_US);
   Check_Value (T, Get_Text (Catalog, "myfac2", "mykey1", L_en_US), "xyz",
           "Expected myfac2/mykey1 = xyz");
   Query_Message (Catalog, 2, 2, 1, First, Last);
   WAssert (T, False, "Query_Message should have raised an exception");
exception
when No_Such_Message_Error =>
   WAssert (T, True, "Query_Message raised an exception");
end T_0034;
