<cfif isdefined("Session.Edu.Usucodigo") and Len(Trim(Session.Edu.Usucodigo)) NEQ 0>
	<cfquery name="rsDownload" datasource="#Session.Edu.DSN#">
		select id_documento as codigo,
			   contenido,
			   isnull(tipo_contenidodoc,'text/html; charset = ISO-8859-1') as tipo_contenido,
			   isnull(nom_archivo, 'untitled') as nom_archivo,
			   tipo_contenido as tipo
		from MADocumento
		where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cod#">
	</cfquery>

	<cfheader name="Content-Disposition" value="filename=#rsDownload.nom_archivo#">
	<cffile action="write" nameconflict="overwrite" file="#gettempdirectory()##Session.Ulocalizacion##rsDownload.codigo#.dat" output="#toBinary(rsDownload.contenido)#">
	<cfif rsDownload.tipo EQ "D">
		<cfcontent type="application/download" file="#gettempdirectory()##Session.Ulocalizacion##rsDownload.codigo#.dat" deleteFile="yes">
	<cfelse>
		<cfcontent type="#rsDownload.tipo_contenido#" file="#gettempdirectory()##Session.Ulocalizacion##rsDownload.codigo#.dat" deleteFile="yes">
	</cfif>
</cfif>
