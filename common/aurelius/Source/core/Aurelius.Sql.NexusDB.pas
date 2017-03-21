unit Aurelius.Sql.NexusDB;

{$I Aurelius.inc}

interface

uses
  DB,
  Aurelius.Sql.AnsiSqlGenerator,
  Aurelius.Sql.BaseTypes,
  Aurelius.Sql.Commands,
  Aurelius.Sql.Interfaces,
  Aurelius.Sql.Metadata,
  Aurelius.Sql.Register;

type
  TNexusDBSQLGenerator = class(TAnsiSQLGenerator)
  protected
    function GetMaxConstraintNameLength: Integer; override;
    procedure DefineColumnType(Column: TColumnMetadata); override;
    function GetSqlLiteral(AValue: Variant; AType: TFieldType): string; override;
    function GetGeneratorName: string; override;
    function GetSqlDialect: string; override;
    function GetSupportedFeatures: TDBFeatures; override;
    function GenerateGetLastInsertId(SQLField: TSQLField): string; override;
    function GenerateDropField(Column: TColumnMetadata): string; override;
    function GenerateLimitedSelect(SelectSql: TSelectSql; Command: TSelectCommand): string; override;

    function GetSupportedFieldTypes: TFieldTypeSet; override;
  end;

implementation

uses
  Variants, SysUtils;

{ TNexusDBSQLGenerator }

procedure TNexusDBSQLGenerator.DefineColumnType(Column: TColumnMetadata);
begin
  DefineNumericColumnType(Column);
  if Column.DataType <> '' then
  begin
    // Ignore Precision and Scale if Scale > 4 (not supported by Nexus)
    // In this case, use a built-in numeric type to hold the specified scale
    if Column.Scale >= 4 then
    begin
      Column.DataType := 'REAL';
      Column.Precision := 0;
      Column.Scale := 0;
    end;
    Exit;
  end;

  case Column.FieldType of
    ftByte:
      Column.DataType := 'TINYINT';
    ftShortint:
      Column.DataType := 'SHORTINT';
    ftWord:
      Column.DataType := 'WORD';
    ftLongWord:
      Column.DataType := 'DWORD';
    ftLargeint:
      Column.DataType := 'BIGINT';

    ftFixedChar:
      Column.DataType := 'VARCHAR($len)';
    ftFixedWideChar:
      Column.DataType := 'NVARCHAR($len)';

    ftFloat:
      Column.DataType := 'REAL';
    ftSingle:
      Column.DataType := 'FLOAT';
    ftExtended:
      Column.DataType := 'EXTENDED';
    ftCurrency:
      Column.DataType := 'MONEY';
//    ftFMTBcd:
//      Column.DataType := 'NUMERIC(16, 4)';

    ftBoolean:
      Column.DataType := 'BOOLEAN';

    ftMemo:
      Column.DataType := 'CLOB';
    ftWideMemo:
      Column.DataType := 'NCLOB';
    ftBlob:
      Column.DataType := 'BLOB';
    ftGuid:
      Column.DataType := 'GUID';
  else
    inherited DefineColumnType(Column);
  end;
  if Column.AutoGenerated then
    Column.DataType := 'AUTOINC(1, 1)';
end;

function TNexusDBSQLGenerator.GenerateDropField(Column: TColumnMetadata): string;
begin
  result := InternalGenerateDropField(Column, True);
end;

function TNexusDBSQLGenerator.GenerateGetLastInsertId(SQLField: TSQLField): string;
begin
  Result := 'SELECT LASTAUTOINC FROM #dummy';
end;

function TNexusDBSQLGenerator.GenerateLimitedSelect(SelectSql: TSelectSql;
  Command: TSelectCommand): string;
var
  MaxRows: integer;
  p: integer;
  TopStr: string;
begin
  Result := GenerateRegularSelect(SelectSql);
  p := Pos('SELECT', UpperCase(Result));
  Assert(p > 0, 'SELECT word not found in SQL. Cannot generate limited select');
  p := p + Length('SELECT');

  // MaxRows must be present in SQL statement no matter what
  if not Command.HasMaxRows then
    MaxRows := MaxInt div 2 // for some reason even maxint - 2 cause integer overflow
  else
    MaxRows := Command.MaxRows;

  if Command.HasFirstRow then
    TopStr := TopStr + Format('TOP %d,%d', [MaxRows, Command.FirstRow + 1])
  else
    TopStr := TopStr + Format('TOP %d', [MaxRows]);
  TopStr := ' ' + TopStr;
  Result := 'SELECT ' + TopStr + Copy(Result, p, MaxInt);
end;

function TNexusDBSQLGenerator.GetSqlDialect: string;
begin
  Result := 'NexusDB';
end;

function TNexusDBSQLGenerator.GetGeneratorName: string;
begin
  Result := 'NexusDB SQL Generator';
end;

function TNexusDBSQLGenerator.GetMaxConstraintNameLength: Integer;
begin
  Result := 128;
end;

function TNexusDBSQLGenerator.GetSqlLiteral(AValue: Variant;
  AType: TFieldType): string;
begin
  Result := inherited GetSqlLiteral(AValue, AType);
end;

function TNexusDBSQLGenerator.GetSupportedFeatures: TDBFeatures;
begin
  Result := AllDBFeatures - [TDBFeature.Sequences];
end;

function TNexusDBSQLGenerator.GetSupportedFieldTypes: TFieldTypeSet;
begin
  Result := inherited GetSupportedFieldTypes + [ftBoolean, ftGuid];
end;

initialization
  TSQLGeneratorRegister.GetInstance.RegisterGenerator(TNexusDBSQLGenerator.Create);

end.