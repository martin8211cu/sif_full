<cfparam name="modoreq2" default="ALTA">
<cfif isdefined("form.Agregar")>

	<cffile action="Upload"  
			filefield="form.ruta" 
			destination="#gettempdirectory()#" 
			nameConflict="overwrite"> 
	<cffile action="readbinary" 
			file="#gettempdirectory()##cffile.ClientFileName#.#cffile.ClientFileExt#" 
			variable="contenido">
	<cffile action="delete" 
			file="#gettempdirectory()##cffile.ClientFileName#.#cffile.ClientFileExt#" >	
	
	<cfset nombre_archivo = cffile.serverfile>
	<cfset tipo_mime      = cffile.contenttype>
	<!--- <cfdump var="#cffile#"> --->
	<cfquery datasource="#session.tramites.dsn#">
		insert TPTramiteDoc( id_tramite, 
							  nombre_archivo, 
							  tipo_mime, 
							  resumen, 
							  contenido, 
							  BMUsucodigo, 
							  BMfechamod)

		values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#nombre_archivo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#tipo_mime#">,
				<cfif isdefined("form.resumen") and len(trim(form.resumen))><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.resumen#"><cfelse>null</cfif>,
				<cfqueryparam cfsqltype="cf_sql_blob" value="#contenido#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> )
	</cfquery>
	<cfset modoreq2="ALTA">
<cfelseif isdefined("form.Eliminar")>
	<cfquery datasource="#session.tramites.dsn#" name="abcprereq">
		delete TPTramiteDoc
		where id_doc  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_doc#">
	</cfquery>			
	<cfset modoreq2="ALTA">
</cfif>


<form action="tramites.cfm" method="post" name="sql">
	<input name="modoreq2" type="hidden" value="<cfif isdefined("modoreq2")><cfoutput>#modoreq2#</cfoutput></cfif>">
	<input name="modo" type="hidden" value="CAMBIO">
	<cfif modoreq2 neq 'ALTA'>
		<input name="id_doc" type="hidden" value="<cfif isdefined("Form.id_doc")><cfoutput>#Form.id_doc#</cfoutput></cfif>">
	</cfif>
	<input name="id_tramite" type="hidden" value="<cfif isdefined("Form.id_tramite")><cfoutput>#Form.id_tramite#</cfoutput></cfif>">
	<input type="hidden" name="tab" value="4">
</form>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
