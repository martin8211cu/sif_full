
<style type="text/css">
	.form-group { margin-left: 5px; }
	.nominas { margin-top: 10px; }
	.nominas div, .tipoEmp div { float: left; }
	.conlist, .nominaCP { margin-left: 10px; margin-right: 5px; }
	.detailNomin, .detailTipoEmp { margin-top: 5px; display: none; }
	.detailNomin table { margin-left: 6%; margin-bottom: 20px; }
	.detailTipoEmp table { margin-left: 9%; margin-bottom: 15px; }
	input#Tdescripcion1, input#CPdescripcion1 { width: 210px; }
	.btns { margin-bottom: 10px; }
</style>

<!----- Etiquetas de traduccion------>
<cfset LB_Nomina = t.translate('LB_Nomina','Nómina','/rh/generales.xml')>
<cfset LB_TipoEmpleado = t.translate('LB_TipoEmpleado','Tipo Empleado','/rh/generales.xml')>
<cfset LB_ListaDeTipoEmpleado = t.translate('LB_ListaDeTipoEmpleado','Lista de Tipo Empleado','/rh/generales.xml')>
<cfset LB_Codigo  = t.translate('LB_Codigo','Código','/rh/generales.xml')>
<cfset LB_Descripcion  = t.translate('LB_Descripcion','Descripción','/rh/generales.xml')>
<cfset LB_TipoNomina = t.translate('LB_TipoNomina','Tipo de Nómina','/rh/generales.xml')>
<cfset LB_CalendarioPagos = t.translate('LB_CalendarioPagos','Calendario de Pagos','/rh/generales.xml')>
<cfset LB_Formato = t.translate('LB_Formato','Formato','/rh/generales.xml')>
<cfset LB_HTML = t.translate('LB_HTML','HTML','/rh/generales.xml')>
<cfset LB_PDF = t.translate('LB_PDF','PDF','/rh/generales.xml')>
<cfset LB_Excel = t.translate('LB_Excel','Excel','/rh/generales.xml')>
<cfset LB_NoSeEncontraronRegistros  = t.translate('LB_NoSeEncontraronRegistros','No se Encontraron Registros','/rh/generales.xml')>
<cfset LB_Generar = t.translate('LB_Generar','Generar','/rh/generales.xml')>
<cfset LB_Limpiar = t.translate('LB_Limpiar','Limpiar','/rh/generales.xml')>

<cfset MSG_Nota = t.translate('MSG_Nota','Nota')>
<cfset MSG_Requeridos = t.translate('MSG_Requeridos','Para realizar la consulta se debe seleccionar los siguientes valores')>
<cfset MSG_AddNomina = t.translate('MSG_AddNomina','Agrega la nomina y el calendario de pago seleccionado')>
<cfset MSG_Nomina = t.translate('MSG_Nomina','Debe seleccionar una nómina y un calendario de pagos para realizar esta acción')>
<cfset MSG_TipoNomina = t.translate('MSG_TipoNomina','Debe seleccionar el tipo de nómina que desea agregar a la consulta')>
<cfset MSG_CalendarPagos = t.translate('MSG_CalendarPagos','Debe seleccionar el calendario de pago que desea agregar a la consulta')>
<cfset MSG_TipoEmpleado = t.translate('MSG_TipoEmpleado','Debe seleccionar el tipo de empleado que desea agregar a la consulta')>
<cfset MSG_AddTipoEmpleado = t.translate('MSG_AddTipoEmpleado','Agrega el tipo de empleado seleccionado')>
<cfset MSG_Generar = t.translate('MSG_Generar','Genera el informe de Nómina Brutos y Netos')>
<cfset MSG_Limpiar = t.translate('MSG_Limpiar','Limpia el formulario')>

<form action="InformeNominaBrutoyNeto-sql.cfm" method="post" name="form1">
	<cfoutput>	
		<!--- Seleccion de Nominas --->
		<div class="form-group row">
			<div class="col-sm-12 nominas">
				<div>
					<label><strong>#LB_Nomina#:</strong></label>
				</div>
				<div class="nominaCP">	
					<cf_rhcalendariopagos form="form1" historicos="true" tcodigo="true" descsize="30" index="1" tabindex="1" Excluir="2">
				</div>	
				<div>
					<input type="button" class="btnNormal" value="+" onclick="fnAddSelectNom()">
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
				<tbody class="detailSelectNom">
				</tbody>	
			</table>		
		</div>
	
		<!--- Tipo de Empleado --->
		<div class="form-group row"> 
			<div class="col-sm-12 tipoEmp">
				<div>
					<label><strong>#LB_TipoEmpleado#:</strong></label>
				</div>
				<div class="conlist">	
					<cf_translatedata name="get" tabla="TiposEmpleado" col="TEdescripcion" returnvariable="LvarTEdescripcion">
					<cf_conlis
				        campos="TEid, TEcodigo, TEdescripcion"
				        asignar="TEid, TEcodigo, TEdescripcion"
				        size="0,0,35"
				        desplegables="N,S,S"
				        modificables="S,N"						
				        title="#LB_ListaDeTipoEmpleado#"
				        tabla="TiposEmpleado a"
				        columnas="TEid, TEcodigo, #LvarTEdescripcion# as TEdescripcion"
				        filtro="a.Ecodigo = #Session.Ecodigo# 
				                order by TEdescripcion"
				        filtrar_por="TEcodigo, TEdescripcion"
				        desplegar="TEcodigo, TEdescripcion"
				        etiquetas="#LB_Codigo#, #LB_Descripcion#"
				        formatos="S,S"
				        align="left,left"								
				        asignarFormatos="S,S,S"
				        form="form1"
				        top="50"
				        left="200"
				        showEmptyListMsg="true"
				        EmptyListMsg=" --- #LB_NoSeEncontraronRegistros# --- "
				        tabindex="8"
				        pageindex="8"
				    />
				</div>	
				<div>
					<input type="button" class="btnNormal" value="+" onclick="fnAddSelectTE()">
				</div>
			</div>	
		</div>	
		
		<!--- Detalle de los tipos de empleados seleccionados --->
		<div class="form-group row">
			<div class="col-sm-12 detailTipoEmp">
				<table class="PlistaTable" width="44%" cellspacing="0" cellpadding="0" border="1">
					<thead>
						<tr bgcolor="##E3EDEF">
							<th width="10%" nowrap="" align="center" class="tituloListas">#LB_Codigo#</th>
							<th width="30%" nowrap="" align="center" class="tituloListas">#LB_TipoEmpleado#</th>
							<th width="4%" nowrap="" align="center" class="tituloListas"></th>
						</tr>	
					</thead>
					<tbody class="detailSelectTE">
					</tbody>	
				</table>		
			</div>
		</div>

		<!--- Formato salida reporte --->
		<div class="form-group row">
			<div class="col-sm-12">
				<label class="lbFormato"> #LB_Formato#: </label>
				<cfparam name="Form.sFormato" default="html">
				<select name="sFormato">
					<option value="html"> #LB_HTML# </option>
					<option value="pdf"> #LB_PDF# </option>
					<option value="excel"> #LB_Excel# </option>
				</select>
			</div> 	
        </div>

        <!--- Botones de acciones del reporte --->
		<div class="form-group row"> 
	        <div class="col-sm-9 col-sm-offset-3 btns">
				<input type="submit" onclick="return fnValSubmit();" class="btnGenerar" title="#MSG_Generar#" value="#LB_Generar#">
				<input type="reset" onclick="fnLimpiar()" class="btnLimpiar" title="#MSG_Limpiar#" value="#LB_Limpiar#">
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
		var mensaje = '<strong>¡<cfoutput>#MSG_Nota#</cfoutput>!</strong> <cfoutput>#MSG_Requeridos#</cfoutput>:<br/><br/>';

		if(!$('.detailNomin').is(':visible')){
			mensaje += '-> <cfoutput>#LB_TipoNomina#</cfoutput><br/>-> <cfoutput>#LB_CalendarioPagos#</cfoutput><br/>';
			result = false;
			alert(mensaje);
		}

		return result;
	}

	function fnAddSelectNom(){
		result = fnValidarElement("Tcodigo1",'<cfoutput>#MSG_TipoNomina#</cfoutput>');

		if(result){
			result = fnValidarElement("CPcodigo1",'<cfoutput>#MSG_CalendarPagos#</cfoutput>');	
			if(result)
				fnAddElementNom(1);
		}		
	}

	function fnAddSelectTE(){
		result = fnValidarElement("TEcodigo",'<cfoutput>#MSG_TipoEmpleado#</cfoutput>');

		if(result)
			fnAddElementTE();	
	}

	function fnValidarElement(e,showMsg){
		var mensaje = '<strong>¡<cfoutput>#MSG_Nota#</cfoutput>!</strong> '; 
		var result = true;

		if ((document.getElementById(e).value).trim() == ''){
			mensaje += showMsg;
			result = false;
			alert(mensaje);
		}

		return result;
	}

	function fnAddElementNom(val){
		var result = "", element = "", Tcodigo = "Tcodigo", Tdescripcion = "Tdescripcion", CPcodigo = "CPcodigo", CPdescripcion = "CPdescripcion", CPid = "CPid";

		Tcodigo = (document.getElementById(Tcodigo+val).value).trim();
		Tdescripcion = (document.getElementById(Tdescripcion+val).value).trim();		
		CPcodigo = (document.getElementById(CPcodigo+val).value).trim();		
		CPdescripcion = (document.getElementById(CPdescripcion+val).value).trim();	
		CPid = (document.getElementById(CPid+val).value).trim();

		element = CPid;

		if($("input[name=TcodigoListNom][value='"+element+"']").length == 0){
			result = '<tr id="'+element+'"><td valign="bottom" align="left">'+Tcodigo+'</td>';
			result += '<td valign="bottom" align="left">'+Tdescripcion+'</td>';
			result += '<td valign="bottom" align="left">'+CPcodigo+'</td>';
			result += '<td valign="bottom" align="left">'+CPdescripcion+'</td>';
			result += '<td align="center"><a style="padding:0" class="btn" title="Eliminar" onclick="fnDelElement(this,1)"><i class="fa fa-times fa-sm"></i></a></td><input type="hidden" name="TcodigoListNom" value="'+element+'"/></tr>';

			$(".detailSelectNom").append(result);

			if(!$('.detailNomin').is(':visible'))
				$('.detailNomin').show();  

			$('#Tcodigo1, #Tdescripcion1, #CPcodigo1, #CPdescripcion1').val('');
		}	
	}

	function fnAddElementTE(){
		var result = "", element = "", TEcodigo = "TEcodigo", TEdescripcion = "TEdescripcion", TEid = "TEid";

		TEcodigo = (document.getElementById(TEcodigo).value).trim();
		TEdescripcion = (document.getElementById(TEdescripcion).value).trim();		
		TEid = (document.getElementById(TEid).value).trim();

		element = TEid;

		if($("input[name=TcodigoListTE][value='"+element+"']").length == 0){
			result = '<tr id="'+element+'"><td valign="bottom" align="left">'+TEcodigo+'</td>';
			result += '<td valign="bottom" align="left">'+TEdescripcion+'</td>';
			result += '<td align="center"><a style="padding:0" class="btn" title="Eliminar" onclick="fnDelElement(this,2)"><i class="fa fa-times fa-sm"></i></a></td><input type="hidden" name="TcodigoListTE" value="'+element+'"/></tr>';

			$(".detailSelectTE").append(result);

			if(!$('.detailTipoEmp').is(':visible'))
				$('.detailTipoEmp').show();  

			$('#TEcodigo, #TEdescripcion').val('');
		}	
	}

	function fnDelElement(e,val){
		var dtSelect = '', dtPadre = '';

		if(val == 1){ //nominas
			dtPadre = '.detailNomin';
			dtSelect = '.detailSelectNom tr';
		}	
		else{ //tipos empleados(2)
			dtPadre = '.detailTipoEmp';
			dtSelect = '.detailSelectTE tr';
		}	
		
		if($(dtSelect).length == 1){
			$(e).parent().parent().remove();
			$(dtPadre).hide(); 
		}
		else
			$(e).parent().parent().remove();
	}

	function fnLimpiar(){
		$('form[name=form1]')[0].reset();
		$(".detailSelectNom, .detailSelectTE").empty();
		$(".detailNomin, .detailTipoEmp").hide();
	}
</script>