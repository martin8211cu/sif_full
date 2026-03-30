<cfif isdefined("form.CtrlConsulta") and form.CtrlConsulta EQ 1>
	<cfset params = "&GEid=#form.GEid#&periodo=#form.periodo#&mes=#form.mes#&nivel=#form.nivel#&tipo=#form.tipo#&Mcodigo=#form.Mcodigo#">
    <cfinclude template="consolidado-cuentas-impr.cfm">
<cfelse>
	<cfinclude template="consolidado-cuentas-filtro.cfm">
</cfif>