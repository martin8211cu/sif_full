<cfif IsDefined("form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="TESotrasEntradasSalidas"
				redirect="OtrasES.cfm"
				timestamp="#form.ts_rversion#"
				field1="TESOid"
				type1="numeric"
				value1="#form.TESOid#"
		>
	
	<cfset vartesomonto = replace(form.tesomonto,",","","all")>
	<cfset vartesotipocambio = replace(form.tesotipocambio,",","","all")>	
	<cfif vartesotipocambio EQ 0>
		<cfset vartesotipocambio = 1>
	</cfif>
	
	<cfquery datasource="#session.dsn#">
		update TESotrasEntradasSalidas
		set   TESOtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tesotipo#" null="#Len(form.TESOtipo) Is 0#">
			, TESOdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tesodescripcion#" null="#Len(form.TESOdescripcion) Is 0#">
			, Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
			, TESOmonto = <cfqueryparam cfsqltype="cf_sql_money4" value="#vartesomonto#">
			, TESOtipoCambio = <cfqueryparam cfsqltype="cf_sql_money4" value="#vartesotipocambio#">
			, TESOrecursividad = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#form.tesorecursividad#">
			<cfif form.tesorecursividad eq 0>
				, TESOrecursividadN = 0
			<cfelse>
				, TESOrecursividadN = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.tesorecursividadN#">			
			</cfif>
			, TESOfechaDesde = <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(LSParsedatetime(form.TESOfechaDesde),'yyyymmdd')#">
			<cfif form.TESOfechaHasta EQ "" OR form.tesorecursividad eq 0>
				<cfset form.TESOfechaHasta = form.TESOfechaDesde>
			</cfif>
			, TESOfechaHasta = <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(LSParsedatetime(form.TESOfechaHasta),'yyyymmdd')#">
		<cfif isdefined("form.chk_activo")>
			, TESOactivo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="1">
		<cfelse>
			, TESOactivo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="0">
		</cfif>
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where TESOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOid#" null="#Len(form.TESOid) Is 0#">
	      and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	</cfquery>

	<cflocation url="OtrasES.cfm?TESOid=#URLEncodedFormat(form.TESOid)#">

<cfelseif IsDefined("form.Baja")>
	
	<cfquery datasource="#session.dsn#">
		delete from TESotrasEntradasSalidas
		where TESOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOid#" null="#Len(form.TESOid) Is 0#">
	</cfquery>
	
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>

	<cfif isdefined("form.chk_activo")>
		<cfset valor=1>
	<cfelse>
		<cfset valor=0>
	</cfif>
	
	<cfquery name="rsTESid" datasource="#Session.DSN#">
		select TESid
		from TESempresas 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	</cfquery>	
	
	<cfoutput query="rsTESid">
		<cfset tesid = rsTESid.TESid>
	</cfoutput>
	
	<!--- Verifica si la recursividad es n o para una vez --->
	<cfif tesorecursividad eq 0>
		<cfset tesorecursividadN = "">	
	</cfif>
	
	<cfset vartesomonto = replace(form.tesomonto,",","","all")>
	<cfset vartesotipocambio = replace(form.tesotipocambio,",","","all")>
	<cfif vartesotipocambio EQ 0>
		<cfset vartesotipocambio = 1>
	</cfif>
	
	<cfquery datasource="#session.dsn#">
		insert into TESotrasEntradasSalidas (
			TESid,
			Ecodigo,
			TESOtipo,
			TESOdescripcion,
			Mcodigo,
			TESOmonto,
			TESOtipoCambio,
			TESOrecursividad,
			TESOrecursividadN,
			TESOfechaDesde,
			TESOfechaHasta,
			TESOactivo,
			BMUsucodigo
			)
		values (					
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#tesid#" null="#Len(tesid) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.tesotipo#" null="#Len(form.tesotipo) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tesodescripcion#" null="#Len(form.tesodescripcion) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_money4" value="#vartesomonto#">,
			<cfqueryparam cfsqltype="cf_sql_money4" value="#vartesotipocambio#">,
			<cfqueryparam cfsqltype="cf_sql_tinyint" value="#form.tesorecursividad#">,
			<cfif form.tesorecursividad eq 0>
				0,
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#tesorecursividadN#">,
			</cfif>
			<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(LSParsedatetime(form.TESOfechaDesde),'yyyymmdd')#">,
			<cfif form.TESOfechaHasta EQ "">
				<cfset form.TESOfechaHasta = form.TESOfechaDesde>
			</cfif>
			<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(LSParsedatetime(form.TESOfechaHasta),'yyyymmdd')#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#valor#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
			
	</cfquery>

<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="OtrasES.cfm">