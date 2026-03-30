<!--- <cftry>
<cfquery name="rs" datasource="#session.Conta.dsn#">
	select CGM1IM from CGM001
 	where CGM1IM  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mid(url.CUENTA,1,4)#">
	<!--- where CGM1IM  = '#mid(url.CUENTA,1,4)#'  --->
	<cfif len(mid(url.CUENTA,5,len(CUENTA))) gt 0>
 		and   CGM1CD  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mid(url.CUENTA,5,len(CUENTA))#">
		<!--- and   CGM1CD  ='#mid(url.CUENTA,5,len(CUENTA))#' --->
	<cfelse>
	    and   CGM1CD  is null
    </cfif>
</cfquery>
<cfcatch type="any">
	<script language="JavaScript">
		if(<cfoutput>#url.ORIGEN#</cfoutput> == 1)
			window.parent.document.form1.DESDE.value = '';
		else
			window.parent.document.form1.HASTA.value = '';
		alert("debe selecionar una cuenta valida *")
		window.parent.limpiarCeldas()
	</script>
	<cfabort>
</cfcatch> 
</cftry>
 ---><script language="JavaScript">
	<!--- <cfif rs.recordcount gt 0>	 --->
		if(<cfoutput>#url.ORIGEN#</cfoutput> == 1)
			window.parent.document.form1.DESDE.value = '<cfoutput>#url.CUENTA#</cfoutput>';
		else
			window.parent.document.form1.HASTA.value = '<cfoutput>#url.CUENTA#</cfoutput>';
	<!--- <cfelse> --->
		/*if(<cfoutput>#url.ORIGEN#</cfoutput> == 1)
			window.parent.document.form1.DESDE.value = '';
		else
			window.parent.document.form1.HASTA.value = '';
		alert("debe selecionar una cuenta valida ")
		window.parent.limpiarCeldas()*/
	<!--- </cfif> --->
</script>
