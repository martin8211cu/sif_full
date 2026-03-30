<cftry>
<cfquery name="rs" datasource="#session.Conta.dsn#">
		 set nocount on 
		 exec  cg_ValidaCuenta
		 @CGE5COD  	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.CGE5COD)#"> ,
         @CGM1IM 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.CGM1IM)#"> ,	
         @CGM1CD 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.CGM1CD)#"> 
         set nocount off 	
</cfquery>
<cfcatch type="any">
	<table width="100%" border="0">
		<tr>
			<td align="center" nowrap  bgcolor="#FFFF00"><strong><cfoutput>#trim(cfcatch.Detail)#</cfoutput></strong></td>
		</tr>            
	</table>
	<cfabort>
</cfcatch>
</cftry>	
<cfif isdefined("rs")  and rs.recordcount gt 0>
	<table width="100%" border="0">
		<tr>
			<td align="center" nowrap bgcolor="#FFFF00"><strong><cfoutput>#trim(rs.resultado)#</cfoutput></strong></td>
		</tr>            
	</table>
</cfif>
