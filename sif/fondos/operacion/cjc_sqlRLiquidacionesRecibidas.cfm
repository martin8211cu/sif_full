<!--- 
Archivo:  cjc_sqlRLiquidacionesRecibidas.cfm
Creado:   Randall Colomer en el ICE.   
Fecha:    09 Noviembre 2006.              
--->
<cfinclude template="cjc_sqlRLiquidacionesRecibidasContent.cfm">
<cfset tempfilepintado_cfm = GetTempDirectory() & "Rep_" & session.usuario & "Pintado">

<cfcontent file="#tempfilepintado_cfm#" type="text/html" deletefile="yes">
