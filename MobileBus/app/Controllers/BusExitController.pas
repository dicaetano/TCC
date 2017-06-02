unit BusExitController;

interface

uses
  BusExitTime, Generics.Collections, Aurelius.Engine.ObjectManager, ControllerInterfaces, BusLine,
  Aurelius.Criteria.Linq, Aurelius.Criteria.Projections;

type
  TBusExitController = class(TInterfacedObject, IController<TBusExitTime>)
  private
     FManager: TObjectManager;
  public
     constructor create;
     destructor destroy;
     procedure Delete(BusLine: TBusExitTime);
     function getAll: TList<TBusExitTime>;
     function getBusExitTime(id: integer): TBusExitTime;
     function getTimes(BusLine: TBusLine): TList<TBusExitTime>;
     procedure Save(BusLine: TBusExitTime);

  end;

implementation

uses
  DBConnection;

{ TBusExitTimeController }

constructor TBusExitController.create;
begin
  FManager := TDBConnection.GetInstance.CreateObjectManager;
end;

procedure TBusExitController.Delete(BusLine: TBusExitTime);
begin
  if not FManager.IsAttached(BusLine) then
  begin
    BusLine := FManager.Find<TBusExitTime>(BusLine.ID);
    FManager.Remove(BusLine);
  end;
end;

destructor TBusExitController.destroy;
begin
  FManager.Free;
end;

function TBusExitController.getAll: TList<TBusExitTime>;
begin
  Result := FManager.FindAll<TBusExitTime>;
end;

function TBusExitController.geTBusExitTime(id: integer): TBusExitTime;
begin
  Result := FManager.Find<TBusExitTime>(id);
end;

function TBusExitController.getTimes(BusLine: TBusLine): TList<TBusExitTime>;
begin
  Result := FManager.Find<TBusExitTime>.
   CreateAlias('BusLine', 'b').
   Where(Linq.Sql<Integer>('{b.ID} = (?)', BusLine.ID)).List;
end;

procedure TBusExitController.Save(BusLine: TBusExitTime);
begin
  FManager.Save(BusLine);
end;

end.
