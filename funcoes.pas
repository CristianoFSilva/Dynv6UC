unit funcoes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DaemonApp, httpSend, ssl_openssl, IniFiles;


Var
  token, server: String;
  refresh: Integer;


Procedure Log(msg: String);
Procedure Ini;
Function PegaIPv4: String;
Function PegaIPv6: String;
function MemoryStreamToString(M: TMemoryStream): AnsiString;
procedure UpdateIP;



implementation



Procedure Log(msg: String);
var
  Filename: string;
  LogFile: TextFile;
begin
  Filename := ChangeFileExt (Application.Exename, '.log');
  AssignFile (LogFile, Filename);
  if FileExists (FileName) then
    Append (LogFile)
  else
    Rewrite (LogFile);
  try
    Writeln (LogFile, DateTimeToStr (Now) + ': ' + msg);
  finally
    CloseFile (LogFile);
  end;
end;

Procedure Ini;
Var
  myINI : TIniFile;
  ref: Integer;
begin
  Log('Loading server and token');
  myINI := TIniFile.Create(ExtractFilePath(Application.EXEName) + 'config.ini');
  token := myINI.ReadString('GENERAL', 'token', '');
  server := myINI.ReadString('GENERAL', 'server', '');
  ref := myINI.ReadInteger('GENERAL', 'refreshtime', 10);
  refresh := ref * 60000;
  Log('Refresh timer is ' + IntToStr(ref) + ' minutes');
  myINI.Free;
end;

Function PegaIPv4: String;
Var
  IPv4: String;
  httpClient: THTTPSend;
begin
  httpClient:= THTTPSend.Create;
  if httpClient.HTTPMethod('GET', 'https://ipv4.icanhazip.com') then
    begin
      IPv4 := Trim(MemoryStreamToString(httpClient.Document));
      log('IPV4: ' + IPv4);
      result := IPv4;
    end
  else
    begin
      log('IPV4: Offline');
      result := '';
    end;
  httpClient.Free;
end;

Function PegaIPv6: String;
var
  IPv6: String;
  httpClient: THTTPSend;
begin
  httpClient:= THTTPSend.Create;
  if httpClient.HTTPMethod('GET', 'https://ipv6.icanhazip.com') then
    begin
      IPv6 := Trim(MemoryStreamToString(httpClient.Document));
      log('IPV6: ' + IPv6);
      result := IPv6;
    end
  else
    begin
      log('IPV6: Offline');
      result := '';
    end;
  httpClient.Free;
end;

procedure UpdateIP;
var
  httpClient: THTTPSend;
  url, IPv4, IPv6: String;
begin
  IPv4 := PegaIPv4;
  IPv6 := PegaIPv6;
  if (Length(IPv4) = 0) and (Length(IPv6) = 0) then
    begin
      Log('No valid IP');
    end
  else
    begin
      if (Length(IPv4) = 0) then
        url := 'https://dynv6.com/api/update?hostname=' + server + '&token=' + token +
               {'&ipv4=' + IPv4 + }'&ipv6=' + IPv6
      else if (Length(IPv6) = 0) then
        url := 'https://dynv6.com/api/update?hostname=' + server + '&token=' + token +
               '&ipv4=' + IPv4 {+ '&ipv6=' + IPv6}
      else
        url := 'https://dynv6.com/api/update?hostname=' + server + '&token=' + token +
               '&ipv4=' + IPv4 + '&ipv6=' + IPv6;

      httpClient:= THTTPSend.Create;
      if httpClient.HTTPMethod('GET', url) then
        begin
          Log(Trim(MemoryStreamToString(httpClient.Document)));
        end
      else
        begin
          Log('Update fail');
        end;
      httpClient.Free;
    end;
end;

function MemoryStreamToString(M: TMemoryStream): AnsiString;
begin
  SetString(Result, PAnsiChar(M.Memory), M.Size);
end;



end.

