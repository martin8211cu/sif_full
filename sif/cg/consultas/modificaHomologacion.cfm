<cfif isdefined('url.ANHCid1') and len(trim(url.ANHCid1)) gt 0>
	<cfset form.ANHCid1 =  url.ANHCid1>
</cfif>
<cfif isdefined('url.ANHCid2') and len(trim(url.ANHCid2)) gt 0>
	<cfset form.ANHCid2 =  url.ANHCid2>
</cfif>
<cfif isdefined('url.ANHid') and len(trim(url.ANHid)) gt 0>
	<cfset form.ANHid = url.ANHid>
</cfif>

<cfquery name="rsVariable" datasource="#session.dsn#">
select ACta.ANHCid ,ACta.ANHid ,ACta.ANHCcodigo ,ACta.ANHCdescripcion 
	from ANhomologacionCta ACta
 where ACta.ANHid =<cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#form.ANHid#">
</cfquery>
<cfset cont = 1>
<cfloop query="rsVariable">
	<cfif cont eq 1>
		<cfset form.ANHCid1 = rsVariable.ANHCid>
        <cfset codigo1 = rsVariable.ANHCcodigo>
        <cfset descrip1 = rsVariable.ANHCdescripcion>
   		<cfset cont =2>
	<cfelse>
    	<cfset form.ANHCid2 = rsVariable.ANHCid>
        <cfset codigo2 = rsVariable.ANHCcodigo>
        <cfset descrip2 = rsVariable.ANHCdescripcion>
    </cfif>
</cfloop>
<cfset url.num  = 1>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>	
    	<td>
        	<strong><font size="2"> <cfoutput>#descrip1#</cfoutput></font></strong>
		</td>
    </tr>
    	<tr class="tituloAlterno" valign="top"> 
		<td><font size="2">Cuentas Financieras homologadas</font></td> 
        <td><font size="2">Máscaras de Cuenta Financiera homologadas</font></td>    
	</tr>
	<tr>
    	<td  valign="top">
			<cfinclude template="ANhomologacionFmts-form.cfm">
		</td>
		<td  valign="top">
			<cfinclude template="ANhomologacionFmts-lista.cfm">
		</td>
    </tr>
</table>
<cfset mododet1="">
<hr />
<cfset url.num  =2>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>	
    	<td>
        	<strong><font size="2"><cfoutput>#descrip2#</cfoutput></font></strong>
		</td>
    </tr>
    	<tr class="tituloAlterno" valign="top"> 
		<td><font size="2">Cuentas Financieras homologadas</font></td> 
        <td><font size="2">Máscaras de Cuenta Financiera homologadas</font></td>    
	</tr>
	<tr>
    	<td  valign="top">
			<cfinclude template="ANhomologacionFmts-form.cfm">
		</td>
		<td  valign="top">
			<cfinclude template="ANhomologacionFmts-lista.cfm">
		</td>
    </tr>
</table>