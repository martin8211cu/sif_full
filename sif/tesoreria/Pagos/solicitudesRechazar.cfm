<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 01 de junio del 2005
	Motivo:	Nueva opción para Módulo de Tesorería, 
			Rechazo de Solicitudes de Pago en Tesorería
----------->
<cfinvoke key="LB_Titulo" default="Rechazo de Solicitudes de Pago"	returnvariable="LB_Titulo"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="solicitudesRechazar.xml"/>
<cf_templateheader title="#LB_Titulo#">
	<cf_navegacion name="TESOPid">
	<cfset navegacion = "">

	<cfif isdefined("form.TESSPid") or isdefined ("url.TESSPid")>
		<cfinclude template="solicitudesRechazar_form.cfm">
	<cfelse>
		<cfinclude template="solicitudesRechazar_lista.cfm">
	</cfif>
<cf_templatefooter>