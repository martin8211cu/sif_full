<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 01 de junio del 2005
	Motivo:	Nueva opción para Módulo de Tesorería, 
			Rechazo de Solicitudes de Pago en Tesorería
----------->
<style type="text/css">
<!--
.pStyle_TESSPmsgRechazo {color: #FF0000}
-->
</style>
<cfinvoke key="LB_Titulo" default="Rechazo de Solicitudes de Pago"	returnvariable="LB_Titulo"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="solicitudesRechazar_lista.xml"/>
<cfset titulo = '#LB_Titulo#'>
<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<cfset Attributes.irA="solicitudesRechazar.cfm">
	<cfset Attributes.RechazoSP="yes">
	<cfinclude template="../Solicitudes/SP_lista.cfm">
<cf_web_portlet_end>
