<cfparam name="LvarTESTILestado" default="0">
<cfif LvarTESTILestado EQ 0>
	<cfset titulo = 'Registro de Transferencias Bancarias'>
<cfelse>
	<cfset titulo = 'Solicitud de Pago de Transferencias Bancarias'>			
</cfif>
<cf_templateheader title="#titulo#">
	<cf_navegacion name="TESTILid">
	<cfset navegacion = "">
	<cfif isdefined("form.TESTILid") and LEN(form.TESTILid) or isdefined('Form.btnNuevo')>
		<cfinclude template="Transferencias_form.cfm">
	<cfelse>
		<cfinclude template="Transferencias_list.cfm">
	</cfif>
<cf_templatefooter>