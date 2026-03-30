<!--- FORMATO: html/pdf/xls --->

<CF_JasperReport DATASOURCE="#session.dsn#" 
            	 OUTPUT_FORMAT="#url.format#"
                 JASPER_FILE="/rh/evaluaciondes/consultas/ResumenCal.jasper">
	<CF_JasperParam name="Ecodigo" value="#session.Ecodigo#"> 
	<CF_JasperParam name="RHEEid" value="#url.RHEEid#"> 
	
</CF_JasperReport>
