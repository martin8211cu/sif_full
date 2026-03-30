<!--- 
	Módulo    : Contabilidad General
	Nombre    : Reporte de Asientos Aplicados y Pendientes
	Hecho por : Randall Colomer en SOIN
	Creado    : 21/07/2006
 --->

<cfif isdefined("form.tipoReporte") and trim(form.tipoReporte) EQ 1>
	<cfif isdefined("form.verReporte") and trim(form.verReporte) EQ 1>
		<cfinclude template="AsientosAplicadosResumido.cfm">
	<cfelse>
		<cfinclude template="AsientosAplicadosDetallado.cfm">
	</cfif>
<cfelse>
	<cfif isdefined("form.verReporte") and trim(form.verReporte) EQ 1>
		<cfinclude template="AsientosPendientesResumido.cfm">
	<cfelse>
		<cfinclude template="AsientosPendientesDetallado.cfm">
	</cfif>
</cfif>

