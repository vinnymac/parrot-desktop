!include "MUI2.nsh"
!include "nsProcess.nsh"
!include "LogicLib.nsh"
!include "nsDialogs.nsh"

CRCCheck on
XPStyle on


!define MUI_ICON "../app/assets/icon-${environment}.ico"
!define MUI_UNICON "../app/assets/icon-${environment}.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "../app/assets/windows-${environment}.bmp"
!define MUI_SPECIALBITMAP "../app/assets/windows-${environment}.bmp"
!define MUI_HEADERIMAGE_RIGHT


!define PRODUCT_NAME "Parrot"
!define DIST_DIR "../dist/build/Parrot-win32-ia32"
!define REG_PATH "Software\Microsoft\Windows\CurrentVersion\Uninstall\Parrot"


BrandingText "Parrot"
Name "${PRODUCT_NAME}"
Icon "../app/assets/icon-${environment}.ico"

# define the resulting installer's name:
OutFile "${DIST_DIR}/Parrot-Setup-Admin.exe"


Var Dialog
Var AutoLogin
Var AutoLogin_State
Var AutoLaunch
Var AutoLaunch_State
Var DTShortcut
Var DTShortcut_State
Var SMShortcut
Var SMShortcut_State
Var QLShortcut
Var QLShortcut_State

Page Custom nsDialogsPage nsDialogsPageLeave
Page instfiles


Function nsDialogsPage
  nsDialogs::Create 1018
  Pop $Dialog

  ${If} $Dialog == error
    Abort
  ${EndIf}

  ${NSD_CreateCheckBox} 0 0 100% 12u "Launch Parrot automatically on login"
  Pop $AutoLogin

  ${NSD_CreateCheckBox} 0 12u 100% 12u "Launch Parrot after installation completes"
  Pop $AutoLaunch

  ${NSD_CreateCheckBox} 0 34u 100% 12u "Add Desktop Shortcut"
  Pop $DTShortcut

  ${NSD_CreateCheckBox} 0 46u 100% 12u "Add Start Menu Shortcut"
  Pop $SMShortcut

  ${NSD_CreateCheckBox} 0 58u 100% 12u "Add Quick Launch Shortcut"
  Pop $QLShortcut

  ${NSD_SetState} $AutoLogin 1
  ${NSD_SetState} $AutoLaunch 1
  ${NSD_SetState} $DTShortcut 0
  ${NSD_SetState} $SMShortcut 1
  ${NSD_SetState} $QLShortcut 1

  nsDialogs::Show
FunctionEnd


Function nsDialogsPageLeave
  ${NSD_GetState} $AutoLogin $AutoLogin_State
  ${NSD_GetState} $AutoLaunch $AutoLaunch_State
  ${NSD_GetState} $DTShortcut $DTShortcut_State
  ${NSD_GetState} $SMShortcut $SMShortcut_State
  ${NSD_GetState} $QLShortcut $QLShortcut_State
FunctionEnd


Section "Kill process" KillProcess
  ${nsProcess::CloseProcess} "Parrot.exe" $R0
  ${nsProcess::Unload}
  Sleep 2000
SectionEnd


# default section start
Section

  # StrCpy can only be called in a Section or Function, so this
  # definition is repeated in each section that requires it.
  StrCpy $INSTDIR "$PROGRAMFILES\Parrot"

  # define the path to which the installer should install
  SetOutPath $INSTDIR

  # specify the files to go in the output path
  # these are the Windows files produced by node-webkit-builder
  File "${DIST_DIR}/Parrot.exe"
  File "${DIST_DIR}/content_resources_200_percent.pak"
  File "${DIST_DIR}/content_shell.pak"
  File "${DIST_DIR}/d3dcompiler_47.dll"
  File "${DIST_DIR}/icudtl.dat"
  File "${DIST_DIR}/libEGL.dll"
  File "${DIST_DIR}/libGLESv2.dll"
  File "${DIST_DIR}/msvcp120.dll"
  File "${DIST_DIR}/msvcr120.dll"
  File "${DIST_DIR}/natives_blob.bin"
  File "${DIST_DIR}/node.dll"
  File "${DIST_DIR}/pdf.dll"
  File "${DIST_DIR}/snapshot_blob.bin"
  File "${DIST_DIR}/ui_resources_200_percent.pak"
  File "${DIST_DIR}/vccorlib120.dll"
  File "${DIST_DIR}/xinput1_3.dll"
  File /r "${DIST_DIR}/locales"
  File /r "${DIST_DIR}/resources"
  File "../app/assets/Parrot.VisualElementsManifest.xml"
  File "../app/assets/icon-${environment}.ico"

  # define the uninstaller name
  WriteUninstaller $INSTDIR\parrot_uninstaller.exe

  WriteRegStr HKCU "${REG_PATH}" "DisplayName" "Parrot"
  WriteRegStr HKCU "${REG_PATH}" "DisplayIcon" "$\"$INSTDIR\icon-${environment}.ico$\""
  WriteRegStr HKCU "${REG_PATH}" "UninstallString" "$\"$INSTDIR\parrot_uninstaller.exe$\""

  ${If} $AutoLaunch_State == ${BST_CHECKED}
    ExecShell "" "$INSTDIR\Parrot.exe"
  ${EndIf}

  ${If} $AutoLogin_State == ${BST_CHECKED}
    CreateShortCut "$SMSTARTUP\Parrot.lnk" "$INSTDIR\Parrot.exe" "." "$INSTDIR\icon-${environment}.ico" "" "" "" "Parrot"
  ${EndIf}

  ${If} $DTShortcut_State == ${BST_CHECKED}
    CreateShortCut "$DESKTOP\Parrot.lnk" "$INSTDIR\Parrot.exe" "." "$INSTDIR\icon-${environment}.ico" "" "" "" "Parrot"
  ${EndIf}

  ${If} $SMShortcut_State == ${BST_CHECKED}
    CreateShortCut "$SMPROGRAMS\Parrot.lnk" "$INSTDIR\Parrot.exe" "." "$INSTDIR\icon-${environment}.ico" "" "" "" "Parrot"
  ${EndIf}

  ${If} $QLShortcut_State == ${BST_CHECKED}
    CreateShortCut "$QUICKLAUNCH\Parrot.lnk" "$INSTDIR\Parrot.exe" "." "$INSTDIR\icon-${environment}.ico" "" "" "" "Parrot"
  ${EndIf}

  Quit

SectionEnd


# create a section to define what the uninstaller does
Section "Uninstall"

  # StrCpy can only be called in a Section or Function, so this
  # definition is repeated in each section that requires it.
  StrCpy $INSTDIR "$PROGRAMFILES\Parrot"

  # delete the uninstaller
  Delete $INSTDIR\parrot_uninstaller.exe

  # delete the installed files
  Delete $INSTDIR/Parrot.exe
  Delete $INSTDIR/content_resources_200_percent.pak
  Delete $INSTDIR/content_shell.pak
  Delete $INSTDIR/d3dcompiler_47.dll
  Delete $INSTDIR/icudtl.dat
  Delete $INSTDIR/libEGL.dll
  Delete $INSTDIR/libGLESv2.dll
  Delete $INSTDIR/msvcp120.dll
  Delete $INSTDIR/msvcr120.dll
  Delete $INSTDIR/natives_blob.bin
  Delete $INSTDIR/node.dll
  Delete $INSTDIR/pdf.dll
  Delete $INSTDIR/snapshot_blob.bin
  Delete $INSTDIR/ui_resources_200_percent.pak
  Delete $INSTDIR/vccorlib120.dll
  Delete $INSTDIR/xinput1_3.dll
  Delete $INSTDIR/locales/
  Delete $INSTDIR/resources/
  Delete $INSTDIR\Parrot.VisualElementsManifest.xml
  Delete $INSTDIR\icon-${environment}.ico

  Delete $DESKTOP\Parrot.lnk
  Delete $SMPROGRAMS\Parrot.lnk
  Delete $SMSTARTUP\Parrot.lnk
  Delete $QUICKLAUNCH\Parrot.lnk

  Delete $INSTDIR

  DeleteRegKey HKCU "${REG_PATH}"

SectionEnd
