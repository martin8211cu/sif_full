<cfparam name="form.periodicidad" default="0">
<cfparam name="form.costo" default="">
<cfset form.costo = Replace(form.costo,',','','all')>

<cfif IsDefined("form.Cambio")>
	
		<cf_dbtimestamp datasource="#session.dsn#"
				table="sa_vigencia"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
			
				field1="id_programa"
				type1="numeric"
				value1="#form.id_programa#"
			
				field2="id_vigencia"
				type2="numeric"
				value2="#form.id_vigencia#"
			
		>
	
	<cfquery datasource="#session.dsn#">
		update sa_vigencia
		set fecha_desde = <cfif Len(form.fecha_desde)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fecha_desde)#"><cfelse>null</cfif>
		, fecha_hasta = <cfif Len(form.fecha_hasta)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fecha_hasta)#"><cfelse>null</cfif>
		
		, costo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.costo#" null="#Len(form.costo) Is 0#">
		, moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.moneda#">
		, periodicidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodicidad#" null="#Len(form.periodicidad) Is 0#">
		, tipo_periodo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo_periodo#" null="#Len(form.tipo_periodo) Is 0#">
		, beneficios = <cfqueryparam cfsqltype="cf_sql_char" value="#form.beneficios#" null="#Len(form.beneficios) Is 0#">
		
		, cantidad_carnes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cantidad_carnes#" null="#Len(form.cantidad_carnes) Is 0#">
		, generar_carnes = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.generar_carnes')#">
		, total_entradas = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.total_entradas#" null="#Len(form.total_entradas) Is 0#">
		, nombre_vigencia = <cfqueryparam cfsqltype="cf_sql_char" value="#form.nombre_vigencia#" null="#Len(form.nombre_vigencia) Is 0#">
		
		, CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		, Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		
		, BMfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where id_programa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_programa#" null="#Len(form.id_programa) Is 0#">
		  and id_vigencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_vigencia#" null="#Len(form.id_vigencia) Is 0#">
	</cfquery>

	<cflocation url="sa_vigencia.cfm?id_programa=#URLEncodedFormat(form.id_programa)#&id_vigencia=#URLEncodedFormat(form.id_vigencia)#">

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete sa_vigencia
		where id_programa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_programa#" null="#Len(form.id_programa) Is 0#">  and id_vigencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_vigencia#" null="#Len(form.id_vigencia) Is 0#">
	</cfquery>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into sa_vigencia (
			
			id_programa,
			fecha_desde,
			fecha_hasta,
			
			costo, moneda,
			periodicidad,
			tipo_periodo,
			beneficios,
			
			cantidad_carnes,
			generar_carnes,
			total_entradas,
			nombre_vigencia,
			
			entradas_asignadas,
			CEcodigo,
			Ecodigo,
			
			BMfechamod,
			BMUsucodigo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_programa#" null="#Len(form.id_programa) Is 0#">,
			<cfif Len(form.fecha_desde)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fecha_desde)#"><cfelse>null</cfif>,
			<cfif Len(form.fecha_hasta)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fecha_hasta)#"><cfelse>null</cfif>,
			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.costo#" null="#Len(form.costo) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.moneda#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodicidad#" null="#Len(form.periodicidad) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo_periodo#" null="#Len(form.tipo_periodo) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.beneficios#" null="#Len(form.beneficios) Is 0#">,
			
			<cfqueryparam cfsqltype="cf_sql_integer" value="#form.cantidad_carnes#" null="#Len(form.cantidad_carnes) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.generar_carnes')#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#form.total_entradas#" null="#Len(form.total_entradas) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.nombre_vigencia#" null="#Len(form.nombre_vigencia) Is 0#">,
			
			0,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="sa_vigencia.cfm?id_programa=#URLEncodedFormat(form.id_programa)#">


