<cfif form.Tipo eq 'ANTICIPO'>
	<cfset form.GEAid= form.CCHTrelacionada>
	<cfset form.GECid_comision= "-1">
	<cfinclude template="imprSolicAnticipoCOM.cfm" >
<cfelseif form.Tipo eq 'COMISION'>
	<cfset LvarComision = true>
	<cfset form.GECid_comision= form.CCHTrelacionada>
	<cfinclude template="LiquidacionImpresion_form.cfm" >
<cfelseif find('GASTO',form.Tipo)>
	<cfset form.Tipo = 'GASTO'>
	<cfset form.GELid= form.CCHTrelacionada> 
	<cfinclude template="AprobarTrans_formLiq.cfm">
</cfif>	
