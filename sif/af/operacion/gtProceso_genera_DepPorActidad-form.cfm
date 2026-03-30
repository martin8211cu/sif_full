<cfset LvarPar = ''>
<cfif isdefined("session.LvarJA") and session.LvarJA>
	<cfset LvarPar = '_JA'>
<cfelseif isdefined("session.LvarJA") and not session.LvarJA>
	<cfset LvarPar = '_Aux'>
</cfif>

<!--- Categorias --->
<cfquery name="rsCategorias" datasource="#Session.DSN#">
	select ACcodigo, <cf_dbfunction name="concat" args="ACcodigodesc,'-',ACdescripcion" > as ACdescripcion, ACmascara
		from ACategoria 
		where Ecodigo = #session.Ecodigo#
	order by 2
</cfquery>
<!--- Oficinas --->
<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select Ocodigo, <cf_dbfunction name="concat" args="Oficodigo,'-',Odescripcion" > as Odescripcion 
		from Oficinas 
		where Ecodigo = #session.Ecodigo#
	order by 2                      
</cfquery>
<!--- Departamentos --->
<cfquery name="rsDepartamentos" datasource="#Session.DSN#">
	select Dcodigo, Ddescripcion from Departamentos 
	where Ecodigo = #session.Ecodigo#
	order by Dcodigo
</cfquery>
<!--- Clases se llenan automticamente cuando cambia la categoria.--->
<cfquery name="rsClases" datasource="#Session.DSN#">
	select a.ACcodigo, a.ACid, <cf_dbfunction name="concat" args="a.ACcodigodesc,'-',a.ACdescripcion" > as ACdescripcion, a.ACdepreciable, a.ACrevalua
		from AClasificacion a
	where a.Ecodigo = #session.Ecodigo#
</cfquery>
<!---Incluye API de Qforms--->
<script language="JavaScript1.2" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<cfflush interval="20">

<form name="fagtproceso" id="fagtproceso" method="post" action="gtProceso_sql_DepPorActidad<cfoutput>#LvarPar#</cfoutput>.cfm">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td align="center">	
				<table width="0%" align="center"  border="0" cellspacing="0" cellpadding="0">
					
					<tr>
						<td>
							<fieldset><legend>Informaci&oacute;n requerida</legend>
								<!---Descripción--->
								<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td><strong>Descripción&nbsp;:&nbsp;</strong></td>
									    <td>&nbsp;&nbsp;</td>
									     <td><input name="AGTPdescripcion" type="text" size="60" maxlength="80" readonly="true" tabindex="1"></td>
								    </tr>
							    </table>
						   </fieldset>
						   <br>
						   <fieldset><legend>Informaci&oacute;n para filtrar la generación</legend>
								<!---Categoria--->
								<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td><strong>Categoría&nbsp;:&nbsp;</strong></td>
										<td>&nbsp;&nbsp;</td>
										<td>
											<select name="FACcodigo" onChange="javascript:AgregarCombo(this);setDescripcion();" tabindex="1">
											<option value="">Todos</option>
											<cfoutput query="rsCategorias">
												<option value="#Trim(rsCategorias.ACcodigo)#">#rsCategorias.ACdescripcion#</option>
											</cfoutput>
											</select>
										</td>
									</tr>
								<!---Clase--->
									<tr>
										<td><strong>Clase&nbsp;:&nbsp;</strong></td>
										<td>&nbsp;&nbsp;</td>
										<td><select name="FACid" onChange="javascript:setDescripcion();" tabindex="1"></select></td>
									</tr>
									<tr>
										<td><strong>Oficina&nbsp;:&nbsp;</strong></td>
										<td>&nbsp;&nbsp;</td>
										<td>
											<select name="FOcodigo" onChange="javascript:limpiarCentroF();setDescripcion();" tabindex="1">
											<option value="">Todos</option>
											<cfoutput query="rsOficinas"> 
												<option value="#rsOficinas.Ocodigo#">#rsOficinas.Odescripcion#</option>
											</cfoutput>
											</select>
										</td>
									</tr>
								<!---Departamento--->	
									<tr>
										<td><strong>Departamento&nbsp;:&nbsp;</strong></td>
										<td>&nbsp;&nbsp;</td>
										<td>
											<select name="FDcodigo" onChange="javascript:limpiarCentroF();setDescripcion();" tabindex="1">
											<option value="">Todos</option>
											<cfoutput query="rsDepartamentos"> 
												<option value="#rsDepartamentos.Dcodigo#">#rsDepartamentos.Ddescripcion#</option>
											</cfoutput>
											</select>
										</td>
									</tr>
								<!---Centro Funcional--->
									<tr>
										<td><strong>Centro Funcional&nbsp;:&nbsp;</strong></td>
										<td>&nbsp;&nbsp;</td>
										<td>
											<cf_conlis 
											form="fagtproceso" 
											campos="FCFid,FCFcodigo,FCFdescripcion" 
											desplegables="N,S,S"
											modificables="N,S,S"
											size="0,10,30"
											title="Lista de Centros Funcionales"
											tabla="CFuncional"
											columnas="CFid as FCFid, CFcodigo as FCFcodigo, CFdescripcion as FCFdescripcion"
											filtro="Ecodigo = #session.Ecodigo# order by CFpath, CFcodigo, CFnivel"
											desplegar="FCFcodigo,FCFdescripcion"
											filtrar_por="CFcodigo,CFdescripcion"
											etiquetas="Código, Descripción"
											formatos="S,S"
											align="left,left"
											asignar="FCFid,FCFcodigo,FCFdescripcion"
											asignarformatos="I,S,S"
											maxrowsquery="250"
											funcion="setDescripcion" 
											tabindex="1">
										</td>
									</tr>
								<!---Tipo de Activo--->
									<tr>
										<td><strong>Tipo&nbsp;:&nbsp;</strong></td>
										<td>&nbsp;&nbsp;</td>
										<td><cf_siftipoactivo form="fagtproceso" id="FAFCcodigo" tabindex="1"></td>
									</tr>
								<!---Activo Inicial--->
									<tr>
										<td><strong>Activo Inicial&nbsp;:&nbsp;</strong></td>
										<td>&nbsp;&nbsp;</td>
										<td><cf_sifactivo name="AidDesde" placa="AplacaDesde" desc="AdescripcionDesde" tabindex="1"
							                    frame="frocupacionDesde" form= "fagtproceso" MetodoDep="3" funcion ="setDescripcion" ></td>
									</tr>
								<!---Activo Final--->
									<tr>
										<td><strong>Activo Final&nbsp;:&nbsp;</strong></td>
										<td>&nbsp;&nbsp;</td>
										<td><cf_sifactivo name="AidHasta" placa="AplacaHasta" desc="AdescripcionHasta" tabindex="1"
								                frame="frocupacionHasta" form= "fagtproceso" MetodoDep="3" funcion ="setDescripcion"></td>
									</tr>
							</table>
							</fieldset>
							<br>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr><td>&nbsp;</td>	</tr>
		<tr><td align="center">	<cf_botones form="fagtproceso" values="Generar, Regresar" tabindex="1"> </td></tr>
	</table>
</form>

<!---funciones en javascript de los botones--->
<script language="javascript" type="text/javascript">

	function funcRegresar(){
		<cfoutput>
			document.fagtproceso.action = "agtProceso_DEPRECIACION#LvarPar#.cfm";
		</cfoutput>
		deshabilitarValidacion();
	}


	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	qFormAPI.include("*");
	qFormAPI.errorColor = "#FFFFCC";
	qffagtproceso = new qForm("fagtproceso");

	function AgregarCombo(codigo) {
		var combo = document.fagtproceso.FACid;
		var cont = 0;
		codigo = codigo.value;
		combo.length=0;
		combo.length=cont+1;
		combo.options[cont].value='';
		combo.options[cont].text='Todos';
		cont++;
		<cfoutput query="rsClases">
			if ('#Trim(rsClases.ACcodigo)#'==codigo) 
			{
				combo.length=cont+1;
				combo.options[cont].value='#rsClases.ACid#';
				combo.options[cont].text='#rsClases.ACdescripcion#';
				cont++;
			};
		</cfoutput>
	}
	function limpiarCentroF(){
		var form = document.fagtproceso;
		form.FCFid.value = "";
		form.FCFcodigo.value = "";
		form.FCFdescripcion.value = "";
	}
	function habilitarValidacion(){
		qffagtproceso.AGTPdescripcion.required = true;
	}
	function deshabilitarValidacion(){
		qffagtproceso.AGTPdescripcion.required = false;
	}
	
	function _qfinit(){
		habilitarValidacion();
		<cfoutput>
		qffagtproceso.AGTPdescripcion.description = "#JSStringFormat('Descripción')#";
		</cfoutput>
	}
	function getCatDesc(lValue){
		<cfoutput query="rsCategorias">
			if (lValue!=""&&lValue==#ACcodigo#) {return "#HTMLEditFormat(ACdescripcion)#";}
		</cfoutput>
	}
	function getClsDesc(lValue){
		<cfoutput query="rsClases">
			if (lValue!=""&&lValue==#ACid#) {return "#HTMLEditFormat(ACdescripcion)#";}
		</cfoutput>
	}
	function getOfiDesc(lValue){
		<cfoutput query="rsOficinas">
			if (lValue!=""&&lValue==#Ocodigo#) {return "#HTMLEditFormat(Odescripcion)#";}
		</cfoutput>
	}
	function getDptDesc(lValue){
		<cfoutput query="rsDepartamentos">
			if (lValue!=""&&lValue==#Dcodigo#) {return "#HTMLEditFormat(Ddescripcion)#";}
		</cfoutput>
	}
	function setDescripcion(){
		var form = document.fagtproceso;
		var lDescObj = form.AGTPdescripcion;
		var lDescObjAnt = lDescObj.value;
		var lDescObjAux = "";
		var lTransDescr = "";
		var lFiltrosAux = "";
		<cfoutput>
			//Define el tipo de transaccin
			lTransDescr = "Dep x Actividad";
			//Define los filtro si estn definidos
			if (form.FACcodigo.value!="")
				lFiltrosAux = lFiltrosAux + ", " + getCatDesc(form.FACcodigo.value);
			if (form.FACid.value!="")
				lFiltrosAux = lFiltrosAux + ", " + getClsDesc(form.FACid.value);
			if (form.FOcodigo.value!="")
				lFiltrosAux = lFiltrosAux + ", " + getOfiDesc(form.FOcodigo.value);
			if (form.FDcodigo.value!="")
				lFiltrosAux = lFiltrosAux + ", " + getDptDesc(form.FDcodigo.value);
			if (form.FCFid.value!="")
				lFiltrosAux = lFiltrosAux + ", " + form.FCFdescripcion.value;
			if (form.FAFCcodigo.value!="")
				lFiltrosAux = lFiltrosAux + ", " + form.AFCdescripcion.value;
			if (form.AplacaDesde.value!="")
				lFiltrosAux = lFiltrosAux + ", Desde:" + form.AplacaDesde.value;
			if (form.AplacaHasta.value!="")
				lFiltrosAux = lFiltrosAux + ", Hasta:" + form.AplacaHasta.value;
			lDescObjAux = lTransDescr + (lFiltrosAux.length>0?lFiltrosAux:" Total");
		</cfoutput>
		lDescObj.value = lDescObjAux;
	}
	function _forminit(){
		var form = document.fagtproceso;
		AgregarCombo(form.FACcodigo);
		_qfinit()
		setDescripcion();
		qffagtproceso.FACcodigo.obj.focus();
	}
	function funcAFCcodigoclas(){
		setDescripcion();
	}
	_forminit();
</script>