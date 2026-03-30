<!---
	modificado por danim, Oct-07-2005
	para permitir tener distintos estilos:
	- se trasladan los css a la plantilla, por lo que no
	se incluye aquí una referencia al CSS.
	- se agregan estilos para el borde inferior de los portlets
	de modo que sea posible hacer portlets redondeados.
	- incluir Attributes.tipo
--->

  <cfif UCase( ThisTag.ExecutionMode ) is 'START'>
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
    <cfparam name="Attributes.redondeo" default="1">
	
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

    <cfset tdcontenido = "class='" & Attributes.tipo & "_tdcontenido'">
    <cfparam name="Request.portlet" default="false">
      <cfif Attributes.border>
        <cfif not Request.portlet>
          <cfhtmlhead text="
                <script language='JavaScript1.2' type='text/javascript'>
                <!--
                function cfportlet_move(pageid,portletid,direction){
                    location.href='/cfmx/home/menu/portlets/pzn/portlet-move.cfm?id_pagina='+escape(pageid)
                        +'&id_portlet='+escape(portletid)
                        +'&direction='+escape(direction);
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
    </cfsilent>
         <cfset color = '##456ABA'>
	<cfif REFind('soinasp01_azul.css',session.sitio.CSS)>
        <cfset color = '##456ABA'>
	<cfelseif REFind('soinasp01_pantone.css',session.sitio.CSS)>
        <cfset color = '##c00020'>    
	 <cfelseif REFind('soinasp01_verde.css',session.sitio.CSS)>   
        <cfset color = '##3BB06F'>
     <cfelseif REFind('soinasp01_gris.css',session.sitio.CSS)>   
        <cfset color = '##757575'>
     <cfelseif REFind('soinasp01_naranja.css',session.sitio.CSS)>   
        <cfset color = '##E46A11'>
     <cfelseif REFind('soinasp01_rosa.css',session.sitio.CSS)>   
        <cfset color = '##F988B0'>
    <cfelseif REFind('soinasp01_negro.css',session.sitio.CSS)>   
        <cfset color = '##638C3C'>   
	<cfelseif REFind('soinasp01_sapiens.css',session.sitio.CSS)>   
        <cfset color = '##172465'>
      </cfif>

	<style type="text/css">
        div#box<cfoutput>#Attributes.name#</cfoutput>  {width: 100%;padding: 2px  0;margin:0 auto;
        text-align:left;background: <cfoutput>#color#</cfoutput>;}		
    </style>
	<cfif not isdefined("session.porlets")>
		<cfset session.porlets = 'div##box' & Attributes.name & '|'& Attributes.redondeo &','>
	<cfelse>
		<cfset session.porlets =session.porlets&'div##box' & Attributes.name & '|'& Attributes.redondeo &',' >
	</cfif>
			
    <cfoutput>
 	  <cfif #Attributes.Width# NEQ "">
        <table width="#Attributes.Width#" border="0"  cellspacing="0" cellpadding="0" align="#Attributes.Align#">
        <tr>
        <td valign="top">
      </cfif>
      <table id="cfportlet#Attributes.name#" width="100%" border="0" cellspacing="0" cellpadding="0">
        <cfif len(Attributes.titulo)>
		<tr>
		 <td colspan="3" valign="top">
		 <div id="box#Attributes.name#">
         <table width="100%" cellpadding="0" cellspacing="0" border="0">
          <tr>
            <td width="26"  align="left"  id="cfportlet#Attributes.name#x" ><img  onClick="cfportlet_toggleTable('#Attributes.name#');" style="cursor:pointer;"
							   alt="Haga click para ocultar" title="Haga click para ocultar"
							   	src="/cfmx/home/menu/portlets/wh_rt.gif" width="15" height="16" border="0" id="cfportlet#Attributes.name#toggle">
			</td><td  align="#Attributes.tituloalign#" style="color:White;"
					  	<cfif Attributes.pzn>style="cursor:move;" onmousedown="pm_onmousedown_handle('pm_name#JSStringFormat(Attributes.id_portlet)#')"</cfif> 
						<cfif Len(Attributes.Width) And REFind('$[0-9]+^', Attributes.Width)>width="#Attributes.Width-31#"<cfelse>width=""</cfif>><strong style="color:##FFFFFF">#Attributes.Titulo#</strong></td>
            <td width="" align="right"  style="cursor:pointer;text-align:right"><cfif Attributes.pzn>
				<div onclick="cfportlet_move('#JSStringFormat(Attributes.id_pagina)#','#JSStringFormat(Attributes.id_portlet)#','close')" style="font-size:larger;font-weight:bold;width:100%">&times;&nbsp;&nbsp;</div>
				
				
              <cfelse><img src="/cfmx/sif/imagenes/tabs/spacer.gif" width="16" height="1" alt="" /></cfif></td>
          </tr>
		  </table>
          </div>
          </td></tr>
        </cfif>
        <tr>
          <td colspan="3" #tdcontenido# id="cfportlet#Attributes.name#tdcont" valign="top">
    </cfoutput>
</cfif>
