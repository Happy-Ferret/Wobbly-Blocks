!define MUI_ICON "icon.ico"
!define INSTALLATIONNAME “Wobbly-Blocks”

!include "MUI.nsh"

!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_LICENSE "License.rtf"
!insertmacro MUI_PAGE_INSTFILES

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"


Name “Wobbly-Blocks”
OutFile "./Setup.exe"
InstallDir "$PROGRAMFILES\${INSTALLATIONNAME}"

Section ""
 
    # Uses the UserInfo Plugin to check user properties.
    UserInfo::getAccountType
    
    # Adds result to stack
    Pop $0
 
    # Compares the result with the string "Admin" to check whether the user has admin privileges required to install this application.
    # If admin, jump three lines.
    StrCmp $0 "Admin" +3
 
    # If Admin = False, display the following popup and abort installation process.
    MessageBox MB_OK "This setup requires administrative privileges. Aborting installation."
    Return

 SetOutPath $INSTDIR
 
 #Add game build directory to path.
 File /r "..\build\*"

 #Create Uninstaller.
 WriteUninstaller "$INSTDIR\uninstall.exe"
 
 #Add registry keys.
 WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${INSTALLATIONNAME}" "DisplayName" "Happy-Ferret's Wobbly-Blocks” 
 WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${INSTALLATIONNAME}" "UninstallString" '"$INSTDIR\uninstall.exe"'
 WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${INSTALLATIONNAME}" "NoModify" 1
 WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${INSTALLATIONNAME}" "NoRepair" 1
SectionEnd


Section "Symbolic links"
 #Define symbolic links as global.
 SetShellVarContext all

 CreateDirectory "$SMPROGRAMS\${INSTALLATIONNAME}"
 CreateShortCut "$SMPROGRAMS\${INSTALLATIONNAME}\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
 CreateShortCut "$SMPROGRAMS\${INSTALLATIONNAME}\Wobbly-Blocks.lnk" "$INSTDIR\Wobbly-Blocks.exe" "" "$INSTDIR\Wobbly-Blocks.exe" 0
 CreateShortCut "$DESKTOP\Wobbly-Blocks.lnk" "$INSTDIR\Wobbly-Blocks.exe" "" "$INSTDIR\Wobbly-Blocks.exe" 0 
SectionEnd

Section "Uninstall"
 #Define as global, in order to remove all files inside all user directories.
 SetShellVarContext all
 
 #Define contents of uinstall.exe.
 DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${INSTALLATIONNAME}"
 RMDir /r "$INSTDIR"
 RMDir /r "$SMPROGRAMS\${INSTALLATIONNAME}"
 RMDir "$SMPROGRAMS\${INSTALLATIONNAME}"
 Delete "$DESKTOP\Wobbly-Blocks.lnk"
SectionEnd