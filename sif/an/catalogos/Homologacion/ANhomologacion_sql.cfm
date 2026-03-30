<cfif isdefined ('form.Alta')>
	<cftransaction>
		<cfquery name="inHomo" datasource="#session.dsn#">
			insert into ANhomologacion(
				Ecodigo, 
				ANHcodigo,
				ANHdescripcion,
				BMUsucodigo 
			)
			values(
				#session.Ecodigo#,
				'#form.cod#',
				'#form.tipo#',
				#session.Usucodigo#
			)
			<cf_dbidentity1 datasource="#session.DSN#" name="inHomo">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="inHomo" returnvariable="LvarANHid">
	</cftransaction>
	<cflocation url="ANhomologacion.cfm?ANHid=#LvarANHid#">
</cfif>

<cfif isdefined ('form.Baja')>	
	<cfquery name="delHomo" datasource="#session.dsn#">	
		delete from ANhomologacion where ANHid=#form.ANHid#
	</cfquery>
	<cflocation url="ANhomologacion.cfm">
</cfif>


<cfif isdefined ('form.Nuevo')>
	<cflocation url="ANhomologacion.cfm">
</cfif>

<cfif isdefined ('form.Cambio')>
		<cfquery name="inHomo" datasource="#session.dsn#">
			update ANhomologacion set
				ANHcodigo='#form.cod#',
				ANHdescripcion='#form.tipo#'
			where ANHid=#form.ANHid#
			and Ecodigo=#session.Ecodigo#
		</cfquery>
	<cflocation url="ANhomologacion.cfm?ANHid=#form.ANHid#">
</cfif>

<cfif isdefined ('form.btnHomologar')>
	<cflocation url="ANhomologacionCta.cfm?ANHid=#form.ANHid#">
</cfif>
