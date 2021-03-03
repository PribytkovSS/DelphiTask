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
    PipeHandle := CreateNamedPipe(PWideChar(pipeName), // ��� �����
                    PIPE_ACCESS_DUPLEX, // ����� ��������������� - ����� ��������� � ���������� ������
                    PIPE_TYPE_MESSAGE,  // ����� ��������� � ���������� ����� ���������
                    1,   // ���������� ��������� ��������� �����
                    PIPE_BUF_SIZE, // ������ ������ ������
                    PIPE_BUF_SIZE, // ������ ������ ������
                    PIPE_TIME_OUT, // ����-��� ������ ����� �� ���������
                    Security);

    if (PipeHandle = INVALID_HANDLE_VALUE) then
    begin
        eCode := INVALID_HANDLE_VALUE;
        eMessage := '�� ������� ������� �����: ' + GetSysErrorMessage;
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

    // ���, ����� ������ �������������� � �����
    if not Connected then
    begin
      Connected := ConnectNamedPipe(PipeHandle, nil);
      if (not Connected) then
      begin
          eCode := ERROR_PIPE_CONNECTED;
          eMessage := '���������� � ����� �� �������: ' + GetSysErrorMessage;
          // ���������� �������...
          // ����������� �����, ���������� ��������� ���������
          CloseHandle(PipeHandle);
          PipeHandle := INVALID_HANDLE_VALUE;
          Exit;
      end;
    end;

    // ���� ���������� �������, ������ �������� �� �������
    ok := ReadFile(PipeHandle, buf, PIPE_BUF_SIZE, BytesRead, nil)
          and (BytesRead > 0);

    if ok then
        // ��������� �� - ���-������, �� ���������� ����� ��, ��� ��������
        ok := WriteFile(PipeHandle, buf, BytesRead, BytesWritten, nil)
              and (BytesRead = BytesWritten);

    if not ok then
    begin
        eCode := GetLastError;
        eMessage := '������ ������ / ������: ' + GetSysErrorMessage;
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
