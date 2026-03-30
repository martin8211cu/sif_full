
<style type="text/css">
	.well { padding: 25px 10px 15px 10px; margin-top: 10px; margin-bottom: 15px;  }
	.form-group { margin-left: 5px; }
	.concursos, .escogEnvio { margin-left: 10px; }
	.concursos div { margin-bottom: 20px; }
	.concursos .selectConcurs { width: 355px; }
	.detConcurs .ln input { width: 350px; }
	.detConcurs fieldset { width: 80%; }
	.detConcurs fieldset div { margin-top: -8px; }
	.escogEnvio div.fmtEnviar { margin-top: 10px; }
	.escogEnvio div.fmtEnviar input { width: 450px; }
	.escogEnvio div.listConcurs { margin-top: 30px; }
	.encabezado, .detListConcurs { margin-left: -2px; width: 110%; }
	.encabezado div { background-color: #B0C8D3; padding-top: 4px; height: 28px; margin-bottom: 0; }
	.encabezado div label { margin-left: -10px; }
	.detListConcurs { max-height: 16em; overflow-y: auto; overflow-x: hidden; margin-top: -20px; }
    .detListConcurs .row, .detListConcurs .row div { height: 35px; margin-bottom: 0; }
    .detListConcurs div { padding-top: 3px; padding-bottom: 3px; }
    .detListConcurs div.row:nth-child(2n) { background-color: #ffffff; }
    .btns { margin-top: -15px; }
	.msgValid { top: 40%; }
	.msgEnvio { top: 55%; }
	.msgValid, .msgEnvio { position: fixed;  right: 41%; display:none; width: 330px !important; }
</style>

<!----- Etiquetas de traduccion------>
<cfset LB_SeleccioneConcurso = t.translate('LB_SeleccioneConcurso','Seleccione el concurso','/rh/generales.xml')>
<cfset LB_DetalleConcurso = t.translate('LB_DetalleConcurso','Detalle del concurso','/rh/generales.xml')>
<cfset LB_Codigo = t.translate('LB_Codigo','Código','/rh/generales.xml')>
<cfset LB_Descripcion = t.translate('LB_Descripcion','Descripción','/rh/generales.xml')>
<cfset LB_Puesto = t.translate('LB_Puesto','Puesto','/rh/generales.xml')>
<cfset LB_Apertura = t.translate('LB_Apertura','Apertura','/rh/generales.xml')>
<cfset LB_Cierre = t.translate('LB_Cierre','Cierre','/rh/generales.xml')>
<cfset LB_SeleccioneTipoCorreo = t.translate('LB_SeleccioneTipoCorreo','Seleccione el tipo de correo','/rh/generales.xml')>
<cfset LB_CorreoTodosConcursantes = t.translate('LB_CorreoTodosConcursantes','Correo para todos los concursantes','/rh/generales.xml')>
<cfset LB_CorreoConcursantesDescalificados = t.translate('LB_CorreoConcursantesDescalificados','Correo para concursantes descalificados','/rh/generales.xml')>
<cfset LB_CorreoConcursantesNOSeleccionados = t.translate('LB_CorreoConcursantesNOSeleccionados','Correo para concursantes no seleccionados','/rh/generales.xml')>

<cfset LB_CorreoConcursantesSeleccionados = t.translate('LB_CorreoConcursantesSeleccionados','Correo para concursantes seleccionados','/rh/generales.xml')>

<cfset LB_FormatoEnviar = t.translate('LB_FormatoEnviar','Formato a enviar','/rh/generales.xml')>
<cfset LB_ListaConcursantes = t.translate('LB_ListaConcursantes','Lista de Concursantes','/rh/generales.xml')>
<cfset LB_Nombre = t.translate('LB_Nombre','Nombre','/rh/generales.xml')>
<cfset LB_Correo = t.translate('LB_Correo','Correo','/rh/generales.xml')>
<cfset LB_Tipo = t.translate('LB_Tipo','Tipo','/rh/generales.xml')>
<cfset LB_Enviar = t.translate('LB_Enviar','Enviar','/rh/generales.xml')>
<cfset LB_Limpiar = t.translate('LB_Limpiar','Limpiar','/rh/generales.xml')>

<cfset MSG_Nota = t.translate('MSG_Nota','Nota','/rh/generales.xml')> 
<cfset MSG_RequeridosEnvio = t.translate('MSG_RequeridosEnvio','Para realizar el envío del correo se debe seleccionar los siguientes valores','/rh/EnvioCorreosConcursantes.xml')>
<cfset MSG_EnviarCorreo = t.translate('MSG_EnviarCorreo','Envía un correo a los concursantes seleccionados','/rh/EnvioCorreosConcursantes.xml')>
<cfset MSG_Limpiar = t.translate('MSG_Limpiar','Limpia el formulario','/rh/EnvioCorreosConcursantes.xml')>
<cfset MSG_EnvioSatisfactorio = t.translate('MSG_EnvioSatisfactorio','Se envío el correo satisfactoriamente a los concursantes seleccionados','/rh/EnvioCorreosConcursantes.xml')>
<cfset MSG_FormatoNoSeleccionado = t.translate('MSG_FormatoNoSeleccionado','No se realizó el envío de correos porque no existe un formato de correo seleccionado','/rh/EnvioCorreosConcursantes.xml')>
<cfset MSG_ConcursantesNoRelacionados = t.translate('MSG_ConcursantesNoRelacionados','No se realizó el envío de correos porque no existe ningún concursante relacionado','/rh/EnvioCorreosConcursantes.xml')>
<cfset MSG_AccionNoRealizada = t.translate('MSG_AccionNoRealizada','No se realizó el envío de correos','/rh/EnvioCorreosConcursantes.xml')>


<cf_translatedata name="get" tabla="RHConcursos" col="RHCdescripcion" returnvariable="LvarRHCdescripcion">
<cf_translatedata name="get" tabla="RHPuestos" col="RHPdescpuesto" returnvariable="LvarRHPdescpuesto">
<cfquery name="rsListaConcursos" datasource="#session.DSN#">
	select a.RHCconcurso, 
		   a.RHCcodigo as codigo,
		   #LvarRHCdescripcion# as descripcion,
		   a.RHCfapertura as fechaapertura,
		   a.RHCfcierre as fechacierre,
		   a.RHCcantplazas as cantidadplazas,
		   a.RHPcodigo, 
		   #LvarRHPdescpuesto# as RHPdescpuesto
	from RHConcursos a 
	inner join RHPuestos b
		on a.RHPcodigo = b.RHPcodigo
		and a.Ecodigo = b.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by #LvarRHCdescripcion# asc
</cfquery> 


<!--- Obtiene los formatos de correo de envio definidos en RHParametros para los concursantes --->
<cf_translatedata name="get" tabla="EFormato ef" col="EFdescripcion" returnvariable="LvarEFdescripcion">
<cfquery name="rsFormatosCorreo" datasource="#session.DSN#">
	select rhp.Pcodigo, ef.EFid, ef.EFcodigo, #LvarEFdescripcion# as EFdescripcion
	from RHParametros rhp
	inner join EFormato ef
		on rhp.Pvalor = <cf_dbfunction name="to_char" args="ef.EFid">
		and rhp.Ecodigo = ef.Ecodigo
	where rhp.Pcodigo in(2712,2713,2714,2728) 
	and rhp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<div class="well"> 
	<div class="container-fluid"> 
		<form action="EnvioCorreosConcursantes-sql.cfm" method="post" name="form1">
			<cfoutput>
				<div class="form-group row">
					<!--- Seleccion de concursos disponibles(abiertos y cerrados) y detalle del concurso seleccionado --->
					<div class="col-sm-5  concursos" style="min-width:380px;">
						<div>
							<select name="sConcurso" class="form-control selectConcurs">
								<option value="">#LB_SeleccioneConcurso#</option>
								<cfloop query="rsListaConcursos">
									<option value="#RHCconcurso#">#codigo# - #descripcion#</option>
								</cfloop>
							</select>
						</div>	
						<div class="detConcurs">
							<fieldset>
								<legend><strong>#LB_DetalleConcurso#</strong></legend>
							    <div class="form-group ln">
									<label for="codigo">#LB_Codigo#:</label> 
									<input type="text" name="codigo" class="form-control" placeholder="#LB_Codigo#" value="" readonly/>
							    </div>
							    <div class="form-group ln">
									<label for="descrip">#LB_Descripcion#:</label> 
									<input type="text" name="descripcion" class="form-control" placeholder="#LB_Descripcion#" value="" readonly/>
							    </div>
							    <div class="form-group ln">
									<label for="puesto">#LB_Puesto#:</label> 
									<input type="text" name="puesto" class="form-control" placeholder="#LB_Puesto#" value="" readonly/>
							    </div>
							    <div class="form-group ln">
									<label for="apertura">#LB_Apertura#:</label> 
									<input type="text" name="apertura" class="form-control" placeholder="#LB_Apertura#" value="" readonly/>
							    </div>
							    <div class="form-group ln">
									<label for="cierre">#LB_Cierre#:</label> 
									<input type="text" name="cierre" class="form-control" placeholder="#LB_Cierre#" value="" readonly/>
							    </div>
						    </fieldset>
						</div>	
					</div> 	

					<!--- Escogencia de envio correos(tipo correo, formato, lista concursantes) --->
					<div class="col-sm-5 escogEnvio form-group">
						<div>
							<input type="radio" name="tpEnvCorreo" value="1"/> <label>#LB_CorreoTodosConcursantes#</label><br/>
							<input type="radio" name="tpEnvCorreo" value="2"/> <label>#LB_CorreoConcursantesDescalificados#</label><br/>
							<input type="radio" name="tpEnvCorreo" value="3"/> <label>#LB_CorreoConcursantesNOSeleccionados#</label><br/>
							<input type="radio" name="tpEnvCorreo" value="4"/> <label>#LB_CorreoConcursantesSeleccionados#</label><br/>
						</div>	
						<div class="fmtEnviar" >
							<label>#LB_FormatoEnviar#:</label> 
							<input type="text" name="fEnviar" class="form-control" placeholder="#LB_FormatoEnviar#" value="" readonly/>
						</div>	
						<div class="listConcurs">
							<label>#LB_ListaConcursantes#</label>
							<div class="row encabezado">	 
								<div class="col-xs-5"><label><strong>#LB_Nombre#</strong></label></div>
					            <div class="col-xs-5"><label><strong>#LB_Correo#</strong></label></div>
					            <div class="col-xs-2"><label><strong>#LB_Tipo#</strong></label></div> 
							</div>
							<div class="detListConcurs">	
							</div>
						</div>	
					</div>	
		        </div>

		        <!--- Botones de acciones --->
				<div class="form-group row btns"> 
			        <div class="col-sm-12 col-sm-offset-4">
						<a onclick="fnValidarEnvio()" onmouseover="fnShowTooltip('enviar')" class="btn btn-primary btn-sm enviar" data-toggle="tooltip" data-placement="top" title="#MSG_EnviarCorreo#"><i class="fa fa-check fa-sm"></i>#LB_Enviar#</a>	

						<a onclick="fnLimpiar()" onmouseover="fnShowTooltip('limpiar')" class="btn btn-warning btn-sm limpiar" data-toggle="tooltip" data-placement="top" title="#MSG_Limpiar#"> <i class="fa fa-check fa-sm"></i>#LB_Limpiar#</a>
			        </div>
		        </div>
			</cfoutput>
			<input type="hidden" name="opcion" value="" />
			<input type="hidden" name="RHCconcurso" value="" />
		</form>
		<div class="alert alert-danger alert-dismissable msgValid">
			<a onclick="fnHideMessage('msgValid')" class="close" aria-hidden="true">&times;</a>
		    <span></span>
		</div>
		<div class="alert alert-success alert-dismissable msgEnvio">
			<a onclick="fnHideMessage('msgEnvio')" class="close" aria-hidden="true">&times;</a>
		    <span></span>
		</div>
	</div> 
</div>

<script type="text/javascript" src="/cf_scripts/scripts/wddx.js"></script>
<script type="text/javascript">
	var vRHCconcurso = '', vEFid = '', index = -1, vPcodigo = '', vOpcion='', mensaje = "";

	<cfoutput>
        var #toScript(rsListaConcursos, "concursos")#;
        var #toScript(rsFormatosCorreo, "formatCorreos")#;
    </cfoutput>
	
	$(document).ready(function(){
		$(".selectConcurs").change(function(){
			fnValChangeSelectConcurso();
		});

		$("input[name=tpEnvCorreo]").click(function(){
			fnValChangeSelectTipoFormato();
		});
	});		

	function fnValidarEnvio(){
		if(fnValidar()){
			mensaje = '<strong>¡<cfoutput>#MSG_Nota#</cfoutput>!</strong> <br/>';

			$.ajax({
		        url: "EnvioCorreosConcursantes-sql.cfm",
		        type: "post",
		        async : false,
		        data: "RHCconcurso="+vRHCconcurso+"&opcion="+vOpcion,
		        success: function(data) { 
					switch(data.trim()) {
					    case 'RS': 
					    	mensaje += '<cfoutput>#MSG_EnvioSatisfactorio#</cfoutput>';
					    	$('.msgEnvio').removeClass('alert-warning').addClass('alert-success');
					        break;
					    case 'NF':
					    	mensaje += '<cfoutput>#MSG_FormatoNoSeleccionado#</cfoutput>';
					    	$('.msgEnvio').removeClass('alert-success').addClass('alert-warning');
					        break;
					    case 'NC':
					    	mensaje += '<cfoutput>#MSG_ConcursantesNoRelacionados#</cfoutput>';
					    	$('.msgEnvio').removeClass('alert-success').addClass('alert-warning');
					        break;    
					    default:
					        mensaje += '<cfoutput>#MSG_AccionNoRealizada#</cfoutput>';
					        $('.msgEnvio').removeClass('alert-success').addClass('alert-warning');
					} 
					$('.msgEnvio span').html(mensaje);
					fnShowMessage('msgEnvio');
		       }
		  });
		}
	}

	function fnValidar(){
		var result = true;
		mensaje = '<strong>¡<cfoutput>#MSG_Nota#</cfoutput>!</strong> <cfoutput>#MSG_RequeridosEnvio#</cfoutput>:<br/><br/>';

		if($('.selectConcurs').val() == ''){
			mensaje += '-> <cfoutput>#LB_SeleccioneConcurso#</cfoutput><br/>';
			result = false;
		}

		if(!$("input[name=tpEnvCorreo]:checked").val()){
			mensaje += '-> <cfoutput>#LB_SeleccioneTipoCorreo#</cfoutput><br/>';
			result = false;
		}		

		if(!result){
			$('.msgValid span').html(mensaje);
			fnShowMessage('msgValid');
		}

		return result;
	}

	function fnValChangeSelectConcurso(){
		vRHCconcurso = $('.selectConcurs').val();
		if(vRHCconcurso != ''){
			fnCargarInfoConcurso(vRHCconcurso);

			if($('input[name=tpEnvCorreo]:checked').length > 0)
				fnValChangeSelectTipoFormato();
		}	
		else{
			$('input[name=codigo]').val('');
			$('input[name=descripcion]').val('');
			$('input[name=puesto]').val('');
			$('input[name=apertura]').val('');
			$('input[name=cierre]').val('');

			$('input[name=tpEnvCorreo]').attr('checked',false);
			$('input[name=fEnviar]').val('');
			$(".detListConcurs").empty();
		}
	}

	function fnValChangeSelectTipoFormato(){
		
		vOpcion = $('input[name=tpEnvCorreo]:checked').val();

		switch(vOpcion) {
		    case '1':
		        vPcodigo = '2712';
		        break;
		    case '2':
		        vPcodigo = '2713';
		        break;
		    case '3':
		        vPcodigo = '2714';
		        break;    
		    case '4':
		         vPcodigo = '2728';
		         break;    
		    default:
		        vPcodigo = '';
		}        
		fnSelectTipoFormatCorreo(vPcodigo);
		fnCargarListaConcursantes(vOpcion);

		$('input[name=opcion]').val(vOpcion);
	}

	function fnCargarInfoConcurso(e){
		index = getPositionEstruct(concursos,'rhcconcurso',e);

		if(index != -1){
			$('input[name=codigo]').val(concursos.codigo[index].trim());
			$('input[name=descripcion]').val(concursos.descripcion[index].trim());
			$('input[name=puesto]').val(concursos.rhpcodigo[index].trim() +' - '+ concursos.rhpdescpuesto[index].trim());
			$('input[name=apertura]').val(getDateShow(concursos.fechaapertura[index]));	
			$('input[name=cierre]').val(getDateShow(concursos.fechacierre[index]));	
			$('input[name=RHCconcurso]').val(concursos.rhcconcurso[index]);
		}  
	}

	function getDateShow(fecha){
		var vFecha = null;
		var day = fecha.getDate();
		var month = fecha.getMonth() + 1;
		var year = fecha.getFullYear();

		if(day < 10)
			day = '0' + day;

		vFecha = day +'/'+ month +'/'+ year;

		return vFecha;
	}

	function fnSelectTipoFormatCorreo(vPcodigo){
		vEFid = vPcodigo;
		index = getPositionEstruct(formatCorreos,'pcodigo',vEFid);
		if(index != -1){
			$('input[name=fEnviar]').val(formatCorreos.efcodigo[index].trim() +' - '+ formatCorreos.efdescripcion[index].trim()); 
		}	
	}

	function fnCargarListaConcursantes(vOpcion){
		$('.detListConcurs').empty();

		$.ajax({
		        url: "EnvioCorreosListaConcursantes.cfm",
		        type: "post",
		        dataType: "json",
		        async : false,
		        data: "&GetConcursantes=true&RHCconcurso="+vRHCconcurso+"&opcion="+vOpcion,
		        success: function(data) {
			        $.each(data.DATA, function(key, val){
			        	RHCPid = -1;
						identificacion = "";
						tipo = "";
						Nombre = "";
						email = "";
						DEid = -1;
						$.each(val, function(key, val){
							if(key == 0)
								RHCPid = val;
						 	else if(key == 1)
								identificacion = val;
							else if(key == 2)
								tipo = val;
							else if(key == 3)
								Nombre = val;
							else if(key == 4)
								email = val;
							else if(key == 5)
								DEid = val;
					 	});
					 	if(RHCPid != -1){
					 		elementHTML = '<div class="row" id="'+RHCPid+'"><div class="col-xs-5">'+Nombre+'</div><div class="col-xs-5">'+email+'</div><div class="col-xs-2">'+tipo+'</div></div>';
					 		$('.detListConcurs').append(elementHTML);
					 	}
					}); 	
		       }
		  });
	}

	function getPositionEstruct(Elementos, colName, e){
		index = -1;

		for (var i = 0; i <= Elementos.getRowCount()-1; i++) {
			if(eval('Elementos.'+colName+'['+i+']') == e){
				index = i;
				break;
			} 
		}
		return index;
	}

	function fnLimpiar(){
		$('form[name=form1]')[0].reset();
		$(".detListConcurs").empty();
	}

	function fnShowTooltip(e){
		$('.'+e).tooltip('show');
	}

	function fnShowMessage(e){	
		if($('.'+e).is(':visible'))
			$('.'+e).delay(200).fadeOut(500); 
		$('.'+e).delay(200).fadeIn(200); 
	}

	function fnHideMessage(e){
		$('.'+e).delay(200).fadeOut(500);  	
	}
</script>

