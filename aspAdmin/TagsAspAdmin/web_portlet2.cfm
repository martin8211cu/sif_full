<cfparam name="Session.Preferences.Skin" default="default">

<cfparam name="Attributes.titulo" default="">
<cfparam name="Attributes.tituloalign" default="center">
<cfparam name="Attributes.border" default="true">
<cfparam name="Attributes.Skin" default="#Session.Preferences.Skin#">
<cfparam name="Attributes.Width" default="100%">

<cfif not Attributes.border>
	<cfset thleft = "">
	<cfset thcenter = "">
	<cfset thright = "">
	<cfset tdcontenido = "">
<cfelse>
	<cfset thleft = "class='" & Attributes.Skin & "_thleft'">
	<cfset thcenter = "class='" & Attributes.Skin & "_thcenter'">
	<cfset thright = "class='" & Attributes.Skin & "_thright'">
	<cfset tdcontenido = "class='" & Attributes.Skin & "_tdcontenido'">
</cfif>

<cfparam name="Request.portlet" default="false">

<CFIF ThisTag.HasEndTag>
    <CFSWITCH EXPRESSION="#ThisTag.ExecutionMode#">
        <CFCASE VALUE="START">
			<cfoutput>
				<table width="#Attributes.Width#" border="0" cellspacing="0" cellpadding="0">
					<tr> 
					  <th width="16" #thleft# title="click to collapse" onClick="cfportlet_toggleTable(this);"></th>
					  <th width="" #thcenter#><div align="#Attributes.tituloalign#">#Attributes.Titulo#</div></th>
					  <th width="16" #thright#></th>
					</tr>
					<tr>
						<td colspan="3" #tdcontenido#>
			</cfoutput>
        </CFCASE>
        
        <CFCASE VALUE="END">
 						</td>
					</tr>
				</table>
			<cfif not Request.portlet>
				<cfhtmlhead text='<link href="/cfmx/sif/css/web_portlet.css" rel="stylesheet" type="text/css">'>
			</cfif>
			<cfif not Request.portlet and Attributes.border>
				<script language="JavaScript1.2">
					function cfportlet_toggleTable(source) {
						var switchToState = cfportlet_toggleSource( source ) ;
						if(document.all) {
							var table = source.parentElement.parentElement ;
							for ( var i = 1; i < table.rows.length; i++ ) {
								target = table.rows[i] ;
								cfportlet_toggleTarget( target, switchToState ) ;
							}
						}
						else {
							var table = source.parentNode.parentNode ;
							for ( var i = 1; i < table.childNodes.length; i++ ) {
								target = table.childNodes[i] ;
								if(target.style) {
									cfportlet_toggleTarget( target, switchToState ) ;
								}
							}
						}
					}
				
					function cfportlet_toggleSource ( source ) {
						if ( source.style.fontStyle == 'italic' ) {
							source.style.fontStyle = 'normal' ;
							source.title = 'click to collapse' ;
							return 'open' ;
						} else {
							source.style.fontStyle = 'italic' ;
							source.title = 'click to expand' ;
							return 'closed' ;
						}
					}
					
					function cfportlet_toggleTarget ( target, switchToState ) {
						if ( switchToState == 'open' )	target.style.display = '' ;
						else target.style.display = 'none' ;
					}
				</script>
			</cfif>
			<cfif Attributes.border>
				<cfset Request.portlet = true>
			</cfif>

        </CFCASE>
    </CFSWITCH>
<CFELSE>
    <PRE>
    Error: Este tag requiere de un TAG de cierre!!!!
    Uso:
    <FONT COLOR="MAROON">&lt;CF_web_portlet&gt;</FONT>
    Contenido del portlet...
    <FONT COLOR="MAROON">&lt;/CF_web_portlet&gt;</FONT>
    <BR>
    Problemas? Contacte al autor:&nbsp;<A HREF="mailto:marcelm@soin.co.cr?Subject=cf_portlet">marcelm@soin.co.cr</A>
    </PRE> 
</CFIF>
