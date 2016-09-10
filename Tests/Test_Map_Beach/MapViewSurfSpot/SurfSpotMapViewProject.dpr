program SurfSpotMapViewProject;

uses
  System.StartUpCopy,
  FMX.Forms,
  SurfSpotMapView in 'SurfSpotMapView.pas' {Form26};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm26, Form26);
  Application.Run;
end.
