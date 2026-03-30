<cfinvoke key="LB_ContabilidadElectronica" default="Contabilidad Electr&oacute;nica" returnvariable="LB_ContabilidadElectronica" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacionCE.xml"/>
<cfinvoke key="LB_BalanzaComprobacion" default="Balanza de Comprobaci&oacute;n SAT" returnvariable="LB_BalanzaComprobacion" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacionCE.xml"/>

<cf_templateheader title="#LB_ContabilidadElectronica#">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<cf_web_portlet_start titulo="#LB_BalanzaComprobacion#">
		<cfinclude template="formBalComprobacionCE.cfm">
		<hr>
		<cfinclude template="listaBalComprobacionCE.cfm">
    <cf_web_portlet_end>
<cf_templatefooter>