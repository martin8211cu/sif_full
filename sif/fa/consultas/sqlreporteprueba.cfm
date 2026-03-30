<cfset session.dsn = "sif_pmi_pruebas">
<cfset session.DATASOURCE = "sif_pmi_pruebas">
<cfset codigo = "/sif/reportes/" & form.codigo >
<CF_JasperReport DATASOURCE="sif_pmi_pruebas"
                 OUTPUT_FORMAT="pdf"
                 JASPER_FILE="#codigo#">
	<CF_JasperParam name="Ecodigo"   value="37">
	<CF_JasperParam name="Dreferencia"  value="1">
<!---	<CF_JasperParam name="FCid"   value="13">
	<CF_JasperParam name="ETnumero"   value="11">--->
</CF_JasperReport>