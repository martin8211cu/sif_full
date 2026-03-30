<cfif isdefined("url.ESnumero") and len(trim(url.ESnumero))>
	<cfquery name="rs" datasource="#session.DSN#">
		select a.ESidsolicitud,a.ESnumero,a.ESobservacion		
		from ESolicitudCompraCM a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.ESnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ESnumero#">
	</cfquery>

	<script language="javascript1.2" type="text/javascript">
	<cfoutput>
		<cfif rs.recordCount gt 0>
			window.parent.document.form1.ESidsolicitud#url.index#.value = #rs.ESidsolicitud#;
			window.parent.document.form1.ESnumero#url.index#.value = #rs.ESnumero#;
			window.parent.document.form1.ESobservacion#url.index#.value = '#JSStringFormat(rs.ESobservacion)#';

		<cfelse>
			window.parent.document.form1.ESidsolicitud#url.index#.value = '';
			window.parent.document.form1.ESnumero#url.index#.value = '';
			window.parent.document.form1.ESobservacion#url.index#.value = '';
		</cfif>
	</cfoutput>
	</script>
</cfif>
