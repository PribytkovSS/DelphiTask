unit PipeBuilderUnit;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, ActiveX, Classes, ComObj, PipeBuilderLib_TLB, StdVcl;

type
  TPipeBuilder = class(TComObject, IPipeBuilder)
  protected
    function GetPipeName: PWideChar; stdcall;
  end;

implementation

uses ComServ, SysUtils;

var
  PipeName: string;

function TPipeBuilder.GetPipeName: PWideChar;
begin
    result := PWideChar(PipeName);
end;

var
  g: TGUID;
initialization
  TTypedComObjectFactory.Create(ComServer, TPipeBuilder, CLASS_PipeBuilder,
    ciSingleInstance, tmSingle);

  CreateGUID(g);
  PipeName := '\\.\pipe\' + GUIDToString(g);
end.
