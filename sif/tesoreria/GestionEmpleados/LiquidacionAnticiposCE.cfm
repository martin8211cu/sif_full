<cfset LvarSAporComision = true>	
<cfset LvarSAporEmpleadoCFM = "LiquidacionAnticiposCE.cfm">
<cfset LvarSAporEmpleadoSQL = "CE">
<cfset titulo = 'Preparación Liquidaciones al Empleado'>
<cfif NOT isdefined("form.GECid_comision") AND isdefined("session.Tesoreria.GECid")>
	<cfset form.GECid_comision = session.Tesoreria.GECid>
<cfelseif isdefined("form.GECid_comision") AND NOT isdefined("session.Tesoreria.GECid")>
	<cfset session.Tesoreria.GECid = form.GECid_comision>
</cfif>

<cfset LvarSAporEmpleado = true>	
<cfinclude template="LiquidacionAnticipos_ini.cfm">
