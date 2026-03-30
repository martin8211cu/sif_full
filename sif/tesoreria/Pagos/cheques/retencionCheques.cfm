<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 06 de junio del 2005
	Motivo:	Nueva opción para Módulo de Tesorería, 
			Retención de cheques
----------->

<cf_templateheader title="Retención de Cheques">
	<cf_navegacion name="TESOPid">
	<cfset navegacion = "">
	<cfset titulo = 'Retención de Cheques'>
	<cfset tipoCheque = '= 1'>
	<cfset retencion = 1>
	<cfset irA = 'retencionCheques.cfm'>
	<cfif isdefined("form.TESOPid") and LEN(form.TESOPid)>
		<cfinclude template="retencionCheques_form.cfm">
	<cfelse>
		<cfinclude template="listaCheques.cfm">
	</cfif>
<cf_templatefooter>