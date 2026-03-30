<cfparam name="modoreq" default="ALTA">
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
		insert TPRequisitoDoc( id_requisito, 
							  nombre_archivo, 
							  tipo_mime, 
							  resumen, 
							  contenido, 
							  BMUsucodigo, 
							  BMfechamod)

		values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#nombre_archivo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#tipo_mime#">,
				<cfif isdefined("form.resumen") and len(trim(form.resumen))><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.resumen#"><cfelse>null</cfif>,
				<cfqueryparam cfsqltype="cf_sql_blob" value="#contenido#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> )
	</cfquery>
	<cfset modoreq="ALTA">
<cfelseif isdefined("form.Eliminar")>
	<cfquery datasource="#session.tramites.dsn#" name="abcprereq">
		delete TPRequisitoDoc
		where id_doc  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_doc#">
	</cfquery>			
	<cfset modoreq="ALTA">
</cfif>


<form action="TP_requisitos.cfm" method="post" name="sql">
	<input name="modoreq" type="hidden" value="<cfif isdefined("modoreq")><cfoutput>#modoreq#</cfoutput></cfif>">
	<input name="modo" type="hidden" value="CAMBIO">
	<cfif modoreq neq 'ALTA'>
		<input name="id_doc" type="hidden" value="<cfif isdefined("Form.id_doc")><cfoutput>#Form.id_doc#</cfoutput></cfif>">
	</cfif>
	<input name="id_requisito" type="hidden" value="<cfif isdefined("Form.id_requisito")><cfoutput>#Form.id_requisito#</cfoutput></cfif>">
	<input type="hidden" name="tab" value="5">
</form>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
