<cfset LvarCedula="107780778">

<cfinvoke 	webservice="http://10.7.7.181:7001/cfmx/WS/TD/tributacionWS.cfc?WSDL"
			method="getStatusF"
			returnVariable="LvarResult"

			tCedula="#LvarCedula#"
>
<cfoutput>
	<strong>SERVICIO: http://10.7.7.181:7001/cfmx/WS/TD/tributacionWS.cfc?WSDL</strong><BR>
	<BR>
	<strong>METODO:	getStatusF</strong><BR>
	cedula = #LvarResult.rCedula#<BR>
	nombre	= #LvarResult.rNombre#<BR>
	apellido1 = #LvarResult.rApellido1#<BR>
	apellido2 = #LvarResult.rApellido2#<BR>
	status = #LvarResult.rStatus#<BR>
</cfoutput>

<cfset LvarCedula="3101260010">

<cfinvoke 	webservice="http://10.7.7.181:7001/cfmx/WS/TD/tributacionWS.cfc?WSDL"
			method="getStatusJ"
			returnVariable="LvarResult"

			tCedulaJ="#LvarCedula#"
>
<cfoutput>
	<BR>
	<strong>METODO:	getStatusJ</strong><BR>
	cedula = #LvarResult.rCedulaJ#<BR>
	nombre	= #LvarResult.rNombreJ#<BR>
	status = #LvarResult.rStatusJ#<BR>
</cfoutput>
