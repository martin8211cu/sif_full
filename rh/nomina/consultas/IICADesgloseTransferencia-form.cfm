
<cfif not StructKeyExists(session,"LvarFiltroEmpresasDT")>
	<cfset session.LvarFiltroEmpresasDT = session.Ecodigo>
</cfif>

<style type="text/css">
	.form-group { margin-bottom: 8px; }
	.detailNom, .detailCargas, .detailDedud { display:none; }
    .calendarioPG div, .chkNomHist div { float: left; }
    .divArbol { padding-left: 113px; }
    .divArbol .listTree { width: 60% } 
    .calPG, .conlisGSN { margin-right: 2px; }
    .calPG, .chkNom, .conlisGSN { margin-left: 5px; }
	.detailNom .listNom { margin-bottom: 10px; }
    .detailNom .listNom, .selectGSNCG .GSNCargas, .selectGSNDED .GSNDedud, .detailCargas .listCargas, .detailDedud .listDedud { margin-top: 5px; }
    .selectGSNCG .GSNCargas div, .selectGSNDED .GSNDedud div { float: left; }
    .selectGSNCG .GSNCargas div:first-child, .selectGSNDED .GSNDedud div:first-child { margin-left: 5px; }
    .lbTitul { width: 150px; text-align: right; }
    .detailNom .encabezado, .detListNom { width: 85%; }
    .encabezado, .detListCargas, .detListDedud { width: 70%; }
    .encabezado div { background-color: #B0C8D3; padding-top: 6px; height: 28px; margin-bottom: 0; }
	.detListNom .row, .detListNom .row div, .detListCargas .row, .detListCargas .row div, .detListDedud .row, .detListDedud .row div { height: 34px; margin-bottom: 0; padding-top: 4px; }
	.detListNom .row, .detListCargas .row, .detListDedud .row { padding-top: 2px; width: 100%; }
    .detListNom .row:nth-child(2n) div { background-color: #ffffff; }
    .detListNom .btn, .detListCargas .btn, .detListDedud .btn { margin-left: 20px; }
    input#Tcodigo,input#Tcodigo2 { width: 88px; }
    input#CPcodigo,input#CPcodigo2 { width: 90px; }
    input#Tdescripcion,input#Tdescripcion2 { width: 175px; }
    input#CPdescripcion,input#CPdescripcion2 { width: 220px; }
    input#GSNdescripcion_CS, input#GSNdescripcion_DD { width: 250px; }
    .btns { margin-bottom: 10px; }
</style>


<cfset t = createObject("component", "sif.Componentes.Translate")>   
<!----- Etiquetas de traduccion------>
<cfset LB_EsCorporativo = t.translate('LB_EsCorporativo','Es Corporativo','/rh/generales.xml')>
<cfset LB_ListaDeCalendariosPagos = t.translate('LB_ListaDeCalendariosPagos','Lista de Calendarios de Pagos')>
<cfset LB_Codigo = t.translate('LB_Codigo','Código','/rh/generales.xml')/>
<cfset LB_Descripcion = t.translate('LB_Descripcion','Descripción','/rh/generales.xml')/>
<cfset LB_Tipo = t.translate('LB_Tipo','Tipo','/rh/generales.xml')>
<cfset LB_Nomina = t.translate('LB_Nomina','Nómina','/rh/generales.xml')>
<cfset LB_CalendarioPago = t.translate('LB_CalendarioPago','Calendario Pago','/rh/generales.xml')>
<cfset LB_Grupo = t.translate('LB_Grupo','Grupo','/rh/generales.xml')>
<cfset LB_Cargas = t.translate('LB_Cargas','Cargas','/rh/generales.xml')>
<cfset LB_Deducciones = t.translate('LB_Deducciones','Deducciones','/rh/generales.xml')>
<cfset LB_CalendarioDePago = t.translate('LB_CalendarioDePago','Calendario de Pago','/rh/generales.xml')/>
<cfset LB_Empresas = t.translate('LB_Empresas','Empresas','/rh/generales.xml')/>
<cfset LB_GruposDeSociosDeNegocioParaCargas = t.translate('LB_GruposDeSociosDeNegocioParaCargas','Grupos de Socios de Negocios para Cargas Sociales')/>
<cfset LB_GruposDeSociosDeNegociosParaDeducciones = t.translate('LB_GruposDeSociosDeNegociosParaDeducciones','Grupos de Socios de Negocios para Deducciones')/>
<cfset LB_ListaDeTiposDeNomina = t.translate('LB_ListaDeTiposDeNomina','Lista de Tipos de Nómina')/>
<cfset LB_ListaDeCalendariosDePago = t.translate('LB_ListaDeCalendariosDePago','Lista de Calendarios de Pago')/>
<cfset LB_ListaDeGruposDeSociosNegocioAIncluir = t.translate('LB_ListaDeGruposDeSociosNegocioAIncluir','Lista de Grupos de Socios de Negocio a incluir')/>
<cfset LB_Eliminar = t.translate('LB_Eliminar','Eliminar','/rh/generales.xml')>
<cfset LB_Consultar = t.translate('LB_Consultar','Consultar','/rh/generales.xml')>
<cfset LB_Limpiar = t.translate('LB_Limpiar','Limpiar','/rh/generales.xml')> 
<cfset LB_NoSeEncontraronRegistros  = t.translate('LB_NoSeEncontraronRegistros','No se Encontraron Registros','/rh/generales.xml')>
<cfset MSG_Nota = t.translate('MSG_Nota','Nota','/rh/generales.xml')> 
<cfset LB_NominasAplicadas = t.translate('LB_NominasAplicadas','Nóminas aplicadas','/rh/generales.xml')> 
<cfset MSG_NominaSelect = t.translate('MSG_NominaSelect','Debe seleccionar al menos una nómina y un calendario de pagos para realizar esta acción')>
<cfset MSG_CalendarPagos = t.translate('MSG_CalendarPagos','Debe seleccionar la nómina y el calendario de pago que desea agregar a la consulta')> 
<cfset MSG_GrupoCarga = t.translate('MSG_GrupoCarga','Debe seleccionar el grupo de carga que desea agregar a la consulta')> 
<cfset MSG_GrupoSociosNegocio = t.translate('MSG_GrupoSociosNegocio','Debe seleccionar el grupo de socios de negocio que desea agregar a la consulta')> 


<!--- Consulta si empresa(session) tiene habilitada la opcion de permitir consultas corporativas --->
<cfquery name="rsPmtConsCorp" datasource="#Session.DSN#">
    select count(1) as valor
    from RHParametros
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> and Pcodigo = 2715
    and Pvalor='1'
</cfquery> 
<cfsavecontent variable="joinCargas">
	inner join DCargas dc
		on sn.SNcodigo = dc.SNcodigo
		and sn.Ecodigo = dc.Ecodigo
</cfsavecontent>

<cfsavecontent variable="joinDedud">
	inner join TDeduccion td	
		on sn.SNcodigo = td.SNcodigo
		and sn.Ecodigo = td.Ecodigo
</cfsavecontent>


<cfoutput>
	<form class="bs-example form-horizontal" action="IICADesgloseTransferencia-sql.cfm" method="post" name="form1" style="margin:0">
		<!--- Valida si esta habilitado las consultas corporativas --->
	    <cfif rsPmtConsCorp.valor>
	        <div class="form-group">
		        <div class="col-sm-12">
					<cf_rharbolempresas>  <!--- Lista de empresas que pertenecen a una coorporacion --->
		        </div>     	
	        </div>		    	
	    </cfif>

		<div class="form-group">
		    <div class="col-sm-12 chkNomHist">
		    	<div class="lbTitul">&nbsp;</div> 	
		    	<div class="chkNom">	
			    	<label>
				  		<input type="checkbox" name="chkHistorico" id="chkHistorico" onclick="fnEsHistorico()"> <strong>#LB_NominasAplicadas#</strong>
				  	</label>
				</div>   	
    		</div>
		</div> 

	    <!--- Seleccion del Calendario de Pago --->
		<div class="form-group">
			<div class="col-sm-12 calendarioPG">
				<div class="lbTitul">
					<label><strong>#LB_CalendarioDePago#:</strong></label>
				</div> 	
				<div class="calPG">			
					<input type="hidden" id="listNSCPidP" name="listNSCPidP" value="0"/>	
					<input type="hidden" id="listNSCPid"  name="listNSCPid"  value="0"/>
					<cf_translatedata name="get" tabla="TiposNomina" col="Tdescripcion" returnvariable="LvarTdescripcion">
					<div id="divProceso">					
						<cf_conlis
					        campos="Tcodigo2,Tdescripcion2,CPid2,CPcodigo2,CPdescripcion2"
					        asignar="Tcodigo2, Tdescripcion2, CPid2, CPcodigo2, CPdescripcion2"
					        size="0,35,0,0,35"
					        desplegables="S,S,N,S,S"
					        modificables="S,N,N,N,N"						
					        title="#LB_ListaDeCalendariosPagos#"
					        tabla="TiposNomina tn
								inner join CalendarioPagos cp
									on cp.Tcodigo = tn.Tcodigo
   									and cp.Ecodigo = tn.Ecodigo
								    inner join RCalculoNomina rhc
								    	on rhc.RCNid = cp.CPid"
					        columnas="tn.Tcodigo as Tcodigo2, #LvarTdescripcion# as Tdescripcion2, cp.CPid as CPid2, cp.CPcodigo as CPcodigo2, rhc.RCDescripcion as CPdescripcion2"
					        filtro="tn.Ecodigo in ($jtreeListaItem,numeric$) and cp.CPid not in ($listNSCPidP,numeric$) order by cp.CPhasta desc"
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
					        tabindex="13"
					        pageindex="13"
					    /> 		
				    </div>	
					<div id="divHistorico" style="display:none">							
						<cf_conlis
					        campos="Tcodigo, Tdescripcion, CPid, CPcodigo, CPdescripcion"
					        asignar="Tcodigo, Tdescripcion, CPid, CPcodigo, CPdescripcion"
					        size="0,35,0,0,35"
					        desplegables="S,S,N,S,S"
					        modificables="S,N,N,N,N"						
					        title="#LB_ListaDeCalendariosPagos#"
					        tabla="TiposNomina tn
								inner join CalendarioPagos cp
									on cp.Tcodigo = tn.Tcodigo
   									and cp.Ecodigo = tn.Ecodigo
								    inner join HRCalculoNomina rhc
								    	on rhc.RCNid = cp.CPid"
					        columnas="tn.Tcodigo, #LvarTdescripcion# as Tdescripcion, cp.CPid, cp.CPcodigo, rhc.RCDescripcion as CPdescripcion"
					        filtro="tn.Ecodigo in ($jtreeListaItem,numeric$) and cp.CPid not in ($listNSCPid,numeric$) order by cp.CPhasta desc"
					        filtrar_por="tn.Tcodigo, tn.Tdescripcion, cp.CPcodigo, rhc.RCDescripcion"
					        desplegar="Tcodigo, Tdescripcion, CPcodigo, CPdescripcion"
					        etiquetas="#LB_Tipo#, #LB_Nomina#, #LB_Codigo#, #LB_CalendarioPago#"
					        formatos="S,S,S,S,S"
					        align="left,left,left,left,left"								
					        asignarFormatos="S,S,S,S,S"
					        form="form1"
					        top="50"
					        left="200"
					        showEmptyListMsg="true"
					        EmptyListMsg=" --- #LB_NoSeEncontraronRegistros# --- "
					        tabindex="11"
					        pageindex="11"
					    /> 		
				    </div>			
		        </div>
		        <div class="addCP">
		        	<input type="button" class="btnNormal" value="+" onclick="fnAddSelect('CP')">
		        </div>  
		    </div>    
		</div>	

		<!--- Detalle de las nominas seleccionadas --->
        <div class="form-group detailNom" >
        	<div class="col-sm-11 col-sm-offset-1 listNom">
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

		<!--- Seleccion del Grupo de Socios de Negocios para las Carga Sociales --->
		<div class="form-group selectGSNCG">
			<div class="col-sm-12 GSNCargas">
				<input type="hidden" id="listNSGSNCG" name="listNSGSNCG" value="0"/>
				#getDivGrupoSociosNegocio('CS','#LB_GruposDeSociosDeNegocioParaCargas#',2,joinCargas,'listNSGSNCG')#
			</div>	
		</div>

		<!--- Detalle de las Cargas Sociales seleccionadas --->
        <div class="form-group detailCargas">
	        <div class="col-sm-11 col-sm-offset-1 listCargas">
	        	<div class="row encabezado">
	        		<div class="col-xs-3"><label><strong>#LB_Grupo#</strong></label></div>
		            <div class="col-xs-6"><label><strong>#LB_Cargas#</strong></label></div>
	        	</div>	
				<div class="detListCargas">
				</div>	
			</div>
		</div>	

		<!--- Seleccion del Grupo de Socios de Negocios para las Deduciones --->
		<div class="form-group selectGSNDED">
			<div class="col-sm-12 GSNDedud">
				<input type="hidden" id="listNSGSNDED" name="listNSGSNDED" value="0"/>
				#getDivGrupoSociosNegocio('DD','#LB_GruposDeSociosDeNegociosParaDeducciones#',3,joinDedud,'listNSGSNDED')#
			</div>		
		</div>

		<!--- Detalle de las Deducciones seleccionadas --->
        <div class="form-group detailDedud">
	        <div class="col-sm-11 col-sm-offset-1 listDedud">
	        	<div class="row encabezado">
	        		<div class="col-xs-3"><label><strong>#LB_Grupo#</strong></label></div>
		            <div class="col-xs-6"><label><strong>#LB_Deducciones#</strong></label></div>
	        	</div>	
				<div class="detListDedud">
				</div>	
			</div>
		</div>

		<!--- Botones de acciones del reporte --->
		<div class="form-group">
			<div class="col-sm-7 col-sm-offset-4 btns">
				<input type="submit" onclick="return fnValSubmit();" class="btnConsultar" value="#LB_Consultar#">	
				<input type="reset" onclick="fnLimpiar()" class="btnLimpiar" value="#LB_Limpiar#">
	        </div>
		</div>
	</form>
</cfoutput>		


<!--- Funcion que devuelve el div para la seleccion del Grupo de Socios de Negocio para las Cargas(CS) y Deducciones(DD) --->
<cffunction name="getDivGrupoSociosNegocio" output="true">
    <cfargument name="tipo" type="string" required="true">
    <cfargument name="titLabel" type="string" required="true">
    <cfargument name="valIndex" type="numeric" required="true">
    <cfargument name="joinTable" type="string" required="true">
    <cfargument name="listGSN" type="string" required="true">

    <div class="lbTitul">
    	<label><strong>#titLabel#:</strong></label>
    </div>	
	<div class="conlisGSN">
        <cf_conlis
			campos="GSNid_#tipo#, GSNcodigo_#tipo#, GSNdescripcion_#tipo#"
			asignar="GSNid_#tipo#, GSNcodigo_#tipo#, GSNdescripcion_#tipo#"
			size="0,8,10"
			desplegables="N,S,S"
			modificables="N,N,N"
			title="#LB_ListaDeGruposDeSociosNegocioAIncluir#"
			tabla="GrupoSNegocios gsn
				inner join SNegocios sn
					on gsn.GSNid = sn.GSNid
					#joinTable#"		
			columnas="distinct gsn.GSNid as GSNid_#tipo#, gsn.GSNcodigo as GSNcodigo_#tipo#, gsn.GSNdescripcion as GSNdescripcion_#tipo#"
			filtro="gsn.Ecodigo in ($jtreeListaItem,numeric$) and gsn.GSNid not in ($#listGSN#,numeric$) order by GSNdescripcion"
			filtrar_por="GSNcodigo, GSNdescripcion"
			desplegar="GSNcodigo_#tipo#, GSNdescripcion_#tipo#"
			etiquetas="#LB_Codigo#, #LB_Descripcion#"
			formatos="S,S"
			align="left,left"
			asignarformatos="S,S"
			form="form1"
			top="50"
            left="200"
			showEmptyListMsg="true"
            EmptyListMsg=" --- #LB_NoSeEncontraronRegistros# --- "
			tabindex="#valIndex#" 
			/>
    </div>
    <div>
    	<input type="button" class="btnNormal" value="+" onclick="fnAddSelect('<cfoutput>#tipo#</cfoutput>')">
    </div> 
</cffunction> 


<script type="text/javascript">
	$(document).ready(function(){
		fnLimpiar();
	});

	$('#esCorporativo').click(function(){
		if(!$(this).prop('checked'))
			$('#jtreeListaItem').val(<cfoutput>#session.Ecodigo#</cfoutput>);
	});

	// Funcion para validar la seleccion que se desea agregar a consulta
	function fnAddSelect(val){
        var result = true;
        var mensaje = '<strong>¡<cfoutput>#MSG_Nota#</cfoutput>!</strong> ';
		var p='2';

		if($('#chkHistorico').prop('checked')){
			p='';
		}
        // Calendario de Pagos
        if(val == 'CP'){
        	if($('#Tcodigo'+p).val().trim() == '' || $('#CPcodigo'+p).val().trim() == ''){
        		mensaje += '<cfoutput>#MSG_CalendarPagos#</cfoutput>';
            	result = false;
        	}
        }

        // Grupo de Socios de Negocio para Cargas Sociales(CS) o Deducciones(DD)
        if(val == 'CS' || val == 'DD'){
        	if($('#GSNcodigo_'+val).val().trim() == ''){
        		mensaje += '<cfoutput>#MSG_GrupoSociosNegocio#</cfoutput>';
            	result = false;
        	}
        }

        if(result){
        	if(val == 'CP')
            	fnAddCP();
        	if(val == 'CS')
        		fnAddCS(val);
        	if(val == 'DD')
        		fnAddDD(val);
        }    
        else
            alert(mensaje);
    }

    // Funcion para agregar los Calendarios de Pago seleccionados
    function fnAddCP(){
    	var elementHTML = "", vTcodigo = "", vTdescripcion = "", vCPid = "", vCPcodigo = "", vCPdescripcion = "", p='2';

		if($('#chkHistorico').prop('checked')){
			p='';
		}

    	vTcodigo = $('#Tcodigo'+p).val().trim(); 
    	vTdescripcion = $('#Tdescripcion'+p).val().trim(); 
    	vCPid = $('#CPid'+p).val().trim(); 
    	vCPcodigo = $('#CPcodigo'+p).val().trim(); 
    	vCPdescripcion = $('#CPdescripcion'+p).val().trim();

    	if($('#'+vCPid).length == 0){
            elementHTML = '<div class="row" id="'+vCPid+'"><div class="col-xs-2">'+vTcodigo+'</div><div class="col-xs-3">'+vTdescripcion+'</div><div class="col-xs-2">'+vCPcodigo+'</div><div class="col-xs-4">'+vCPdescripcion+'</div><div class="col-xs-1"><a style="cursor: pointer" title="<cfoutput>#LB_Eliminar#</cfoutput>" onclick="fnDelElement(this,1)"><i class="fa fa-times fa-sm"></i></a></div><input type="hidden" name="TcodigoListNom" value="'+vCPid+'"/></div>';
            $('.detListNom').append(elementHTML);

            if(!$('.detailNom').is(':visible'))
                $('.detailNom').show();


	            if($('#chkHistorico').prop('checked')){
	            	$('#listNSCPid').val($('#listNSCPid').val()+','+vCPid);
	            }else{
	            	$('#listNSCPidP').val($('#listNSCPidP').val()+','+vCPid);	
	            }
            
            fnClearSelect(1);
        } 
    }

    // Funcion para agregar las Cargas Sociales relacionadas al Grupo de Socios de Negocios seleccionado
    function fnAddCS(val){ 
        var elementHTML = "", vGSNid = -1, vGSNcodigo = "", vGSNdescripcion = "", vDClinea = -1, vDCcodigo = "-----", vDCdescripcion = "-------------------------", vClass ="", vCoorporativo = false, vjtreeListaItem = "";

        vGSNid = $('#GSNid_'+val).val().trim();
        vGSNcodigo = $('#GSNcodigo_'+val).val().trim(); 
		vGSNdescripcion = $('#GSNdescripcion_'+val).val().trim(); 
		vClass = val+'_'+vGSNid;

		if($('#esCorporativo').length != 0)
			vCoorporativo = $('#esCorporativo').prop('checked');

		vjtreeListaItem = $('#jtreeListaItem').val();

		if($('.'+vClass).length == 0){
			elementHTML = '<div class="row encGC '+vClass+'"><div class="col-xs-3">'+vGSNdescripcion+'</div><div class="col-xs-1 lbCod"><label><strong><cfoutput>#LB_Codigo#</cfoutput></strong></label></div><div class="col-xs-4"><label><strong><cfoutput>#LB_Descripcion#</cfoutput></strong></label></div><div class="col-xs-1"><a style="padding:0" class="btn" title="<cfoutput>#LB_Eliminar#</cfoutput>" onclick="fnDelElement(this,2)"><i class="fa fa-times fa-sm"></i></a></div><input type="hidden" name="listGSNCG" value="'+vGSNid+'"/></div>';

			$('.detListCargas').append(elementHTML);

			$.ajax({
		        url: "IICADesgloseTransferencia-lista.cfm",
		        type: "post",
		        dataType: "json",
		        async : false,
		        data: { GetListCargas:true, GSNid:vGSNid, esCorporativo:vCoorporativo, jtreeListaItem:vjtreeListaItem },  
		        success: function(data) { 
		        	if(data.DATA.length > 0){
				        $.each(data.DATA, function(key, val){
				        	vDClinea = -1;
				        	vDCcodigo = "";
				        	vDCdescripcion = "";
							$.each(val, function(key, val){
								switch(key){
									case 0:
										vDClinea = val;
										break;
									case 1:
										vDCcodigo = val;
										break;
									case 2:
										vDCdescripcion = val;		
										break;
									default:
										vDClinea = -1
								}		
						 	});

						 	if(vDClinea != -1){ 
						 		elementHTML = '<div class="row '+vClass+'" id="'+vDClinea+'"><div class="col-xs-3"></div><div class="col-xs-1">'+vDCcodigo+'</div><div class="col-xs-4">'+vDCdescripcion+'</div><div class="col-xs-1"><a style="cursor: pointer" title="<cfoutput>#LB_Eliminar#</cfoutput>" onclick="fnDelElement(this,2)"><i class="fa fa-times fa-sm"></i></a></div><input type="hidden" name="TcodigoListCg" value="'+vDClinea+'"/></div>';

							 	$('.detListCargas').append(elementHTML);
							}	
						}); 	
					}	
					else{
				 		elementHTML = '<div class="row '+vClass+'"><div class="col-xs-3"></div><div class="col-xs-1">'+vDCcodigo+'</div><div class="col-xs-4">'+vDCdescripcion+'</div><div class="col-xs-1"><a style="cursor: pointer" title="<cfoutput>#LB_Eliminar#</cfoutput>" onclick="fnDelElement(this,2)"><i class="fa fa-times fa-sm"></i></a></div></div>';
				
						$('.detListCargas').append(elementHTML);
					}
					
					if(!$('.detailCargas').is(':visible'))
						$('.detailCargas').show();	
		       }
		    });
			
			$('#listNSGSNCG').val($('#listNSGSNCG').val()+','+vGSNid);

			fnClearSelect(2);
		} 
    }

    // Funcion para agregar las Deducciones relacionadas al Grupo de Socios de Negocios seleccionado
    function fnAddDD(val){
    	var elementHTML = "", vGSNid = -1, vGSNcodigo = "", vGSNdescripcion = "", vTDid = -1, vTDcodigo = "-----", vTDdescripcion = "-------------------------", vClass = "", vCoorporativo = false, vjtreeListaItem = "";

    	vGSNid = $('#GSNid_'+val).val().trim();
        vGSNcodigo = $('#GSNcodigo_'+val).val().trim(); 
		vGSNdescripcion = $('#GSNdescripcion_'+val).val().trim();
		vClass = val+'_'+vGSNid;

		if($('#esCorporativo').length != 0)
			vCoorporativo = $('#esCorporativo').prop('checked');

		vjtreeListaItem = $('#jtreeListaItem').val();

		if($('.'+vClass).length == 0){
			elementHTML = '<div class="row encGC '+vClass+'"><div class="col-xs-3">'+vGSNdescripcion+'</div><div class="col-xs-1 lbCod"><label><strong><cfoutput>#LB_Codigo#</cfoutput></strong></label></div><div class="col-xs-4"><label><strong><cfoutput>#LB_Descripcion#</cfoutput></strong></label></div><div class="col-xs-1"><a style="padding:0" class="btn" title="<cfoutput>#LB_Eliminar#</cfoutput>" onclick="fnDelElement(this,3)"><i class="fa fa-times fa-sm"></i></a></div><input type="hidden" name="listGSNDED" value="'+vGSNid+'"/></div>';

			$('.detListDedud').append(elementHTML);

			$.ajax({
		        url: "IICADesgloseTransferencia-lista.cfm",
		        type: "post",
		        dataType: "json",
		        async : false,
		        data: { GetListDeducciones:true, GSNid:vGSNid, esCorporativo:vCoorporativo, jtreeListaItem:vjtreeListaItem },  
		        success: function(data) {
		        	if(data.DATA.length > 0){
				        $.each(data.DATA, function(key, val){
				        	vTDid = -1;
							vTDcodigo = "";
							vTDdescripcion = "";
							$.each(val, function(key, val){
								switch(key){
									case 0:
										vTDid = val;
										break;
									case 1:
										vTDcodigo = val;
										break;
									case 2:
										vTDdescripcion = val;		
										break;
									default:
										vTDid = -1;
								}										
						 	});

						 	if(vTDid != -1){ 
						 		elementHTML = '<div class="row '+vClass+'" id="'+vTDid+'"><div class="col-xs-3"></div><div class="col-xs-1">'+vTDcodigo+'</div><div class="col-xs-4">'+vTDdescripcion+'</div><div class="col-xs-1"><a style="cursor: pointer" title="<cfoutput>#LB_Eliminar#</cfoutput>" onclick="fnDelElement(this,3)"><i class="fa fa-times fa-sm"></i></a></div><input type="hidden" name="TcodigoListDD" value="'+vTDid+'"/></div>';
						 		
						 		$('.detListDedud').append(elementHTML);
						 	}
						}); 
					}	
					else{
				 		elementHTML = '<div class="row '+vClass+'"><div class="col-xs-3"></div><div class="col-xs-1">'+vTDcodigo+'</div><div class="col-xs-4">'+vTDdescripcion+'</div><div class="col-xs-1"><a style="cursor: pointer" title="<cfoutput>#LB_Eliminar#</cfoutput>" onclick="fnDelElement(this,3)"><i class="fa fa-times fa-sm"></i></a></div></div>';
						
						$('.detListDedud').append(elementHTML);
					}
					
					if(!$('.detailDedud').is(':visible'))  
						$('.detailDedud').show();		
		       }
		    });
			
			$('#listNSGSNDED').val($('#listNSGSNDED').val()+','+vGSNid);

			fnClearSelect(3);
		}		
    }	

    // Funcion para limpiar los campos despues de agregar una seleccion a la lista de consulta
    function fnClearSelect(e){
		switch(e){ 
			case 1: // Calendarios Pagos
				$('#Tcodigo, #Tdescripcion, #CPcodigo, #CPdescripcion,#Tcodigo2, #Tdescripcion2, #CPcodigo2, #CPdescripcion2').val('');
				break;
			case 2: // Cargas
				$('#GSNcodigo_CS, #GSNdescripcion_CS').val('');	
				break;
			case 3: // Deducciones 
				$('#GSNcodigo_DD, #GSNdescripcion_DD').val('');
				break;
			default:	
				$('#Tcodigo, #Tdescripcion, #CPcodigo, #CPdescripcion, #GSNcodigo_CS, #GSNdescripcion_CS, #GSNcodigo_DD, #GSNdescripcion_DD').val('');
		}		
	}

    // Funcion encargada de eliminar un elemento de la lista de calendarios de pago, cargas o deducciones que se haya seleccionado
    function fnDelElement(e,val){
    	var vDetailName = "", vDetNameList = "", vGC = "", vListName = "", vListNameNS = "", vListElements = "0";

    	switch(val){
    		case 1:  // Nominas
				vDetailName = "detailNom"; 
				vDetNameList = "detListNom";	
				vListName = "TcodigoListNom";
				vListNameNS = "listNSCPid";
				break;	
			case 2:  // Cargas
				vDetailName = "detailCargas"; 
				vDetNameList = "detListCargas";	
				vListName = "listGSNCG";
				vListNameNS = "listNSGSNCG";
				break;	
			case 3: // Socios de Negocios
				vDetailName = "detailDedud"; 
				vDetNameList = "detListDedud";	
				vListName = "listGSNDED";
				vListNameNS = "listNSGSNDED";
				break;		
			default:
				vDetailName = "";
				vDetNameList = "";
				vListName = "";
				vListNameNS = "";
    	}

    	if(val == 2 || val == 3){ // Cargas o Deducciones
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
		}	
		else // Nominas(1)
			$(e).parent().parent().remove();

		if(!$('.'+vDetailName+' .'+vDetNameList+' div').length){
			$('.'+vDetailName).hide(); 
		}	

		$('input[name='+vListName+']').each(function(i){
			vListElements += ','+ $(this).val();
		});	

		$('#'+vListNameNS).val(vListElements);
	}

	// Funcion que valida si los elementos requeridos han sido suministrados por el usuario para realizar submit del form
	function fnValSubmit(){
		var result = true;
		var mensaje = '<strong>¡<cfoutput>#MSG_Nota#</cfoutput>!</strong> ';

		if(!$('.detailNom').is(':visible')) {
			mensaje += '<cfoutput>#MSG_NominaSelect#</cfoutput>';
			result = false;
			alert(mensaje);
		}
		
		return result;
	}

    function fnEsHistorico(){
        if($('#chkHistorico').prop('checked')){
            $('#divHistorico').show();
        	$('#divProceso').hide();
        }	
        else{
            $('#divHistorico').hide();
        	$('#divProceso').show();
        } 
    }

    // Funcion para limpiar(inicializar) los elementos del formulario
    function fnLimpiar(){
		$(".detListNom, .detListCargas, .detListDedud").empty();
		$('.listTree').listTree('deselectAll');
		$(".divArbol, .detailNom, .detailCargas, .detailDedud").hide();
		$('#jtreeListaItem').val(<cfoutput>#session.Ecodigo#</cfoutput>);
		$('#listNSCPid, #listNSGSNCG, #listNSGSNDED').val('0');
	}
</script>