program Server;
{$APPTYPE GUI}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  Data.FireDACJSONReflect in 'Data.FireDACJSONReflect.pas',
  ServerUnit in 'ServerUnit.pas' {DepartmentsServerForm},
  ServerMethods in 'ServerMethods.pas' {ServerMethods1: TDataModule},
  WebModuleUnit1 in 'WebModuleUnit1.pas' {WebModule1: TWebModule};

{$R *.res}

begin
//  TObject.Create;
//  ReportMemoryLeaksOnShutdown := True;
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TDepartmentsServerForm, DepartmentsServerForm);
  Application.Run;
end.
