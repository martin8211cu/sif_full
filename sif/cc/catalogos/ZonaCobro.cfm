<cf_templateheader title="Cuentas por Cobrar">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Zonas de Cobro'>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="2" valign="top">
						<cfinclude template="../../portlets/pNavegacion.cfm">
						<script language="JavaScript1.2" type="text/javascript">
							function limpiar(){
							document.filtro.fZCSNcodigo.value = '';
							document.filtro.fZCSNdescripcion.value = '';
							document.filtro.fNombreEmp.value = '';
							}
						</script>
					</td>
				</tr>
				<tr>
                	<cfinclude template="../../Utiles/sifConcat.cfm">
					<cfquery name="rsLista" datasource="#session.DSN#">
						select a.ZCSNcodigo,a.ZCSNdescripcion, 
							b.DEnombre #_Cat# ' ' #_Cat# b.DEapellido1 #_Cat# ' ' #_Cat# b.DEapellido2 as NombreEmp
						from ZonaCobroSNegocios a inner join DatosEmpleado b
						  on a.Ecodigo = b.Ecodigo and 
						     a.DEidCobrador    = b.DEid
						where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#" >
						<cfif isdefined("form.fZCSNcodigo") and len(trim(form.fZCSNcodigo)) gt 0>
							and upper (rtrim(a.ZCSNcodigo)) like upper('%#form.fZCSNcodigo#%')
						</cfif>
						<cfif isdefined("form.fZCSNdescripcion") and len(trim(form.fZCSNdescripcion)) gt 0>
							and  upper(rtrim(a.ZCSNdescripcion)) like upper('%#form.fZCSNdescripcion#%')
						</cfif>
						<cfif isdefined("form.fNombreEmp") and len(trim(form.fNombreEmp)) gt 0>
							and  upper(rtrim(b.DEnombre #_Cat# b.DEapellido1 #_Cat# b.DEapellido2)) like upper('%#form.fNombreEmp#%')
						</cfif>						
						order by ZCSNcodigo
					</cfquery>
					<td valign="top" width="50%"> 
						<form style="margin:0" name="filtro" method="post">
							<table width="100%" cellpadding="2" cellspacing="0" class="areaFiltro">
								<tr>
									<td><strong>C&oacute;digo</strong></td>
									<td><strong>Descripci&oacute;n</strong></td>
									<td><strong>Cobrador Asociado</strong></td>
								</tr>
								<tr>
									<cfoutput>
										<td>
											<input name="fZCSNcodigo" type="text" size="5" maxlength="5" 
											onFocus="this.select();" 
											value="<cfif isdefined("form.fZCSNcodigo")>#form.fZCSNcodigo#</cfif>">
										</td>
										<td>
											<input name="fZCSNdescripcion" type="text" size="30" maxlength="80" 
											onFocus="this.select();" 
											value="<cfif isdefined("form.fZCSNdescripcion")>#form.fZCSNdescripcion#</cfif>">
										</td>
										<td>
											<input name="fNombreEmp" type="text" size="30" maxlength="80" 
											onFocus="this.select();" 
											value="<cfif isdefined("form.fNombreEmp")>#form.fNombreEmp#</cfif>">
										</td>
									</cfoutput>
									<td align="center" nowrap>
										<input name="btnFiltrar" type="submit" value="Filtrar">
										<input name="btnLimpiar" type="button" value="Limpiar" 
											onClick="javascript:limpiar();">
									</td>
								</tr>
							</table>						
						</form>
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"	 returnvariable="pListaZonas">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="etiquetas" value="Código, Descripción, Cobrador Asociado"/>
							<cfinvokeargument name="desplegar" value="ZCSNcodigo,ZCSNdescripcion,NombreEmp"/>
							<cfinvokeargument name="etiquetas" value="Código, Descripción, Cobrador Asociado"/>
							<cfinvokeargument name="formatos" value=""/>
							<cfinvokeargument name="align" value="left, left,left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="keys" value="ZCSNcodigo"/>
							<cfinvokeargument name="irA" value="ZonaCobro.cfm"/>
						</cfinvoke> </td>
					<td><cfinclude template="formZonaCobro.cfm"></td>
				</tr>
				<tr><td>&nbsp;</td><td>&nbsp;</td></tr>
			</table>
<cf_web_portlet_end>	
	<cf_templatefooter>