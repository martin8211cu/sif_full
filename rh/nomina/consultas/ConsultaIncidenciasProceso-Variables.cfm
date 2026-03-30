
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Incluir_dependencias"
	default="Incluir dependencias"
	xmlFile="/rh/generales.xml"
	returnvariable="vDependencias"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Estado"
	default="Estado"
	xmlFile="/rh/generales.xml"
	returnvariable="vestado"/>	
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Estado_Admin"
	default="Estado (Admin)"
	xmlFile="/rh/generales.xml"
	returnvariable="vestadoAdmin"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Estado_Jefe"
	default="Estado (Jefe)"
	xmlFile="/rh/generales.xml"
	returnvariable="vestadoJefe"/>

<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Estado"
		default="Estado"
		xmlfile="/rh/generales.xml"
		returnvariable="LB_estado"/>

<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Todos"
		default="Todos"
		xmlfile="/rh/generales.xml"
		returnvariable="LB_todos"/>
		
<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Sin_Aprobar_Admin"
		default="Sin Aprobar por Administrador"
		returnvariable="LB_Sin_Aprobar_Admin"/>
<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Rechazadas_Admin"
		default="Rechazadas por Administrador"
		returnvariable="LB_Rechazadas_Admin"/>
<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Aprobadas_Admin"
		default="Aprobadas por Administrador"
		returnvariable="LB_Aprobadas_Admin"/>
<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_aprobadasAdmSinnap"
		default="Aprobadas por Administrador sin NAP"
		returnvariable="LB_aprobadasAdmSinnap"/>
<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_aprobadasAdmConnrp"
		default="Aprobadas por Administrador con NRP"
		returnvariable="LB_aprobadasAdmConnrp"/>
		
		
<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_sin_aprobar_jefe"
		default="Sin aprobar por jefe"
		returnvariable="LB_sin_aprobar_jefe"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Rechazadas_Jefe"
		default="Rechazadas por Jefe"
		returnvariable="LB_Rechazadas_Jefe"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Aprobadas_Jefe"
		default="Aprobadas por Jefe "
		returnvariable="LB_Aprobadas_Jefe"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Sin_Aprobar_Admin"
		default="Sin Aprobar por Administrador"
		returnvariable="LB_Sin_Aprobar_Admin"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Rechazadas_Admin"
		default="Rechazadas por Administrador"
		returnvariable="LB_Rechazadas_Admin"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Aprobadas_Admin"
		default="Aprobadas por Administrador"
		returnvariable="LB_Aprobadas_Admin"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_aprobadasAdmSinnap"
		default="Aprobadas por Administrador sin NAP"
		returnvariable="LB_aprobadasAdmSinnap"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_aprobadasAdmConnrp"
		default="Aprobadas por Administrador con NRP"
		returnvariable="LB_aprobadasAdmConnrp"/>
	

<!---Averiguar si se ingresa desde Autogestion o desde Nomina --->
<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="validaLugarConsulta" returnvariable="Menu"/>

<!--- Averiguar rol. -1=Ninguno, 0=Usuario, 1=Jefe, 2=Administrador --->
<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="getRol" returnvariable="rol"/>

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

<!---Averigua si se usa presupuesto --->
<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="getParam" returnvariable="rsUsaPresupuesto">
	<cfinvokeargument name="Pcodigo" value="540"/>
</cfinvoke>


<cfset aprobarIncidencias = false >
<cfif reqAprobacion eq 1 >
	<cfset aprobarIncidencias = true >
</cfif>

<cfset aprobarIncidenciasCalc = false >
<cfif reqAprobacionCalculo eq 1 >
	<cfset aprobarIncidenciasCalc = true >
</cfif>	

<cfset aprobarIncidenciasJefe= false >
<cfif reqAprobacionJefe eq 1 >
	<cfset aprobarIncidenciasJefe = true >
</cfif>	

<cfset usaPresupuesto = false >
<cfif rsUsaPresupuesto eq 1 >
	<cfset usaPresupuesto = true >
</cfif>

<!---**********************FILTROS PARA EL QUERY DE LA LISTA************************************************--->

<cfif rol EQ 2>									<!---NOMINA--->
												<!---Es el mismo caso, si requiere o no aprobacion... cuando no se requiere aprobacion las incidencias ingresan aprobadas --->
	<cfset I_ingresadopor = '0,1,2'>			<!---Ingresado por cualquiera--->		
	<cfset I_estado = '0,1,2'>					<!---Aprobado o rechazado Admin o pendiente--->		
	<cfset I_estadoAprobacion = 2>				<!---Aprobado o rechazado Jefe--->	
	
	<cfset filtro_estadoList= '4,5,6'>			<!---filtros que se pueden visualizar--->
											
	<cfif isdefined("url.filtro_estado")>		<!---Si viene definido el filtro --->
		<cfif url.filtro_estado eq 4 >			<!---filtro pendiente admin--->
			<cfset I_estado = '0'>
		<cfelseif url.filtro_estado eq 5>		<!---filtro rechaza admin--->
			<cfset I_estado = '2'>
		<cfelseif url.filtro_estado eq 6>		<!---filtro aprueba admin--->
			<cfset I_estado = '1'>
		
		<cfelseif url.filtro_estado eq 7>		<!---casos en que se usa presupuesto--->
			<cfset I_estado = '1'>
		<cfelseif url.filtro_estado eq 8>		
			<cfset I_estado = '1'>
		</cfif>
	</cfif>
	
<cfelse>										<!---AUTOGESTION--->			
	<cfif rol EQ 1> 							<!---JEFE--->
		
		<cfset I_ingresadopor = '0,1'>				
		<cfset I_estado = '0,1,2'>				
		<cfset I_estadoAprobacion = '1,2,3'>	
	<cfelse>									<!---USUARIO--->
		<cfset I_ingresadopor = 0>				
		<cfset I_estado = '0,1,2'>							
		<cfset I_estadoAprobacion = '1,2,3'>	
	</cfif>
	
	<cfset filtro_estadoList= '1,2,3,4,5,6'>	<!---filtros que se pueden visualizar--->
											
	<cfif isdefined("url.filtro_estado")>		
		
		<cfif url.filtro_estado eq 4 >			<!---filtro pendiente jefe--->
			<cfset I_estadoAprobacion = '1'>
		<cfelseif url.filtro_estado eq 5>		<!---filtro rechaza jefe--->
			<cfset I_estadoAprobacion = '3'>
		<cfelseif url.filtro_estado eq 6>		<!---filtro aprueba jefe--->
			<cfset I_estadoAprobacion = '2'>
			
		<cfelseif url.filtro_estado eq 4 >		<!---filtro pendiente admin--->
			<cfset I_estado = '0'>
		<cfelseif url.filtro_estado eq 5>		<!---filtro rechaza admin--->
			<cfset I_estado = '2'>
		<cfelseif url.filtro_estado eq 6>		<!---filtro aprueba admin--->
			<cfset I_estado = '1'>
		
		<cfelseif url.filtro_estado eq 7>		<!---casos en que se usa presupuesto--->
			<cfset I_estado = '1'>
		<cfelseif url.filtro_estado eq 8>		
			<cfset I_estado = '1'>
		</cfif>
		
	</cfif>
</cfif>

<!---**********************FIN FILTROS PARA EL QUERY DE LA LISTA************************************************--->