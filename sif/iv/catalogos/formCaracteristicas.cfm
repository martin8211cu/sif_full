<!--- Datos del Articulo y Clasificacion --->
<cfquery name="data_articulo" datasource="#session.DSN#">
	select a.Acodigo, a.Adescripcion, a.Ccodigo, b.Ccodigoclas, b.Cdescripcion 
	from Articulos a 
	inner join Clasificaciones b
	on a.Ecodigo=b.Ecodigo
	   and a.Ccodigo=b.Ccodigo
	where a.Aid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="data_caracteristicas" datasource="#session.DSN#">
	select a.CDcodigo, a.CDdescripcion, b.CVcodigo, Valor
	from ClasificacionesDato a
	left outer join ArticulosValor b
	on a.CDcodigo=b.CDcodigo
	  and b.Aid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.Ccodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#data_articulo.Ccodigo#">
</cfquery>

<cfif data_caracteristicas.RecordCount gt 0>
	<form name="form1" action="SQLCaracteristicas.cfm" method="post">
		<cfoutput>
			<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
			<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">		
			<input type="hidden" name="filtro_Acodigo" value="<cfif isdefined('form.filtro_Acodigo') and form.filtro_Acodigo NEQ ''>#form.filtro_Acodigo#</cfif>">
			<input type="hidden" name="filtro_Acodalterno" value="<cfif isdefined('form.filtro_Acodalterno') and form.filtro_Acodalterno NEQ ''>#form.filtro_Acodalterno#</cfif>">
			<input type="hidden" name="filtro_Adescripcion" value="<cfif isdefined('form.filtro_Adescripcion') and form.filtro_Adescripcion NEQ ''>#form.filtro_Adescripcion#</cfif>">		
			<input type="hidden" name="Aid" value="#form.Aid#">
			<input type="hidden" name="total" value="#data_caracteristicas.RecordCount#">
		</cfoutput>		
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr><td colspan="2" class="subTitulo" align="center"><font size="2">Caracter&iacute;sticas de Art&iacute;culos</font></td></tr>
			<cfoutput>
	
			<tr><td width="40%" align="right" nowrap><strong>Art&iacute;culo:&nbsp;</strong></td><td><strong>#data_articulo.Acodigo# - #data_articulo.Adescripcion#</strong></td></tr>
			<tr><td align="right" nowrap><strong>Clasificaci&oacute;n:</strong></td><td><strong>#data_articulo.Ccodigoclas# - #data_articulo.Cdescripcion#</strong></td></tr>
			</cfoutput>
			
			<script language="javascript" type="text/javascript">
				function cambCVcodigo(par1,par2){
					eval("document.form1.valor_" + par1 + ".value='" + par2 + "'");
				}
			</script>		
				
			<cfset i = 0>
			<cfoutput query="data_caracteristicas">
				<cfset vCDcodigo = data_caracteristicas.CDcodigo >
				<cfset vCDdescripcion = data_caracteristicas.CDdescripcion >
				<cfset vCVcodigo = data_caracteristicas.CVcodigo >
				<cfset vValor = data_caracteristicas.Valor >
			
				<tr>
					<td align="right" width="40%"><strong>#data_caracteristicas.CDdescripcion#:&nbsp;</strong></td>
					
					<cfquery name="rsCombo" datasource="#session.DSN#">
						select CDcodigo, CVcodigo, CVvalor
						from ClasificacionesValor
						where CDcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCDcodigo#">
					</cfquery>
					<td>
						<cfif rsCombo.RecordCount gt 0>
<!--- 							<select name="CVcodigo_#i#" onChange="form.valor_#i#.value=this.options[this.selectedIndex].text" > --->
							<select tabindex="1" name="CVcodigo_#i#" onChange="javascript: cambCVcodigo(#i#,this.options[this.selectedIndex].text);" >							
								<option value="">-Sin especificar-</option>
								<cfloop query="rsCombo">
									<option value="#rsCombo.CVcodigo#"  <cfif vCVcodigo eq rsCombo.CVcodigo>selected</cfif> >#rsCombo.CVvalor#</option>
								</cfloop>
							</select>
							<input type="hidden" name="valor_#i#" value="">
							<script language="javascript" type="text/javascript">
								var obj1 = new String(#i#);
								var obj2 = new String(document.form1.CVcodigo_#i#.options[document.form1.CVcodigo_#i#.selectedIndex].text);
								cambCVcodigo(obj1,obj2);
							</script>
							
						<cfelse>
							<input type="text" onFocus="this.select()" tabindex="1" size="60" maxlength="60" name="valor_#i#" value="<cfif len(trim(vValor))>#trim(vValor)#</cfif>">
						</cfif>
						<input type="hidden" name="CDcodigo_#i#" value="#vCDcodigo#">
					</td>	
				</tr>
				<cfset i = i+1>
			</cfoutput>
	
			<tr><td>&nbsp;</td></tr>
	
			<tr>
				<td colspan="2" align="center">
					<cf_Botones modo="CAMBIO" exclude="Baja,Nuevo" include="Regresar" includevalues="Regresar" tabindex="1">
				</td>
			</tr>
			
			<tr><td>&nbsp;</td></tr>
		
		</table>
	</form>
<cfelse>
	<cfoutput>
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr><td>&nbsp;</td></tr>
		<tr><td width="40%" align="right" nowrap><strong>Art&iacute;culo:&nbsp;</strong></td><td><strong>#data_articulo.Acodigo# - #data_articulo.Adescripcion#</strong></td></tr>
		<tr><td align="right" nowrap><strong>Clasificaci&oacute;n:</strong></td><td><strong>#data_articulo.Ccodigoclas# - #data_articulo.Cdescripcion#</strong></td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr><td align="center" colspan="2">No han sido definidas caracter&iacute;sticas para la Clasificaci&oacute;n asociada al art&iacute;culo.</td></tr>
					<tr><td align="center" align="center">Si desea definirlas ahora, haga click al bot&oacute;n.</td></tr>
					<tr><td colspan="2" align="center"><input type="button" name="Definr" value="Definr Caracter&iacute;sicas" onClick="location.href='Clasificacion.cfm?arbol_pos=#data_articulo.Ccodigo#';"></td></tr>
				</table>
			</td></tr>
			<tr><td>&nbsp;</td></tr>
	</table>
	</cfoutput>
</cfif>