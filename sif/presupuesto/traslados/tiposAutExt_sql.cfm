<cfif isdefined ('form.Alta')>
	<cftransaction>
		<cfquery name="inHomo" datasource="#session.dsn#">
			insert into CPtipoAutExterna(
				Ecodigo, 
				CPTAEcodigo,
				CPTAEdescripcion,
				BMUsucodigo 
			)
			values(
				#session.Ecodigo# ,
				'#form.CPTAEcodigo#',
				'#form.CPTAEdescripcion#',
				#session.Usucodigo#
			)
			<cf_dbidentity1 datasource="#session.DSN#" name="inHomo">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="inHomo" returnvariable="LvarCPTAEid">
	</cftransaction>
	<cflocation url="tiposAutExt.cfm">
</cfif>

<cfif isdefined ('form.Baja')>	
	<cfquery name="delHomo" datasource="#session.dsn#">	
		delete from CPtipoAutExterna where CPTAEid=#form.CPTAEid#
	</cfquery>
	<cflocation url="tiposAutExt.cfm">
</cfif>


<cfif isdefined ('form.Nuevo')>
	<cflocation url="tiposAutExt.cfm">
</cfif>

<cfif isdefined ('form.Cambio')>
		<cfquery name="inHomo" datasource="#session.dsn#">
			update CPtipoAutExterna set
				CPTAEcodigo='#form.CPTAEcodigo#',
				CPTAEdescripcion='#form.CPTAEdescripcion#'
			where CPTAEid=#form.CPTAEid#
			and Ecodigo=#session.Ecodigo# 
		</cfquery>
	<cflocation url="tiposAutExt.cfm?CPTAEid=#form.CPTAEid#">
</cfif>
