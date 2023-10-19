unit DaemonUnit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DaemonApp, simpletimer;

type

  { TDaemon1 }

  TDaemon1 = class(TDaemon)
    procedure DataModuleStart(Sender: TCustomDaemon; var OK: Boolean);
    procedure DataModuleAfterInstall(Sender: TCustomDaemon);
    procedure TimerFired(const Sender: TObject);
  private
    { private declarations }
      Timer : TSimpleTimer;
  public
    { public declarations }
  end; 

var
  Daemon1: TDaemon1;

implementation

Uses
  funcoes;

Procedure RegisterDaemon; 
begin
  RegisterDaemonClass(TDaemon1)
end;

{ TDaemon1 }

procedure TDaemon1.TimerFired(const Sender: TObject);
begin
  UpdateIP;
end;

procedure TDaemon1.DataModuleStart(Sender: TCustomDaemon; var OK: Boolean);
begin
  Log('Initializing service.');
  Ini;
  Sleep(1000);
  TimerFired(self);
  Timer := TSimpleTimer.Create(self);
  Timer.Interval := refresh;
  Timer.OnTimer := @TimerFired;
  Timer.Enabled := True;
end;

procedure TDaemon1.DataModuleAfterInstall(Sender: TCustomDaemon);
begin
   Log('Service installed.');
end;

{$R *.lfm}


initialization
  RegisterDaemon; 
end.

