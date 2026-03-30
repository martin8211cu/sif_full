<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2692" default="0" returnvariable="LvarAprobarPublicacion"/>

<style type="text/css">
	.detailCoautor { margin-top: 25px; }  
	.detailCoautor table { margin-bottom: 15px; }
	.botones { padding-top: 15px; }
	input[name=Cambio] { margin-left: 12%; }
</style>

<!----- Etiquetas de traduccion------>
<cfset LB_TipoPublicacion = t.translate('LB_TipoPublicacion','Tipo de Publicación','/rh/generales.xml')>
<cfset LB_TituloPublicacion = t.translate('LB_TituloPublicacion','Título de la Publicación','/rh/generales.xml')>
<cfset LB_AnoPublicacion = t.translate('LB_AnoPublicacion','Año de la Publicación','/rh/generales.xml')>
<cfset LB_PublicadoEn = t.translate('LB_PublicadoEn','Publicado en','/rh/generales.xml')>
<cfset LB_Editorial = t.translate('LB_Editorial','Editorial','/rh/generales.xml')>
<cfset LB_Lugar = t.translate('LB_LugarDePublicacion','Lugar de Publicación','/rh/generales.xml')>
<cfset LB_EnlaceWebPublicacion = t.translate('LB_EnlaceWebPublicacion','Enlace web de la Publicación','/rh/generales.xml')>
<cfset LB_PublicadoCooperacion = t.translate('LB_PublicadoCooperacion','Publicado en cooperación con','/rh/generales.xml')>
<cfset BTN_Agregar = t.translate('BTN_Agregar','Agregar','/rh/generales.xml')>
<cfset BTN_Limpiar = t.translate('BTN_Limpiar','Limpiar','/rh/generales.xml')>
<cfset BTN_Modificar = t.translate('BTN_Modificar','Modificar','/rh/generales.xml')>
<cfset BTN_Eliminar = t.translate('BTN_Eliminar','Eliminar','/rh/generales.xml')>
<cfset BTN_Nuevo = t.translate('BTN_Nuevo','Nuevo','/rh/generales.xml')>
<cfset CMB_SelectTipoPublicacion = t.translate('CMB_SelectTipoPublicacion','Seleccione el tipo de publicación','/rh/generales.xml')>
<cfset MSG_AddCoautor = t.translate('MSG_AddCoautor','Agrega el colaborador seleccionado','/rh/autogestion/autogestion.xml')>

<!----- Etiquetas placeholder ------>
<cfset MSG_DigiteTituloPublic = t.translate('MSG_DigiteTituloPublic','Digite el título de la publicación','/rh/autogestion/autogestion.xml')>
<cfset MSG_DigiteAnoPublic = t.translate('MSG_DigiteAnoPublic','Digite el año de la publicación','/rh/autogestion/autogestion.xml')>
<cfset MSG_DigitePublicadoEn = t.translate('MSG_DigitePublicadoEn','Digite donde fue publicado','/rh/autogestion/autogestion.xml')>
<cfset MSG_DigiteEditorialPublic = t.translate('MSG_DigiteEditorialPublic','Digite la editorial de la publicación','/rh/autogestion/autogestion.xml')>
<cfset MSG_DigiteLugarPublic = t.translate('MSG_DigiteLugarPublic','Digite el lugar de la publicación','/rh/autogestion/autogestion.xml')>
<cfset MSG_DigiteEnlaceWeb = t.translate('MSG_DigiteEnlaceWeb','Digite el enlace de la publicación','/rh/autogestion/autogestion.xml')>
<cfset MSG_DigiteCoautores = t.translate('MSG_DigiteCoautores','Digite el nombre o nombres de colaboradores','/rh/autogestion/autogestion.xml')>

<!----- Etiquetas mensajes advertencia ------>
<cfset MSG_ElegirTipoPublicacion = t.translate('MSG_ElegirTipoPublicacion','Debe elegir un tipo de publicación','/rh/autogestion/autogestion.xml')>
<cfset MSG_IndicarTituloPublicacion = t.translate('MSG_IndicarTituloPublicacion','Debe indicar el título de publicación','/rh/autogestion/autogestion.xml')>
<cfset MSG_IndicarAnoPublicacion = t.translate('MSG_IndicarAnoPublicacion','Debe indicar el año de la publicación','/rh/autogestion/autogestion.xml')>
<cfset MSG_IndicarPublicadoEn = t.translate('MSG_IndicarPublicadoEn','Debe indicar donde fue publicado','/rh/autogestion/autogestion.xml')>
<cfset MSG_IndicarEditorial = t.translate('MSG_IndicarEditorial','Debe indicar la editorial de la publicación','/rh/autogestion/autogestion.xml')>
<cfset MSG_IndicarLugar = t.translate('MSG_IndicarLugar','Debe indicar el lugar de la publicación','/rh/autogestion/autogestion.xml')>
<cfset MSG_IndicarEnlaceWeb = t.translate('MSG_IndicarEnlaceWeb','Debe indicar el enlace web de la publicación','/rh/autogestion/autogestion.xml')>
<cfset MSG_IndicarCoautores = t.translate('MSG_IndicarCoautores','Debe indicar los co-autores de la publicación','/rh/autogestion/autogestion.xml')>
<cfset MSG_DeseaEliminarElRegistro = t.translate('MSG_DeseaEliminarElRegistro','Desea eliminar el registro','/rh/generales.xml')>
<cfset LB_CoAutor = t.translate('LB_CoAutor','Co-author','/rh/autogestion/autogestion.xml')>

<cf_translatedata name="get" tabla="RHPublicacionTipo" col="RHPTDescripcion" returnvariable="LvarRHPTDescripcion">
<cfquery name="rsPublicTipo" datasource="#session.DSN#">
	select RHPTid, #LvarRHPTDescripcion# as RHPTDescripcion
	from RHPublicacionTipo
	order by #LvarRHPTDescripcion#
</cfquery>

<cfif isdefined("form.RHPid") and len(trim(form.RHPid)) gt 0 >
	<cfset modo = 'Cambio'>	
	<cfquery name="rsPublicacion" datasource="#session.DSN#">
		select RHP.RHPid, RHP.RHPTid, RHP.RHPTitulo, RHP.RHPAnoPub, RHP.RHPPublicadoEn, RHP.RHPEditorial, RHP.RHPLugar,
		RHP.RHPEnlaceWebPub, RHP.RHPCoautores, RHP.RHPEstado
		from RHPublicaciones RHP
		where RHP.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPid#">
	</cfquery>
<cfelse>
	<cfset modo = 'Alta'>	
</cfif>

<cfoutput>
	<form name="publicacion" method="post" action="#destino#">
		<cfif isdefined("fromExpediente")>
			<input type="hidden" name="fromExpediente" value="1">
		</cfif>
		<cfif isdefined("fromAprobacionCV")><!----- si se trabaja desde aprobacion de curriculum vitae---->
			<input type="hidden" name="tab" value="5">
		</cfif>
		<table width="100%" cellpadding="7" cellspacing="0">
			<cfif isdefined('form.RHPid') and len(trim(form.RHPid)) gt 0 ><input type="hidden" name="RHPid" value="#form.RHPid#">
			</cfif>
			<cfif isdefined('form.DEid') and len(trim(form.DEid)) gt 0 ><input type="hidden" name="DEid" value="#form.DEid#">
			</cfif>
			<input type="hidden" name="RHPTid" value="">

			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td class="col-sm-5" align="left"><strong>#LB_TipoPublicacion#:&nbsp;</strong></td>
				<td align="left">
					<select name="sTipoPub" tabindex="1">
						<option value="">#CMB_SelectTipoPublicacion#</option>
						<cfloop query="rsPublicTipo">
							<option value="#RHPTid#" <cfif isdefined('rsPublicacion') and rsPublicacion.recordCount gt 0>
								<cfif rsPublicacion.RHPTid eq RHPTid>selected</cfif></cfif>	>#RHPTDescripcion#</option>
						</cfloop>	
					</select>							
				</td>
			</tr>
			<tr>
				<td class="col-sm-5" align="left"><strong>#LB_TituloPublicacion#:&nbsp;</strong></td>
				<td align="left">
					<textarea name="RHPTitulo" rows="3" cols="35" maxlength="250" placeholder="#MSG_DigiteTituloPublic#"><cfif modo eq 'Cambio'>#trim(rsPublicacion.RHPTitulo)#</cfif></textarea>
				</td>
			</tr>
			<tr>
				<td class="col-sm-5" align="left"><strong>#LB_AnoPublicacion#:&nbsp;</strong></td>
				<td align="left">
					<cfset anoActual = year(now())>
					<cfset anoInicial = year(now())-40 > 
					<select name="RHPAnoPub">
						<option value="">---------</option>
						<cfloop index="year" from="#anoInicial#" to="#anoActual#" step="1">
							<option value="#year#" <cfif modo eq 'Cambio' and rsPublicacion.recordCount gt 0>
								<cfif isdefined("rsPublicacion.RHPAnoPub") and len(trim(rsPublicacion.RHPAnoPub)) and int(rsPublicacion.RHPAnoPub) eq year>
								selected</cfif></cfif>>#year#</option>
						</cfloop>
					</select>	
				</td>	
			</tr>	
			<tr>
				<td class="col-sm-5" align="left"><strong>#LB_PublicadoEn#:&nbsp;</strong></td>
				<td align="left">
					<input type="text" name="RHPPublicadoEn" size="35" maxlength="80" placeholder="#MSG_DigitePublicadoEn#" value="<cfif modo eq 'Cambio'>#trim(rsPublicacion.RHPPublicadoEn)#</cfif>">
				</td>
			</tr>	
			<tr>
				<td class="col-sm-5" align="left"><strong>#LB_Editorial#:&nbsp;</strong></td>
				<td align="left">
					<input type="text" name="RHPEditorial" size="35" maxlength="80" placeholder="#MSG_DigiteEditorialPublic#" value="<cfif modo eq 'Cambio'>#trim(rsPublicacion.RHPEditorial)#</cfif>">
				</td>	
			</tr>	
			<tr>
				<td class="col-sm-5" align="left"><strong>#LB_Lugar#:&nbsp;</strong></td>
				<td align="left">
					<input type="text" name="RHPLugar" size="35" maxlength="80" placeholder="#MSG_DigiteLugarPublic#" value="<cfif modo eq 'Cambio'>#trim(rsPublicacion.RHPLugar)#</cfif>">
				</td>	
			</tr>	
			<tr>
				<td class="col-sm-5" align="left"><strong>#LB_EnlaceWebPublicacion#:&nbsp;</strong></td>
				<td align="left">
					<input type="text" name="RHPEnlaceWebPub" size="35" placeholder="#MSG_DigiteEnlaceWeb#" value="<cfif modo eq 'Cambio'>#trim(rsPublicacion.RHPEnlaceWebPub)#</cfif>">
				</td>
			</tr>	
			<tr>
				<td class="col-sm-5" align="left"><strong>#LB_PublicadoCooperacion#:&nbsp;</strong></td>
				<td align="left">
					<input type="text" name="RHPCoautores" size="45" placeholder="#MSG_DigiteCoautores#" value="">
					<a id="btnAddCtr" onclick="fnAddSelect()"  class="btn btn-primary btn-xs Ctr"><i class="fa fa-plus fa-xs"></i></a>
				</td>	
			</tr>
			<tr class="detailCoautor" <cfif modo neq 'Cambio' or (isdefined('rsPublicacion') and len(trim(rsPublicacion.RHPCoautores)) eq 0 )> style="display:none;"</cfif>>
 				<td class="lbPub" align="left"></td>
				<td>
					<table class="PlistaTable" width="80%" cellspacing="0" cellpadding="0" border="1">
						<thead>
							<tr bgcolor="##E3EDEF">
								<th nowrap="" align="center" class="tituloListas">#LB_CoAutor#</th>
								<th width="4%" nowrap="" align="center" class="tituloListas"></th>
							</tr>	
						</thead>
						<tbody class="detailSelect">
							<cfif modo eq 'Cambio' and len(trim(rsPublicacion.RHPCoautores)) gt 0 >
								<cfset listCoautor = valueList(rsPublicacion.RHPCoautores)>
								<cfloop list="#listCoautor#" index="i">
									<tr id="#i#">
										<td valign="bottom" align="left">#i#</td>
										<td align="center">
											<a style="padding:0" class="btn" title="Eliminar" onclick="fnDelElement(this)">
												<i class="fa fa-times fa-sm"></i>
											</a>
										</td>
										<input type="hidden" name="TCoautorList" value="#i#"/>
									</tr>
								</cfloop>
							</cfif>	
						</tbody>	
					</table>		
				</td>	
			</tr>	
			<tr>
				<td class="botones" colspan="2" align="center"> 
					<cfif isdefined ('LvarAutog') and LvarAutog eq 1 and  modo eq 'Cambio' and rsPublicacion.RHPEstado eq 1 and LvarAprobarPublicacion>
						<div class="row">	
							<div class="alert alert-dismissable alert-info text-center">
							 <cf_Translate key="MSG_NoPuedeEditarEstarInformacionAprobacionPrevia" xmlFile="/rh/generales.xml">No puede editar esta información debido a una aprobación previa</cf_Translate>
							</div>
						</div>
						 <cf_botones values="Nuevo">
					<cfelse>	
						<cf_botones modo="#modo#"> 
					</cfif>
				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
		</table>	
	</form>	
</cfoutput>	

<script type="text/javascript"> 
	$("form[name=publicacion]").submit( function(event) {
		if(!fnValidar())
		  	event.preventDefault();
		 else
		 	$('input[name=RHPTid]').val($('select[name=sTipoPub]').val());
	});

	<cfoutput>	
		function fnValidar(){
			var result = true;

			if($('select[name=sTipoPub]').val() == ''){ 
				alert('#MSG_ElegirTipoPublicacion#');
				result = false;
			} 
			else
				if($('textarea[name=RHPTitulo]').val().trim() == ''){ 
					alert('#MSG_IndicarTituloPublicacion#');
					result = false;	
				}	
			return result;
		}

		function fnAddSelect(){
			var result = true;
			result = fnValidarElement("RHPCoautores",'#MSG_IndicarCoautores#');
		
			if(result)
				fnAddElement(); 
		}
	</cfoutput>

	function fnValidarElement(e,showMsg){
		if ($('input[name='+e+']').val().trim() == ''){ 
			alert(showMsg);
			return false;
		}
		return true;
	}	

	function fnAddElement(){
		var result = "", coautor = "";
		coautor = $('input[name=RHPCoautores]').val().trim();

		if($("input[name=TCoautorList][value='"+coautor+"']").length == 0){
			result = '<tr id="'+coautor+'"><td valign="bottom" align="left">'+coautor+'</td>';
			result += '<td align="center"><a style="padding:0" class="btn" title="Eliminar" onclick="fnDelElement(this)"><i class="fa fa-times fa-sm"></i></a></td><input type="hidden" name="TCoautorList" value="'+coautor+'"/></tr>';

			$(".detailSelect").append(result);

			if(!$('.detailCoautor').is(':visible'))
				$('.detailCoautor').delay(200).fadeIn(800);  

			$('input[name=RHPCoautores]').val('');
		}	
	}

	function fnDelElement(e){
		if($('.detailSelect tr').length == 1){
			$(e).parent().parent().remove();
			$('.detailCoautor').hide(); 
		}
		else
			$(e).parent().parent().remove();
	}

	function fnShowTooltip(e){
		$('#'+e).tooltip('show');
	}

</script>