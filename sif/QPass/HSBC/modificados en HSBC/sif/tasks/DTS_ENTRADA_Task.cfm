<!--- <cfdump var="#now()#">
<br /> --->

<cfinvoke component="sif.QPass.Componentes.QPProcesaDatos" returnvariable="Resultado" method="fnEnviaDatosInterfaz">
	<cfinvokeargument name="Conexion" value="minisif">
    <cfinvokeargument name="Ecodigo" value="1"><!--- Va fijo 1 desarrollo, 2 Produccion HSBC --->
    <!--- <cfinvokeargument name="Conexion" value="#minisif_qp#"> este para HSBC --->
</cfinvoke>

<!--- <cfquery name="paradump" datasource="minisif">
	select * 
    from QPParametros
    where Ecodigo = 1
</cfquery>

<cfdump var="#Resultado#">
<br />
<cfdump var="#paradump#">

<br />

<cfdump var="#now()#">
<br /> --->