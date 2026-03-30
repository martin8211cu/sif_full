
<style type="text/css">
	.alert { position: fixed; top: 30%; right: 21%; display:none; width: 330px !important; }
</style>


<!----- Etiquetas de traduccion------>
<cfset LB_TipoDeFormato = t.translate('LB_TipoDeFormato','Tipo de Formato','/rh/generales.xml')>
<cfset LB_Consulta = t.translate('LB_Consulta','Consulta','/rh/generales.xml')>
<cfset LB_CertificacionesRH = t.translate('LB_CertificacionesRH','Certificaciones RH','/rh/generales.xml')>
<cfset LB_FormatosDeCorreos = t.translate('LB_FormatosDeCorreos','Formatos de correos','/rh/generales.xml')>
<cfset LB_Uso = t.translate('LB_Uso','Uso','/rh/generales.xml')>
<cfset LB_SeleccioneTipoUso = t.translate('LB_SeleccioneTipoUso','Seleccione el tipo Uso','/rh/generales.xml')>

<cfset MSG_Nota = t.translate('MSG_Nota','Nota')>
<cfset MSG_RequeridosFormatoRH = t.translate('MSG_RequeridosFormatoRH','Para agregar el formato se debe seleccionar los siguientes valores')>


<cfif isdefined("Form.Cambio")>
  <cfset modo="CAMBIO">
  <cfelse>
  <cfif not isdefined("Form.modo")>
    <cfset modo="ALTA">
    <cfelseif Form.modo EQ "CAMBIO">
    <cfset modo="CAMBIO">
    <cfelse>
    <cfset modo="ALTA">
  </cfif>
</cfif>

<cfif isdefined("Form.PFid") and Len(Trim(Form.PFid)) NEQ 0>
	<cfset modoDet = "CAMBIO">
<cfelse>
	<cfset modoDet = "ALTA">
</cfif>

<cfif modo neq "ALTA">
    <cfquery name="rsTipoFormato" datasource="#Session.DSN#">
		select TFid, TFdescripcion, TFsql, TFcfm, ts_rversion, TFUso
		from TFormatos 
		where TFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TFid#">
    </cfquery>
  
    <cfquery name="rsParamsList" datasource="#Session.DSN#">
	  	select PFid, TFid, PFcampo, PFtipodato, 
	  	case PFtipodato when 1 then 'varchar' when 2 then 'integer' when 3 then 'datetime' when 4 then 'money' when 5 then 'numeric' when 6 then 'float' else '' end as TipoDato
		from PFormato
		where TFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TFid#">
	</cfquery>
</cfif>


<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
		    <td width="40%" valign="top">
				<cfinvoke 
				 component="sif.Componentes.pListas"
				 method="pListaRH"
				 returnvariable="pListaFormatosTipo">
					<cfinvokeargument name="tabla" value="TFormatos a"/>
					<cfinvokeargument name="columnas" value="TFid, a.TFdescripcion, a.TFsql"/>
					<cfinvokeargument name="desplegar" value="TFid, TFdescripcion"/>
					<cfinvokeargument name="etiquetas" value="Codigo, Tipo de Formato"/>
					<cfinvokeargument name="formatos" value="V, V"/>
					<cfinvokeargument name="filtro" value=" 1 = 1 and Ecodigo=#Session.Ecodigo# order by a.TFid, TFdescripcion"/>
					<cfinvokeargument name="align" value="center, left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
					<cfinvokeargument name="keys" value="TFid"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="formName" value="listaTipos"/>
				</cfinvoke>
			</td>
		    <td align="center">
				<form name="formTipoFormato" action="SQLFormatosTipos.cfm" method="post" style="margin: 0">
					<cfif modo NEQ 'ALTA'>
						<input type="hidden" name="TFid" value="#rsTipoFormato.TFid#">
						<cfset ts = "">
						<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts">
							<cfinvokeargument name="arTimeStamp" value="#rsTipoFormato.ts_rversion#"/>
						</cfinvoke>
						<input type="hidden" name="ts" value="#ts#">
					</cfif>
					<table width="95%" border="0" cellspacing="0" cellpadding="2">
						<tr>
							<td nowrap><strong>#LB_TipoDeFormato#: </strong></td>
							<td>
								<input name="TFdescripcion" type="text" id="TFdescripcion" size="40" maxlength="80" value="<cfif modo NEQ 'ALTA'>#rsTipoFormato.TFdescripcion#</cfif>">
							</td>
					    </tr>
					    <tr>
					    	<td><strong>#LB_Consulta#: </strong></td>
						  	<td valign="top" >
						  		<input name="TFcfm" onBlur="pagina(this)" type="text" id="TFcfm" tabindex="1" onFocus="this.select();" value="<cfif modo neq 'ALTA'>#trim(rsTipoFormato.TFcfm)#</cfif>" size="60" maxlength="255" >
		                    	<a href="javascript:conlisFiles()"><img src="/cfmx/sif/importar/foldericon.gif" width="16" height="16" border="0"></a>
		                    </td>
						</tr>
						<tr>
							<td><strong>#LB_Uso#: </strong></td>
							<td>
								<select name="TFUso">
									<option value="">#LB_SeleccioneTipoUso#</option>
									<option value="1" <cfif modo neq 'ALTA' and rsTipoFormato.TFUso EQ 1>selected</cfif>>#LB_CertificacionesRH#</option>
									<option value="2" <cfif modo neq 'ALTA' and rsTipoFormato.TFUso EQ 2>selected</cfif>>#LB_FormatosDeCorreos#</option>
								</select>
							</td>
						</tr>	
						<tr>
							<td><strong>SQL: </strong></td>
							<td valign="top" >
								<textarea name="TFsql" onBlur="pagina(this)" id="TFsql"  cols="90" rows="18"><cfif modo neq 'ALTA'>#trim(rsTipoFormato.TFsql)#</cfif></textarea>
							</td>
						</tr>
						<tr>
							<td></td>
							<td>
								<cf_translate key="AYUDA_AyudaParaFormatos">
									La consulta para generaci&oacute;n de certificaciones debe ser definida en un archivo cfm y de tal forma que funcione correctamente para bases de datos Sybase, Oracle y Sql Server. Adem&aacute;s puede utilizar las siguientes variables <strong>predefinidas</strong>:
									<ul style="margin-top:0;" >
							  			<li>rsData.DEidentificacion( variable string de coldfusion con identificaci&oacute;n del empleado ) </li>
										<li>rsData.Fecha (objeto date de coldfusion que correponde a la fecha seleccionada para la generaci&oacute;n ) </li>
									</ul>
								</cf_translate>	
							</td>
						</tr>
					    <tr>
					    	<td colspan="2" align="center"><cfinclude template="../portlets/pBotones.cfm"></td>
				        </tr>
					    <tr><td colspan="2">&nbsp;</td></tr>
					</table>
					<input type="hidden" class="btnAccion" value="" name="btnAccion"></input>
				</form>
			</td>	
		</tr>
		<cfif modo NEQ 'ALTA'>
			<cfif modoDet EQ "CAMBIO">
				<cfquery name="rsParam" datasource="#Session.DSN#">
					select <cf_dbfunction name="to_char" args="PFid"> as PFid, PFcampo, PFtipodato
					from PFormato
					where PFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PFid#">
				</cfquery>
			</cfif>
			<tr>
				<td>&nbsp;</td>
				<td align="center" style="padding-left: 10px; padding-right: 10px;">
					<cf_web_portlet titulo="Lista de Parámetros">
					<form name="formParametros" action="SQLParametros.cfm" method="post" style="margin: 0">
						<cfif modo NEQ 'ALTA'>
							<input type="hidden" name="TFid" value="#rsTipoFormato.TFid#">
						</cfif>
						<input type="hidden" name="PFid" value="<cfif modoDet EQ 'CAMBIO'>#Form.PFid#</cfif>">
						<table width="100%" cellpadding="0" cellspacing="0" border="0" style="padding-left: 10px; padding-right: 10px;">
							<tr>
								<td colspan="3">&nbsp;</td>
							</tr>
							<tr>
								<td><strong>Nombre</strong></td>
								<td><strong>Tipo</strong></td>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td>
									<input name="PFcampo" type="text" id="PFcampo" value="<cfif  modoDet EQ 'CAMBIO'>#rsParam.PFcampo#</cfif>">
								</td>
								<td>
									<select name="PFtipodato" id="PFtipodato">
										<option value="1" <cfif modoDet EQ 'CAMBIO' and rsParam.PFtipodato EQ 1>selected</cfif>>varchar</option>
										<option value="2" <cfif modoDet EQ 'CAMBIO' and rsParam.PFtipodato EQ 2>selected</cfif>>integer</option>
										<option value="3" <cfif modoDet EQ 'CAMBIO' and rsParam.PFtipodato EQ 3>selected</cfif>>datetime</option>
										<option value="4" <cfif modoDet EQ 'CAMBIO' and rsParam.PFtipodato EQ 4>selected</cfif>>money</option>
										<option value="5" <cfif modoDet EQ 'CAMBIO' and rsParam.PFtipodato EQ 5>selected</cfif>>numeric</option>
										<option value="6" <cfif modoDet EQ 'CAMBIO' and rsParam.PFtipodato EQ 6>selected</cfif>>float</option>
									</select>
								</td>
								<td align="center">
									<input name="btnSubmit" type="submit" id="btnSubmit" value="Agregar">
									<input name="btnLimpiar" type="button" id="btnLimpiar" value="Limpiar" onClick="javascript: Limpiar();">
								</td>
						    </tr>
							<tr>
							    <td colspan="3">&nbsp;</td>
						    </tr>
						</table>
					</form>
					<table width="90%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td>
								<table cellpadding="0" cellspacing="0" border="0" width="100%">
									<cfloop query="rsParamsList"> 
										<tr <cfif CurrentRow MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>> 
											<td nowrap><a href="javascript: CargarDetalle(#PFid#, '#PFcampo#', '#PFtipodato#');">#PFcampo#</a></td>
											<td nowrap><a href="javascript: CargarDetalle(#PFid#, '#PFcampo#', '#PFtipodato#');">#TipoDato#</a></td>
											<td nowrap>	
												<input name="btnBorrar" type="image" alt="Eliminar parámetro" onClick="javascript: return Borrar(#PFid#)" src="../imagenes/Borrar01_T.gif" width="16" height="16">
											</td>
										</tr>
									</cfloop>
									<tr><td colspan="3">&nbsp;</td></tr>
								</table>
							</td>
						</tr>
					</table>
					</cf_web_portlet>
				</td>
		    </tr>
	    </cfif>
	    <tr><td colspan="2">&nbsp;</td></tr>
	    <div class="alert alert-danger alert-dismissable">
			<a onclick="fnHideMessage()" class="close" aria-hidden="true">&times;</a>
		    <span></span>
		</div>
	</table>
</cfoutput>


<script type="text/javascript">
	$(document).ready(function(){
		$('.btnGuardar').click(function(e){
			e.preventDefault();
			fnValidarAdd();
		});
	});	

	function fnValidarAdd(){
		if(fnValidar()){
			$('.btnAccion').attr('name',$('.btnGuardar').prop('name')).attr('value',$('.btnGuardar').prop('value'));
			$('form[name=formTipoFormato]').submit();
		}	
	}

	function fnValidar(){
		var result = true;
		var mensaje = '<strong>¡<cfoutput>#MSG_Nota#</cfoutput>!</strong> <cfoutput>#MSG_RequeridosFormatoRH#</cfoutput>:<br/><br/>';

		if($("input[name=TFdescripcion]").val().trim() == ''){
			mensaje += '-> <cfoutput>#LB_TipoDeFormato#</cfoutput><br/>';
			result = false;
		}	

		if($("input[name=TFcfm]").val().trim() == '' && $("textarea[name=TFsql]").val().trim() == ''){ 
			mensaje += '-> <cfoutput>#LB_Consulta# / SQL </cfoutput><br/>';
			result = false;
		}	

		if($('select[name=TFUso]').val() == ''){
			mensaje += '-> <cfoutput>#LB_Uso#</cfoutput><br/>';
			result = false;
		}	

		if(!result){
			$('.alert span').html(mensaje);
			fnShowMessage();
		}

		return result;
	}

	function fnShowMessage(){	
		if($('.alert').is(':visible'))
			$('.alert').delay(200).fadeOut(500); 
		$('.alert').delay(200).fadeIn(200); 
	}

	function fnHideMessage(){
		$('.alert').delay(200).fadeOut(500);  	
	}


	function Limpiar() {
		document.formParametros.btnSubmit.value = 'Agregar';
		document.formParametros.PFid.value = '';
		document.formParametros.PFcampo.value = '';
	}

	function CargarDetalle(id, campo, tipo) {
		document.formParametros.PFid.value = id;
		document.formParametros.PFcampo.value = campo;
		document.formParametros.btnSubmit.value = 'Modificar';
		for (var i = 0; i < document.formParametros.PFtipodato.length; i++) {
			if (document.formParametros.PFtipodato.options[i].value == tipo) {
				document.formParametros.PFtipodato.selectedIndex = i;
				break;
			}
		}
	}

	function Borrar (linea){
		if (confirm('¿Realmente desea eliminar el parámetro?')) {
			document.formParametros.PFid.value = linea;
			document.formParametros.btnSubmit.value = 'Borrar';
			document.formParametros.btnSubmit.click();
		}
	}
	
	function trim(dato) {
		return dato.replace(/^\s*|\s*$/g,"");
	}

	function conlisFilesSelect(filename){
		document.formTipoFormato.TFcfm.value = filename;
		closePopup();
		window.focus();
		document.formTipoFormato.TFcfm.focus();
	}

	function pagina(obj){
		obj.value = obj.value.
				replace(/\\/g, '/').
				replace(/^https?:\/\/([A-Za-z0-9._]+)(:[0-9]{1,5})?/,'').
				replace(/^\/cfmx/, '').
				replace(/^[A-Za-z]:/,'');
		if (trim(obj.value) != '' && obj.value.charAt(0) != '/') {
			obj.value = "/" + obj.value;
		}
	}
	
	
	function closePopup() {
		if (window.gPopupWindow != null && !window.gPopupWindow.closed ) {
			window.gPopupWindow.close();
			window.gPopupWindow = null;
		}
	}

	function conlisFiles(){
		closePopup();
		window.gPopupWindow = window.open('/cfmx/sif/importar/files.cfm?c=1&p='+escape(document.formTipoFormato.TFcfm.value),'_blank',
			'left=50,top=50,width=300,height=400,status=no,toolbar=no,title=no');
		window.onfocus = closePopup;
	}
</script>