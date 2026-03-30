<!---valida que existan cargas configuradas en Parametros Generales > Cargas a Presentar en Forma Acumulada --->
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
 ecodigo="#session.Ecodigo#" pvalor="2820" default="" returnvariable="lvarConfig"/>
<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
	select rtrim(a.Tcodigo) as Tcodigo, a.Tdescripcion
	from TiposNomina a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by a.Tdescripcion
</cfquery>

<!--- Consulta si empresa(session) tiene habilitada la opcion de permitir consultas corporativas --->
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
 ecodigo="#session.Ecodigo#" pvalor="2715" default="" returnvariable="lvPmtConsCorp"/>




<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ReporteAportesAcumulados"
	Default="Reporte de Aportes Acumulados Funcionario - Patrono"
	returnvariable="LB_ReporteAportesAcumulados"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaDesde"
	Default="Fecha Desde"
	returnvariable="LB_FechaDesde"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaHasta"
	Default="Fecha Hasta"
	returnvariable="LB_FechaHasta"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CortePor"
	Default="Corte por"
	returnvariable="LB_CortePor"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Empleado"
	Default="Empleado"
	returnvariable="LB_Empleado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CentroFuncionalYEmpleado"
	Default="Centro Funcional y Empleado"
	returnvariable="LB_CentroFuncionalYEmpleado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CentroFuncional"
	Default="Centro Funcional"
	returnvariable="LB_CentroFuncional"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Estado"
	Default="Estado"
	returnvariable="LB_Estado"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Todos"
	Default="Todos"
	returnvariable="LB_Todos"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Activo"
	Default="Activo"
	returnvariable="LB_Activo"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Inactivo"
	Default="Inactivo"
	returnvariable="LB_Inactivo"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Tipo_Nomina"
	Default="Tipo de Nómina"	
	xmlFile="/rh/generales.xml"
	returnvariable="LB_Tipo_Nomina"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_TipoNominaYEmpleado"
	Default="Tipo de Nómina y Empleado"	 
	returnvariable="LB_TipoNominaYEmpleado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NominasAplicadas"
	Default="Nóminas Aplicadas"	 
	returnvariable="LB_NominasAplicadas"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CalendarioPago"
	Default="Calendario Pago"	 
	returnvariable="LB_CalendarioPago"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nomina"
	Default="Nomina"	 
	returnvariable="LB_Nomina"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Tipo"
	Default="Tipo"	 
	returnvariable="LB_Tipo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Funcionario"
	Default="Funcionario"	 
	returnvariable="LB_Funcionario"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Patrono"
	Default="Patrono"	 
	returnvariable="LB_Patrono"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FiltrarPorFecha"
	Default="Filtrar por Fecha"	 
	returnvariable="LB_FiltrarPorFecha"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Resumido"
	Default="Resumido"	 
	returnvariable="LB_Resumido"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Detallado"
	Default="Detallado"	 
	returnvariable="LB_Detallado"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_PorNomina"
	Default="Por Nómina"	 
	returnvariable="LB_PorNomina"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_PorFechas"
	Default="Filtrar por fechas"	 
	returnvariable="LB_PorFechas"/>	
	
	
<cfset t = createObject("component", "sif.Componentes.Translate")>
<cfset LB_TipoNomina = t.translate('LB_TipoNomina','Tipo de Nómina','/rh/generales.xml')> 
<cfset LB_ListaDeTiposNomina = t.translate('LB_ListaDeTiposNomina','Lista de Tipos de Nómina','/rh/generales.xml')>
<cfset LB_Codigo  = t.translate('LB_Codigo','Código','/rh/generales.xml')>
<cfset LB_Descripcion  = t.translate('LB_Descripcion','Descripción','/rh/generales.xml')>
<cfset LB_NoSeEncontraronRegistros  = t.translate('LB_NoSeEncontraronRegistros','No se Encontraron Registros','/rh/generales.xml')>
<cfset LB_Tipo = t.translate('LB_Tipo','Tipo','/rh/generales.xml')> 
<cfset MSG_TipoNomina = t.translate('MSG_TipoNomina','Debe seleccionar un tipo de nómina para agregar a la consulta')>
<cfset LB_NominasAplicadas = t.translate('LB_NominasAplicadas','Nóminas Aplicadas','/rh/generales.xml')>
<cfset LB_CalendarioPago = t.translate('LB_CalendarioPago','Calendario Pago','/rh/indexReportes.xml')>
<cfset MSG_Nota = t.translate('MSG_Nota','Nota','/rh/generales.xml')>
<cfset MSG_SelectCalendarPG = t.translate('MSG_SelectCalendarPG','Debe seleccionar un tipo de nómina y un calendario de pagos para realizar esta acción')>
<cfset MSG_CalendarPagos = t.translate('MSG_CalendarPagos','Debe seleccionar el calendario de pago que desea agregar a la consulta')>
<cfset MSG_NominaSelect = t.translate('MSG_NominaSelect','Debe seleccionar al menos una nómina y un calendario de pagos para realizar esta acción')>
<cfset LB_Limpiar = t.translate('LB_Limpiar','Limpiar','/rh/generales.xml')> 
<cfset LB_Eliminar = t.translate('LB_Eliminar','Eliminar','/rh/generales.xml')>
<cfset LB_NoSeEncontraronRegistros  = t.translate('LB_NoSeEncontraronRegistros','No se Encontraron Registros','/rh/generales.xml')>
<cfset MSG_Requeridos = t.translate('MSG_Requeridos','Para realizar la consulta se debe seleccionar los siguientes valores','/rh/generales.xml')>

	
<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_ReporteAportesAcumulados#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	<cf_web_portlet_start titulo="#LB_ReporteAportesAcumulados#">
		<cfif len(trim(lvarConfig)) and lvarConfig NEQ '-1' >
			<cfoutput>
			<form name="form1" method="get" action="ReporteAportesFuncionarioPatrono_Res.cfm" onsubmit="return fnValSubmit();">
				<input name="rptid" type="hidden" value="0">
                <input name="GrupaMesPeriodo" type="hidden" value="1">
               	
			    <table width="85%" cellpadding="2" cellspacing="2" align="center" border="0">
					<tr><td colspan="4">&nbsp;</td></tr>
					<!---<tr><td colspan="4" nowrap="nowrap">
						<table cellpadding="2" cellspacing="2" border="0" width="50%"> <tr>
							<td><input name="PorNomina" id="PorNomina"  type="radio" value="0" checked="checked"> <label>#LB_PorFechas#</label></td>
							<td><input name="PorNomina" id="PorNomina"  type="radio" value="1"> <label>#LB_PorNomina# </label></td>
						</tr></table> 
					</td></tr>--->
					<tr><td colspan="4" nowrap="nowrap">
						<table cellpadding="2" cellspacing="2" border="0" width="50%"> <tr>
							<td><input name="PorFechas" id="PorFechas"  type="checkbox"> <label>#LB_PorFechas#</label></td>
							
						</tr></table> 
					</td></tr>
					<tr id="selectDates">
						<td colspan="2" align="left">
							<table cellpadding="0" cellspacing="0" border="0" align="left" width="50%">
							<tr>
								<td><label> <cfoutput><strong>#LB_FechaDesde#&nbsp;:&nbsp;</strong></cfoutput></label></td>
								<td><cf_sifcalendario name="Fdesde" tabindex="1"></td>
								<td><label> <cfoutput><strong>#LB_FechaHasta#&nbsp;:&nbsp;</strong></cfoutput></label></td>&nbsp; 
								<td><cf_sifcalendario name="Fhasta" tabindex="1"></td>
							</tr>
							</table>
						</td>
					</tr>
					<tr><td colspan="4">&nbsp;</td></tr>
					<tr id="nominas"><td colspan="4">
							<table width="100%" border="0" cellspacing="1" cellpadding="1" style="margin:0" border="0">
							<tr><td nowrap colspan="3"> 
                            	<input type="checkbox" name="chk_NominaAplicada" id="chk_NominaAplicada"> 
                                <label><strong>#LB_NominasAplicadas#:</strong></label>
                            </td></tr> 
                            <tr>
                            	<td> <label><strong>#LB_Nomina#:</strong></label></td>
                                <td> 
                                		<div class="calPGProc">	
                                        <cf_translatedata name="get" tabla="TiposNomina" col="Tdescripcion" returnvariable="LvarTdescripcion">
                                        <cf_conlis
                                            campos="Tcodigo1, Tdescripcion1, CPid1, CPcodigo1, CPdescripcion1"
                                            asignar="Tcodigo1, Tdescripcion1, CPid1, CPcodigo1, CPdescripcion1"
                                            size="0,30,0,0,30"
                                            desplegables="S,S,N,S,S"
                                            modificables="S,N,N,N,N"						
                                            title="#LB_ListaDeTiposNomina#"
                                            tabla="TiposNomina tn
                                                inner join CalendarioPagos cp
                                                    on cp.Tcodigo = tn.Tcodigo
                                                        and cp.Ecodigo = tn.Ecodigo
                                                    inner join RCalculoNomina rhc
                                                        on rhc.RCNid = cp.CPid"
                                            columnas="tn.Tcodigo as Tcodigo1, #LvarTdescripcion# as Tdescripcion1, cp.CPid as CPid1, cp.CPcodigo as CPcodigo1, rhc.RCDescripcion as CPdescripcion1"
                                            filtro="tn.Ecodigo = #session.Ecodigo# order by cp.CPhasta desc"
                                            filtrar_por="tn.Tcodigo, tn.Tdescripcion, cp.CPcodigo, rhc.RCDescripcion"
                                            desplegar="Tcodigo1, Tdescripcion1, CPcodigo1, CPdescripcion1"
                                            etiquetas="#LB_Tipo#, #LB_Nomina#, #LB_Codigo#, #LB_CalendarioPago#"
                                            formatos="S,S,S,S,S"
                                            align="left,left,left,left,left"								
                                            asignarFormatos="S,S,S,S,S"
                                            form="form1"
                                            top="50"
                                            left="200"
                                            showEmptyListMsg="true"
                                            EmptyListMsg=" --- #LB_NoSeEncontraronRegistros# --- "
                                            tabindex="9"
                                            pageindex="9"
                                        /> 					
                                    </div>	
                                    <div class="calPGAply" style="display:none">	
                                        <cf_translatedata name="get" tabla="TiposNomina" col="Tdescripcion" returnvariable="LvarTdescripcion">
                                        <cf_conlis
                                            campos="Tcodigo2, Tdescripcion2, CPid2, CPcodigo2, CPdescripcion2"
                                            asignar="Tcodigo2, Tdescripcion2, CPid2, CPcodigo2, CPdescripcion2"
                                            size="0,30,0,0,30"
                                            desplegables="S,S,N,S,S"
                                            modificables="S,N,N,N,N"						
                                            title="#LB_ListaDeTiposNomina#"
                                            tabla="TiposNomina tn
                                                inner join CalendarioPagos cp
                                                    on cp.Tcodigo = tn.Tcodigo
                                                        and cp.Ecodigo = tn.Ecodigo
                                                    inner join HRCalculoNomina rhc
                                                        on rhc.RCNid = cp.CPid"
                                            columnas="tn.Tcodigo as Tcodigo2, #LvarTdescripcion# as Tdescripcion2, cp.CPid as CPid2, cp.CPcodigo as CPcodigo2, rhc.RCDescripcion as CPdescripcion2"
                                            filtro="tn.Ecodigo = #session.Ecodigo# order by cp.CPhasta desc"
                                            filtrar_por="tn.Tcodigo, tn.Tdescripcion, cp.CPcodigo, rhc.RCDescripcion"
                                            desplegar="Tcodigo2, Tdescripcion2, CPcodigo2, CPdescripcion2"
                                            etiquetas="#LB_Tipo#, #LB_Nomina#, #LB_Codigo#, #LB_CalendarioPago#"
                                            formatos="S,S,S,S,S"
                                            align="left,left,left,left,left"								
                                            asignarFormatos="S,S,S,S,S"
                                            form="form1"
                                            top="50"
                                            left="200"
                                            showEmptyListMsg="true"
                                            EmptyListMsg=" --- #LB_NoSeEncontraronRegistros# --- "
                                            tabindex="10"
                                            pageindex="10"
                                        />
                                    </div>
                                </td>
                                <td><input type="button" class="btnNormal" value="+" onClick="fnAddNom()"></td>
                            </tr>
                            <tr>
                            	<td colspan="3">
                                	<div class="form-group detailNom" style="display:none">
                                        <div class="col-sm-12 listNom">
                                            <div class="row encabezado">
                                                <div class="col-sm-2"><label><strong>#LB_Tipo#</strong></label></div>
                                                <div class="col-sm-3"><label><strong>#LB_Nomina#</strong></label></div>
                                                <div class="col-sm-2"><label><strong>#LB_Codigo#</strong></label></div>
                                                <div class="col-sm-5"><label><strong>#LB_CalendarioPago#</strong></label></div>
                                            </div>	
                                            <div class="detListNom">
                                            </div>	
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
					</td>
					</tr>
					<tr>
						<td><label> <cfoutput><strong>#LB_Tipo#&nbsp;:&nbsp;</strong></cfoutput></label></td>
						<td>
							<select name="Tipo" tabindex="1">
								<option value="1"><cfoutput>#LB_Funcionario#</cfoutput></option>
								<option value="0"><cfoutput>#LB_Patrono#</cfoutput></option>
							</select>
						</td>
					</tr>
					
					<tr>
						<td><label><cf_translate key="LB_Empleado" xmlFile="/rh/generales.xml">Empleado</cf_translate>:</label></td>
						<td>
							<cf_rhempleado index="1" agregarEnLista="1">
						</td>
					</tr>
					<tr><td colspan="4" nowrap="nowrap">
						<table cellpadding="2" cellspacing="2" border="0" width="50%"> <tr>
							<td><input name="resumido" id="resumido"  type="radio" value="0" checked="checked"> <label>#LB_Detallado#</label></td>
							<td><input name="resumido" id="resumido"  type="radio" value="1"> <label>#LB_Resumido# </label></td>
						</tr></table> 
					</td></tr>
					<tr><td colspan="2"><cf_botones values="Consultar,Limpiar" tabindex="1"></td></tr>
				</table>
			</form>
			</cfoutput>
		<cfelse>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_NoSeHanConfiguradoLasCargasObreroPatronalesCorrespondientesalFuncionarioPatrono"
				Default="No se ha configurado las Cargas Obrero Patronales Correspondientes a los Provisiones. Ir a Parámetros RH > Parámetros Generales > Nómina > Cargas Obrero-Patronales Acumuladas"
				returnvariable="LB_NoSeHanConfiguradoLasCargasObreroPatronalesCorrespondientesalFuncionarioPatrono"/>
			<table width="100%" cellpadding="1" cellspacing="0" align="center">
				<tr><td>&nbsp;</td></tr>
				<tr><td align="center"><cfoutput>#LB_NoSeHanConfiguradoLasCargasObreroPatronalesCorrespondientesalFuncionarioPatrono#</cfoutput></td></tr>
				<tr><td>&nbsp;</td></tr>
			</table>
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_TipoDeNomina"
	Default="Tipo de N&oacute;mina"
	returnvariable="MSG_TipoDeNomina"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_FechaDesde"
	Default="Fecha Desde"
	returnvariable="MSG_FechaDesde"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_FechaHasta"
	Default="Fecha Hasta"
	returnvariable="MSG_FechaHasta"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_LosSiguientesDatosSonRequeridos"
	Default="Los siguientes datos son requeridos"
	xmlFile="/rh/generales.xml"
	returnvariable="LB_LosSiguientesDatosSonRequeridos"/>

	
<!--- FIN VARIABLES DE TRADUCCION --->

<cfif len(trim(lvarConfig)) and lvarConfig NEQ '-1' ><!---correccion para el BN, cuando el reporte aun no se ha configurado presentaba error--->
</cfif>

<script type="text/javascript">
 
	$('#chk_NominaAplicada').click(function(){
		fnShowNominAplyProcess($(this).prop('checked'));
	});
	<!---$('#PorFechas').click(function(){
		fnShowDates($(this).prop('checked'));
	});	--->
	
	// Funcion que valida si los elementos requeridos han sido suministrados por el usuario para realizar submit del form
	function fnValSubmit(){
		var result = true;
		var mensaje = '¡<cfoutput>#MSG_Nota#</cfoutput>! <cfoutput>#MSG_Requeridos#</cfoutput>:<br/><br/>';

		if($('#PorFechas').prop('checked') == false){
			if(!$('.detailNom').is(':visible')){
				mensaje += '<cfoutput>#MSG_NominaSelect#</cfoutput><br/>';
				result = false;
			}
		} 
		<!---else{ 
			result = fnValidarElement("Fdesde",'<cfoutput>#MSG_FechaDesde#</cfoutput>');
			if(result)
				result = fnValidarElement("Fhasta",'<cfoutput>#MSG_FechaHasta#</cfoutput>');
		}--->

		if(!result){
			alert(mensaje);
		}
			
		return result;
	}
	// Funcion utilizada para mostrar la seleccion de las nominas aplicadas o en proceso
	function fnShowNominAplyProcess(check){
		$('.detailNom').hide();
		$('.detListNom').empty();

		if(check){  //Mostrar seleccion nominas aplicadas
			$('.calPGProc').hide();
			$('.calPGAply').show();
		}	
		else{  //Mostrar seleccion nominas proceso
			$('.calPGAply').hide();
			$('.calPGProc').show();
		}
	}
	// Funcion que permite añadir una nomina(Aplicada/Proceso) a la lista de seleccion para la consulta
	function fnAddNom(){
		if($('#chk_NominaAplicada').prop('checked')){  //Seleccion nominas aplicadas
			result = fnValidarElement("Tcodigo2",'<cfoutput>#MSG_TipoNomina#</cfoutput>');

			if(result)
				result = fnValidarElement("CPcodigo2",'<cfoutput>#MSG_CalendarPagos#</cfoutput>');	
		}else{  //Seleccion nominas proceso
			result = fnValidarElement("Tcodigo1",'<cfoutput>#MSG_TipoNomina#</cfoutput>');

			if(result)
				result = fnValidarElement("CPcodigo1",'<cfoutput>#MSG_CalendarPagos#</cfoutput>');
		}

		if(result)
			fnAddElementCP();
	}
	
	// Funcion para agregar un Calendario de Pago seleccionado
	function fnAddElementCP(){
		var elementHTML = "", vTcodigo = "", vTdescripcion = "", vCodigo = "", vDescripcion = "", vID = "", vClass = "", vCodListName = "", vDetListName = "",  result = true;

		vNomAply = ($('#chk_NominaAplicada').prop('checked')) ? true : false;

		vTcodigo = (vNomAply) ? $('#Tcodigo2').val().trim() : $('#Tcodigo1').val().trim();
		vTdescripcion = (vNomAply) ? $('#Tdescripcion2').val().trim() : $('#Tdescripcion1').val().trim();	
		vCodigo = (vNomAply) ? $('#CPcodigo2').val().trim() : $('#CPcodigo1').val().trim();
		vDescripcion = (vNomAply) ? $('#CPdescripcion2').val().trim() : $('#CPdescripcion1').val().trim();			
		vID = (vNomAply) ? $('#CPid2').val().trim() : $('#CPid1').val().trim();
		vClass = 'nom_'+vID;
		vCodListName = 'ListaNomina';
		vDetListName = 'detListNom';

		if($('.'+vClass).length == 0){	
			elementHTML = '<div class="row '+vClass+'"><div class="col-xs-2">'+vTcodigo+'</div><div class="col-xs-3">'+vTdescripcion+'</div><div class="col-xs-2">'+vCodigo+'</div><div class="col-xs-4">'+vDescripcion+'</div><div class="col-xs-1"><a style="cursor: pointer" title="<cfoutput>#LB_Eliminar#</cfoutput>" onclick="fnDelElementCP(this)"><i class="fa fa-times fa-sm"></i></a></div><input type="hidden" name="'+vCodListName+'" value="'+vID+'"/></div>';

	 		$('.'+vDetListName).append(elementHTML);

	 		if(!$('.'+vDetListName).parent().parent().is(':visible'))
				$('.'+vDetListName).parent().parent().show();

			(vNomAply) ? $('#Tcodigo2, #Tdescripcion2, #CPcodigo2, #CPdescripcion2').val('') : $('#Tcodigo1, #Tdescripcion1, #CPcodigo1, #CPdescripcion1').val('');
		}
	}
	// Funcion que valida si un elemento requerido no ha sido suministrado
	function fnValidarElement(e,showMsg){
		var mensaje = '¡<cfoutput>#MSG_Nota#</cfoutput>! ';
		var result = true;

		if($('#'+e).val().trim() == ''){
			result = false;
			mensaje += showMsg;
			alert(mensaje);
		}
		return result;
	}
	// Funcion para eliminar un Calendario de Pago de la lista de calendarios ya seleccionados en consulta
	function fnDelElementCP(e){
		var detList = $(e).parent().parent().parent();

		$(e).parent().parent().remove();
		
		if(!$(detList).children().length > 0)
			$(detList).parent().parent().hide();
	}
	
	// Funcion utilizada para mostrar el filtro de fechas(Desde/Hasta) para la seleccion de nominas
	function fnShowDates(check){
		if(check){  //Mostrar seleccion fechas
			document.getElementById("nominas").style.display='none';
			document.getElementById("selectDates").style.display='';
		}
		else{  //Ocultar seleccion de fechas
			document.getElementById("nominas").style.display='';
			document.getElementById("selectDates").style.display='none';
			
		}	
	}
	
</script>