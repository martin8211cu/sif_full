<cfquery name="rs" datasource="#session.Fondos.dsn#">
	set nocount on	
	select CTADES from CGM001 
	WHERE CGM1ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(url.CGM1ID)#">
	set nocount off	
</cfquery>
<script language="JavaScript">
	window.parent.document.form1.DESCUENTA.value = '<cfoutput>#trim(rs.CTADES)#</cfoutput>';
</script>


