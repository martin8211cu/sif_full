<style type="text/css">
	.calPGAply, .selectDates, .filters, .filtersDet, .selectEmp, .selectDed, .selectCgPat, .selectIncid, .detailNom, .detailEmp, .detailDedud, .detailCargas
	.nominas { margin-top: 5px; }
	input#Tdescripcion1, input#Tdescripcion2, input#CPdescripcion1, input#CPdescripcion2 { width: 190px; }
	.nominas div, .filterDates div { float: left; }
	.calPGProc, .calPGAply { margin-left: 3px; }
	.addNomin { margin-left: 5px; }
	.selectDates { margin-left: 60px; }
	.selectDates div { margin-right: 40px; }
	.tpConsulta label { margin-right: 30px; }
	.tpOrden { margin-top: 15px;}
	.filters label, .filtersDet label { font-weight: normal;  margin-right: 20px; }
	.detailNom .listNom { margin-bottom: 10px; }
	.detailNom .listNom, .selectEmp .emplds, .selectDed .deducs, .selectCgPat .cgPatrs, .selectIncid .incidns, .detailEmp .listEmp, .detailCargas .listCargas { margin-top: 10px; }
	.selectEmp .emplds div, .selectDed .deducs div, .selectCgPat .cgPatrs div, .selectIncid .incidns div { float: left; margin-right: 5px; }
	.selectEmp .emplds div:first-child { margin-left: 8px; }
	
	.selectIncid .incidns div:first-child { margin-left: -3px; }
	.detailNom .encabezado, .detListNom { width: 95%; }
	.encabezado, .detListEmp, .detListDedud, .detListCargas, .detListIncid { width: 70%; }
	.encabezado div { background-color: #B0C8D3; padding-top: 6px; height: 28px; margin-bottom: 0; }
	.detListNom .row, .detListNom .row div, .detListDedud .row, .detListDedud .row div, .detListCargas .row, .detListCargas .row div, .detListEmp .row, .detListEmp .row div, .detListIncid .row, .detListIncid .row div { height: 34px; margin-bottom: 0; padding-top: 4px; }
	.detListNom .row, .detListDedud .row, .detListCargas .row, .detListEmp .row, .detListIncid .row { padding-top: 2px; width: 100%; }
	.detListNom .row:nth-child(2n) div, .detListDedud .row:nth-child(2n) div, .detListCargas .row:nth-child(2n) div, .detListEmp .row:nth-child(2n) div, .detListIncid .row:nth-child(2n) div  { background-color: #ffffff; }
	.detListNom .btn, .detListDedud .btn, .detListCargas .btn, .detListEmp .btn, .detListIncid .btn { margin-left: 20px; }


	.btnsRep { margin-top: 10px; margin-bottom: 10px; }
</style>

<cfset t = createObject("component", "sif.Componentes.Translate")>
<cfset LB_Incidencias = t.translate('LB_Incidencias','Incidencias')/> 
<cfset LB_Codigo  = t.translate('LB_Codigo','Código','/rh/generales.xml')>
<cfset LB_Empleado = t.translate('LB_Empleado','Empleado','/rh/generales.xml')>
<cfset MSG_ListaEmpleados = t.translate('MSG_ListaEmpleados','Debe seleccionar un empleado para agregar a la consulta')>
<cfset MSG_ListaIncidencias = t.translate('MSG_ListaIncidencias','Debe seleccionar una incidencia para agregar a la consulta')>
<cfset MSG_Nota = t.translate('MSG_Nota','Nota','/rh/generales.xml')>
<cfset LB_Eliminar = t.translate('LB_Eliminar','Eliminar','/rh/generales.xml')>
<cfset LB_Consultar = t.translate('LB_Consultar','Consultar','/rh/generales.xml')>
<cfset LB_ExportarExcel = t.translate('LB_ExportarExcel','Exportar a Excel')>
<cfset LB_Limpiar = t.translate('LB_Limpiar','Limpiar','/rh/generales.xml')> 
<cfset LB_Eliminar = t.translate('LB_Eliminar','Eliminar','/rh/generales.xml')>
<cfset LB_FiltroFechas = t.translate('LB_FiltroFechas','Utilizar filtro de fechas','/rh/generales.xml')>
<cfset LB_Fecha_Corte = t.translate('LB_Fecha_Corte','Fecha Corte','/rh/generales.xml')>
<cfset LB_TipoOrden = t.translate('LB_TipoOrden','Ordenado:')>
<cfset LB_OrdenxEmp = t.translate('LB_OrdenxEmp','Por empleado')>
<cfset LB_OrdenxCF = t.translate('LB_OrdenxCF','Por Centro Funcional')>

<div class="row">
	<div class="col-md-2"></div>
	<div class="col-md-10">
	<cfoutput>
		<form name="form1" class="form form-horizontal" action="PlusesSalarialesEmpleado-sql.cfm" method="post">
			<div class="form-group col-sm-12">     	
				<div class="col-sm-3">
						<label for="fechDesde"><strong>#LB_Fecha_Corte#:</strong></label>
						<cf_sifcalendario form="form1" tabindex="1" name="FechaCorte" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
				</div>        
			</div>

			<div class="form-group col-sm-12">
					<div class="col-sm-2">
						<label for="CFcodigo">
						<cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate>:
						</label>  
					</div>
					<div class="col-sm-6">	
						<cf_rhcfuncional tabindex="1">
					</div>
					<div class="col-sm-3 ">
						<input type="checkbox" name="dependencias" id="dependencias" tabindex="1">
						<cf_translate key="LB_Incluir_Dependencias">Incluir Dependencias</cf_translate>
					</div>
			</div>

			<div class="form-group col-sm-12">
				<div class="col-sm-2">
					<label for="tiponomina">
						<cf_translate  key="LB_TNomina">Tipo Nómina</cf_translate>:
					</label>  
				</div>
				<div class="col-sm-6">	
					<cf_rhtiponomina form="form1" agregarEnLista="true">
				</div>
			</div>

			<!--- Selección de Empleados --->
			
			<div class="form-group selectEmp col-sm-12">	
				<div class="col-sm-2">
					<label><strong>#LB_Empleado#:</strong></label>
				</div>
				<div class="col-sm-6 listEmp">	
					<cf_rhempleado form="form1" agregarEnLista="true">
				</div>	
			</div>	
					
			<div class="form-group col-sm-12 tpOrden"> 
				<div class="col-sm-2">
					<label><strong>#LB_TipoOrden#</strong></label>
				</div>
				<div class="col-sm-8">
					<input type="radio" name="radOrd" value="1" checked="checked">
					<label><strong>#LB_OrdenxCF#</strong></label>

					<input type="radio" name="radOrd" value="2">
					<label><strong>#LB_OrdenxEmp#</strong></label>
				</div>
			</div>	
			<div class="form-group"> 
			    <div class="col-sm-7 col-sm-offset-1 btnsRep">
					<input type="submit" onclick="fnValConsult()" class="btnConsultar" value="#LB_Consultar#">
					<input class="btnExportar" type="submit" name="ExportarExcel" value="Exportar a Excel" />  
					<input class="btnExportar" type="submit" name="BtnPDF" value="Exportar a PDF" />  
				    <input type="reset"  onclick="fnLimpiar()"	  class="btnLimpiar" value="#LB_Limpiar#">
			    </div>
			</div>
			<input type="hidden" name="ExpExc" id="ExpExc">
		</form>
	</cfoutput>
	</div>
</div>

<script>
	$(document).ready(function(){
	  
	});

	function showEmpDet(){
		$('.detailEmp').show();
	}
	function showIncDet(){
		$('.detailIncid').show();
	}
	//Funcion que permitir añadir un empleado a la lista de seleccion para la consulta
	function fnAddEmp(){
		result = fnValidarElement('DEidentificacion','<cfoutput>#MSG_ListaEmpleados#</cfoutput>');
 			showEmpDet();
		if(result)
			fnAddElement(2);
	}
	
	//Funcion que permitir añadir una incidencia a la lista de seleccion para la consulta
	function fnAddIncid(){
		result = fnValidarElement('CIdescripcion','<cfoutput>#MSG_ListaIncidencias#</cfoutput>');
			showIncDet();
		if(result)
			fnAddElement(1);
	}

	function fnAddElement(e){
		var elementHTML = "", vTcodigo = "", vTdescripcion = "", vCodigo = "", vDescripcion = "", vID = "", vClass = "", vCodListName = "", vDetListName = "",  result = true;

		vNomAply = (e == 5 && $('#chk_NominaAplicada').prop('checked')) ? true : false;

		switch(e){ 
			
			case 1: // Incidencias  
				vCodigo = $('#CIcodigo').val().trim();
				vDescripcion = $('#CIdescripcion').val().trim();
				vID = $('#CIid').val().trim();
				vClass = 'inc_'+vID;
				vCodListName = 'ListaTipoIncidencia';
				vDetListName = 'detListIncid';
				break;	
			case 2: // Empleados    
				vID = $('#DEid').val().trim(); 
				vCodigo = $('#DEidentificacion').val().trim(); 
				vDescripcion = $('#NombreEmp').val().trim();
				vClass = 'emp_'+vID;
				vCodListName = 'ListaEmpleado';
				vDetListName = 'detListEmp';
				break;		
			default:	
				result = false;
		}		
		
		if(result)
			if($('.'+vClass).length == 0){	
				elementHTML = '<div class="row '+vClass+'">';

				if(e != 5) //Si no son nominas
		 			elementHTML += '<div class="col-xs-3">'+vCodigo+'</div><div class="col-xs-8">'+vDescripcion+'</div>';
		 		else //Nominas
		 			elementHTML += '<div class="col-xs-2">'+vTcodigo+'</div><div class="col-xs-3">'+vTdescripcion+'</div><div class="col-xs-2">'+vCodigo+'</div><div class="col-xs-4">'+vDescripcion+'</div>';
		 		
		 		elementHTML += '<div class="col-xs-1"><a style="cursor: pointer" title="<cfoutput>#LB_Eliminar#</cfoutput>" onclick="fnDelElement(this)"><i class="fa fa-times fa-sm"></i></a></div><input type="hidden" name="'+vCodListName+'" value="'+vID+'"/></div>';

		 		$('.'+vDetListName).append(elementHTML);

		 		if(!$('.'+vDetListName).parent().parent().is(':visible'))
					$('.'+vDetListName).parent().parent().show();

				fnClearSelect(e,vNomAply);
			}
	}

	function fnValidarElement(e,showMsg){
		var mensaje = '<strong>¡<cfoutput>#MSG_Nota#</cfoutput>!</strong> ';
		var result = true;

		if($('#'+e).val().trim() == ''){
			result = false;
			mensaje += showMsg;
			alert(mensaje);
		}
		return result;
	}
	function fnClearSelect(e,vNomAply){
		switch(e){ 
			
			case 1: // Empleados 
				$('#DEidentificacion, #NombreEmp').val('');
				break;
			case 2: // Incidencias
				$('#CIcodigo, #CIdescripcion').val('');
				break;	
			
			default:	
				vNomAply = false;
		}		
	}
	function fnDelElement(e){
			var detList = $(e).parent().parent().parent();

			$(e).parent().parent().remove();	
	}
	function fnLimpiar(){
		$('form[name=form1]')[0].reset();
		$(".detListNom, .detListEmp, .detListDedud, .detListCargas, .detListIncid").empty();
		$('input[name=ListaTipoDeduccion], input[name=ListaTipoCarga], input[name=ListaEmpleado], input[name=ListaTipoIncidencia]').val('');	
	}

	function fnValConsult(){
		$('form[name=form1]').submit();
	}
	function fnValidar(){
	    document.form1.action =  '/cfmx/rh/nomina/consultas/ReporteIncidenciasAplicadas-sql.cfm';	
		return result;	
	}



	function validateForm() {
	   var mensaje = '<strong>¡Favor incluir un criterio de búsqueda!</strong> ';
	   var x= $('#FechaCorte').val();
	   var y= $('#CFcodigo').val();
	   var z= $('input[name=ListaEmpleado]').val();
	    
	    if (typeof x !== 'undefined' && typeof y !== 'undefined' && typeof z !== 'undefined') {
	        alert(z+x+y);
	        return false;
	    }
	    
	    return true;	
	}
</script>
