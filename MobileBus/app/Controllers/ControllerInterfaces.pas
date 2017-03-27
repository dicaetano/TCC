unit ControllerInterfaces;

interface
uses
  Generics.Collections;

type
  IController<T> = interface
    procedure Delete(Param: T);
    function GetAll: TList<T>;
  end;

implementation

end.
