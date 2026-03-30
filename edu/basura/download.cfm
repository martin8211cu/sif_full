<cfquery name="rsDownload" datasource="educativo">
	select convert(varchar, id_documento) as codigo,
		   contenido,
		   isnull(tipo_contenidodoc,'text/html; charset = ISO-8859-1') as tipo_contenido,
		   isnull(nom_archivo, 'untitled') as nom_archivo
	from MADocumento
	where id_documento = 62
</cfquery>

<cfheader 
	name="Content-Disposition" 
	value="filename=prueba.jpg">
<cffile action="write" 
	nameconflict="overwrite" 
	file="#gettempdirectory()#58.gif" 
	output="#toBinary(rsDownload.contenido)#">
<cfcontent type="application/download" 
	file="#gettempdirectory()#58.gif" 
	deleteFile="yes">

