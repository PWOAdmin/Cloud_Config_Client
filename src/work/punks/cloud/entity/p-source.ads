
with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;
with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Containers.Indefinite_Vectors;
with Ada.Strings.Unbounded.Hash;

package work.punks.cloud.entity.Property_Source is

Type Property_Source is tagged private;
Type Property_Source_Access is access all Property_Source'Class;

package Source_Map is new Ada.Containers.Indefinite_Hashed_Maps
   (Key_Type => Unbounded_String,
    Element_Type => Unbounded_String, Hash => Ada.Strings.Unbounded.Hash, Equivalent_Keys => "=");


Package Source_Vector is new Ada.Containers.Indefinite_Vectors
   (Index_Type => Positive,
    Element_Type => Property_Source_Access);  

--------------------------------------------------------------
------------- Getters ----------------------------------------
---------------------------------------------------------------
function Get_Name (Property : access Property_Source'Class) return String;
function Get_Property(Property : access Property_Source'Class; Name : String) return String;


function Read(Data: String) return Source_Vector.Vector;

procedure Free (Property : in out Property_Source_Access);

private

   type Property_Source is tagged record
      Name : Unbounded_String;
      Source : Source_Map.Map;
   end record;

end work.punks.cloud.entity.Property_Source; 
