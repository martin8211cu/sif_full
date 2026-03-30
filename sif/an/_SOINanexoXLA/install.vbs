sbInstall

sub sbInstall()
  dim LvarShell
  dim LvarExcel
  dim LvarFSO
  dim LvarPrcEnv
  dim LvarWinVer
  dim LvarWinDir
  dim LvarSystem32

  set LvarFSO    = CreateObject("Scripting.FileSystemObject")
  set LvarShell  = CreateObject("WScript.Shell")
  LvarWinCrntVer = LvarShell.regread("HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\CurrentVersion")
  LvarCSDVersion = LvarShell.regread("HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\CSDVersion")
  set LvarPrcEnv = LvarShell.Environment("PROCESS")
  LvarWinDir	 = LvarPrcEnv("WINDIR")
  if instr(ucase(LvarPrcEnv("PATH")), ucase(LvarWinDir) & "\SYSWOW64") > 0 then
    msgbox "ERROR: soinAnexos.xla sólo se puede instalar sobre Windows de 32 bits"
    exit sub
  end if

  If LvarFSO.FolderExists(LvarWinDir + "\System32") Then
     LvarSystem32 = LvarWinDir + "\System32"
  elseIf LvarFSO.FolderExists(LvarWinDir + "\System") Then
     LvarSystem32 = LvarWinDir + "\System"
  else
    msgbox "No se encontro el directorio System32"
    exit sub
  end if

  If not LvarFSO.FileExists("soinAnexos.xla") Then
    msgbox "No ha descomprimido todos los archivos de instalación en un folder"
    exit sub
  end if

  on error resume next
  set LvarExcel = Nothing
  set LvarExcel = CreateObject("Excel.Application")
  if LvarExcel is Nothing then
    msgbox "ERROR: No se encontró Microsoft Excel instalado"
    exit sub
  end if

  if val(LvarExcel.version) >= 11 then
    LvarSOAPsetup	= "MSSOAPoffice2003.exe"
    LvarSOAPobject	= "MSOSOAP.SoapClient30"
  elseif LvarExcel.version = "10.0" then
    LvarSOAPsetup	= "MSSOAPofficeXP.exe"
    LvarSOAPobject	= "MSSOAP.SoapClient30"
  else
    msgbox "ERROR: soinAnexos.xla sólo se puede instalar sobre Excel XP o 2003 o superior"
    exit sub
  end if

  msgbox "Cierre todas las instancias de Excel (asegurese con el TaskManager que no haya ningun proceso Excel en background ejecutandose)"+chr(13)+"y presione <OK> para continuar"

  
  'Instala MSXML
  set LvarXML = nothing
  set LvarXML = CreateObject("MSXML2.DOMDocument.6.0")
  if LvarXML is Nothing OR not LvarFSO.FileExists(LvarSystem32 + "\msxml6.dll") then
	LvarShell.run "msxml6.msi", true
	msgbox "Final de la instalación de MSXML" + vbCR + "(<OK> para continuar...)"
	set LvarXML = nothing
	set LvarXML = CreateObject("MSXML2.DOMDocument.6.0")
	if LvarXML is Nothing then
		msgbox "No se instaló el MsXML6.msi"
		exit sub
	end if
  end if
  if left(LvarWinCrntVer,1) = "5" AND LvarCSDVersion = "Service Pack 2" then
	  LvarShell.run "msxml6-SP2.exe", true
	  msgbox "Final de la instalación de MSXML SP 2" + vbCR + "(<OK> para continuar...)"
  end if

  'Instala MSSOAP
  set LvarSOAP	= CreateObject(LvarSOAPobject)
  if LvarSOAP is Nothing then
	LvarShell.run LvarSOAPsetup, true
	msgbox "Final de la instalación de MSSOAP" + vbCR + "(<OK> para continuar...)"
	set LvarSOAP	= CreateObject(LvarSOAPobject)
	if LvarSOAP is Nothing then
		msgbox "No se instaló el " + LvarSOAPsetup
		exit sub
	end if
  end if

  'Instala zip32_231.dll
  LvarDLL = LvarSystem32 + "\zip32_231.dll"
  LvarFSO.CopyFile "zip32_231.dll", LvarDLL, true
  If not LvarFSO.FileExists(LvarDLL) Then
    msgbox "No se instaló el zip32_231.dll: debe copiarse en directorio System32"
    exit sub
  end if

  'Instala unzip32_54.dll
  LvarDLL = LvarSystem32 + "\unzip32_54.dll"
  LvarFSO.CopyFile "unzip32_54.dll", LvarDLL, true
  If not LvarFSO.FileExists(LvarDLL) Then
    msgbox "No se instaló el unzip32_54.dll: debe copiarse en directorio System32"
    exit sub
  end if

  on error goto 0
  AppInstall
end sub

Public Sub AppInstall()
  Dim LvarPath
  Dim LvarAI  
  Dim LvarFSO

  set LvarFSO = CreateObject("Scripting.FileSystemObject")
  
  On Error Resume Next
  set LvarExcel = CreateObject("Excel.Application")
  Set LvarAI = Nothing
  Set LvarAI = LvarExcel.AddIns("SOIN Anexos")

  If NOT LvarAI Is Nothing Then
    LvarPath = LvarAI.FullName
    LvarAI.Installed = False
  Else
    Set LvarWSN = CreateObject("WScript.Network")
    LvarUID = LvarWSN.UserName

    If LvarFSO.FolderExists("C:\Documents and Settings\" + LvarUID) Then
      LvarFSO.CreateFolder "C:\Documents and Settings\" + LvarUID + "\Application Data"
      LvarFSO.CreateFolder "C:\Documents and Settings\" + LvarUID + "\Application Data\Microsoft"
      LvarFSO.CreateFolder "C:\Documents and Settings\" + LvarUID + "\Application Data\Microsoft\AddIns"
      LvarPath = "C:\Documents and Settings\" + LvarUID + "\Application Data\Microsoft\AddIns"
    End If
    If NOT LvarFSO.FolderExists(LvarPath) And LvarFSO.FolderExists("C:\Programs Files") Then
      LvarFSO.CreateFolder "C:\Programs Files\SOIN"
      LvarPath = "C:\Programs Files\SOIN"
    End If
    If NOT LvarFSO.FolderExists(LvarPath) Then
      LvarFSO.CreateFolder "C:\SOIN"
      LvarPath = "C:\SOIN"
    End If
    If NOT LvarFSO.FolderExists(LvarPath) Then
      MsgBox "No se puede crear el directorio de instalación del AddIn SOIN Anexos"
      Exit Sub
    End If
    LvarPath = LvarPath + "\soinAnexos.xla"
  End If
  LvarExcel.quit
  set LvarExcel = nothing

  If LvarFSO.FileExists(LvarPath) Then
    LvarFSO.DeleteFile(LvarPath)
    If LvarFSO.FileExists(LvarPath) Then
      msgbox "No se pudo borrar el soinAnexos.xla: debe borrarse " + chr(13) + LvarPath
      exit sub
    end if
  end if

  On Error GoTo 0
  LvarFSO.CopyFile "soinAnexos.xla", LvarPath, true
  set LvarExcel = CreateObject("Excel.Application")
  LvarExcel.Workbooks.Add
  LvarExcel.AddIns.Add LvarPath
  LvarExcel.AddIns("SOIN Anexos").Installed = True
  LvarExcel.quit
  msgbox "Terminó Instalación SOINanexos"
End Sub
