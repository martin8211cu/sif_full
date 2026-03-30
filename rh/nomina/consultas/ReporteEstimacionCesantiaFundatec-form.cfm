
<style type="text/css">
	.well { padding: 25px 10px 15px 10px; margin-top: 10px; margin-bottom: 15px; overflow: hidden; }
	.empresasCoorp { display: none; }
	.corporativo, .empresasCoorp, .cntrFuncional, .fechCorte, .mostrarComo, .ordenamiento { margin-left: 10%; overflow: hidden; }
	.cntrFuncional span { float: left; margin-right: 44px; }
	.fechCorte span { margin-right: 71px; }
	.mostrarComo, .ordenamiento { padding-top: 15px; }
	.mostrarComo span { margin-right: 75px; float: left; }
	.mostrarComo div { margin-right: 170px; float: left; }
	.ordenamiento span { margin-right: 62px; float: left; }
	.tiposOrd { float: left; width: 75%; overflow: hidden; }
	.tiposOrd div { float: left; margin-right: 50px; }
	.buttons { margin-top: 15px; margin-left: 29%; overflow: hidden; padding-top: 8px;}
	.alert { position: fixed; top: 35%; right: 41%; display:none; width: 330px !important; }
</style>

<!----- Etiquetas de traduccion------>
<cfset LB_EsCorporativo = t.translate('LB_EsCorporativo','Es Corporativo','/rh/generales.xml')>
<cfset LB_CentroFuncional = t.translate('LB_CentroFuncional','Centro Funcional','/rh/generales.xml')>
<cfset LB_Empleado = t.translate('LB_Empleado','Empleado','/rh/generales.xml')>
<cfset LB_FechaCorte = t.translate('LB_FechaCorte','Fecha Corte','/rh/generales.xml')>
<cfset LB_TodasLasEmpresas = t.translate('LB_TodasLasEmpresas','Todas las Empresas','/rh/generales.xml')>
<cfset LB_Nombre = t.translate('LB_Nombre','Nombre','/rh/generales.xml')>
<cfset LB_Apellido = t.translate('LB_Apellido','Apellido','/rh/generales.xml')>
<cfset LB_Identificacion = t.translate('LB_Identificacion','Identificación','/rh/generales.xml')>
<cfset LB_MostrarPor = t.translate('LB_MostrarPor','Mostrar Por','/rh/generales.xml')>
<cfset LB_OrdenadoPor = t.translate('LB_OrdenadoPor','Ordenado Por','/rh/generales.xml')>
<cfset LB_Consultar = t.translate('LB_Consultar','Consultar','/rh/generales.xml')>
<cfset LB_ExportarExcel = t.translate('LB_ExportarExcel','Exportar a Excel')>
<cfset LB_Limpiar = t.translate('LB_Limpiar','Limpiar','/rh/generales.xml')>
<cfset MSG_Nota = t.translate('MSG_Nota','Nota')>
<cfset MSG_CentroFuncional = t.translate('MSG_CentroFuncional','Debe seleccionar un centro funcional para realizar la consulta')>
<cfset MSG_FechaCorte = t.translate('MSG_FechaCorte','Debe seleccionar la fecha de corte para realizar la consulta')>
<cfset MSG_Consultar = t.translate('MSG_Consultar','Consulta la información de las nóminas seleccionadas')>
<cfset MSG_Exportar = t.translate('MSG_Exportar','Exportar la información de las nóminas seleccionadas')>
<cfset MSG_Limpiar = t.translate('MSG_Limpiar','Inicializa todos los valores del formulario')>



<cfquery name="rsUltimo" datasource="#session.DSN#">
	Select distinct FGenerada
		from RHEstCesantiaCF
</cfquery>

<!--- 
<cfquery name="rsUltimo" datasource="#session.DSN#">
	Select getdate() as FGenerada
		from dual
</cfquery>
 --->


<div >	
	<form action="ReporteEstimacionCesantiaFundatec-sql.cfm" method="post" name="form1">
		<cfoutput>
			<cfparam name="ordenamiento" default="1">
			<cfparam name="mostrarComo" default="1">

			<div class="col-sm-4" >
				<div class="col-sm-12 observaciones">
					<span><strong>*** La infomación esta generada al: [<cf_locale name="date" value="#rsUltimo.FGenerada#"/> ]</strong></span>
				</div>
			</div>
			<div class="col-sm-8" >
				<div class="form-group row">
					<div class="col-sm-12 cntrFuncional">
						<label><span><strong>#LB_CentroFuncional#:</strong></span></label>
						<cf_rhcfuncional form="form1" name="CFuncional" tabindex="1">
                        <input type="checkbox" name="dependencias" tabindex="1">
                        <label><cf_translate key="LB_Incluir_Dependencias">Incluir Dependencias</cf_translate>&nbsp;</label>
					</div>	

					<div class="col-sm-12 ordenamiento">
						<label><span><strong>#LB_Empleado#:</strong></span></label>
							<cf_rhempleado  tabindex="1" TipoId = -1> 
					</div>
				</div>	

				


				<div class="form-group row">

					<div class="col-sm-12 mostrarComo">
						<span><strong>#LB_MostrarPor#:</strong></span>
						<div>
							<input type="radio" name="mostrarComo" value="1" <cfif mostrarComo EQ 1>checked</cfif>/> <b/>#LB_Nombre#, #LB_Apellido# 
						</div>	
						<div>
							<input type="radio" name="mostrarComo" value="2" <cfif mostrarComo EQ 2>checked</cfif>/> <b/>#LB_Apellido#, #LB_Nombre#
						</div>		
					</div>

					<div class="col-sm-12 ordenamiento">
						<span><strong>#LB_OrdenadoPor#:</strong></span>
						<div class="tiposOrd">
							<div>
								<input type="radio" name="ordenamiento" value="1" <cfif ordenamiento EQ 1>checked</cfif>/> <b/>#LB_Apellido#, #LB_Nombre#
							</div>
							<div>
								<input type="radio" name="ordenamiento" value="2" <cfif ordenamiento EQ 2>checked</cfif>/> <b/>#LB_Nombre#, #LB_Apellido# 
							</div>
							<div>
								<input type="radio" name="ordenamiento" value="3" <cfif ordenamiento EQ 3>checked</cfif>/> <b/>#LB_Identificacion#
							</div>
						</div>	
					</div>

					<div class="col-sm-12 buttons">
						<div class="col-sm-12">
							<a id="btnConsultar" onclick="fnValidarConsult()" onmouseover="fnShowTooltip('btnConsultar')" class="btn btn-primary btn-sm" data-toggle="tooltip" data-placement="top" title="#MSG_Consultar#"><i class="fa fa-check fa-sm"></i>#LB_Consultar#</a>	

							<a id="btnExportar" onclick="fnValidarExport()" onmouseover="fnShowTooltip('btnExportar')" class="btn btn-success btn-sm" data-toggle="tooltip" data-placement="top" title="#MSG_Exportar#"> <i class="fa fa-check fa-sm"></i>#LB_ExportarExcel#</a>

							<a id="btnLimpiar" onclick="fnLimpiar()" onmouseover="fnShowTooltip('btnLimpiar')" class="btn btn-warning btn-sm" data-toggle="tooltip" data-placement="top" title="#MSG_Limpiar#"> <i class="fa fa-check fa-sm"></i>#LB_Limpiar#</a>			        
				        </div>
					</div>	
				</div>		
			</div>
			
		</cfoutput>
		<input type="hidden" name="chkOpcion" class="chkOpcion" value="1" />
	</form>
	<div class="alert alert-danger alert-dismissable msjInfoDel">
		<a onclick="fnHideMessage()" class="close" aria-hidden="true">&times;</a>
	    <span></span>
	</div>
</div>

<script type="text/javascript">
<cfoutput>

		function fnValidarElement(e,showMsg){
			var mensaje = '<strong>¡#MSG_Nota#!</strong> ';
			var result = true;

			if (document.getElementById(e).value == ''){
				mensaje += showMsg;
				result = false;
				$('.alert span').html(mensaje);
				fnShowMessage();
			}
			return result;
		}

		function fnValidar(){
			var result = true;
			var mensaje = '<strong>¡#MSG_Nota#!</strong> ';

			result = fnValidarElement("CFuncional",'#MSG_CentroFuncional#'); 
	
						
			return result;
		}
</cfoutput>

	function fnValidarConsult(){
		if(fnValidar()){ 
			$('.chkOpcion').val(1);
			$('form[name=form1]').submit();
		}	
	}
		
	function fnValidarExport(){
		if(fnValidar()){
			$('.chkOpcion').val(0);
			$('form[name=form1]').submit();
		}	
	}

	function fnLimpiar(){
		$('form[name=form1]')[0].reset();
		$(".cntrFuncional").delay(600).fadeIn(200);
	}

	function fnShowTooltip(e){
		$('#'+e).tooltip('show');
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