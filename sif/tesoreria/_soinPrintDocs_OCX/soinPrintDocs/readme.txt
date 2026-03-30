INSTALACION AUTOMÁTICA:
1) Asegurarse de que no esté corriendo ninguna instancia de Internet Explorer (esto se ve en el Task Manager, o bien, ctrl.+Alt+Del botón Task Manager) o bien inicializar Windows
2) Correr el setup.exe
3) Si durante la instalación se requiere reiniciar la máquina, y repetir la instalación,
   pero en la segunda instalación vuelve a requerir reinicar la máquina, posiblemente
   los componentes de VisualBasic son demasiados viejos para la Versión de Windows en 
   ejecución.  Por esta razón, se debe instalar únicamente con el componente de 
   instalación VB6STKIT.DLL
   a) Borre el archivo SETUP.LST
   b) Renombre el archivo SETUP_1.LST a SETUP.LST
4) Volver a Interner Explorer y probar imprimir cheques
   Si al probar da error de que no está instalado o no se pudo instalar
   es neceario la instalación manual

INSTALACION MANUAL:
1) Asegurarse de que no esté corriendo ninguna instancia de Internet Explorer (esto se ve en el Task Manager, o bien, ctrl.+Alt+Del botón Task Manager) o bien inicializar Windows
2) Entrar al c:\windows\system32\regedt32.exe
3) Buscar F3: hilera a buscar "soinPrintDocs"
4) Borrar todas las siguientes llaves de Registro (Keys) y volver a punto anterior, hasta no encontrar más "soinPrintDocs"
	{classid} es algo como {0FC59281-AD36-4FA6-A1AE-525E7D740FCC}

	My Computer\HKEY_CALSSES_ROOT\CLSID\{classid}\...
	My Computer\HKEY_CALSSES_ROOT\soinPrintDocs.clsFormatoImg
	My Computer\HKEY_CALSSES_ROOT\soinPrintDocs.clsFormatoLin
	My Computer\HKEY_CALSSES_ROOT\soinPrintDocs.clsFormatoPos
	My Computer\HKEY_CALSSES_ROOT\soinPrintDocs.cntImpresora
	My Computer\HKEY_CALSSES_ROOT\TypeLib\{classid}\...
	My Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Classes\CLSID\{classid}\...
	My Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Classes\soinPrintDocs.clsFormatoImg
	My Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Classes\soinPrintDocs.clsFormatoLin
	My Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Classes\soinPrintDocs.clsFormatoPos
	My Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Classes\soinPrintDocs.cntImpresora
	My Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Classes\TypeLib\{classid}\...
	My Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\soinPrintDocs.ocx
	My Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\STxxUNST #xx\...

5) Salir de regedt32
6) Copiar el soinPrintDocs.ocx que viene en el zip en cualquier directorio de la maquina local, puede ser "c:\windows\system32",o bien, "C:\Program Files\soinPrintDocs", o bien, cualquier directorio permanente.
7) Registar el ActiveX con:
	c:\windows\system32\regsvr32 "<DRIVE>:\<PATH>\soinPrintDocs.ocx"


OPCIONES DE SEGURIDAD DE Internet Explorer:
   Tools -> Internet Options -> Security -> Custom Level:

   ActiveX controls and plug-ins:
      Allow scriptlets                         ENABLED
      Automatic Prompting for ActiveX controls ENABLED
      Binary and script behaviors              ENABLED
      Initialize and script ActiveX controls 
            not marked as safe                 ENABLED
      Run ActiveX Controls and plug-inns       ENABLED
      Script ActiveX controls marked as safe   
            for scripting                      ENABLED
 
   Scripting:
      Active scripting                         ENABLED

