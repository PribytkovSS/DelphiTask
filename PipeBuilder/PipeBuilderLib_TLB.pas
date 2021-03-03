unit PipeBuilderLib_TLB;

// ************************************************************************ //
// WARNING
// -------
// The types declared in this file were generated from data read from a
// Type Library. If this type library is explicitly or indirectly (via
// another type library referring to this type library) re-imported, or the
// 'Refresh' command of the Type Library Editor activated while editing the
// Type Library, the contents of this file will be regenerated and all
// manual modifications will be lost.
// ************************************************************************ //

// $Rev: 52393 $
// File generated on 03.03.2021 16:00:06 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Users\sereg\OneDrive\хо\BusinessPro\DelphiTask\PipeBuilder\PipeBuilderLib (1)
// LIBID: {290E76BD-F450-4D3D-99F7-0B0E889CF188}
// LCID: 0
// Helpfile:
// HelpString:
// DepndLst:
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// SYS_KIND: SYS_WIN32
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers.
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}

interface

uses Winapi.Windows, System.Classes, System.Variants, System.Win.StdVCL, Vcl.Graphics, Vcl.OleServer, Winapi.ActiveX;


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:
//   Type Libraries     : LIBID_xxxx
//   CoClasses          : CLASS_xxxx
//   DISPInterfaces     : DIID_xxxx
//   Non-DISP interfaces: IID_xxxx
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  PipeBuilderLibMajorVersion = 1;
  PipeBuilderLibMinorVersion = 0;

  LIBID_PipeBuilderLib: TGUID = '{290E76BD-F450-4D3D-99F7-0B0E889CF188}';

  IID_IPipeBuilder: TGUID = '{82A1D937-EF4B-4CEA-A70B-B6F5679ADD4A}';
  CLASS_PipeBuilder: TGUID = '{6ACF2F8A-5E2C-4606-B6D3-5780001881C3}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//
  IPipeBuilder = interface;
  IPipeBuilderDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library
// (NOTE: Here we map each CoClass to its Default Interface)
// *********************************************************************//


// *********************************************************************//
// Interface: IPipeBuilder
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {82A1D937-EF4B-4CEA-A70B-B6F5679ADD4A}
// *********************************************************************//
  IPipeBuilder = interface(IDispatch)
    ['{82A1D937-EF4B-4CEA-A70B-B6F5679ADD4A}']
    function GetPipeName: PWideChar; stdcall;
  end;

// *********************************************************************//
// DispIntf:  IPipeBuilderDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {82A1D937-EF4B-4CEA-A70B-B6F5679ADD4A}
// *********************************************************************//
  IPipeBuilderDisp = dispinterface
    ['{82A1D937-EF4B-4CEA-A70B-B6F5679ADD4A}']
    function GetPipeName: {NOT_OLEAUTO(PWideChar)}OleVariant; dispid 201;
  end;

implementation

uses System.Win.ComObj;

end.

