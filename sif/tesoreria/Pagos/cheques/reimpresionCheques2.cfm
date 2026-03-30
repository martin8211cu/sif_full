<cf_templateheader title="Reimpresión de Cheques de cualquier Dia">
	<cfset titulo = 'Reimpresión de Cheques de cualquier Dia'>
	<cfset tipoCheque = '= 1'>
	<cfset irA = 'reimpresionCheques2.cfm'>
	<cf_navegacion name="TESOPid">
	<cfset navegacion = "">

	<cfif isdefined("form.TESOPid")>
		<cfinclude template="reimpresionCheques2_form.cfm">
	<cfelse>
		<cfinclude template="listaCheques.cfm">
	</cfif>
<cf_templatefooter>