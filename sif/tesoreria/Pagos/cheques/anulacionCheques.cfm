<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 16 de junio del 2005
	Motivo:	Nueva opción para Módulo de Tesorería, 
			Anulación de cheques
----------->


<cf_templateheader title="Anulación de Cheques">
	<cf_navegacion name="TESOPid">
	<cfset navegacion = "">
	<cfset titulo = 'Anulaci&oacute;n de Cheques'>
	<cfset tipoCheque = '= 1'>
	<cfset anulacion = 1>
	<cfif isdefined("GvarAnulacionEspecial")>
		<cfset irA = 'anulacionCheques2.cfm'>
	<cfelse>
		<cfset irA = 'anulacionCheques.cfm'>
	</cfif>
	<cfif isdefined("form.TESOPid") and LEN(form.TESOPid)>
		<cfinclude template="anulacionCheques_form.cfm">
	<cfelse>
		<cfinclude template="listaCheques.cfm">
	</cfif>
<cf_templatefooter>