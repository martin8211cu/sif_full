<script language="Javascript1.2">
	<!-- // load htmlarea
	_editor_url = "/cfmx/edu/Utiles/htmlarea/";  // URL to htmlarea files
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

<!-- Establecimiento del modo -->
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

<cfif modo neq 'ALTA'>
	<cfquery name="rsForm" datasource="sdc">
		select convert(varchar, MSCcontenido) as MSCcontenido, MSCtexto, MSCtitulo, MSCcategoria, convert (varchar, MSCexpira, 103) as MSCexpira
		from MSContenido
		where MSCcontenido = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MSCcontenido#">
		  and Scodigo = #session.Scodigo#
	</cfquery>
	<cfquery name="rsImages" datasource="sdc">
		select convert(varchar, MSIcodigo) as MSIcodigo,
			case when MSInombre is null or MSInombre = '' then 'Imagen ' + convert(varchar, MSIcodigo) else MSInombre end as MSInombre
		from MSImagen
		where MSCcontenido = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MSCcontenido#">
		  and Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Scodigo#">
	</cfquery>
	<cfquery name="restricciones" datasource="sdc">
		select count(1) as cant from MSPaginaArea
		where MSCcontenido = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MSCcontenido#">
		  and Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Scodigo#">
	</cfquery>
</cfif>
<cfquery name="categorias" datasource="sdc">
	select convert(varchar, MSCcategoria) as MSCcategoria,MSCnombre
	from MSCategoria
	order by MSCnombre
</cfquery>

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

</script>

<form action="SQLContenidos.cfm" method="post" enctype="multipart/form-data" name="form1" onSubmit="javascript: MM_validateForm('MSCtitulo','','R'); validarDependencias(this); return document.MM_returnValue">
	<cfif isdefined("Form.PageNum")>
		<input type="hidden" name="Pagina" value="<cfoutput>#Form.PageNum#</cfoutput>">
	</cfif>
	<cfoutput>
	<table width="100%" border="0" cellpadding="2" cellspacing="0">
		<tr>
			<td align="right">T&iacute;tulo:&nbsp;</td>
			<td colspan="3">
				<input type="text" size="50" maxlength="50" name="MSCtitulo" value="<cfif modo neq 'ALTA'>#rsForm.MSCtitulo#</cfif>" onfocus="javascript:this.select();" alt="La Descripción" >
				<cfif modo neq 'ALTA'>
					<input type="hidden" name="MSCcontenido" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.MSCcontenido#</cfoutput></cfif>" >
				</cfif>
			</td>
		</tr>
		<tr>
		    <td align="right">Categor&iacute;a</td>
		    <td><select name="MSCcategoria">
			<cfloop query="categorias">
			<option value="#categorias.MSCcategoria#" <cfif IsDefined("rsForm.MSCcategoria") and categorias.MSCcategoria EQ rsForm.MSCcategoria>selected</cfif> >
				#categorias.MSCnombre#</option>
			</cfloop>
		        </select></td>
		    <td>Fecha de expiraci&oacute;n:</td>
		    <td><cfif IsDefined("rsForm.MSCexpira")>
				<cf_sifcalendario name="MSCexpira" query="#rsForm#">
				<cfelse><cf_sifcalendario name="MSCexpira">
			</cfif></td>
		</tr>
		<tr>
		    <td colspan="4"><strong><a href="##" onClick="mostrarContenidoOImagen('C')">Editar contenido</a>
				| <a href="##" onClick="mostrarContenidoOImagen('I')">Editar Im&aacute;genes</a></strong></td>
		    </tr>
		<tr id="trcontenido">
		    <td colspan="4">
			<cfif IsDefined("rsForm.MSCtexto")>
				<cfset html=rsForm.MSCtexto>
			<cfelse>
				<cfset html="">
			</cfif>
			<!---
			<cf_soEditor_lite 
				form="form1" 
				field="MSCtexto" 
				scriptpath="/cfmx/edu/Utiles/soeditor/lite/"
				html="#html#"
				width="100%"
				height="150"
				singlespaced="true"
				wordcount="false" 
				validateonsave="false"
				
				initialFocus="MSCtitulo"
				find="false"
				hr="false"
				image="false" 
				link="true"
				unlink="true"
				align="true" 
				list="false" 
				unindent="false" 
				indent="false"
				fontdialog="false"
				format="false" 
				font="true"
				size="true" 
				bold="true" 
				italic="true" 
				underline="false"
				superscript="false"
				subscript="false"
				fgcolor="true" 
				bgcolor="false"
				tables="false"
				htmledit="false"
				borders="false" 
				details="false"
				save="false"
				new="false"
				anchor="false">
				--->
				
				<textarea name="MSCtexto" id="MSCtexto" rows="15" style="width: 100%"><cfoutput>#html#</cfoutput></textarea>
			</td>
		    </tr>
		<tr id="trimagenes" style="display:none;background-color:##ccc">
		    <td colspan="4" valign="top">
			<table width="100%%" border="0" cellspacing="0" cellpadding="2">
		        <tr>
		    <td width="70%" valign="top">
				<cfset src="blank.gif">
				<cfif Modo EQ "ALTA" OR rsImages.RecordCount EQ 0>
					No hay imágenes en este documento<br>
				<cfelse>
					<table cellpadding="2" cellspacing="0" width="100%">
					<cfloop query="rsImages">
						<cfset src="/jsp/DownloadServlet/MiniSitios/MSIimagen.jpg?MSIcodigo=" & rsImages.MSIcodigo>
						
						<tr id="trid#rsImages.CurrentRow#"
							class="<cfif rsImages.CurrentRow MOD 2 EQ 1>listaPar<cfelse>listaNon</cfif>"
							onmouseover="mostrarImagenIn('#src#', #rsImages.CurrentRow#);"
							onmouseout="mostrarImagenOut(#rsImages.CurrentRow#);"
							<cfif rsImages.CurrentRow EQ rsImages.RecordCount>
							style="background-color:##E4E8F3"
							</cfif>
							onClick="mostrarImagenIn('#src#', #rsImages.CurrentRow#);">
							<td>
							#rsImages.MSInombre#</td>
							<td align="right"><input type="button" value="Quitar" onClick="location.href='Contenidos-imgdelete.cfm?MSCcontenido=#form.MSCcontenido#&i=#rsImages.MSIcodigo#'"></td>
							</tr>
					</cfloop></table>
				</cfif>
				Cargar imagen nueva: <br>
                <input type="file" size="60" name="MSIimagen" onChange="mostrarImagenIn(this.value)">
			</td>
		    <td width="30%" valign="top"><img name="imgsampler" id="imgsampler" src="#src#" height="120" border="1">
			</td>
		</tr>
		        </table></td>
		    </tr>
		<tr><td colspan="4">&nbsp;</td></tr>
		<tr><td colspan="4" align="center"><cfinclude template="../../portlets/pBotones.cfm"></td></tr>
		<tr><td colspan="4">&nbsp;</td></tr>
	</table>
	<input name="PageNum" type="hidden" value="<cfif isdefined("form.PageNum") and form.PageNum NEQ "">#form.PageNum# <cfelse>1</cfif>">
	</cfoutput>
	
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

	editor_generate('MSCtexto', config);
</script>

<script type="text/javascript">
<!--
	function mostrarImagenIn(imgsrc, trid) {
		if (document.getElementById("imgsampler")) {
			document.getElementById("imgsampler").src = imgsrc;
		}
		if (document.getElementById("trid" + trid) && document.getElementById("trid" + trid).style) {
			document.getElementById("trid" + trid).style.backgroundColor ="#E4E8F3";
		}
	}
	function mostrarImagenOut(trid) {
		if (document.getElementById("trid" + trid) && document.getElementById("trid" + trid).style) {
			document.getElementById("trid" + trid).style.backgroundColor =(trid % 2 == 0) ? "#ffffff" : "#fafafa";
		}
		if (document.form1.MSIimagen.value.length != 0) {
			document.getElementById("imgsampler").src = document.form1.MSIimagen.value;
		} else {
			document.getElementById("imgsampler").src = "blank.gif";
		}
	}
	
	function mostrarContenidoOImagen(cual) {
		if (document.getElementById("trcontenido")) {
			document.getElementById("trcontenido").style.display = (cual == 'C') ? "inline" : "none";
			document.getElementById("trimagenes").style.display  = (cual != 'C') ? "inline" : "none";
		}
	}
	
	function validarDependencias(f) {
		<cfif modo neq 'ALTA'>
			<cfif isdefined("restricciones") and restricciones.cant GT 0>
			if (btnSelected("Baja", f)) {
				alert("El contenido no se puede eliminar porque tiene páginas asociadas");
				document.MM_returnValue = false;
			}
			<cfelse>
				document.MM_returnValue = document.MM_returnValue && true;
			</cfif>	
		</cfif>
	}
//-->
</script>