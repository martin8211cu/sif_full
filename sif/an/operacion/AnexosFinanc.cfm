<cf_templateheader title="Anexos Financieros">

		<cfquery name="rsPeriodos" datasource="#Session.DSN#">
			select distinct Speriodo from SaldosContables where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
	
		<cfquery name="rsMeses" datasource="#Session.DSN#">
			select VSvalor, VSdesc from VSidioma
			where Iid = 1 and VSgrupo = 1
			order by <cf_dbfunction name="to_char_integer" args="VSvalor">
		</cfquery>
	
		<cfquery name="rsOficinas" datasource="#Session.DSN#">
			select Ocodigo, Odescripcion 
			from Oficinas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		
		<cfquery name="rsMonedas" datasource="#Session.DSN#">
			select Mcodigo, Mnombre
			from Monedas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		
		<cfquery name="rsAnexos" datasource="#Session.DSN#">
			select <cf_dbfunction name="to_char" args="a.AnexoId"> as AnexoId, 
					a.AnexoDes as AnexoDes
			from Anexo a, AnexoEm b
			where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and a.AnexoId = b.AnexoId
		</cfquery>
		
		<cfif rsAnexos.RecordCount EQ 0>
			<cf_errorCode	code = "50149" msg = "No se han definido Anexos! Por favor defina el Anexo en el catálogo de Anexos del Sistema!. Proceso Cancelado.">
		</cfif>
		
		<cfif not isdefined("form.AnexoId")>
			<cfset form.AnexoId = rsAnexos.AnexoId>
		</cfif>

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					  <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Anexos Financieros'>
						  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
							  <tr><td colspan="3"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
							  <tr><td> 
								<table width="100%" border="0" cellspacing="0" cellpadding="0"> <!--- 1 --->
									<tr>
										<td>
											<form name="form1" method="post" action="SQLAnexo.cfm">
												<table width="100%" border="0" cellspacing="0" cellpadding="0">
													<tr bgcolor="#CCCCCC" class="contenido-allborder"> 
														<td>Anexo:</td>
														<td>
															<select name="AnexoId" onChange="javascript:CargarAnexo(this.value);">
																<cfoutput query="rsAnexos"> 
																	<option value="#AnexoId#" <cfif isdefined("Form.AnexoId") and len(Trim(Form.AnexoId)) GT 0 and Form.AnexoId EQ rsAnexos.AnexoId>selected</cfif> >#AnexoDes#</option>
																</cfoutput>
															</select>
														</td>
														
														<td>Per&iacute;odo: </td>
														<td>
															<select name="Periodo">
																<cfoutput query="rsPeriodos"> 
																	<option value="#Speriodo#">#Speriodo#</option>
																</cfoutput>
															</select>
														</td>
														
														<td>Mes:</td>
														<td>
															<select name="Mes">
																<cfoutput query="rsMeses"> 
																	<option value="#VSvalor#">#VSdesc#</option>
																</cfoutput>
															</select>
														</td>
									
														<td>Oficina: </td>
														<td>
															<select name="Ocodigo">
																<option value="-1">Todas</option>
																<cfoutput query="rsOficinas"> 
																	<option value="#Ocodigo#">#Odescripcion#</option>
																</cfoutput>
															</select>
														</td>
						
														<td>Moneda:</td>
														<td>
															<select name="Mcodigo">
																<option value="-1">Local</option>
																<cfoutput query="rsMonedas"> 
																	<option value="#Mcodigo#">#Mnombre#</option>
																</cfoutput>
															</select>
														</td>
													</tr>
						
													<tr> 
														<td colspan="10"> 
															<object classid="CLSID:0002E559-0000-0000-C000-000000000046" id="grid" width="100%">
															<img src="../../images/noxl-edit.gif" id="imganexo" name="imganexo" width="695" height="288">
															<!--- <img src="about:blank" width="1" height="1" align="left"> --->
															</object>
															
															<script>				
															var bandera=0;
															if (!document.getElementById('grid')) 
															{
															  //Si no esta definida la instancia del objeto, se carga el otro
															  document.getElementById('imganexo').width = 0;
															  document.getElementById('imganexo').height = 0;															  
															  document.writeln('<object classid="CLSID:0002E551-0000-0000-C000-000000000046" id="grid" width="100%">');
															  document.writeln('<img src="../../images/noxl-edit.gif" id="imganexo" name="imganexo" width="695" height="288">');
															  document.writeln('</object>');
															}
															</script>
															<!--- Julio 27 2005 ADVV
															<object classid="CLSID:0002E551-0000-0000-C000-000000000046" id="grid" width="100%">
															</object> --->
														</td>
													</tr>
												</table>
						
												<cfset anexo = -1 >	
												<cfif isdefined("form.AnexoId") and len(trim(form.AnexoId)) gt 0>
													<cfset anexo = form.AnexoId >
												<cfelseif isdefined("rsAnexos")>
													<cfset anexo = rsAnexos.AnexoId >
												</cfif>
												<cfquery name="rsAnexoXml" datasource="#session.DSN#">
													select AnexoDef
													from Anexoim
													where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#anexo#">
												</cfquery>
						
												<cftry>
													<cfset xmldoc = xmlparse(rsAnexoXml.AnexoDef)>
							
													<cfset ExisteRangos1 = listFind(structkeylist(xmldoc['ss:WorkBook']),'ss:Names')>
							
							
													<cfquery name="rsAnexoCel" datasource="#session.DSN#">
														select AnexoRan 
														from AnexoCel
														where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#anexo#">
													</cfquery>
							
													<cfset cant = ArrayLen(xmldoc['ss:WorkBook']['ss:Names'].xmlChildren)>
													<cfset rsRangos = QueryNew("name")>
							
													<cfset temp = QueryAddRow(rsRangos,cant)>
													<cfloop index="i" from="1" to="#cant#">
														<cfset nombre = xmldoc['ss:WorkBook']['ss:Names'].xmlChildren[i].XmlAttributes['ss:Name'] >
														<cfset temp = QuerySetCell(rsRangos, "name", trim(nombre), i)>
													</cfloop>
							
													<cfset calcular = true >
													<cfloop query="rsAnexoCel">
														<cfquery name="rsRangos1" dbtype="query">
															select 1 
															from rsRangos
															where name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsAnexoCel.AnexoRan)#">
														</cfquery>
														<cfif rsRangos1.RecordCount eq 0>
															<cfset calcular = false >
															<cfbreak>
														</cfif>
													</cfloop>
												<cfcatch type="any">
													<cfset calcular =  false >
												</cfcatch>
												</cftry>
						
												<br>
												<table width="100%" cellpadding="0" cellspacing="0"  align="center">
													<tr><td align="center">
														<input type="Submit" name="Grabar" value="Grabar" onClick="javascript:GrabarAnexo(document.form1.AnexoId.value);">
														<cfif calcular ><input type="button" name="btnCalcular" value="Calcular" onClick="javascript:Calcular(document.form1.AnexoId.value);"></cfif>
														<input type="hidden" name="xmldata" value="">
														<input type="button" name="Definir" value="Definir" onClick="javascript:popUpDefinir(document.form1.AnexoId.value);">
													</td></tr>
												</table>
											</form>
						
											<cfif isdefined("form.AnexoId") and form.AnexoId neq "">
												<cfquery name="rsLeer" datasource="#Session.DSN#">
													select AnexoDef from Anexoim where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoId#">
												</cfquery>
												<cfif rsLeer.RecordCount NEQ 0>
													<script language="JavaScript">
														document.form1.grid.XMLdata="<cfoutput>#JSStringFormat(rsLeer.AnexoDef)#</cfoutput>";
													</script>
												</cfif>
											</cfif>
										</td>
									</tr>
									<cfif not calcular>
										<tr>
											<td align="center">
												<table width="70%" align="center" class="areaFiltro">
													<tr><td><font size="1"><strong>Error definiendo el Anexo Financiero.</strong></font></td></tr> 
													<tr><td>Hay elementos almacenados en la base de datos, que no tienen un elemento correspondiente en la hoja de c&aacute;lculo.</td></tr>
												</table>
												<br>
											</td>
										</tr>
									</cfif>

								</table><!--- 1 --->

							</td></tr>

						  </table>
					  <cf_web_portlet_end>	
				</td>	
			</tr>
		</table>	

		<iframe name="frAn" frameborder="0" src="procesarAnexo.cfm" width="0" height="0"></iframe>


		<script language="JavaScript1.2" type="text/javascript">
			<!-- Begin
			var popUpWin2 = 0;
			function popUpWindow(URLStr, wl, wt, ww, wh){
				if(popUpWin2){
					if(!popUpWin2.closed){
						popUpWin2.close();
					}	
				}
				popUpWin2 = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+ww+',height='+wh+',left='+wl+', top='+wt+',screenX='+wl+',screenY='+wt+'');
			}
			
			function popUpDefinir(Anexo) {
				GrabarAnexo(Anexo);
				popUpWindow("Definirdatos.cfm?form=form1&AnexoId="+Anexo,120,60,820,600);
			}
			
			function trim(dato) {
				dato = dato.replace(/^\s+|\s+$/g, '');
				return dato;
			}
			
			function Calcular(Anexo){
				<cfquery name="rsValidarPer1" datasource="#Session.DSN#">
					select Pvalor from Parametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and Pcodigo = 30
				</cfquery>
				
				<cfquery name="rsValidarPer2" datasource="#Session.DSN#">
					select Pvalor from Parametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and Pcodigo = 40
				</cfquery>
				
				var r1 = <cfoutput>#(trim(rsValidarPer1.Pvalor)*100)+rsValidarPer2.Pvalor#</cfoutput>;
				var r2 = eval((parseInt(trim(document.form1.Periodo.value))*100)+parseInt(trim(document.form1.Mes.value)));
				
				if (r2>r1) {
					alert('El período de cálculo seleccionado es superior al período Contable actual!');
					return;
				}
				
				var params = "?AnexoId="+trim(Anexo);
				params += "&PerP="+trim(document.form1.Periodo.value);
				params += "&MesP="+trim(document.form1.Mes.value);
				params += "&OcodigoP="+trim(document.form1.Ocodigo.value);
				params += "&McodigoP="+trim(document.form1.Mcodigo.value);
				document.getElementById('frAn').src="procesarAnexo.cfm"+params;
			}
			
			function CargarAnexo(AnexoId) {
				var params = "?AnexoId="+AnexoId;
				params += "&Leer=S";
				document.getElementById('frAn').src="procesarAnexo.cfm"+params;
				document.form1.submit();
			}
			
			function GrabarAnexo(AnexoId){
				document.form1.xmldata.value = document.form1.grid.XMLdata;
				document.form1.submit();
			}
			// End -->
		</script>

	<cf_templatefooter>


