<!--- TAG Tool Tip Text (cf_tooltiptext) --->
<cfparam type="string" name="Attributes.Text" default="Tool Tip Text">
<cfparam type="string" name="Attributes.Type" default="div">
<cfparam type="string" name="Attributes.Args" default="">
<cfparam type="string" name="Attributes.fgcolor" default="##FFFFFF">
<cfparam type="string" name="Attributes.textcolor" default="##000000">
<cfparam type="string" name="Attributes.capcolor" default="##FFFFFF">
<cfparam type="string" name="Attributes.bgcolor" default="##ADADCA">
<cfparam type="string" name="Attributes.Width" default="300">
<CFIF ThisTag.HasEndTag>
    <CFSWITCH EXPRESSION="#ThisTag.ExecutionMode#">
        <CFCASE VALUE="START">
			<!--- script de ayuda --->
			<cfparam name="Request.OverDiv" default="false">
			<cfoutput>
				<cfif not Request.OverDiv>
					<div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>
					<script language="JavaScript1.2"><!-- Configuracin Default del OVERLIB -->
						<!-- Begin
							var ol_fgcolor = "#Attributes.fgcolor#"; 		// Background color del area de la ayuda
							var ol_textcolor = "#Attributes.textcolor#"; 	// Text color del area de la ayuda
							var ol_capcolor = "#Attributes.capcolor#";		// color del texto del caption
							var ol_bgcolor ="#Attributes.bgcolor#";			// Background color del caption
							var ol_width = "#Attributes.Width#";			// witdh
						// End -->
					</script>
					<script language="JavaScript" src="/cfmx/sif/js/Overlib/overlib.js"><!-- overLIB (c) Erik Bosrup --></script> 
					<cfset Request.OverDiv = true>
				</cfif>
				<#Attributes.Type#
					onmouseover='javascript:return overlib("#jsstringformat(Attributes.text)#", CAPTION, "");'
					onmouseout='nd();'>
			</cfoutput>
        </CFCASE>
        
        <CFCASE VALUE="END">
			<cfoutput>
				</#Attributes.Type#>
			</cfoutput>
        </CFCASE>
    </CFSWITCH>
<CFELSE>
    <PRE>
    Error: Este tag requiere de un TAG de cierre!!!!
    Uso:
    <FONT COLOR="MAROON">&lt;cf_tooltiptext&gt;</FONT>
    Contenido del portlet...
    <FONT COLOR="MAROON">&lt;/cf_tooltiptext&gt;</FONT>
    <BR>
    Problemas? Contacte al autor:&nbsp;<A HREF="mailto:marcelm@soin.co.cr?Subject=cf_tooltiptext">marcelm@soin.co.cr</A>
    </PRE> 
</CFIF>