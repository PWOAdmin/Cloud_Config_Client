with work.punks.cloud.entity.Property_Source;
package body work.punks.cloud.Cloud_Config_Service_Client is

procedure Setup_Client (Client : in out Client_Type; 
Cloud_Server_Host : String; 
Trusted_Ca_Filename: String)
is
begin

Client.Cloud_Server_Host:= To_Unbounded_String (Cloud_Server_Host);
Client.Trusted_Ca_Filename:=To_Unbounded_String (Trusted_Ca_Filename);

AWS.Net.SSL.Initialize
     (Config               => Client.TLS_Config,
      
      Security_Mode        => AWS.Net.SSL.TLS_Client,
      Trusted_CA_Filename  => To_String(Client.Trusted_Ca_Filename));

   AWS.Client.Create
     (Connection => Client.Connection,
      Host       => To_String(Client.Cloud_Server_Host),
      SSL_Config => Client.TLS_Config);
end Setup_Client;
procedure Initialize (Object : in out Client_Type) is
begin
null;
end Initialize;

procedure Finalize (Object : in out Client_Type) is
begin
   AWS.Client.Close (Object.Connection);
   AWS.Net.SSL.Release (Object.TLS_Config);
end Finalize;

function Load_Config (Object : in out Client_Type; Path: String) return Source_Vector.Vector is
PS:Source_Vector.Vector;
RS: Response.Data;
begin
  AWS.Client.Get
     (Connection => Object.Connection,
      Result     => RS,
      URI        => Path);
PS:=work.punks.cloud.entity.Property_Source.Read(RS.Message_Body);
return PS;
end Load_Config;

end work.punks.cloud.Cloud_Config_Service_Client;