<cfif form.tipo EQ "ANTICIPO">
	<cfinclude template="AprobarTrans_sqlAnt.cfm">
<cfelseif form.tipo EQ "COMISION">
	<cfinclude template="AprobarTrans_sqlCom.cfm">
<cfelseif form.tipo EQ "GASTO">
	<cfinclude template="AprobarTrans_sqlLiq.cfm">
</cfif>
