; NSIS installer script for openmqtt

!include "MUI.nsh"

; For environment variable code
!include "WinMessages.nsh"
!define env_hklm 'HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"'

Name "OpenMqtt"
!define VERSION 0.0.1
OutFile "openmqtt-${VERSION}-install-cygwin.exe"

InstallDir "$PROGRAMFILES\openmqtt"

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
	File "..\src\openmqtt.exe"
	File "..\ChangeLog.txt"
	File "..\openmqtt.conf"
	File "..\readme.txt"
	File "..\readme-windows.txt"
	File "C:\pthreads\Pre-built.2\dll\x86\pthreadVC2.dll"
	File "C:\OpenSSL-Win32\libeay32.dll"
	File "C:\OpenSSL-Win32\ssleay32.dll"
	File "..\LICENSE.txt"
	
	WriteUninstaller "$INSTDIR\Uninstall.exe"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenMqtt" "DisplayName" "OpenMqtt"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenMqtt" "UninstallString" "$\"$INSTDIR\Uninstall.exe$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenMqtt" "QuietUninstallString" "$\"$INSTDIR\Uninstall.exe$\" /S"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenMqtt" "HelpLink" "http://openmqtts.moranit.com/"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenMqtt" "URLInfoAbout" "http://openmqtts.moranit.com/"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenMqtt" "DisplayVersion" "${VERSION}"
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenMqtt" "NoModify" "1"
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenMqtt" "NoRepair" "1"

	WriteRegExpandStr ${env_hklm} OPENMQTT_DIR $INSTDIR
	SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
SectionEnd

Section "Service" SecService
	ExecWait '"$INSTDIR\openmqtt.exe" install'
SectionEnd

Section "Uninstall"
	ExecWait '"$INSTDIR\openmqtt.exe" uninstall'
	Delete "$INSTDIR\cygwin1.dll"
	Delete "$INSTDIR\cyggcc_s-1.dll"
	Delete "$INSTDIR\cygcrypto-1.0.0.dll"
	Delete "$INSTDIR\cygssl-1.0.0.dll"
	Delete "$INSTDIR\cygz.dll"
	Delete "$INSTDIR\openmqtt.exe"
	Delete "$INSTDIR\ChangeLog.txt"
	Delete "$INSTDIR\openmqtt.conf"
	Delete "$INSTDIR\readme.txt"
	Delete "$INSTDIR\readme-windows.txt"
	Delete "$INSTDIR\pthreadVC2.dll"
	Delete "$INSTDIR\libeay32.dll"
	Delete "$INSTDIR\ssleay32.dll"
	Delete "$INSTDIR\LICENSE.txt"
	
	Delete "$INSTDIR\Uninstall.exe"
	RMDir "$INSTDIR"
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenMqtt"

	DeleteRegValue ${env_hklm} OPENMQTT_DIR
	SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
SectionEnd

LangString DESC_SecInstall ${LANG_ENGLISH} "The main installation."
LangString DESC_SecService ${LANG_ENGLISH} "Install OpenMqtt as a Windows service?"
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	!insertmacro MUI_DESCRIPTION_TEXT ${SecInstall} $(DESC_SecInstall)
	!insertmacro MUI_DESCRIPTION_TEXT ${SecService} $(DESC_SecService)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

