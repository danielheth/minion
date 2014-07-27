; NSIS installer script for minion

!include "MUI.nsh"

; For environment variable code
!include "WinMessages.nsh"
!define env_hklm 'HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"'

Name "Minion"
!define VERSION 0.0.1
OutFile "minion-${VERSION}-install-cygwin.exe"

InstallDir "$PROGRAMFILES\minion"

;--------------------------------
; Installer pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH


;--------------------------------
; Uninstaller pages
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

;--------------------------------
; Languages

!insertmacro MUI_LANGUAGE "English"

;--------------------------------
; Installer sections

Section "Files" SecInstall
	SectionIn RO
	SetOutPath "$INSTDIR"
	File "c:\cygwin\bin\cygwin1.dll"
	File "c:\cygwin\bin\cyggcc_s-1.dll"
	File "c:\cygwin\bin\cygcrypto-1.0.0.dll"
	File "c:\cygwin\bin\cygssl-1.0.0.dll"
	File "c:\cygwin\bin\cygz.dll"
	File "..\src\minion.exe"
	File "..\ChangeLog.txt"
	File "..\minion.conf"
	File "..\readme.txt"
	File "..\readme-windows.txt"
	File "C:\pthreads\Pre-built.2\dll\x86\pthreadVC2.dll"
	File "C:\OpenSSL-Win32\libeay32.dll"
	File "C:\OpenSSL-Win32\ssleay32.dll"
	File "..\LICENSE.txt"
	
	WriteUninstaller "$INSTDIR\Uninstall.exe"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Minion" "DisplayName" "Minion"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Minion" "UninstallString" "$\"$INSTDIR\Uninstall.exe$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Minion" "QuietUninstallString" "$\"$INSTDIR\Uninstall.exe$\" /S"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Minion" "HelpLink" "http://minions.moranit.com/"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Minion" "URLInfoAbout" "http://minions.moranit.com/"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Minion" "DisplayVersion" "${VERSION}"
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Minion" "NoModify" "1"
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Minion" "NoRepair" "1"

	WriteRegExpandStr ${env_hklm} MINION_DIR $INSTDIR
	SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
SectionEnd

Section "Service" SecService
	ExecWait '"$INSTDIR\minion.exe" install'
SectionEnd

Section "Uninstall"
	ExecWait '"$INSTDIR\minion.exe" uninstall'
	Delete "$INSTDIR\cygwin1.dll"
	Delete "$INSTDIR\cyggcc_s-1.dll"
	Delete "$INSTDIR\cygcrypto-1.0.0.dll"
	Delete "$INSTDIR\cygssl-1.0.0.dll"
	Delete "$INSTDIR\cygz.dll"
	Delete "$INSTDIR\minion.exe"
	Delete "$INSTDIR\ChangeLog.txt"
	Delete "$INSTDIR\minion.conf"
	Delete "$INSTDIR\readme.txt"
	Delete "$INSTDIR\readme-windows.txt"
	Delete "$INSTDIR\pthreadVC2.dll"
	Delete "$INSTDIR\libeay32.dll"
	Delete "$INSTDIR\ssleay32.dll"
	Delete "$INSTDIR\LICENSE.txt"
	
	Delete "$INSTDIR\Uninstall.exe"
	RMDir "$INSTDIR"
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Minion"

	DeleteRegValue ${env_hklm} MINION_DIR
	SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
SectionEnd

LangString DESC_SecInstall ${LANG_ENGLISH} "The main installation."
LangString DESC_SecService ${LANG_ENGLISH} "Install Minion as a Windows service?"
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	!insertmacro MUI_DESCRIPTION_TEXT ${SecInstall} $(DESC_SecInstall)
	!insertmacro MUI_DESCRIPTION_TEXT ${SecService} $(DESC_SecService)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

