<cfinvoke key="LB_Titulo" default="Lista de Ordenes de Pago en Preparación"	returnvariable="LB_Titulo"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPago_lista.xml"/>
<cfinvoke key="BTN_SeleccionarSolicitudes" default="Seleccionar Solicitudes"	returnvariable="BTN_SeleccionarSolicitudes"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPago_lista.xml"/>

<cfset titulo = '#LB_Titulo#'>

<cf_web_portlet_start _start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<cfif NOT isdefined("form.chkEnEmision")>
		<cf_listaOPs TESOPestado='10'  ira="ordenesPago.cfm" enEmision='yes'>
		<cfoutput><input name="btnSel" type="button" value="#BTN_SeleccionarSolicitudes#" onClick="location.href='ordenesPago.cfm?PASO=1'" tabindex="2"></cfoutput>
	<cfelse>
		<cf_listaOPs TESOPestado='11' noLotes='yes' enEmision='yes'>
	</cfif>
<cf_web_portlet_start _end>
