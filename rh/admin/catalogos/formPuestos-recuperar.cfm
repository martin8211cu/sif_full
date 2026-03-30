<cfif isdefined("url.dato") and Len(Trim(url.dato))>
	<cfquery name="rs" datasource="#Session.DSN#">
		select RHDDVvalor
		from RHDDatosVariables
		where RHDDVlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.dato#">
	</cfquery>
	<script language="JavaScript">
		<cfoutput>
		if (window.parent.fillValue) window.parent.fillValue('#JSStringFormat(rs.RHDDVvalor)#');
		</cfoutput>
	</script>
</cfif>