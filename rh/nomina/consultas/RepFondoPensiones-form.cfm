
<style type="text/css">
	.form-group { margin-bottom: 8px; }
	.nominas { margin-top: 5px; }
	input#Tdescripcion1, input#Tdescripcion2, input#CPdescripcion1, input#CPdescripcion2 { width: 190px; }
	.nominas div, .filterDates div { float: left; }
	.calPGProc, .calPGAply { margin-left: 3px; }
	.addNomin { margin-left: 5px; }
	.selectDates { margin-left: 60px; }
	.selectDates div { margin-right: 40px; }
	.detailNom .listNom { margin-bottom: 10px; margin-top: 10px; }
	.detailNom .encabezado, .detListNom { width: 90%; }
	.encabezado div { background-color: #B0C8D3; padding-top: 6px; height: 28px; margin-bottom: 0; }
	.detListNom .row, .detListNom .row div { height: 34px; margin-bottom: 0; padding-top: 4px; }
	.detListNom .row { padding-top: 2px; width: 100%; }
	.detListNom .row:nth-child(2n) div { background-color: #ffffff; }
	.detListNom .btn { margin-left: 20px; }
	.GCargas label, .GCargas select { float: left; }
	.GCargas label { padding-left: 65px; }
	.GCargas select { margin-left: 7px;  margin-right: 7px; width: 280px; }
	.detailCargas { margin-bottom: 20px; }
	.encabezado, .detListCargas { margin-left: -2px; width: 87%; }
	.encabezado label { margin-left: -13px; }
	.detListCargas .row, .detListCargas .row div { height: 35px; margin-bottom: 0; }
	.detListCargas .encGC { padding-top: 2px; margin-left: -1px; width: 100%; }
	.detListCargas .encGC div { background-color: #ffffff; }
	.detListCargas .encGC .lbCod label { margin-left: -9px; }
	.detListCargas .encGC .btn { margin-left: 20px; }
    .detListCargas div { padding-top: 3px; padding-bottom: 3px; }
	.divArbol .listTree { margin-left: 176px; width: 50% } 
	.btns { margin-bottom: 10px; }
</style>


<cfset t = createObject("component", "sif.Componentes.Translate")>   

<!--- Etiquetas de traducción --->
<cfset LB_NominasAplicadas = t.translate('LB_NominasAplicadas','Nóminas Aplicadas','/rh/generales.xml')>
<cfset LB_Nomina = t.translate('LB_Nomina','Nómina','/rh/generales.xml')/>
<cfset LB_ListaDeTiposNomina = t.translate('LB_ListaDeTiposNomina','Lista de Tipos de Nómina','/rh/generales.xml')>
<cfset LB_Tipo = t.translate('LB_Tipo','Tipo','/rh/generales.xml')>
<cfset LB_CalendarioPago = t.translate('LB_CalendarioPago','Calendario Pago','/rh/indexReportes.xml')>
<cfset LB_FiltroFechas = t.translate('LB_FiltroFechas','Utilizar filtro de fechas','/rh/generales.xml')>
<cfset LB_Fecha_Desde = t.translate('LB_Fecha_Desde','Fecha Desde','/rh/generales.xml')>
<cfset LB_Fecha_Hasta = t.translate('LB_Fecha_Hasta','Fecha Hasta','/rh/generales.xml')>
<cfset LB_EsCorporativo = t.translate('LB_EsCorporativo','Es Corporativo','/rh/generales.xml')>
<cfset LB_GrupoCargas = t.translate('LB_GrupoCargas','Grupo de Cargas','/rh/generales.xml')/>
<cfset LB_Codigo = t.translate('LB_Codigo','Código','/rh/generales.xml')/>
<cfset LB_Descripcion = t.translate('LB_Descripcion','Descripción','/rh/generales.xml')/>
<cfset LB_GrupoCarga = t.translate('LB_GrupoCarga','Grupo de Carga','/rh/generales.xml')>
<cfset LB_SeleccioneGrupoCarga = t.translate('LB_SeleccioneGrupoCarga','Seleccione Grupo de Carga','/rh/generales.xml')>
<cfset LB_Grupo = t.translate('LB_Grupo','Grupo','/rh/generales.xml')>
<cfset LB_Cargas = t.translate('LB_Cargas','Cargas','/rh/generales.xml')>
<cfset LB_Consultar = t.translate('LB_Consultar','Consultar','/rh/generales.xml')>
<cfset LB_ExportarExcel = t.translate('LB_ExportarExcel','Exportar a Excel')>
<cfset LB_Limpiar = t.translate('LB_Limpiar','Limpiar','/rh/generales.xml')> 
<cfset LB_Eliminar = t.translate('LB_Eliminar','Eliminar','/rh/generales.xml')>
<cfset LB_NoSeEncontraronRegistros  = t.translate('LB_NoSeEncontraronRegistros','No se Encontraron Registros','/rh/generales.xml')>

<cfset MSG_Nota = t.translate('MSG_Nota','Nota','/rh/generales.xml')>
<cfset MSG_Requeridos = t.translate('MSG_Requeridos','Para realizar la consulta se debe seleccionar los siguientes valores','/rh/generales.xml')>
<cfset MSG_TipoNomina = t.translate('MSG_TipoNomina','Debe seleccionar el tipo de nómina que desea agregar a la consulta')>
<cfset MSG_CalendarPagos = t.translate('MSG_CalendarPagos','Debe seleccionar el calendario de pago que desea agregar a la consulta')>
<cfset MSG_NominaSelect = t.translate('MSG_NominaSelect','Debe seleccionar al menos una nómina y un calendario de pagos para realizar esta acción')>
<cfset MSG_FechaDesde = t.translate('MSG_FechaDesde','Debe seleccionar la fecha inicial del rango de la consulta')>
<cfset MSG_FechaHasta = t.translate('MSG_FechaHasta','Debe seleccionar la fecha final del rango de la consulta')>
<cfset MSG_GrupoCargas = t.translate('MSG_GrupoCargas','Debe seleccionar un grupo de cargas para agregar a la consulta')>


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


<!--- Obtiene los grupos de cargas --->
<cf_translatedata name="get" tabla="ECargas" col="ECdescripcion" returnvariable="LvarECdescripcion">
<cfquery name="rsListGC" datasource="#session.DSN#">
	select ec.ECcodigo, #LvarECdescripcion# as ECdescripcion
	from ECargas ec 
	where ec.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by ec.ECcodigo
</cfquery>


<cfoutput>
	<form class="bs-example form-horizontal" action="RepFondoPensiones-sql.cfm" method="post" name="form1" style="margin:0">
		<cfif lvPmtConsCorp eq 1>
	        <!--- Check de consulta coorporativa --->
	        <div class="form-group">
	        	<div class="col-sm-12">
		    		<cf_rharbolempresas>
		        </div>	
	        </div>
	    <cfelse>
		    <input type="hidden" name="jtreeListaItem" id="jtreeListaItem" value="#session.Ecodigo#">    
	    </cfif>

		<!--- Check para mostrar las nominas aplicadas --->
		<div class="form-group">
			<span class="col-sm-12 ckNomAply">
				<label><strong>#LB_NominasAplicadas#:</strong></label>
				<input type="checkbox" name="chk_NominaAplicada" id="chk_NominaAplicada"> 
			</span>
		</div>

		<!--- Seleccion de Nominas Aplicadas/Proceso --->
		<div class="form-group">
			<div class="col-sm-12 nominas">
				<div>
					<label for="Nomina"><strong>#LB_Nomina#:</strong></label>
				</div>
				<div class="calPGProc">	
					<cf_translatedata name="get" tabla="TiposNomina" col="Tdescripcion" returnvariable="LvarTdescripcion">
					<cf_conlis
				        campos="Tcodigo1, Tdescripcion1, CPid1, CPcodigo1, CPdescripcion1"
				        asignar="Tcodigo1, Tdescripcion1, CPid1, CPcodigo1, CPdescripcion1"
				        size="0,35,0,0,35"
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
				        filtro="tn.Ecodigo in ($jtreeListaItem,numeric$) order by cp.CPhasta desc"
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
				        size="0,35,0,0,35"
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
				        filtro="tn.Ecodigo in ($jtreeListaItem,numeric$) order by cp.CPhasta desc"
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
				<div class="addNomin">
					<input type="button" class="btnNormal" value="+" onclick="fnAddNom()">
				</div>	
			</div>
		</div>

		<!--- Detalle de las nominas seleccionadas --->
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

		<!--- Seleccion del Filtro de fechas 
		<div class="form-group">
            <div class="col-sm-12 filterDates"> 
            	<div>
					<label for="filtroFechas"><strong>#LB_FiltroFechas#:</strong></label>
					<input name="chk_FiltroFechas" id="chk_FiltroFechas" type="checkbox" tabindex="1">
				</div>		
				<div class="selectDates" style="display:none">
					<div>
						<label for="fechDesde"><strong>#LB_Fecha_Desde#:</strong></label>
						<cf_sifcalendario form="form1" tabindex="1" name="FechaDesde" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
					</div>
					<div>
						<label for="fechHasta"><strong>#LB_Fecha_Hasta#:</strong></label>
						<cf_sifcalendario form="form1" tabindex="2" name="FechaHasta" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
					</div>			
				</div>		
            </div>	
		</div>	--->

        <!--- Seleccion del Grupo de Cargas --->
        <div class="form-group">	
        	<div class="col-sm-11 col-sm-offset-1 GCargas">
	        	<label><strong>#LB_GrupoCarga#:</strong></label>
				<select name="sGC" id="sGC" class="form-control">
					<option value="">#LB_SeleccioneGrupoCarga#</option>
					<cfloop query="rsListGC">
			            <option value="#ECcodigo#"<cfif isdefined("lvarECcodigo") and len(trim(lvarECcodigo))>
			            		<cfif rsListGC.ECcodigo eq lvarECcodigo> selected </cfif>
			            	</cfif>>#ECdescripcion#
			        	</option>
			        </cfloop>	
				</select>
				<input type="button" class="btnNormal" value="+" onclick="fnAddGC()">
			</div>	
        </div>

    	<!--- Detalle de las cargas seleccionadas --->
        <div class="form-group">
	        <div class="col-sm-12 col-sm-offset-2 detailCargas" style="display:none">
	        	<div class="row encabezado">
	        		<div class="col-xs-3"><label><strong>#LB_Grupo#</strong></label></div>
		            <div class="col-xs-6"><label><strong>#LB_Cargas#</strong></label></div>
	        	</div>	
				<div class="detListCargas">
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

	$(document).on('click','.listTree input[type=checkbox]', function(e) {
		fnCargarListGC();
	});	

	$('#esCorporativo').click(function(){
		if(!$(this).prop('checked')){
			$('#jtreeListaItem').val(<cfoutput>#session.Ecodigo#</cfoutput>);
			fnCargarListGC();
		}
	});

	$('#chk_NominaAplicada').click(function(){
		fnShowNominAplyProcess($(this).prop('checked'));
	});	

	$('#chk_FiltroFechas').click(function(){
		fnShowDates($(this).prop('checked'));
	});	

	// Funcion que valida si los elementos requeridos han sido suministrados por el usuario para realizar submit del form
	function fnValSubmit(){
		var result = true;
		var mensaje = '¡<cfoutput>#MSG_Nota#</cfoutput>! <cfoutput>#MSG_Requeridos#</cfoutput>:<br/><br/>';

		if($('#chk_FiltroFechas').prop('checked')){
			result = fnValidarElement("FechaDesde",'<cfoutput>#MSG_FechaDesde#</cfoutput>');
			
			if(result)
				result = fnValidarElement("FechaHasta",'<cfoutput>#MSG_FechaHasta#</cfoutput>'); 
		} 
		else{ 
			if(!$('.detailNom').is(':visible')){
				mensaje += '<cfoutput>#MSG_NominaSelect#</cfoutput><br/>';
				result = false;
			}
		}

		if(!$('.detailCargas').is(':visible')){
			mensaje += '<cfoutput>#LB_GrupoCarga#</cfoutput>';
			result = false;
		}

		if(!result){
			alert(mensaje);
		}
			
		return result;
	}

	// Funcion utilizada para mostrar el filtro de fechas(Desde/Hasta) para la seleccion de nominas
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

	// Funcion que permite añadir un grupo de cargas a la lista de seleccion para la consulta
	function fnAddGC(){
		result = fnValidarElement('sGC','<cfoutput>#MSG_GrupoCargas#</cfoutput>');

		if(result)
			fnAddElementGC('sGC');
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

	// Funcion para cargar una Lista de Grupos de Cargas a partir de una o mas empresas seleccionadas
	function fnCargarListGC(){
		var elementHTML = "", vECcodigo = -1, vECdescripcion = "", vCodConc = "", vCoorporativo = false, vjtreeListaItem = "";

		$('#sGC option').remove();
		elementHTML = '<option value=""><cfoutput>#LB_SeleccioneGrupoCarga#</cfoutput></option>';
		$('#sGC').append(elementHTML); 

		if($('#esCorporativo').length != 0)
			vCoorporativo = $('#esCorporativo').prop('checked');
		else
			vCoorporativo = false; 

		vjtreeListaItem = $('#jtreeListaItem').val();

		$.ajax({
		        url: "RepFondoPensiones-lista.cfm",
		        type: "post",
		        dataType: "json",
		        async : false,
		        data: { GetListGC:true, esCorporativo:vCoorporativo, jtreeListaItem:vjtreeListaItem },  
		        success: function(data) { 
			        $.each(data.DATA, function(key, val){
						vECcodigo = "";
						vECdescripcion = "";
						$.each(val, function(key, val){
							if(key == 0)
								vECcodigo = val;
							else if(key == 1)
								vECdescripcion = val;
					 	});
					 	if(vECcodigo != -1){ 
					 		if(vCoorporativo)
					 			vCodConc = vECcodigo +' - ';
					 		else 
					 			vCodConc = '';

					 		elementHTML = '<option value="'+vECcodigo+'">'+vCodConc+vECdescripcion+'</option>';
							$('#sGC').append(elementHTML);
					 	}
					}); 	
		       }
		    });
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

	// Funcion para agregar un Grupo de Cargas seleccionado y el detalle de las cargas relacionadas
	function fnAddElementGC(e){
		var elementHTML = "", vECcodigo = "", vECdescripcion = "", vDCcodigo = -1, vDCdescripcion = "", vClass ="", vCoorporativo = "", vjtreeListaItem = "";

		vECcodigo = $('#'+e).val(); 
		vECdescripcion = $('#'+e+' :selected').text();
		vClass = 'gc_'+vECcodigo;

		if($('#esCorporativo').length != 0)
			vCoorporativo = $('#esCorporativo').prop('checked');
		else
			vCoorporativo = false;

		vjtreeListaItem = $('#jtreeListaItem').val();

		if($('.'+vClass).length == 0){

			elementHTML = '<div class="row encGC '+vClass+'"><div class="col-xs-3">'+vECdescripcion+'</div><div class="col-xs-1 lbCod"><label><strong><cfoutput>#LB_Codigo#</cfoutput></strong></label></div><div class="col-xs-4"><label><strong><cfoutput>#LB_Descripcion#</cfoutput></strong></label></div><div class="col-xs-1"><a style="padding:0" class="btn" title="<cfoutput>#LB_Eliminar#</cfoutput>" onclick="fnDelElementGC(this)"><i class="fa fa-times fa-sm"></i></a></div></div>';

			$('.detListCargas').append(elementHTML);
		
			$.ajax({
		        url: "RepFondoPensiones-lista.cfm",
		        type: "post",
		        dataType: "json",
		        async : false,
		        data: { GetListCargas:true, ECcodigo:vECcodigo, esCorporativo:vCoorporativo, jtreeListaItem:vjtreeListaItem },  
		        success: function(data) {
			        $.each(data.DATA, function(key, val){
						vDCcodigo = "";
						vDCdescripcion = "";
						$.each(val, function(key, val){
							if(key == 0)
								vDCcodigo = val;
							else if(key == 1)
								vDCdescripcion = val;
					 	});
					 	if(vDCcodigo != -1){ 
					 		elementHTML = '<div class="row '+vClass+'" id="'+vDCcodigo+'"><div class="col-xs-3"></div><div class="col-xs-1">'+vDCcodigo+'</div><div class="col-xs-4">'+vDCdescripcion+'</div><div class="col-xs-1"><a style="padding:0" class="btn" title="<cfoutput>#LB_Eliminar#</cfoutput>" onclick="fnDelElementGC(this)"><i class="fa fa-times fa-sm"></i></a></div><input type="hidden" name="TcodigoListCg" value="'+vDCcodigo+'"/></div>';
					 		$('.detListCargas').append(elementHTML);

					 		if(!$('.detailCargas').is(':visible'))
								$('.detailCargas').show();
					 	}
					}); 	
		       }
		    });
		}
	}	

	// Funcion para eliminar un Calendario de Pago de la lista de calendarios ya seleccionados en consulta
	function fnDelElementCP(e){
		var detList = $(e).parent().parent().parent();

		$(e).parent().parent().remove();
		
		if(!$(detList).children().length > 0)
			$(detList).parent().parent().hide();
	}

	// Funcion para eliminar un Grupo de Cargas de la lista de grupos ya seleccionados en consulta
	function fnDelElementGC(e){
		vGC = $(e).parent().parent().attr('class').split(' ')[1]; //obtiene clase del grupo carga asociado
		
		if(vGC == 'encGC'){
			vGC = $(e).parent().parent().attr('class').split(' ')[2]; //obtiene clase del grupo carga asociado
			$('.detailCargas .'+vGC).remove();
		}	

		$(e).parent().parent().remove();

		if($('.detailCargas .'+vGC).length == 1)
			$('.detailCargas .'+vGC).remove(); 

		if(!$('.detailCargas .detListCargas div').length)
			$('.detailCargas').hide(); 
	}

	// Funcion para inicializar(reset) los elementos del form
	function fnLimpiar(){
		$('form[name=form1]')[0].reset();
		$(".detListNom, .detListCargas").empty();
		$('.listTree').listTree('deselectAll');
		$(".calPGAply, .detailNom, .detailCargas, .divArbol").hide();
		$('.calPGProc').show();
		$('#jtreeListaItem').val(<cfoutput>#session.Ecodigo#</cfoutput>);
		fnCargarListGC();
	}
</script>