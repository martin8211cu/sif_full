<cfif isdefined("url.OPnum")>
	<script language="javascript">
		alert('Se generó la Orden de Pago Num.<cfoutput>#url.OPnum#</cfoutput>');
	</script>
<cfelseif isdefined("url.TESTILid")>
	<script language="javascript">
		alert('Se generó el Lote de Registro de Transferencias entre Cuentas Bancarias Num.<cfoutput>#url.TESTILid#</cfoutput>. Debe aplicarlo después de realizar la Transferencia en el Banco.');
	</script>
</cfif>
<cf_templateheader title="Reintegros de Cuentas Bancarias"> 
	<cf_navegacion name="Config" navegacion="">
	<cfparam name="Attributes.entrada"		default="">
	
	<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>		  
	<cfset titulo = 'Reintegros de Cuentas Bancarias'>			
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">																						
	<cfif (isdefined ('form.TESRnumero') and len(trim(form.TESRnumero)) gt 0)  or isdefined ('url.TESRnumero') or isdefined ('form.Nuevo') or isdefined ('form.btnNuevo') or isdefined ('url.Nuevo')>
		<cfinclude template="CCHReintegroCc_form.cfm"> 
	<cfelse>
		<cfinclude template="CCHReintegroCc_lista.cfm">
	</cfif>			
	<cf_web_portlet_end>
<cf_templatefooter>
