<cf_templateheader title="Activos Fijos">
		<cf_templatecss>
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Movimientos de Activos por Centro Funcional'>
			<cfinclude template="../../portlets/pNavegacion.cfm">
			<cfoutput>

			<!--- Tipo de Transaccion --->
			<cfquery name="tipo" datasource="#session.DSN#">
				select IDtrans, AFTdes
				from AFTransacciones
			</cfquery>
			<form name="form1" method="get" style="margin:0;" action="Movimientos.cfm">
				<table align="center" width="100%" cellpadding="2" cellspacing="0">
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td align="right" width="45%"><strong>Tipo de Transacci&oacute;n:</strong>&nbsp;</td>
						<td>
							<select name="">
								<cfloop query="tipo">
									<option value="#tipo.IDtrans#">#tipo.AFTdes#</option>
								</cfloop>
							</select>
						</td>
					</tr>

					<!---
					<tr>
						<td align="right"><strong>Fecha Inicial:</strong>&nbsp;</td>
						<td ><cf_sifcalendario name="inicio"  tabindex="1"></td>
					</tr>
					<tr>
						<td align="right"><strong>Fecha Final:</strong>&nbsp;</td>
						<td><cf_sifcalendario name="ffinal"  tabindex="1"></td>
					</tr>
					<tr>
						<td align="right"><strong>Cuenta Bancaria:</strong>&nbsp;</td>
						<td>
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td width="1%">
										<cf_conlis title="Lista de Cuentas Bancarias"
												campos = "CBid, CBcodigo,CBdescripcion" 
												desplegables = "N,S,N" 
												modificables = "N,N,N" 
												size = "0,50,0"
												tabla="CuentasBancos a inner join Bancos b on b.Bid=a.Bid"
												columnas="a.CBid, b.Bdescripcion, a.CBcodigo, a.CBdescripcion"
												filtro="a.Ecodigo=#session.ecodigo# and a.CBesTCE = 0 order by b.Bdescripcion, a.CBcodigo"
												desplegar="CBcodigo,CBdescripcion"
												etiquetas="Cuenta, Descripción"
												formatos="S,S"
												align="left,left"
												asignar="CBid, CBcodigo"
												asignarformatos="S,S"
												showEmptyListMsg="true"
												debug="false"
												tabindex="1"
												cortes="Bdescripcion">
									</td>
									<td width="99%"><a href="##"><img onclick="javascript:limpiar();" border="0" src="../../imagenes/Borrar01_S.gif" /></a></td>
								</tr>
							</table>
						</td>
					</tr>

					<tr>
						<td align="right"><strong>Socio:</strong>&nbsp;</td>
						<td><cf_sifsociosnegocios2 SNcodigo="idsocio" SNnombre="nsocio" SNnumero="socio" SNtiposocio="P" frame="framesocio" tabindex="1"></td>
					</tr>
					
					<tr>
						<td align="right"><strong>Formato:</strong>&nbsp;</td>
						<td>
							<select name="formato" tabindex="1">
								<option value="flashpaper">flashpaper</option>
								<option value="pdf">pdf</option>
							</select>
						</td>
					</tr>
					--->
					<tr><td colspan="2" align="center"><cf_botones tabindex="1" include="Filtrar" exclude="Alta,Limpiar"></td></tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			</form>	
			</cfoutput>
		<cf_web_portlet_end>

		<cf_qforms>
		<script type="text/javascript" language="javascript1.2">
			function limpiar(){
				document.form1.CBid.value=''; 
				document.form1.CBcodigo.value=''; 
				return false;
			}

			objForm.TESid.required = true;
			objForm.TESid.description = 'Tesorería';
			objForm.inicio.required = true;
			objForm.inicio.description = 'Fecha Inicial';
			objForm.ffinal.required = true;
			objForm.ffinal.description = 'Fecha Final';
		</script>


	<cf_templatefooter>