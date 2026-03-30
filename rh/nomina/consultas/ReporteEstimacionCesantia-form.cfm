
<style type="text/css">
	.fechCorte { margin-bottom: 5px; }
	.cntrFuncional { clear: left; }
	.tree { margin-left: -13px; }
	.mostrarComo, .ordenamiento, .btns { margin-top: 5px; }
	.cntrFuncional .cntrs div { float: left; }
	.mostrarPor label, .ordenamiento label { margin-right: 30px; }
	.encabezado div { background-color: #B0C8D3; padding-top: 6px; height: 28px; margin-bottom: 0; }
	.detListCF .row, .detListCF .row div { height: 34px; margin-bottom: 0; padding-top: 4px; }
	.detListCF .row { padding-top: 2px; }
	.detListCF .btn { margin-left: 20px; }
	.btns { margin-bottom: 15px; }
</style>

<cfset t = createObject("component", "sif.Componentes.Translate")>

<!--- Etiquetas de traduccion --->
<cfset LB_Codigo = t.translate('LB_Codigo','Código','/rh/generales.xml')>
<cfset LB_Descripcion = t.translate('LB_Descripcion','Descripción','/rh/generales.xml')>
<cfset LB_CentroFuncional = t.translate('LB_CentroFuncional','Centro Funcional','/rh/generales.xml')>
<cfset LB_ListaCentrosFuncionales = t.translate('LB_ListaCentrosFuncionales','Lista de Centros Funcionales')>
<cfset LB_Incluir_Dependencias = t.translate('LB_Incluir_Dependencias','Incluir Dependencias')>
<cfset LB_FechaCorte = t.translate('LB_FechaCorte','Fecha Corte','/rh/generales.xml')>
<cfset LB_Nombre = t.translate('LB_Nombre','Nombre','/rh/generales.xml')>
<cfset LB_Apellido = t.translate('LB_Apellido','Apellido','/rh/generales.xml')>
<cfset LB_Identificacion = t.translate('LB_Identificacion','Identificación','/rh/generales.xml')>
<cfset LB_MostrarPor = t.translate('LB_MostrarPor','Mostrar Por','/rh/generales.xml')>
<cfset LB_OrdenadoPor = t.translate('LB_OrdenadoPor','Ordenado Por','/rh/generales.xml')>
<cfset LB_Consultar = t.translate('LB_Consultar','Consultar','/rh/generales.xml')>
<cfset LB_ExportarExcel = t.translate('LB_ExportarExcel','Exportar a Excel')>
<cfset LB_Limpiar = t.translate('LB_Limpiar','Limpiar','/rh/generales.xml')>
<cfset LB_Eliminar = t.translate('LB_Eliminar','Eliminar','/rh/generales.xml')>
<cfset LB_NoSeEncontraronRegistros  = t.translate('LB_NoSeEncontraronRegistros','No se Encontraron Registros','/rh/generales.xml')>
<cfset MSG_Nota = t.translate('MSG_Nota','Nota')>
<cfset MSG_ADDCentroFuncional = t.translate('MSG_ADDCentroFuncional','Debe seleccionar el centro funcional que desea agregar a la consulta')>
<cfset MSG_CentroFuncional = t.translate('MSG_CentroFuncional','Debe seleccionar un centro funcional para realizar esta acción')>
<cfset MSG_FechaCorte = t.translate('MSG_FechaCorte','Debe seleccionar la fecha de corte para realizar la consulta')>
<cfset MSG_Consultar = t.translate('MSG_Consultar','Consulta la información de las nóminas seleccionadas')>
<cfset MSG_Exportar = t.translate('MSG_Exportar','Exportar la información de las nóminas seleccionadas')>
<cfset MSG_Limpiar = t.translate('MSG_Limpiar','Inicializa todos los valores del formulario')>


<!--- Consulta si empresa(session) tiene habilitada la opcion de permitir consultas corporativas --->
<cfquery name="rsPmtConsCorp" datasource="#Session.DSN#">
    select Pvalor
    from RHParametros
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> and Pcodigo = 2715
</cfquery>

<cfif rsPmtConsCorp.recordCount gt 0 and rsPmtConsCorp.Pvalor eq '1'>
    <cfset lvPmtConsCorp = 1 >
<cfelse>
    <cfset lvPmtConsCorp = 0 >  
</cfif>


<cfoutput>
	<form name="form1" action="ReporteEstimacionCesantia-sql.cfm" method="post" >
		<cfparam name="ordenamiento" default="1">
		<cfparam name="mostrarComo" default="1">

		<!--- Valida si esta habilitado las consultas corporativas --->
	    <cfif lvPmtConsCorp eq 1>
	        <!--- Check de consulta coorporativa --->
	        <div class="form-group">
	        	<label class="col-md-2 control-label"></label>
	            <div class="col-md-7 tree">
	    			<cf_rharbolempresas> 
    			</div>  
	        </div>
	    </cfif>  

		<!--- Seleccion del Centro Funcional --->
		<div class="form-group cntrFuncional">
			<label class="col-md-2 control-label text-right">#LB_CentroFuncional#:</label>
			<div class="col-md-10 cntrs">
				<div class="conlist">
					<input type="hidden" id="listNSCF" name="listNSCF" value="0"/>
					<cf_translatedata name="get" tabla="CFuncional" col="CFdescripcion" returnvariable="LvarCFdescripcion">	
					<cf_conlis
				        campos="CFcodigo, CFdescripcion"
				        asignar="CFcodigo, CFdescripcion"
				        size="0,35"
				        desplegables="S,S"
				        modificables="S,N"						
				        title="#LB_ListaCentrosFuncionales#"
				        tabla="CFuncional"
				        columnas="distinct CFcodigo, #LvarCFdescripcion# as CFdescripcion"
				        filtro="Ecodigo in ($jtreeListaItem,numeric$) and CFcodigo not in ($listNSCF,char$) order by #LvarCFdescripcion#"
				        filtrar_por="CFcodigo, CFdescripcion"
				        desplegar="CFcodigo, CFdescripcion"
				        etiquetas="#LB_Codigo#, #LB_Descripcion#"
				        formatos="S,S"
				        align="left,left"								
				        asignarFormatos="S,S"
				        form="form1"
				        top="50"
				        left="200"
				        showEmptyListMsg="true"
				        EmptyListMsg=" --- #LB_NoSeEncontraronRegistros# --- "
				        tabindex="11"
				        pageindex="11"
				    /> 			
				</div>	
				<div>
					<input type="button" class="btnNormal" value="+" onclick="fnAddSelect()">
                	<input type="checkbox" name="dependencias" tabindex="1">
                	<label>#LB_Incluir_Dependencias#</label>
                </div>	
            </div>	      	
		</div>	

		<!--- Detalle de los Centros Funcionales seleccionados --->
        <div class="form-group detailCF" style="display:none;">
        	<label class="col-md-2 control-label"></label>
	        <div class="col-md-10 listCF">
	        	<div class="row encabezado">
	        		<div class="col-xs-3"><label><strong>#LB_Codigo#</strong></label></div>
		            <div class="col-xs-6"><label><strong>#LB_CentroFuncional#</strong></label></div>
	        	</div>	
				<div class="detListCF">
				</div>	
			</div>
		</div>	
			
		<!--- Seleccion de la Fecha Corte --->	
		<div class="form-group">
			<label for="fechCorte" class="col-md-2 control-label text-right">#LB_FechaCorte#:</label>
			<div class="col-md-10 fechCorte">
				<cf_sifcalendario form="form1" tabindex="1" name="FechaCorte" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
			</div>
		</div>		

		<!--- Seleccion del Mostrar Como --->	
		<div class="form-group">
			<label for="mostrarPor" class="col-md-2 control-label text-right">#LB_MostrarPor#:</label>
			<div class="col-md-10 mostrarPor">
				<input type="radio" name="mostrarComo" value="1" <cfif mostrarComo EQ 1>checked</cfif>/> 
				<label><strong>#LB_Nombre#, #LB_Apellido#</strong></label>

				<input type="radio" name="mostrarComo" value="2" <cfif mostrarComo EQ 2>checked</cfif>/> 
				<label><strong>#LB_Apellido#, #LB_Nombre#</strong></label>
			</div>		
		</div>	

		<!--- Seleccion del Ordenamiento --->
		<div class="form-group">
			<label for="ordenadoPor" class="col-md-2 control-label text-right">#LB_OrdenadoPor#:</label>
			<div class="col-md-10 ordenamiento">
				<input type="radio" name="ordenamiento" value="1" <cfif ordenamiento EQ 1>checked</cfif>/> 
				<label><strong>#LB_Apellido#, #LB_Nombre#</strong></label>

				<input type="radio" name="ordenamiento" value="2" <cfif ordenamiento EQ 2>checked</cfif>/> 
				<label><strong>#LB_Nombre#, #LB_Apellido#</strong></label> 

				<input type="radio" name="ordenamiento" value="3" <cfif ordenamiento EQ 3>checked</cfif>/> 
				<label><strong>#LB_Identificacion#</strong></label>
			</div>
		</div>	
			
		<!--- Botones de acciones del reporte --->	
		<div class="form-group"> 
	        <div class="col-sm-10 col-sm-offset-2 btns">
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

	$('#esCorporativo').click(function(){
		if($(this).prop('checked'))
			$('#CFcodigo, #CFdescripcion').val('');
	});
	
	// Funcion que valida si los elementos requeridos han sido suministrados por el usuario para realizar submit del form
	function fnValSubmit(){
		var result = true;
		var mensaje = '<strong>¡<cfoutput>#MSG_Nota#</cfoutput>!</strong> ';

		if(!$('.detailCF').is(':visible')) {
			mensaje += '<cfoutput>#MSG_CentroFuncional#</cfoutput>';
			result = false;
			alert(mensaje);
		}
	
		if(result)
			result = fnValidarElement("FechaCorte",'<cfoutput>#MSG_FechaCorte#</cfoutput>'); 
		
		return result;
	}

	//Funcion que valida si un elemento requerido no ha sido suministrado
	function fnValidarElement(e,showMsg){
		var mensaje = '<strong>¡<cfoutput>#MSG_Nota#</cfoutput>!</strong> ';
		var result = true;

		if (document.getElementById(e).value == ''){
			mensaje += showMsg;
			result = false;
			alert(mensaje);
		}
		return result;
	}

	// Funcion para validar la seleccion que se desea agregar a consulta
	function fnAddSelect(){
		var result = true;
        var mensaje = '<strong>¡<cfoutput>#MSG_Nota#</cfoutput>!</strong> ';

        if($('#CFcodigo').val().trim() == ''){
    		mensaje += '<cfoutput>#MSG_ADDCentroFuncional#</cfoutput>';
        	result = false;
    	}	

    	if(result)
    		fnAddCF();
    	else
    		alert(mensaje);		
	}

	//Funcion para agregar un Centro Funcional seleccionado
	function fnAddCF(){
		var elementHTML = "", vCFcodigo = "", vCFdescripcion = "";

    	vCFcodigo = $('#CFcodigo').val().trim(); 
    	vCFdescripcion = $('#CFdescripcion').val().trim(); 
    	
    	if($('#'+vCFcodigo).length == 0){
            elementHTML = '<div class="row" id="'+vCFcodigo+'"><div class="col-xs-3">'+vCFcodigo+'</div><div class="col-xs-5">'+vCFdescripcion+'</div><div class="col-xs-1"><a style="cursor: pointer" title="<cfoutput>#LB_Eliminar#</cfoutput>" onclick="fnDelElement(this)"><i class="fa fa-times fa-sm"></i></a></div><input type="hidden" name="ListCF" value="'+vCFcodigo+'"/></div>';
            $('.detListCF').append(elementHTML);

            if(!$('.detailCF').is(':visible'))
                $('.detailCF').show();

            $('#listNSCF').val($('#listNSCF').val()+','+vCFcodigo);

            $('#CFcodigo,#CFdescripcion').delay(150).queue(function(){
            	$(this).val('');
	            $(this).dequeue();
	        });   
        } 
	}

	//Funcion para eliminar un elemento de la lista seleccionada
	function fnDelElement(e){
		var vListElements = "0";

		$(e).parent().parent().remove();

		if(!$('.detailCF .detListCF div').length)
			$('.detailCF').hide(); 

		$('input[name=ListCF]').each(function(i){
			vListElements += ','+ $(this).val();
		});	

		$('#listNSCF').val(vListElements);
	}

	//Funcion para inicializar(reset) los elementos del form
	function fnLimpiar(){
		$('form[name=form1]')[0].reset();
		$(".detListCF").empty();
		$(".divArbol, .detailCF").hide();
		$('.listTree').listTree('deselectAll');
		$('#CFcodigo, #CFdescripcion').val('');
		$(".cntrFuncional").show();
		$('#jtreeListaItem').val('<cfoutput>#session.Ecodigo#</cfoutput>'); 
		$('#listNSCF').val('0');
	}
</script>