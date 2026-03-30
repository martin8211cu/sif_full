<!--- <cfinvoke component="sif.Basura.marcel.flexquery" returnvariable="salida" method="dEmpresas"> --->
<cfinvoke 
	webservice = "http://desarrollo/cfmx/sif/Basura/marcel/flexquery.cfc?wsdl"
	method = "dEmpresas"
	returnVariable = "salida">

<!--- <cfdump var="#salida#"> --->