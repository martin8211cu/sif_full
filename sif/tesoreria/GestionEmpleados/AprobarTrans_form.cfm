<cfif form.Tipo eq 'ANTICIPO'>
	<cfset form.GEAid= form.CCHTrelacionada>
	<cfset form.GECid_comision= "-1">
	<cfinclude template="AprobarTrans_formAnt.cfm" >
<cfelseif form.Tipo eq 'COMISION'>
	<cfset LvarComision = true>
	<cfset form.GECid_comision= form.CCHTrelacionada>
	<cfinclude template="AprobarTrans_formCom.cfm" >
<cfelseif find('GASTO',form.Tipo)>
	<cfset form.Tipo = 'GASTO'>
	<cfset form.GELid= form.CCHTrelacionada>
	<cfinclude template="AprobarTrans_formLiq.cfm">
</cfif>
