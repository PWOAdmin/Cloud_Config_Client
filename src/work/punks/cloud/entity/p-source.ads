
with Ada.Containers.Hashed_Maps;
with Ada.Strings.Bounded;
use Ada.Strings.Bounded;
with Ada.Containers.Vectors;
with Ada.Strings;
with Ada.Strings.Hash;
with  Ada.strings.Bounded.Hash;

with Ada.Strings.Bounded.Hash;
package Cloud_Property_Source is

Property_Length: constant positive:=128;

package Bounded_Properties_Fields is  new Ada.Strings.Bounded.Generic_Bounded_Length(Max=>Property_Length);
function Hash_Bounded_Property is
  new Ada.Strings.Bounded.Hash (Bounded => Bounded_Properties_Fields);

package Source_Map is new Ada.Containers.Hashed_Maps
  (Key_Type        => Bounded_Properties_Fields.Bounded_String,
   Element_Type    => Bounded_Properties_Fields.Bounded_String,
   Hash            => Hash_Bounded_Property,
   Equivalent_Keys => Bounded_Properties_Fields."=",
   "="             => Bounded_Properties_Fields."=");

Type Property_Source_Type is record
      Name : Bounded_Properties_Fields.Bounded_String;
      Source : Source_Map.Map;
end record;

Package Source_Vector is new Ada.Containers.Vectors
   (Index_Type => Positive,
    Element_Type => Property_Source_Type);  

--------------------------------------------------------------
------------- Getters ----------------------------------------
---------------------------------------------------------------
function Get_Name (Property : Property_Source_Type) return String;
function Get_Property(Property : Property_Source_Type; Name : String) return String;


function Read(Data: String) return Source_Vector.Vector;



end Cloud_Property_Source; 
