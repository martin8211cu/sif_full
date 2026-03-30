<cfset setEncoding("url", "utf-8") >
<cfparam name="url.titulo" default="Información Adicional">
<cfparam name="url.form" default="form1">
<cfparam name="url.texto" default="texto">
<cfparam name="url.value" default="">
<cfparam name="url.rows" default="25">
<cfparam name="url.height" default="250">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><cfoutput>#url.titulo#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
<cfoutput>
<script language="javascript" type="text/javascript" >
<!--//
	// load htmlarea
	_editor_url = "/cfmx/sif/Utiles/htmlarea/";  // URL to htmlarea files
	var win_ie_ver = parseFloat(navigator.appVersion.split("MSIE")[1]);
	if (navigator.userAgent.indexOf('Mac')        >= 0) { win_ie_ver = 0; }
	if (navigator.userAgent.indexOf('Windows CE') >= 0) { win_ie_ver = 0; }
	if (navigator.userAgent.indexOf('Opera')      >= 0) { win_ie_ver = 0; }
	if (win_ie_ver >= 5.5) {
	  document.write('<scr' + 'ipt src="' +_editor_url+ 'editor.js"');
	  document.write(' language="Javascript1.2"></scr' + 'ipt>');  
	} else { document.write('<scr'+'ipt>function editor_generate() { return false; }</scr'+'ipt>'); }
//-->
</script>
</cfoutput>
</head>
<cfoutput>
<body>
<form action="" method="post" name="form1">
<table width="99%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="tituloListas">
			<div align="left"><strong>#url.titulo#</strong>
		    </div></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
  <tr>
    <td><textarea name="Texto" id="Texto" rows="#url.rows#" style="width: 100%;"></textarea></td>
  </tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="center">
			<input type="button" name="Asignar" value="Asignar" onClick="javascript: funcAsignar();">
		</td>
	</tr>
</table>
</form>
</body>
</cfoutput>
<script language="JavaScript" type="text/javascript">
	<!--//
	var config = new Object();    // create new config object
	
	config.width = "100%";
	config.height = "<cfoutput>#url.height#</cfoutput>px";
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

	editor_generate('Texto', config);
	//-->
</script>
<script language='javascript' type='text/JavaScript' >
<!--//
	<cfoutput>
	document.form1.Texto.value = window.opener.#url.form#.#url.texto#.value;
	function funcAsignar(){
		window.opener.#url.form#.#url.texto#.value = document.form1.Texto.value;
		window.close();
	}
	</cfoutput>
//-->
</script>
</html>