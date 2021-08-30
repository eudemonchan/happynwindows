Unicode True
!include "MUI2.nsh"
!include "StrFunc.nsh"
!include "WinVer.nsh"
!include "LogicLib.nsh"
!include "x64.nsh"

${StrLoc}

Name "happynet"
OutFile "happynet_install.exe"

RequestExecutionLevel admin

BrandingText "Happynet Installer"
!define PRODUCT_VERSION "0.2.0.0"
!define PRODUCT_PUBLISHER "happyn.cc"

InstallDir "$PROGRAMFILES\happynet"
InstallDirRegKey HKLM "Software\happynet" "Path"

!define MUI_FINISHPAGE_RUN "$INSTDIR\happynet.exe"
!define MUI_FINISHPAGE_RUN_TEXT "Launch happynet"
!insertmacro MUI_PAGE_LICENSE "../COPYING"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "simpchinese"
;--------------------------------
;Version Information
VIProductVersion ${PRODUCT_VERSION}
VIAddVersionKey  ProductVersion ${PRODUCT_VERSION}
VIAddVersionKey  ProductName "Happynet Windows Client"
VIAddVersionKey  Comments "happyn for easy net"
VIAddVersionKey  CompanyName ${PRODUCT_PUBLISHER}
VIAddVersionKey  LegalCopyright "Copyright ${PRODUCT_PUBLISHER}"
VIAddVersionKey  FileDescription "happynet.exe"
VIAddVersionKey  FileVersion ${PRODUCT_VERSION}


;--------------------------------

Var is64bit

Icon "..\happynet\happyn.ico"

Section "happynet"
  SectionIn RO
  SetOutPath $INSTDIR
  
  CreateDirectory "$SMPROGRAMS\happynet"
  File "..\happynet\happyn.ico"

  WriteUninstaller "happynet_uninst.exe"
  WriteRegStr HKLM "SOFTWARE\happynet" "Path" '$INSTDIR'
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\happynet" "DisplayName" "happynet"
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\happynet" "UninstallString" '"$INSTDIR\happynet_uninst.exe"'
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\happynet" "QuietUninstallString" '"$INSTDIR\happynet_uninst.exe" /S'
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\happynet" "InstallLocation" '"$INSTDIR"'
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\happynet" "DisplayIcon" '"$INSTDIR\happyn.ico"'
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\happynet" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\happynet" "Publisher" "${PRODUCT_PUBLISHER}"
  
  
; --------------------------------------------------------
; edge.exe
; --------------------------------------------------------  
  SetOutPath $INSTDIR
  ${If} ${RunningX64}
    File "n2n_release\x64\edge.exe"
  ${Else}
    ${If} ${IsWinXP}
      File "n2n_release\winxp\edge.exe"
    ${Else}  
      File "n2n_release\x86\edge.exe"
    ${EndIf}
  ${EndIf}
  
  
; --------------------------------------------------------
; TAP DRIVER
; --------------------------------------------------------

  SetOutPath "$INSTDIR\drv"
  
  ${IfNot} ${AtLeastWinVista}

    ${If} ${RunningX64}
      File "..\tap_driver\NDIS5_x64\tapinstall.exe"
      File "..\tap_driver\NDIS5_x64\OemWin2k.inf"
      File "..\tap_driver\NDIS5_x64\tap0901.cat"
      File "..\tap_driver\NDIS5_x64\tap0901.sys"
      DetailPrint  "INSTALL NDIS5_x64"    
      nsExec::ExecToStack '"$INSTDIR\drv\tapinstall" find TAP0901'
      Pop $1
        Pop $2
        ${StrLoc} $0 $2 "No matching devices" 0
        nsExec::ExecToLog '"$INSTDIR\drv\tapinstall" remove TAP0901'
        nsExec::ExecToLog '"$INSTDIR\drv\tapinstall" install OemWin2k.inf TAP0901'
    ${Else}
      File "..\tap_driver\NDIS5_x86\tapinstall.exe"
      File "..\tap_driver\NDIS5_x86\OemWin2k.inf"
      File "..\tap_driver\NDIS5_x86\tap0901.cat"
      File "..\tap_driver\NDIS5_x86\tap0901.sys"
      DetailPrint  "INSTALL NDIS5_x86"      
      nsExec::ExecToStack '"$INSTDIR\drv\tapinstall" find TAP0901'
      Pop $1
        Pop $2
        ${StrLoc} $0 $2 "No matching devices" 0
        nsExec::ExecToLog '"$INSTDIR\drv\tapinstall" remove TAP0901'
        nsExec::ExecToLog '"$INSTDIR\drv\tapinstall" install OemWin2k.inf TAP0901'
    ${EndIf}
  
  ${Else}

    ${If} ${RunningX64}
      File "..\tap_driver\NDIS6_x64\tapinstall.exe"
      File "..\tap_driver\NDIS6_x64\OemVista.inf"
      File "..\tap_driver\NDIS6_x64\tap0901.cat"
      File "..\tap_driver\NDIS6_x64\tap0901.sys"
      DetailPrint  "INSTALL NDIS6_x64"
      nsExec::ExecToStack '"$INSTDIR\drv\tapinstall" find TAP0901'
      Pop $1
      Pop $2
      ${StrLoc} $0 $2 "No matching devices" 0
      nsExec::ExecToLog '"$INSTDIR\drv\tapinstall" remove TAP0901'
      nsExec::ExecToLog '"$INSTDIR\drv\tapinstall" install OemVista.inf TAP0901'  
    ${Else}
      File "..\tap_driver\NDIS6_x86\tapinstall.exe"
      File "..\tap_driver\NDIS6_x86\OemVista.inf"
      File "..\tap_driver\NDIS6_x86\tap0901.cat"
      File "..\tap_driver\NDIS6_x86\tap0901.sys"
      DetailPrint  "INSTALL NDIS6_x86"
      nsExec::ExecToStack '"$INSTDIR\drv\tapinstall" find TAP0901'
      Pop $1
      Pop $2
      ${StrLoc} $0 $2 "No matching devices" 0
      nsExec::ExecToLog '"$INSTDIR\drv\tapinstall" remove TAP0901'
      nsExec::ExecToLog '"$INSTDIR\drv\tapinstall" install OemVista.inf TAP0901'  
    ${EndIf}

  ${EndIf}

; --------------------------------------------------------
; SERVICE
; --------------------------------------------------------
  SetOutPath $INSTDIR

  ClearErrors
  EnumRegKey $0 HKLM "SOFTWARE\happynet" 0
  ${If} ${Errors}
    DetailPrint  "Value not found"
    WriteRegStr HKLM "SOFTWARE\happynet\Parameters" "community" "community"
    WriteRegStr HKLM "SOFTWARE\happynet\Parameters" "enckey" "enckey"
    WriteRegStr HKLM "SOFTWARE\happynet\Parameters" "ip_address" ""
    WriteRegStr HKLM "SOFTWARE\happynet\Parameters" "keyfile" ""
    WriteRegDWORD HKLM "SOFTWARE\happynet\Parameters" "local_port" 0x00000000
    WriteRegStr HKLM "SOFTWARE\happynet\Parameters" "mac_address" ""
    WriteRegDWORD HKLM "SOFTWARE\happynet\Parameters" "mtu" 0x00000000
    WriteRegDWORD HKLM "SOFTWARE\happynet\Parameters" "multicast" 0x00000000
    WriteRegDWORD HKLM "SOFTWARE\happynet\Parameters" "packet_forwarding" 0x00000001
    WriteRegDWORD HKLM "SOFTWARE\happynet\Parameters" "header_encry" 0x00000000
    WriteRegStr HKLM "SOFTWARE\happynet\Parameters" "subnet_mask" "255.255.255.0"
    WriteRegStr HKLM "SOFTWARE\happynet\Parameters" "supernode_addr" "vip00.happyn.cc"
    WriteRegDWORD HKLM "SOFTWARE\happynet\Parameters" "supernode_port" 0x00007530
    WriteRegStr HKLM "SOFTWARE\happynet\Parameters" "custom_param" "-l rvip.happyn.cc:30000"
    WriteRegDWORD HKLM "SOFTWARE\happynet\Parameters" "auto_start" 0x00000000
    WriteRegDWORD HKLM "SOFTWARE\happynet\Parameters" "auto_tray" 0x00000000
  ${Else}
    ${IF} $0 == ""
          DetailPrint   "NUL exists and it's empty"
          WriteRegStr HKLM "SOFTWARE\happynet\Parameters" "community" "community"
          WriteRegStr HKLM "SOFTWARE\happynet\Parameters" "enckey" "enckey"
          WriteRegStr HKLM "SOFTWARE\happynet\Parameters" "ip_address" ""
          WriteRegStr HKLM "SOFTWARE\happynet\Parameters" "keyfile" ""
          WriteRegDWORD HKLM "SOFTWARE\happynet\Parameters" "local_port" 0x00000000
          WriteRegStr HKLM "SOFTWARE\happynet\Parameters" "mac_address" ""
          WriteRegDWORD HKLM "SOFTWARE\happynet\Parameters" "mtu" 0x00000000
          WriteRegDWORD HKLM "SOFTWARE\happynet\Parameters" "multicast" 0x00000000
          WriteRegDWORD HKLM "SOFTWARE\happynet\Parameters" "packet_forwarding" 0x00000001
          WriteRegDWORD HKLM "SOFTWARE\happynet\Parameters" "header_encry" 0x00000000
          WriteRegStr HKLM "SOFTWARE\happynet\Parameters" "subnet_mask" "255.255.255.0"
          WriteRegStr HKLM "SOFTWARE\happynet\Parameters" "supernode_addr" "vip00.happyn.cc"
          WriteRegDWORD HKLM "SOFTWARE\happynet\Parameters" "supernode_port" 0x00007530
          WriteRegStr HKLM "SOFTWARE\happynet\Parameters" "custom_param" "-l rvip.happyn.cc:30000"
          WriteRegDWORD HKLM "SOFTWARE\happynet\Parameters" "auto_start" 0x00000000
          WriteRegDWORD HKLM "SOFTWARE\happynet\Parameters" "auto_tray" 0x00000000
      ${ELSE}
          DetailPrint   "Value isn't empty"
      ${ENDIF}
  ${EndIf}

; --------------------------------------------------------
; GUI TOOL
; --------------------------------------------------------
  SetOutPath $INSTDIR

  CreateShortCut "$SMPrograms\happynet\happynet.lnk" "$INSTDIR\happynet.exe"
  File "..\Release\happynet.exe"

; --------------------------------------------------------
; FINAL
; --------------------------------------------------------
  CreateShortCut "$SMPROGRAMS\happynet\Uninstall happynet.lnk" "$INSTDIR\happynet_uninst.exe"
SectionEnd

Function .onInit
  System::Call "kernel32::GetCurrentProcess() i.s"
  System::Call "kernel32::IsWow64Process(is, *i.s)"
  Pop $is64bit
FunctionEnd

UninstallText "This will uninstall happynet client.  Click 'Uninstall' to continue."

Section "Uninstall"
  nsExec::ExecToLog '"$INSTDIR\drv\tapinstall" remove TAP0901'
  Delete "$INSTDIR\drv\*.*"
  Delete "$INSTDIR\*.*"
  Delete "$SMPROGRAMS\happynet\*.*"
  RMDir "$SMPROGRAMS\happynet"
  RMDir "$INSTDIR\drv"
  RMDir "$INSTDIR"
  DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\happynet"
  DeleteRegKey HKLM "SOFTWARE\happynet"
SectionEnd