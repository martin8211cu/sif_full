<!--- <cfinvoke component="sif.Basura.marcel.flexquery" method="dEmpresas" returnvariable="salida">
 --->
 
  <cfobject webservice="http://desarrollo/cfmx/sif/Basura/marcel/flexquery.cfc?wsdl"
  name="flexquery">

 <cfinvoke webservice="#flexquery#" 
 	method="dEmpresas" 
	returnVariable="salida"
 > 
 <cfdump var="#salida#">
 <!--- 

 <cfinvoke 
	webservice = "http://desarrollo/cfmx/sif/Basura/marcel/flexquery.cfc?wsdl"
	method = "ejemplo"
	returnVariable = "salida"
>

--->