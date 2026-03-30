<cfif isdefined("url.CPid") and len(trim(url.CPid)) and isdefined("url.DEid") and len(trim(url.DEid))>
	<cfquery name="data" datasource="#session.DSN#">
		select coalesce(RHCmontobase, 0) as RHCmontobase
		from RHComisiones
		where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#">
		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif data.recordCount gt 0>
		<script type="text/javascript" language="javascript1.2">
			<cfoutput>
				window.parent.document.form1.RHCmontobase.value = '#data.RHCmontobase#';
				window.parent.fm(window.parent.document.form1.RHCmontobase, 2);
			</cfoutput>
		</script>
	<cfelse>
		<script type="text/javascript" language="javascript1.2">
			window.parent.document.form1.RHCmontobase.value = '0.00';
		</script>
	</cfif>
<cfelse>
	<script type="text/javascript" language="javascript1.2">
		window.parent.document.form1.RHCmontobase.value = '0.00';
	</script>
</cfif>