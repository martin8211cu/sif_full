<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 30 de junio del 2005
	Motivo:	Nueva opción para Módulo de Tesorería, 
			Entrega de cheques en custodia
----------->

<cf_templateheader title="Consulta de Cheques">
	<cf_navegacion name="TESOPid">
	<cfset navegacion = "">
	<cfset tipoCheque = '= 1'>
	<cfset custodia = 1>
	<cfset titulo = 'Entrega de Cheques en Custodia'>
	<cfif isdefined("form.TESCFDnumFormulario") and LEN(form.TESCFDnumFormulario)>
		<cfinclude template="entregaCheques_form.cfm">
	<cfelse>
		<cfset irA = 'entregaChequesCustodia.cfm'>
		<cfinclude template="listaCheques.cfm">
	</cfif>
<cf_templatefooter>