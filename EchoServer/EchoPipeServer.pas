unit EchoPipeServer;

interface

type
  TEchoPipeServer = class
  private
    PipeHandle: THandle;
    Connected: boolean;
    eCode: Cardinal;
    eMessage: string;
  public
    constructor Create(pipeName: string);
    destructor Destroy;
    function ListenAndReply: string;

    property ErrorCode: Cardinal read eCode;
    property ErrorMessage: string read eMessage;
  end;

  function GetSysErrorMessage: string;

implementation

Uses Windows;

const
    PIPE_BUF_SIZE = 254;
    PIPE_TIME_OUT = 500;

constructor TEchoPipeServer.Create(pipeName: string);
var
   Security: PSecurityAttributes;
   SecDesc: PSecurityDescriptor;
begin
    PipeHandle := INVALID_HANDLE_VALUE;
    Connected := false;

    New(Security);
    Security.nLength := sizeof(SECURITY_ATTRIBUTES);
    Security.bInheritHandle := false;
    Security.lpSecurityDescriptor := nil;
    PipeName := pipeName;
    PipeHandle := CreateNamedPipe(PWideChar(pipeName), // Имя трубы
                    PIPE_ACCESS_DUPLEX, // Труба двунаправленная - может принимать и отправлять данные
                    PIPE_TYPE_MESSAGE,  // Труба принимает и отправляет поток сообщений
                    1,   // Количество возможных эземляров трубы
                    PIPE_BUF_SIZE, // Размер буфера чтения
                    PIPE_BUF_SIZE, // Размер буфера записи
                    PIPE_TIME_OUT, // Тайм-аут ответа трубы по умолчанию
                    Security);

    if (PipeHandle = INVALID_HANDLE_VALUE) then
    begin
        eCode := INVALID_HANDLE_VALUE;
        eMessage := 'Не удалось создать трубу: ' + GetSysErrorMessage;
    end
      else
        begin
            eCode := 0;
            eMessage := '';
        end;
end;

function TEchoPipeServer.ListenAndReply: string;
var
  Connected: boolean;
  BytesRead, BytesWritten: Cardinal;
  buf: array[0..PIPE_BUF_SIZE] of Char;
  ok: boolean;
begin
    result := '';

    if PipeHandle = INVALID_HANDLE_VALUE then Exit;

    // Ждём, когда клиент подсоединиться к трубе
    if not Connected then
    begin
      Connected := ConnectNamedPipe(PipeHandle, nil);
      if (not Connected) then
      begin
          eCode := ERROR_PIPE_CONNECTED;
          eMessage := 'Подлючение к трубе не удалось: ' + GetSysErrorMessage;
          // Прикрываем лавочку...
          // Освобождаем трубу, прекращаем принимать сообщения
          CloseHandle(PipeHandle);
          PipeHandle := INVALID_HANDLE_VALUE;
          Exit;
      end;
    end;

    // Если соединение удалось, читаем послание от клиента
    ok := ReadFile(PipeHandle, buf, PIPE_BUF_SIZE, BytesRead, nil)
          and (BytesRead > 0);

    if ok then
        // Поскольку мы - эхо-сервер, то отправляем назад то, что получили
        ok := WriteFile(PipeHandle, buf, BytesRead, BytesWritten, nil)
              and (BytesRead = BytesWritten);

    if not ok then
    begin
        eCode := GetLastError;
        eMessage := 'Ошибка чтения / записи: ' + GetSysErrorMessage;
    end else
          result := buf;
end;

destructor TEchoPipeServer.Destroy;
begin
    CloseHandle(PipeHandle);
end;

function GetSysErrorMessage: string;
var
   err: Cardinal;
   errorBuf: array[0..2048] of WideChar;
begin
    err := GetLastError;

    FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM,
                  nil,
                  err,
                  LANG_USER_DEFAULT,
                  errorBuf,
                  sizeof(errorBuf), nil);

    result := errorBuf;
end;

end.
