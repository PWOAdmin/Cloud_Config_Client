with Ada.Unchecked_Deallocation;
with Gnatcoll.JSON;
use Gnatcoll;
use type Gnatcoll.JSON.JSON_Value_Type;
package body work.punks.cloud.entity.Property_Source is

   procedure Deallocate is new Ada.Unchecked_Deallocation
     (Property_Source'Class, Property_Source_Access);

   function Get_Name (Property : access Property_Source'Class) return String is
   begin
      if Property = null then
         return "";
      end if;

      return Ada.Strings.Unbounded.To_String (Property.Name);
   end Get_Name;

   function Get_Property
     (Property : access Property_Source'Class;
      Name     : String) return String
   is
      Key : constant Unbounded_String := To_Unbounded_String (Name);
   begin
      if Property = null or else not Property.Source.Contains (Key) then
         return "";
      end if;

      return To_String (Property.Source.Element (Key));
   end Get_Property;

   function Read(Data: String) return Source_Vector.Vector is
      Result : Source_Vector.Vector;
      Property_Sources_Array_Key: constant String:= "propertySources";
      Json_Value : constant JSON.JSON_Value := JSON.Read (Data);
   begin
      if JSON.Has_Field (Json_Value, Property_Sources_Array_Key) then
         declare
            Property_Sources : constant JSON.JSON_Array :=
              JSON.Get (Json_Value, Property_Sources_Array_Key);
         begin
            for Source of Property_Sources loop
               declare
                  Property_Name : constant JSON.UTF8_String :=
                    JSON.Get (Source, "name");
                  Property : constant Property_Source_Access :=
                    new Property_Source'
                      (Name   => To_Unbounded_String (Property_Name),
                       Source => Source_Map.Empty_Map);
                  Source_Properties : constant JSON.JSON_Value :=
                    JSON.Get (Source, "source");

                  procedure Process_Value
                    (Name  : String;
                     Value : JSON.JSON_Value);

                  procedure Process_Field
                    (Name  : JSON.UTF8_String;
                     Value : JSON.JSON_Value)
                  is
                  begin
                     Process_Value (String (Name), Value);
                  end Process_Field;

                  procedure Process_Value
                    (Name  : String;
                     Value : JSON.JSON_Value)
                  is
                     procedure Process_Child
                       (Child_Name  : JSON.UTF8_String;
                        Child_Value : JSON.JSON_Value)
                     is
                     begin
                        Process_Value
                          (Name & "." & String (Child_Name), Child_Value);
                     end Process_Child;
                  begin
                     if Value.Kind = JSON.JSON_Object_Type then
                        JSON.Map_JSON_Object
                          (Value, Process_Child'Access);
                     else
                        Property.Source.Insert
                          (Key      => To_Unbounded_String (Name),
                           New_Item => To_Unbounded_String
                             (if Value.Kind = JSON.JSON_String_Type
                              then JSON.Get (Value)
                              else JSON.Write (Value)));
                     end if;
                  end Process_Value;
               begin
                  JSON.Map_JSON_Object
                    (Source_Properties, Process_Field'Access);
                  Result.Append (Property);
               end;
            end loop;
         end;
      end if;
      return Result;
   end Read;

   procedure Free (Property : in out Property_Source_Access) is
   begin
      Deallocate (Property);
   end Free;

end work.punks.cloud.entity.Property_Source;