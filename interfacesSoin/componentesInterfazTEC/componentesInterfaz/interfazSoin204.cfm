<!---
	Interfaz 204
	Interfaz de Intercambio de Información de Acciones de Personal
	Dirección de la Inforamción: Sistema Externo - RRHH
	Elaborado por: Ana Villavicencio
	Fecha de Creación: 11/07/2007
	Modificaciones Posteriores
	Fecha 		Usuario		Motivo
	DD/MM/YYYY	UUUUUUU		MMMMMM
--->

<!--- Crea Instancia de Componente de Interfaces para reportar actividad de la intarfaz --->
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- Crea Transacción para Leer Encabezado y Detalles de Documento de Cuentas por Cobrar y Cuentas por Pagar de la BD de Interfaces. --->
<cftransaction isolation="read_uncommitted">
	<!--- Lee encabezado y detalles por procesar. --->
	<cfquery name="readInterfaz204" datasource="sifinterfaces">
		SELECT 	*
		FROM 	IE204
		WHERE 	ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#"><!--- La variable GvarID fué por el Componente de Interfaces previamente a invocar este Componente --->
	</cfquery>
	<!--- Valida que vengan datos --->
	<cfif readInterfaz204.recordcount eq 0>
		<cfthrow message="Error en Interfaz 204. No existen datos de Entrada para el ID='#GvarID#' o no tiene detalles definidos. Proceso Cancelado!.">
	</cfif>
</cftransaction>
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- Crea Transacción para Agregar las Acciones de Personal. --->
<!--- Procesamiento de Interfaz 204. --->

<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_Tipo_Nomina" Default="Tipo Nómina" returnvariable="LB_Tipo_Nomina" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Regimen_de_vacaciones" Default="Régimen de vacaciones" returnvariable="LB_Regimen_de_vacaciones" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Plaza" Default="Plaza" returnvariable="LB_Plaza" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Jornada" Default="Jornada" returnvariable="LB_Jornada" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_La_accion_no_se_puede_aplicar_porque_los_siguientes_valores_no_son_modificables" Default="La acción no se puede aplicar porque los siguientes valores no son modificables:"	 returnvariable="MSG_Error" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES TRADUCCION --->

<cftransaction>
	<!--- <cfset QueryAccion	 = getComportamAccion(readInterfaz204.TipoAccionPersonal)> --->
	<!--- BUSCA EL TIPO DE COMPORTAMIENTO DE LA ACCION --->
	<cfquery name="rsConsTipoAccion" datasource="#Session.DSN#">
		select RHTcomportam, RHTpfijo, RHTid
		from RHTipoAccion a
			inner join Empresa c
				on c.Ereferencia = a.Ecodigo
				and c.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#readInterfaz204.EcodigoSDC#"> 
		where a.RHTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#readInterfaz204.TipoAccionPersonal#">
	</cfquery>
	<cfif rsConsTipoAccion.RecordCount EQ 0>
		<cfthrow message="Error de Interfaz 204. El tipo de Acción no existe. Proceso Cancelado!">
	<cfelseif rsConsTipoAccion.RHTcomportam EQ 9>
		<cfthrow message="Error de Interfaz 204. Tipo de Acción no permitido. Proceso Cancelado!">
	</cfif>
	
	<!--- VALIDA LA EMPRESA --->
	<cfquery name="rsEmpresa" datasource="#Session.DSN#">
		select Ereferencia
		from Empresa c
		where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#readInterfaz204.EcodigoSDC#"> 
	</cfquery>
	<cfif rsEmpresa.RecordCount EQ 0>			
		<cfthrow message="Error de Interfaz 204. La empresa #readInterfaz204.EcodigoSDC# no existe. Proceso Cancelado!">
	</cfif>
	<cfset Valida_Empresa = rsEmpresa.Ereferencia>
	
	<!--- VALIDA LAS FECHAS DE LA ACCION --->
	<cfif rsConsTipoAccion.RHTpfijo EQ 1 and readInterfaz204.FechaVence EQ ''>
		<cfthrow message="Error de Interfaz 204. Fecha Vence nula. El tipo de acción requiere fecha de vencimiento. Proceso Cancelado!">
	<cfelseif rsConsTipoAccion.RHTpfijo EQ 1 and readInterfaz204.FechaVence lt readInterfaz204.FechaRige>
		<cfthrow message="Error de Interfaz 204. FechaVencimiento es inválido, La Fecha del Vencimiento debe ser mayor o igual que la Fecha Rige. Proceso Cancelado!">
	</cfif>

	
	<!--- VALIDA QUE EL EMPLEADO HAYA SIDO NOMBRADO PARA PODER AGREGAR LA ACCIÓN --->
	<cfif rsConsTipoAccion.RHTcomportam NEQ 1>
		<cfquery name="rsEmpleado" datasource="#Session.DSN#">
			select count(1) as cantidad, a.DEid
			from LineaTiempo a
			inner join DatosEmpleado b
				on a.Ecodigo = b.Ecodigo
				and a.DEid = b.DEid
				and b.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz204.IdentificacionEmpleado#"> 
			where <cfqueryparam cfsqltype="cf_sql_date" value="#readInterfaz204.FechaRige#"> between LTdesde and LThasta
			  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Valida_Empresa#"> 
			group by a.DEid
		</cfquery>
		<cfif rsEmpleado.RecordCount EQ 0 or (rsEmpleado.cantidad EQ 0 AND rsConsTipoAccion.RHTcomportam NEQ 1)>			
			<cfthrow message="Error de Interfaz 204. El empleado #readInterfaz204.IdentificacionEmpleado# no existe o no ha sido nombrado para esta fecha: #readInterfaz204.FechaRige#. Proceso Cancelado!">
		</cfif>
	<cfelse>
		<cfquery name="rsEmpleado" datasource="#session.DSN#">
			select count(1) as cantidad, DEid
			from DatosEmpleado
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Valida_Empresa#">
			  and DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz204.IdentificacionEmpleado#">
			 group by DEid
		</cfquery>
		<cfif rsEmpleado.RecordCount EQ 0 or (rsEmpleado.cantidad EQ 0 AND rsConsTipoAccion.RHTcomportam NEQ 1)>			
			<cfthrow message="Error de Interfaz 204. El empleado #readInterfaz204.IdentificacionEmpleado# no existe. Proceso Cancelado!">
		</cfif>
	</cfif>
	<cfset Valida_DEid 	  = rsEmpleado.DEid>	
	<!--- VALIDA LA PLAZA --->
	<cfquery name="rsPlaza" datasource="#session.DSN#">
		select RHPid
		from RHPlazas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Valida_Empresa#"> 
		  and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#readInterfaz204.CodigoPlazaAsignada#">
	</cfquery>
	<cfif rsPlaza.RecordCount EQ 0>
		<cfthrow message="Error de Interfaz 204.El código de plaza #readInterfaz204.CodigoPlazaAsignada# no existe. Proceso Cancelado!">
	</cfif>
	<cfset Valida_Plaza   = rsPlaza.RHPid>
	
	<!--- VALIDA LA TIPO DE NOMINA --->
	<cfquery name="rsNomina" datasource="#session.DSN#">
		select Tcodigo
		from TiposNomina
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Valida_Empresa#"> 
		  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#readInterfaz204.CodigoTipoNomina#">  
	</cfquery>
	<cfif rsNomina.RecordCount EQ 0>
		<cfthrow message="Error de Interfaz 204. El Tipo de Nómina #readInterfaz204.CodigoTipoNomina# no existe. Proceso Cancelado!">
	</cfif>
	<cfset Valida_Nomina  = rsNomina.Tcodigo>
	
	<!--- VALIDA LA JORNADA --->
	<cfquery name="rsJornada" datasource="#session.DSN#">
		select RHJid
		from RHJornadas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Valida_Empresa#"> 
		  and RHJcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#readInterfaz204.CodigoTipoJornada#">  
	</cfquery>
	<cfif rsJornada.RecordCount EQ 0>
		<cfthrow message="Error de Interfaz 204. Jornada #readInterfaz204.CodigoTipoJornada# no existe. Proceso Cancelado!">
	</cfif>
	<cfset Valida_Jornada = rsJornada.RHJid>
	
	<!--- VALIDA LA REGIMEN DE VACACIONES --->
	<cfquery name="rsRegVac" datasource="#session.DSN#">
		select RVid
		from RegimenVacaciones
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Valida_Empresa#"> 
		  and RVcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#readInterfaz204.CodigoRegVacaciones#">  
	</cfquery>
	<cfif rsRegVac.RecordCount EQ 0>
		<cfthrow message="Error de Interfaz 204. Régimen de Vacaciones #readInterfaz204.CodigoRegVacaciones# no existe. Proceso Cancelado!">
	</cfif>
	<cfset Valida_RegVac  = rsRegVac.RVid>
	
	<!--- VALIDA LA VALIDA COMPONENTE SALARIAL 1 --->
	<cfquery name="rsCompSal" datasource="#session.DSN#">
		select CSid
		from ComponentesSalariales
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Valida_Empresa#"> 
		  and CScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#readInterfaz204.ComponenteSalarial1#">  
	</cfquery>
	<cfif rsCompSal.RecordCount EQ 0>
		<!--- SI EL COMPONENTE SALARIAL 1 NO EXISTE ENTONCES SE ASIGNA EL COMPONENTE DEL SALARIO BASE. --->
		<cfquery name="rsCompSal" datasource="#session.DSN#">
			select CSid
			from ComponentesSalariales
			where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Valida_Empresa#">
			  and CSsalariobase = 1
		</cfquery>
	</cfif>
	<cfif rsCompSal.RecordCount EQ 0>
		<cfthrow message="Error de Interfaz 204. Componente Salarial 1 no existe. Proceso Cancelado!">
	</cfif>
	<cfset Valida_CompSal1= rsCompSal.CSid>
	<cfif LEN(TRIM(readInterfaz204.ComponenteSalarial2))>
		<!--- VALIDA LA VALIDA COMPONENTE SALARIAL 2 --->
		<cfquery name="rsCompSal2" datasource="#session.DSN#">
			select CSid
			from ComponentesSalariales
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Valida_Empresa#"> 
			  and CScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#readInterfaz204.ComponenteSalarial2#">  
		</cfquery>
		<cfif rsCompSal2.RecordCount EQ 0>
			<cfthrow message="Error de Interfaz 204. Componente Salarial 2 no existe. Proceso Cancelado!">
		</cfif>
		<cfset Valida_CompSal2= rsCompSal2.CSid>
	</cfif>
	<cfif LEN(TRIM(readInterfaz204.ComponenteSalarial3))>
		<!--- VALIDA LA VALIDA COMPONENTE SALARIAL 3 --->
		<cfquery name="rsCompSal3" datasource="#session.DSN#">
			select CSid
			from ComponentesSalariales
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Valida_Empresa#"> 
			  and CScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#readInterfaz204.ComponenteSalarial3#">  
		</cfquery>
		<cfif rsCompSal3.RecordCount EQ 0>
			<cfthrow message="Error de Interfaz 204. Componente Salarial 3 no existe. Proceso Cancelado!">
		</cfif>
		<cfset Valida_CompSal3= rsCompSal3.CSid>
	</cfif>
	<cfif LEN(TRIM(readInterfaz204.ComponenteSalarial4))>
		<!--- VALIDA LA VALIDA COMPONENTE SALARIAL 4 --->
		<cfquery name="rsCompSal4" datasource="#session.DSN#">
			select CSid
			from ComponentesSalariales
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Valida_Empresa#"> 
			  and CScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#readInterfaz204.ComponenteSalarial4#">  
		</cfquery>
		<cfif rsCompSal4.RecordCount EQ 0>
			<cfthrow message="Error de Interfaz 204. Componente Salarial 4 no existe. Proceso Cancelado!">
		</cfif>
		<cfset Valida_CompSal4= rsCompSal4.CSid>
	</cfif>
	
	<!--- VALIDA LA ACCION DEPENDIENDO DEL TIPO --->
	<cfset va_errores = ''>
	<!--- VERIFICA EL ESTADO ACTUAL DE LA PERSONA --->
	<cfquery name="rsActual" datasource="#session.DSN#">
		select 	Tcodigo as TipoNomina,
				RVid as RegimenVacaciones,
				RHPid as Plaza,
				RHJid as Jornada,
				Dcodigo,
				Ocodigo
		from LineaTiempo a
		where <cfqueryparam cfsqltype="cf_sql_date" value="#readInterfaz204.FechaRige#"> between a.LTdesde and a.LThasta
			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Valida_DEid#">
	</cfquery>
	
	<!--- VERIFICA EL TIPO DE ACCION --->
	<cfquery name="rsTipoAccion" datasource="#session.DSN#">
		select 	b.RHTid, b.RHTcodigo,
				b.RHTctiponomina as CTiponomina,
				b.RHTcregimenv as CRegimenvacaciones,
				b.RHTcplaza as CPlaza,
				b.RHTcjornada as CJornada
		from RHTipoAccion b
		where RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsTipoAccion.RHTid#">
	</cfquery>

	<cfif rsTipoAccion.RecordCount NEQ 0 and rsActual.RecordCount NEQ 0>
		<!----NO Cambiar Tipo nomina---->
		<cfif rsTipoAccion.CTiponomina EQ 0>
			<cfif trim(rsActual.TipoNomina) NEQ trim(Valida_Nomina)>
				<cfset va_errores = ListAppend(va_errores, '#LB_Tipo_Nomina#')>
			</cfif>
		</cfif> 
		<!----NO Cambiar Regimen de vacaciones---->
		<cfif rsTipoAccion.CRegimenvacaciones EQ 0>
			<cfif trim(rsActual.RegimenVacaciones) NEQ trim(Valida_RegVac)>
				<cfset va_errores = ListAppend(va_errores, '#LB_Regimen_de_vacaciones#')>
			</cfif>
		</cfif>
		<!----NO Cambiar Plaza---->
		<cfif rsTipoAccion.CPlaza EQ 0>
			<cfif trim(rsActual.Plaza) NEQ trim(Valida_Plaza)>
				<cfset va_errores = ListAppend(va_errores, '#LB_Plaza#')>
			</cfif>
		</cfif>
		<!----NO Cambiar Jornada ---->
		<cfif rsTipoAccion.CJornada EQ 0>
			<cfif trim(rsActual.Jornada) NEQ trim(Valida_Jornada)>
				<cfset va_errores = ListAppend(va_errores, '#LB_Jornada#')>
			</cfif>
		</cfif>
	</cfif>
	<cfif va_errores NEQ ''>
		<cfthrow message="Error de Interfaz 204. Los campos #va_errores# no son modificables. Proceso Cancelado!">
	</cfif>
	<cfquery name="rsDatosAccion" datasource="#session.DSN#">
		select RHPpuesto,b.Dcodigo,b.Ocodigo
		from RHPlazas a
		inner join Cfuncional b
		  on b.CFid = a.CFid
		  and b.Ecodigo = a.Ecodigo
		where a.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Valida_Plaza#">
	</cfquery>
	<!--- INSERTA LA ACCION --->
	
	<cfquery name="rsInsert" datasource="#session.DSN#">
		insert into RHAcciones(
			DEid, 
			RHTid, 
			Ecodigo, 
			RHPcodigo,
			Dcodigo,
			Ocodigo,
			Tcodigo, 
			RVid, 
			RHJid, 
			RHPid, 
			DLfvigencia, 
			DLffin, 
			IDInterfaz,
			Usucodigo)
		values(
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valida_DEid#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsTipoAccion.RHTid#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Valida_Empresa#">,
			<cfqueryparam cfsqltype="cf_sql_char" 	 value="#rsDatosAccion.RHPpuesto#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatosAccion.Dcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatosAccion.Ocodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" 	 value="#Valida_Nomina#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Valida_RegVac#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Valida_Jornada#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Valida_Plaza#">,
			<cfqueryparam cfsqltype="cf_sql_date" 	 value="#readInterfaz204.FechaRige#">, 
			<cfqueryparam cfsqltype="cf_sql_date" 	 value="#readInterfaz204.FechaVence#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#readInterfaz204.ID#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		)
		<cf_dbidentity1 datasource="#session.DSN#">
	</cfquery>
	<cf_dbidentity2 datasource="#session.DSN#" name="rsInsert">
	<cfset Lvar_RHAlinea = rsInsert.identity>
	<!--- INSERTA EL COMPONENTE SALARIAL 1 --->
	<cfquery name="rsEquipararLineaTiempo" datasource="#Session.DSN#">
		insert into RHDAcciones(RHAlinea, 
								CSid, 
								RHDAtabla, 
								RHDAunidad, 
								RHDAmontobase, 
								RHDAmontores, 
								Usucodigo,
								Ulocalizacion)
		values(<cfqueryparam cfsqltype="cf_sql_numeric"  value="#Lvar_RHAlinea#">,
			   <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Valida_CompSal1#">,
				null,
				1,
				<cfqueryparam cfsqltype="cf_sql_money"   value="#readInterfaz204.MontoSalarial1#">,
				<cfqueryparam cfsqltype="cf_sql_money"   value="#readInterfaz204.MontoSalarial1#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ulocalizacion#">
			)
	</cfquery>
	<cfif isdefined('Valida_CompSal2')>
		<!--- INSERTA EL COMPONENTE SALARIAL 2 --->
		<cfquery name="rsEquipararLineaTiempo" datasource="#Session.DSN#">
			insert into RHDAcciones(RHAlinea, 
									CSid, 
									RHDAtabla, 
									RHDAunidad, 
									RHDAmontobase, 
									RHDAmontores, 
									Usucodigo,
									Ulocalizacion)
			values(<cfqueryparam cfsqltype="cf_sql_numeric"  value="#Lvar_RHAlinea#">,
				   <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Valida_CompSal2#">,
					null,
					1,
					<cfqueryparam cfsqltype="cf_sql_money" 	 value="#readInterfaz204.MontoSalarial2#">,
					<cfqueryparam cfsqltype="cf_sql_money" 	 value="#readInterfaz204.MontoSalarial2#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ulocalizacion#">
				)
		</cfquery>
	</cfif>
	<cfif isdefined('Valida_CompSal3')>
		<!--- INSERTA EL COMPONENTE SALARIAL 3 --->
		<cfquery name="rsEquipararLineaTiempo" datasource="#Session.DSN#">
			insert into RHDAcciones(RHAlinea, 
									CSid, 
									RHDAtabla, 
									RHDAunidad, 
									RHDAmontobase, 
									RHDAmontores, 
									Usucodigo,
									Ulocalizacion)
			values(<cfqueryparam cfsqltype="cf_sql_numeric"  value="#Lvar_RHAlinea#">,
				   <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Valida_CompSal3#">,
					null,
					1,
					<cfqueryparam cfsqltype="cf_sql_money" 	 value="#readInterfaz204.MontoSalarial3#">,
					<cfqueryparam cfsqltype="cf_sql_money" 	 value="#readInterfaz204.MontoSalarial3#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ulocalizacion#">
				)
		</cfquery>
	</cfif>
	<cfif isdefined('Valida_CompSal4')>
		<!--- INSERTA EL COMPONENTE SALARIAL 2 --->
		<cfquery name="rsEquipararLineaTiempo" datasource="#Session.DSN#">
			insert into RHDAcciones(RHAlinea, 
									CSid, 
									RHDAtabla, 
									RHDAunidad, 
									RHDAmontobase, 
									RHDAmontores, 
									Usucodigo,
									Ulocalizacion)
			values(<cfqueryparam cfsqltype="cf_sql_numeric"  value="#Lvar_RHAlinea#">,
				   <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Valida_CompSal4#">,
					null,
					1,
					<cfqueryparam cfsqltype="cf_sql_money" 	 value="#readInterfaz204.MontoSalarial4#">,
					<cfqueryparam cfsqltype="cf_sql_money" 	 value="#readInterfaz204.MontoSalarial4#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ulocalizacion#">
				)
		</cfquery>
	</cfif>
</cftransaction>
<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>