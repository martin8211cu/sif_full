<!---***************************************************************************************************--->
<!---********Logica de ingreso de incidencias segun sea necesaria la aprobacion de las mismos***********--->
<!---***************************************************************************************************--->

<!--- Averiguar rol. -1=Ninguno, 0=Usuario, 1=Jefe, 2=Administrador --->
<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="getRol" returnvariable="rol"/>

<!---Es administrador RH--->
<cfset esAdminRH = 0>
<cfif rol EQ 2>
	<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="esAdministradorRH" returnvariable="esAdminRH"/>
</cfif>

<!---Averiguar si se ingresa desde Autogestion o desde Nomina --->
<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="validaLugarConsulta" returnvariable="Menu"/>

<!--- Averigua si el usuario es empleado activo en al empresa actual--->
<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="getEmpleadoUsuario" returnvariable="rsDEidUser"/>
<cfif rsDEidUser.RecordCount EQ 0><!---No es empleado--->
	<cfset UserDEid = 0>
<cfelse>
	<cfset UserDEid = rsDEidUser.DEid>
</cfif>

<!---Si es jefe u autorizador averigua quienes son sus subalternos --->
<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="getSubalternos" returnvariable="rsSubalternos">
	<cfinvokeargument name="DEid" value="#UserDEid#"/>
</cfinvoke>

<!---Si es jefe averigua si es su propio jefe--->
<cfif rol EQ 1>
	<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="EsSuJefe" returnvariable="EsSuJefe">
		<cfinvokeargument name="DEid" value="#UserDEid#"/>
	</cfinvoke>
</cfif>

<!---Averigua si el parametro 'Requiere aprobación incidencias' esta encendido --->
<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="getParam" returnvariable="reqAprobacion">
	<cfinvokeargument name="Pcodigo" value="1010">
</cfinvoke>

<!---Averigua si el parametro 'Requiere aprobacion de Incidencias de tipo cálculo' esta encendido --->
<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="getParam" returnvariable="reqAprobacionCalculo">
	<cfinvokeargument name="Pcodigo" value="1060"/>
</cfinvoke>

<!---Averigua si el parametro 'Requiere aprobacion de Incidencias por el Jefe del Centro Funcional' esta encendido --->
<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="getParam" returnvariable="reqAprobacionJefe">
	<cfinvokeargument name="Pcodigo" value="2540"/>
</cfinvoke>


<cfset aprobarIncidencias = false >
<cfif reqAprobacion eq 1 >
	<cfset aprobarIncidencias = true >
</cfif>

<cfset aprobarIncidenciasCalc = false >
<cfif reqAprobacionCalculo eq 1 >
	<cfset aprobarIncidenciasCalc = true >
</cfif>	


<cfset aprobarIncidenciasJefe = false >
<cfif reqAprobacionJefe eq 1 >
	<cfset aprobarIncidenciasJefe = true >
</cfif>

<cfif rol EQ 2>						<!---Ingresado desde nomina, cuando se ingresa desde nomina no importa si requiere aporbacion de incidencias u aprobacion por parte del jefe debido a que la incidencia se aprueba de forma automatica--->
	
	<cfif esAdminRH or reqAprobacion EQ 0>	
		<cfset I_ingresadopor = 2>							<!---Ingresa Administrador--->
		<cfset I_estado = 1>								<!---Aprobacion Directa del Administrador--->
		<cfset I_estadoAprobacion = 2>						<!---Aprobacion Directa del Jefe no importa si tiene o no--->
	<cfelse>
		<cfset I_ingresadopor = 2>							<!---Ingresa Administrador--->
		<cfset I_estado = 0>								<!---Aprobacion Directa del Administrador--->
		<cfset I_estadoAprobacion = 2>						<!---Aprobacion Directa del Jefe no importa si tiene o no--->
	</cfif>
<cfelse>												<!---Ingresado desde autogestion--->
	<cfif reqAprobacion EQ 1 >
		<cfif reqAprobacionJefe EQ 1>
				
				<cfif rol EQ 1>	
					<cfset I_ingresadopor = rol>			<!---Ingresa Jefe--->
					<cfset I_estado = 0>					<!---Requiere aprobacion del Administrador--->
					<cfset I_estadoAprobacion = 2>			<!---Se envian a aprobar--->	
				<cfelse>
					<cfset I_ingresadopor = rol>			<!---Ingresa Ususario--->
					<cfset I_estado = 0>					<!---Requiere aprobacion del Administrador--->
					<cfset I_estadoAprobacion = 0>			<!---Requiere aprobacion del Jefe--->	
				</cfif>
					
		<cfelse>
			<cfset I_ingresadopor = rol>					<!---Ingresa Jefe o Usuario--->
			<cfset I_estado = 0>							<!---Requiere aprobacion del Administrador--->
			<cfset I_estadoAprobacion = 2>					<!---Aprobacion Directa del Jefe no importa si tiene o no, por que no requiere aprobacion del jefe--->	
		</cfif>
	<cfelse>
		<cfset I_ingresadopor = rol>						<!---Ingresa Jefe o Usuario--->
		<cfset I_estado = 1>								<!---Aprobacion Directa por que no requiere aprobacion del administrador--->
		<cfset I_estadoAprobacion = 2>						<!---Aprobacion Directa del Jefe no importa si tiene o no, por que no requiere aprobacion del jefe al no requerir aprobacion del administrador--->
	</cfif>
</cfif>
<!---***************************************************************************************************--->
<!---************************************************FIN************************************************--->
<!---***************************************************************************************************--->