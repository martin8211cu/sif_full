<cfif isdefined("url.ESnumero") and len(trim(url.ESnumero))>
	<cfquery name="rs" datasource="#session.DSN#">
		select a.ESidsolicitud,a.ESnumero,a.ESobservacion		
		from ESolicitudCompraCM a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.ESnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ESnumero#">
	</cfquery>

	<script language="javascript1.2" type="text/javascript">
		<cfif rs.recordCount gt 0>
			<cfoutput>
			window.parent.document.form1.ESidsolicitud.value = #rs.ESidsolicitud#;
			window.parent.document.form1.ESnumero.value = #rs.ESnumero#;
			window.parent.document.form1.ESobservacion.value = '#JSStringFormat(rs.ESobservacion)#';
			</cfoutput>
		<cfelse>
			window.parent.document.form1.ESidsolicitud.value = '';
			window.parent.document.form1.ESnumero.value = '';
			window.parent.document.form1.ESobservacion.value = '';
		</cfif>
	</script>
</cfif>
