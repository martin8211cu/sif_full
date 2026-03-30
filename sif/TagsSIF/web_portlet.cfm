<!---
	modificado por danim, Oct-07-2005
	para permitir tener distintos estilos:
	- se trasladan los css a la plantilla, por lo que no
	se incluye aquí una referencia al CSS.
	- se agregan estilos para el borde inferior de los portlets
	de modo que sea posible hacer portlets redondeados.
	- incluir Attributes.tipo
--->

<cfif ThisTag.HasEndTag>
  <cfif UCase( ThisTag.ExecutionMode ) is 'END'>
    <cfsilent>
    <cfparam name="Session.Preferences.Skin" default="default">
    <cfparam name="Attributes.titulo" default="">
    <cfparam name="Attributes.tituloalign" default="center">
    <cfparam name="Attributes.border" default="true">
    <cfparam name="Attributes.Skin" default="#Session.Preferences.Skin#">
    <cfparam name="Attributes.Width" default="100%">
    <cfparam name="Attributes.Align" default="center">
    <cfparam name="Attributes.pzn" default="no">
    <cfparam name="Attributes.name" default="0">
    <cfparam name="Attributes.tipo" default="">
    <cfif Len(Attributes.tipo) EQ 0 And Attributes.border IS false>
      <cfset Attributes.tipo = 'box'>
      <cfelseif (Len(Attributes.tipo) EQ 0) and (Len(Attributes.skin) NEQ 0)>
      <!--- compatibilidad --->
      <cfset Attributes.tipo = Attributes.skin>
      <cfelseif (Len(Attributes.tipo) EQ 0)>
      <cfset Attributes.tipo = 'normal'>
    </cfif>
	<cfif ListFind('normal,bold,light,mini,box', Attributes.tipo) EQ 0>
		<cfif ListFind('Gray', Attributes.Skin)>
		<cfset Attributes.tipo = 'normal'><!--- light --->
		<cfelse>
		<cfset Attributes.tipo = 'normal'>
		</cfif>
	</cfif>
    <cfif Attributes.tipo EQ 'normal'>
      <cfset Attributes.tipo = 'portlet'>
      <cfelse>
      <cfset Attributes.tipo = 'portlet_' & Attributes.tipo>
    </cfif>
    <cfif Attributes.pzn>
      <cfparam name="Attributes.id_pagina">
      <cfparam name="Attributes.id_portlet">
    </cfif>
    <cfif Attributes.name Is 0>
      <cfparam name="Request.cfportlet_count" default="0">
      <cfset Request.cfportlet_count = Request.cfportlet_count + 1>
      <cfset Attributes.name = Request.cfportlet_count>
    </cfif>
    <cfset thleft   = "class='" & Attributes.tipo & "_thleft'">
    <cfset thcenter = "class='" & Attributes.tipo & "_thcenter'">
    <cfset thright  = "class='" & Attributes.tipo & "_thright'">
    <cfset tfleft   = "class='" & Attributes.tipo & "_tfleft'">
    <cfset tfcenter = "class='" & Attributes.tipo & "_tfcenter'">
    <cfset tfright  = "class='" & Attributes.tipo & "_tfright'">
    <cfset tdcontenido = "class='" & Attributes.tipo & "_tdcontenido'">
    <cfparam name="Request.portlet" default="false">
    </cfsilent>
    <cfoutput>
      <cfif #Attributes.Width# NEQ "">
        <table width="#Attributes.Width#" border="0" cellspacing="0" cellpadding="0" align="#Attributes.Align#">
        <tr>
        <td valign="top">
      </cfif>
      <table id="cfportlet#Attributes.name#" width="100%" border="0" cellspacing="0" cellpadding="0">
        <cfif len(Attributes.titulo)>
		<tr>
		 <td colspan="3" valign="top">
		 <table width="100%" cellpadding="0" cellspacing="0">
          <tr>
            <td width="26" #thleft# align="left"  id="cfportlet#Attributes.name#x" ><img  onClick="cfportlet_toggleTable('#Attributes.name#');" style="cursor:pointer;"
							   alt="Haga click para ocultar" title="Haga click para ocultar"
							   	src="/cfmx/home/menu/portlets/wh_rt.gif" width="15" height="16" border="0" id="cfportlet#Attributes.name#toggle">
			</td><!---   
			                                                      
			      se quitaron los anchos de 26-*-16 para que se acomode solo   
			      en el siguiente TD se pone width="" en lugar de              
			      width="100%" para que no salga un espacio horrible entre el  
			      portlet y el border en el internet explorer                  
			      sin embargo, el ancho de 26 permanece porque hay portlets    
			      alineados a la izquierda   
			                                                                   
			---><td #thcenter# align="#Attributes.tituloalign#"
					  	<cfif Attributes.pzn>style="cursor:move;" onmousedown="pm_onmousedown_handle('pm_name#JSStringFormat(Attributes.id_portlet)#')"</cfif> 
						<cfif Len(Attributes.Width) And REFind('$[0-9]+^', Attributes.Width)>width="#Attributes.Width-31#"<cfelse>width=""</cfif>>#Attributes.Titulo#</td>
            <td width="" align="right" #thright# style="cursor:pointer;text-align:right">
				<cfif Attributes.pzn>
					<table width="1" align="right" cellpadding="0" cellspacing="0"><tr><td width="25">
						<img src="/cfmx/sif/imagenes/Template.gif" onclick="document.customize.submit();" title="Personalizar">
					</td><td>
					<SPAN onclick="cfportlet_move('#JSStringFormat(Attributes.id_pagina)#','#JSStringFormat(Attributes.id_portlet)#','close')" style="color:white;font-size:larger;font-weight:bold;width:1px" title="Eliminar Portlet">&nbsp;&times;&nbsp;&nbsp;</SPAN>
					</td></tr></table>
				<cfelse>
					<img src="/cfmx/sif/imagenes/tabs/spacer.gif" width="16" height="1" alt="" />
				</cfif>
			</td>
          </tr>
		  </table></td></tr>
        </cfif>
		<tr>
			<td colspan="3" #tdcontenido# id="cfportlet#Attributes.name#tdcont" valign="top">
			 	<cfif Attributes.pzn EQ 0 AND Len(ThisTag.GeneratedContent) GT 50*1024>
					<div style="color:white;background-color:red;font-size:16px;padding:6px;font-weight:bold;">
						Atenci&oacute;n:<br />Está usando el cf_web_portlet para contenido muy grande en <cfoutput>
						# Replace(Replace(  GetBaseTemplatePath(), ExpandPath('/'), ''), '\\', '/',' all') #</cfoutput>.<br />
						Cambie por el cf_web_portlet_start / cf_web_portlet_end.
					</div>
				</cfif>
				<cfset LvarChart = ThisTag.GeneratedContent>
			 	<cfif Attributes.pzn NEQ 0>
					<cfset LvarChart=replacenocase(LvarChart,'quality="high"', 'quality="high" wmode="transparent"', "ALL")>
					<cfset LvarChart=replacenocase(LvarChart,'<PARAM NAME="quality" VALUE="high"/>', '<PARAM NAME="quality" VALUE="high"/><PARAM NAME="wmode" VALUE="transparent"/>', "ALL")>
				</cfif>
				#LvarChart#
				<cfset ThisTag.GeneratedContent = ''>
				<cfset LvarChart = ''>
			</td>
		</tr>
          <tr>
            <td #tfleft#   align="left"></td>
            <td #tfcenter# align="#Attributes.tituloalign#"></td>
            <td #tfright#  align="right"></td>
          </tr>
      </table>
      <cfif #Attributes.Width# NEQ "">
        </td>
        </tr>
        </table>
      </cfif>
      <cfif Attributes.border>
        <cfif not Request.portlet>
          <cfhtmlhead text="
          <script language='JavaScript1.2' type='text/javascript'>
          <!--
			function cfportlet_move(pageid,portletid,direction){
				window.open('/cfmx/home/menu/portlets/pzn/portlet-move.cfm?id_pagina='+escape(pageid)
					+'&id_portlet='+escape(portletid)
					+'&direction='+escape(direction), 'pm_iframe');
				location.href='#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#';
			}
			function cfportlet_toggleTable(baseid) {
				var source = document.all ? document.all['cfportlet'  + baseid + 'toggle'] : document.getElementById('cfportlet'  + baseid + 'toggle');
				var target = document.all ? document.all['cfportlet'  + baseid + 'tdcont'] : document.getElementById('cfportlet'  + baseid + 'tdcont');
				var switchToState = cfportlet_toggleSource( source ) ;
				cfportlet_toggleTarget( target, switchToState ) ;
				return;
			}
			function cfportlet_toggleSource ( source ) {
				if ( source.style.fontStyle == 'italic' ) {
					source.style.fontStyle = 'normal' ;
					source.title = 'Haga clic para ocultar' ;
					source.src = '/cfmx/home/menu/portlets/wh_rt.gif';
					return 'open' ;
				} else {
					source.style.fontStyle = 'italic' ;
					source.title = 'Haga clic para mostrar' ;
					source.src = '/cfmx/home/menu/portlets/wh_dn.gif';
					return 'closed' ;
				}
			}
			function cfportlet_toggleTarget ( target, switchToState ) {
				target.style.display = ( switchToState == 'open' )	? '' : 'none';
			}
			//-->
		</script>">
        </cfif>
        <cfset Request.portlet = true>
      </cfif>
    </cfoutput>
  </cfif>
  <cfelse>
  <pre>
    Error: Este tag requiere de un TAG de cierre!!!!
    Uso:
    <font color="maroon">&lt;cf_web_portlet&gt;</font>
    Contenido del portlet...
    <font color="maroon">&lt;/cf_web_portlet&gt;</font>
    <br/>
    Problemas? Contacte al autor:&nbsp;<a href="mailto:marcelm@soin.co.cr?Subject=cf_portlet">marcelm@soin.co.cr</a>
    </pre>
</cfif>