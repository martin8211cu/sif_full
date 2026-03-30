<cfif isdefined("url.RCNid")>
	<script language="javascript1.2" type="text/javascript">
		window.parent.document.form1.existe.value = 'N';
	</script>
	<cfquery name="rsExiste" datasource="#session.DSN#">
		select 1
		from BMovimientoIncidencias
		where RCNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
	</cfquery>
	<cfif rsExiste.recordcount gt 0>
		<script language="javascript1.2" type="text/javascript">
			window.parent.document.form1.existe.value = 'S';
		</script>
	</cfif>
</cfif>