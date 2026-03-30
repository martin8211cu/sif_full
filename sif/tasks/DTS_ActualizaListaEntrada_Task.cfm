<!--- <cfdump var="#now()#">
<br /> --->

<cfinvoke component="sif.QPass.Componentes.QPVerificaSaldos" returnvariable="Resultado" method="fnConsultaSaldosInterfaz">
	<cfinvokeargument name="Conexion" value="minisif">
    <cfinvokeargument name="Ecodigo" value="2"><!--- 2 Produccion HSBC --->
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