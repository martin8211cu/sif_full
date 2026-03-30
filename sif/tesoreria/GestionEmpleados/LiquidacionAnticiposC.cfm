<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_TituloPreparacionDeLiquidaciones" default = "Preparaci&oacute;n de Liquidaciones de Empleados" returnvariable="LB_TituloPreparacionDeLiquidaciones" xmlfile = "LiquidacionAnticiposC.xml">

<cfset LvarSAporComision = true	> 
<cfset LvarSAporEmpleadoCFM = "LiquidacionAnticiposC.cfm">
<cfset LvarSAporEmpleadoSQL = "C">
<cfset titulo = '#LB_TituloPreparacionDeLiquidaciones#'>
<cfif NOT isdefined("form.GECid_comision") AND isdefined("session.Tesoreria.GECid")>
	<cfset form.GECid_comision = session.Tesoreria.GECid>	
<cfelseif isdefined("form.GECid_comision") AND NOT isdefined("session.Tesoreria.GECid")>
	<cfset session.Tesoreria.GECid = form.GECid_comision>
</cfif>

<cfinclude template="LiquidacionAnticipos_ini.cfm">
