<cfset fecha = dateformat(#now()#,"DD/MM/YYYY")>

<CF_JasperReport DATASOURCE="#session.dsn#"
                 OUTPUT_FORMAT="#form.formato#"
                 JASPER_FILE="/rh/nomina/consultas/RCargasHist.jasper">
	<CF_JasperParam name="Ecodigo"   value="#session.Ecodigo#">

	<CF_JasperParam name="RCNid"   value="#form.CPid#">
	<CF_JasperParam name="fechal"   value="#fecha#">	

	<cfif isdefined("Form.DEid") and len(trim(Form.DEid)) NEQ 0> 
		<CF_JasperParam name="DEid"   value="#form.DEid#">
	</cfif>
	<cfif isdefined("Form.ECid") and len(trim(Form.ECid)) NEQ 0> 
		<CF_JasperParam name="ECid"   value="#form.ECid#">
	</cfif>
</CF_JasperReport>
