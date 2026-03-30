<cflock scope="application" timeout="5" throwontimeout="no">
	<cfquery datasource="#session.Fondos.dsn#"  name="sqlproc">
				
		exec cj_CierreMesCJ_aut

	</cfquery>
</cflock>
