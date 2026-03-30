
<cfset modoCalifExp = "ALTA">
<cfif isdefined("form.RHEEEid") and len(trim(form.RHEEEid))>
	<cfset modoCalifExp = "CAMBIO">
</cfif>
<cfif modoCalifExp neq 'ALTA'>
	<cfquery name="data" datasource="#session.DSN#">	
		select  a.RHEEEid,coalesce(b.RHPcodigoext,b.RHPcodigo) as RHPcodigoext,b.RHPdescpuesto,a.RHEEEannos,ltrim(rtrim(a.RHPcodigo)) as RHPcodigo,a.ts_rversion
		from RHExpExternaEmpleado a
		inner join RHPuestos b
			on ltrim(rtrim(a.RHPcodigo)) = ltrim(rtrim(b.RHPcodigo))
			and a.Ecodigo = b.Ecodigo
		where a.Ecodigo = #session.Ecodigo#
	    and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		and a.RHEEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEEid#">
	</cfquery>
</cfif>
<cfoutput>
<form name="formCalifExp" action="CalificaExperiencia-sql.cfm" method="post">
	<input type="hidden" name="DEid" value="<cfif isdefined("form.DEid") and len(trim(form.DEid))>#form.DEid#</cfif>">
	<input name="sel" type="hidden" value="3">
	<input type="hidden" name="o" value="3">		
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr><td colspan="100%">&nbsp;</td></tr>
		<tr>
			<td align="right" nowrap>
				<strong>
					<cf_translate key="LB_Puesto">Puesto</cf_translate>:&nbsp;
				</strong>
			</td>
			<td >
				<cfif modoCalifExp eq 'ALTA'>
				  <cf_rhpuesto tabindex="1" form="formCalifExp">
				  <cfelse>
				  #data.RHPcodigoext#-#data.RHPdescpuesto#
				  <input type="hidden" name="RHPcodigo" value="#data.RHPcodigo#">
				</cfif>
			</td>
		</tr>
		<tr>
			<td width="25%" align="right" nowrap="nowrap"><strong><cf_translate  key="LB_annos_de_servicio">Años de servicio</cf_translate>:&nbsp;</strong></td>
			<td width="75%">
				<cfset Lvar_Annos = 0>
				<cfif modoCalifExp NEQ 'ALTA'><cfset Lvar_Annos = data.RHEEEannos></cfif>
				<cf_monto name="RHEEEannos" size="5" decimales="2" value="#Lvar_Annos#">
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<cf_botones modo="#modoCalifExp#" ></td>
			</tr>
	</table>
	<cfif modoCalifExp neq 'ALTA'>
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		<input type="hidden" name="RHEEEid" value="#data.RHEEEid#">
		<input type="hidden" name="tab" value="3">
	</cfif>

</form>
<cf_qforms objForm="objFormCE" form='formCalifExp'>
	<cf_qformsrequiredfield args="RHPcodigo, #LB_Puesto#">
	<cf_qformsrequiredfield args="RHEEEannos, #LB_Annos_de_Servicio2#">
</cf_qforms>
</cfoutput>
	
	