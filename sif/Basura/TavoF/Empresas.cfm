<cfquery name="rsEmpresas" datasource="minisif">
SELECT * from Empresas where Ecodigo < 5 
</cfquery>
<CFREPORT format="flashpaper" template="Empresas.cfr" query="rsEmpresas">
as