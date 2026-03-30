<cf_templateheader title="Cancelación de Solicitudes de Viaticos por Comisión"> 
<cfinclude template="TESid_Ecodigo.cfm">
<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>
	<cfset titulo = 'Cancelación de Solicitudes de Viaticos por Comisión'>
  <cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">

<cfset LvarSAporEmpleadoCFM = "CancelacionComision.cfm">
<cfset Cancela = "1">
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

	<cfif isdefined("form.Tipo") and isdefined('form.GEAid')>

   
		<cfinclude template="CancelacionAnticipo_form.cfm" >

	<cfelse>
		<cfinclude template="CancelacionAnticipo_lista.cfm">
	</cfif>
	
  <cf_web_portlet_end>
<cf_templatefooter>



	


