<cfset LvarCedulaJur = createObject("component","P_CedulaJuridica")>

<cfset LvarCedulaJur.N_TIPOCEDULA="3">
<cfset LvarCedulaJur.N_CLASECEDULA="101">
<cfset LvarCedulaJur.N_CONSEC_CEDULA="260010">

<cfinvoke 	webservice="http://10.7.7.181:7001/cfmx/WS/RN/PersonasJuridicasWS.cfc?WSDL"
			method="getPersonaJuridica"
			returnVariable="LvarResult"

			parameters="#LvarCedulaJur#"
>
<cfoutput>
	<strong>SERVICIO: http://10.7.7.181:7001/cfmx/WS/RN/PersonasJuridicasWS.cfc?WSDL</strong><BR>
	<BR>
	<strong>METODO:	getPersonaJuridica</strong><BR>
	Razón Social = #LvarResult.A_RAZONSOCIAL#<BR>
	tomo	= #LvarResult.tomo#<BR>
	asiento = #LvarResult.asiento#<BR>
	otorga poder = #LvarResult.N_IND_OTORGARPODER#<BR>
	inscripcion = #LvarResult.F_INSCRIPCION# #LvarResult.H_INSCRIPCION#<BR>
	inicio = #LvarResult.F_INICIO#<BR>
	vencimiento = #LvarResult.F_VENCIMIENTO#<BR>
	estado actual = #LvarResult.C_ESTADOACTUAL#<BR>
	expediente = #LvarResult.A_EXPEDIENTE#<BR>
	domicilio = #LvarResult.A_DOMICILIO#<BR>
	fines = #LvarResult.A_FINES#<BR>
</cfoutput>

<cfinvoke 	webservice="http://10.7.7.181:7001/cfmx/WS/RN/PersonasJuridicasWS.cfc?WSDL"
			method="getCapital"
			returnVariable="LvarResult"

			parameters="#LvarCedulaJur#"
>
<cfoutput>
	<BR>
	<strong>METODO:	getCapital</strong><BR>
	<cfloop index="i" from="1" to="#arrayLen(LvarResult)#">
		i = #i#<BR>
		consecutivo	= #LvarResult[i].N_CONSECUTIVO_TITULO#<BR>
		clase accion	= #LvarResult[i].C_CLASEACCION#<BR>
		tipo capital	= #LvarResult[i].C_TIPOCAPITAL#<BR>
		tipo moneda	= #LvarResult[i].C_TIPOMONEDA#<BR>
		monto	= #LvarResult[i].N_MONTO#<BR>
		cantidad	= #LvarResult[i].N_CANTIDAD#<BR>
		tomo inscr	= #LvarResult[i].N_TOMOINSCAP#<BR>
		asiento inscr	= #LvarResult[i].N_ASIENTOINSCAP#<BR>
		inscripcion = #LvarResult[i].F_INSCRIPCION# #LvarResult[i].H_INSCRIPCION#<BR>
		accion	= #LvarResult[i].D_ACCION#<BR>
	</cfloop>
</cfoutput>

<cfinvoke 	webservice="http://10.7.7.181:7001/cfmx/WS/RN/PersonasJuridicasWS.cfc?WSDL"
			method="getNombramientos"
			returnVariable="LvarResult"

			parameters="#LvarCedulaJur#"
>
<cfoutput>
	<BR>
	<strong>METODO:	getNombramientos</strong><BR>
	<cfloop index="i" from="1" to="#arrayLen(LvarResult)#">
		i = #i#<BR>
		consecutivo	= #LvarResult[i].N_CONSECUTIVOPARTE#<BR>
		tomo inscr	= #LvarResult[i].N_TOMOINSPARTE#<BR>
		asiento inscr	= #LvarResult[i].N_ASIENTOINSPARTE#<BR>
		inscripcion = #LvarResult[i].F_INSCRIPCION# #LvarResult[i].H_INSCRIPCION#<BR>
		tipo parte	= #LvarResult[i].C_TIPOPARTE#<BR>
		representacion	= #LvarResult[i].C_REPRESENTAC#<BR>
		ind junta dir	= #LvarResult[i].N_IND_JUNTA_DIR#<BR>
		identificacion	= #LvarResult[i].C_IDENTIFICACION#<BR>
		num identifica	= #LvarResult[i].A_NUM_IDENTIFICACION#<BR>
		tipo ced	= #LvarResult[i].N_TIPOCED_MIEMBRO#<BR>
		clase ced	= #LvarResult[i].N_CLASECED_MIEMBRO#<BR>
		consc ced	= #LvarResult[i].N_CONSCED_MIEMBRO#<BR>
		estado civil	= #LvarResult[i].C_ESTADOCIVIL#<BR>
		domicilio	= #LvarResult[i].C_DOMICILIO#<BR>
		inicio = #LvarResult[i].F_INICIO#<BR>
		vencimiento = #LvarResult[i].F_VENCIMIENTO#<BR>
		direccion	= #LvarResult[i].A_DIRECCION#<BR>
	</cfloop>
</cfoutput>

<cfset LvarCedulaFis = createObject("component","P_CedulaFisica")>
<cfset LvarCedulaFis.C_IDENTIFICACION="1">
<cfset LvarCedulaFis.A_NUM_IDENTIFICACION="0688">
<cfset LvarCedulaFis.N_CONSEC_IDENTIFIC="0721">

<cfinvoke 	webservice="http://10.7.7.181:7001/cfmx/WS/RN/PersonasJuridicasWS.cfc?WSDL"
			method="getPersonaFisica"
			returnVariable="LvarResult"

			parameters="#LvarCedulaFis#"
>
<cfoutput>
	<BR>
	<strong>METODO:	getPersonaFisica</strong><BR>
	nombre = #LvarResult.NOMBRE#<BR>
	apellido 1	= #LvarResult.APELLIDO_1#<BR>
	apellido 2	= #LvarResult.APELLIDO_2#<BR>
</cfoutput>

