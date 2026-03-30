<cfcomponent>
	<cffunction name="getEstadosPersona" access="remote" output="no" returntype="R_ConsultaEstados">
		<cfargument name="parameters" type="P_CedulaT" required="yes">
		
		<cfset LvarTipo = Arguments.parameters.tipoCedula>
		<cfset LvarCedula = Arguments.parameters.numeroCedula>
		<cfset LvarRespon = createObject("component","R_ConsultaEstados")>
		<cfif Arguments.parameters.tipoCedula EQ "J">
			<!--- REGISTRO NACIONAL --->
			<cfset LvarCedulaJur = createObject("component","P_CedulaJuridica")>
			
			<cfset LvarCedulaJur.N_TIPOCEDULA=mid(LvarCedula,1,1)>
			<cfset LvarCedulaJur.N_CLASECEDULA=mid(LvarCedula,2,3)>
			<cfset LvarCedulaJur.N_CONSEC_CEDULA=mid(LvarCedula,5,len(LvarCedula))>
			
			<cftry>
				<cfinvoke 	webservice="http://10.7.7.181:7001/cfmx/WS/RN/PersonasJuridicasWS.cfc?WSDL"
							method="getPersonaJuridica"
							returnVariable="LvarResult"
				
							parameters="#LvarCedulaJur#"
				>
				<cfset LvarRespon.ESTADO_RN = 	LvarResult.getC_ESTADOACTUAL()>
			<cfcatch type="any">			
				<cfset LvarRespon.ESTADO_RN = 	"N/D">
			</cfcatch>
			</cftry>
			
			<!--- TRIBUTACION DIRECTA --->
			<cftry>
				<cfinvoke 	webservice="http://10.7.7.181:7001/cfmx/WS/TD/tributacionWS.cfc?WSDL"
							method="getStatusJ"
							returnVariable="LvarResult"
				
							tCedulaJ="#LvarCedula#"
				>
				<cfset LvarRespon.ESTADO_TD = 	LvarResult.getrStatusJ()>
				<cfset LvarRespon.NOMBRE 	 = 	LvarResult.getrNombreJ()>
			<cfcatch type="any">			
				<cfset LvarRespon.ESTADO_TD = 	"N/D">
			</cfcatch>
			</cftry>

			<!--- CCSS --->
			<cfset LvarCedulaJur = createObject("component","P_Cedula")>
			<cfset LvarCedulaJur.pTipPatrono = "2">
			<cfset LvarCedulaJur.pNumPatrono = LvarCedula>
			
			<cftry>
				<cfinvoke 	webservice="https://ccsssjapp03.ccss.sa.cr/ConsultaMorosidadWS/ConsultaMorosoWSSoapHttpPort?WSDL"
							method="verificaMorosidadWeb"
							returnVariable="LvarResult"
				
							parameters="#LvarCedulaJur#"
				>
				<cfset LvarResult = LvarResult.getResult()>
				<cfif LvarResult.getPindmorosoOut() EQ "S">
					<cfset LvarRespon.ESTADO_CCSS = "MOROSO">
				<cfelseif LvarResult.getPindactivoOut() EQ "S">
					<cfset LvarRespon.ESTADO_CCSS = "ACTIVO">
				<cfelseif LvarResult.getPindactivoOut() EQ "N">
					<cfset LvarRespon.ESTADO_CCSS = "INACTIVO">
				<cfelse>
					<cfset LvarRespon.ESTADO_CCSS = "N/A">
				</cfif>
			<cfcatch type="any">			
				<cfset LvarRespon.ESTADO_CCSS = 	"N/D">
			</cfcatch>
			</cftry>

		</cfif>
		<cfreturn LvarRespon>
	</cffunction>
</cfcomponent>