unit DaemonMapperUnit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DaemonApp;

type

  { TDaemonMapper1 }

  TDaemonMapper1 = class(TDaemonMapper)
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  DaemonMapper1: TDaemonMapper1; 

implementation

Procedure RegisterMapper; 
begin
  RegisterDaemonMapper(TDaemonMapper1)
end;

{ TDaemonMapper1 }

{$R *.lfm}


initialization
  RegisterMapper; 
end.

