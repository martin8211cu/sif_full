<cf_templateheader title="Activos Fijos ">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Activos por Placa'>
			<!--- Consultas si existe --->
			<cfif isdefined("url.existe") and url.existe is 0>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td align="center"><font style="color:#FFOOOO " >La Placa ingresada no existe.</font></td>
					</tr>
				</table>
			</cfif>
			
			<!--- Consultas --->
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
			
			<!--- JavaScript Número 1 --->	
			<script language="JavaScript" type="text/JavaScript">				
				function consultarxPaginas() 
				{
					if (document.form1.DSplaca.value != "") {
						document.form1.action='/cfmx/sif/af/consultas/activosPorPlaca/activosPorPlaca_form.cfm';
						document.form1.submit();
					} else {
						alert("Debe digitar un número de placa!.Por favor intente de nuevo.");
						return false;
					}
				}
			</script>
			
			<cfoutput>
			<form action="activosPorPlaca.cfm" method="post" name="form1" onSubmit="javascript: consultarxPaginas();">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr><td nowrap colspan="2">&nbsp;</td></tr>
					<tr>
						<td valign="top" width="50%" align="center">
							<table width="90%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<cf_web_portlet_start border="true" titulo="Consulta de Activos por Placa" skin="info1">
											<p align="justify">En &eacute;sta consulta se muestra la informaci&oacute;n de todos los activos según la placa solicitada, agrupados
											&eacute;stos por Centro funcional, Categor&iacute;a, Clase. Este reporte
											se puede generar en varios formatos - Html, pdf y xls-,
											mejorando su presentaci&oacute;n y aumentando as&iacute; su utilidad
											y eficiencia en el traslado de datos. </p>
										<cf_web_portlet_end>
									</td>
								</tr>
							</table>
						</td>
						
						<td valign="top" width="50%" align="center">
							<table width="98%" border="0">
								<tr>
									<td>
										<table width="98%" border="0">
											<tr>
												<td width="5%" align="right" nowrap><strong>Placa:</strong></td>
												<td width="95%" nowrap><cf_sifactivo placa="DSplaca"></td>
											</tr>
										</table>
									</td>
								</tr>
							  	
								<tr>
									<td nowrap align="center">
										<fieldset>
								  		<legend><strong>Estado del Activo desde</strong>&nbsp;</legend>
											<table width="100%"  border="0" cellspacing="2" cellpadding="0">
												<tr>
													<td align="right" nowrap><strong>Periodo inicial:</strong>&nbsp;</td>
													<td nowrap>
														<select name="Periodoini" onChange="javascript:CambiarMesini();">
															<cfloop query="rsPeriodos">
																<option value="#Pvalor#">#Pvalor#</option>
															</cfloop>
														</select>
													</td>
													<td align="right" nowrap><strong>Mes inicial:</strong>&nbsp;</td>
													<td nowrap>
														<select name="Mesini"></select>
													</td>
												</tr>
													
												<tr>
													<td align="right" nowrap><strong>Periodo final:</strong>&nbsp;</td>
													<td nowrap>
														<select name="Periodo" onChange="javascript:CambiarMes();">
															<cfloop query="rsPeriodos">
																<option value="#Pvalor#" <cfif rsPeriodo.Pvalor eq rsPeriodos.Pvalor>selected</cfif>>#Pvalor#</option>
															</cfloop>
														</select>
													</td>
													<td align="right" nowrap><strong>Mes final:</strong>&nbsp;</td>
													<td nowrap>
														<select name="Mes"></select>
													</td>
												</tr>
											</table>
										</fieldset>
									</td>
							  	</tr>
								 
								<tr>
									<td colspan="3" align="center">
							  			<input name="btnConsultar" type="button" value="Consultar" onClick="javascript: consultarxPaginas();">
							  			<input type="reset" name="Reset" value="Limpiar">
									</td>
								</tr>
								<tr>
									<td colspan="3">&nbsp;</td>
								</tr>	
							</table>
						</td>
					</tr>
				</table>
			</form>
			</cfoutput>
			
			<!--- JavaScript Número 2 --->	
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
			  	
				function CambiarMesini()
				{
			  		var oCombo = document.form1.Mesini;
			  		var vPeriodo = document.form1.Periodoini.value;
			  		var cont = 0;
			  		oCombo.length=0;
			  		<cfoutput query="rsMeses">
			   			if ( (#Trim(rsPeriodo.Pvalor)# > vPeriodo) || ((#Trim(rsPeriodo.Pvalor)# == vPeriodo) && (#Trim(rsMes.Pvalor)# >= #rsMeses.Pvalor#)) )
			   			{
							oCombo.length=cont+1;
							oCombo.options[cont].value='#Trim(rsMeses.Pvalor)#';
							oCombo.options[cont].text='#Trim(rsMeses.Pdescripcion)#';
							cont++;
			   			};
			  		</cfoutput>
			 	}
				
				CambiarMesini();
			 	CambiarMes();
			</script>
			
		<cf_web_portlet_end>
	<cf_templatefooter>