
<cfif IsDefined("form.Cambio")>

	
		<cf_dbtimestamp datasource="#session.dsn#"
				table="OBproyectoReglas"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
				field1="OBPRid"
				type1="numeric"
				value1="#form.OBPRid#"
		>
	

	<cfquery datasource="#session.dsn#">
		update OBproyectoReglas
		
		set Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		, OBPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.obras.OBPid#">
		, CFformatoRegla = <cfqueryparam cfsqltype="cf_sql_char" value="#fnCFformatoRegla()#">
		
		, Ocodigo = <cfif isdefined("form.Ocodigo") and Len(Trim(form.Ocodigo))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#"><cfelse>null</cfif>
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where OBPRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBPRid#" null="#Len(form.OBPRid) Is 0#">
	</cfquery>

	<cflocation url="OBproyecto.cfm?OBPRid=#URLEncodedFormat(form.OBPRid)#">

<cfelseif IsDefined("form.Baja")>

	<cfquery datasource="#session.dsn#">
		delete from OBproyectoReglas
		where OBPRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBPRid#" null="#Len(form.OBPRid) Is 0#">
		
	</cfquery>

	<cflocation url="OBproyecto.cfm">
<cfelseif IsDefined("form.Alta")>	

	<cfset form.OBPRid = replace(form.OBPRid,",","-","ALL")>
	<cfquery datasource="#session.dsn#">
		insert into OBproyectoReglas (
			
			Ecodigo,
			OBPid,
			CFformatoRegla,
			
			Ocodigo,
			BMUsucodigo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.obras.OBPid#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#fnCFformatoRegla()#">,
			
			<cfif isdefined("form.Ocodigo") and Len(Trim(form.Ocodigo))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>

	<cflocation url="OBproyecto.cfm">
<cfelseif IsDefined("form.Nuevo")>
	<cflocation url="OBproyecto.cfm">
<cfelse>
	<!--- Tratar como form.nuevo --->
	<cflocation url="OBproyecto.cfm">
</cfif>
<cffunction name="fnCFformatoRegla" returntype="string">
	<cfreturn replace(form.CFformatoRegla,",","-","ALL")>
</cffunction>


