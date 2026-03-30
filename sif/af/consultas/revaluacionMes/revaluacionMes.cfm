<!---
Nombre del Archivo: revaluacionMes.cfm
Programado Por: 	Rodolfo Jiménez Jara.
Fecha de Creación: 	02/07/2004.
Descripción: 		Se necesita consultar los datos de la revaluación al último mes del activo. 
Principales Funciones.
--->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<cfoutput>#pNavegacion#</cfoutput>			<!---Consultas para pintar el formulario--->
			<!---Categorias--->
			<cfquery name="rsCategorias" datasource="#Session.DSN#">
			 select ACcodigo, ACdescripcion, ACmascara
			 from ACategoria 
			 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			
			<!---Clases se llenan automáticamente cuando cambia la categoria--->
			<cfquery name="rsClases" datasource="#Session.DSN#">
			 select a.ACcodigo, a.ACid, a.ACdescripcion, a.ACdepreciable, a.ACrevalua
			 from AClasificacion a
			 where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			
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
									<cf_web_portlet_start border="true" titulo="Reporte de Revaluaci&oacute;n de Activos" skin="info1">
										<p align="justify">En &eacute;sta consulta se muestra la informaci&oacute;n de todos los activos revaluados al periodo- mes solicitados, agrupados
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
						<form method="get" name="form1" action="revaluacionMes-rep.cfm">
							<table width="90%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="25%" nowrap><strong>Categor&iacute;a:&nbsp;</strong></td>
									<td rowspan="2" nowrap><cf_sifCatClase tabindexCat="1" tabindexClas="1"></td>
								</tr>
								<tr>
									<td width="25%" nowrap><strong>Clase:&nbsp;</strong></td>
								</tr>
								<tr>
									<td width="25%" nowrap><strong>Centro Funcional:&nbsp;</strong></td>
									<td><cf_rhcfuncional form="form1" id="CFid" tabindex="1"></td>
								</tr>
								<tr><td colspan="2" nowrap>&nbsp;</td></tr>
								<tr>
									<td align="center" colspan="2">
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
								<tr><td nowrap colspan="2">&nbsp;</td></tr>
								<tr>
									<td width="25%" nowrap><strong>Formato:&nbsp;</strong></td>
									<td>
										<select name="Formato" id="Formato" tabindex="1">
											<option value="FLASHPAPER">FLASHPAPER</option>
											<option value="PDF">PDF</option>
											<option value="EXCEL">EXCEL</option>
										</select>
									</td>
								</tr>
								<tr><td colspan="2">&nbsp;</td></tr>
								
								<tr>
									<td align="center" colspan="2">
										<fieldset>
										<legend>Tipo de Reporte&nbsp;</legend>
											<input name="TipoRep" type="radio" id="r1" value="1" checked tabindex="1"> <label for="r1" style="font-style:normal; font-variant:normal; font-weight:normal">cf/c/c</label>
											<input name="TipoRep" type="radio" id="r2" value="2" tabindex="1"><label for="r2" style="font-style:normal; font-variant:normal; font-weight:normal">c/c/cf </label>
											<input name="TipoRep" type="radio" id="r3" value="3" tabindex="1"><label for="r3" style="font-style:normal; font-variant:normal; font-weight:normal">cf/c/c - Resumido </label>
											<input name="TipoRep" type="radio" id="r4" value="4" tabindex="1"><label for="r4" style="font-style:normal; font-variant:normal; font-weight:normal">c/c/cf - Resumido </label>
										</fieldset>		
									</td>
								</tr>
								<tr><td colspan="2">&nbsp;</td></tr>
								<tr>
									<td colspan="2" align="center"><cf_botones values="Generar, Limpiar" names="Reporte, Limpiar"  tabindex="1"></td>
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
								document.form1.Categoria.focus();
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
