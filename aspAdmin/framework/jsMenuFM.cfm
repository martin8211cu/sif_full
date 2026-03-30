<cfif Compare(Session.tipoRolAdmin, 'sys.admin') EQ 0>
	<cfinclude template="../admin/jsMenuFM.cfm">
<cfelseif Compare(Session.tipoRolAdmin, 'sys.agente') EQ 0>
	<cfinclude template="../agente/jsMenuFM.cfm">
<cfelseif Compare(Session.tipoRolAdmin, 'sys.adminCuenta') EQ 0>
	<cfinclude template="../admCta/jsMenuFM.cfm">
</cfif>
