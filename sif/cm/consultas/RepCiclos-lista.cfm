<script language="JavaScript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<!--- Asociación de Tipos de solicitud por Centro Funcional --->
<cfquery name="rsTipos" datasource="#session.DSN#">
	select b.CMTScodigo, <cf_dbfunction name="sPart" args="b.CMTScodigo #_Cat# ' - ' #_Cat# b.CMTSdescripcion; 1; 40" delimiters=";"> as CMTSdescripcion
	from CMTiposSolicitud b
	where b.Ecodigo= #session.Ecodigo#
	order by b.CMTScodigo
</cfquery>

<cfset solicitante = Session.compras.solicitante>
<cfset annoActual = DatePart("yyyy",#now()#)>
<cfset annoinicio = annoActual - 5>

<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>

<cf_templateheader title="Compras - Consulta ciclos de compra">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta ciclos de compra'>

			<cfoutput>
			<form name="form1" method="post" action="RepCiclos-vista.cfm" style="margin: 0" onSubmit="javascript: return Valida();">
				<input name="ESidsolicitud" type="hidden" value="">
				<input type="hidden" name="CMSid" value="#solicitante#">
				<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
				<tr><td colspan="2"><cfinclude template="/sif/portlets/pNavegacion.cfm"></td></tr>
				<tr>
					<!--- Información del reporte --->
					<td width="50%">
						<table width="100%">
							<tr>
								<td valign="top">
									<cf_web_portlet_start border="true" titulo="Consulta ciclos de compra" skin="info1">
										<div align="justify">
											<p> 
											En este reporte se muestran los ciclos de compra comprendidos entre:<br> 
											 <br>
											 <strong>Ciclo A:</strong> Confección de solicitud de compra y fin del trámite	<br>										
											 <strong>Ciclo B:</strong> Aprobación de solicitud y publicación <br>	
											 <strong>Ciclo C:</strong> Publicación y vencimiento de recepción de ofertas<br>
											 <strong>Ciclo D:</strong> Fecha máxima de publicación y registro de la orden de compra<br>
											 <strong>Ciclo E:</strong> Aplicación de la orden de compra y su aprobación<br>
											 <strong>Ciclo F:</strong> Fecha estimada de recepci&oacute;n y fecha de aplicaci&oacute;n de la recepci&oacute;n<br><br>
											Para un centro funcional en un rango de meses y años seleccionados
											</p>
										</div>
									<cf_web_portlet_end>
								</td>
							</tr>
						</table>
					</td>
					
					<!--- Filtros del reporte --->
					<td width="50%" valign="top">
						<table width="100%" cellpadding="2" cellspacing="4" align="center">
							<!--- Centro funcional --->
							<tr>
								<td align="right" nowrap><strong>Centro Funcional:</strong>&nbsp;</td>
							  	<td nowrap>
									<input type="hidden" name="CFid" value="">
									<input type="text" name="CFcodigo" id="CFcodigo" value="" onblur="javascript: TraeCFuncional(this); " size="10" maxlength="10" onfocus="javascript:this.select();">
									<input type="text" name="CFdescripcion" id="CFdescripcion" disabled value="" size="30" maxlength="80">
									<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Centros Funcionales" name="CFimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisCFuncional();'></a>
								</td>
							</tr>
							<!--- Comprador --->
							<tr>
								<td align="right" nowrap>
									<strong>Comprador:&nbsp;</strong>
								</td>
								<td nowrap>
									<input type="text" name="CMCcodigo1" maxlength="10" value="" size="10" onBlur="javascript:comprador(this.value);">
									<input type="text" name="CMCnombre1" id="CMCnombre1" readonly value="" size="40" maxlength="80">
									<input type="hidden" name="CMCid1" id="CMCid1" value="">
									<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Compradores" name="imagen2" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisCompradores();'></a>
								</td>
							</tr>
							<!--- Clasificación de artículos --->
							<tr>
								<td align="right" nowrap>
									<strong>Clasificación artículos:&nbsp;</strong>
								</td>
								<td align="left" nowrap>
									<cf_sifclasificacionarticulo form="form1">
								</td>
							</tr>
							<!--- Clasificación de conceptos --->
							<tr>
								<td align="right" nowrap>
									<strong>Clasificación conceptos:&nbsp;</strong>
								</td>
								<td align="left" nowrap>
									<cf_sifclasificacionconcepto form="form1">
								</td>
							</tr>
							<!--- Fecha desde --->
							<tr>
								<td align="right" nowrap><strong>Desde:</strong>&nbsp;</td>
								<td>
									<table>
										<tr>
											<!--- Mes desde --->
											<td>
												 <select name="mesIni" id="mesIni">
													<option value="">(Mes)</option>
													<option value="1">Enero</option>
													<option value="2">Febrero</option>
													<option value="3">Marzo</option>
													<option value="4">Abril</option>
													<option value="5">Mayo</option>
													<option value="6">Junio</option>
													<option value="7">Julio</option>
													<option value="8">Agosto</option>
													<option value="9">Septiembre</option>
													<option value="10">Octubre</option>
													<option value="11">Noviembre</option>
													<option value="12">Diciembre</option>
												  </select>
											</td>
											<!--- Año desde --->
											<td>
												<select name="anoIni" id="anoIni">
													<option value="">(a&ntilde;o)</option>
													<cfloop from="#annoinicio#" to="#year(now())#" index="i">
														<option value="#i#">#i#</option>
													</cfloop>
												 </select>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<!--- Fecha hasta --->
							<tr>
								<td align="right" nowrap><strong>Hasta:</strong>&nbsp;</td>
								<td>
									<table>
										<tr>
											<!--- Mes fin --->
											<td>
												 <select name="mesFin" id="mesFin">
													<option value="">(Mes)</option>
													<option value="1">Enero</option>
													<option value="2">Febrero</option>
													<option value="3">Marzo</option>
													<option value="4">Abril</option>
													<option value="5">Mayo</option>
													<option value="6">Junio</option>
													<option value="7">Julio</option>
													<option value="8">Agosto</option>
													<option value="9">Septiembre</option>
													<option value="10">Octubre</option>
													<option value="11">Noviembre</option>
													<option value="12">Diciembre</option>
												  </select>
											</td>
											<!--- Año fin --->
											<td>
												<select name="anoFin" id="anoFin">
													<option value="">(a&ntilde;o)</option>
													<cfloop from="#annoinicio#" to="#year(now())#" index="i">
														<option value="#i#">#i#</option>
													</cfloop>
												 </select>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<!--- Tipos de solicitud --->
							<tr>
								<td align="right" nowrap><strong>Tipo de solicitud:</strong>&nbsp;</td>
								<td>
									<select name="cod_CMTScodigo" tabindex="1">
										<option value="Todos" selected>Todos</option>
										<cfloop query="rsTipos">
											<option value="#rsTipos.CMTScodigo#">#rsTipos.CMTSdescripcion#</option>
										</cfloop>
									</select>
								</td>
							</tr>
							<!--- Agrupación del reporte --->
							<tr>
								<td align="right" nowrap><strong>Agrupar reporte por:</strong>&nbsp;</td>
								<td>
									<select name="AgruparPor">
										<option value="1" selected>Mes</option>
										<option value="2" >Trimestre</option>
										<option value="3" >Semestre</option>
										<option value="4" >Año</option>
									</select>
								</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
							</tr>
							<!--- Consultar --->
							<tr align="center">
								<td align="center" colspan="2">
									<input type="submit" name="btnConsultar" value="Consultar">
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			</form>
			</cfoutput>		
			<script language="JavaScript" type="text/javascript">	
				function Valida(){					
					if(document.form1.CFid.value == ''){
						alert("Debe seleccionar un centro funcional");
						return false;
					}
					if(document.form1.mesIni.value == '' && document.form1.anoIni.value == ''){
						alert("Debe seleccionar un mes y año inicial");
						return false;
					}
					if(document.form1.mesFin.value == '' && document.form1.anoFin.value == ''){
						alert("Debe seleccionar un mes y año final");
						return false;
					}
					if(document.form1.anoFin.value == '' && document.form1.anoFin.value == ''){
						alert("Debe seleccionar un mes y año final");
						return false;
					}
					if(document.form1.anoIni.value == '' && document.form1.anoIni.value == ''){
						alert("Debe seleccionar un mes y año inicial");
						return false;
					}	
					if (parseInt(document.form1.anoFin.value) < parseInt(document.form1.anoIni.value)){
						alert("El año final debe ser mayor que el año inicial");
						return false;
					}	
					if (document.form1.anoFin.value == document.form1.anoIni.value){
						if (parseInt(document.form1.mesFin.value) < parseInt(document.form1.mesIni.value)){
							alert("La fecha desde no puede ser mayor a la fecha hasta")
							return false;
						}
					}		
					return true;					
				}			
				
				var popUpWin = 0;
				function popUpWindow(URLStr, left, top, width, height){
					if(popUpWin){
						if(!popUpWin.closed) popUpWin.close();
					}
					popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
				}
				
				//Obtiene la descripción con base al código
				function TraeCFuncional(dato) {
					var params ="";
					params = "&CMSid=<cfoutput>#solicitante#</cfoutput>&id=CFid&name=CFcodigo&desc=CFdescripcion";
					if (dato.value != "") {
						document.getElementById("fr").src="/cfmx/sif/cm/operacion/cfuncionalquery.cfm?dato="+dato.value+"&form=form1"+params;
					}
					else{
						document.form1.CFid.value = "";
						document.form1.CFcodigo.value = "";
						document.form1.CFdescripcion.value = "";
					}
					return;
				}
				
				function doConlisCFuncional(){
					var params ="";
					params = "?CMSid=<cfoutput>#solicitante#</cfoutput>&form=form1&id=CFid&name=CFcodigo&desc=CFdescripcion";
					popUpWindow("/cfmx/sif/cm/operacion/ConlisCFuncional.cfm"+params,250,200,650,400);
				}

				//Conlis de compradores 
				function doConlisCompradores(){
					var params = "";
						params = "?formulario=form1&CMCid=CMCid1&CMCcodigo=CMCcodigo1&desc=CMCnombre1";
					popUpWindow("/cfmx/sif/cm/consultas/ConlisCompradoresConsulta.cfm"+params,250,200,650,400);
				}
				
				function comprador(value){
					if (value != ''){
						document.getElementById("frCompradores").src = "/cfmx/sif/cm/consultas/CompradoresConsulta.cfm?formulario=form1&CMCcodigo="+value+"&opcion=1";
					}
					else{
						document.form1.CMCid1.value = '';
						document.form1.CMCcodigo1.value = '';
						document.form1.CMCnombre1.value = '';
					}
				}
			</script>	
			<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="10" width="10" scrolling="auto" src=""></iframe>
			<!--- Frame para el conlis de compradores --->
			<iframe name="frCompradores" id="frCompradores" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src=""></iframe>
		<cf_web_portlet_end>
	<cf_templatefooter>