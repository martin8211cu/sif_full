<cfparam name="Attributes.name" default="imAyuda"  type="string">
<cfparam name="Attributes.Acodigo" default=""  type="string">
<cfparam name="Attributes.Iid" default="1"  type="numeric">
<cfparam name="Attributes.width" default="550"  type="numeric">
<cfparam name="Attributes.height" default="400"  type="numeric">
<cfparam name="Attributes.left" default="250"  type="numeric">
<cfparam name="Attributes.top" default="200"  type="numeric">
<cfparam name="Attributes.url" default=""  type="string">
<cfparam name="Attributes.imagen" default="0"  type="numeric">
<cfparam name="Attributes.TitleBGColor" default="##ADADCA"  type="string">
<cfparam name="Attributes.TitleTextColor" default="##FFFFFF"  type="string">
<cfparam name="Attributes.BGColor" default="##FFFFFF"  type="string">
<cfparam name="Attributes.TextColor" default="##000000"  type="string">
<cfparam name="Attributes.CaptionText" default=""  type="string">
<cfparam name="Attributes.Tip" default="false"  type="string">

<cfif Attributes.Imagen GT 2>
	<cfset Attributes.Imagen = 0>
</cfif>
<SCRIPT LANGUAGE="JavaScript">
<!-- Begin
var popUpWin<cfoutput>#Attributes.name#</cfoutput>=0;
function popUpWindow<cfoutput>#Attributes.name#</cfoutput>(URLStr){
	URLStr += '<cfoutput>?Acodigo=#Attributes.Acodigo#&Iid=#Attributes.Iid#</cfoutput>';
<cfif Attributes.width EQ "">
	ww = parseInt(screen.width) - 10;
<cfelse>
	ww = <cfoutput>#Attributes.width#;</cfoutput>
</cfif>	
<cfif Attributes.height EQ "">
	wh = parseInt(screen.height) - 60;
<cfelse>
	wh = <cfoutput>#Attributes.height#;</cfoutput>
</cfif>	
<cfif Attributes.left EQ "">
	wl = 0;
<cfelse>
	wl = <cfoutput>#Attributes.left#;</cfoutput>
</cfif>	
<cfif Attributes.top EQ "">
	wt = 0;
<cfelse>
	wt = <cfoutput>#Attributes.top#;</cfoutput>
</cfif>	
  if(popUpWin<cfoutput>#Attributes.name#</cfoutput>)
  {
	if(!popUpWin<cfoutput>#Attributes.name#</cfoutput>.closed) popUpWin<cfoutput>#Attributes.name#</cfoutput>.close();
  }
  popUpWin<cfoutput>#Attributes.name#</cfoutput> = open(URLStr, 'popUpWin<cfoutput>#Attributes.name#</cfoutput>', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+ww+',height='+wh+',left='+wl+', top='+wt+',screenX='+wl+',screenY='+wt+'');
}

// End -->
</script>

<cfif Attributes.Tip>
	<div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>
	<script language="JavaScript1.2"><!-- Configuración Default del OVERLIB -->
	<!-- Begin
	<cfoutput>
	var ol_fgcolor = "#Attributes.BGColor#"; 			// Background color del area de la ayuda
	var ol_textcolor = "#Attributes.TextColor#"; 		// Text color del area de la ayuda
	var ol_capcolor = "#Attributes.TitleTextColor#";	// color del texto del caption
	var ol_bgcolor ="#Attributes.TitleBGColor#";		// Background color del caption
	var ol_width = "#Attributes.width#";				// witdh
	</cfoutput>
	// End -->
	</script>
	<script language="JavaScript" src="/cfmx/edu/js/Overlib/overlib.js"><!-- overLIB (c) Erik Bosrup --></script> 
	<cfquery name="rs" datasource="sifcontrol">
		select Adesc 
		from Ayuda 
		where Acodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Attributes.Acodigo#">
		  and Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.Iid#">
	</cfquery>
	<cfif rs.RecordCount GT 0>
		<cfset ayuda = rs.Adesc>
	<cfelse>
		<cfset ayuda = "Ayuda no disponible.">
	</cfif>
<!--- 	<cf_PowerPOSTIT_INIT 
		maxNOTES="1" 
		Title_BGColor1="#Attributes.TitleBGColor#"
		BGColor1="#Attributes.BGColor#"
		Title_TxtColor1="#Attributes.TitleTextColor#"
		TxtColor1="#Attributes.TextColor#"
		note1="#JSstringFormat(ayuda)#" 
		title1="Ayuda de SIF">
	<CF_PowerPOSTIT name="note1" text="_image" src="/cfmx/edu/Imagenes/Bulb.gif">
 --->
	<cfoutput>
	<a href='javascript:void(0);'
		onmouseover='javascript:return overlib("#jsstringformat(ayuda)#", CAPTION, "#Attributes.CaptionText#");'
		onmouseout='nd();'		
	>
	<img 
		name="#Attributes.name#" 
		src="<cfif Attributes.imagen EQ 1>/cfmx/edu/Imagenes/help_u.gif<cfelseif Attributes.imagen EQ 0>/cfmx/edu/Imagenes/Help01_T.gif<cfelseif Attributes.imagen EQ 2>/cfmx/edu/Imagenes/Bulb.gif</cfif>" 
		border="0">
	</a>
	</cfoutput>

<cfelse>	
	<cfoutput>
	<a href='javascript:void(0);'
	onclick="javascript:popUpWindow<cfoutput>#Attributes.name#</cfoutput>('#attributes.url#')"
	>
	<img 
		name="#Attributes.name#" 
		src="<cfif Attributes.imagen EQ 1>/cfmx/edu/Imagenes/help_u.gif<cfelseif Attributes.imagen EQ 0>/cfmx/edu/Imagenes/Help01_T.gif<cfelseif Attributes.imagen EQ 2>/cfmx/edu/Imagenes/Bulb.gif</cfif>" 
		border="0">
	</a>
<!--- 	<input name="#Attributes.name#" type="image" src="<cfif Attributes.imagen EQ 1>/cfmx/edu/Imagenes/help_u.gif<cfelseif Attributes.imagen EQ 0>/cfmx/edu/Imagenes/Help01_T.gif<cfelseif Attributes.imagen EQ 2>/cfmx/edu/Imagenes/Bulb.gif</cfif>" alt="Ayuda" onclick="javascript:popUpWindow<cfoutput>#Attributes.name#</cfoutput>('#attributes.url#')"> --->
	</cfoutput>
</cfif>
