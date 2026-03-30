<!--- Para mantener la referencia del proceso provenienente, en caso que el componente este en dos o mas procesos--->
<cfset session.monitoreo.SPcodigo =session.menues.SPcodigo>

<cf_templateheader title="Tipo de Cambios Adicionales">
    <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Tipo de Cambios Adicionales">
		<cfset LvarTCHpresupuesto=1>
		<cfinclude template="../../portlets/pNavegacion.cfm">
		<cfinclude template="../../cg/operacion/TCHistoricos-lista.cfm">
    <cf_web_portlet_end>	
<cf_templatefooter>
