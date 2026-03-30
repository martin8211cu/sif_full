<cfset LvarTipoDocumento = 7>
<cf_GE_lista tipo="#LvarTipoDocumento#" Estado="4" ListarCancelados="no" irA="CancLIQGE.cfm" PorEmpleado="#isdefined("LvarSAporEmpleado")#" 
PorSolicitante="#isdefined("LvarSAporEmpleadoSolicitante")#" FormaPago="TES" CancelacionLiq="true">
