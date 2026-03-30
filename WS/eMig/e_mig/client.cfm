<cfset LvarCedulaJur = createObject("component","P_CedulaT")>

<cfset LvarCedulaJur.tipoCedula="J">
<cfset LvarCedulaJur.numeroCedula="3101260010">

<cfinvoke 	webservice="http://10.7.7.181:8001/soa-infra/services/default/estadoPersonas/getEstados?WSDL"
			method="getEstadosPersona"
			returnVariable="LvarResult"

			parameters="#LvarCedulaJur#"
>
<cfoutput>
	<strong>SERVICIO: http://10.7.7.181:8001/soa-infra/services/default/estadoPersonas/getEstados?WSDL</strong><BR>
	<BR>
	<strong>METODO:	getEstadosPersona</strong><BR>
	Nombre 	= #LvarResult.getNOMBRE()#<BR>
	Estado_RN	= #LvarResult.getESTADO_RN()#<BR>
	Estado_CCSS	= #LvarResult.getESTADO_CCSS()#<BR>
	Estado_TD	= #LvarResult.getESTADO_TD()#<BR>
</cfoutput>

<cfabort>


<cfset LvarCedulaJur = createObject("component","P_CedulaT")>

<cfset LvarCedulaJur.tipoCedula="J">
<cfset LvarCedulaJur.numeroCedula="3101260010">

<cfinvoke 	webservice="http://10.7.7.181:8001/soa-infra/services/default/juridica/getestados_client_ep?WSDL"
			method="process"
			returnVariable="LvarResult"

			payLoad="#LvarCedulaJur#"
>
<cfoutput>
	<strong>SERVICIO: http://10.7.7.181:8001/soa-infra/services/default/juridica/getestados_client_ep?WSDL</strong><BR>
	<BR>
	<strong>METODO:	process</strong><BR>
	Nombre 	= #LvarResult.getNOMBRE()#<BR>
	Estado_RN	= #LvarResult.getESTADO_RN()#<BR>
	Estado_CCSS	= #LvarResult.getESTADO_CCSS()#<BR>
	Estado_TD	= #LvarResult.getESTADO_TD()#<BR>
</cfoutput>

<cfabort>


<cfset LvarCedulaJur = createObject("component","P_CedulaT")>

<cfset LvarCedulaJur.tipoCedula="J">
<cfset LvarCedulaJur.numeroCedula="3101260010">

<cfinvoke 	webservice="http://10.7.7.181:7001/cfmx/WS/e_mig/emigWS.cfc?WSDL"
			method="getEstadosPersona"
			returnVariable="LvarResult"

			parameters="#LvarCedulaJur#"
>
<cfoutput>
	<strong>SERVICIO: http://10.7.7.181:7001/cfmx/WS/bus.cfc?WSDL</strong><BR>
	<BR>
	<strong>METODO:	getEstadosPersona</strong><BR>
	Nombre 	= #LvarResult.getNOMBRE()#<BR>
	Estado_RN	= #LvarResult.getESTADO_RN()#<BR>
	Estado_CCSS	= #LvarResult.getESTADO_CCSS()#<BR>
	Estado_TD	= #LvarResult.getESTADO_TD()#<BR>
</cfoutput>

<cfabort>

<cfinvoke 	webservice="http://10.7.7.181:8001/soa-infra/services/default/personaJuridica/getEstados?WSDL"
			method="getEstadosPersona"
			returnVariable="LvarResult"

			parameters="#LvarCedulaJur#"
>
<cfoutput>
	<strong>SERVICIO: http://10.7.7.181:8001/soa-infra/services/default/estadoPersonas/getEstados?WSDL</strong><BR>
	<BR>
	<strong>METODO:	getEstadosPersona</strong><BR>
	Nombre 	= #LvarResult.getNOMBRE()#<BR>
	Estado_RN	= #LvarResult.getESTADO_RN()#<BR>
	Estado_CCSS	= #LvarResult.getESTADO_CCSS()#<BR>
	Estado_TD	= #LvarResult.getESTADO_TD()#<BR>
</cfoutput>

<cfabort>
