<cfset LvarPar = ''>
<cfif isdefined("session.LvarJA") and session.LvarJA>
	<cfset LvarPar = '_JA'>
<cfelseif isdefined("session.LvarJA") and not session.LvarJA>
	<cfset LvarPar = '_Aux'>
</cfif>

<cfset fnParametros_AGT()>
<!---Incluye API de Qforms--->
<script language="JavaScript1.2" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<cfflush interval="20">
<!--- filtro--->
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td align="center">	
			<table width="0%" align="center"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<fieldset><legend>Informaci&oacute;n requerida</legend>
							<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td><strong>Descripci&oacute;n&nbsp;:&nbsp;</strong></td>
									<td>&nbsp;&nbsp;</td>
									<td><input name="AGTPdescripcion" type="text" size="60" maxlength="80" readonly="true" tabindex="1">
									</td>
								</tr>
							</table>
						</fieldset>
						<br>
						<fieldset><legend>Informaci&oacute;n para filtrar la generaci&oacute;n</legend>
							<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td><strong>Categor&iacute;a&nbsp;:&nbsp;</strong></td>
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
								<tr>
									<td><strong>Clase&nbsp;:&nbsp;</strong></td>
									<td>&nbsp;&nbsp;</td>
									<td>
										<!--- Las opciones se defininen dinmicamente cuando cambia la categora --->
										<select name="FACid" onChange="javascript:setDescripcion();" tabindex="1"></select>
									</td>
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
								<tr>
									<td><strong>Tipo&nbsp;:&nbsp;</strong></td>
									<td>&nbsp;&nbsp;</td>
									<td><cf_siftipoactivo form="fagtproceso" id="FAFCcodigo" tabindex="1"></td>
								</tr>
							</table>
						</fieldset>
						<br>
						<fieldset><legend>Informaci&oacute;n para Programar la tarea para otro momento.</legend>
							<cfinclude template="agtProceso_frProgramacion.cfm">
						</fieldset>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>	
	</tr>
	<tr>
		<td align="center">	<cf_botones form="fagtproceso" values="Generar, Programar, Regresar" tabindex="1"> </td>
	</tr>
</table>
<!---funciones en javascript de los botones--->
<script language="javascript" type="text/javascript">
<!--//
	function funcProgramar(){
		habilitarValidacion();
		habilitarValidacionProgramar();
	}
	function funcRegresar(){
		<cfoutput>
			document.fagtproceso.action = "agtProceso_#botonAccion[IDtrans][1]##LvarPar#.cfm?#params#";
		</cfoutput>
		deshabilitarValidacion();
	}
	function funcGenerar(){
		deshabilitarValidacionProgramar();
	}
//-->
</script>
<!---funciones en javascript de los dems campos--->
<script language="javascript" type="text/javascript">
<!--//
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
		deshabilitarValidacionProgramar();
	}
	function habilitarValidacionProgramar(){
		qffagtproceso.FechaProgramacion.required = true;
	}
	function deshabilitarValidacionProgramar(){
		qffagtproceso.FechaProgramacion.required = false;
	}
	function _qfinit(){
		habilitarValidacion();
		<cfoutput>
		qffagtproceso.AGTPdescripcion.description = "#JSStringFormat('Descripcin')#";
		qffagtproceso.FechaProgramacion.description = "#JSStringFormat('Fecha de Programacin')#";
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
			lTransDescr = "#JSStringFormat(botonAccion[IDtrans][4])#";
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
//-->
</script>

<cffunction name="fnParametros_AGT" access="private" output="no" hint="Procesa los parametros de la pantalla">
	<!--- FILTROS DE LA LISTA --->
	<cfset params = ''>
	<cfif isdefined('url.Filtro_AGTPdescripcion')>
		<cfset params = params & 'Filtro_AGTPdescripcion=#url.Filtro_AGTPdescripcion#'>
	</cfif>
	<cfif isdefined('url.Filtro_AGTPestadoDesc')>
		<cfset params = params & '&Filtro_AGTPestadoDesc=#url.Filtro_AGTPestadoDesc#'>
	</cfif>
	<cfif isdefined('url.Filtro_AGTPfalta')>
		<cfset params = params & '&Filtro_AGTPfalta=#url.Filtro_AGTPfalta#'>
	</cfif>
	<cfif isdefined('url.Filtro_AGTPmesDesc')>
		<cfset params = params & '&Filtro_AGTPmesDesc=#url.Filtro_AGTPmesDesc#'>
	</cfif>
	<cfif isdefined('url.Filtro_AGTPperiodo')>
		<cfset params = params & '&Filtro_AGTPperiodo=#url.Filtro_AGTPperiodo#'>
	</cfif>
	<cfif isdefined('url.HFiltro_AGTPdescripcion')>
		<cfset params = params & '&HFiltro_AGTPdescripcion=#form.HFiltro_AGTPdescripcion#'>
	</cfif>
	<cfif isdefined('url.HFiltro_AGTPestadoDesc')>
		<cfset params = params & '&HFiltro_AGTPestadoDesc=#url.HFiltro_AGTPestadoDesc#'>
	</cfif>
	<cfif isdefined('url.HFiltro_AGTPfalta')>
		<cfset params = params & '&HFiltro_AGTPfalta=#url.HFiltro_AGTPfalta#'>
	</cfif>
	<cfif isdefined('url.HFiltro_AGTPmesDesc')>
		<cfset params = params & '&HFiltro_AGTPmesDesc=#url.HFiltro_AGTPmesDesc#'>
	</cfif>
	<cfif isdefined('url.HFiltro_AGTPperiodo')>
		<cfset params = params & '&HFiltro_AGTPperiodo=#url.HFiltro_AGTPperiodo#'>
	</cfif>
	<cfif isdefined('url.Pagina')>
		<cfset params = params & '&Pagina=#url.Pagina#'>
	</cfif>
	
	<!--- Categorias --->
	<cfquery name="rsCategorias" datasource="#Session.DSN#">
		select ACcodigo, <cf_dbfunction name="concat" args="ACcodigodesc,'-',ACdescripcion" > as ACdescripcion, ACmascara
			from ACategoria 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by 2
	</cfquery>
	
	<!--- Oficinas --->
	<cfquery name="rsOficinas" datasource="#Session.DSN#">
		select Ocodigo, <cf_dbfunction name="concat" args="Oficodigo,'-',Odescripcion" > as Odescripcion 
			from Oficinas 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by 2                      
	</cfquery>
	
	<!--- Departamentos --->
	<cfquery name="rsDepartamentos" datasource="#Session.DSN#">
		select Dcodigo, Ddescripcion from Departamentos 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by Dcodigo
	</cfquery>
	
	<!--- Clases 
	se llenan automticamente cuando cambia la categoria.
	--->
	<cfquery name="rsClases" datasource="#Session.DSN#">
		select a.ACcodigo, a.ACid, <cf_dbfunction name="concat" args="a.ACcodigodesc,'-',a.ACdescripcion" > as ACdescripcion, a.ACdepreciable, a.ACrevalua
			from AClasificacion a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cffunction>
