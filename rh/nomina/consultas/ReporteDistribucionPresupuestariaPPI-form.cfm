
<style type="text/css">
	.selectDates, .detailNom { display: none; }
	.nominas { margin-top: 5px; }
	.nominas div, .filterDates div { float: left; }
	.calPGAply { margin-left: 3px; }
	.addNomin { margin-left: 2px; }
	.selectDates { margin-left: 60px; }
	.selectDates div { margin-right: 40px; }
	.detailNom .listNom { margin-bottom: 10px; margin-top: 10px; }
	.detailNom .encabezado, .detListNom { width: 95%; }
	.encabezado div { background-color: #B0C8D3; padding-top: 6px; height: 28px; margin-bottom: 0; }
	.detListNom .row, .detListNom .row div { height: 34px; margin-bottom: 0; padding-top: 4px; }
	.detListNom .row { padding-top: 2px; width: 100%; }
	.detListNom .row:nth-child(2n) div { background-color: #ffffff; }
	.detListNom .btn { margin-left: 20px; }
	input#Tdescripcion1, input#CPdescripcion1 { width: 190px; }
	.btns { margin-bottom: 10px; }
</style>

<!--- Etiquetas de traduccion --->
<cfset LB_Nomina = t.translate('LB_Nomina','Nómina','/rh/generales.xml')>
<cfset LB_FiltroFechas = t.translate('LB_FiltroFechas','Utilizar filtro de fechas','/rh/generales.xml')>
<cfset LB_FechaDesde = t.translate('LB_FechaDesde','Fecha Desde','/rh/generales.xml')>
<cfset LB_FechaFin = t.translate('LB_FechaFin','Fecha Hasta','/rh/generales.xml')>
<cfset LB_Tipo = t.translate('LB_Tipo','Tipo','/rh/generales.xml')>
<cfset LB_Codigo = t.translate('LB_Codigo','Código','/rh/generales.xml')>
<cfset LB_CalendarioPago = t.translate('LB_CalendarioPago','Calendario Pago','/rh/generales.xml')>
<cfset LB_Eliminar = t.translate('LB_Eliminar','Eliminar','/rh/generales.xml')>
<cfset LB_Consultar = t.translate('LB_Consultar','Consultar','/rh/generales.xml')>
<cfset LB_ExportarExcel = t.translate('LB_ExportarExcel','Exportar a Excel','/rh/generales.xml')>
<cfset LB_Limpiar = t.translate('LB_Limpiar','Limpiar','/rh/generales.xml')>

<cfset MSG_Nota = t.translate('MSG_Nota','Nota','/rh/generales.xml')> 
<cfset MSG_TipoNomina = t.translate('MSG_TipoNomina','Debe seleccionar el tipo de nómina que desea agregar a la consulta','/rh/ReporteDistribucionPresupuestariaPPI.xml')>
<cfset MSG_CalendarPagos = t.translate('MSG_CalendarPagos','Debe seleccionar el calendario de pago que desea agregar a la consulta','/rh/ReporteDistribucionPresupuestariaPPI.xml')>
<cfset MSG_FechaDesde = t.translate('MSG_FechaDesde','Debe seleccionar la fecha inicial del rango de la consulta','/rh/ReporteDistribucionPresupuestariaPPI.xml')>
<cfset MSG_FechaHasta = t.translate('MSG_FechaHasta','Debe seleccionar la fecha final del rango de la consulta','/rh/ReporteDistribucionPresupuestariaPPI.xml')>
<cfset MSG_NominaSelect = t.translate('MSG_NominaSelect','Debe seleccionar al menos una nómina y un calendario de pagos para realizar esta acción','/rh/ReporteDistribucionPresupuestariaPPI.xml')>
<cfset MSG_Limpiar = t.translate('MSG_Limpiar','Limpia el formulario','/rh/generales.xml')>


<cfoutput>
	<form name="form1" action="ReporteDistribucionPresupuestariaPPI-sql.cfm" method="post">
		<!--- Seleccion de Nominas Aplicadas --->
		<div class="form-group">
            <div class="col-sm-12 nominas"> 
            	<div>
					<label for="Nomina"><strong>#LB_Nomina#</strong></label>
				</div>
				<div class="calPGAply">	
					<cf_rhcalendariopagos form="form1" historicos="true" tcodigo="true" descsize="20" index="1" tabindex="1" Excluir="2">
				</div>			
				<div class="addNomin">
					<input type="button" class="btnNormal" value="+" onclick="fnAddNom()">
				</div>			
            </div>
        </div>   

        <!--- Detalle de las nominas seleccionadas --->
        <div class="form-group detailNom" >
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
					
		<!--- Seleccion del Filtro de fechas --->			
		<div class="form-group">
            <div class="col-sm-12 filterDates"> 
            	<div>
					<label for="filtroFechas"><strong>#LB_FiltroFechas#:</strong></label>
					<input name="chk_FiltroFechas" id="chk_FiltroFechas" type="checkbox" tabindex="1">
				</div>			
				<div class="selectDates">
					<div>
						<label for="fechDesde"><strong>#LB_FechaDesde#:</strong></label>
						<cf_sifcalendario form="form1" tabindex="1" name="FechaDesde" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
					</div>
					<div>
						<label for="fechHasta"><strong>#LB_FechaFin#:</strong></label>
						<cf_sifcalendario form="form1" tabindex="2" name="FechaHasta" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
					</div>			
				</div>	
            </div>	
		</div>	

		<!--- Botones de acciones del reporte --->
        <div class="form-group"> 
	        <div class="col-sm-9 col-sm-offset-3 btns">
				<input type="submit" name="Consultar" class="btnConsultar" value="#LB_Consultar#" onclick="return fnValSubmit();">
				<input type="submit" name="Exportar" class="btnExportar" value="#LB_ExportarExcel#" onclick="return fnValSubmit();">
				<input type="reset" name="Limpiar" class="btnLimpiar" value="#LB_Limpiar#" onclick="fnLimpiar()">
			</div>
        </div>
	</form>
</cfoutput>


<script type="text/javascript">
	$(document).ready(function(){
		fnLimpiar();
	});

	$('#chk_FiltroFechas').click(function(){
		fnShowDates($(this).prop('checked'));
	});		

	// Funcion que valida si los elementos requeridos han sido suministrados por el usuario para realizar submit del form
	function fnValSubmit(){
		var result = true;
		var mensaje = '<strong>¡<cfoutput>#MSG_Nota#</cfoutput>!</strong> ';

		if($('#chk_FiltroFechas').prop('checked')){
			result = fnValidarElement('FechaDesde','<cfoutput>#MSG_FechaDesde#</cfoutput>');
			
			if(result)
				result = fnValidarElement('FechaHasta','<cfoutput>#MSG_FechaHasta#</cfoutput>'); 
		} 
		else
			if(!$('.detailNom').is(':visible')) {
				mensaje += '<cfoutput>#MSG_NominaSelect#</cfoutput>';
				result = false;
				alert(mensaje);
			}
		
		return result;
	}

	//Funcion utilizada para mostrar el filtro de fechas(Desde/Hasta) para la seleccion de nominas
	function fnShowDates(check){
		if(check){  //Mostrar seleccion fechas
			$('.nominas, .detailNom').hide(); 
			$('.detListNom').empty();
			$('.selectDates').show();	
		}
		else{  //Ocultar seleccion de fechas
			$('.selectDates').hide();
			$('.nominas').show();	
		}	
	}

	//Funcion que permitir añadir una nomina(Aplicada) a la lista de seleccion para la consulta
	function fnAddNom(){
		result = fnValidarElement('Tcodigo1','<cfoutput>#MSG_TipoNomina#</cfoutput>');

		if(result){
			result = fnValidarElement('CPcodigo1','<cfoutput>#MSG_CalendarPagos#</cfoutput>');	
			if(result)
				fnAddElement();
		}	
	}

	//Funcion que permite validar si un elemento requerido ha sido suministrado
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

	//Funcion que permite agregar elementos seleccionados a la lista de la consulta
	function fnAddElement(){
		var elementHTML = "", vTcodigo = "Tcodigo1", vTdescripcion = "Tdescripcion1", vCodigo = "CPcodigo1", vDescripcion = "CPdescripcion1", vID = "CPid1", vClass = "", vCodListName = "", vDetListName = "",  result = true;

		vTcodigo = $('#'+vTcodigo).val().trim();
		vTdescripcion = $('#'+vTdescripcion).val().trim();	
		vCodigo = $('#'+vCodigo).val().trim();
		vDescripcion = $('#'+vDescripcion).val().trim();			
		vID = $('#'+vID).val().trim();
		vClass = 'nom_'+vID;
		vCodListName = 'ListaNomina';
		vDetListName = 'detListNom';

		if($('.'+vClass).length == 0){	
	 		elementHTML = '<div class="row '+vClass+'"><div class="col-xs-2">'+vTcodigo+'</div><div class="col-xs-3">'+vTdescripcion+'</div><div class="col-xs-2">'+vCodigo+'</div><div class="col-xs-4">'+vDescripcion+'</div><div class="col-xs-1"><a style="cursor: pointer" title="<cfoutput>#LB_Eliminar#</cfoutput>" onclick="fnDelElement(this)"><i class="fa fa-times fa-sm"></i></a></div><input type="hidden" name="'+vCodListName+'" value="'+vID+'"/></div>';
	 		
	 		$('.'+vDetListName).append(elementHTML);

	 		if(!$('.'+vDetListName).parent().parent().is(':visible'))
				$('.'+vDetListName).parent().parent().show();

			$('#Tcodigo1, #Tdescripcion1, #CPcodigo1, #CPdescripcion1').val('');
		}
	}

	//Funcion que permite eliminar un elemento seleccionado de la lista de la consulta
	function fnDelElement(e){
		var detList = $(e).parent().parent().parent();

		$(e).parent().parent().remove();
		
		if(!$(detList).children().length > 0)
			$(detList).parent().parent().hide();
	}

	function fnLimpiar(){
		$(".detListNom").empty();
		$(".detailNom").hide();
	}
</script>