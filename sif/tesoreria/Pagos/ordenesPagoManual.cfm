<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 22 de junio del 2005
	Motivo:	Nueva opción para Módulo de Tesorería, 
			Anulación de Ordenes de Pago
----------->
<cfinvoke key="LB_Titulo" default="Emisión de Ordenes de Pago Manual"	returnvariable="LB_Titulo"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagomanual.xml"/>
<cfinvoke key="LB_TituloLista" default="Lista de Ordenes de Pago en Emisión"	returnvariable="LB_TituloLista"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagos_manual.xml"/>

<cf_templateheader title="#LB_Titulo#">
	<cfset titulo = '#LB_Titulo#'>
	<cfset tipoCheque = '= 1'>
	<cfset irA = 'ordenesPagoManual.cfm'>
	<cfset entrega = 1>
	<cf_navegacion name="TESOPid">
	<cfset navegacion = "">
	<cfif isdefined("form.TESOPid")>
		<cfset Session.Tesoreria.ordenesPagoIrLista = "ordenesPagoManual.cfm">
		<cfinclude template="ordenesPago_manual.cfm">
	<cfelse>
		<cfset titulo = '#LB_TituloLista#'>
		<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
			<cf_listaOPs TESOPestado='11' ira="ordenesPagoManual.cfm" noLotes='yes'>
	<cf_web_portlet_end>
	</cfif>
<cf_templatefooter>