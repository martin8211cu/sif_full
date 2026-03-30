<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 06 de junio del 2005
	Motivo:	Nueva opción para Módulo de Tesorería, 
			Retención de cheques
----------->

<cf_templateheader title="Consulta de Cheques">
	<cf_navegacion name="TESOPid">
	<cf_navegacion name="CBid">
	<cf_navegacion name="TESMPcodigo">
	<cf_navegacion name="TESCFDnumFormulario">

	<cfset navegacion = "">
	<cfset tipoCheque = '<> 0'>
	<cfset titulo = 'Consulta de Cheques'>
	<cfif isdefined("form.TESCFDnumFormulario") and LEN(form.TESCFDnumFormulario)>
		<cfinclude template="consultaCheques_form.cfm">
	<cfelse>
		<cfset irA = 'consultaCheques.cfm'>
		<cfinclude template="listaCheques.cfm">
	</cfif>
<cf_templatefooter>