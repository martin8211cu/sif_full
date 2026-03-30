<cfif isdefined("url.EOidorden") and len(trim(url.EOidorden))>
	<cfset form.EOidorden = url.EOidorden>
</cfif>
<cfquery name="rsDatosOC" datasource="#session.DSN#">
	select 	EOnumero, EOfecha, 
			case EOImpresion 	when 'I' then 'Impresa'
								when 'R' then 'Impresa'
								else 'Pendiente de impresión'								
			end as EstadoImpresion,
			EOImpresion
	from EOrdenCM
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
</cfquery>

<!---========== REALIZAR EL CAMBIO DEL ESTADO DE IMPRESION DE LA OC Y GUARDAR EN BITACORA ===========----->
<cfif isdefined("form.btn_aceptar")>	 
	 <cfquery datasource="#session.DSN#">
	 	update EOrdenCM
			set EOImpresion = 
				<cfif isdefined("form.EOImpresion") and len(trim(form.EOImpresion))>
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.EOImpresion#">
				<cfelse>
					null
				</cfif>
		where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
	 </cfquery>
	 <!---======= GUARDAR BITACORA ======----->
	<cfquery datasource="#session.DSN#">
	 	insert into BitEstadoIOC (Estanterior, 
								  Estactual, 
								  Fechacambio, 
								  BMUsucodigo, 
								  EOidorden,
								  EOnumero)
		values (<cfqueryparam cfsqltype="cf_sql_char" value="#form.EOImpresion_ant#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.EOImpresion#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero#">
				)
	 </cfquery>
	 <script type="text/javascript" language="javascript1.2">
	 	window.close();
	 </script>
</cfif>

<cfoutput>
	<form name="form1" action="" method="post">
		<input type="hidden" name="EOidorden" value="<cfif isdefined("form.EOidorden") and len(trim(form.EOidorden))>#form.EOidorden#</cfif>">
		<input type="hidden" name="EOnumero" value="<cfif isdefined("rsDatosOC") and rsDatosOC.RecordCount NEQ 0>#rsDatosOC.EOnumero#</cfif>">
		<input type="hidden" name="EOImpresion_ant" value="<cfif isdefined("rsDatosOC") and rsDatosOC.RecordCount NEQ 0>#rsDatosOC.EOImpresion#</cfif>">
		<table width="98%" cellpadding="0" cellspacing="0">
			<tr>
			  <td colspan="2" align="center"><strong style="color:##003366;font-family:'Times New Roman', Times, serif; font-size:13pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">Cambio de estado de Impresi&oacute;n OC</strong></td>
			</tr>
			<tr>			
				<td colspan="2" align="center">
					<table width="100%" align="center">
						<tr>
							<td><hr/></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr><td width="42%">&nbsp;</td></tr>
			<tr>
				<td align="right"><strong>No.Orden de compra:&nbsp;</strong></td>
				<td width="58%">#rsDatosOC.EOnumero#</td>
			</tr>
			<tr>
				<td align="right"><strong>Estado actual de impresi&oacute;n:&nbsp;</strong></td>
				<td width="58%">#rsDatosOC.EstadoImpresion#</td>
			</tr>
			<tr>
				<td align="right"><strong>Cambiar estado a:&nbsp;</strong></td>
				<td>
					<select name="EOImpresion">
						<option value="">Pendiente de impresión (Nunca impresa)</option>
						<!---<option value="I">Primera impresión</option>--->
						<option value="R">Impresa (Impresión de copias)</option>
					</select>
				</td>
			</tr>		
			<tr><td>&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="2" align="center">
					<table width="159">
					  <tr>
						<td width="88"><input type="submit" name="btn_aceptar" value="Aceptar"></td>
						<td width="59"><input type="button" name="btn_cerrar" value="Cerrar" onClick="javascript: window.close();"></td>
				  </tr></table>
				</td>	
			</tr>
		</table>
	</form>
</cfoutput>