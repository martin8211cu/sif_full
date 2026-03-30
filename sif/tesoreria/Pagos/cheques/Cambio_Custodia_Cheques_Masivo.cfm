<!---
	Creado por: Gustavo Fonseca Hernández
	Fecha: 22 de junio del 2005
	Motivo: Nueva opción para Módulo de Tesorería, Cambio Custodia de Cheques.
--->

<cf_templateheader title="Cambio Custodia de Cheques Masivo">
	<cfset titulo = 'Cambio Custodia de Cheques'>
	<cfset tipoCheque = '= 1'>
	<cfset irA = 'Cambio_Custodia_Cheques_Masivo.cfm'>
	<cfset custodia = 1>
	<cf_navegacion name="TESOPid">
	<cfset navegacion = "">

	<cfif isdefined("form.TESOPid")>
		<cfinclude template="Cambio_Custodia_Cheques_Masivo_form.cfm">
	<cfelse>
		<cfinclude template="listaChequesMasivo.cfm">
	</cfif>
<cf_templatefooter>