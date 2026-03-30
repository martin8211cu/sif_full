<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 22 de junio del 2005
	Motivo:	Nueva opción para Módulo de Tesorería, 
			Anulación de Ordenes de Pago
----------->
<cfinvoke key="LB_Titulo" default="Anulaci&oacute;n de Ordenes de Pago"	returnvariable="LB_Titulo"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagoanular.xml"/>
<cfinvoke key="LB_Titulo1" default="Ordenes de Pago Emitidas"	returnvariable="LB_Titulo1"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagoanular.xml"/>
<cf_templateheader title="#LB_Titulo#">
	<cfset titulo = '#LB_Titulo#'>
	<cfset tipoCheque = '= 1'>
	<cfset irA = 'ordenesPagoAnulacion.cfm'>
	<cfset entrega = 1>
	<cf_navegacion name="TESOPid">
	<cfset navegacion = "">
	<cfif isdefined("form.TESOPid")>
		<cfinclude template="ordenesPagoAnular_form.cfm">
	<cfelse>
		<cfset titulo = '#LB_Titulo1#'>
		
		<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
			<cf_listaOPs TESOPestado='12,110' ira="ordenesPagoAnular.cfm">
	<cf_web_portlet_end>
	</cfif>
<cf_templatefooter>