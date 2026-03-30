<cfparam name="Attributes.name" default="imAyuda" type="string">
<cfparam name="Attributes.Acodigo" default="#cgi.SCRIPT_NAME#" type="string">
<cfparam name="Attributes.Iid" default="1" type="numeric">
<cfparam name="Attributes.width" default="550" type="numeric">
<cfparam name="Attributes.height" default="400" type="numeric">
<cfparam name="Attributes.left" default="250" type="numeric">
<cfparam name="Attributes.top" default="200" type="numeric">
<cfparam name="Attributes.url" default="/cfmx/sif/Utiles/sifayudahelp.cfm" type="string">
<cfparam name="Attributes.imagen" default="3" type="numeric">
<cfparam name="Attributes.TitleBGColor" default="##ADADCA" type="string">
<cfparam name="Attributes.TitleTextColor" default="##FFFFFF" type="string">
<cfparam name="Attributes.BGColor" default="##FFFFFF" type="string">
<cfparam name="Attributes.TextColor" default="##000000" type="string">
<cfparam name="Attributes.CaptionText" default="" type="string">
<cfparam name="Attributes.Tip" default="false" type="string">
<cfparam name="Attributes.scrollbars" default="no" type="string">
<cfparam name="Attributes.tipo" default="0" type="string">

<cfif Attributes.tipo eq 0>
	<cfif FindNoCase( '/', Attributes.url, 1) neq 1>
		<cfset Attributes.url = '/' & Attributes.url >
	</cfif>

	<cfif FindNoCase(cgi.context_path, Attributes.url, 1) neq 1>
		<cfset Attributes.url = cgi.context_path & Attributes.url >
	</cfif>
</cfif>

<cfquery name="rs" datasource="sifcontrol">
	select Adesc 
	from Ayuda 
	where Acodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.Acodigo#">
	  and Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.Iid#">
</cfquery>

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

		popUpWin<cfoutput>#Attributes.name#</cfoutput> = open(URLStr, 'popUpWin<cfoutput>#Attributes.name#</cfoutput>', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=<cfoutput>#Attributes.scrollbars#</cfoutput>,resizable=yes,copyhistory=yes,width='+ww+',height='+wh+',left='+wl+', top='+wt+',screenX='+wl+',screenY='+wt+'');			
	}
	
	// End -->
</script>

<cfif Attributes.Imagen GT 3>
	<cfset Attributes.Imagen = 0>
</cfif>

<cfif Attributes.Tip>
	<cfparam name="Request.OverDiv" default="false">
	<cfif not Request.OverDiv>
		<div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>
		<cfset Request.OverDiv = true>
	</cfif>
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
	<script language="JavaScript" src="/cfmx/sif/js/Overlib/overlib.js"><!-- overLIB (c) Erik Bosrup --></script> 
	<cfif rs.RecordCount GT 0>
		<cfset ayuda = '<table width="100%" border="0" cellspacing="0" cellpadding="0"><tr><td>'>
		<cfset ayuda = ayuda & rs.Adesc >
		<cfset ayuda = ayuda & '</td><td>'>
		<cfset ayuda = ayuda & '<img name="imasist" src="/cfmx/sif/imagenes/asistente1.gif">'>
		<cfset ayuda = ayuda & '</td></tr></table>'>
	<cfelse>
		<cfset ayuda = "Ayuda no disponible.">
	</cfif>
	<cfoutput>
	<a href='javascript:void(0);'
		onmouseover='javascript:return overlib("#jsstringformat(ayuda)#", CAPTION, "#Attributes.CaptionText#");'
		onmouseout='nd();'
		<cfif attributes.Tip>
		onclick="javascript:popUpWindow#Attributes.name#('#attributes.url#');"
		</cfif>
	>
	<img 
		name="#Attributes.name#" 
		src=
			<cfif Attributes.imagen EQ 1>"/cfmx/sif/imagenes/help_u.gif"	</cfif>
			<cfif Attributes.imagen EQ 0>"/cfmx/sif/imagenes/Help01_T.gif"	</cfif>
			<cfif Attributes.imagen EQ 2>"/cfmx/sif/imagenes/Bulb.gif"	</cfif>
			<cfif Attributes.imagen EQ 3>"/cfmx/sif/imagenes/Help02_T.gif"	</cfif>
		border="0"
	>
	</a>
	</cfoutput>
<cfelse>	
	<cfoutput>
	<a href='javascript:void(0);'
	onclick="javascript:popUpWindow#Attributes.name#('#attributes.url#')"
	>
	<img 
		name="#Attributes.name#" 
		src=
			<cfif Attributes.imagen EQ 1>"/cfmx/sif/imagenes/help_u.gif"	</cfif>
			<cfif Attributes.imagen EQ 0>"/cfmx/sif/imagenes/Help01_T.gif"	</cfif>
			<cfif Attributes.imagen EQ 2>"/cfmx/sif/imagenes/Bulb.gif"	</cfif>
			<cfif Attributes.imagen EQ 3>"/cfmx/sif/imagenes/Help02_T.gif"	</cfif>
		border="0">
	</a>
	</cfoutput>
</cfif>
