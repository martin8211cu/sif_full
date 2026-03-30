
<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!--- Consultas --->
<cfif modo neq 'ALTA'>
	<!--- Form --->
	<cfquery name="rsForm" datasource="#session.DSN#">
		select upper(rtrim(RHTPcodigo))as RHTPcodigo, RHTPdescripcion, ts_rversion, RHTinfo
		from RHTPuestos
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHTPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTPid#">
	</cfquery>
<!---<cfquery name="rsForm" datasource="#session.DSN#">
		select RHTPcodigo = upper(rtrim(RHTPcodigo)), RHTPdescripcion, ts_rversion, RHTinfo
		from RHTPuestos
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHTPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTPid#">
	</cfquery>--->
</cfif>


<!--- registros existentes --->
<cfquery name="rsCodigos" datasource="#session.DSN#">
	select upper(rtrim(RHTPcodigo)) as RHTPcodigo
	from RHTPuestos
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<form name="form1" method="post" action="SQLPuestosTipos.cfm">
  <cfoutput>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr><td colspan="2">&nbsp;</td></tr>
    <tr> 
      <td nowrap align="right"><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate>:&nbsp;</td>
      <td nowrap>
	  	<input name="RHTPcodigo" type="text" value="<cfif modo neq 'ALTA'>#Trim(rsForm.RHTPcodigo)#</cfif>" size="10" maxlength="5" onFocus="javascript:this.select();" style="text-transform: uppercase;">
	  </td>
    </tr>
    <tr> 
      <td nowrap align="right"><cf_translate key="LB_Decripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</td>
      <td nowrap><input name="RHTPdescripcion" type="text" value="<cfif modo neq 'ALTA'>#rsForm.RHTPdescripcion#</cfif>" size="62" maxlength="60" onFocus="javascript:this.select();"></td>
    </tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td align="center" colspan="2"><strong><cf_translate key="LB_InformacionAdicional">Información Adicional</cf_translate>	</strong></td></tr>
	<tr> 
       <td>&nbsp;</td>
		<td>
			<!--*******************************Editor TEXTO************************************-->						
			<textarea name="RHTinfo" id="RHTinfo" rows="15" style="width: 100%" tabindex="1"><cfoutput><cfif modo EQ 'CAMBIO'>#rsForm.RHTinfo#</cfif></cfoutput></textarea>
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
					editor_generate('RHTinfo', config);
				</script>
				<!--*******************************Editor TEXTO************************************-->
		</td>	
    </tr>
	<tr>
		<td nowrap colspan="2" align="center">
			<cfinclude template="/rh/portlets/pBotones.cfm">
		</td>
	</tr>
	
	<cfif modo NEQ 'ALTA'>
	<cfset ts = "">	
	<cfif modo neq "ALTA">
		<cfinvoke 
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
		</cfinvoke>
	</cfif>
	<tr>
		<td>
			<input type="hidden" name="ts_rversion" value="#ts#">
			<input type="hidden" name="RHTPid" value="#form.RHTPid#">
		</td>
	</tr>
	</cfif>

  </table>  
  </cfoutput>
</form>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCodigoDeTipoDePuestoYaExisteDefinaUnoDistinto"
	Default="El Código de Tipo de Puesto ya existe, defina uno distinto"
	returnvariable="MSG_ElCodigoDeTipoDePuestoYaExisteDefinaUnoDistinto"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Codigo"
	Default="Código"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripción"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Descripcion"/>

<script language="JavaScript1.2" type="text/javascript">

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	function _Field_CodigoNoExiste(){
		<cfoutput query="rsCodigos">
			if (("#TRIM(UCASE(RHTPcodigo))#"==this.obj.value.toUpperCase( ))
			<cfif modo neq "ALTA">
			&&("#TRIM(UCASE(rsForm.RHTPcodigo))#"!=this.obj.value.toUpperCase( ))
			</cfif>
			)
				this.error = "#MSG_ElCodigoDeTipoDePuestoYaExisteDefinaUnoDistinto#.";
		</cfoutput>
	}

	_addValidator("isCods", _Field_CodigoNoExiste);
<cfoutput>
	objForm.RHTPcodigo.required = true;
	objForm.RHTPcodigo.description="#MSG_Codigo#";
	objForm.RHTPcodigo.validateCods();
	
	objForm.RHTPdescripcion.required = true;
	objForm.RHTPdescripcion.description="#MSG_Descripcion#";
</cfoutput>
	function deshabilitarValidacion(){
		objForm.RHTPcodigo.required = false;
		objForm.RHTPdescripcion.required = false;
	}

	function habilitarValidacion(){
		objForm.RHTPcodigo.required = true;
		objForm.RHTPdescripcion.required = true;
	}
	objForm.RHTPcodigo.obj.focus();
</script>