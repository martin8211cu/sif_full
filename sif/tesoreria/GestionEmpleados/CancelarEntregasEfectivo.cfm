<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TituloCanceracionEntregasEfectivo" default ="Cancelación/Consulta de Recepciones en Efectivo" returnvariable="LB_TituloCanceracionEntregasEfectivo" xmlfile = "AprobarTrans.xml">

<cf_templateheader title="#LB_TituloCanceracionEntregasEfectivo#"> 
<cfinclude template="TESid_Ecodigo.cfm">
<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>
	<cfset titulo = '#LB_TituloCanceracionEntregasEfectivo#'>
  <cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">

<cfset LvarSAporEmpleadoCFM = "AprobarTrans.cfm">
<cfif isdefined ('url.Tipo')>
	<cfset form.Tipo=#url.Tipo#>
</cfif>

	<cfinclude template="CancelarEntregasEfectivo_Lista.cfm">

  <cf_web_portlet_end>
<cf_templatefooter>


