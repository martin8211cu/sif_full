
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
	
        
      </div><!-- cierre del panel body-->
	  </div><!-- cierre del panel-->
      <cfif #Attributes.Width# NEQ "">
        </div><!--Cierra Row-->
      </cfif>
    </cfoutput>
  </cfif>