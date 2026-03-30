<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
<script language="javascript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
<script language="javascript" src="/cfmx/sif/js/qForms/qforms.js" type="text/javascript"></script>

<!---
<script language="javascript" type="text/javascript">
	// Qforms. especifica la ruta donde el directorio "/qforms/" está localizado
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// Qforms. carga todas las librerías por defecto
	qFormAPI.include("*");
	//-->
</script>
--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DatosVariables"
	Default="Datos Variables"
	returnvariable="LB_DatosVariables"/>

<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_DatosVariables#'>
<!--- establecimiento de los modos (ENC y DET)--->	
	<cfset modo  = 'ALTA'>
	<cfset dmodo = 'ALTA'>
	<cfif isdefined("form.RHEDVid") and len(trim(form.RHEDVid))>
		<cfset modo = 'CAMBIO'>
	</cfif>
	<cfif isdefined("form.RHDDVlinea") and len(trim(form.RHDDVlinea)) and isdefined("form.RHEDVid") and len(trim(form.RHEDVid))>
		<cfset dmodo = 'CAMBIO'>
	</cfif>


<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>              	
	<form action="SQLDatosVariables.cfm" method = "post" name = "form1" onSubmit="return valida();">
		<tr>
			<td>
			
				<table width="99%" cellpadding="0" cellspacing="0" align="center">
					<tr><td class="subTitulo" align="center"><font size="2"><cf_translate key="LB_EncabezadoDatosVariables">Encabezado Datos Variables</cf_translate></font></td>
					</tr><tr><td align="center"><cfinclude template="DatosVariablesE.cfm"></td></tr>					
					<cfif modo neq "ALTA">
						<tr><td class="subTitulo" align="center"><font size="2"><cf_translate key="LB_DetalleDatosVariables">Detalle Datos Variables</cf_translate></font></td></tr>												
						<tr><td align="center"><cfinclude template="DatosVariablesD.cfm"></td></tr>
					</cfif>									
					<!---<tr><td >&nbsp;</td></tr>--->
					<!-- Caso 1: Alta de Encabezados -->
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Agregar"
						Default="Agregar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Agregar"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Limpiar"
						Default="Limpiar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Limpiar"/>
					<cfif modo EQ 'ALTA'>
					<tr>
						<td align="center">
							<cfoutput>
							<input type="submit" class="btnGuardar" name="btnAgregarE" value="#BTN_Agregar#" tabindex="1" >
							<input type="reset"  class="btnLimpiar" name="btnLimpiar"  value="#BTN_Limpiar#" tabindex="1" >
							</cfoutput>
						</td>	
					</tr>
					</cfif>	
					
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_BorrarDatoVariable"
						Default="Borrar Dato Variable"
						returnvariable="BTN_BorrarDatoVariable"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_DeseaEliminarElDatoVariable"
						Default="Desea eliminar el Dato Variable"
						returnvariable="MSG_DeseaEliminarElDatoVariable"/>
					<!-- Caso 2: Cambio de Encabezados / Alta de detalles -->
					<cfif modo neq 'ALTA' and dmodo eq 'ALTA' >
					<tr>						
						<td align="center" valign="baseline" colspan="8">						
							<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_ModificarEncabezado"
								Default="Modificar Encabezado"
								returnvariable="BTN_ModificarEncabezado"/>
							<cfoutput>
							<input type="submit" class="btnGuardar" name="btnModificarEnc"   value="#BTN_ModificarEncabezado#" tabindex="1" onClick="javascript: ModificaEncabezado = 'btnModificarEnc'">
							<input type="submit" class="btnGuardar" name="btnAgregarD"  value="#BTN_Agregar#" tabindex="1">
							<input type="submit" class="btnEliminar" name="btnBorrarE"  tabindex="1"  value="#BTN_BorrarDatoVariable#" 
								onClick="javascript:if ( confirm('#MSG_DeseaEliminarElDatoVariable#?') ){validar=false; return true;} return false;" >
							<input type="reset" class="btnLimpiar"  name="btnLimpiar"   value="#BTN_Limpiar#" tabindex="1" >						
							</cfoutput>
						</td>
					</tr>
					</cfif>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Modificar"
						Default="Modificar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Modificar"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_BorrarLinea"
						Default="Borrar L&iacute;nea"
						returnvariable="BTN_BorrarLinea"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_NuevaLinea"
						Default="Nueva L&iacute;nea"
						returnvariable="BTN_NuevaLinea"/>

					<!-- Caso 3: Cambio de Encabezados / Cambio de detalle -->		
					<cfif modo neq 'ALTA' and dmodo neq 'ALTA' >
					<tr>
						<td align="center" valign="baseline" colspan="8">
							<cfoutput>
								<input type="submit" class="btnGuardar" name="btnCambiarD" value="#BTN_Modificar#" tabindex="1">
								<input type="submit" class="btnEliminar"  name="btnBorrarD"  tabindex="1" value="#BTN_BorrarLinea#" 
									onClick="javascript:if ( confirm('Desea eliminar el valor del detalle?') ){validar=false; return true;} return false;" >
								<input type="submit" name="btnBorrarE" class="btnEliminar"   tabindex="1" value="#BTN_BorrarDatoVariable#" 
									onClick="javascript:if ( confirm('#MSG_DeseaEliminarElDatoVariable#?') ){validar=false; return true;} return false;" >
								<input type="submit" class="btnNuevo"  name="btnNuevoD"   tabindex="1" value="#BTN_NuevaLinea#" 
									onClick="javascript:validar=false;" >
								<input type="reset" class="btnLimpiar"   name="btnLimpiar"  tabindex="1" value="#BTN_Limpiar#" >
							</cfoutput>
						</td>
					</tr>
					</cfif>
					</form>
					<!-- ============================================================================================================ -->
					<!-- ============================================================================================================ -->		
					<tr><td>&nbsp;</td></tr>
					<cfif modo NEQ 'ALTA'>
						<tr>
							<td>
								<cfquery name="rsDetalleLista" datasource="#Session.DSN#">
									select 	a.RHEDVid,
											a.RHDDVlinea,
											a.RHDDVcodigo,
											a.RHDDVdescripcion,
											a.RHDDVvalor,
											a.RHDDVorden
									from 	RHDDatosVariables a
									where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										 and a.RHEDVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEDVid#">
								</cfquery>
								<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="LB_Codigo"
									Default="C&oacute;digo"
									XmlFile="/rh/generales.xml"
									returnvariable="LB_Codigo"/>
								<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="LB_Descripcion"
									Default="Descripci&oacute;n"
									XmlFile="/rh/generales.xml"
									returnvariable="LB_Descripcion"/>
								
								<cfinvoke 
									component="rh.Componentes.pListas"
									method="pListaQuery"
									returnvariable="pListaRet">
									<cfinvokeargument name="query" value="#rsDetalleLista#"/>
									<cfinvokeargument name="desplegar" value="RHDDVcodigo,RHDDVdescripcion"/>
									<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#"/>
									<cfinvokeargument name="formatos" value="V,V"/>
									<cfinvokeargument name="align" value="left,left"/>
									<cfinvokeargument name="ajustar" value="N"/>
									<cfinvokeargument name="irA" value="DatosVariables.cfm"/>
									<cfinvokeargument name="showEmptyListMsg" value="true"/>
									<cfinvokeargument name="keys" value="RHEDVid,RHDDVlinea"/>
								</cfinvoke>
							</td>
						</tr>
					</cfif>
				</table>	
			</td>
		</tr>
</table>
<!----*************************************************************--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_SePresentaronLosSiguientesErrores"
	Default="Se presentaron los siguientes errores"
	returnvariable="MSG_SePresentaronLosSiguientesErrores"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCampoCodigoEsrequerido"
	Default="El campo Código es requerido"
	returnvariable="MSG_ElCampoCodigoEsrequerido"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCampoDescripcionEsrequerido"
	Default="El campo Descripción es requerido"
	returnvariable="MSG_ElCampoDescripcionEsrequerido"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCampoCodigoDelDetalleEsRequerido"
	Default="El campo Código del detalle es requerido"
	returnvariable="MSG_ElCampoCodigoDelDetalleEsRequerido"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCampoDescripcionDelDetalleEsRequerido"
	Default="El campo Descripción del detalle es requerido"
	returnvariable="MSG_ElCampoDescripcionDelDetalleEsRequerido"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCampoDescripcionDetalladaEsRequerido"
	Default="El campo Descripción detallada es requerido"
	returnvariable="MSG_ElCampoDescripcionDelDetalleEsRequerido2"/>


<script language="JavaScript1.2" type="text/javascript">
	var validar = true;
	var ModificaEncabezado ='';
	function valida(){
		if (validar){
			var error = false;
			var mensaje = "<cfoutput>#MSG_SePresentaronLosSiguientesErrores#</cfoutput>:\n";
			// Validacion de Encabezado	
			if ( trim(document.form1.RHEDVcodigo.value) == '' ){
				error = true;
				mensaje += " - <cfoutput>#MSG_ElCampoCodigoEsrequerido#</cfoutput>.\n";
			}
	
			if ( trim(document.form1.RHEDVdescripcion.value) == '' ){
				error = true;
				mensaje += " - <cfoutput>#MSG_ElCampoDescripcionEsrequerido#</cfoutput>.\n";
			}
			<cfif modo NEQ 'ALTA'>
				 if (ModificaEncabezado !== 'btnModificarEnc'){
					if ( trim(document.form1.RHDDVcodigo.value) == '' ){
						error = true;
						mensaje += " - <cfoutput>#MSG_ElCampoCodigoDelDetalleEsRequerido#</cfoutput>.\n";
					}
					
					if ( trim(document.form1.RHDDVdescripcion.value) == '' ){
						error = true;
						mensaje += " - <cfoutput>#MSG_ElCampoDescripcionDelDetalleEsRequerido#</cfoutput>.\n";
					}

					if ( trim(document.form1.RHDDVvalor.value) == '' ){
						error = true;
						mensaje += " - <cfoutput>#MSG_ElCampoDescripcionDelDetalleEsRequerido2#</cfoutput>.\n";
					}

				}	
			</cfif>
			if ( error ){
				alert(mensaje);
				return false;
			}
			
	else{
		return true;
			}
	}
	}
</script>
<!---- ***********************    Edición de texto  ************************* ------>		
<script language="Javascript1.2">
	<!-- // load htmlarea
	_editor_url = "/rh/Utiles/htmlarea/";  // URL to htmlarea files
	var win_ie_ver = parseFloat(navigator.appVersion.split("MSIE")[1]);
	if (navigator.userAgent.indexOf('Mac')        >= 0) { win_ie_ver = 0; }
	if (navigator.userAgent.indexOf('Windows CE') >= 0) { win_ie_ver = 0; }
	if (navigator.userAgent.indexOf('Opera')      >= 0) { win_ie_ver = 0; }
	if (win_ie_ver >= 5.5) {
	  document.write('<scr' + 'ipt src="' +_editor_url+ 'editor.js"');
	  document.write(' language="Javascript1.2"></scr' + 'ipt>');  
	} else { document.write('<scr'+'ipt>function editor_generate() { return false; }</scr'+'ipt>'); }
	// --> 
</script>


<script language="javascript1.2">
	var config = new Object();    // create new config object	
	config.width = "680px";
	config.height = "75px";
	config.bodyStyle = 'background-color: white; font-family: "Verdana"; font-size: x-small;';
	config.debug = 0;

	// NOTE:  You can remove any of these blocks and use the default config!
	config.toolbar = [
		['fontname'],
		['fontsize'],
		['fontstyle'],
		['linebreak'],
		['bold','italic','underline','separator'],
	//  ['strikethrough','subscript','superscript','separator'],
		['justifyleft','justifycenter','justifyright','separator'],
		['OrderedList','UnOrderedList','Outdent','Indent','separator'],
		['forecolor','backcolor','separator'],
		['HorizontalRule','Createlink','InsertImage','InsertTable','htmlmode'],
	//	['about','help','popupeditor'],
	];

	config.fontnames = {
		"Arial":           "arial, helvetica, sans-serif",
		"Courier New":     "courier new, courier, mono",
		"Georgia":         "Georgia, Times New Roman, Times, Serif",
		"Tahoma":          "Tahoma, Arial, Helvetica, sans-serif",
		"Times New Roman": "times new roman, times, serif",
		"Verdana":         "Verdana, Arial, Helvetica, sans-serif",
		"impact":          "impact",
		"WingDings":       "WingDings"
	};
	config.fontsizes = {
		"1 (8 pt)":  "1",
		"2 (10 pt)": "2",
		"3 (12 pt)": "3",
		"4 (14 pt)": "4",
		"5 (18 pt)": "5",
		"6 (24 pt)": "6",
		"7 (36 pt)": "7"
	  };


	//config.stylesheet = "http://www.domain.com/sample.css";
	config.fontstyles = [   // make sure classNames are defined in the page the content is being display as well in or they won't work!
	  { name: "headline",     className: "headline",  classStyle: "font-family: arial black, arial; font-size: 28px; letter-spacing: -2px;" },
	  { name: "arial red",    className: "headline2", classStyle: "font-family: arial black, arial; font-size: 12px; letter-spacing: -2px; color:red" },
	  { name: "verdana blue", className: "headline4", classStyle: "font-family: verdana; font-size: 18px; letter-spacing: -2px; color:blue" }
	// leave classStyle blank if it's defined in config.stylesheet (above), like this:
	//  { name: "verdana blue", className: "headline4", classStyle: "" }  
	];				

	editor_generate('RHEDVdescripcion', config);
	<cfif modo neq 'ALTA'> // Genera la barra para el text area solamente cuando se esta en modo alta del detalle/modo cambio encabezado
		editor_generate('RHDDVvalor', config);
	</cfif>
</script>
		<cf_web_portlet_end>
<cf_templatefooter>	