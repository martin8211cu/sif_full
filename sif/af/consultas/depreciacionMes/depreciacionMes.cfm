<!---
Nombre del Archivo: depreciacionMes.cfm
Programado Por: 	Rodolfo Jiménez Jara.
Fecha de Creación: 	01/07/2004.
Descripción: 		Se necesita consultar los datos de depreciacion del activo. 
Principales Funciones.
--->

<cf_templateheader title="Activos Fijos">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Depreciaci&oacute;n de Activos'>
			<!---Consultas para pintar el formulario--->
			<!--- Periodo --->
			<cfquery name="rsPeriodo" datasource="#session.dsn#">
				select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as Pvalor
				from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and Pcodigo = 50
					and Mcodigo = 'GN'
			</cfquery>
			
			<!--- Periodos --->
			<cfset rsPeriodos = QueryNew("Pvalor")>
			<cfset temp = QueryAddRow(rsPeriodos,3)>
			<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor-2,1)>
			<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor-1,2)>
			<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor,3)>
			
			<!--- Mes --->
			<cfquery name="rsMes" datasource="#session.dsn#">
				select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as Pvalor
				from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and Pcodigo = 60
					and Mcodigo = 'GN'
			</cfquery>
			
			<!--- Meses --->
			<cfquery name="rsMeses" datasource="sifControl">
				select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
				from Idiomas a, VSidioma b 
				where a.Icodigo = '#Session.Idioma#'
				and b.VSgrupo = 1
				and a.Iid = b.Iid
				order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
			</cfquery>
				
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr><td nowrap>&nbsp;</td></tr>
				<tr>
					<td valign="top" width="45%" align="center">
						<table width="90%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td>
									<cf_web_portlet_start border="true" titulo="Reporte de Depreciaci&oacute;n de Activos" skin="info1">
										<p align="justify">En &eacute;sta consulta se muestra la informaci&oacute;n de todos los activos depreciados al periodo- mes solicitados, agrupados
										&eacute;stos por Centro funcional, Categor&iacute;a, Clase. Esta consulta
										se puede generar en varios formatos - Html, pdf y xls-,
										mejorando su presentaci&oacute;n y aumentando as&iacute; su utilidad
										y eficiencia en el traslado de datos. </p>
									<cf_web_portlet_end>
								</td>
							</tr>
						</table>
					</td>
					<td valign="top" width="55%" align="center">
						<cfoutput>
						<form method="post" name="form1" action="depreciacionMes-rep.cfm">
							<table width="90%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="35%" valign="top" align="center">
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td width="25%" nowrap><strong>Categor&iacute;a:&nbsp;</strong></td>
												<td rowspan="2" nowrap><cf_sifCatClase tabindexCat="1" tabindexClas="1"></td>
 											</tr>
											<tr>
												<td width="25%" nowrap><strong>Clase:&nbsp; </strong></td>
											</tr>
											<tr>
												<td width="25%" nowrap><strong>Centro Funcional:&nbsp;</strong></td>
												<td><cf_rhcfuncional form="form1" id="FCentroF" tabindex="1"></td>
											</tr>
											<tr>
												<td colspan="2" nowrap>&nbsp;</td>
											</tr>
											<tr>
												<td width="25%" nowrap><div align="left"><strong>Formato:&nbsp;</strong></div></td>
												<td>
													<select name="formato" tabindex="1">
														<option value="FlashPaper">FlashPaper</option>
														<option value="pdf">Adobe PDF</option>
														<option value="Excel">Microsoft Excel</option>
													</select>													
												</td>
											</tr>
										</table>
									</td>
									<td width="10%">&nbsp;</td>
								</tr>
								
								<tr><td nowrap>&nbsp;</td></tr>
								
								<tr>
									<td align="center">
										<fieldset>
										<legend>Estado Activo&nbsp;</legend>
											<table width="100%"  border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td nowrap><strong>Periodo:&nbsp;</strong></td>
													<td nowrap>
														<select name="Periodo" onChange="javascript:CambiarMes();" tabindex="1">
															<cfloop query="rsPeriodos">
																<option value="#Pvalor#" <cfif rsPeriodo.Pvalor eq rsPeriodos.Pvalor>selected</cfif>>#Pvalor#</option>
															</cfloop>
														</select>
													</td>
													<td nowrap><strong>Mes:&nbsp;</strong></td>
													<td nowrap>
														<select name="Mes" tabindex="1"></select>
													</td>
												</tr>
											</table>
										</fieldset>
									</td>
								</tr>
								<tr><td nowrap>&nbsp;</td></tr>
								<tr>
									<td align="center">
										<fieldset>
										<legend>Tipo de Reporte&nbsp;</legend>
											cf/c/c <input name="cf" type="radio" value="1" checked tabindex="1">
											c/c/cf <input name="cf" type="radio" value="2" tabindex="1">
											cf/c/c - Resumido <input name="cf" type="radio" value="3" tabindex="1">
											c/c/cf - Resumido <input name="cf" type="radio" value="4" tabindex="1">
										</fieldset>		
									</td>
								</tr>
								<tr><td nowrap>&nbsp;</td></tr>
								<tr>
									<td align="center"><cf_botones values="Generar, Limpiar" names="Reporte, Limpiar" tabindex="1"></td>
								</tr>
								<tr><td nowrap>&nbsp;</td></tr>
							</table>
						</form>
						</cfoutput>
						
						<!---Funciones en Javascript del formulario de filtro--->
						<script language="javascript" type="text/javascript">
							function CambiarMes()
							{
								var oCombo = document.form1.Mes;
								var vPeriodo = document.form1.Periodo.value;
								var cont = 0;
								oCombo.length=0;
								<cfoutput query="rsMeses">
									if ( (#Trim(rsPeriodo.Pvalor)# > vPeriodo) || ((#Trim(rsPeriodo.Pvalor)# == vPeriodo) && (#Trim(rsMes.Pvalor)# >= #rsMeses.Pvalor#)) )
									{
										oCombo.length=cont+1;
										oCombo.options[cont].value='#Trim(rsMeses.Pvalor)#';
										oCombo.options[cont].text='#Trim(rsMeses.Pdescripcion)#';
										
										<cfif rsMeses.Pvalor eq rsMes.Pvalor>
											if (#Trim(rsPeriodo.Pvalor)# == vPeriodo)
												oCombo.options[cont].selected = true;
										</cfif>
										cont++;
									};
								</cfoutput>
							}
							
							function _forminit()
							{
								var form = document.form1;
								CambiarMes();
							}
							
							function _formclose(){ }
							
							_forminit();
						</script>
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>
