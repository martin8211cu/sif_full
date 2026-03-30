
<cfif isdefined("url.DGCid") and not isdefined("form.DGCid")>
	<cfset form.DGCid = url.DGCid >
</cfif>

<cfif isdefined("url.pagenum_lista")>
	<cfset form.pagenum_lista = url.pagenum_lista >
<cfelse>
	<cfset form.pagenum_lista = 1 >
</cfif>
<cfif isdefined("url.filtro_DGCcodigo")	and not isdefined("form.filtro_DGCcodigo")>
	<cfset form.filtro_DGCcodigo = url.filtro_DGCcodigo >
</cfif>
<cfif isdefined("url.filtro_DGdescripcion")	and not isdefined("form.filtro_DGdescripcion")>
	<cfset form.filtro_DGdescripcion = url.filtro_DGdescripcion >
</cfif>

<cfset modo = 'ALTA'>
<cfif isdefined("form.DGCid") and len(trim(form.DGCid)) >
	<cfset modo = 'CAMBIO'>

	<cfquery name="data" datasource="#session.DSN#">
		select a.DGCid, a.DGCcodigo, a.DGdescripcion, a.CEcodigo, a.DGtipo, a.Comportamiento, a.referencia
		from DGConceptosER a	
		where a.DGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCid#" >
	</cfquery>
</cfif>
			<cfoutput>
			<form style="margin:0" action="conceptos-sql.cfm" method="post" name="form1" id="form1" >
			<table align="center" border="0" cellspacing="0" cellpadding="4" width="100%" >
				<tr>
					<td colspan="6" align="center" bgcolor="##ececff" >
						<table width="100%" cellpadding="0" >
							<tr><td align="center" colspan="3" ><font color="##006699"><strong>Conceptos</strong></font></td></tr>
						</table>
					</td>
				</tr>

				<tr>
					<td align="right" valign="middle" width="45%"><strong>C&oacute;digo:</strong></td>
					<td align="left" valign="middle">
						<input type="text" size="15" maxlength="10" onfocus="this.select()" 
						name="DGCcodigo" value="<cfif isdefined("data.DGCcodigo")>#trim(data.DGCcodigo)#</cfif>" >
					</td>
						
				</tr>	

				<tr>
					<td align="right" valign="middle" width="1%"><strong>Descripci&oacute;n:</strong></td>
					<td align="left" valign="middle">
						<input type="text" size="40" maxlength="80" onfocus="this.select()" 
							name="DGdescripcion" value="<cfif isdefined("data.DGdescripcion")>#trim(data.DGdescripcion)#</cfif>">
					</td>
				</tr>	

				<tr>
					<td align="right" valign="middle" width="1%"><strong>Tipo:</strong></td>
					<td align="left" valign="middle">
						<select name="DGtipo">
							<option value="I" <cfif isdefined("data.DGtipo") and data.DGtipo eq 'I'>selected</cfif> >Ingreso</option>
							<option value="G" <cfif isdefined("data.DGtipo") and data.DGtipo eq 'G'>selected</cfif>>Gasto</option>
						</select>
					</td>
				</tr>	

				<tr>
					<td align="right" valign="middle" width="1%"><strong>Comportamiento:</strong></td>
					<td align="left" valign="middle">
						<select name="Comportamiento">
							<option value="O" <cfif isdefined("data.Comportamiento") and data.Comportamiento eq 'O'>selected</cfif> >Objeto de Gasto</option>
							<option value="P" <cfif isdefined("data.Comportamiento") and data.Comportamiento eq 'P'>selected</cfif>>Producto</option>
						</select>
					</td>
				</tr>	

				<tr>
					<td align="right" valign="middle" width="1%"><strong>Referencia:</strong></td>
					<td align="left" valign="middle">
						<select name="referencia">
							<option value="10" <cfif isdefined("data.referencia") and data.referencia eq '10'>selected</cfif> >Ventas</option>
							<option value="20" <cfif isdefined("data.referencia") and data.referencia eq '20'>selected</cfif>>Costo de Ventas</option>
							<option value="30" <cfif isdefined("data.referencia") and data.referencia eq '30'>selected</cfif> >Otros Ingresos de Operaci&oacute;n</option>
							<option value="40" <cfif isdefined("data.referencia") and data.referencia eq '40'>selected</cfif>>Gastos Directos</option>
							<option value="41" <cfif isdefined("data.referencia") and data.referencia eq '41'>selected</cfif>>Gastos Indirectos</option>
							<option value="50" <cfif isdefined("data.referencia") and data.referencia eq '50'>selected</cfif> >Otros Gastos Deducibles</option>
							<option value="60" <cfif isdefined("data.referencia") and data.referencia eq '60'>selected</cfif>>Asignaci&oacute;n Gastos Administrativos</option>
							<option value="70" <cfif isdefined("data.referencia") and data.referencia eq '70'>selected</cfif> >Otros Ingresos No Gravables</option>
							<option value="80" <cfif isdefined("data.referencia") and data.referencia eq '80'>selected</cfif> >Otros Gastos No Deducibles</option>
							<option value="90" <cfif isdefined("data.referencia") and data.referencia eq '90'>selected</cfif> >Impuestos</option>
						</select>
					</td>
				</tr>	


				<tr>
					<td colspan="4" align="center"><cf_botones modo="#modo#" include="Regresar"></td>
				</tr>
			</table>
			<input type="hidden" name="pagenum_lista" value="#form.pagenum_lista#"  /> 
			<cfif modo eq 'CAMBIO' >
				<input type="hidden" name="DGCid" value="#form.DGCid#" /> 
			</cfif>

			<cfif isdefined("form.filtro_DGCcodigo")and len(trim(form.filtro_DGCcodigo)) >
				<input type="hidden" name="filtro_DGCcodigo" value="#form.filtro_DGCcodigo#"  /> 
			</cfif>
			<cfif isdefined("form.filtro_DGdescripcion") and len(trim(form.filtro_DGdescripcion))>
				<input type="hidden" name="filtro_DGdescripcion" value="#form.filtro_DGdescripcion#"  /> 
			</cfif>
			<cfif isdefined("form.filtro_DGtipo")>
				<input type="hidden" name="filtro_DGtipo" value="#form.filtro_DGtipo#"  /> 
			</cfif>
		</form>
		</cfoutput>
		
		<cf_qforms>
		<script language="javascript1.2" type="text/javascript">
			objForm.DGCcodigo.required = true;
			objForm.DGCcodigo.description = 'Código';			
			objForm.DGdescripcion.required = true;
			objForm.DGdescripcion.description = 'Descripción';			
			
			function deshabilitarValidacion(){
				objForm.DGCcodigo.required = false;
				objForm.DGdescripcion.required = false;
			}
			
			function funcRegresar(){
				deshabilitarValidacion();
				document.form1.action = 'conceptos-lista.cfm';
			}
		</script>