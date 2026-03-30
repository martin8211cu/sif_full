<cf_templateheader title="Entrega de Cheques">
	<cfset titulo = 'Devolución de Cheques Entregados'>
	<cfset tipoCheque = '= 2'>
	<cfset irA = 'entregaChequesDevolver.cfm'>
	<cfset devolver = 1>
	<cf_navegacion name="TESOPid" navegacion = "">

	<cfif isdefined("form.TESOPid")>
		<cfinclude template="entregaCheques_form.cfm">
	<cfelse>
		<cfinclude template="listaCheques.cfm">
	</cfif>
<cf_templatefooter>