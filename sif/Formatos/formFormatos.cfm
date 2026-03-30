<!---
<script language="Javascript1.2">
	<!-- // load htmlarea
	_editor_url = "/cfmx/sif/Utiles/htmlarea/";  // URL to htmlarea files
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
---->
<cfif isdefined("Form.EFid") and len(trim(Form.EFid))>
	<cf_translatedata name="validar" tabla="EFormato" filtro="EFid=#Form.EFid#"/>
</cfif>

<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2700" default="0" returnvariable="Param2700">

<cfinvoke Key="LB_Regresar" Default="Regresar" returnvariable="LB_Regresar" component="sif.Componentes.Translate" method="Translate"/>
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
<cfif isdefined("url.EFid") and len(trim(url.EFid))>
	<cfset form.EFid = url.EFid>
	<cfset modo = "CAMBIO">
</cfif>
<cfquery name="rsTipoFormato" datasource="#Session.DSN#">
	select TFid, TFdescripcion,TFcfm
		from TFormatos
	Where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfif modo neq "ALTA">
	<cf_translatedata name="get" tabla="EFormato" col="a.EFdescripcion" returnvariable="LvarEFdescripcion">
	<cf_translatedata name="get" tabla="EFormato" col="EFdescalterna" returnvariable="LvarEFdescalterna">
	<cf_translatedata name="get" tabla="DFormato" col="DFtexto" returnvariable="LvarDFtexto">
	<cfquery name="rsFormatos" datasource="#Session.DSN#">
		select a.EFid, a.EFcodigo, a.Ecodigo, a.TFid, a.EFfecha, #LvarEFdescripcion# as EFdescripcion,
			DFlinea, #LvarDFtexto# as DFtextoTranslate, DFtexto, a.EFpautogestion,
			#LvarEFdescalterna# as EFdescalternaTranslate,EFdescalterna <!--- ,a.NotificarSolicitante --->
			from EFormato a
			left outer join  DFormato b
			on a.EFid = b.EFid
			where a.Ecodigo =
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and a.EFid =
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EFid#">
	</cfquery>
</cfif>

<cfquery name="rsCodigos" datasource="#session.DSN#">
	select EFcodigo
	from EFormato
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	<cfif modo NEQ "ALTA">
		and EFid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EFid#">
	</cfif>
</cfquery>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<!--<td valign="top" nowrap width="40%">
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_CODIGO"
			Default="C&oacute;digo"
			XmlFile="/sif/rh/generales.xml"
			returnvariable="LB_CODIGO"/>

			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_DESCRIPCION"
			Default="Descripci&oacute;n del Formato"
			returnvariable="LB_DESCRIPCION"/>

			<cfinvoke
			component="sif.Componentes.pListas"
			method="pListaRH"
			returnvariable="pListaRet"
			columnas="a.EFid, a.EFcodigo, a.EFdescripcion"
			tabla="EFormato a
				inner join TFormatos b
				on b.TFid = a.TFid"
			filtro="a.Ecodigo = #Session.Ecodigo#
					order by a.EFcodigo"
			desplegar="EFcodigo, EFdescripcion"
			etiquetas="#LB_CODIGO#, #LB_DESCRIPCION#"
			formatos="S,S"
			filtrar_por="EFcodigo, EFdescripcion"
			mostrar_filtro="true"
			filtrar_automatico="true"
			align="left, left"
			ira="Formatos.cfm"/>

		</td>---->
		<td valign="top">
			<form action="SQLFormatos.cfm" method="post" name="form1">
				<input name="DFlinea" type="hidden" value="<cfif modo neq "ALTA" and isdefined('rsFormatos') and rsFormatos.DFlinea NEQ ''><cfoutput>#rsFormatos.DFlinea#</cfoutput><cfelse>0</cfif>">
				<table valign="top" align="center" cellpadding="2" cellspacing="0" border="0" width="100%" style="padding-left: 10px;">
					<tr>
						<cfoutput>
						<td width="23%" align="right" nowrap class="fileLabel"><strong>#LB_CODIGO#:</strong>&nbsp;</td>
						<td width="28%">
							<input name="EFcodigo" type="text"
								value="<cfif modo neq "ALTA">#rsFormatos.EFcodigo#</cfif>"
								size="20" maxlength="10" alt="El campo C&oacute;digo"
								onblur="codigos(this)">
						</td>
						</cfoutput>
						<td width="10%" align="right" nowrap class="fileLabel"><strong><cf_translate key="LB_Modulo">M&oacute;dulo</cf_translate>:&nbsp;</strong></td>
						<td width="33%">
							<select name="TFid" id="TFid">
								<cfoutput query="rsTipoFormato">
									<option value="#TFid#" <cfif modo NEQ 'ALTA' and rsTipoFormato.TFid EQ rsFormatos.TFid>selected</cfif>>#TFdescripcion#</option>
								</cfoutput>
							</select>
						</td>
						<td width="6%">
							<div align="right">
								<!---<cf_sifayuda width="650" height="450" name="imgAyuda" Tip="false">--->
								<img style="cursor:pointer;" src="/cfmx/sif/imagenes/Help02_T.gif" onclick="javascrip:popUpWindowimgAyuda();" />
							</div>
						</td>
					</tr>
					<cfoutput>
					<tr>
						<td class="fileLabel" align="right"><strong>#LB_DESCRIPCION#:&nbsp;</strong></td>
						<td>
							<input name="EFdescripcion" size="40" type="text" value="<cfif modo neq "ALTA">#rsFormatos.EFdescripcion#</cfif>" maxlength="80" alt="El campo Descripci&oacute;n de Formato">
						</td>
						<td class="fileLabel"><strong></strong></td>
						<td>
							<table width="1%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td><input type="checkbox" name="EFpautogestion"<cfif modo neq "ALTA" and rsFormatos.EFpautogestion eq 1>checked</cfif> /></td>
									<td nowrap="nowrap" class="fileLabel"><strong><cf_translate key="CHK_SolicitablePorAutogestion">Solicitable por Autogesti&oacute;n</cf_translate></strong>
									<a href="/cfmx/sif/Formatos/FormatosTipos.cfm" style="cursor:pointer">.</a></td>
								</tr>
								<!--- 20170104 Bjimenez. Nuevos check para notificar mediante correo --->
								<!--- <tr>
									<td><input type="checkbox" name="NotificarSolicitante"<cfif modo neq "ALTA" and rsFormatos.NotificarSolicitante eq 1>checked</cfif> /></td>
									<td nowrap="nowrap" class="fileLabel"><strong><cf_translate key="CHK_NotificarSolicitante">Notificar a solicitante</cf_translate></strong>
								</tr> --->
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="5" align="center" nowrap>
							<cf_botones modo="#modo#" include="Regresar">
						</td>
					</tr>
					<tr>
						<td colspan="5">
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td class="fileLabel" align="center"><strong><cf_translate key="LB_TextoDelFormato">Texto del Formato</cf_translate></strong>
									<td colspan="3">&nbsp;</td>
								</tr>
								<cfif isdefined("Form.EFid") and len(trim(Form.EFid))>
									<tr>
										<td class="fileLabel" align="center">	<cf_translatedata name="validar" tabla="DFormato" filtro="EFid=#Form.EFid#"/></strong>
										<td colspan="3">&nbsp;</td>
									</tr>
								</cfif>
								<tr class="fileLabel">
									<td colspan="3">
										<cfif modo eq "ALTA">
											<strong>
											<cfset miHTML = "">
										<cfelse>
											<cfif Param2700 eq 0>
												<cfset miHTML = rsFormatos.DFtexto>
											<cfelseif Param2700 eq 1 and len(trim(rsFormatos.DFtextoTranslate))>
												<cfset miHTML = rsFormatos.DFtextoTranslate>
											<cfelse>
												<cfset miHTML = rsFormatos.DFtexto>
											</cfif>
											</strong>
										</cfif>
										<strong>
											<!---<textarea name="DFtexto" id="DFtexto" rows="15" style="width: 100%">#miHTML#</textarea>---->
											<cf_rheditorhtml name="DFtexto" value="#miHTML#" height="400" toolbarset="Default">
										</strong>
									</td>
								</tr>
								<tr><td>&nbsp;</td></tr>
								<tr>
									<td class="fileLabel" align="center"><strong><cf_translate key="LB_Mensaje">Mensaje</cf_translate></strong>
									<td colspan="3">&nbsp;</td>
								</tr>
								<tr class="fileLabel">
									<td colspan="3">
										<cfif modo eq "ALTA">
											<strong>
											<cfset miHTML2 = "">
										<cfelse>
											<cfif param2700 eq 0>
												<cfset miHTML2 = rsFormatos.EFdescalterna>
											<cfelseif param2700 eq 1 and len(trim(rsFormatos.EFdescalternaTranslate))>
												<cfset miHTML2 = rsFormatos.EFdescalternaTranslate>
											<cfelse>
												<cfset miHTML2 = rsFormatos.EFdescalterna>
											</cfif>
											</strong>
										</cfif>
										<strong>
											<!----<textarea name="EFdescalterna" id="EFdescalterna" rows="15" style="width: 100%">#miHTML2#</textarea>---->
											<cf_rheditorhtml name="EFdescalterna" value="#miHTML2#" height="250" toolbarset="Default">
										</strong>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="5" align="center" nowrap>
							<cf_botones modo="#modo#" include="Regresar"><!---values="Regresar" functions="funcRegresar();"  --->
						</td>
					</tr>
				</table>
				<input type="hidden" name="EFid" value="<cfif modo neq "ALTA">#rsFormatos.EFid#</cfif>">
				</cfoutput>
			</form>
		</td>
	</tr>
</table>

<!---Definir cual es el archivo de ayuda, en este caso se hace porque el ITCR necesita un archivo de ayuda especializado para cada una de las certificaciones,
de modo que el archivo de ayuda que va a abrir es el que tiene el mismo nombre que el archivo definido en el modulo (formatos-tipos) pero con '-ayuda' al final--->
<cfif modo neq "ALTA">
	<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
	<cfif isdefined ('rsFormatos') and rsFormatos.recordcount gt 0 and len(trim(rsFormatos.TFid)) gt 0>
		<cfquery name="rsSql" datasource="#session.dsn#">
			select TFcfm from TFormatos where TFid=#rsFormatos.TFid#
		</cfquery>
		<cfset Lvar=''>
		<cfif len(trim(rsSql.TFcfm)) gt 0>
			<cfloop list="#rsSQL.TFcfm#" delimiters="." index="i">
				<cfset Lvar=i>
				<cfbreak>
			</cfloop>
			<cfset LvarRuta=Lvar&'-ayuda.cfm'>
			<cfif FileExists(ExpandPath(#LvarRuta#))>
				<cfset Ruta='/cfmx'&LvarRuta>
			<cfelse>
				<cfset Ruta='/cfmx/sif/Formatos/formatos-ayuda.cfm'>
			</cfif>
		</cfif>
	</cfif>

</cfif>
<cf_qforms>

<script language="javascript1.2">
	<!--//
	//Validaci&oacute;n de Requiridos con Qforms
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Codigo"	Default="Código" returnvariable="MSG_Codigo"/>
	<cfinvoke component="sif.Componentes.Translate"	method="Translate" Key="MSG_Descripcion" Default="Descripción" returnvariable="MSG_Descripcion"/>
	<cfinvoke component="sif.Componentes.Translate"	method="Translate" Key="MSG_Formato" Default="Tipo de Formato" returnvariable="MSG_Formato"/>

	objForm.EFcodigo.description="<cfoutput>#MSG_Codigo#</cfoutput>";
	objForm.EFdescripcion.description="<cfoutput>#MSG_Descripcion#</cfoutput>";
	objForm.TFid.description="<cfoutput>#MSG_Formato#</cfoutput>";

	function habilitarValidacion(){
		objForm.EFcodigo.required=true;
		objForm.EFdescripcion.required=true;
		objForm.TFid.required=true;
	}

	function deshabilitarValidacion(){
		objForm.EFcodigo.required=false;
		objForm.EFdescripcion.required=false;
		objForm.TFid.required=false;
	}
	/*
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

	editor_generate('DFtexto', config);
	editor_generate('EFdescalterna', config);

	//-->
	*/

	var popUpWinimgAyuda=0;
	function popUpWindowimgAyuda(URLStr){
		URLStr += '?Acodigo=/cfmx/sif/Formatos/Formatos.cfm&Iid=1';
		ww = 650;
		wh = 550;
		wl = 250;
		wt = 200;

		if(popUpWinimgAyuda){
			if(!popUpWinimgAyuda.closed) popUpWinimgAyuda.close();
		}
		<cfif isdefined('Ruta') and len(trim(Ruta)) gt 0>
		popUpWinimgAyuda = open('<cfoutput>#Ruta#</cfoutput>', 'popUpWinimgAyuda', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+ww+',height='+wh+',left='+wl+', top='+wt+',screenX='+wl+',screenY='+wt+'');
		<cfelse>
		popUpWinimgAyuda = open('formatos-ayuda.cfm', 'popUpWinimgAyuda', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+ww+',height='+wh+',left='+wl+', top='+wt+',screenX='+wl+',screenY='+wt+'');
		</cfif>
	}

	function codigos(obj){
		if (obj.value != "") {
			obj.value = obj.value.toUpperCase();
			var dato  = obj.value;
			var temp  = new String();
			var found = false;
			<cfloop query="rsCodigos">
			found |= (dato == '<cfoutput>#UCase(Trim(rsCodigos.EFcodigo))#</cfoutput>');
			</cfloop>
			if (found){
				alert('El Código ya existe.');
				obj.value = "<cfif modo neq 'ALTA'><cfoutput>#UCase(Trim(rsFormatos.EFcodigo))#</cfoutput></cfif>";
				obj.focus();
				return false;
			}
		}
		return true;
	}
	function funcRegresar(){
		deshabilitarValidacion();
		document.form1.action = 'FormatosLista.cfm';
		//location.href = 'FormatosLista.cfm';
	}
</script>

