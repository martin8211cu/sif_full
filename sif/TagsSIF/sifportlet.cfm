<cfparam name="Attributes.titulo" default="">
<cfparam name="Attributes.include" default="">
<cfparam name="Attributes.border" default="true">
<cfif Attributes.border>
	<cfset claseTitulo = "class='Titulo'">
	<cfset contenido_lbborder = "class='contenido-lbborder'">
	<cfset contenido_brborder = "class='contenido-brborder'">
	<cfset Imagen1 = "<img src='http://" & SERVER_NAME & ":" & SERVER_PORT &"/cfmx/sif/imagenes/sp.gif'>"> 
	<cfset Imagen2 = "<img src='http://" & SERVER_NAME & ":" & SERVER_PORT &"/cfmx/sif/imagenes/rt.gif'>"> 
<cfelse>
	<cfset claseTitulo="">
	<cfset contenido_lbborder="">
	<cfset contenido_brborder="">
	<cfset Imagen1 = "">
	<cfset Imagen2 = "">
</cfif>
<cfparam name="Request.portlet" default="false">
<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr> 
		  <th width="2%" #claseTitulo# style="cursor:hand;" title="click to collapse" onClick="cfportlet_toggleTable(this);">#Imagen1#</th>
		  <th width="3%" #claseTitulo#>&nbsp;</th>
    	  <th width="94%" #claseTitulo#><div align="center">#Attributes.Titulo#</div></th>
		  <th width="" valign="top" <cfif Attributes.border>bgcolor="##ADADCA"</cfif>>#Imagen2#</th>
		</tr>
		<tr> 
		  
    <td colspan="3" #contenido_lbborder#><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td>
		  <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td>
				</cfoutput>
				<cfif Attributes.Include NEQ "">
					<cfinclude template="#Attributes.Include#">
				</cfif>
				<cfoutput>
				</td>
			  </tr>
			  <tr>
			  <td>&nbsp;</td>
			  </tr>
		  </table>
		  </td>
        </tr>
      </table></td>
		  <td #contenido_brborder#>&nbsp;</td>
		</tr>
</table>
</cfoutput>
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
