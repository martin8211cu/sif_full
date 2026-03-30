<cfinvoke  key="LB_Titulo" default="Conversi&oacute;n de Estados Financieros" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Titulo" xmlfile="ConversionEstFin.xml"/>

<cfset LvarB15 = false>
<cf_templateheader title="#LB_Titulo#">
    <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_Titulo#">
        <cfinclude template="../../portlets/pNavegacion.cfm">
        <cfinclude template="ConversionEstFinCorp.cfm">
		<div id="divTCs">
        <cfinclude template="ConversionEstFin-form.cfm">
		</div>
    <cf_web_portlet_end>	
<cf_templatefooter>