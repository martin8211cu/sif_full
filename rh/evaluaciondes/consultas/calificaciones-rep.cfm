<!--- FORMATO: html/pdf/xls --->
<!--- <cfdump var="#url#">
<cfabort> --->
<cfsetting requesttimeout="36000">

<CF_JasperReport DATASOURCE="#session.dsn#" 
            	 OUTPUT_FORMAT="#url.format#"
                 JASPER_FILE="/rh/evaluaciondes/consultas/Calificacion.jasper">
	<CF_JasperParam name="Ecodigo" value="#session.Ecodigo#"> 
	<CF_JasperParam name="RHEEid" value="#url.RHEEid#"> 
	<CF_JasperParam name="id_centro" value="#url.id_centro#"> 
	
</CF_JasperReport>