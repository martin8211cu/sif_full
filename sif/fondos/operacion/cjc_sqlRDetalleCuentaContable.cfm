<!--- 
Archivo:  cjc_sqlRDetalleCuentaContable.cfm
Creado:   Randall Colomer en el ICE.   
Fecha:    20  Octubre 2006.              
--->
<cfinclude template="cjc_sqlRDetalleCuentaContableContent.cfm">
<cfset tempfilepintado_cfm = GetTempDirectory() & "Rep_" & session.usuario & "Pintado">

<cfcontent file="#tempfilepintado_cfm#" type="text/html" deletefile="yes">
