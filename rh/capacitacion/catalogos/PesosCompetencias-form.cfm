<cfset modo = "ALTA">
<cfif isdefined("form.RHPCid") and len(trim(form.RHPCid))>
	<cfset modo = "CAMBIO">
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="#session.DSN#">
		select  RHPCid, RHPCcodigo, RHPCdescripcion, RHPCpeso, ts_rversion
		from RHPesosCompetencia
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and  RHPCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPCid#">
	</cfquery>
</cfif>

<cfoutput>
<script language="javascript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
<form name="formCalificaE" action="PesosCompetencias-sql.cfm" method="post">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td align="right"><strong>#LB_Codigo#:&nbsp;</strong></td>
			<td><input type="text" name="RHPCcodigo" size="10" maxlength="10" readonly value="<cfif modo neq 'ALTA'>#trim(data.RHPCcodigo)#</cfif>" onfocus="this.select();" tabindex="1"></td>
		</tr>
		<tr>
			<td align="right"><strong>#LB_Descripcion#:&nbsp;</strong></td>
			<td><input type="text" name="RHPCdescripcion" size="50" maxlength="200" value="<cfif modo neq 'ALTA'>#trim(data.RHPCdescripcion)#</cfif>" onfocus="this.select();" tabindex="1"></td>
		</tr>
		<tr>
			<td align="right"><strong>#LB_Peso#:&nbsp;</strong></td>
			<td>
				<cfset Lvar_Peso = ''>
				<cfif isdefined('data.RHPCpeso')><cfset Lvar_Peso = data.RHPCpeso></cfif>
				<cf_monto name="RHPCpeso" size="10" decimales="0" value="#Lvar_Peso#"  tabindex="1">%
			</td>
		</tr>
		<!--- Botones --->
		<tr><td colspan="2"><cf_botones modo="#modo#" exclude="ALTA,NUEVO,BAJA" tabindex="1"></td></tr>
	</table>

	<cfif modo neq 'ALTA'>
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		<input type="hidden" name="RHPCid" value="#trim(data.RHPCid)#">
	</cfif>
</form>
</cfoutput>
<cf_qforms objForm="objForm" form='formCalificaE'>
	<cf_qformsrequiredfield args="RHPCcodigo, #MSG_Codigo#">
	<cf_qformsrequiredfield args="RHPCpeso, #LB_Peso#">
	<cf_qformsrequiredfield args="RHPCdescripcion, #MSG_Descripcion#">
</cf_qforms>

