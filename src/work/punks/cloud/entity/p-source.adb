with Ada.Unchecked_Deallocation;
with Gnatcoll.JSON;
use Gnatcoll;
use type Gnatcoll.JSON.JSON_Value_Type;
package body Cloud_Property_Source is


   function Get_Name (Property : Property_Source_Type) return String is
   begin
      return Bounded_Properties_Fields.To_String (Property.Name);
   end Get_Name;

   function Get_Property
     (Property : Property_Source_Type;
      Name     : String) return String
   is
   Bounded_Name : constant Bounded_Properties_Fields.Bounded_String :=Bounded_Properties_Fields.To_Bounded_String (name);
      begin
      if not Property.Source.Contains (Bounded_Name) then
         return "";
      end if;
      return Bounded_Properties_Fields.To_String (Property.Source.Element (Bounded_Name));
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
                  Property :Property_Source_Type:=
                      (Name   => Bounded_Properties_Fields.To_Bounded_String (Property_Name),
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
                          (Key      => Bounded_Properties_Fields.To_Bounded_String (Name),
                           New_Item => (if Value.Kind = JSON.JSON_String_Type
                              then Bounded_Properties_Fields.To_Bounded_String (JSON.Get (Value))
                              else Bounded_Properties_Fields.To_Bounded_String (JSON.Write (Value))));
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


end Cloud_Property_Source;