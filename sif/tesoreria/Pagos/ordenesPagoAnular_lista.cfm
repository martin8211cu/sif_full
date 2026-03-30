<cfinvoke key="LB_Titulo" default="Lista de Ordenes de Pago Emitidas"	returnvariable="LB_Titulo"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagoAnular_form.xml"/>
<cfset titulo = '#LB_Titulo#'>

<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<cf_listaOPs TESOPestado='12' ira="ordenesPagoAnular.cfm">
<cf_web_portlet_end>
