<cfset variable = 1>
<cfset LvarTituloReporte = "Transacciones Aplicadas">
<cfset LvarCondicion1     = " and coalesce(a.GATeliminado, 0) <> 1">
<cfinclude template="gabtransaccionesRep_Salida.cfm">
