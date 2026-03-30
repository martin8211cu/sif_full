
<style type="text/css">
	.well { padding: 25px 10px 15px 10px; margin-top: 10px; margin-bottom: 15px;  }
	.form-group { margin-left: 30px; }
	.tbSalarial div, .tbVigencia div { float: left; }
	.conlist, .btnAddES { margin-left: 10px; }
	.detailES { margin-top: 25px; display:none; }  
	.detailES table { margin-left: 35px; margin-bottom: 30px; }
	.alert { position: fixed; top: 35%; right: 21%; display:none; width: 330px !important; }
</style>


<!--- Etiquetas de traducción --->
<cfset LB_TablaSalarial = t.translate('LB_TablaSalarial','Tabla Salarial','/rh/generales.xml')>
<cfset LB_Vigencia = t.translate('LB_Vigencia','Vigencia')>
<cfset LB_ListaVigencias = t.translate('LB_ListaVigencias','Lista de Vigencias')>
<cfset LB_Codigo = t.translate('LB_Codigo','Código','/rh/generales.xml')>
<cfset LB_Descripcion = t.translate('LB_Descripcion','Descripción','/rh/generales.xml')>
<cfset LB_FechaRige = t.translate('LB_FechaRige','Fecha Rige')>
<cfset LB_FechaHasta = t.translate('LB_FechaHasta','Fecha Hasta')>
<cfset LB_Estado = t.translate('LB_Estado','Estado')>
<cfset LB_ListaTablas = t.translate('LB_ListaDeTablasSalariales','Lista de Tablas Salariales','TablaPuestoCategoria.xml')>	
<cfset LB_Consultar = t.translate('LB_Consultar','Consultar','/rh/generales.xml')>
<cfset LB_Limpiar = t.translate('LB_Limpiar','Limpiar','/rh/generales.xml')>
<cfset LB_Indefinido = t.translate('LB_Indefinido','Indefinido','/rh/generales.xml')>
<cfset LB_Aplicado = t.translate('LB_Aplicado','Aplicado','/rh/generales.xml')>
<cfset LB_Pendiente = t.translate('LB_Pendiente','Pendiente','/rh/generales.xml')>

<cfset MSG_Nota = t.translate('MSG_Nota','Nota')>
<cfset MSG_Requeridos = t.translate('MSG_Requeridos','Para realizar la consulta se debe seleccionar los siguientes valores')>
<cfset MSG_EscalaSalarial = t.translate('MSG_EscalaSalarial','Debe seleccionar una tabla salarial y la vigencia para agregar a la consulta')>
<cfset MSG_EscalaSalarialSelect = t.translate('MSG_EscalaSalarialSelect','La tabla salarial seleccionada ya fue agregada a la consulta con una vigencia')>
<cfset MSG_AddES = t.translate('MSG_AddES','Agrega la tabla salarial y la vigencia seleccionada')>
<cfset MSG_ConsultarES = t.translate('MSG_ConsultarES','Consulta la escala salarial')>
<cfset MSG_Limpiar = t.translate('MSG_Limpiar','Limpia el formulario')>

<cfset filtro = "">

<div class="well">
	<form name="form1" method="post" action="RepEscalaSalarial-ResultPensionable.cfm" >
		<cfoutput>
			<!--- Tabla salarial --->
			<div class="form-group row">
				<div class="col-sm-12 tbSalarial">
					<div class="lbTS">
						<label><strong>#LB_TablaSalarial#:</strong></label>
					</div>
					<div class="conlist">
						<cf_translatedata name="get" tabla="RHTTablaSalarial" col="RHTTdescripcion" returnvariable="LvarRHTTdescripcion">
						<cf_conlis 
			                campos="RHTTid,RHTTcodigo,RHTTdescripcion"
			                size="0,10,30"
			                desplegables="N,S,S"
			                modificables="N,S,N"
			                title="#LB_ListaTablas#"
			                tabla="RHTTablaSalarial"
			                columnas="RHTTid,RHTTcodigo,#LvarRHTTdescripcion# as RHTTdescripcion"
			                filtro="Ecodigo = #session.Ecodigo#"
			                filtrar_por="RHTTcodigo,RHTTdescripcion"
			                desplegar="RHTTcodigo,RHTTdescripcion"
			                etiquetas="#LB_Codigo#,#LB_Descripcion#"
			                formatos="S,S"
			                align="left,left"
			                asignar="RHTTid,RHTTcodigo,RHTTdescripcion"
			                asignarFormatos="S,S,S"
			                form="form1"
			                showEmptyListMsg="true" 
			                translatedatacols="RHTTdescripcion"
			                />
			        </div>
			    </div>    
			</div>

			<!--- Vigencias --->
		    <div class="form-group row">
		    	<div class="col-sm-12 tbVigencia">
		    		<div class="lbVG">
						<label><strong>#LB_Vigencia#:</strong></label>
					</div>
					<div class="conlist">
				    	<cf_dbfunction name="to_sdatedmy" args="RHVTfechahasta" returnvariable="lvar_fechaHasta">
				        <cf_dbfunction name="to_sdatedmy" args="#createdate(6100,01,01)#" returnvariable="lvar_fechaIndefinida">
						<cf_translatedata name="get" tabla="RHVigenciasTabla" col="RHVTdescripcion" returnvariable="LvarRHVTdescripcion">
						<cf_conlis 
						campos="RHVTid,RHVTcodigo,RHVTdescripcion"
						size="0,10,30"
						desplegables="N,S,S"
						modificables="N,S,N"
						title="#LB_ListaVigencias#"
						tabla="RHVigenciasTabla"
						columnas="RHTTid,RHVTcodigo,#LvarRHVTdescripcion# as RHVTdescripcion,RHVTid,RHVTfecharige,case #preservesinglequotes(lvar_fechaHasta)# when #lvar_fechaIndefinida# then '#LB_Indefinido#' else #preservesinglequotes(lvar_fechaHasta)# end as RHVTfechahasta,case RHVTestado when 'A' then '#LB_Aplicado#' when 'P' then '#LB_Pendiente#' else RHVTestado end as RHVTestado"
						filtro="Ecodigo = #session.Ecodigo# and RHTTid = $RHTTid,numeric$ and RHVTestado = 'A' #filtro# order by RHVTfecharige,RHVTfechahasta,RHVTestado"
						filtrar_por="RHVTcodigo,RHVTdescripcion,RHVTfecharige,RHVTfechahasta,RHVTestado"
						desplegar="RHVTcodigo,RHVTdescripcion,RHVTfecharige,RHVTfechahasta,RHVTestado"
						etiquetas="#LB_Codigo#,#LB_Descripcion#,#LB_FechaRige#,#LB_FechaHasta#,#LB_Estado#"
						formatos="I,S,D,S,S"
						align="left,left"
						asignar="RHTTid,RHVTid,RHVTcodigo,RHVTdescripcion"
						asignarFormatos="S,S,S"
						form="form1"
						showEmptyListMsg="true"
						mensajeValoresRequeridos="#LB_TablaSalarial#"
						/>
					</div>
					<div class="btnAddES">	
						<a onclick="fnAddSelect()" onmouseover="fnShowTooltip('estrSal')" class="btn btn-primary btn-xs estrSal" data-toggle="tooltip" data-placement="top" title="#MSG_AddES#"><i class="fa fa-plus fa-xs"></i></a>	
				    </div>
				</div>    
			</div>

			<!--- Detalle de las tablas salariales con las vigencias seleccionadas --->
	        <div class="col-sm-12 detailES">
				<table class="PlistaTable" width="84%" cellspacing="0" cellpadding="0" border="1">
					<thead>
						<tr bgcolor="##E3EDEF">
							<th width="44%" nowrap="" align="center" class="tituloListas">#LB_TablaSalarial#</th>
							<th width="36%" nowrap="" align="center" class="tituloListas">#LB_Vigencia#</th>
							<th width="4%" nowrap="" align="center" class="tituloListas"></th>
						</tr>	
					</thead>
					<tbody class="detailSelect">
					</tbody>	
				</table>		
			</div>

			<!--- Botones de acciones del reporte --->
			<div class="form-group row"> 
		        <div class="col-sm-12 col-sm-offset-3">
					<a onclick="fnValidarConsult()" onmouseover="fnShowTooltip('consult')" class="btn btn-primary btn-sm consult" data-toggle="tooltip" data-placement="top" title="#MSG_ConsultarES#"><i class="fa fa-check fa-sm"></i>#LB_Consultar#</a>	

					<a onclick="fnLimpiar()" onmouseover="fnShowTooltip('limpiar')" class="btn btn-warning btn-sm limpiar" data-toggle="tooltip" data-placement="top" title="#MSG_Limpiar#"><i class="fa fa-check fa-sm"></i>#LB_Limpiar#</a>
				</div>
	        </div>
		</cfoutput>
	</form>
	<div class="alert alert-danger alert-dismissable msjInfoDel">
		<a onclick="fnHideMessage()" class="close" aria-hidden="true">&times;</a>
	    <span></span>
	</div>
</div>


<script type="text/javascript">
	var myVar = 0;
	var vRHTTcodigo = "";
	var vRHTTcodigoTemp = "";

	$(document).ready(function() {
		vRHTTcodigo = (document.getElementById('RHTTcodigo').value).trim(); 
		myVar = setInterval(function(){fnValidarChangeTS()}, 500);
	});

	function fnValidarChangeTS() {
	    vRHTTcodigoTemp = (document.getElementById('RHTTcodigo').value).trim();
	    
	    if(vRHTTcodigoTemp != vRHTTcodigo){
	    	document.getElementById('RHVTcodigo').value = "";
	    	document.getElementById('RHVTdescripcion').value = "";
	    	vRHTTcodigo = vRHTTcodigoTemp;
	    }
	}

	function myStopFunction() {
	    clearInterval(myVar);
	}

	function fnValidarConsult(){
		if(fnValidar())
			$('form[name=form1]').submit();
	}

	function fnValidar(){
		var result = true;
		var mensaje = '<strong>¡<cfoutput>#MSG_Nota#</cfoutput>!</strong> <cfoutput>#MSG_Requeridos#</cfoutput>:<br/><br/>';

		if(!$('.detailES').is(':visible')){
			mensaje += '-> <cfoutput>#LB_TablaSalarial#</cfoutput><br/>-> <cfoutput>#LB_Vigencia#</cfoutput><br/>';
			result = false;
			$('.alert span').html(mensaje);
			fnShowMessage();
		}

		return result;
	}

	function fnAddSelect(){
		result = fnValidarElement();

		if(result)
			fnAddElement();
	}

	function fnValidarElement(){
		var mensaje = '<strong>¡<cfoutput>#MSG_Nota#</cfoutput>!</strong> <cfoutput>#MSG_Requeridos#</cfoutput>:<br/><br/>';
		var result = true;

		if ((document.getElementById('RHTTcodigo').value).trim() == ''){
			mensaje += '-> <cfoutput>#LB_TablaSalarial#</cfoutput><br/>';
			result = false;
		}
		
		if ((document.getElementById('RHVTcodigo').value).trim() == ''){
			mensaje += '-> <cfoutput>#LB_Vigencia#</cfoutput><br/>';
			result = false;
		}

		if(!result){
			$('.alert span').html(mensaje);
			fnShowMessage();
		}

		return result;
	}

	function fnAddElement(){
		var result = "", element = "", RHTTid = "RHTTid", RHTTdescripcion = "RHTTdescripcion", RHVTid = "RHVTid", 
		RHVTdescripcion = "RHVTdescripcion";
		var mensaje = '<strong>¡<cfoutput>#MSG_Nota#</cfoutput>!</strong> ';

		RHTTid = (document.getElementById(RHTTid).value).trim();
		RHTTdescripcion = (document.getElementById(RHTTdescripcion).value).trim();		
		RHVTid = (document.getElementById(RHVTid).value).trim();
		RHVTdescripcion = (document.getElementById(RHVTdescripcion).value).trim();	

		element = RHTTid;

		if($("input[name=TCodListTS][value='"+element+"']").length == 0){
			result = '<tr id="'+element+'"><td valign="bottom" align="left">'+RHTTdescripcion+'</td>';
			result += '<td valign="bottom" align="left">'+RHVTdescripcion+'</td>';
			result += '<td align="center"><a style="padding:0" class="btn" title="Eliminar" onclick="fnDelElement(this)"><i class="fa fa-times fa-sm"></i></a></td><input type="hidden" name="TCodListTS" value="'+element+'"/><input type="hidden" name="TCodListVG" value="'+RHVTid+'"/></tr>';

			$(".detailSelect").append(result);

			if(!$('.detailES').is(':visible'))
				$('.detailES').delay(200).fadeIn(800);  
		}	
		else{
			mensaje += '<cfoutput>#MSG_EscalaSalarialSelect#</cfoutput>'; 
			$('.alert span').html(mensaje);
			fnShowMessage();
		}
	}

	function fnDelElement(e){
		if($('.detailSelect tr').length == 1){
			$(e).parent().parent().remove();
			$('.detailES').hide(); 
		}
		else
			$(e).parent().parent().remove();
	}

	function fnLimpiar(){
		$('form[name=form1]')[0].reset();
		$(".detailSelect").empty();
		$(".detailES").hide();
	}

	function fnShowTooltip(e){
		$('.'+e).tooltip('show');
	}

	function fnShowMessage(){	
		if($('.alert').is(':visible'))
			$('.alert').delay(200).fadeOut(500); 
		$('.alert').delay(200).fadeIn(200); 
	}

	function fnHideMessage(){
		$('.alert').delay(200).fadeOut(500);  	
	}
</script>

