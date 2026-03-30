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

<cfset t=createObject("component","sif.Componentes.Translate")>
<cfset LB_GruposDeSociosNegocio = t.translate('LB_GruposDeSociosNegocio','Grupo de socios de negocio','/rh/generales.xml')>
<cfset LB_Codigo = t.translate('LB_Codigo','Código','/rh/generales.xml')>
<cfset LB_Descripcion = t.translate('LB_Descripcion','Descripción','/rh/generales.xml')>
<cfset MSG_GrupoSociosNegocio = t.translate('MSG_GrupoSociosNegocio','Seleccione un grupo de socios de negocio','/rh/nomina/consultas/IICADesgloseTransferencia.cfm')> 
<cfset LB_Grupo = t.translate('LB_Grupo','Grupo','/rh/generales.xml')>
<cfset LB_Deducciones = t.translate('LB_Deducciones','Deducciones','/rh/generales.xml')>
<cfset LB_Nomina = t.translate('LB_Nomina','Nómina','/rh/generales.xml')>
<cfset LB_ListaDeTiposNomina = t.translate('LB_ListaDeTiposNomina','Lista de Tipos de Nómina','/rh/generales.xml')>
<cfset LB_Tipo = t.translate('LB_Tipo','Tipo','/rh/generales.xml')> 
<cfset LB_CalendarioPago = t.translate('LB_CalendarioPago','Calendario Pago','/rh/indexReportes.xml')>
<cfset LB_NoSeEncontraronRegistros  = t.translate('LB_NoSeEncontraronRegistros','No se Encontraron Registros','/rh/generales.xml')>
<cfset MSG_TipoNomina = t.translate('MSG_TipoNomina','Debe seleccionar un tipo de nómina para agregar a la consulta')>
<cfset MSG_CalendarPagos = t.translate('MSG_CalendarPagos','Debe seleccionar el calendario de pago que desea agregar a la consulta')>
<cfset LB_Eliminar = t.translate('LB_Eliminar','Eliminar','/rh/generales.xml')>
<cfset MSG_Nota = t.translate('MSG_Nota','Nota','/rh/generales.xml')>
<cfset LB_NominasAplicadas = t.translate('LB_NominasAplicadas','Nóminas Aplicadas','/rh/generales.xml')>
<cfset MSG_NominaRequerida = t.translate('MSG_TipoNomina','Debe seleccionar al menos una nómina')>

<cfif not REFind('erp.css',session.sitio.CSS)>
  <cfinclude template="/eticket/libs.cfm">
</cfif>
<cfoutput>
	<!---<div class="well">--->
      <form name="form1" id="form1" action="ReporteFirmasAdelanto-sql.cfm" method="post" class="bs-example form-horizontal">
        
		<table>
		<!--- Valida si esta habilitado las consultas corporativas --->
        <cfif lvPmtConsCorp eq 1>
        	<tr><td>
		    <!--- Check de consulta coorporativa --->
            <div class="form-group lbCoorp">
                <div class="col-sm-12" style="margin-left: 80px;">
                    <cf_rharbolempresas>
                </div>  
            </div>
        	</td></tr>
        </cfif>
           
       
          <tr>
			<td align="left" nowrap colspan="2">
			            <table cellpadding="2" cellspacing="2" style="margin-left: 80px;">
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
         </table>
		 <center>
			<input class="btnNormal" type="submit" name="Consultar" value="<cf_translate key='LB_Consulta'>Consultar</cf_translate> " />
		 </center>
	  </form>
    
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