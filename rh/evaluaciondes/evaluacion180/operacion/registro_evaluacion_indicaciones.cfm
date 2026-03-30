<cfif isdefined("form.REid") and len(trim(form.REid))>
	<cfset Form.modo='CAMBIO'>
</cfif>
<cfif modo neq 'ALTA'>
	<cfquery name="rsForm" datasource="#session.dsn#"><!--- RHPcodigo,  --->
		select 	REid, 
				REestado,
				REindicaciones,
				ts_rversion
		from RHRegistroEvaluacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
	</cfquery>
</cfif>
<cfoutput>
<form action="registro_evaluacion_indicadores-sql.cfm" method="post" name="form1">
	<input type="hidden" name="SEL" value="">
	<input type="hidden" name="params" value="">
	<input type="hidden" name="Estado" value="<cfif isdefined("Form.Estado") and Form.Estado EQ 1>#Form.Estado#<cfelse>0</cfif>">
	<input type="hidden" name="REid" value="#rsForm.REid#">
	<table width="95%" align="center"  border="0" cellspacing="2" cellpadding="0">
		<tr>
			<td width="16%" height="20">&nbsp;</td>
		</tr>
		<tr>
			<td valign="top" align="right"><strong><cf_translate key="LB_Indicaciones">Indicaciones</cf_translate>:&nbsp;</strong></td>
			<td width="84%">
				<cfif isdefined('rsForm.REindicaciones') and len(trim(rsForm.REindicaciones)) gt 0>
					<cf_sifeditorhtml name="REindicaciones" value="#Trim(rsForm.REindicaciones)#" tabindex="1"> 
				<cfelse>
					<cf_sifeditorhtml name="REindicaciones" tabindex="1"> 
				</cfif>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center">
				<cf_botones values="Anterior,Modificar,Siguiente" names="Anterior,Cambio,Siguiente" nbspbefore="4" nbspafter="4" tabindex="2">
			</td>
		</tr>
		<cfif modo neq 'ALTA' and isdefined("rsForm.ts_rversion")>
			<cfset ts = "">
			<cfinvoke 	component="sif.Componentes.DButils"
						method="toTimeStamp"
						returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
		</cfif>
	</table>
</form>
<script type="text/javascript" language="javascript1.2">
	function funcSiguiente(){
		document.form1.SEL.value = "3";
		document.form1.action = "registro_evaluacion.cfm";
		return true;
	}
	function funcAnterior(){
		document.form1.SEL.value = '1';
		document.form1.action = "registro_evaluacion.cfm";
		return true;
	}
</script>
</cfoutput>
