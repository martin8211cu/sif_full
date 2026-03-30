<cfif isdefined('url.ANHCid') and len(trim(url.ANHCid)) gt 0>
	<cfset form.ANHCid =  url.ANHCid>
</cfif>
<cfif isdefined('url.ANHid') and len(trim(url.ANHid)) gt 0>
	<cfset form.ANHid = url.ANHid>
</cfif>
<cfquery name="rsVariable" datasource="#session.dsn#">
select ACta.ANHCid ,ACta.ANHid ,ACta.ANHCcodigo ,ACta.ANHCdescripcion 
	from ANhomologacionCta ACta
 where ACta.ANHCid =<cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#form.ANHCid#">
</cfquery>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr class="tituloAlterno" valign="top"> 
		<td><font size="2">Cuentas Financieras homologadas</font></td> 
	</tr>
	<tr><td>
			<cfinclude template="ANhomologacionFmts-form.cfm">
	</td></tr>
	<td><font size="2">Máscaras de Cuenta Financiera homologadas</font></td>    
	<tr><td>
			<cfinclude template="ANhomologacionFmts-lista.cfm">
	</td></tr>
</table>