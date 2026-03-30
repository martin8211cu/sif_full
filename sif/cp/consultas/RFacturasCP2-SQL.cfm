<!--- necesario para convertir una fecha string '24/10/2002' en '20021024'  --->
<cffunction name="convertir_fecha" access="public" returntype="string">
<cfargument name="fecha" type="string" required="true">
	<cfset dia = Mid(fecha,1,2)>
	<cfset mes = Mid(fecha,4,2)>	
	<cfset anio = Mid(fecha,7,4)>	
	<cfset fechaConv = anio & mes & dia>			
	<cfreturn #fechaConv#>
</cffunction>

<CF_JasperReport DATASOURCE="#session.dsn#"
                 OUTPUT_FORMAT="#form.formato#"
                 JASPER_FILE="/sif/cc/consultas/RFacturasCC2.jasper">
	<CF_JasperParam name="Ecodigo"   value="#session.Ecodigo#">
	
	<cfif isdefined("Form.SNcodigo") and len(trim(Form.SNcodigo)) NEQ 0> 
		<CF_JasperParam name="SNcodigo" value="#form.SNcodigo#">		
		<CF_JasperParam name="SNnombre" value="#form.SNnombre#">
	</cfif>
	<!---<cfif isdefined("Form.fechaIni") and len(trim(Form.fechaIni)) NEQ 0> 
		<CF_JasperParam name="BMfecha" value="#convertir_fecha(form.fechaIni)#">
		<CF_JasperParam name="fechaIniLabel" value="#form.fechaIni#">
	</cfif>
	---> 
	<cfif isdefined("Form.fechaIni") and len(trim(Form.fechaIni)) NEQ 0> 
		<CF_JasperParam name="BMfecha" value="#form.fechaIni#">
		<CF_JasperParam name="fechaIniLabel" value="#form.fechaIni#">
	</cfif>
	<cfif isdefined("Form.CCTcodigo") and len(trim(Form.CCTcodigo)) NEQ 0> 
		<CF_JasperParam name="CCTcodigo" value="#form.CCTcodigo#">
	</cfif>
	
	<cfif isdefined("Form.Documento") and len(trim(Form.Documento)) NEQ 0> 
		<CF_JasperParam name="Ddocumento" value="%#Ucase(form.Documento)#%">
		<CF_JasperParam name="DdocumentoLabel" value="#form.Documento#">
	</cfif>	
</CF_JasperReport>
