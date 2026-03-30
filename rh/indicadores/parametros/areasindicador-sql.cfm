<cfset vn_id = ''>
<cfif isdefined("form.ALTA")>
	<cftransaction>
		<cfquery name="inserta" datasource="#session.DSN#">
			insert into AreaIndEncabezado(CodArea, DescArea, Ecodigo, BMUsucodigo, BMfecha)
			values( <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CodArea#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DescArea#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
					)
			<cf_dbidentity1 datasource="#session.DSN#">		
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="inserta">
	</cftransaction>
	<cfset vn_id = inserta.identity>
<cfelseif isdefined("form.CAMBIO")>
	<cfquery datasource="#session.DSN#">
		update AreaIndEncabezado
		set CodArea = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CodArea#">,
			DescArea = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DescArea#">
		where AreaEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AreaEid#">
	</cfquery>
	<cfset vn_id = form.AreaEid>
<cfelseif isdefined("form.BAJA")>
	<cfquery datasource="#session.DSN#">
		delete from AreaIndDetalle
		where AreaEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AreaEid#">
	</cfquery>
	<cfquery datasource="#session.DSN#">
		delete from AreaIndEncabezado
		where AreaEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AreaEid#">
	</cfquery>
</cfif>
<cfoutput>
	<cfset params =''>
	<cfif len(trim(vn_id))>
		<cfset params = '?AreaEid=#vn_id#'>
	</cfif>
	<cflocation url="areasindicador.cfm#params#">
</cfoutput>