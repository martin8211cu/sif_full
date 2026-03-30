<!---------
	Modificado por: Ana Villavicencio
	Fecha de modificación: 17 de mayo del 2005
	Motivo:	Se agrego un nuevo paso en le proceso de conciliación bancaria. 
			Se agrego una nueva pagina para Conciliacion Automatica
----------->

<!----
		Modificado por Hector Garcia Beita
		Motivo: validador para la redirección en caso de ser invocada desde la 
		opcion de conciliacion bancaria de el modulo de tarjetas de
		credito empresariales mediante un include
--->
<cfset LvarIrAConcAuto="ConciliacionAutomatica.cfm">
<cfset LvarIrAConciliacion="Conciliacion.cfm">
<cfset LvarIrAlistECP="listaEstadosCuentaEnProceso.cfm">
<cfset LvarIrAConcLibre="Conciliacion-Libre.cfm">
<cfset LvarIrAListaPreConci="listaPreConciliacion.cfm">
<cfset LvarIrAresumenConci="resumenConciliacion.cfm">
 <cfif isdefined("LvarTCEFrameConfig")>
 	<cfset LvarIrAConcAuto="TCEConciliacionAutomatica.cfm">
	<cfset LvarIrAConciliacion="TCEConciliacion.cfm">
	<cfset LvarIrAlistECP="listaEstadosCuentaProcesoTCE.cfm">
	<cfset LvarIrAConcLibre="TCEConciliacion-Libre.cfm">
	<cfset LvarIrAListaPreConci="TCElistaPreConciliacion.cfm">
	<cfset LvarIrAresumenConci="TCEresumenConciliacion.cfm">
 </cfif>

<cfif not isdefined("Session.Progreso")>
	<cfset Session.Progreso = StructNew()>
</cfif>


<cfset pagina = #GetFileFromPath(GetTemplatePath())#>

<cfif pagina EQ "#LvarIrAlistECP#">
	<cfset Session.Progreso.Pantalla = "1">
<cfelseif pagina EQ "#LvarIrAConcAuto#">
	<cfset Session.Progreso.Pantalla = "2">
<cfelseif pagina EQ "#LvarIrAConciliacion#">
	<cfset Session.Progreso.Pantalla = "3">
<cfelseif pagina EQ "#LvarIrAConcLibre#">
	<cfset Session.Progreso.Pantalla = "4">
<cfelseif pagina EQ "#LvarIrAListaPreConci#">
	<cfset Session.Progreso.Pantalla = "5">
<cfelseif pagina EQ "#LvarIrAresumenConci#">
	<cfset Session.Progreso.Pantalla = "6">
</cfif>
<!---<cf_dump var=#Session.Progreso.Pantalla#>--->