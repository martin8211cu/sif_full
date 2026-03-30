<cfif isdefined("form.FTidEstado") and len(trim(form.FTidEstado))>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select 
			a.FTPvalorAutomatico,
			a.FTidEstado,
			a.Ecodigo,
			a.FTcodigo,
			a.FTdescripcion,
			a.FTfolio,
			a.ts_rversion 
				from EstadoFact a
			where a.Ecodigo = #session.Ecodigo# 
			and  a.FTidEstado=#form.FTidEstado#
	</cfquery>	
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfoutput>
	<fieldset>
	<legend><strong>Estado</strong>&nbsp;</legend>
		<form action="EstadoFac_SQL.cfm" method="post" name="form1" onClick="javascript: habilitarValidacion(); "> 
			<table width="80%" align="center" border="0" >
				<tr>
					<td align="right"><strong>C&oacute;digo:</strong></td>
					<td colspan="2">
                <input name="FTcodigo" <cfif modo NEQ "ALTA"> class="cajasinbordeb" readonly tabindex="-1" <cfelse> 
						tabindex="1"</cfif> type="text" value="<cfif modo NEQ "ALTA">#rsForm.FTcodigo#<cfelseif isdefined('rsForm.FTcodigo')>#rsForm.FTcodigo#</cfif>" 
						size="20" maxlength="20" />
		 	 	</tr>	
						
				<tr>
					<td align="right"><strong>Descripci&oacute;n:</strong></td>
					<td colspan="2">
					<input type="text" name="FTdescripcion" maxlength="40" size="40" id="FTdescripcion" tabindex="0" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsForm.FTdescripcion)#</cfif>" />
				</tr>			
				<tr>
					<td align="right"></td>
					<td colspan="2">
					<input 	type="checkbox" name="FTfolio" tabindex="1" 
					<cfif modo NEQ "ALTA" and #rsForm.FTfolio# EQ 1> checked </cfif><cfif modo NEQ "ALTA" and #rsForm.FTPvalorAutomatico# EQ 1> disabled="disabled"</cfif> ><strong>Genera Folio</strong>
				</tr>	
				<tr><td colspan="3"></td></tr>
				<tr valign="baseline"> 
					<td colspan="3" align="center" nowrap>
						<cfif isdefined("form.FTidEstado")> 
							<cfif #rsForm.FTPvalorAutomatico# EQ 1>
								<cf_botones modo="#modo#" exclude = "baja" tabindex="1">
							<cfelse>
								<cf_botones modo="#modo#" tabindex="1">
							</cfif>
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
							<input type="hidden" name="FTidEstado" value="#rsForm.FTidEstado#" >
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
			objForm.FTcodigo.description = "Descripción";
			objForm.FTdescripcion.description = "Descripción";
			
		function habilitarValidacion() 
		{
			objForm.FTcodigo.required = true;
			objForm.FTdescripcion.required = true;
		}
	</script>
</cfoutput>