<cfparam name="RCNid" type="any"   default=" ">
<cfparam name="Ecodigo" type="any"  default=" ">
<cfparam name="CIcodigo"  type="any"  default=" ">
<cfparam name="CIcodigo"  type="any" default=" ">


<cfset fechaA = dateformat(#now()#,"DD/MM/YYYY")>

<CF_JasperReport DATASOURCE="#session.dsn#"
                 OUTPUT_FORMAT="#form.formato#"
                 JASPER_FILE="/rh/nomina/consultas/RHIncidencias.jasper">
	<CF_JasperParam name="Ecodigo"   value="#session.Ecodigo#">

	<CF_JasperParam name="RCNid"   value="#form.CPid#">

	<CF_JasperParam name="fechal"   value="#fechaA#">

	<cfif isdefined("Form.CIcodigo") and len(trim(Form.CIcodigo)) NEQ 0>
		<CF_JasperParam name="CIidA"   value="#form.CIid#">
	</cfif>

	<cfif isdefined("Form.CIcodigo") and len(trim(Form.CIcodigo)) NEQ 0> 
		<CF_JasperParam name="CIcodigo"   value="#form.CIcodigo#">
	</cfif>
		<!--- <CF_JasperParam name="DEid"   value="4839"> --->
</CF_JasperReport>
