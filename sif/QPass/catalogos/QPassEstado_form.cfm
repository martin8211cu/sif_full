<cfif isdefined("form.QPidEstado") and len(trim(form.QPidEstado))>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select 
			a.QPidEstado,
			a.Ecodigo,
			a.QPEdescripcion,
			a.QPEdisponibleVenta,
			a.QEPvalorDefault,
			a.ts_rversion 
				from QPassEstado a
			where a.Ecodigo = #session.Ecodigo# 
			and  a.QPidEstado=#form.QPidEstado#
	</cfquery>	
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfoutput>
	<fieldset>
	<legend><strong>Estado</strong>&nbsp;</legend>
		<form action="QPassEstado_SQL.cfm" method="post" name="form1" onClick="javascript: habilitarValidacion(); "> 
			<table width="80%" align="center" border="0" >
				<tr>
					<td align="right"><strong>Descripci&oacute;n:</strong></td>
					<td colspan="2">
					<input type="text" name="QPEdescripcion" maxlength="40" size="40" id="QPEdescripcion" tabindex="0" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsForm.QPEdescripcion)#</cfif>" />
				</tr>			
				<tr>
					<td align="right"></td>
					<td colspan="2">
					<input 	type="checkbox" name="QPEdisponibleVenta" tabindex="1"
					<cfif modo NEQ "ALTA" and #rsForm.QPEdisponibleVenta# EQ 1> checked </cfif> ><strong>Disponible en Venta</strong>
				</tr>	
				<tr>
					<td align="right"></td>
					<td colspan="2">
					<input 	type="checkbox" name="QEPvalorDefault" tabindex="1"
					<cfif modo NEQ "ALTA" and #rsForm.QEPvalorDefault# EQ 1> checked </cfif> ><strong>Valor por Omisi&oacute;n</strong>
				</tr>	
				<tr><td colspan="3"></td></tr>
				<tr valign="baseline"> 
					<td colspan="3" align="center" nowrap>
						<cfif isdefined("form.QPidEstado")> 
							<cf_botones modo="#modo#" tabindex="1">
						<cfelse>
							<cf_botones modo="#modo#" tabindex="1">
						</cfif> 
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<cfset ts = "">
						<cfif modo NEQ "ALTA">
							<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsForm.ts_rversion#" returnvariable="ts">        
							</cfinvoke>
							<input type="hidden" name="QPidEstado" value="#rsForm.QPidEstado#" >
							<input type="hidden" name="ts_rversion" value="#ts#" >
						</cfif>
							<input type="hidden" name="Pagina3" 
							value="
							<cfif isdefined("form.pagenum3") and form.pagenum3 NEQ "">
								#form.pagenum3#
							<cfelseif isdefined("url.PageNum_lista3") and url.PageNum_lista3 NEQ "">
								#url.PageNum_lista3#
							</cfif>">
					</td>
				</tr>
			</table>
		</form>
	</fieldset>
</cfoutput>

<cfoutput>
	<cf_qforms form="form1">
	<script language="javascript1" type="text/javascript">
		
			objForm.QPEdescripcion.description = "Descripción";
			
		function habilitarValidacion() 
		{
			objForm.QPEdescripcion.required = true;
		}
	</script>
</cfoutput>