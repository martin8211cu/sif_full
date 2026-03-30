<cf_templateheader title="Aprobación Transacciones"> 
<cfinclude template="TESid_Ecodigo.cfm">
<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>
	<cfset titulo = 'Aprobación Transacciones'>
  <cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">

<cfset LvarSAporEmpleadoCFM = "AprobarTrans.cfm">
<cfif isdefined ('url.Tipo')>
	<cfset form.Tipo=#url.Tipo#>
</cfif>

<cfif isdefined ('url.CCHTrelacionada')>
	<cfset form.CCHTrelacionada=#url.CCHTrelacionada#>
</cfif>
<cfif isdefined ('url.GECid')>
	<cfset form.idTransaccion=url.GECid>
	<cfset form.CCHTrelacionada=url.GECid>
	<cfset form.Tipo="COMISION">
</cfif>


	<!---Aprueba Liquidaciones--->
	<cfif isdefined ('url.Aprobar')>
		<cfif url.LvarTipo eq 'ANTICIPO'>	
			<cfinclude template="AprobacionAnticipos.cfm">
		</cfif>
		
	<!---Aprueba Anticipos--->
	<cfelseif isdefined("form.Tipo")>
		<cfinclude template="AprobarTrans_form.cfm" >
	<cfelse>
		<cfinclude template="AprobarTrans_Lista.cfm">
	</cfif>
	
  <cf_web_portlet_end>
<cf_templatefooter>


