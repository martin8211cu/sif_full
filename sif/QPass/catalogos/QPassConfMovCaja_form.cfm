	<cfquery name="rsCausas" datasource="#session.dsn#">
		select c.QPCid, c.QPCcodigo, c.QPCdescripcion, m.Miso4217 as Moneda, c.QPCmonto as Monto
        from QPCausa c
        	inner join Monedas m
            on m.Mcodigo = c.Mcodigo
		where c.Ecodigo = #session.Ecodigo#
        order by c.QPCcodigo
	</cfquery>

<cfif isdefined("form.QPMovid") and len(trim(form.QPMovid))>

	<cfquery name="rsDato" datasource="#session.dsn#">
		select 
			a.QPMovid,   
			a.QPMovCodigo,
			a.QPMovDescripcion,
			a.Ecodigo,                   
			a.BMFecha,                
			a.BMUsucodigo   
			from QPMovimiento a
			where a.Ecodigo = #session.Ecodigo#
				and a.QPMovid = #form.QPMovid#
	</cfquery>	
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfoutput>
	<fieldset>
		<form action="QPassConfMovCaja_SQL.cfm" method="post" name="form1" onClick="javascript: habilitarValidacion(); "> 
			<table width="80%" align="center" border="0" >
				<tr>
					<td valign="top" align="right"><strong>Código:</strong>&nbsp;</td>
			      	<td valign="top">
						<input type="text" name="QPMovCodigo" maxlength="101" size="20" id="QPMovCodigo" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsDato.QPMovCodigo)#</cfif>"/>
					</td>
				</tr>
				<tr>
					<td align="right"><strong>Descripci&oacute;n:</strong></td>
					<td colspan="2">
                        <textarea  
                            cols="45" 
                            rows="3" 
                            name="QPMovDescripcion" 
                            maxlength="255" 
                            tabindex="1"><cfif modo NEQ 'ALTA'>#trim(rsDato.QPMovDescripcion)#</cfif></textarea>
                	</td>
				</tr>	
				<tr>
					<td colspan="4" align="center">
						<cfset control = 0>
						<fieldset style="width:85%">
						<legend>Causas</legend>
						<table cellspacing="2">
						<cfset LvarCausa = "">
						<cfloop query="rsCausas">
							<cfif isdefined ('form.QPMovid') and len(trim(form.QPMovid))>
								<cfquery name="rsDoc" datasource="#session.dsn#">
									select count(1) as cantidad 
									from QPCausaxMovimiento a
									where a.Ecodigo = #session.Ecodigo#
									and a.QPCid= #rsCausas.QPCid#
									and a.QPMovid = #form.QPMovid#
								</cfquery>
							</cfif>
							<cfif control eq 0>
								<tr>
							</cfif>
								<td>
									<input type="checkbox" name="QPCid" tabindex="1" value="#rsCausas.QPCid#" <cfif modo NEQ "ALTA" and #rsDoc.cantidad# gt 0>checked</cfif>>
								</td>
								<td>#rsCausas.QPCcodigo#&nbsp;&nbsp;&nbsp;</td>
								<td>#rsCausas.QPCdescripcion#&nbsp;&nbsp;&nbsp;</td>
								<td align="right">#numberformat(Monto, "999,999,999.00")#</td>
								<td align="right">#Moneda#</td>
							<cfif control eq 1>
								</tr>
								<cfset control = 0>
							<cfelse>
								<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
								<cfset control = 1>
							</cfif>
						</cfloop>
						<cfif control eq 1>
							</tr>
						</cfif>
						</table>
						</fieldset>	
				<tr><td colspan="3"></td></tr>
			
				<tr valign="baseline"> 
					<td colspan="3" align="center" nowrap>
						<cfif isdefined("form.QPMovid") and isdefined("form.QPMovCodigo")> 
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
							<input type="hidden" name="QPMovid" value="#rsDato.QPMovid#" >
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
		objForm.QPMovCodigo.description = "Código del Movimiento";
		objForm.QPMovDescripcion.description = "Descripción";
	function habilitarValidacion() 
	{
		objForm.QPMovCodigo.required = true;
		objForm.QPMovDescripcion.required = true;
	}
</script>
</cfoutput>
