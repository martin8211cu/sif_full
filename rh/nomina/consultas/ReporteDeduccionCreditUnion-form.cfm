<style type="text/css">
	.nomAplic, .NAplicadas, .NNoAplicadas, .filters { margin-left: 40px; }
	.NAplicadas, .filterDate, .detailNomin { display:none; }
	.NAplicadas div, .NNoAplicadas div { float: left; }
	.NAplicadas, .NNoAplicadas { margin-top: 12px; }
	.NAplicadas .nominaCP, .NNoAplicadas .nominaCP { margin-left: 15px;  margin-right: 5px; }
	input#Tdescripcion1, input#Tdescripcion2, input#CPdescripcion1, input#CPdescripcion2 { width: 190px; }
	.filters .filterDate { margin-left: 150px; margin-bottom: 15px; }
	.filters .filterDate input { margin-right: 70px; }
	.detailNomin { margin-top: 10px; }
	.detailNomin table { margin-left: 10%; margin-bottom: 10px; }
	.btns { margin-bottom: 10px; }
</style>


<!----- Etiquetas de traduccion------>
<cfset LB_Consultar = t.translate('LB_Consultar','Consultar','/rh/generales.xml')>
<cfset LB_ExportarExcel = t.translate('LB_ExportarExcel','Exportar a Excel')>
<cfset LB_Limpiar = t.translate('LB_Limpiar','Limpiar','/rh/generales.xml')>
<cfset LB_NominasAplicadas = t.translate('LB_NominasAplicadas','Nóminas Aplicadas','/rh/generales.xml')>
<cfset LB_Nomina = t.translate('LB_Nomina','Nómina','/rh/generales.xml')>
<cfset LB_FiltroFechas = t.translate('LB_FiltroFechas','Utilizar filtro de fechas','/rh/generales.xml')>
<cfset LB_FechaDesde = t.translate('LB_FechaDesde','Fecha Desde','/rh/generales.xml')>
<cfset LB_FechaHasta = t.translate('LB_FechaHasta','Fecha Hasta','/rh/generales.xml')>
<cfset MSG_Nota = t.translate('MSG_Nota','Nota')>
<cfset MSG_TipoNomina = t.translate('MSG_TipoNomina','Debe seleccionar el tipo de nómina que desea agregar a la consulta')>
<cfset MSG_CalendarPagos = t.translate('MSG_CalendarPagos','Debe seleccionar el calendario de pago que desea agregar a la consulta')>
<cfset MSG_FechaDesde = t.translate('MSG_FechaDesde','Debe seleccionar la fecha inicial del rango de la consulta')>
<cfset MSG_FechaHasta = t.translate('MSG_FechaHasta','Debe seleccionar la fecha final del rango de la consulta')>
<cfset MSG_NominaSelect = t.translate('MSG_NominaSelect','Debe seleccionar al menos una nómina y un calendario de pagos para realizar esta acción')>
<cfset MSG_AddNomina = t.translate('MSG_AddNomina','Agrega la nomina y el calendario de pago seleccionado')>
<cfset MSG_Consultar = t.translate('MSG_Consultar','Consulta la información de las nóminas seleccionadas')>
<cfset MSG_Exportar = t.translate('MSG_Exportar','Exportar la información de las nóminas seleccionadas')>
<cfset MSG_Limpiar = t.translate('MSG_Limpiar','Limpia el formulario')>


<form action="ReporteDeduccionCreditUnion-sql.cfm" method="post" name="form1">
	<cfoutput>
		<!--- Check nominas aplicadas --->
		<div class="form-group">
			<div class="col-sm-12 nomAplic">
				<label>	 	
					<input name="chk_NominaAplicada" id="chk_NominaAplicada" type="checkbox" tabindex="1" onclick="ValidarTipoNomina();"> <strong>#LB_NominasAplicadas#</strong>
				</label>
			</div>
		</div>		

		<!--- Nominas aplicadas --->
		<div class="form-group">
			<div class="col-sm-12 NAplicadas"> 
            	<div>
					<label><strong>#LB_Nomina#</strong></label>
				</div>
				<div class="nominaCP">	
					<cf_rhcalendariopagos form="form1" historicos="true" tcodigo="true" descsize="40" index="1" tabindex="1" Excluir="2">
				</div>			
				<div>
					<input type="button" class="btnNormal" value="+" onclick="fnAddSelect()">
				</div>			
            </div>
        </div>    
		
		<!--- Nominas no aplicadas --->
		<div class="form-group">	
			<div class="col-sm-12 NNoAplicadas"> 
            	<div>
					<label><strong>#LB_Nomina#</strong></label>
				</div>
				<div class="nominaCP">
					<cf_rhcalendariopagos form="form1" historicos="false" tcodigo="true" descsize="40" index="2" tabindex="1" Excluir="2">
				</div>		
				<div>
					<input type="button" class="btnNormal" value="+" onclick="fnAddSelect()">
				</div>	
            </div>	
        </div>    

        <!--- Detalle de las nominas seleccionadas --->
		<div class="col-sm-12 detailNomin">
			<table class="PlistaTable" width="70%" cellspacing="0" cellpadding="0" border="1">
				<thead>
					<tr bgcolor="##E3EDEF">
						<th width="5%" nowrap="" align="center" class="tituloListas">Tipo</th>
						<th width="20%" nowrap="" align="center" class="tituloListas">Nómina</th>
						<th width="15%" nowrap="" align="center" class="tituloListas">Código</th>
						<th width="26%" nowrap="" align="center" class="tituloListas">Calendario Pago</th>
						<th width="4%" nowrap="" align="center" class="tituloListas"></th>
					</tr>	
				</thead>
				<tbody class="detailSelect">
				</tbody>	
			</table>		
		</div>
		
		<!--- Filtro de fechas --->
        <div class="form-group"> 
            <div class="col-sm-12 filters">
            	<div class="lbFilterFech">
					<label>
						<input name="chk_FiltroFechas" id="chk_FiltroFechas" type="checkbox" onClick="fnActivarFiltro()"> <strong>#LB_FiltroFechas#</strong>
					</label>
				</div>		
				<div class="filterDate">
					<label><strong>#LB_FechaDesde#</strong></label>
					<cf_sifcalendario form="form1" tabindex="1" name="FechaDesde" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">

					<label><strong>#LB_FechaHasta#</strong></label>
					<cf_sifcalendario form="form1" tabindex="2" name="FechaHasta" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
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
	</cfoutput>
</form>

<script type="text/javascript">
	$(document).ready(function(){
		fnLimpiar();
	});

	// Funcion que valida si los elementos requeridos han sido suministrados por el usuario para realizar submit del form
	function fnValSubmit(){
		var result = true;
		var mensaje = '<strong>¡<cfoutput>#MSG_Nota#</cfoutput>!</strong> ';

		if(document.getElementById("chk_FiltroFechas").checked == true){
			result = fnValidarElement("FechaDesde",'<cfoutput>#MSG_FechaDesde#</cfoutput>');
			
			if(result)
				result = fnValidarElement("FechaHasta",'<cfoutput>#MSG_FechaHasta#</cfoutput>'); 
		} 
		else{ 
			if(!$('.detailNomin').is(':visible')){
				mensaje += '<cfoutput>#MSG_NominaSelect#</cfoutput>';
				result = false;
				alert(mensaje);
			}
		}	
		
		return result;
	}

	// Funcion que valida si un elemento requerido no ha sido suministrado
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

	function ValidarTipoNomina(){ 
		if (document.getElementById("chk_NominaAplicada").checked == true){ 
			if (!document.getElementById("chk_FiltroFechas").checked == true){
				if($('.NNoAplicadas').is(':visible'))
					$('.NNoAplicadas').hide(); 
				$('.NAplicadas').show();

				document.form1.Tcodigo1.value = '';
				document.form1.CPid1.value = '';
				document.form1.Tdescripcion1.value = '';
				document.form1.CPcodigo1.value = '';
				document.form1.CPdescripcion1.value = ''; 
				$(".detailSelect").empty();
				$(".detailNomin").hide();
			}	
		}
		else{ 
			if (!document.getElementById("chk_FiltroFechas").checked == true){
				if($('.NAplicadas').is(':visible'))
					$('.NAplicadas').hide(); 
				$('.NNoAplicadas').show();

				document.form1.Tcodigo2.value = '';
				document.form1.CPid2.value = '';
				document.form1.Tdescripcion2.value = '';
				document.form1.CPcodigo2.value = '';
				document.form1.CPdescripcion2.value = '';
				$(".detailSelect").empty();
				$(".detailNomin").hide();
			}	
		}
	}

	function fnActivarFiltro(){
		if (document.getElementById("chk_FiltroFechas").checked == true){
			if($('.NNoAplicadas').is(':visible'))
				$('.NNoAplicadas').hide();
			else
				$('.NAplicadas').hide();

			$(".detailSelect").empty();
			$(".detailNomin").hide();
			$('.filterDate').show();
		}
		else{
			$('.filterDate').hide();

			if (document.getElementById("chk_NominaAplicada").checked == true)
				$('.NAplicadas').show();
			else
				$('.NNoAplicadas').show();
		}	
	}

	function fnAddSelect(){
		if (document.getElementById("chk_NominaAplicada").checked == true){
			result = fnValidarElement("Tcodigo1",'<cfoutput>#MSG_TipoNomina#</cfoutput>');

			if(result){
				result = fnValidarElement("CPcodigo1",'<cfoutput>#MSG_CalendarPagos#</cfoutput>');	
				if(result)
					fnAddElement();
			}	
		}	
		else{
			result = fnValidarElement("Tcodigo2",'<cfoutput>#MSG_TipoNomina#</cfoutput>');

			if(result){
				result = fnValidarElement("CPcodigo2",'<cfoutput>#MSG_CalendarPagos#</cfoutput>');
				if(result)
					fnAddElement();
			}	
		}	
	}

	function fnAddElement(){
		var result = "", element = "", Tcodigo = "", Tdescripcion = "", CPcodigo = "", CPdescripcion = "", CPid = "";

		vNomAply = ($('#chk_NominaAplicada').prop('checked')) ? true : false;

		Tcodigo = (vNomAply) ? $('#Tcodigo1').val().trim() : $('#Tcodigo2').val().trim();
		Tdescripcion = (vNomAply) ? $('#Tdescripcion1').val().trim() : $('#Tdescripcion2').val().trim();			
		CPcodigo = (vNomAply) ? $('#CPcodigo1').val().trim() : $('#CPcodigo2').val().trim();		
		CPdescripcion = (vNomAply) ? $('#CPdescripcion1').val().trim() : $('#CPdescripcion2').val().trim();
		CPid = (vNomAply) ? $('#CPid1').val().trim() : $('#CPid2').val().trim();

		element = CPid;

		if($("input[name=TcodigoList][value='"+element+"']").length == 0){
			result = '<tr id="'+element+'"><td valign="bottom" align="left">'+Tcodigo+'</td>';
			result += '<td valign="bottom" align="left">'+Tdescripcion+'</td>';
			result += '<td valign="bottom" align="left">'+CPcodigo+'</td>';
			result += '<td valign="bottom" align="left">'+CPdescripcion+'</td>';
			result += '<td align="center"><a style="padding:0" class="btn" title="Eliminar" onclick="fnDelElement(this)"><i class="fa fa-times fa-sm"></i></a></td><input type="hidden" name="TcodigoList" value="'+element+'"/></tr>';

			$(".detailSelect").append(result);

			if(!$('.detailNomin').is(':visible'))
				$('.detailNomin').show();  

			(vNomAply) ? $('#Tcodigo1, #Tdescripcion1, #CPcodigo1, #CPdescripcion1').val('') : $('#Tcodigo2, #Tdescripcion2, #CPcodigo2, #CPdescripcion2').val('');
		}	
	}

	function fnDelElement(e){
		if($('.detailSelect tr').length == 1){
			$(e).parent().parent().remove();
			$('.detailNomin').hide(); 
		}
		else
			$(e).parent().parent().remove();
	}

	function fnLimpiar(){
		$('form[name=form1]')[0].reset();
		$(".detailSelect").empty();
		$(".filterDate, .NAplicadas, .detailNomin").hide();
		$('.NNoAplicadas').show();
	}
</script>


