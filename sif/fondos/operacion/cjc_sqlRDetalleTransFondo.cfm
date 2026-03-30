<!--- 
Archivo:  cjc_sqlRDetalleTransFondo.cfm
Creado:   Randall Colomer en el ICE.   
Fecha:    26 Octubre 2006.              
--->
<cfset tempfilepintado_cfm = GetTempDirectory() & "Rep_" & session.usuario & "Pintado">

<cffile file="#tempfilepintado_cfm#" 
	action="write" 
	output="<!--- Generado #dateformat(now(),"DD/MM/YYYY")# #timeformat(now(),"HH:MM:SS")# --->" 
	nameconflict="overwrite">
<cfset contenidohtml = "">

<cfinclude template="cjc_sqlRDetalleTransFondoContent.cfm">

<cfcontent file="#tempfilepintado_cfm#" type="text/html" deletefile="yes">
