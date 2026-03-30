<cfparam name="form.tipo" default="">
<cfparam name="form.cedula" default="">
<form action="client.cfm" method="post">
	Tipo:&nbsp;&nbsp;&nbsp;&nbsp;
		<select name="tipo">
			<option value="J">Juridica</option>
			<option value="F">Fisica</option>
		</select><BR>
	Cedula: <input name="cedula" size="10" value="<cfoutput>#form.cedula#</cfoutput>"/><BR>
	<input type="submit" value="Consultar" />
</form>
<cfif form.cedula NEQ "">
	<cfset LvarCedulaJur = createObject("component","P_Cedula")>

	<cfset LvarCedulaJur.tipoCedula=form.tipo>
	<cfset LvarCedulaJur.numeroCedula=form.cedula>
	<cfinvoke 	webservice="http://localhost:8001/soa-infra/services/default/estadosPersona/consultarWS?WSDL"
				method="getEstadosPersona"
				returnVariable="LvarResult"
	
				parameters="#LvarCedulaJur#"
	>
	<cfoutput>
		<strong>SERVICIO: http://localhost:8001/soa-infra/services/default/estadosPersona/consultarWS?WSDL</strong><BR>
		<BR>
		<strong>METODO:	getEstadosPersona</strong><BR>
		Nombre 	= #LvarResult.getNOMBRE()#<BR>
		Estado_RN	= #LvarResult.getESTADO_RN()#<BR>
		Estado_CCSS	= #LvarResult.getESTADO_CCSS()#<BR>
		Estado_TD	= #LvarResult.getESTADO_TD()#<BR>
	</cfoutput>
	<br><br>
	<IMG src="e_mig/e_mig.JPG" />
</cfif>

<cfabort>

<cfset LvarCedulaJur = createObject("component","P_CedulaT")>
<cfset LvarCedulaJur.tipoCedula="J">
<cfset LvarCedulaJur.numeroCedula="3101260010">
<cfinvoke 	webservice="http://10.7.7.181:7001/cfmx/WS/bus.cfc?WSDL"
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

