<cfset modo = "ALTA">
<cfif isdefined("form.CVid") and len(trim(form.CVid))>
	<cfset modo = "CAMBIO">
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="#session.DSN#">
		select  CVid, CVCodigo, CVDescripcion, CVTipo, Ecodigo, ts_rversion
   		from ECalendarioVentas
		where CVid = #form.CVid# 
	</cfquery>
</cfif>

<form style="margin:0;" name="form1" action="CalendariosVenta-sql.cfm" method="post">
	<!---Codigo--->
	<table align="center" width="100%" cellpadding="2" cellspacing="0" border="0" >
		<tr>
			<td nowrap align="right"><strong>Código: </strong></td>
			<td nowrap>
				<input type="text" name="CVcodigo" size="8" maxlength="15" value="<cfif modo neq 'ALTA'><cfoutput>#data.CVCodigo#</cfoutput></cfif>" onfocus="this.select();">
			</td>
		</tr>
	<!---Descripción--->	
		<tr>
			<td nowrap align="right"><strong>Descripción: </strong></td>
			<td nowrap>
				<input type="text" name="CVdescripcion" size="50" maxlength="80" value="<cfif modo neq 'ALTA'><cfoutput>#data.CVDescripcion#</cfoutput></cfif>" onfocus="this.select();">
			</td>
		</tr>
    <!---Tipo de Calendario--->	
		<tr>
			<td nowrap align="right"><strong>Tipo: </strong></td>
			<td nowrap>
				<select name="CVtipo" tabindex="4">
					<option value="D" <cfif modo neq 'ALTA' and data.CVTipo eq 'D'>selected</cfif>>
						Aplica para Descuentos
					</option>
					<option value="R" <cfif modo neq 'ALTA' and data.CVTipo eq 'R'>selected</cfif>>
						Aplica para Recargos
					</option>
				</select>
			</td>
		</tr>    
	<!--- Portles de Botones --->
		<tr><td nowrap colspan="2">&nbsp;</td></tr>
		<tr>
			<td nowrap colspan="2" align="center">
				<cfinclude template="/sif/portlets/pBotones.cfm">
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
	<cfif modo neq 'ALTA'>
		<cfoutput>
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
			<input type="hidden" name="CVid" value="#data.CVid#">
		</cfoutput>
	</cfif>
</form>
<cfif modo neq 'ALTA'>
	<cfinclude template="PeriodosCalendario.cfm">
</cfif>

<cf_qforms>
	<cf_qformsRequiredField name="CVcodigo" description="Codigo">
	<cf_qformsRequiredField name="CVdescripcion" description="Descripción">
</cf_qforms>

