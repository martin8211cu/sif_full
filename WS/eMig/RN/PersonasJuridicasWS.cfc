<cfcomponent>
	<cffunction name="getPersonaJuridica" access="remote" returntype="R_PersonaJuridica" output="no">
		<cfargument name="parameters" type="P_CedulaJuridica" required="yes">

		<cfset LvarResponse = createObject("component","R_PersonaJuridica")>
		<cfset LvarResponse.A_RAZONSOCIAL		= "NOMBRE DE LA EMPRESA">
		<cfset LvarResponse.TOMO				= 1>
		<cfset LvarResponse.ASIENTO				= 2>
		<cfset LvarResponse.N_IND_OTORGARPODER	= 0>
		<cfset LvarResponse.F_INSCRIPCION		= createDate(year(now()),month(now()),day(now()))>
		<cfset LvarResponse.H_INSCRIPCION		= timeFormat(now(),"HH:MM:SS")>
		<cfset LvarResponse.F_INICIO			= createDate(2000,1,1)>
		<cfset LvarResponse.F_VENCIMIENTO		= createDate(2099,12,31)>
		<cfset LvarResponse.C_ESTADOACTUAL		= "ESTADO ACTUAL">
		<cfset LvarResponse.A_EXPEDIENTE		= "EXPEDIENTE DE LA EMPRESA">
		<cfset LvarResponse.A_DOMICILIO			= "DOMICILIO DE LA EMPRESA">
		<cfset LvarResponse.A_FINES				= "FINES DE LA EMPRESA">

		<cfreturn LvarResponse>
	</cffunction>

	<cffunction name="getCapital" access="remote" returntype="R_Capital[]" output="no">
		<cfargument name="parameters" type="P_CedulaJuridica" required="yes">

		<cfset LvarResponseArray = arraynew(1)>
		<cfloop index="i" from="1" to="3">
			<cfset LvarResponseItem	 = createObject("component","R_Capital")>
			
			<cfset LvarResponseItem.N_CONSECUTIVO_TITULO	= i>
			<cfset LvarResponseItem.C_CLASEACCION			= "#i#">
			<cfset LvarResponseItem.C_TIPOCAPITAL			= "#i#">
			<cfset LvarResponseItem.C_TIPOMONEDA			= "#i#">
			<cfset LvarResponseItem.N_MONTO					= 100000*i>
			<cfset LvarResponseItem.N_CANTIDAD				= 10*i>
			<cfset LvarResponseItem.N_TOMOINSCAP			= i>
			<cfset LvarResponseItem.N_ASIENTOINSCAP			= i>
			<cfset LvarResponseItem.F_INSCRIPCION			= createDate(year(now()),month(now()),day(now()))>
			<cfset LvarResponseItem.H_INSCRIPCION			= timeFormat(now(),"HH:MM:SS")>
			<cfset LvarResponseItem.D_ACCION				= "ACCION #i#">
			<cfset arrayAppend(LvarResponseArray, LvarResponseItem)>
		</cfloop>
		
		<cfreturn LvarResponseArray>
	</cffunction>

	<cffunction name="getNombramientos" access="remote" returntype="R_Nombramientos[]" output="no">
		<cfargument name="parameters" type="P_CedulaJuridica" required="yes">

		<cfset LvarResponseArray = arraynew(1)>
		<cfloop index="i" from="1" to="3">
			<cfset LvarResponseItem	 = createObject("component","R_Nombramientos")>
			<cfset LvarResponseItem.N_CONSECUTIVOPARTE		= i>
			<cfset LvarResponseItem.N_TOMOINSPARTE			= i>
			<cfset LvarResponseItem.N_ASIENTOINSPARTE		= i>
			<cfset LvarResponseItem.F_INSCRIPCION			= createDate(year(now()),month(now()),day(now()))>
			<cfset LvarResponseItem.H_INSCRIPCION			= timeFormat(now(),"HH:MM:SS")>
			<cfset LvarResponseItem.C_TIPOPARTE				= "#i#">
			<cfset LvarResponseItem.C_REPRESENTAC			= "#i#">
			<cfset LvarResponseItem.N_IND_JUNTA_DIR			= i>
			<cfset LvarResponseItem.C_IDENTIFICACION		= "#i#">
			<cfset LvarResponseItem.A_NUM_IDENTIFICACION	= "0000000000#i#">
			<cfset LvarResponseItem.N_TIPOCED_MIEMBRO		= 2*i>
			<cfset LvarResponseItem.N_CLASECED_MIEMBRO		= 2*i>
			<cfset LvarResponseItem.N_CONSCED_MIEMBRO		= 2*i>
			<cfset LvarResponseItem.C_ESTADOCIVIL			= "#i#">
			<cfset LvarResponseItem.C_DOMICILIO				= "#i#">
			<cfset LvarResponseItem.F_INICIO				= createDate(2000,1,1)>
			<cfset LvarResponseItem.F_VENCIMIENTO			= createDate(2099,12,31)>
			<cfset LvarResponseItem.A_DIRECCION				= "DIRECCION DE NOMBRAMIENTO #i#">
			<cfset arrayAppend(LvarResponseArray, LvarResponseItem)>
		</cfloop>
		
		<cfreturn LvarResponseArray>
	</cffunction>

	<cffunction name="getPersonaFisica" access="remote" returntype="R_PersonaFisica" output="no">
		<cfargument name="parameters" type="P_CedulaFisica" required="yes">

		<cfset LvarResponse = createObject("component","R_PersonaFisica")>
		<cfset LvarResponse.NOMBRE			= "NOMBRE DE PERSONA #Arguments.parameters.A_NUM_IDENTIFICACION#">
		<cfset LvarResponse.APELLIDO_1		= "APELLIDO1 DE PERSONA">
		<cfset LvarResponse.APELLIDO_2		= "APELLIDO2 DE PERSONA">

		<cfreturn LvarResponse>
	</cffunction>
</cfcomponent>