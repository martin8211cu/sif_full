<cfif form.Tipo eq 'ANTICIPO'>
	<cfset form.GEAid= form.CCHTrelacionada>
	<cfset form.GECid= "-1">
	<cfinclude template="AprobarTrans_formAnt.cfm" >
<cfelseif form.Tipo eq 'COMISION'>
	<cfset LvarComision = true>
	<cfset form.GECid= form.CCHTrelacionada>
	<cfinclude template="AprobarTrans_formCom.cfm" >
<cfelseif form.Tipo eq 'GASTO'>
	<cfset form.GELid= form.CCHTrelacionada> 
	<cfinclude template="AprobarTrans_formLiq.cfm">
</cfif>	
