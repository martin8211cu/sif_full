<cfset modo = "ALTA">
<cfif isdefined("form.RHCEDid") and len(trim(form.RHCEDid))>
	<cfset modo = "CAMBIO">
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="#session.DSN#">
		select RHCEDid, RHCEDNivel, RHCEDPeso, ts_rversion
		from RHCalificaEduc
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHCEDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCEDid#">
	</cfquery>
</cfif>


<cfoutput>
<script language="javascript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
<form name="formCalificaE" action="CalificacionEducacion-sql.cfm" method="post">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td align="right"><strong>#LB_Nivel#:&nbsp;</strong></td>
			<td><input type="text" name="RHCEDNivel" size="50" maxlength="200" value="<cfif modo neq 'ALTA'>#trim(data.RHCEDNivel)#</cfif>" onfocus="this.select();" tabindex="1"></td>
		</tr>
		<tr>
			<td align="right"><strong>#LB_Peso#:&nbsp;</strong></td>
			<td>
				<cfset Lvar_LimInf = ''>
				<cfif isdefined('data.RHCEDPeso')><cfset Lvar_LimInf = data.RHCEDPeso></cfif>
				<cf_monto name="RHCEDPeso" size="10" decimales="0" value="#Lvar_LimInf#"  tabindex="1">
			</td>
		</tr>
		<!--- Botones --->
		<tr><td colspan="2"><cf_botones modo="#modo#"  tabindex="1"></td></tr>
	</table>

	<cfif modo neq 'ALTA'>
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		<input type="hidden" name="RHCEDid" value="#trim(data.RHCEDid)#">
	</cfif>
</form>
</cfoutput>
<cf_qforms objForm="objForm" form='formCalificaE'>
	<cf_qformsrequiredfield args="RHCEDNivel, #LB_Nivel#">
	<cf_qformsrequiredfield args="RHCEDPeso, #LB_Peso#">
</cf_qforms>
