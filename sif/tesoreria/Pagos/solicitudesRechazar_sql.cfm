<!---<cfdump var="#form#">
<cfdump var="aa">
<cf_dump var="#url#">
--->

<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 01 de junio del 2005
	Motivo:	Nueva opción para Módulo de Tesorería, 
			Rechazo de Solicitudes de Pago en Tesorería
----------->

<cfif IsDefined("form.Rechazar")>
	<cfinvoke 	component		= "sif.tesoreria.Componentes.TESaplicacion"
				method			= "sbRechazarSPaprobada"
				
				DSN				= "#session.dsn#"
				Ecodigo			= "#session.Ecodigo#"
				TESSPid			= "#form.TESSPid#"
				TESOPid			= "-1"
				TESSPmsgRechazo	= "#form.TESSPmsgRechazo#"
	>
<cfelseif IsDefined("form.Nuevo")>
	<!--- Tratar como form.nuevo --->
	<cfset form.PASO = 0>
<!--- Comunes --->
<cfelseif IsDefined("form.btnLista_Solicitudes")>
	<cfset form.PASO = 0>
</cfif>
<cflocation url="solicitudesRechazar.cfm">


