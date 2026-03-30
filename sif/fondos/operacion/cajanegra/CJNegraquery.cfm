<cfif isdefined("url.DATO") and url.DATO NEQ "">
	<cfquery name="rs" datasource="#session.Fondos.dsn#">
		set nocount on	
		exec sp_Next_tipo @CGM1IM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.CGM1IM)#">
		, @nivel  = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.NIVEL#">
		<cfif len(trim(url.StringNivel)) gt 0>
			, @CGM1CD = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#trim(url.StringNivel)#">
		<cfelse>
			, @CGM1CD =null
		</cfif> 	
		set nocount off	
	</cfquery>
	<cfquery name="rs1" datasource="#session.Fondos.dsn#">
		SELECT CG12ID,CG12DE FROM CGM012 		
		WHERE CG11ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#rs.CG11ID#">
		AND   CG12ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.DATO#">
	</cfquery>
	<script language="JavaScript">
		window.parent.document.form1.CG13ID_<cfoutput>#url.NIVEL#</cfoutput>.value = '<cfoutput>#trim(rs1.CG12ID)#</cfoutput>';
		window.parent.document.form1.DESCUENTA.value = '<cfoutput>#trim(rs1.CG12DE)#</cfoutput>';
		window.parent.validaceldas(<cfoutput>#url.NIVEL#</cfoutput>);		
	</script>
</cfif>

