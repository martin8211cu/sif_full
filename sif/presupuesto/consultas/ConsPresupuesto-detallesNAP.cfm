<cf_templateheader title="Consulta de Numeros de Autorizaci&oacute;n Presupuestaria">
	<cf_web_portlet_start titulo="Consulta de Numeros de Autorizaci&oacute;n Presupuestaria">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<cfif isdefined("url.CPNAPDlinea") and Len(Trim(url.CPNAPDlinea))>
			<cfset form.CPNAPDlinea = url.CPNAPDlinea>
		</cfif>
		<cfif isdefined("url.CPNAPnum") and Len(Trim(url.CPNAPnum))>
			<cfset form.CPNAPnum = url.CPNAPnum>
		</cfif>
		
		<cfif isdefined("Form.CPNAPnum") and isdefined("Form.CPNAPDlinea")
		  and Len(Trim(Form.CPNAPnum)) and Len(Trim(Form.CPNAPDlinea))>
			<cfinclude template="ConsNAP-form.cfm">
		<cfelse>
			<cfinclude template="ConsPresupuesto-detallesNAP-form.cfm">
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>
