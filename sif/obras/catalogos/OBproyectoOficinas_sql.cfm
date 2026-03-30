
<cfif IsDefined("form.Cambio")>

	
		<cf_dbtimestamp datasource="#session.dsn#"
				table="OBproyectoOficinas"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
				field1="Ecodigo"
				type1="integer"
				value1="#form.Ecodigo#"
				field2="OBPid"
				type2="numeric"
				value2="#session.obras.OBPid#"
				field3="Ocodigo"
				type3="integer"
				value3="#form.Ocodigo#"
		>
	

	<cfquery datasource="#session.dsn#">
		update OBproyectoOficinas
		set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and OBPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.obras.OBPid#" null="#Len(session.obras.OBPid) Is 0#">
		  and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#" null="#Len(form.Ocodigo) Is 0#">
	</cfquery>

	<cflocation url="OBproyecto.cfm?Ecodigo=#URLEncodedFormat(form.Ecodigo)#&OBPid=#URLEncodedFormat(session.obras.OBPid)#&Ocodigo=#URLEncodedFormat(form.Ocodigo)#">

<cfelseif IsDefined("form.Baja")>

	<cfquery datasource="#session.dsn#">
		delete from OBproyectoOficinas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and OBPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.obras.OBPid#" null="#Len(session.obras.OBPid) Is 0#">
		  and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#" null="#Len(form.Ocodigo) Is 0#">
		
	</cfquery>

	<cflocation url="OBproyecto.cfm">
<cfelseif IsDefined("form.Alta")>	

	<cfquery datasource="#session.dsn#">
		insert into OBproyectoOficinas (
			
			Ecodigo,
			OBPid,
			Ocodigo,
			BMUsucodigo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.obras.OBPid#" null="#Len(session.obras.OBPid) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#" null="#Len(form.Ocodigo) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>

	<cflocation url="OBproyecto.cfm">
<cfelseif IsDefined("form.Nuevo")>
	<cflocation url="OBproyecto.cfm">
<cfelse>
	<!--- Tratar como form.nuevo --->
	<cflocation url="OBproyecto.cfm">
</cfif>



