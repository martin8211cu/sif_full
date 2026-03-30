<!--- <cfdump var="#form#">
<cfabort> --->

<cfset fecha = dateformat(#now()#,"DD/MM/YYYY")>

<CF_JasperReport DATASOURCE="#session.dsn#"
                 OUTPUT_FORMAT="#form.formato#"
                 JASPER_FILE="/rh/nomina/consultas/RDeducHist.jasper">
	<CF_JasperParam name="Ecodigo"   value="#session.Ecodigo#">

	<CF_JasperParam name="RCNid"   value="#form.CPid#">
	<CF_JasperParam name="fechal"   value="#fecha#">

	<cfif isdefined("Form.TDid") and len(trim(Form.TDid)) NEQ 0> 
		<CF_JasperParam name="TDid"   value="#form.TDid#">
	</cfif>
		<!--- <CF_JasperParam name="DEid"   value="4839"> --->
</CF_JasperReport>
