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
 <cfquery name="rsForm" datasource="#session.DSN#">
	select 	CRPohabilidad, 	CRPoconocim, 	CRPomision, 	CRPoobj,CRPoespecif, CRPoencab, CRPoubicacion, CRPepie,
			CRPehabilidad, 	CRPeconocim, 	CRPemision, 	CRPeobjetivo,	CRPeespecif, CRPeencab, CRPeubicacion, CRPeini, 
			 CRPoPuntajes,		coalesce(CRPiPuntajes,0) as CRPiPuntajes,CRPePuntajes,
		 	coalesce(CRPihabilidad,0) as CRPihabilidad, 	
			coalesce(CRPiconocimi,0) as CRPiconocimi, 	
			coalesce(CRPimision,0) as CRPimision, 	
			coalesce(CRPiobj,0) as CRPiobj, 	
			coalesce(CRPiespecif,0) as CRPiespecif, 	
			coalesce(CRPiencab,0) as CRPiencab, 	
			coalesce(CRPiubicacion ,0) as CRPiubicacion,
			coalesce(CRPipie ,0) as CRPipie ,
			CRPoHAY,coalesce(CRPiHAY ,0) as CRPiHAY,CRPeHAY
	from RHConfigReportePuestos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<script language="javascript1.4" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript1.4" type="text/javascript">
 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>

<form name="form1" method="post" action="SQLPuestosConfig.cfm">
<cfoutput>
<table width="98%"  border="0" cellspacing="0" cellpadding="0" align="center">
  	<tr><td colspan="6">&nbsp;</td></tr>
  	<tr>
		<td>&nbsp;</td>
		<td colspan="4" nowrap align="center"><strong><cf_translate key="LB_ConfiguracionDelReporteDePuestos">Configuraci&oacute;n del Reporte de Puestos</cf_translate> </strong></td>
		<td>&nbsp;</td>
	</tr>
 	<tr><td colspan="6">&nbsp;</td></tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="10%" nowrap>&nbsp;</td>
		<td width="10%" nowrap align="center"><strong><cf_translate key="LB_Orden">Orden</cf_translate></strong></td>
		<td width="10%" nowrap align="center"><strong><cf_translate key="LB_Impresion">Impresi&oacute;n</cf_translate></strong></td>
		<td width="60%" nowrap><strong><cf_translate key="LB_Etiqueta">Etiqueta</cf_translate></strong></td>
		<td width="5%">&nbsp;</td>
    </tr>
  	<tr>
		<td>&nbsp;</td>
		<td nowrap align="right"><cf_translate key="LB_Inicial">Inicial</cf_translate> : </td>
		<td nowrap><p align="center">1</p></td>
		<td nowrap><p align="center"><img src="/cfmx/rh/imagenes/checked.gif"></p></td>
		<td nowrap><input name="eini" type="text" id="eini" tabindex="1" value="<cfif rsForm.RecordCount gt 0>#rsForm.CRPeini#<cfelse>Identificaci&oacute;n del Puesto</cfif>" size="120" maxlength="120"></td>
		<td>&nbsp;</td>
    </tr>
  	<tr>
		<td>&nbsp;</td>
		<td nowrap align="right"><cf_translate key="LB_Mision">Misi&oacute;n</cf_translate> :</td>
		<td nowrap><p align="center">
			  <input name="omision" type="text" id="omision" tabindex="1" value="<cfif rsForm.RecordCount gt 0>#rsForm.CRPomision#<cfelse>2</cfif>" size="4" maxlength="1">
		  </p></td>
		<td nowrap align="center"><input type="checkbox" id="imision" tabindex="1" name="imision" <cfif rsForm.RecordCount gt 0><cfif rsForm.CRPimision>checked</cfif><cfelse>1</cfif>></td>
		<td nowrap><input name="emision" type="text" id="emision" tabindex="1" value="<cfif rsForm.RecordCount gt 0>#rsForm.CRPemision#<cfelse>Misi&oacute;n</cfif>" size="120" maxlength="120"></td>
		<td>&nbsp;</td>
    </tr>
  	<tr>
		<td>&nbsp;</td>
		<td nowrap align="right"><cf_translate key="LB_Responsabilidades">Responsabilidades</cf_translate> :</td>
		<td nowrap><p align="center">
			  <input name="oobj" type="text" id="oobj" tabindex="1" value="<cfif rsForm.RecordCount gt 0>#rsForm.CRPoobj#<cfelse>3</cfif>" size="4" maxlength="1">
		  </p></td>
		<td nowrap align="center"><input type="checkbox" id="iobj" tabindex="1" name="iobj" <cfif rsForm.RecordCount gt 0><cfif rsForm.CRPiobj>checked</cfif><cfelse>1</cfif>></td>
		<td nowrap><input name="eobj" type="text" id="eobj" tabindex="1" value="<cfif rsForm.RecordCount gt 0>#rsForm.CRPeobjetivo#<cfelse>Responsabilidades por proceso</cfif>" size="120" maxlength="120"></td>
		<td>&nbsp;</td>
    </tr>
	<tr>
		<td>&nbsp;</td>
		<td nowrap align="right"><cf_translate key="LB_DatosVariables">Datos Variables</cf_translate> :</td>
		<td nowrap><p align="center">
			  <input name="oespecif" type="text" id="oespecif" tabindex="1" value="<cfif rsForm.RecordCount gt 0>#rsForm.CRPoespecif#<cfelse>4</cfif>" size="4" maxlength="1">
		  </p></td>
		<td nowrap align="center"><input type="checkbox" id="iespecif" tabindex="1" name="iespecif" <cfif rsForm.RecordCount gt 0><cfif rsForm.CRPiespecif>checked</cfif><cfelse>1</cfif>></td>
		<td nowrap><input name="eespecif" type="text" id="eespecif" tabindex="1" value="<cfif rsForm.RecordCount gt 0>#rsForm.CRPeespecif#<cfelse>Especificaciones del puesto</cfif>" size="120" maxlength="120"></td>
		<td>&nbsp;</td>
    </tr>
  	<tr>
		<td>&nbsp;</td>
		<td nowrap align="right"><cf_translate key="LB_Perfil">Perfil</cf_translate> :</td>
		<td nowrap><p align="center">
			  <input name="oencab" type="text" id="oencab" tabindex="1" value="<cfif rsForm.RecordCount gt 0>#rsForm.CRPoencab#<cfelse>5</cfif>" size="4" maxlength="1">
		  </p></td>
		<td nowrap align="center"><input type="checkbox" tabindex="1" id="iencab" name="iencab" <cfif rsForm.RecordCount gt 0><cfif rsForm.CRPiencab>checked</cfif><cfelse>1</cfif>></td>
		<td nowrap><input name="eencab" type="text" tabindex="1" id="eencab" value="<cfif rsForm.RecordCount gt 0>#rsForm.CRPeencab#<cfelse>Perfil del puesto</cfif>" size="120" maxlength="120"></td>
		<td>&nbsp;</td>
    </tr>
 	<tr>
		<td>&nbsp;</td>
		<td nowrap align="right"><cf_translate key="LB_Habiliades">Habilidades</cf_translate> :</td>
		<td nowrap><p align="center">
			  <input name="ohabilidad" type="text" id="ohabilidad" tabindex="1" value="<cfif rsForm.RecordCount gt 0>#rsForm.CRPohabilidad#<cfelse>6</cfif>" size="4" maxlength="1">
		  </p></td>
		<td nowrap align="center"><input type="checkbox" tabindex="1" id="ihabilidad" name="ihabilidad" <cfif rsForm.RecordCount gt 0><cfif rsForm.CRPihabilidad>checked</cfif><cfelse>1</cfif>></td>
		<td nowrap><input name="ehabilidad" type="text" tabindex="1" id="ehabilidad" value="<cfif rsForm.RecordCount gt 0>#rsForm.CRPehabilidad#<cfelse>Habilidades requeridas por el puesto</cfif>" size="120" maxlength="120"></td>
		<td>&nbsp;</td>
    </tr>
  	<tr>
		<td>&nbsp;</td>
		<td nowrap align="right"><cf_translate key="LB_Conocimientos">Conocimientos</cf_translate> :</td>
		<td nowrap><p align="center">
			  <input name="oconocim" type="text" id="oconocim" tabindex="1" value="<cfif rsForm.RecordCount gt 0>#rsForm.CRPoconocim#<cfelse>7</cfif>" size="4" maxlength="1">
		  </p></td>
		<td nowrap align="center"><input type="checkbox" id="iconocimi" name="iconocimi" tabindex="1" <cfif rsForm.RecordCount gt 0><cfif rsForm.CRPiconocimi>checked</cfif><cfelse>1</cfif>></td>
		<td nowrap><input name="econocim" type="text" id="econocim" tabindex="1" value="<cfif rsForm.RecordCount gt 0>#rsForm.CRPeconocim#<cfelse>Conocimientos requeridos por el puesto</cfif>" size="120" maxlength="120"></td>
		<td>&nbsp;</td>
  	</tr>
  	<tr>
		<td>&nbsp;</td>
		<td nowrap align="right"><cf_translate key="LB_Ubicacion">Ubicaci&oacute;n</cf_translate> :</td>
		<td nowrap><p align="center">
			  <input name="oubicacion" type="text" id="oubicacion" tabindex="1" value="<cfif rsForm.RecordCount gt 0>#rsForm.CRPoubicacion#<cfelse>7</cfif>" size="4" maxlength="1">
		  </p></td>
		<td nowrap align="center"><input type="checkbox" id="iubicacion" tabindex="1" name="iubicacion" <cfif rsForm.RecordCount gt 0><cfif rsForm.CRPiubicacion>checked</cfif><cfelse>1</cfif>></td>
		<td nowrap><input name="eubicacion" type="text" id="eubicacion" tabindex="1" value="<cfif rsForm.RecordCount gt 0>#rsForm.CRPeubicacion#<cfelse>Ubicaci&oacute;n</cfif>" size="120" maxlength="120"></td>
		<td>&nbsp;</td>
  	</tr>
	<tr>
		<td>&nbsp;</td>
		<td nowrap align="right"><cf_translate key="LB_PuntosHAY"> Puntos HAY</cf_translate> :</td>
		<td nowrap><p align="center">
			  <input name="CRPoHAY" type="text" id="CRPoHAY" tabindex="1" value="<cfif rsForm.RecordCount gt 0>#rsForm.CRPoHAY#<cfelse></cfif>" size="4" maxlength="1">
		  </p></td>
		<td nowrap align="center"><input type="checkbox" id="CRPiHAY" tabindex="1" name="CRPiHAY" <cfif rsForm.RecordCount gt 0><cfif rsForm.CRPiHAY>checked</cfif><cfelse>1</cfif>></td>
		<td nowrap><input name="CRPeHAY" type="text" id="CRPeHAY" tabindex="1" value="<cfif rsForm.RecordCount gt 0>#rsForm.CRPeHAY#<cfelse>HAY</cfif>" size="120" maxlength="120"></td>
		<td>&nbsp;</td>
  	</tr>
	<tr>
		<td>&nbsp;</td>
		<td nowrap align="right"><cf_translate key="LB_Puntajes">Puntajes</cf_translate> :</td>
		<td nowrap><p align="center">
			  <input name="CRPoPuntajes" type="text" id="CRPoPuntajes" tabindex="1" value="<cfif rsForm.RecordCount gt 0>#rsForm.CRPoPuntajes#<cfelse></cfif>" size="4" maxlength="1">
		  </p></td>
		<td nowrap align="center"><input type="checkbox" id="CRPiPuntajes" tabindex="1" name="CRPiPuntajes" <cfif rsForm.RecordCount gt 0><cfif rsForm.CRPiPuntajes>checked</cfif><cfelse>1</cfif>></td>
		<td nowrap><input name="CRPePuntajes" type="text" id="CRPePuntajes" tabindex="1" value="<cfif rsForm.RecordCount gt 0 and len(trim(rsForm.CRPePuntajes)) gt 0>#rsForm.CRPePuntajes#<cfelse>Puntajes</cfif>" size="120" maxlength="120"></td>
		<td>&nbsp;</td>
  	</tr>
	
  	<tr>
		<td>&nbsp;</td>
		<td nowrap valign="top" align="right"><cf_translate key="LB_PieDePagina">Pie de P&aacute;gina</cf_translate>:</td>
		<td nowrap><p align="center">&nbsp;
			  
		  </p></td>
		<td nowrap  valign="top"align="center"><input type="checkbox" id="CRPipie" tabindex="1" name="CRPipie" <cfif rsForm.RecordCount gt 0><cfif rsForm.CRPipie>checked</cfif><cfelse>1</cfif>></td>
		<td nowrap>
	</cfoutput>	
		<!--- <input  name="CRPepie" type="text" id="CRPepie" tabindex="1" value="<cfif rsForm.RecordCount gt 0>#htmleditformat(rsForm.CRPepie)#<cfelse> Pie de P&aacute;gina</cfif>"  size="80" maxlength="80"> --->
		<cfset miHTML2 = "">
		<cfif rsForm.RecordCount gt 0>
			<cfset miHTML2 = rsForm.CRPepie>
		<cfelse>
			<cfset miHTML2 = "Pie de P&aacute;gina">
		</cfif>
		<br>
		<cf_sifeditorhtml name="CRPepie" indice="1" value="<cfoutput>#miHTML2#</cfoutput>" height="300">
		</td>
		<td>&nbsp;</td>
  	</tr>
  	<cfoutput>
	<tr><td colspan="6">&nbsp;</td></tr>
  	<tr>
		<td>&nbsp;</td>
		<td colspan="4" align="center">
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Guardar"
				Default="Guardar"
				returnvariable="BTN_Guardar"/>
			
		  <input name="Cambio" type="submit" id="Cambio" value="#BTN_Guardar#" tabindex="1">
		</td>
		<td>&nbsp;</td>
    </tr>
	<tr><td colspan="6">&nbsp;</td></tr>
	</cfoutput>
</table>
</form>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EtiquetaInicial"
	Default="Etiqueta Inicial"
	returnvariable="MSG_EtiquetaInicial"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_OrdenMision"
	Default="Orden Misión"
	returnvariable="MSG_OrdenMision"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EtiquetaMision"
	Default="Etiqueta Misión"
	returnvariable="MSG_EtiquetaMision"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCampo"
	Default="El campo"
	returnvariable="MSG_ElCampo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_RequiereUnValorQueSeEncuentreEntre2Y8"
	Default="requiere un valor que se encuentre entre 2 y 8"
	returnvariable="MSG_RequiereUnValorQueSeEncuentreEntre2Y8"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_OrdenObjetivos"
	Default="Orden Objetivos"
	returnvariable="MSG_OrdenObjetivos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EtiquetaObjetivos"
	Default="Etiqueta Objetivos"
	returnvariable="MSG_EtiquetaObjetivos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_OrdenEspecificaciones"
	Default="Orden Especificaciones"
	returnvariable="MSG_OrdenEspecificaciones"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EtiquetaEspecificaciones"
	Default="Etiqueta Especificaciones"
	returnvariable="MSG_EtiquetaEspecificaciones"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_OrdenEncabezado"
	Default="Orden Encabezado"
	returnvariable="MSG_OrdenEncabezado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EtiquetaEncabezado"
	Default="Etiqueta Encabezado"
	returnvariable="MSG_EtiquetaEncabezado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_OrdenHabilidades"
	Default="Orden Habilidades"
	returnvariable="MSG_OrdenHabilidades"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EtiquetaHabilidades"
	Default="Etiqueta Habilidades"
	returnvariable="MSG_EtiquetaHabilidades"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_OrdenConocimientos"
	Default="Orden Conocimientos"
	returnvariable="MSG_OrdenConocimientos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EtiquetaConocimientos"
	Default="Etiqueta Conocimientos"
	returnvariable="MSG_EtiquetaConocimientos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_OrdenUbicacion"
	Default="Orden Ubicación"
	returnvariable="MSG_OrdenUbicacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EtiquetaUbicacion"
	Default="Etiqueta Ubicación"
	returnvariable="MSG_EtiquetaUbicacion"/>


<script language="JavaScript1.4" type="text/javascript">
	//Validaciones del Encabezado Registro de Nomina
<cfoutput>
	qFormAPI.errorColor = "FFFFCC";
	objForm = new qForm("form1");
	objForm.eini.required = true;
	objForm.eini.description = "#MSG_EtiquetaInicial#";
	objForm.omision.required = true;
	objForm.omision.description = "#MSG_OrdenMision#";
	objForm.emision.required = true;
	objForm.emision.description = "#MSG_EtiquetaMision#";
	objForm.omision.validateRange(2,8,'#MSG_ElCampo# ' + objForm.omision.description + ' #MSG_RequiereUnValorQueSeEncuentreEntre2Y8#.');
	objForm.omision.validate = true;
	objForm.oobj.required = true;
	objForm.oobj.description = "#MSG_OrdenObjetivos#";
	objForm.eobj.required = true;
	objForm.eobj.description = "#MSG_EtiquetaObjetivos#";
	objForm.oobj.validateRange(2,8,'#MSG_ElCampo# ' + objForm.oobj.description + ' #MSG_RequiereUnValorQueSeEncuentreEntre2Y8#.');
	objForm.oobj.validate = true;
	objForm.oespecif.required = true;
	objForm.oespecif.description = "#MSG_OrdenEspecificaciones#";
	objForm.eespecif.required = true;
	objForm.eespecif.description = "#MSG_EtiquetaEspecificaciones#";
	objForm.oespecif.validateRange(2,8,'#MSG_ElCampo# ' + objForm.oespecif.description + ' #MSG_RequiereUnValorQueSeEncuentreEntre2Y8#.');
	objForm.oespecif.validate = true;
	objForm.oencab.required = true;
	objForm.oencab.description = "#MSG_OrdenEncabezado#";
	objForm.eencab.required = true;
	objForm.eencab.description = "#MSG_EtiquetaEncabezado#";
	objForm.oencab.validateRange(2,8,'#MSG_ElCampo# ' + objForm.oencab.description + ' #MSG_RequiereUnValorQueSeEncuentreEntre2Y8#.');
	objForm.oencab.validate = true;
	objForm.ohabilidad.required = true;
	objForm.ohabilidad.description = "#MSG_OrdenHabilidades#";
	objForm.ehabilidad.required = true;
	objForm.ehabilidad.description = "#MSG_EtiquetaHabilidades#";
	objForm.ohabilidad.validateRange(2,8,'#MSG_ElCampo# ' + objForm.ohabilidad.description + ' requiere un valor que se encuentre entre 2 y 8.');
	objForm.ohabilidad.validate = true;
	objForm.oconocim.required = true;
	objForm.oconocim.description = "#MSG_OrdenConocimientos#";
	objForm.econocim.required = true;
	objForm.econocim.description = "#MSG_EtiquetaConocimientos#";
	objForm.oconocim.validateRange(2,8,'#MSG_ElCampo# ' + objForm.oconocim.description + ' #MSG_RequiereUnValorQueSeEncuentreEntre2Y8#.');
	objForm.oconocim.validate = true;
	objForm.oubicacion.required = true;
	objForm.oubicacion.description = "#MSG_OrdenUbicacion#";
	objForm.eubicacion.required = true;
	objForm.eubicacion.description = "#MSG_EtiquetaUbicacion#";
	objForm.oubicacion.validateRange(2,8,'#MSG_ElCampo# ' + objForm.oubicacion.description + ' #MSG_RequiereUnValorQueSeEncuentreEntre2Y8#.');
	objForm.oubicacion.validate = true;
</cfoutput>

	//Funcionamiento del Area de Edici&oacute;n de texto estilo word
	
	var config = new Object();    // create new config object
	
	config.width = "100%";
	config.height = "200px";
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


</script>
