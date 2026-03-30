<!--- <cfdump var="#now()#">
<br /> --->

<cfinvoke component="sif.QPass.Componentes.QPAfectaSaldos" returnvariable="Resultado" method="ProcesaMovimiento">
	<!--- <cfinvokeargument name="Conexion" value="minisif"> Para Pruebas en SOIN --->
     <cfinvokeargument name="Conexion" value="minisif">
</cfinvoke>

<!--- <cfquery name="paradump" datasource="minisif">
	select * 
    from QPParametros
    where Ecodigo = 0
</cfquery>

<cfdump var="#Resultado#">
<br />
<cfdump var="#paradump#">
<br />
<cfdump var="#application.QPaplicandoprocesamovimiento#">

<br />
<cfdump var="#application.QPfechaprocesamovimiento#">
<br />

<cfdump var="#now()#">
<br /> --->