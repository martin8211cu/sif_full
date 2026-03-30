<!--- 
Archivo:  cjc_sqlRConsultaUsuarios.cfm
Creado:   Randall Colomer en el ICE.   
Fecha:    18  Octubre 2006.              
--->
<cfinclude template="cjc_sqlRConsultaUsuariosContent.cfm">
<cfset tempfilepintado_cfm = GetTempDirectory() & "Rep_" & session.usuario & "Pintado">

<cfcontent file="#tempfilepintado_cfm#" type="text/html" deletefile="yes">
