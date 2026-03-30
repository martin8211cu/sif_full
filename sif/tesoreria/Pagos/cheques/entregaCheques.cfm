<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 06 de junio del 2005
	Motivo:	Nueva opción para Módulo de Tesorería, 
			Entrega de cheques
----------->

<cf_templateheader title="Entrega de Cheques">
	<cfset titulo = 'Entrega de Cheques'>
	<cfset tipoCheque = '= 1'>
	<cfset irA = 'entregaCheques.cfm'>
	<cfset entrega = 1>
	<cf_navegacion name="TESOPid">
	<cfset navegacion = "">

	<cfif isdefined("form.TESOPid")>
		<cfinclude template="entregaCheques_form.cfm">
	<cfelse>
		<cfinclude template="listaCheques.cfm">
	</cfif>
<cf_templatefooter>