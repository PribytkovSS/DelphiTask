library PipeBuilder;

uses
  ComServ,
  PipeBuilderLib_TLB in 'PipeBuilderLib_TLB.pas',
  PipeBuilderUnit in 'PipeBuilderUnit.pas' {PipeBuilder: CoClass};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer,
  DllInstall;

{$R *.TLB}

{$R *.RES}

begin
end.
