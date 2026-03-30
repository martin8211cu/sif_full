<cfset LvarCedula = createObject("component","P_Cedula")>
<!--- 0=Fisica 2=Juridica 7=ExtranjeroCCSS --->
<cfset LvarCedula.pTipPatrono="1">
<cfset LvarCedula.pNumPatrono="106880777">
<cfset LvarCedula.pTipPatrono="2">
<cfset LvarCedula.pNumPatrono="3101260010">
<cfset LvarCedula.pTipPatrono="2">
<cfset LvarCedula.pNumPatrono="3101204411">
<cfset LvarCedula.pTipPatrono="0">
<cfset LvarCedula.pNumPatrono="206010759">
<cfset LvarCedula.pTipPatrono="0">
<cfset LvarCedula.pNumPatrono="106880721">
<cfset LvarCedula.pTipPatrono="2">
<cfset LvarCedula.pNumPatrono="3101260010">

<cfset LvarCedula.pTipPatrono="2">
<cfset LvarCedula.pNumPatrono="3101069227">
<cfinvoke 	webservice="https://ccsssjapp03.ccss.sa.cr/ConsultaMorosidadWS/ConsultaMorosoWSSoapHttpPort?WSDL"
			method="verificaMorosidadWeb"
			returnVariable="LvarResult"

			parameters="#LvarCedula#"
>
<cfset LvarResult = LvarResult.getResult()>

<cfoutput>
	<strong>SERVICIO: https://ccsssjapp03.ccss.sa.cr/ConsultaMorosidadWS/ConsultaMorosoWSSoapHttpPort?WSDL</strong><BR>
	<BR>
	<strong>METODO:	verificaMorosidadWeb</strong><BR>
	resultado = #LvarResult.getPresultadoOut()#<BR>
	nom patrono	= #LvarResult.getPnompatronoOut()#<BR>
	esta activo = #LvarResult.getPindactivoOut()#<BR>
	esta moroso = #LvarResult.getPindmorosoOut()#<BR>
	monto total = #LvarResult.getPmonttotalOut()#<BR>
	cant.facturas = #LvarResult.getPcantfacturasOut()#<BR>
</cfoutput>
