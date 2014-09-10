------------------------------------------------------------------------------
--                                                                          --
--                   GNOGA - The GNU Omnificent GUI for Ada                 --
--                                                                          --
--                      G N O G A . D O C U M E N T                         --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                                                                          --
--                     Copyright (C) 2014 David Botton                      --
--                                                                          --
--  This library is free software;  you can redistribute it and/or modify   --
--  it under terms of the  GNU General Public License  as published by the  --
--  Free Software  Foundation;  either version 3,  or (at your  option) any --
--  later version. This library is distributed in the hope that it will be  --
--  useful, but WITHOUT ANY WARRANTY;  without even the implied warranty of --
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                    --
--                                                                          --
--  As a special exception under Section 7 of GPL version 3, you are        --
--  granted additional permissions described in the GCC Runtime Library     --
--  Exception, version 3.1, as published by the Free Software Foundation.   --
--                                                                          --
--  You should have received a copy of the GNU General Public License and   --
--  a copy of the GCC Runtime Library Exception along with this program;    --
--  see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see   --
--  <http://www.gnu.org/licenses/>.                                         --
--                                                                          --
--  As a special exception, if other files instantiate generics from this   --
--  unit, or you link this unit with other files to produce an executable,  --
--  this  unit  does not  by itself cause  the resulting executable to be   --
--  covered by the GNU General Public License. This exception does not      --
--  however invalidate any other reasons why the executable file  might be  --
--  covered by the  GNU Public License.                                     --
--                                                                          --
-- For more information please go to http://www.gnoga.com                   --
------------------------------------------------------------------------------                                                                          --

with Gnoga.Types;
with Gnoga.Base;
with Gnoga.Element;

package Gnoga.Document is

   -------------------------------------------------------------------------
   --  Document_Type
   -------------------------------------------------------------------------
   --  Document_Type is the class encapsulating the DOM document node


   type Document_Type is new Gnoga.Base.Base_Type with private;
   type Document_Access is access all Document_Type;
   type Pointer_To_Document_Class is access all Document_Type'Class;

   procedure Attach (Document      : in out Document_Type;
                     Connection_ID : in     Gnoga.Types.Connection_ID);
   --  Attach a Gnoga Document_Type to the document on Connection_ID

   -------------------------------------------------------------------------
   --  Document_Type - Properties
   -------------------------------------------------------------------------

   function Domain (Document : Document_Type) return String;

   function Input_Encoding (Document : Document_Type) return String;

   function Last_Modified (Document : Document_Type) return String;

   function Referrer (Document : Document_Type) return String;

   procedure Title (Document : in out Document_Type; Value : String);
   function Title (Document : Document_Type) return String;

   function URL (Document : Document_Type) return String;

   function Head_Element (Document : Document_Type)
                          return Gnoga.Element.Element_Access;

   function Body_Element (Document : Document_Type)
                          return Gnoga.Element.Element_Access;

private
   type Document_Type is new Gnoga.Base.Base_Type with
      record
         DOM_Head : aliased Gnoga.Element.Element_Type;
         DOM_Body : aliased Gnoga.Element.Element_Type;
      end record;
end Gnoga.Document;