
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
<cfset LB_Consultar = t.translate('LB_Consultar','Generar información','/rh/generales.xml')>
<cfset LB_ExportarExcel = t.translate('LB_ExportarExcel','Exportar a Excel')>
<cfset LB_Limpiar = t.translate('LB_Limpiar','Limpiar','/rh/generales.xml')>
<cfset MSG_Nota = t.translate('MSG_Nota','Nota')>
<cfset MSG_CentroFuncional = t.translate('MSG_CentroFuncional','Debe seleccionar un centro funcional para realizar la consulta')>
<cfset MSG_FechaCorte = t.translate('MSG_FechaCorte','Debe seleccionar la fecha de corte para realizar la consulta')>
<cfset MSG_Consultar = t.translate('MSG_Consultar','Consulta la información de las nóminas seleccionadas')>
<cfset MSG_Exportar = t.translate('MSG_Exportar','Exportar la información de las nóminas seleccionadas')>
<cfset MSG_Limpiar = t.translate('MSG_Limpiar','Inicializa todos los valores del formulario')>

<cfset MSG_Proceso_satisfactorio = t.translate('MSG_Proceso_satisfactorio','Proceso Satisfactorio')>


<cfset LB_FechaGenerado = t.translate('LB_FechaGenerado','Fecha última generación de información','/rh/generales.xml')>

<cfquery name="rsRaiz" datasource="#session.DSN#">
	Select CFid, CFcodigo, CFdescripcion
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> and 
				CFcodigo = 'RAIZ'
</cfquery>


<cfquery name="rsUltimo" datasource="#session.DSN#">
	Select distinct FGenerada
		from RHEstCesantiaCF
</cfquery>

<!--- <cfquery name="rsUltimo" datasource="#session.DSN#">
	Select getdate() as FGenerada
		from dual
</cfquery> --->

<cfif isDefined('form.VerMensaje') and form.VerMensaje>
	<cf_jnotify Titulo="#MSG_Proceso_satisfactorio#" Tipo="Informacion">
</cfif>

<div >	
	<form action="GenerarEstimacionCesantiaFundatec-sql.cfm" method="post" name="form1">
		<cfoutput>
			<input name="CFid" type="hidden" value="#rsRaiz.CFid#">
			<input name="dependencias" type="hidden" value="1">

			<div class="col-sm-4" >
				<div class="col-sm-12 observaciones">
					<span><strong>*** La infomación esta generada al: [<cf_locale name="date" value="#rsUltimo.FGenerada#"/> ] al consultar se elimina la información anterior y se genera una infomación a la fecha de corte </strong></span>
				</div>
			</div>
			<div class="col-sm-8" >
				<div class="form-group row">
					<div class="col-sm-12 cntrFuncional">
						<cfset form.CFuncional = 'RAIZ'>
						<label><span><strong>#LB_CentroFuncional#:</strong></span></label>
						<cf_rhcfuncional form="form1" query="#rsRaiz#" tabindex="1" readonly="true">

                        <input type="checkbox" name="dependencias" tabindex="1" checked= "checked" disabled > 
                        <label><cf_translate key="LB_Incluir_Dependencias">Incluir Dependencias</cf_translate>&nbsp;</label>
					</div>	
 
				</div>	

				<div class="form-group row">
					<div class="col-sm-12 fechCorte">
						<span><strong>#LB_FechaCorte#:</strong></span>
						<cf_sifcalendario form="form1" tabindex="1" name="FechaCorte" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
					</div>

					 

					<div class="col-sm-12 buttons">
						<div class="col-sm-12">
							<a id="btnConsultar" onclick="fnValidarConsult()" onmouseover="fnShowTooltip('btnConsultar')" class="btn btn-primary btn-sm" data-toggle="tooltip" data-placement="top" title="#MSG_Consultar#"><i class="fa fa-check fa-sm"></i>#LB_Consultar#</a>	
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

	

			result = fnValidarElement("FechaCorte",'#MSG_FechaCorte#'); 
			
			return result;
		}


	function fnValidarConsult(){
		if(fnValidar()){ 
			// $('.chkOpcion').val(1);
			$('form[name=form1]').submit();
		}	
	}
		
	function fnValidarExport(){
		if(fnValidar()){
			// $('.chkOpcion').val(0);
			$('form[name=form1]').submit();
		}	
	}

	function fnLimpiar(){
		$('form[name=form1]')[0].reset();
		// $(".empresasCoorp").delay(200).fadeOut(400);
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