unit BusLineController;

interface

uses BusLine, Generics.Collections, Aurelius.Engine.ObjectManager, ControllerInterfaces;

type
  TBusLineController = class(TInterfacedObject, IController<TBusLine>)
  private
     FManager: TObjectManager;
  public
     constructor create;
     destructor destroy;
     procedure Delete(BusLine: TBusLine);
     function getAll: TList<TBusLine>;
     function getBusLine(id: integer): TBusLine;
     procedure Save(BusLine: TBusLine);

  end;

implementation

uses
  DBConnection;

{ TBusLineController }

constructor TBusLineController.create;
begin
  FManager := TDBConnection.GetInstance.CreateObjectManager;
end;

procedure TBusLineController.Delete(BusLine: TBusLine);
begin
  if not FManager.IsAttached(BusLine) then
  begin
    BusLine := FManager.Find<TBusLine>(BusLine.ID);
    FManager.Remove(BusLine);
  end;
end;

destructor TBusLineController.destroy;
begin
  FManager.Free;
end;

function TBusLineController.getAll: TList<TBusLine>;
begin
  Result := FManager.FindAll<TBusLine>;
end;

function TBusLineController.getBusLine(id: integer): TBusLine;
begin
  Result := FManager.Find<TBusLine>(id);
end;

procedure TBusLineController.Save(BusLine: TBusLine);
begin
  FManager.Save(BusLine);
end;

end.
