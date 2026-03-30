<cfquery name="rsMoneda" datasource="#Session.DSN#">
		select Mcodigo, Mnombre
		from Monedas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
<cfif isdefined("form.QPCid") and len(trim(form.QPCid))>
	<cfquery name="rsDato" datasource="#session.dsn#">
		select 
			a.QPCMontoVariable,
			a.QPCtipo,
			a.QPCid,        
			a.QPCcodigo,
			a.QPCdescripcion, 
			a.QPCmonto,       
			a.Ecodigo,         
			a.BMFecha,      
			a.BMUsucodigo, 
			a.ts_rversion,
			a.Mcodigo,
			a.QPCCuentaContable
			from QPCausa a   
			inner join Monedas c on
		  		a.Mcodigo = c.Mcodigo 
				and a.Ecodigo = c.Ecodigo
			where a.Ecodigo = #session.Ecodigo# 
			and  a.QPCid=#form.QPCid#
			order by a.QPCcodigo desc
	</cfquery>	
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfoutput>
	<form action="QPassRubros_SQL.cfm" method="post" name="form1" onClick="javascript: habilitarValidacion(); "> 
       <table cellpadding="2" cellspacing="0" align="center" border="0" width="100%">
			<tr>
                 <td align="right" width="40%"><strong>C&oacute;digo:</strong></td>
                 <td align="left">
					<input type="text" name="QPCcodigo" maxlength="20" size="20" id="QPCcodigo" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsDato.QPCcodigo)#</cfif>"/>
				</td>
			</tr>	
			
			<tr>
				<td align="right"><strong>Descripci&oacute;n:</strong></td>
				<td>
                   <cfset LvarDescripcion = "">
				<cfif modo NEQ 'ALTA'>
                  	<cfset LvarDescripcion = trim(rsDato.QPCdescripcion)>
                 </cfif>
					<textarea  
					cols="45" 
					rows="3" 
					name="QPCdescripcion" 
					maxlength="255" 
					tabindex="1">#LvarDescripcion#</textarea>
                 </td>
			</tr>	
			
				<td align="right" nowrap="nowrap"><strong>Moneda:</strong></td>
				<td>
					<select name="Mcodigo" id="Mcodigo" tabindex="1">
						<cfloop query="rsMoneda"> 
							<option value="#rsMoneda.Mcodigo#"<cfif modo NEQ 'ALTA' and rsDato.Mcodigo EQ rsMoneda.Mcodigo> selected</cfif>>#rsMoneda.Mnombre#</option>
						</cfloop>
					</select>
				</td>			
			</tr>
				<td align="right"><strong>Monto:</strong></td>
				<td>
				<cfset QPCmonto = 0 >
					<cfif modo neq 'ALTA'>
						<cfset QPCmonto = LSNumberFormat(abs(rsDato.QPCmonto),"0.00") >
					</cfif>
				<cf_inputNumber name="QPCmonto" value="#QPCmonto#" enteros="8" decimales="2">
			</tr>	
			
			<tr>
				<td align="right"><strong>Cuenta Contable:</strong></td>
				<td>
					<input type="text" name="QPCCuentaContable" maxlength="100" size="40" id="QPCCuentaContable" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsDato.QPCCuentaContable)#</cfif>"/>
                 </td>
			</tr>	
			
			<tr>
				<td align="right"><strong>Tipo:</strong></td>
				<td>
					<select name="QPCtipo" tabindex="1">
						<option value="4" <cfif modo NEQ 'ALTA' and rsDato.QPCtipo eq 4>selected="selected"</cfif>>Venta</option>
						<option value="3" <cfif modo NEQ 'ALTA' and rsDato.QPCtipo eq 3>selected="selected"</cfif>>Membresia</option>
						<option value="5" <cfif modo NEQ 'ALTA' and rsDato.QPCtipo eq 5>selected="selected"</cfif>>Recarga</option>
						<option value="2" <cfif modo NEQ 'ALTA' and rsDato.QPCtipo eq 2>selected="selected"</cfif>>Movimiento (Uso)</option>
						<option value="1" <cfif modo NEQ 'ALTA' and rsDato.QPCtipo eq 1>selected="selected"</cfif>>Otros Cargos</option>
					</select>
                 </td>
			</tr>			
			
			<tr>
				<td align="right"></td>
				<td colspan="2">
				<input 	type="checkbox" name="QPCMontoVariable" id="QPCMontoVariable" tabindex="1"
				<cfif modo NEQ "ALTA" and #rsDato.QPCMontoVariable# EQ 1> checked </cfif> >&nbsp;<strong><label for="QPCMontoVariable">Monto Variable</label></strong>
			</tr>
			
			<tr><td>&nbsp;</td></tr>
			<tr valign="baseline"> 
				<td colspan="6" align="center" nowrap>
					<cfif isdefined("form.QPvtaConvid")> 
						<cf_botones modo="#modo#" tabindex="1" include="Regresar">
					<cfelse>
						<cf_botones modo="#modo#" tabindex="1" include="Regresar">
					</cfif> 
				</td>
			</tr>
			<tr>
				<td colspan="3">
					<cfset ts = "">
					<cfif modo NEQ "ALTA">
						<input type="hidden" name="QPCid" value="#rsDato.QPCid#">
					</cfif>
				</td>
			</tr>
		</table>
	</form>
</cfoutput>

<cfoutput>
	<cf_qforms form="form1">
<script language="javascript1" type="text/javascript">
		objForm.QPCcodigo.description = "Código";
		objForm.QPCdescripcion.description = "Descripción";
		objForm.QPCmonto.description = "Monto";
		
	function deshabilitarValidacion(){
		objForm.QPCcodigo.required = false;
		objForm.QPCdescripcion.required = false;
		objForm.QPCmonto.required = false;
	}		
	
	function habilitarValidacion() 
	{
	if (!btnSelected('Nuevo',document.form1) && !btnSelected('Baja',document.form1) && !btnSelected('Regresar',document.form1) ){
		objForm.QPCcodigo.required = true;
		objForm.QPCdescripcion.required = true;
		objForm.QPCmonto.required = true;
		}
	}
	
	function funcRegresar()
	{
		deshabilitarValidacion();
		document.form1.action = 'QPassRubros.cfm';
		return true;
	}
	
</script>
</cfoutput>
