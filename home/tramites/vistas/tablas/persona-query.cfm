<cfparam name="url.index" default="" type="string">
<cfparam name="url.identificacion_persona" default="" type="string">
<cfparam name="url.id_tipoident" default="" type="string">
<cfoutput>
<cfif len(url.identificacion_persona) and len(url.id_tipoident)>
	<cfquery name="rs" datasource="#session.tramites.dsn#">
		select id_persona, identificacion_persona,apellido1||' ' ||apellido2||' '||nombre as nombre_persona
		from TPPersona
		where identificacion_persona = <cfqueryparam cfsqltype="cf_sql_char" value="#url.identificacion_persona#">
		and id_tipoident = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id_tipoident#">
	</cfquery>
	<script language="javascript" type="text/javascript">
		<cfif rs.recordcount>
			parent.#url.gname#.value = "#rs.id_persona#";
			parent.identificacion_persona#url.index#.value = "#rs.identificacion_persona#";
			parent.nombre_persona#url.index#.value = "#rs.nombre_persona#";
		<cfelse>
			window.parent.funcLimpiarPersona#url.index#();
		</cfif>
	</script>
<cfelse>
	<script language="javascript" type="text/javascript">
		window.parent.funcLimpiarPersona#url.index#();
	</script>
</cfif>
</cfoutput>