<!--- Archivo que guarda el archivo xls --->
<cfset tempfile_cfm = GetTempDirectory() & "Rep_" & session.usuario >
<cfset nombre= "Reporte" & url.name & ".xls" >

<cfheader name="Content-Disposition" value="attachment; filename=#nombre#">
<cfcontent type="application/vnd.ms-excel" file="#tempfile_cfm#" deletefile="yes">

