<cf_templateheader title="Peajes">
<cf_templatecss>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Ingresos por Estación de Peaje'>
<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
<cfset Regresar = "/sif/af/MenuConsultasAF.cfm">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>	

<cfquery name="periodoAct" datasource="#session.dsn#">	
	select 	Pvalor ano 
	from 	Parametros 
	where 	Pcodigo = 30 and Ecodigo = #session.ECODIGO# 
</cfquery>
	
<cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">	
<form action="rptIngresoEstacionPeaje.cfm" method="get" name="form1" style="margin:0px;" onSubmit="return validar(this);">
	<table align="center" border="0" width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td valign="top" width="40%">
				<cf_web_portlet_start border="true" titulo="Reporte de Ingresos por Estación de Peaje" skin="info1">
					<p>En este reporte se muestra información  referente a los ingresos y cantidad de vehículos por estación de peaje. 
					Se  puede ver la información por periodos y meses o por días, se determine un  peaje, un turno, un tipo de vehículo inicial y 
					final para cada uno de los  anteriores. Además se puede ver el reporte detallado o resumido, y se puede escoger  si solo se quiere 
					ver la cantidad de vehículos o solo ver los montos e  inclusive se pueden escoger los dos.</p>
					<p align="justify">&nbsp;</p>
				<cf_web_portlet_end>
			</td>
			<td valign="top">
				<table border="0" width="100%">
					<tr>
						<td>
						<fieldset style="width:97%;">
						<legend style="font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:normal; font-weight:bolder;">Tipo De Consulta</legend>
							<input type="radio" name="tipoResumen" value="1" tabindex="1" checked onchange="requerido(this.value)">
								<label for="tipoResumen1" style="font-style:normal; font-variant:normal; font-weight:normal">Resumido</label>
							 <input type="radio" name="tipoResumen" value="2"  tabindex="1" onchange="requerido(this.value)">
								<label for="tipoResumen2" style="font-style:normal; font-variant:normal; font-weight:normal">Detallado por Documento</label>
						</fieldset>
						</td>
					</tr>
					<tr>
						<td>
							<fieldset style="width:97%;">
							<legend style="font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:normal; font-weight:bolder;">Parametros Filtro</legend>
								<table cellpadding="0" cellspacing="0" border="0">
									<tr>
										<td align="left"><input type="radio" name="TipoBus" value="1" onclick="Cambia(this.value)" checked="checked"/>Periodo</td>
										<td align="left"><input type="radio" name="TipoBus" value="2" onclick="Cambia(this.value)"/>Fecha</td>
									</tr>
									<tr>
										<td colspan="2">&nbsp;</td>
									</tr>
									<tr id="periodo">
										<td colspan="2">
											<table border="0" cellpadding="0" cellspacing="0">
												<tr>
													<td nowrap><strong>Periodo Inicial:</strong>&nbsp;</td>
													<td nowrap>
														<cfif isdefined("url.periodoInicial") and len(trim(url.periodoInicial))>								
															<cf_periodos name="periodoInicial" value="#url.periodoInicial#" tabindex="1">
														<cfelse>
															<cf_periodos name="periodoInicial" tabindex="1">
														</cfif>
													</td>
													<td>&nbsp;&nbsp;</td>
													<td nowrap><strong>Periodo Final:</strong>&nbsp;</td>
													<td nowrap>
														<cfif isdefined("url.periodoFinal") and len(trim(url.periodoFinal))>
															<cf_periodos name="periodoFinal" value="#url.periodoFinal#" tabindex="1">
														<cfelse>
															<cf_periodos name="periodoFinal" tabindex="1">
														</cfif>
													</td>
												</tr>
												<tr>
													<td nowrap><strong>Mes Inicial:</strong>&nbsp;</td>
													<td nowrap>
														<cfif isdefined("url.mesInicial") and len(trim(url.mesInicial))>
															<cf_meses name="mesInicial" value="#url.mesInicial#" tabindex="1">
														<cfelse>
															<cf_meses name="mesInicial" tabindex="1">
														</cfif>
													</td>
													<td>&nbsp;&nbsp;</td>
													<td nowrap><strong>Mes Final:</strong>&nbsp;</td>
													<td nowrap>
														<cfif isdefined("url.mesFinal") and len(trim(url.mesFinal))>
															<cf_meses name="mesFinal" value="#url.mesFinal#" tabindex="1">
														<cfelse>
															<cf_meses name="mesFinal" tabindex="1">
														</cfif>
													</td>
												</tr>
											</table>
										</td>
									</tr>		
									<tr id="fecha">
										<td colspan="2">
											<table border="0" cellpadding="0" cellspacing="0">
												<tr>
													<td nowrap><strong>Fecha Desde:&nbsp;&nbsp;</strong></td>
													<td nowrap><cf_sifcalendario name="Fechadesde" tabindex="1"></td>
													<td>&nbsp;&nbsp;</td>
													<td nowrap><strong>Fecha Hasta:&nbsp;&nbsp;</strong></td>
													<td nowrap><cf_sifcalendario name="Fechahasta" tabindex="1"></td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td align="center" colspan="2">
											<strong>Peajes:&nbsp;</strong>&nbsp;
										</td>
									</tr>
									<tr>
										<td colspan="2">
											<table border="0" cellpadding="0" cellspacing="0">
												<tr>
													<td>
														<strong>Desde:</strong>
													</td>
													<td align="left">
														<cf_conlis
														campos="Pidinicio, Pcodigoinicio, Pdescripcioninicio"
														desplegables="N,S,S"
														modificables="N,S,N"
														size="0,10,40"
														title="Lista de Peajes"
														tabla="Peaje"
														columnas="Pid as Pidinicio, Pcodigo as Pcodigoinicio, Pdescripcion as Pdescripcioninicio"
														filtro="Ecodigo=#SESSION.ECODIGO# order by Pid"
														desplegar="Pcodigoinicio, Pdescripcioninicio"
														filtrar_por="Pcodigo, Pdescripcion"
														etiquetas="Código, Descripción"
														formatos="S,S"
														align="left,left"
														asignar="Pidinicio, Pcodigoinicio, Pdescripcioninicio"
														asignarformatos="S, S, S"
														showEmptyListMsg="true"
														EmptyListMsg="-- No se encontraron Peajes --"
														tabindex="1">					
													</td>
												</tr>
												<tr>
													<td><strong>Hasta:</strong></td>
													<td>
														<cf_conlis
														campos="Pidfinal, Pcodigofinal, Pdescripcionfinal"
														desplegables="N,S,S"
														modificables="N,S,N"
														size="0,10,40"
														title="Lista de Peajes"
														tabla="Peaje"
														columnas="Pid as Pidfinal, Pcodigo as Pcodigofinal, Pdescripcion as Pdescripcionfinal"
														filtro="Ecodigo=#SESSION.ECODIGO# order by Pid"
														desplegar="Pcodigofinal, Pdescripcionfinal"
														filtrar_por="Pcodigo, Pdescripcion"
														etiquetas="Código, Descripción"
														formatos="S,S"
														align="left,left"
														asignar="Pidfinal, Pcodigofinal, Pdescripcionfinal"
														asignarformatos="S, S, S"
														showEmptyListMsg="true"
														EmptyListMsg="-- No se encontraron Peajes --"
														tabindex="1">					
													</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr id="turnos">
										<td colspan="2">
											<table border="0" width="100%">
												<tr><td align="center" colspan="4"><strong>Turnos:</strong></td></tr>
												<tr>
													<cf_dbfunction name="to_char" args="PThoraini/60" returnvariable = "hi">
													<cf_dbfunction name="to_char" args="PThoraini -(PThoraini/60)*60" returnvariable = "him">
													<cf_dbfunction name="to_char" args="PThorafin/60" returnvariable = "hf">
													<cf_dbfunction name="to_char" args="PThorafin -(PThorafin/60)*60" returnvariable = "hfm">
													<td><strong>Desde:</strong></td>
													<td><cf_conlis
														campos="PTidinicio, PTcodigoinicio,horainiI,horafinI"
														desplegables="N,S,N,N"
														modificables="N,S"
														size="0,10,0"
														title="Lista de Turnos"
														tabla="PTurnos"
														columnas="PTid as PTidinicio, PTcodigo as PTcodigoinicio, case when (PThoraini/60) < 10 then '0' #_Cat# #hi# else #hi# end #_Cat#':'#_Cat# case when PThoraini -(PThoraini/60)*60 < 10 then '0' #_Cat# #him# else #him# end as horainiI, case when (PThorafin/60) < 10 then '0' #_Cat# #hf# else #hf# end #_Cat#':'#_Cat# case when PThorafin -(PThorafin/60)*60 < 10 then '0' #_Cat# #hfm# else #hfm# end as horafinI"  
														filtro="Ecodigo=#SESSION.ECODIGO# order by PTid"
														desplegar="PTcodigoinicio, horainiI,horafinI"
														filtrar_por="PTcodigo, PThoraini,PThorafin"
														etiquetas="Código, Hora inicio, Hora fin"
														formatos="S,I,I"
														align="left,left,left"
														asignar="PTidinicio, PTcodigoinicio, horainiI,horafinI"
														asignarformatos="S, S,I,I"
														showEmptyListMsg="true"
														EmptyListMsg="-- No se encontro Tipo Turnos --"
														tabindex="1">			
													</td>
													<td><strong>Hasta:</strong></td>
													<td><cf_conlis
														campos="PTidfinal, PTcodigofinal,horainiF,horafinF"
														desplegables="N,S,N,N"
														modificables="N,S"
														size="0,10,0"
														title="Lista de Turnos"
														tabla="PTurnos"
														columnas="PTid as PTidfinal, PTcodigo as PTcodigofinal, case when (PThoraini/60) < 10 then '0' #_Cat# #hi# else #hi# end #_Cat#':'#_Cat# case when PThoraini -(PThoraini/60)*60 < 10 then '0' #_Cat# #him# else #him# end as horainiF, case when (PThorafin/60) < 10 then '0' #_Cat# #hf# else #hf# end #_Cat#':'#_Cat# case when PThorafin -(PThorafin/60)*60 < 10 then '0' #_Cat# #hfm# else #hfm# end as horafinF"
														filtro="Ecodigo=#SESSION.ECODIGO# order by PTid"
														desplegar="PTcodigofinal, horainiF,horafinF"
														filtrar_por="PTcodigo, PThoraini,PThorafin"
														etiquetas="Código, Hora inicio, Hora fin"
														formatos="S,I,I"
														align="left,left,left"
														asignar="PTidfinal, PTcodigofinal, horainiF,horafinF"
														asignarformatos="S, S,I,I"
														showEmptyListMsg="true"
														EmptyListMsg="-- No se encontro Tipo Turnos --"
														tabindex="1">						
													</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr><td align="center" colspan="2"><strong>Vehículos:&nbsp;</strong>&nbsp;</td></tr>
									<tr>
										<td><strong>Desde:&nbsp;&nbsp;</strong></td>
										<td><cf_conlis
												Campos="PVidinicio,PVcodigoinicio,PVdescripcioninicio"
												Desplegables="N,S,S"
												Modificables="N,S,N"
												Size="0,15,35"
												Title="Lista de Vehiculos"
												Tabla="PVehiculos"
												Columnas="PVid as PVidinicio,PVcodigo as PVcodigoinicio, PVdescripcion as PVdescripcioninicio"
												Filtro="Ecodigo = #Session.Ecodigo# order by PVid"
												Desplegar="PVcodigoinicio,PVdescripcioninicio"
												filtrar_por="PVcodigo,PVdescripcion"
												Etiquetas="Codigo,Descripcion"
												Formatos="S,S"
												Align="left,left"
												Asignar="PVidinicio,PVcodigoinicio,PVdescripcioninicio"
												Asignarformatos="I,S,S"
												showEmptyListMsg="true"
												EmptyListMsg="-- No se encontro Tipo Turnos --"
												tabindex="6"/>	
										</td>
									</tr>
									<tr>
										<td><strong>Hasta:&nbsp;&nbsp;</strong></td>
										<td><cf_conlis
												Campos="PVidfinal,PVcodigofinal,PVdescripcionfinal"
												Desplegables="N,S,S"
												Modificables="N,S,N"
												Size="0,15,35"
												Title="Lista de Vehiculos"
												Tabla="PVehiculos"
												Columnas="PVid as PVidfinal,PVcodigo as PVcodigofinal, PVdescripcion as PVdescripcionfinal"
												Filtro="Ecodigo = #Session.Ecodigo# order by PVid"
												Desplegar="PVcodigofinal,PVdescripcionfinal"
												filtrar_por="PVcodigo,PVdescripcion"
												Etiquetas="Codigo,Descripcion"
												Formatos="S,S"
												Align="left,left"
												Asignar="PVidfinal,PVcodigofinal,PVdescripcionfinal"
												Asignarformatos="I,S,S"
												showEmptyListMsg="true"
												EmptyListMsg="-- No se encontro Tipo Turnos --"
												tabindex="6"/>				
										</td>
									</tr>
									<tr>
										<td><strong>Monto</strong><input type="checkbox" name="monto" value="ok" /></td>
										<td><strong>Cantidad</strong><input type="checkbox" name="cantidad" checked="checked" value="ok" /></td>
									</tr>
									<tr><td colspan="24"><cf_botones values="Generar, Limpiar" names="Generar, Limpiar" tabindex="1" ></td></tr>
							</table>
						</fieldset>
					</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>

<cf_qforms form="form1">
<script language="javascript1" type="text/javascript">


	objForm.Pcodigoinicio.description = "Peaje inicial";
	objForm.Pcodigofinal.description = "Peaje final";
	objForm.PTcodigoinicio.description = "tipo de turno inicial";
	objForm.PTcodigofinal.description = "tipo de turno final";
	objForm.PVcodigoinicio.description = "tipo de vehiculo inicial";
	objForm.PVcodigofinal.description = "tipo de vehiculo final";
	
	objForm.Fechadesde.description = "fecha desde";
	objForm.Fechahasta.description = "fecha hasta";
	
	<!---objForm.periodoInicial.description = "Periodo Inicial";
	objForm.periodoFinal.description = "Periodo Final";
	objForm.periodoInicial.required = true;
	objForm.periodoFinal.required = true;--->
	
	objForm.Pcodigoinicio.required = true;
	objForm.Pcodigofinal.required = true;
	objForm.PVcodigoinicio.required = true;
	objForm.PVcodigofinal.required = true;
	
	function requerido(valor){
		turnos = document.getElementById('turnos')
		if(valor == '1'){
			objForm.PTcodigoinicio.required = false;
			objForm.PTcodigofinal.required = false;
			turnos.style.display = "none";
		}else if(valor == '2'){
			objForm.PTcodigoinicio.required = true;
			objForm.PTcodigofinal.required = true;
			turnos.style.display = "";
		}
	}

	function fnFechaYYYYMMDD (LvarFecha)
	{
		return LvarFecha.substr(6,4)+LvarFecha.substr(3,2)+LvarFecha.substr(0,2);
	}
	
	function validar(form1){
		if (fnFechaYYYYMMDD(document.form1.Fechadesde.value) > fnFechaYYYYMMDD(document.form1.Fechahasta.value))
		{
			alert ("La Fecha Inicial debe ser menor a la Fecha Final");
			return false;
		}
	}    
	function Cambia(valor){
		if(valor == '1'){
			document.getElementById('periodo').style.display = "";
			document.getElementById('fecha').style.display = "none";
			objForm.Fechadesde.required = false;
			objForm.Fechahasta.required = false;
		}else if(valor == '2'){
			document.getElementById('periodo').style.display = "none";
			document.getElementById('fecha').style.display = "";
			objForm.Fechadesde.required = true;
			objForm.Fechahasta.required = true;
		}
			
		document.form1.Fechadesde.value = "";
		document.form1.Fechahasta.value = "";
	} 
	
	radioObj = document.form1.TipoBus;
	for(var i = 0; i < radioObj.length; i++) {
		if(radioObj[i].checked)
			Cambia(radioObj[i].value);
	}
	
	radioObj = document.form1.tipoResumen;
	for(var i = 0; i < radioObj.length; i++) {
		if(radioObj[i].checked)
			requerido(radioObj[i].value);
	}
	
</script>

	<cf_web_portlet_end>
<cf_templatefooter>