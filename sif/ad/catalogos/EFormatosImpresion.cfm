<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SIFAdministracionDelSistema"
	Default="SIF - Administraci&oacute;n del Sistema"
	XmlFile="/sif/generales.xml"
	returnvariable="LB_SIFAdministracionDelSistema"/>

<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>		
<cfif isdefined("url.FMT01COD") and Len(Trim("url.FMT01COD")) gt 0 >
	<cfset form.FMT01COD = url.FMT01COD >
</cfif>

<cf_templateheader title="#LB_SIFAdministracionDelSistema#">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Encabezado de Formatos de Impresi&oacute;n'>
		<cfoutput>
			<cfinclude template="formEFormatosImpresion.cfm">
		</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>