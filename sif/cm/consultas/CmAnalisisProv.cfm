<!--- Combo de tipos de documentos --->
<cfquery name="rsTipos" datasource="#session.DSN#">
	select CMTid, CMTdesc
	from CMTipoAnalisis
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by CMTid
</cfquery>

<cfset annoActual = DatePart("yyyy", #now()#)>
<cfset annoinicio = annoActual - 5>

<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<cf_templateheader title="Análisis de proveedores">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Análisis de proveedores'>
			<cfinclude template="../../portlets/pNavegacionCM.cfm">
			<cfoutput>
			<form name="form1" action="RepCmAnalisisProv-vista.cfm" method="post">
				<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
					<tr>
						<!--- Socio de negocios --->
						<td align="right" nowrap class="fileLabel">
							<strong>Socio de Negocios:&nbsp;</strong>
						</td>
						<td nowrap class="fileLabel">
							<cf_sifsociosnegocios2  form="form1" sntiposocio="P" sncodigo="SNcodigo" snnumero="SNnumero" frame="frame1">
						</td>
						<!--- Comprador --->
						<td align="right" nowrap class="fileLabel">
							<strong>Comprador:&nbsp;</strong>
						</td>
						<td nowrap class="fileLabel">
							<input type="text" name="CMCcodigo1" maxlength="10" value="" size="10" onBlur="javascript:comprador(this.value);">
							<input type="text" name="CMCnombre1" id="CMCnombre1" readonly value="" size="40" maxlength="80">
							<input type="hidden" name="CMCid1" id="CMCid1" value="">
							<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Compradores" name="imagen2" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisCompradores();'></a>
						</td>
						<!--- Consultar --->
						<td rowspan="5" valign="middle"><input type="submit" name="btnFiltro" value="Consultar"></td>
					</tr>
					<tr>
						<!--- Clasificación de artículos --->
						<td align="right" class="fileLabel" nowrap>
							<strong>Clasificación artículos:&nbsp;</strong>
						</td>
						<td align="left" class="fileLabel" nowrap>
							<cf_sifclasificacionarticulo form="form1">
						</td>
						<!--- Clasificación de conceptos --->
						<td align="right" class="fileLabel" nowrap>
							<strong>Clasificación conceptos:&nbsp;</strong>
						</td>
						<td align="left" class="fileLabel" nowrap>
							<cf_sifclasificacionconcepto form="form1">
						</td>
					</tr>
					<tr>
						<!--- Anio inicial --->
						<td align="right" class="fileLabel" nowrap>
							<strong>&nbsp;A&ntilde;o Inicial:&nbsp;</strong>
						</td>
						<td class="fileLabel" nowrap>
							<select name="AnnoIni">
								<cfloop from="#annoinicio#" to ="#annoActual#" index="i">
									<option value="#i#"<cfif i eq annoActual> selected</cfif>>#i#</option>
								</cfloop>
							</select>
						</td>
						<!--- Mes inicial --->
						<td align="right" class="fileLabel" nowrap>
							<strong>Mes Inicial :&nbsp;</strong>
						</td>
						<td align="left" class="fileLabel" nowrap>
							<select name="MesIni">
								<option value="1" selected> Enero</option>
								<option value="2"> Febrero</option>
								<option value="3"> Marzo</option>
								<option value="4"> Abril</option>
								<option value="5"> Mayo</option>
								<option value="6"> junio</option>
								<option value="7"> Julio</option>
								<option value="8"> Agosto</option>
								<option value="9"> Setiembre</option>
								<option value="10"> Octubre</option>
								<option value="11"> Noviembre</option>
								<option value="12"> Diciembre</option>
							</select>
						</td>
					</tr>
					<tr>
						<!--- Anio final --->
						<td align="right" class="fileLabel" nowrap>
							<strong>&nbsp;A&ntilde;o Final:&nbsp;</strong>
						</td>
						<td align="left" class="fileLabel" nowrap>
							<select name="AnnoFin">
								<cfloop from="#annoinicio#" to ="#annoActual#" index="i">
									<option value="#i#"<cfif i eq annoActual> selected</cfif>>#i#</option>
								</cfloop>
							</select>
						</td>
						<!--- Mes final --->
						<td align="right" class="fileLabel" nowrap>
							<strong>Mes Final :&nbsp;</strong>
						</td>
						<td align="left" class="fileLabel" nowrap>
							<select name="MesFin">
								<option value="1"> Enero</option>
								<option value="2"> Febrero</option>
								<option value="3"> Marzo</option>
								<option value="4"> Abril</option>
								<option value="5"> Mayo</option>
								<option value="6"> junio</option>
								<option value="7"> Julio</option>
								<option value="8"> Agosto</option>
								<option value="9"> Setiembre</option>
								<option value="10"> Octubre</option>
								<option value="11"> Noviembre</option>
								<option value="12" selected> Diciembre</option>
							</select>
						</td>
					</tr>
					<tr>
						<!--- Tipo de análisis --->						
						<td align="right" nowrap class="fileLabel">
							<strong>Tipo de análisis:&nbsp;</strong>
						</td>
						<td nowrap class="fileLabel">
						  <select name="CMTid" tabindex="1">
							  <cfloop query="rsTipos">
								<option value="#rsTipos.CMTid#">#rsTipos.CMTdesc#</option>
							  </cfloop>
							</select>
						</td>
						<!--- Agrupación del reporte --->
						<td align="right" class="fileLabel" nowrap>
							<strong>Agrupar reporte por:&nbsp;</strong>
						</td>
						<td align="left" class="fileLabel" nowrap>
							<select name="AgruparPor">
								<option value="1" selected>Mes</option>
								<option value="2" >Trimestre</option>
								<option value="3" >Semestre</option>
								<option value="4" >Año</option>
							</select>
						</td>
					</tr>
				</table>
			</form>
			</cfoutput>	
			<cf_qforms>
			
			<!--- Frame para el conlis de compradores --->
			<iframe name="frCompradores" id="frCompradores" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>
			
			<script language='javascript' type='text/JavaScript'>
				objForm.SNnumero.required = true;
				objForm.SNnumero.description="Socio de Negocios";	
				objForm.CMTid.required = true;
				objForm.CMTid.description="Tipo de análisis";	
			</script>
			<script language='javascript' type='text/JavaScript'>
				var popUpWin = 0;
				function popUpWindow(URLStr, left, top, width, height){
					if(popUpWin){
						if(!popUpWin.closed) popUpWin.close();
					}
					popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
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
		<cf_web_portlet_end>
	<cf_templatefooter>
