
<style type="text/css">
	.ln div span { float: left; margin-right: 5px; width: 85px; }
	.ln .codigo input { width: 200px; }
	.ln .correo input { width: 320px; }
	.ln .descrip input { width: 320px; }
	.tpFormat span { float: left; margin-right: 5px; }
	.tpFormat select { width: 295px; margin-right: 0; float: left; }
	.editor { margin-top: 25px; }
	.editor .lbFmt { margin-left: 47%; }
	.btns { margin-bottom: 10px; }
	.alert { position: fixed; top: 40%; right: 41%; display:none; width: 330px !important; }
</style>


<cfif not REFind('erp.css',session.sitio.CSS)>
	<cf_importLibs>
</cfif>

<cfset t = createObject("component", "sif.Componentes.Translate")>

<!--- Etiquetas de traduccion --->
<cfset LB_FormatosCorreo = t.translate('LB_FormatosCorreo','Formatos de Correo','/rh/FormatosCorreo.xml')>
<cfset LB_Codigo = t.translate('LB_Codigo','Código','/rh/generales.xml')>
<cfset LB_Descripcion = t.translate('LB_Descripcion','Descripción','/rh/generales.xml')>
<cfset LB_TipoFormato = t.translate('LB_TipoFormato','Tipo de Formato','/rh/generales.xml')>
<cfset LB_SeleccioneTipoFormato = t.translate('LB_SeleccioneTipoFormato','Seleccione el tipo de formato','/rh/generales.xml')>
<cfset LB_TextoDelFormato = t.translate('LB_TextoDelFormato','Texto del Formato','/rh/generales.xml')>

<cfset LB_CorreoNotificar = t.translate('LB_CorreoNotificar','Correo a Notificar','/rh/generales.xml')>
<cfset LB_DiasAntesVencimiento = t.translate('LB_DiasAntesVencimiento','Días antes de vencimiento','/rh/generales.xml')>

<cfset MSG_Nota = t.translate('MSG_Nota','Nota','/rh/generales.xml')>
<cfset LB_SePresentaronLosSiguientesErrores = t.translate('LB_SePresentaronLosSiguientesErrores','Se presentaron los siguientes errores','/rh/generales.xml')>
<cfset LB_EsRequerido = t.translate('LB_EsRequerido','es requerido','/rh/generales.xml')>
<cfset MSG_RequeridosFormato = t.translate('MSG_RequeridosFormato','Para agregar el formato de correo se debe seleccionar los siguientes valores','/rh/FormatosCorreo.xml')>


<cfif isdefined("url.EFid") and len(trim(url.EFid))>
	<cfset form.EFid = url.EFid>
	<cfset modo = "Cambio">
</cfif>

<cfif isdefined('form.EFid') and len(trim(form.EFid))>
	<cfset modo = 'Cambio'>
<cfelse>
	<cfset modo = 'Alta'>
</cfif>

<cfquery name="rsTipoFormato" datasource="#Session.DSN#">
	select TFid, TFdescripcion, TFcfm
	from TFormatos
	Where TFUso = 2
</cfquery>


<cfset miHTML = "" >

<cfif compare(modo,'Alta') neq 0>
	<cf_translatedata name="get" tabla="EFormato" col="ef.EFdescripcion" returnvariable="LvarEFdescripcion">
	<cf_translatedata name="get" tabla="EFormato" col="ef.EFdescalterna" returnvariable="LvarEFdescalterna">
	<cf_translatedata name="get" tabla="DFormato" col="df.DFtexto" returnvariable="LvarDFtexto">
	<cfquery name="rsFormatos" datasource="#Session.DSN#">
		select ef.EFid, ef.EFcodigo, #LvarEFdescripcion# as EFdescripcion, ef.TFid, ef.EFfecha, df.DFlinea,  
		#LvarDFtexto# as DFtexto, #LvarEFdescalterna# as EFdescalterna,ef.EFCorreoNotificar as EFcorreos,ef.EFDiasAntesVencimiento as EFdias
		from EFormato ef
		inner join TFormatos tf
        	on tf.TFid = ef.TFid
		left join DFormato df
			on ef.EFid = df.EFid
		where ef.EFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EFid#">
		and tf.TFUso = 2
	</cfquery>

	<cfset miHTML = rsFormatos.DFtexto>
</cfif>

<cf_templateheader> 
	<cf_web_portlet_start>
		<form action="FormatosCorreo-sql.cfm" method="post" name="form1">
			<cfoutput>
				<!--- Codigo, descripcion y tipo de formato de correo --->
				<div class="row">
					<div class="form-group">
						<div class="col-sm-6 ln">
							<input name="DFlinea" type="hidden" value="<cfif compare(modo,'Alta') neq 0 and isdefined('rsFormatos') and rsFormatos.DFlinea NEQ ''>#rsFormatos.DFlinea#<cfelse>0</cfif>">

							<div class="col-sm-offset-4 codigo">
								<span><strong>#LB_Codigo#:</strong></span>
								<input type="text" name="EFcodigo" class="form-control" placeholder="#LB_Codigo#" maxlength="10" size="20" value="<cfif compare(modo,'Alta') neq 0>#trim(rsFormatos.EFcodigo)#</cfif>" />
							</div>	

							<div class="col-sm-offset-4 descrip">
								<span><strong>#LB_Descripcion#:</strong></span>
								<input type="text" name="EFdescripcion" class="form-control" placeholder="#LB_Descripcion#" maxlength="80" size="40" value="<cfif compare(modo,'Alta') neq 0>#trim(rsFormatos.EFdescripcion)#</cfif>" />
							</div>	

							<cfset EFdias = 0>
							<cfif compare(modo,'Alta') neq 0>
								<cfset EFdias = trim(rsFormatos.EFdias)>
							</cfif>

							<div class="col-sm-offset-4 codigo">
								<span><strong>#LB_DiasAntesVencimiento#:</strong></span>
								<cf_inputNumber name="EFdiasVen" id="EFdiasVen" value="#EFdias#" size="20" enteros="15" decimales="0" readonly="no">
							</div>	
						</div>	
						<div class="col-sm-6">
							<div class="tpFormat">
								<span><strong>#LB_TipoFormato#:</strong></span>
								<select name="TFid" class="form-control">
									<option value="">#LB_SeleccioneTipoFormato#</option>
										<cfloop query="rsTipoFormato">
											<option value="#TFid#" <cfif compare(modo,'Alta') neq 0 and rsTipoFormato.TFid EQ rsFormatos.TFid>selected</cfif>>#TFdescripcion#</option>
										</cfloop> 
								</select>
								<a href="/cfmx/sif/Formatos/FormatosTipos.cfm" style="cursor:pointer">.</a>
							</div>		
						</div>	
						<div class="col-sm-6">
							<div class="tpFormat">
								<span><strong>#LB_CorreoNotificar#:</strong></span>
								<input type="text" name="EFcorreo" class="form-control" placeholder="#LB_CorreoNotificar#" maxlength="250" size="20" value="<cfif compare(modo,'Alta') neq 0>#trim(rsFormatos.EFcorreos)#</cfif>" />
							</div>		
						</div>	
					</div>	
				</div>
				
				<!--- Editor HTML para escribir texto del formato de correo --->
				<div class="row">
					<div class="form-group col-sm-12 editor">
						<span class="lbFmt"><strong>#LB_TextoDelFormato#</strong></span>
						<div class="editHTML">
							<cf_rheditorhtml name="DFtexto" value="#miHTML#" height="400" toolbarset="Default">
						</div>	
					</div>	
				</div>

				<!--- Botones de accion --->
				<div class="form-group row"> 
			        <div class="col-sm-12 btns">
						<cf_botones modo="#modo#" include="Regresar">
			        </div>
		        </div>
		        <input type="hidden" class="btnAccion" value="" name="btnAccion"></input>
		        <input type="hidden" name="EFid" value="<cfif compare(modo,'Alta') neq 0>#rsFormatos.EFid#</cfif>">
			</cfoutput>
		</form>	
		<div class="alert alert-danger alert-dismissable">
			<a onclick="fnHideMessage()" class="close" aria-hidden="true">&times;</a>
		    <span></span>
		</div>
	<cf_web_portlet_end>
<cf_templatefooter>


<script type="text/javascript">
	$(document).ready(function(){
		$('.btnGuardar').click(function(e){
			e.preventDefault();
			fnValidarAdd();
		});

		$('.btnLimpiar').click(function(e){
			e.preventDefault();
			fnLimpiar();
		});

		$('.btnNuevo').click(function(e){
			e.preventDefault();
			location.href = 'FormatosCorreo-form.cfm';
		});

		$('.btnAnterior').click(function(e){
			e.preventDefault();
			location.href = 'FormatosCorreo.cfm';
		});
	});	

	function fnValidarAdd(){
		if(fnValidar()){
			$('.btnAccion').attr('name',$('.btnGuardar').prop('name')).attr('value',$('.btnGuardar').prop('value'));
			$('form[name=form1]').submit();
		}	
	}

	function fnValidar(){
		var result = true;
		var mensaje = '<cfoutput>#LB_SePresentaronLosSiguientesErrores#</cfoutput><br>';

		if($("input[name=EFcodigo]").val().trim() == ''){
			mensaje += '-> <cfoutput>#LB_Codigo# #LB_EsRequerido#</cfoutput><br/>';
			result = false;
		}	

		if($("input[name=EFdescripcion]").val().trim() == ''){
			mensaje += '-> <cfoutput>#LB_Descripcion# #LB_EsRequerido#</cfoutput><br/>';
			result = false;
		}	

		if($('select[name=TFid]').val() == ''){
			mensaje += '-> <cfoutput>#LB_TipoFormato# #LB_EsRequerido#</cfoutput><br/>';
			result = false;
		}	

		if(!result){
			$('.alert span').html(mensaje);
			fnShowMessage();
		}

		return result;
	}

	function fnLimpiar(){
		$('form[name=form1]')[0].reset();
		CKEDITOR.instances.DFtexto.setData('');
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