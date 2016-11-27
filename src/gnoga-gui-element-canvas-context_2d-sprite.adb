------------------------------------------------------------------------------
--                                                                          --
--                   GNOGA - The GNU Omnificent GUI for Ada                 --
--                                                                          --
--   G N O G A . G U I . E L E M E N T . C A N V A S . C O N T E X T _ 2 D  --
--                              . S P R I T E                               --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                     Copyright (C) 2016 Pascal Pignard                    --
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
------------------------------------------------------------------------------

with Ada.Unchecked_Deallocation;
with Ada.Numerics.Elementary_Functions;

package body Gnoga.Gui.Element.Canvas.Context_2D.Sprite is

   Sprite_List : Sprite_Lists.Vector;

   protected Sprite_Resource is
      entry Seize;
      procedure Release;
   private
      Busy : Boolean := False;
   end Sprite_Resource;

   protected body Sprite_Resource is
      entry Seize when not Busy is
      begin
         Busy := True;
      end Seize;
      procedure Release is
      begin
         Busy := False;
      end Release;
   end Sprite_Resource;

   ------------
   -- Create --
   ------------

   procedure Create
     (Sprite                        :    out Sprite_Type;
      Context                       : in     Context_2D_Type'Class;
      Image_Data                    : in     Image_Data_Type'Class;
      Row, Column                   : in     Integer;
      Row_Velocity, Column_Velocity : in     Integer := 0)
   is
      Sprite_Element : constant Sprite_Data_Access := new Sprite_Data;
   begin
      Sprite_Element.Context.Connection_ID     := Context.Connection_ID;
      Sprite_Element.Context.Context_ID        := Context.Context_ID;
      Sprite_Element.Drawn_Image.Connection_ID := Image_Data.Connection_ID;
      Sprite_Element.Drawn_Image.Context_ID    := Image_Data.Context_ID;
      Sprite_Element.Row                       := Row;
      Sprite_Element.Column                    := Column;
      Sprite_Element.Row_Velocity              := Row_Velocity;
      Sprite_Element.Column_Velocity           := Column_Velocity;
      Sprite_Element.Context.Get_Image_Data
      (Sprite_Element
         .Saved_Image, Sprite_Element
         .Column, Sprite_Element
         .Row, Sprite_Element
         .Drawn_Image.Width, Sprite_Element
         .Drawn_Image.Height);
      Sprite_Element.Context.Put_Image_Data
      (Sprite_Element.Drawn_Image, Sprite_Element.Column, Sprite_Element.Row);
      Sprite_List.Append (Sprite_Element);
      Sprite := Sprite_Type (Sprite_List.Last);
   end Create;

   ------------
   -- Locate --
   ------------

   procedure Locate (Sprite : in Sprite_Type; Row, Column : in Integer) is
      Sprite_Element : constant Sprite_Data_Access :=
        Sprite_Lists.Element (Sprite_Lists.Cursor (Sprite));
   begin
      Sprite_Resource.Seize;
      Sprite_Element.Context.Put_Image_Data
      (Sprite_Element.Saved_Image, Sprite_Element.Column, Sprite_Element.Row);
      Sprite_Element.Row    := Row;
      Sprite_Element.Column := Column;
      Sprite_Element.Context.Get_Image_Data
      (Sprite_Element
         .Saved_Image, Sprite_Element
         .Column, Sprite_Element
         .Row, Sprite_Element
         .Drawn_Image.Width, Sprite_Element
         .Drawn_Image.Height);
      Sprite_Element.Context.Put_Image_Data
      (Sprite_Element.Drawn_Image, Sprite_Element.Column, Sprite_Element.Row);
      Sprite_Resource.Release;
   end Locate;

   --------------
   -- Position --
   --------------

   procedure Position (Sprite : in Sprite_Type; Row, Column : out Integer) is
      Sprite_Element : constant Sprite_Data_Access :=
        Sprite_Lists.Element (Sprite_Lists.Cursor (Sprite));
   begin
      Row    := Sprite_Element.Row;
      Column := Sprite_Element.Column;
   end Position;

   ---------
   -- Row --
   ---------

   function Row (Sprite : in Sprite_Type) return Integer is
      Sprite_Element : constant Sprite_Data_Access :=
        Sprite_Lists.Element (Sprite_Lists.Cursor (Sprite));
   begin
      return Sprite_Element.Row;
   end Row;

   ------------
   -- Column --
   ------------

   function Column (Sprite : in Sprite_Type) return Integer is
      Sprite_Element : constant Sprite_Data_Access :=
        Sprite_Lists.Element (Sprite_Lists.Cursor (Sprite));
   begin
      return Sprite_Element.Column;
   end Column;

   -------------
   -- Pattern --
   -------------

   procedure Pattern
     (Sprite     : in Sprite_Type;
      Image_Data : in Image_Data_Type'Class)
   is
      Sprite_Element : constant Sprite_Data_Access :=
        Sprite_Lists.Element (Sprite_Lists.Cursor (Sprite));
   begin
      Sprite_Resource.Seize;
      Sprite_Element.Drawn_Image.Connection_ID := Image_Data.Connection_ID;
      Sprite_Element.Drawn_Image.Context_ID    := Image_Data.Context_ID;
      Sprite_Resource.Release;
   end Pattern;

   -------------
   -- Pattern --
   -------------

   function Pattern (Sprite : in Sprite_Type) return Image_Data_Type'Class is
      Sprite_Element : constant Sprite_Data_Access :=
        Sprite_Lists.Element (Sprite_Lists.Cursor (Sprite));
   begin
      return Pattern : Image_Data_Type do
         Pattern.Connection_ID := Sprite_Element.Drawn_Image.Connection_ID;
         Pattern.Context_ID    := Sprite_Element.Drawn_Image.Context_ID;
      end return;
   end Pattern;

   ------------
   -- Motion --
   ------------

   procedure Motion
     (Sprite                        : in Sprite_Type;
      Row_Velocity, Column_Velocity : in Integer)
   is
      Sprite_Element : constant Sprite_Data_Access :=
        Sprite_Lists.Element (Sprite_Lists.Cursor (Sprite));
   begin
      Sprite_Resource.Seize;
      Sprite_Element.Row_Velocity    := Row_Velocity;
      Sprite_Element.Column_Velocity := Column_Velocity;
      Sprite_Resource.Release;
   end Motion;

   ------------------
   -- Row_Velocity --
   ------------------

   function Row_Velocity (Sprite : in Sprite_Type) return Integer is
      Sprite_Element : constant Sprite_Data_Access :=
        Sprite_Lists.Element (Sprite_Lists.Cursor (Sprite));
   begin
      return Sprite_Element.Row_Velocity;
   end Row_Velocity;

   ---------------------
   -- Column_Velocity --
   ---------------------

   function Column_Velocity (Sprite : in Sprite_Type) return Integer is
      Sprite_Element : constant Sprite_Data_Access :=
        Sprite_Lists.Element (Sprite_Lists.Cursor (Sprite));
   begin
      return Sprite_Element.Column_Velocity;
   end Column_Velocity;

   -----------------
   -- Coincidence --
   -----------------

   function Coincidence
     (Sprite1, Sprite2 : in Sprite_Type;
      Tolerance        : in Natural) return Boolean
   is
   begin
      return Distance (Sprite1, Sprite2) <= Tolerance;
   end Coincidence;

   -----------------
   -- Coincidence --
   -----------------

   function Coincidence
     (Sprite      : in Sprite_Type;
      Row, Column : in Integer;
      Tolerance   : in Natural) return Boolean
   is
   begin
      return Distance (Sprite, Row, Column) <= Tolerance;
   end Coincidence;

   --------------
   -- Distance --
   --------------

   function Distance (Sprite1, Sprite2 : in Sprite_Type) return Natural is
      Sprite_Element1 : constant Sprite_Data_Access :=
        Sprite_Lists.Element (Sprite_Lists.Cursor (Sprite1));
      Sprite_Element2 : constant Sprite_Data_Access :=
        Sprite_Lists.Element (Sprite_Lists.Cursor (Sprite2));
      D2, D : Natural;
   begin
      Sprite_Resource.Seize;
      D2 :=
        (Sprite_Element2.Row - Sprite_Element1.Row)**2 +
        (Sprite_Element2.Column - Sprite_Element1.Column)**2;
      D := Natural (Ada.Numerics.Elementary_Functions.Sqrt (Float (D2)));
      Sprite_Resource.Release;
      return D;
   end Distance;

   --------------
   -- Distance --
   --------------

   function Distance
     (Sprite      : in Sprite_Type;
      Row, Column : in Integer) return Natural
   is
      Sprite_Element : constant Sprite_Data_Access :=
        Sprite_Lists.Element (Sprite_Lists.Cursor (Sprite));
      D2, D : Natural;
   begin
      Sprite_Resource.Seize;
      D2 :=
        (Sprite_Element.Row - Row)**2 + (Sprite_Element.Column - Column)**2;
      D := Natural (Ada.Numerics.Elementary_Functions.Sqrt (Float (D2)));
      Sprite_Resource.Release;
      return D;
   end Distance;

   ------------
   -- Delete --
   ------------

   procedure Delete (Sprite : in out Sprite_Type) is
      Sprite_Element : Sprite_Data_Access :=
        Sprite_Lists.Element (Sprite_Lists.Cursor (Sprite));
      procedure Free is new Ada.Unchecked_Deallocation
        (Sprite_Data,
         Sprite_Data_Access);
   begin
      Sprite_Resource.Seize;
      Sprite_Element.Context.Put_Image_Data
      (Sprite_Element.Saved_Image, Sprite_Element.Column, Sprite_Element.Row);
      Free (Sprite_Element);
      Delete (Sprite_List, Sprite);
      Sprite := Sprite_Type (Sprite_Lists.No_Element);
      Sprite_Resource.Release;
   end Delete;

   ----------------
   -- Delete_All --
   ----------------

   procedure Delete_All is
   begin
      for Sprite in Sprite_List.Iterate loop
         declare
            S : Sprite_Type := Sprite_Type (Sprite);
         begin
            Delete (S);
         end;
      end loop;
   end Delete_All;

   -------------
   -- Trigger --
   -------------

   Trigger_Value : Positive := 1000; --  Default 1000 milli-seconds

   procedure Trigger (Value : Positive) is
   begin
      Trigger_Value := Value;
   end Trigger;

   -------------
   -- Trigger --
   -------------

   function Trigger return Positive is
   begin
      return Trigger_Value;
   end Trigger;

   -----------------
   -- Sprite task --
   -----------------

   task Sprite;
   task body Sprite is
   begin
      loop
         for Sprite_Element of Sprite_List loop
            Sprite_Element.Context.Put_Image_Data
            (Sprite_Element
               .Saved_Image, Sprite_Element
               .Column, Sprite_Element
               .Row);
            Sprite_Element.Row :=
              Sprite_Element.Row + Sprite_Element.Row_Velocity;
            Sprite_Element.Column :=
              Sprite_Element.Column + Sprite_Element.Column_Velocity;
            Sprite_Element.Context.Get_Image_Data
            (Sprite_Element
               .Saved_Image, Sprite_Element
               .Column, Sprite_Element
               .Row, Sprite_Element
               .Drawn_Image.Width, Sprite_Element
               .Drawn_Image.Height);
            Sprite_Element.Context.Put_Image_Data
            (Sprite_Element
               .Drawn_Image, Sprite_Element
               .Column, Sprite_Element
               .Row);
         end loop;
         delay Standard.Duration (Trigger_Value) / 1000.0;
      end loop;
   end Sprite;

end Gnoga.Gui.Element.Canvas.Context_2D.Sprite;
