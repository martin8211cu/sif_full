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

<cfquery name="rsIdiomas" datasource="sifcontrol">
	select convert(varchar,Iid) as Iid, Descripcion 
	from Idiomas 
</cfquery>

<cfif modo neq "ALTA">
  <cfquery name="rsLinea" datasource="sifcontrol">
	  select convert(varchar, Ayid) as Ayid, Acodigo, convert(varchar,Iid) as Iid, Adesc, Atipo
	  from Ayuda 
	  where Ayid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ayid#">
  </cfquery>
</cfif>

<script language="JavaScript" type="text/JavaScript">
	<!--
	function MM_findObj(n, d) { //v4.01
	  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
		d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
	  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
	  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
	  if(!x && d.getElementById) x=d.getElementById(n); return x;
	}
	
	function MM_validateForm() { //v4.0
	  var i,p,q,nm,test,num,min,max,errors='',args=MM_validateForm.arguments;
	  for (i=0; i<(args.length-2); i+=3) { test=args[i+2]; val=MM_findObj(args[i]);
		if (val) { if (val.alt!="") nm=val.alt; else nm=val.name; if ((val=val.value)!="") {
		  if (test.indexOf('isEmail')!=-1) { p=val.indexOf('@');
			if (p<1 || p==(val.length-1)) errors+='- '+nm+' no es una dirección de correo electrónica válida.\n';
		  } else if (test!='R') { num = parseFloat(val);
			if (isNaN(val)) errors+='- '+nm+' debe ser numérico.\n';
			if (test.indexOf('inRange') != -1) { p=test.indexOf(':');
			  min=test.substring(8,p); max=test.substring(p+1);
			  if (num<min || max<num) errors+='- '+nm+' debe ser un número entre '+min+' y '+max+'.\n';
		} } } else if (test.charAt(0) == 'R') errors += '- '+nm+' es requerido.\n'; }
	  } if (errors) alert('Se presentaron los siguientes errores:\n\n'+errors);
	  document.MM_returnValue = (errors == '');
	}
	//-->

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

<form action="SQLAyudas.cfm" method="post" name="form1" onSubmit="MM_validateForm('Acodigo','','R');return document.MM_returnValue">
	<table>
		<tr valign="baseline">
			<td width="78%">C&oacute;digo:</td>
			<td width="1%">&nbsp;</td>
			<td width="15%">Idioma:</td>
			<td width="1%">&nbsp;</td>
			<td width="5%">Din&aacute;mica:</td>
		</tr>

		<tr valign="baseline">
			<td><input name="Acodigo" type="text" value="<cfif modo neq "ALTA"><cfoutput>#rsLinea.Acodigo#</cfoutput></cfif>" size="80" maxlength="255" alt="El campo Código"></td>
			<td><div align="right"></div></td>
			<td>
				<select name="Iid">
					<cfoutput query="rsIdiomas">
						<option value="#rsIdiomas.Iid#">#rsIdiomas.Descripcion#</option>
					</cfoutput>
				</select>
			</td>
			<td><div align="right"></div></td>
			<td><div align="right"><input type="checkbox" name="Atipo" <cfif modo neq "ALTA" and rsLinea.Atipo eq 1>checked</cfif>></div>
			</td>
		</tr>

		<tr valign="baseline">
			<td colspan="5" align="left" valign="top">
				<textarea id="Adesc" name="Adesc" style="x-width:100%" rows="5" cols="10"><cfif modo neq "ALTA"><cfoutput>#rsLinea.Adesc#</cfoutput></cfif></textarea>
			</td>
		</tr>

		<tr valign="baseline"> 
			<td colspan="5" align="right" nowrap>
				<div align="center"><cfinclude template="../../portlets/pBotones.cfm"></div>
			</td>
		</tr>
	</table>

	<div align="left"><input type="hidden" name="Ayid" value="<cfif modo neq "ALTA"><cfoutput>#rsLinea.Ayid#</cfoutput></cfif>"></div>
</form>
  
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

	editor_generate('Adesc', config);
</script>