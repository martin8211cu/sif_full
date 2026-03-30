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
    <cfparam name="Attributes.Align" default="left">
    <cfparam name="Attributes.pzn" default="no">
    <cfparam name="Attributes.name" default="0">
    <cfparam name="Attributes.tipo" default="">
    <cfparam name="Attributes.redondeo" default="1">
    <cfparam name="Session.Portlet.esconderTitulo" default="false">
  	<cfparam name="Attributes.esconderTitulo" default="#Session.Portlet.esconderTitulo#">
  	<cfparam name="Session.Portlet.Class" default="">
  	<cfparam name="Attributes.Class" default="#Session.Portlet.Class#">
  	<cfparam name="Session.Portlet.ClassTitulo" default="">
  	<cfparam name="Attributes.claseTitulo" default="#Session.Portlet.ClassTitulo#">

  	<!----- 20141028 fcastro, si no se selecciona un titulo especifico para el encabezado se le coloca el del proceso de ser posible--->
    <cfif not len(trim(Attributes.titulo)) and isDefined("session.monitoreo.SScodigo") and isDefined("session.monitoreo.SMcodigo") and isDefined("session.monitoreo.SPcodigo")>
      <cfquery datasource="asp" name="translate_SPcodigo" maxrows="1">
        select SPdescripcion from SProcesos where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.monitoreo.SScodigo#"> and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.monitoreo.SMcodigo#"> and SPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.monitoreo.SPcodigo#">
      </cfquery>
      <cfinvoke component="sif.Componentes.TranslateDB" method="Translate" VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#" Default="#translate_SPcodigo.SPdescripcion#" VSgrupo="103" returnvariable="Attributes.titulo"/>
    </cfif>

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
	<cfelseif REFind('sif_login02.css',session.sitio.CSS)>   
        <cfset color = '##0B7CC1'>
	<cfelseif REFind('css/erp.css',session.sitio.CSS)>   
        <cfset color = '##0079C1'>
    </cfif>	

	<style type="text/css">
        div#box<cfoutput>#Attributes.name#</cfoutput>  
			   {width: 100%; margin-bottom: 9px; padding: 4px 0; background:<cfoutput>#color#</cfoutput>;}
          <cfif not REFind('css/erp.css',session.sitio.CSS)>.row {margin: 0;padding: 0;}</cfif>
        .panel-portlet {
          border-color: #0079C1;
        }
        .panel-portlet>.panel-heading {
          padding: 4px 0;
          color: #fff;
          background-color: #0079C1;
          border-color: #0079C1;
        }
        .panel-portlet>.panel-body {
          padding:8px 0px 0px 0px;
        }
		<cfif not isdefined("request.web_porlet_rounded")>
			<cfset request.web_porlet_rounded = true>
		</cfif>
    </style>
	<cfif not isdefined("session.porlets")>
		<cfset session.porlets = 'div##box' & Attributes.name & '|'& Attributes.redondeo &','>
	<cfelse>
		<cfset session.porlets =session.porlets&'div##box' & Attributes.name & '|'& Attributes.redondeo &',' >
	</cfif>
			
    <cfoutput>
 	    <cfif #Attributes.Width# NEQ "">
	  	<div class="row divPorlet">
      </cfif>
	  	<div id="cfportlet#Attributes.name#" class="panel panel-portlet"><!-- inicio panel-->
      <!----- encabezado del panel-------->
      <div class="panel-heading">
          <cfif #Attributes.claseTitulo# NEQ "">
              <table>
                <tr>
                 <td colspan="3">
                 <div class="#Attributes.claseTitulo#" <cfif attributes.esconderTitulo>style="display:none"</cfif>>
                    <table width="100%" cellpadding="0" cellspacing="0" border="1">
                      <tr>
                        <td width="26"  align="left"  id="cfportlet#Attributes.name#x"></td>
                        <td  align="left" 
                            <cfif Attributes.pzn>style="cursor:move;" onmousedown="pm_onmousedown_handle('pm_name#JSStringFormat(Attributes.id_portlet)#')"</cfif> 
                            <cfif Len(Attributes.Width) And REFind('$[0-9]+^', Attributes.Width)>width="#Attributes.Width-31#"<cfelse>width=""</cfif>><a class="tituloPortlet">#Attributes.Titulo#</strong>
                        </td>
                        <td width="" align="right"  class="tituloPortlet">
                            <cfif Attributes.pzn>
                              <div onclick="cfportlet_move('#JSStringFormat(Attributes.id_pagina)#','#JSStringFormat(Attributes.id_portlet)#','close')" style="font-size:larger;font-weight:bold;width:100%">&times;&nbsp;&nbsp;</div>
                            <cfelse>
                                <img src="/cfmx/sif/imagenes/tabs/spacer.gif" width="16" height="1" alt="" />
                            </cfif>
                        </td>
                      </tr>
                    </table>
                  </div>
                  </td>
                </tr>   
              </table>
            <cfelseif len(Attributes.titulo)>
              <div align="#Attributes.Align#">
                <strong  style="color:##FFFFFF">#Attributes.Titulo#</strong>
              </div>
            </cfif>
      </div> 

      <div   class="panel-body <cfif attributes.class neq ''>#attributes.class#</cfif>"><!-- inicio panel body-->
      
    </cfoutput>
</cfif>
