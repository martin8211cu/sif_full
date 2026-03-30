	<cf_templateheader title="Contabilidad General">
		<cfinclude template="../../portlets/pNavegacion.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Estado de Resultados por Centro Funcional'>
			<cfinclude template="Funciones.cfm">
			<cfset periodo=get_val(30).Pvalor>
			<cfset mes=get_val(40).Pvalor>
			<cfset formato = get_val(10).Pvalor>
			<cfset cantniv = ArrayLen(listtoarray(formato,'-'))>
			  
			<cfquery name="rsOficinas" datasource="#Session.DSN#">
				select Ocodigo, Odescripcion 
				from Oficinas 
				where Ecodigo =  #Session.Ecodigo# 
			</cfquery>
	
			<cfquery name="rsMonedas" datasource="#Session.DSN#">
				select Mcodigo, Mnombre, Msimbolo, Miso4217, ts_rversion 
				from Monedas
				where Ecodigo =  #Session.Ecodigo# 
			</cfquery>

			<cfquery datasource="#Session.DSN#" name ="rsPeriodos">
					select 
						distinct Speriodo 
					from SaldosContables 
					where Ecodigo =  #Session.Ecodigo#  
					order by Speriodo desc
			</cfquery>
			
			<cfset longitud = len(Trim(rsMonedas.Miso4217))>
			<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
				select a.Mcodigo, b.Mnombre, b.Msimbolo, b.Miso4217
				from Empresas a
					inner join Monedas b 
						on a.Mcodigo = b.Mcodigo
				where a.Ecodigo =  #Session.Ecodigo# 
			</cfquery>

			<cfquery name="rsParam" datasource="#Session.DSN#">
				select Pvalor
				from Parametros
				where Ecodigo =  #Session.Ecodigo# 
				and Pcodigo = 660
			</cfquery>
			<cfif rsParam.recordCount> 
				<cfquery name="rsMonedaConvertida" datasource="#Session.DSN#">
					select Mcodigo, Mnombre
					from Monedas
					where Ecodigo =  #Session.Ecodigo# 
					and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsParam.Pvalor#">
				</cfquery>
			</cfif>
			
		  <form name="form1" method="post" action="EstadoResultadosCF-result.cfm" onsubmit="javascript:return validar(this);">
            <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
              <tr>
                <td colspan="4">&nbsp; </td>
              </tr>
				<tr>
					<td width="50%" valign="top">
						<cf_web_portlet_start border="true" titulo="Estado de Resultados por Centro Funcional" skin="info1">
							<table width="95%" border="0" cellpadding="2" cellspacing="0" align="center">
							  <tr>
								<td>
									<div align="justify" style="font-size:12px;">
										<br />
										En &eacute;ste reporte se detalla el estado de resultados 
										durante un per&iacute;odo contable	y en un centro funcional espec&iacute;fico.
										<br />
										<br />
									</div>
								</td>
							  </tr>
							</table>
						<cf_web_portlet_end>
					</td>	
					<td valign="top" align="center">
						<table width="50%" align="center" cellpadding="1" cellspacing="0">
							<tr><td><strong>Centro Funcional</strong></td></tr>
							<tr><td ><cf_rhcfuncional></td></tr>
							
							<tr><td ><strong>Incluir dependencias</strong></td></tr>	
							<tr>
								<td valign="middle">
									<input type="checkbox" name="dependencias">
									<input name="mcodigoopt" type="hidden" value="-2" >
								</td>
							</tr>
							<tr>
								<td>
									<table width="100%" cellpadding="0" cellspacing="0">
										<tr>
											<td ><strong>Per&iacute;odo</strong></td>
											<td ><strong>Mes</strong></td>
										</tr>	
										<tr>
											<td>
												<select name="periodo">
													<cfloop query = "rsPeriodos">
														<option value="<cfoutput>#rsPeriodos.Speriodo#</cfoutput>"><cfoutput>#rsPeriodos.Speriodo#</cfoutput></option>" <cfif periodo EQ "#rsPeriodos.Speriodo#">selected</cfif>></option>
													</cfloop>
												</select>
											</td>
											<td>
												<select name="mes" size="1">
													<option value="1" <cfif mes EQ 1>selected</cfif>>Enero</option>
													<option value="2" <cfif mes EQ 2>selected</cfif>>Febrero</option>
													<option value="3" <cfif mes EQ 3>selected</cfif>>Marzo</option>
													<option value="4" <cfif mes EQ 4>selected</cfif>>Abril</option>
													<option value="5" <cfif mes EQ 5>selected</cfif>>Mayo</option>
													<option value="6" <cfif mes EQ 6>selected</cfif>>Junio</option>
													<option value="7" <cfif mes EQ 7>selected</cfif>>Julio</option>
													<option value="8" <cfif mes EQ 8>selected</cfif>>Agosto</option>
													<option value="9" <cfif mes EQ 9>selected</cfif>>Setiembre</option>
													<option value="10" <cfif mes EQ 10>selected</cfif>>Octubre</option>
													<option value="11" <cfif mes EQ 11>selected</cfif>>Noviembre</option>
													<option value="12" <cfif mes EQ 12>selected</cfif>>Diciembre</option>
												</select>
											</td>
										</tr>
										<tr>
											<td><strong>Nivel</strong></td>
										</tr>
										<tr>
											<td>
												<select name="nivel">
												<cfloop index="i" from="1" to="#cantniv#">
													<option value="<cfoutput>#i#</cfoutput>" <cfif i EQ 2>selected</cfif>><cfoutput>#i#</cfoutput></option>
												</cfloop>
												</select>
											</td>
										</tr>
										<tr>
											<td colspan="4" align="center">
												<input type="submit" name="Submit" value="Consultar">
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
							</tr>
						</table>
					</td>
				</tr>
              <tr>
                <td colspan="4">&nbsp;</td>
              </tr>
            </table>
		  </form>
		<cf_web_portlet_end>
		<script language="javascript1.2" type="text/javascript">
			function validar(f){
				var mensaje = '';
				if ( document.form1.CFid.value == '' ){
					mensaje += ' - El campo Centro Funcional es requerido.\n';
				}

				if ( mensaje != '' ){
					alert('Se presentaron los siguientes errores:\n' + mensaje)
					return false;
				}
				return true;
			}
		</script>
	<cf_templatefooter>