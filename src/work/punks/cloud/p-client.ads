with Ada.Finalization;
use Ada.Finalization;

with Ada.Strings.Bounded;
use Ada.Strings.Bounded;

with AWS.Net.SSL;
with AWS.Client;
with AWS.Response;
use AWS;


with AWS.Client;
with Cloud_Property_Source;

package Cloud_Config_Service_Client is

package Path_Strings is new Ada.Strings.Bounded.Generic_Bounded_Length(Max => 256);



  Type Client_Type is new Ada.Finalization.Limited_Controlled with private;
procedure Setup_Client (Client : in out Client_Type; 
Cloud_Server_Host : String; 
Trusted_Ca_Filename: String);

 procedure Initialize (Object : in out Client_Type);
procedure Finalize (Object : in out Client_Type);

function Load_Config (Object : in out Client_Type; Path:String) return  Cloud_Property_Source.Source_Vector.Vector;

private 

  type Client_Type is new Ada.Finalization.Limited_Controlled with record
  
   Cloud_Server_Host : Path_Strings.Bounded_String;
   Trusted_Ca_Filename: Path_Strings.Bounded_String;

   TLS_Config : AWS.Net.SSL.Config;
   Connection : AWS.Client.HTTP_Connection;
   RS: Response.Data;
  
  end record;
 

end Cloud_Config_Service_Client;