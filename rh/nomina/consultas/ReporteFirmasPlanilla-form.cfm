 <SCRIPT src="/cfmx/rh/js/utilesMonto.js"></SCRIPT>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	function validarSubmit(){
		var obj= document.getElementsByName("ListaTcodigoCalendario1");
		var obj2= document.getElementsByName("ListaTcodigoCalendario2");

		var checkH= document.getElementById("ckNominasHistoricas");
		var check= document.getElementById("ckUtilizarFiltroFechas");
		
		if(!check.checked){
			if ( (checkH.checked && obj.length == 0) || (!checkH.checked && obj2.length == 0) ) {
				alert("<cf_translate key='LB_DebeEscogerAlmenosUnaNomina'>Debe Escoger al menos una Nómina</cf_translate>");
				return false;
			}
		}
		return true;
	}

	function CambiarNominas(e){
		if (!e.checked) {
			$("#verNominasProceso1").hide();
			$("#verNominasProceso2").show();
		}
		else{
			$("#verNominasProceso2").hide();
			$("#verNominasProceso1").show();
		}
		$("#ListaCalendarios1 tr").remove();
		$("#ListaCalendarios2 tr").remove();
	}
	
</SCRIPT>

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

<cfset t = createObject("component", "sif.Componentes.Translate")>
<cfset LB_Nomina = t.translate('LB_Nomina','Nómina','/rh/generales.xml')> 
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
<cfset LB_GruposDeSociosNegocio = t.translate('LB_GruposDeSociosNegocio','Grupo de socios de negocio','/rh/generales.xml')>

<cfset MSG_FechaDesde = t.translate('MSG_FechaDesde','Debe seleccionar la fecha inicial del rango de la consulta')>
<cfset MSG_FechaHasta = t.translate('MSG_FechaHasta','Debe seleccionar la fecha final del rango de la consulta')>

<cfset LB_Limpiar = t.translate('LB_Limpiar','Limpiar','/rh/generales.xml')> 
<cfset LB_Eliminar = t.translate('LB_Eliminar','Eliminar','/rh/generales.xml')>
<cfset LB_NoSeEncontraronRegistros  = t.translate('LB_NoSeEncontraronRegistros','No se Encontraron Registros','/rh/generales.xml')>
<cfset MSG_Requeridos = t.translate('MSG_Requeridos','Para realizar la consulta se debe seleccionar los siguientes valores','/rh/generales.xml')>

<cfset MSG_GrupoSociosNegocio = t.translate('MSG_GrupoSociosNegocio','Seleccione un grupo de socios de negocio','/rh/nomina/consultas/IICADesgloseTransferencia.cfm')> 
<cfset LB_Grupo = t.translate('LB_Grupo','Grupo','/rh/generales.xml')>
<cfset LB_Deducciones = t.translate('LB_Deducciones','Deducciones','/rh/generales.xml')>

<cfoutput>
<body>
<form  name="form1" style="margin:0" action="ReporteFirmasPlanilla-sql.cfm" method="post" onSubmit="javascript:return validarSubmit();">
	<table width="100%" border="0" cellspacing="1" cellpadding="1" style="margin:0">
		
		<!--- Valida si esta habilitado las consultas corporativas --->
        <cfif lvPmtConsCorp eq 1>
        	<tr><td>
		    <!--- Check de consulta coorporativa --->
            <div class="form-group lbCoorp">
                <div class="col-sm-12" style="margin-left: -30px;">
                    <cf_rharbolempresas>
                </div>  
            </div>
        	</td></tr>
        </cfif>
           
       
          <tr>
			<td align="left" nowrap colspan="2">
			            <table cellpadding="0" cellspacing="0">
                       		<tr><td nowrap colspan="3"> 
                            	<input type="checkbox" name="chk_NominaAplicada" id="chk_NominaAplicada"> 
                                <label  for="Nomina"><strong>#LB_NominasAplicadas#:</strong></label>
                            </td></tr> 
                            <tr>
                            	<td> <label  for="Nomina"><strong>#LB_Nomina#:</strong></label></td>
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
			<td>
				<tr>
					<td align="left" nowrap colspan="2">
					<table>
						<tr>
						<td><label><b>#LB_GruposDeSociosNegocio#:&nbsp;</b></label></td>	
						<td>
							<cf_translatedata name="get" tabla="GrupoSNegocios" col="GSNdescripcion" returnvariable="LvarGSNdescripcion">    
					        <cf_conlis
								campos="GSNcodigo, GSNdescripcion"
								asignar="GSNcodigo, GSNdescripcion"
								size="15,25"
								desplegables="S,S"
								modificables="N,N"
								title="#LB_GruposDeSociosNegocio#"
								tabla="GrupoSNegocios"
								columnas="distinct GSNcodigo as GSNcodigo, #LvarGSNdescripcion# as GSNdescripcion"
								filtro="Ecodigo = #Session.Ecodigo# order by GSNdescripcion"
								filtrar_por="GSNcodigo, GSNdescripcion"
								desplegar="GSNcodigo, GSNdescripcion"
								etiquetas="#LB_Codigo#, #LB_Descripcion#"
								formatos="S,S"
								align="left,left"
								asignarformatos="S,S"
								form="form1"
								top="50"
					            left="200"
								showEmptyListMsg="true"
								translatedatacols="GSNdescripcion"
								tabindex="2" 
								/>
						</td>
						<td align="left" colspan="8">
							<input onClick="fnAddSelect()" type="button" class="btnNormal" value="+"> 
						</td>
						</tr>
						</table>
					</td>	
		</tr>
        <!--- Detalle de las Deducciones seleccionadas --->
		<tr>
			<td>
				 <div class="form-group row">
			        <div class="col-sm-12 col-sm-offset-2 detailDeducciones">
			        	<div class="row encabezado">
			        		<div class="col-xs-3"><label><strong>#LB_Grupo#</strong></label></div>
				            <div class="col-xs-6"><label><strong>#LB_Deducciones#</strong></label></div>
			        	</div>	
						<div class="detListDeducciones">
						</div>	
					</div>
				</div>
			</td>
		</tr>
		<tr>
			<td colspan="10">
				<table>
				<td align="left" nowrap ><label><strong><cf_translate key="LB_Utilizar_filtro_de_fechas">Utilizar filtro de fechas</cf_translate>:&nbsp;</strong></label><input type="checkbox" id="ckUtilizarFiltroFechas" name="ckUtilizarFiltroFechas">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>			
				<td align="left" nowrap><label><strong><cf_translate key="LB_Fecha_Desde" xmlFile="/rh/generales.xml">Fecha Desde</cf_translate>&nbsp;:&nbsp;</strong></label></td> 
				<td align="left" nowrap><cf_sifcalendario name="FechaDesde" value="#LSDateFormat(Now(),'dd/mm/yyyy')#"></td> 
				<td colspan="10">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td align="left" nowrap ><label><strong><cf_translate key="LB_Fecha_Hasta" xmlFile="/rh/generales.xml">Fecha Hasta</cf_translate>&nbsp;:&nbsp;</strong></label></td>				
				<td align="left" nowrap ><cf_sifcalendario name="FechaHasta" value="#LSDateFormat(Now(),'dd/mm/yyyy')#"></td>	
				</table>
			</td>
		</tr>
	</table>
	
	<center>
	<input class="btnNormal" type="submit" name="Consultar" value="<cf_translate key='LB_Consulta'>Consultar</cf_translate> " />
	</center>

</form>

</body>
</cfoutput>
<script language="JavaScript1.2">

	$('#chk_NominaAplicada').click(function(){
		fnShowNominAplyProcess($(this).prop('checked'));
	});
	
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
	
	
	function fnAddSelect(){
        var result = true;
        var mensaje = '';

        // Grupo de Socios de Negocio para Cargas Sociales(CS) o Deducciones(DD)
        if($('#GSNcodigo').val() == ''){
    		mensaje += '<cfoutput>#MSG_GrupoSociosNegocio#</cfoutput>';
        	result = false;
        }

        if(result){
        	fnAddDD();
        }    
        else{
            alert(mensaje);
        }
    }


function fnAddDD(){
	var elementHTML = "", vGSNcodigo = "", vGSNdescripcion = "", vTDcodigo = -1, vTDdescripcion = "", vClass = "", 
    vCoorporativo = false, vJtreeJsonFormat = "";

    vGSNcodigo = $('#GSNcodigo').val(); 
	vGSNdescripcion = $('#GSNdescripcion').val();
	vClass = '_'+vGSNcodigo;

	if($('.'+vClass).length == 0){

		elementHTML = '<div class="row encGC '+vClass+'"><div class="col-xs-3">'+vGSNdescripcion+'</div><div class="col-xs-1 lbCod"><label><strong><cfoutput>#LB_Codigo#</cfoutput></strong></label></div><div class="col-xs-4"><label><strong><cfoutput>#LB_Descripcion#</cfoutput></strong></label></div><div class="col-xs-1"><a style="padding:0" class="btn" onclick="fnDelElement(this,3)"><i class="fa fa-times fa-sm"></i></a></div></div>';

		$('.detListDeducciones').append(elementHTML);

		$.ajax({
	        url: "IICADesgloseTransferencia-lista.cfm",
	        type: "post",
	        dataType: "json",
	        async : false,
	        data: { GetListDeducciones:true, GSNcodigo:vGSNcodigo, esCorporativo:false, jtreeJsonFormat:'0' },  
	        success: function(data) {
		        $.each(data.DATA, function(key, val){
					vTDcodigo = "";
					vTDdescripcion = "";
					$.each(val, function(key, val){
						if(key == 1)
							vTDcodigo = val;
						else if(key == 2)
							vTDdescripcion = val;
				 	});
				 	if(vTDcodigo != -1){ 
				 		elementHTML = '<div class="row '+vClass+'" id="'+vTDcodigo+'"><div class="col-xs-3"></div><div class="col-xs-1">'+vTDcodigo+'</div><div class="col-xs-4">'+vTDdescripcion+'</div><div class="col-xs-1"><a style="padding:0" class="btn" onclick="fnDelElement(this,3)"><i class="fa fa-times fa-sm"></i></a></div><input type="hidden" name="TcodigoListDD" value="'+vTDcodigo+'"/></div>';
				 		$('.detListDeducciones').append(elementHTML);

				 		if(!$('.detailDeducciones').is(':visible'))
							$('.detailDeducciones').delay(200).fadeIn(800);
				 	}
				}); 	
	       }
	    });
	}		
}	

function fnDelElement(e,val){
    	var vDetailName = "", vDetNameList = "", vGC = "";

		vDetailName = "detailDeducciones"; 
		vDetNameList = "detListDeducciones";	
 
		vGC = $(e).parent().parent().attr('class').split(' ')[1]; //obtiene clase del grupo seleccionado
	
		if(vGC == 'encGC'){ // Valida si elemento que se desea eliminar es el encabezado
			vGC = $(e).parent().parent().attr('class').split(' ')[2]; //obtiene clase del grupo seleccionado a eliminar
			$('.'+vDetailName+' .'+vGC).remove();
		}	
		else{
			$(e).parent().parent().remove();
			
			if($('.'+vDetailName+' .'+vGC).length == 1)
				$('.'+vDetailName+' .'+vGC).remove(); 
		}	
 
		if(!$('.'+vDetailName+' .'+vDetNameList+' div').length)
			$('.'+vDetailName).hide(); 
}

$('#esCorporativo').click(function(){
		if(!$(this).prop('checked')){
			$('#jtreeListaItem').val(<cfoutput>#session.Ecodigo#</cfoutput>);
		}
	});

$('#jtreeListaItem').val(<cfoutput>#session.Ecodigo#</cfoutput>);
</script>



