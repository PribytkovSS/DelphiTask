program EchoServer;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  ComObj,
  EchoPipeServer in 'EchoPipeServer.pas';

var
  PipeName: string;
  PipeBuilder: Variant;
begin
  try
      CoInitializeEx(nil, 0);
      PipeBuilder := CreateOleObject('PipeBuilder.PipeBuilder');
      PipeName := PipeBuilder.GetPipeName;

      with TEchoPipeServer.Create(PipeName) do
      try
          while ErrorCode = 0 do
             WriteLn(ListenAndReply);
          WriteLn(ErrorMessage);
      finally
          Free;
      end;
  except
    on E: Exception do
    begin
        WriteLn('Ошибка: ' + E.Message);
        ReadLn;
    end;
  end;
end.
