

<cfif IsDefined("form.Cambio")>
	
	
	
	
	
	
	
	
	
	
	
	
		
		
	
		<cf_dbtimestamp datasource="#session.dsn#"
				table="sa_programas"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
			
				field1="id_programa"
				type1="numeric"
				value1="#form.id_programa#"
			
		>
	
	<cfquery datasource="#session.dsn#">
		update sa_programas
		set nombre_programa = <cfqueryparam cfsqltype="cf_sql_char" value="#form.nombre_programa#" null="#Len(form.nombre_programa) Is 0#">
		, descripcion_programa = <cfqueryparam cfsqltype="cf_sql_char" value="#form.descripcion_programa#" null="#Len(form.descripcion_programa) Is 0#">
		, caracteristicas_programa = <cfqueryparam cfsqltype="cf_sql_char" value="#form.caracteristicas_programa#" null="#Len(form.caracteristicas_programa) Is 0#">
		, CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		, Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		, BMfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where id_programa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_programa#" null="#Len(form.id_programa) Is 0#">
	</cfquery>

	<cflocation url="sa_programas.cfm?id_programa=#URLEncodedFormat(form.id_programa)#">

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete sa_programas
		where id_programa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_programa#" null="#Len(form.id_programa) Is 0#">
	</cfquery>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into sa_programas (
			nombre_programa,
			descripcion_programa,
			caracteristicas_programa,
			CEcodigo,
			Ecodigo,
			BMfechamod,
			
			BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.nombre_programa#" null="#Len(form.nombre_programa) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.descripcion_programa#" null="#Len(form.descripcion_programa) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.caracteristicas_programa#" null="#Len(form.caracteristicas_programa) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="sa_programas.cfm">


