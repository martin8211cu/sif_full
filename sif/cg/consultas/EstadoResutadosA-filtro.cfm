<!--- 	
	Modificado por Gustavo Fonseca H.
		Fecha: 3-3-2006.
		Motivo: Se utiliza la tabla CGPeriodosProcesados para sacar el combo de los periodos y así mejorar el 
			rendimiento de la pantalla. 
	Modificado por Gustavo Fonseca H.
		Fecha: 10-3-2006.
		Motivo: Limitación del acceso al uso de la consulta de Estado de resultado por Area de Responsabilidad. 
			Solo el responsable que se asigne al área debe tener acceso a esta consulta. Se limitan las opciones del combo de Area de Responsabilidad.
--->


	<cf_templateheader title="Contabilidad General">

		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consultas por Area de Responsabilidad'>
			<cfinclude template="../../portlets/pNavegacion.cfm">
			<cfinclude template="Funciones.cfm">
			<cfset periodo=get_val(30).Pvalor>
			<cfset mes=get_val(40).Pvalor>
			<cfset formato = get_val(10).Pvalor>
			<cfset cantniv = ArrayLen(listtoarray(formato,'-'))>

			<cfquery name="rsOficinas" datasource="#Session.DSN#">
				select Ocodigo, Odescripcion 
				from Oficinas 
				where Ecodigo = #Session.Ecodigo#
			</cfquery>
	
			<cfquery name="rsPeriodos" datasource="#Session.DSN#">
				select distinct Speriodo
				from CGPeriodosProcesados
				where Ecodigo = #Session.Ecodigo#
				order by Speriodo desc
			</cfquery>
			
			<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
				select a.Mcodigo, b.Mnombre, b.Msimbolo, b.Miso4217
				from Empresas a
					inner join Monedas b 
					 	on a.Mcodigo = b.Mcodigo	
				where a.Ecodigo = #Session.Ecodigo#
			</cfquery>

			<cfquery name="rsParam" datasource="#Session.DSN#">
				select Pvalor
				from Parametros
				where Ecodigo = #Session.Ecodigo#
				and Pcodigo = 660
			</cfquery>
			<cfif rsParam.recordCount> 
				<cfquery name="rsMonedaConvertida" datasource="#Session.DSN#">
					select Mcodigo, Mnombre
					from Monedas
					where Ecodigo = #Session.Ecodigo#
					and Mcodigo = #rsParam.Pvalor#
				</cfquery>
			</cfif>
		 <script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
		  <form name="form1" method="post" action="EstadoResultadosA-result.cfm" onsubmit="javascript:return validar(this); sinbotones();">
            <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
              <tr>
                <td colspan="4">&nbsp; </td>
              </tr>
              
				<tr>
					<td width="50%" valign="top">
						<cf_web_portlet_start border="true" titulo="Consultas por Area de Responsabilidad" skin="info1">
							<table width="95%" border="0" cellpadding="2" cellspacing="0" align="center">
							  <tr>
								<td>
									<div align="justify" style="font-size:12px;">
										<br />
										En &eacute;ste reporte se detalla el estado de resultados 
										durante un per&iacute;odo contable	y en un area de responsabilidad espec&iacute;fica.
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
							<tr><td><strong>Tipo de Reporte</strong></td></tr>
							<tr><td >
								<cfquery name="tipo" datasource="#session.DSN#">
									select CGARepid, CGARepDes
									from CGAreasTipoRep
									order by 2
								</cfquery>
								<select name="CGARepid">
									<option value="">-seleccionar-</option>
									<cfoutput query="tipo">
										<option value="#tipo.CGARepid#">#tipo.CGARepDes#</option>
									</cfoutput>
								</select>
							</td></tr>
							
							<tr><td ><strong>Area de Responsabilidad</strong></td></tr>	
							<tr>
								<td valign="middle">
								<cfquery name="area" datasource="#session.DSN#">
								<!--- Todos los que no tienen registro en la tabla de permisos --->
									select a.CGARid, a.CGARcodigo, a.CGARdescripcion
									from CGAreaResponsabilidad a
									where a.Ecodigo = #Session.Ecodigo#
									and 0  =  (  select count(1)
														from CGPermisosAreaResp b 
														where b.Ecodigo=a.Ecodigo 
														  and b.CGARid = a.CGARid )
									
									union
									
								<!--- todos a los que un usuario tiene permiso --->
									select a.CGARid, a.CGARcodigo, a.CGARdescripcion
									from CGAreaResponsabilidad a

									inner join CGPermisosAreaResp  b
										on b.CGARid=a.CGARid
										and b.Ecodigo=a.Ecodigo
										and b.Usucodigo = #session.Usucodigo#
									where a.Ecodigo = #Session.Ecodigo#
									
									order by CGARcodigo 
								</cfquery>
								
								
								
								<select name="CGARid">
									<option value="">-seleccionar-</option>
									<cfoutput query="area">
										<option value="#area.CGARid#">#trim(area.CGARcodigo)# - #area.CGARdescripcion#</option>
									</cfoutput>
								</select>
								</td>
							</tr>

							<tr><td ><strong>Moneda</strong></td></tr>	
							<tr>
								<td valign="middle">
								<cfquery name="monedas" datasource="#session.DSN#">
									select Miso4217, Mnombre 
									from Monedas 
									where Ecodigo = #Session.Ecodigo#
									order by Mnombre
								</cfquery>
								<select name="moneda">
									<option value="-1">-todos-</option>
									<cfoutput query="monedas">
										<option value="#monedas.Miso4217#"  <cfif rsMonedaLocal.Miso4217 eq monedas.Miso4217 >selected</cfif> >#monedas.Mnombre#</option>
									</cfoutput>
								</select>
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
												<cfloop index="i" from="0" to="#cantniv#">
													<option value="<cfoutput>#i#</cfoutput>" <cfif i EQ 2>selected</cfif>><cfoutput>#i#</cfoutput></option>
												</cfloop>
												</select>
											</td>
										</tr>
						  <tr>
							<td colspan=""><input type="checkbox" name="toExcel"/>Generar a Excel </td>
						  </tr>

										
										<tr>
											<td colspan="4" align="center">
												<input type="submit" name="Submit" value="Consultar">
											</td>
										</tr>
									</table>
								</td>
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
				if ( document.form1.CGARepid.value == '' ){
					mensaje += ' - El campo Tipo de Reporte es requerido.\n';
				}

				if ( document.form1.CGARid.value == '' ){
					mensaje += ' - El campo Area de Responsabilidad es requerido.\n';
				}

				if ( mensaje != '' ){
					alert('Se presentaron los siguientes errores:\n' + mensaje)
					return false;
				}
				return true;
			}
		</script>

	<cf_templatefooter>