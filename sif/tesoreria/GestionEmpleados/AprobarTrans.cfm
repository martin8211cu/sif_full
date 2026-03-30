<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TituloAprobacionTransacciones" default ="Aprobaci&oacute;n Transacciones" returnvariable="LB_TituloAprobacionTransacciones" xmlfile = "AprobarTrans.xml">

<cf_templateheader title="#LB_TituloAprobacionTransacciones#"> 
<cfinclude template="TESid_Ecodigo.cfm">
<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>
	<cfset titulo = '#LB_TituloAprobacionTransacciones#'>
  <cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">

<cfset LvarSAporEmpleadoCFM = "AprobarTrans.cfm">
<cfif isdefined ('url.Tipo')>
	<cfset form.Tipo=#url.Tipo#>
</cfif>

<cfif isdefined ('url.CCHTrelacionada')>
	<cfset form.CCHTrelacionada=#url.CCHTrelacionada#>
</cfif>
<cfif isdefined ('url.GECid_comision')>
	<cfset form.idTransaccion=url.GECid_comision>
	<cfset form.CCHTrelacionada=url.GECid_comision>
	<cfset form.Tipo="COMISION">
</cfif>

	<cfif isdefined("form.Tipo")>
		<cfinclude template="AprobarTrans_form.cfm" >
	<cfelse>
		<cfinclude template="AprobarTrans_Lista.cfm">
	</cfif>
	
  <cf_web_portlet_end>
<cf_templatefooter>


