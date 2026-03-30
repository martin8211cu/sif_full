
<cfcomponent>
	<!--- Aplicación de Acciones de Personal --->
	<!---
		Modificacion:  
		    Tomar en cuenta el comportamiento nuevo de las acciones que se marcan como que no afectan retroactivamente
	
	        No construir la linea del tiempo cuando la accion esta marcada como que no afecta retroactivos
	        Grabar la tabla de Pagos en Exceso (RHSaldoPagosExceso) cuando la accion esta marcada como que no afecta retroactivos
		Modificado por Mauricio Esquivel
		Fecha:  Dic 26 2003
	--->
    <!---
    Comportamiento de Acciones
    1 Nombramiento
    2 Cese
    3 Vacaciones
    4 Permiso
    5 Incapacidad
    6 Cambio
    7 Anulación
    8 Aumento
	9 Cambio de Empresa
	10 Anotación
	11 antigüedad
	12 Recargo de Plazas
	13 Ausencia / Falta
    --->	
    
    <!--- FUNCIONES --->
    <!--- VALIDACIONES --->
    
    <cffunction name="FechaIngreso" access="public" returntype="date">
        <cfargument name="DEid" 		type="numeric" 	required="yes">
    	<cfargument name="Ecodigo" 		type="numeric" 	required="no" default="#Session.Ecodigo#">
		<cfargument name="conexion" 	type="string" 	required="no" default="#Session.DSN#">

        <cfquery name="rsFechaIngreso" datasource="#Arguments.conexion#">
            select EVfantig
            from EVacacionesEmpleado
            where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
        </cfquery>
        <cfif isdefined('rsFechaIngreso') and rsFechaIngreso.RecordCount NEQ 0>
        	<cfreturn rsFechaIngreso.EVfantig>
        <cfelse>
        	<cfreturn createdate('6100','01','01')>
        </cfif>
    </cffunction>

    <cffunction name="Parte1" access="private" output="false">
    	<cfargument name="Ecodigo" 		type="numeric" 	required="yes" default="#Session.Ecodigo#">
		<cfargument name="RHAlinea" 	type="numeric" 	required="yes">	
		<cfargument name="Usucodigo" 	type="string" 	required="no" default="#Session.Usucodigo#">
		<cfargument name="conexion" 	type="string" 	required="no" default="#Session.DSN#">
		<cfargument name="validar" 		type="boolean" 	required="no" default="false">
		<cfargument name="respetarLT" 	type="boolean" 	required="no" default="false">		
		<cfargument name="debug" 		type="boolean" 	required="no" default="false">


		<!--- El proceso se va a dividir en 2 partes el actual en donde se procesan las acciones normales       --->
		<!--- y el nuevo donde se van a procesar las acciones especiales ANTIGÜEDAD, ANOTACION  Y CAMBIO PUESTO --->
		<!--- Para poder indentificarlas se utiliza la variable  RHTespecial donde 0 es normal y 1 especial     --->
		<!--- *********************************************************************************************     --->
		<!---                                 Acciones de tipo normal                                           --->
		<!--- *********************************************************************************************     --->
		
		<cfif Arguments.validar EQ false><!--- valida el acceso segun parametrizacion 2526, el caso que sea falsa es indicando que va a postear--->
			<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso">
		</cfif>
		
		<cfif RHTespecial eq  0>		
			<!--- Validaciones Generales --->
			<!--- Acción marcada como de aumento (Estas no se pueden postear así...se aplican en el proceso de aumentos) --->
			<cfif dataTipoAccion.RHTcomportam EQ 8 and dataTipoAccion.IDinterfaz LTE 0>
				<cf_throw message="#MSG_ETipoComportamientoAumento#" errorCode="12090">
				<cfabort>
			<!--- Accion marcada como de Anulacion --->
			<cfelseif dataTipoAccion.RHTcomportam EQ 7>
				<cfthrow message="#MSG_ETipoComportamientoAnulacion#">
				<cfabort>
			<!--- Valida que las fecha desde sea menor a la fecha hasta --->
			<cfelseif DateCompare(Fdesde, Fhasta) GT 0>
				<cf_throw message="#MSG_EFechaRigeMayor#" errorCode="12095">
				<cfabort>
			</cfif>
			<!--- Valida que la Acción tenga datos --->
			<cfquery name="dataAccion" datasource="#Arguments.conexion#">
				select a.Tcodigo 
				from RHAcciones a 
				where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
			</cfquery>
			<cfif Len(Trim(dataAccion.Tcodigo)) EQ 0>
				<cf_throw message="#MSG_EGrabadoAccion#" errorCode="12100">
				<cfabort>
			</cfif>
			<!--- Valida que el parametro de dias para calculo de salario diario se haya definido --->
			<!--- Validar Primero que para el tipo de Nómina esté definido ese parámetro --->
			<cfquery name="dataParametros" datasource="#Arguments.conexion#">
				select FactorDiasSalario 
				from TiposNomina
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				  and Tcodigo = '#dataAccion.Tcodigo#'
			</cfquery>
			<cfif len(trim(dataParametros.FactorDiasSalario)) eq 0>
				<cf_throw message="#MSG_EParametroDiasCalculo#" errorCode="12105">
				<cfabort>
			</cfif>
			<!--- Comentado porque ahora trabaja con el Parámetro por Tipo de Nómina --->
			<!--- Valida que tenga componentes salariales --->
			<cfquery name="dataDAccion" datasource="#Arguments.conexion#">
				select 1 
				from RHDAcciones a 
				where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
			</cfquery>
			<cfif dataDAccion.recordCount EQ 0>
				<cf_throw message="#MSG_EComponentesDefinidos#" errorCode="12110">
				<cfabort>
			</cfif>	
			<!--- Valida que la cantidad de días no supere el plazo si la accion tiene plazo fijo definido y es mayor que cero --->
			<cfset CantDias = 0>
			<cfset CantDias = DateDiff('d', Fdesde, Fhasta) + 1>
			<cfif dataTipoAccion.RHTpfijo EQ 1 and dataTipoAccion.RHTpmax GT 0 and dataTipoAccion.RHTpmax LT CantDias>
				<cf_throw message="#MSG_EConfiguracionTipoAccion#" errorCode="12115">
				<cfabort>
			</cfif>
			<cfif dataTipoAccion.RHTnoretroactiva EQ 1>
				<!--- Validar que no se traslapen fechas en acciones que generan rebajo de salario.  Se valida con la misma accion de personal , mismo empleado y las fechas de vigencia. --->
				<cfquery name="chkFechas" datasource="#Arguments.conexion#">
					select b.DEidentificacion
					from RHSaldoPagosExceso a, DatosEmpleado b
					where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
					and a.DEid=b.DEid
					and a.RHSPEanulado != 1
					and (
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#"> between a.RHSPEfdesde and a.RHSPEfhasta 
					 or <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#"> between a.RHSPEfdesde and a.RHSPEfhasta
					)
				</cfquery>
				<cfif chkFechas.recordCount>
					<cf_throw message="#MSG_EFechasTraslapadas# Identificacion: #chkFechas.DEidentificacion#" errorCode="12120">
					<cfabort>
				</cfif>
				
				
				<!--- Validar que no existan acciones no retroactivas posteriores a la que se está ingresando --->
				<cfquery name="chkFechas" datasource="#Arguments.conexion#">
					select 1 
					from RHSaldoPagosExceso a 
					where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
					and a.RHSPEanulado != 1
					and a.RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTipoAccion.RHTid#">
					and a.RHSPEfdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
				</cfquery>
				<cfif chkFechas.recordCount>
					<cfquery name="errorinfo" datasource="#Arguments.conexion#">
						select c.RHTdesc, a.DLfvigencia, a.DLffin
						from RHSaldoPagosExceso b, DLaboralesEmpleado a, RHTipoAccion c
						where b.RHSPEid = (
							select min(pe.RHSPEid) 
							from RHSaldoPagosExceso pe 
							where pe.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
							and pe.RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTipoAccion.RHTid#">
							and b.RHSPEanulado != 1 
							and pe.RHSPEfdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
						)
						and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
						and a.DEid = b.DEid
						and a.DLlinea = b.DLlinea
						and a.RHTid = c.RHTid
					</cfquery>
					
					<cf_throw message="#LB_msg1#&nbsp;#Trim(errorinfo.RHTdesc)#&nbsp;#LB_msg2#&nbsp;#LSDateFormat(errorinfo.DLfvigencia, 'dd/mm/yyyy')#&nbsp;#LB_msg3#&nbsp;#LSDateFormat(errorinfo.DLffin, 'dd/mm/yyyy')#" errorCode="12125">
					<cfabort>
				</cfif>
			</cfif>
		<!--- ********************************************************************************************* --->
		<!---                                 Acciones de tipo especial                                     --->
		<!--- ********************************************************************************************* --->
		<cfelseif RHTespecial eq  1>	
			<cfif dataTipoAccion.RHTcomportam EQ 11><!--- antigüedad --->
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="MSG_El_CampoDeFechaDeAntiguedadNoPuedeEstarVacio"
					default="Error! El campo de fecha de antigüedad no puede estar vacio."	
					returnvariable="MSG_El_CampoDeFechaDeAntiguedadNoPuedeEstarVacio"/>
				<!--- valida la que campo de fecha EVfantig no sea nulo --->
				<cfif isdefined("dataTipoAccion.EVfantig") and len(trim(dataTipoAccion.EVfantig)) eq 0>
					<cf_throw message="#MSG_El_CampoDeFechaDeAntiguedadNoPuedeEstarVacio#" errorCode="12130">
					<cfabort>
				</cfif>
			<cfelseif dataTipoAccion.RHTcomportam EQ 10><!--- Anotación --->
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="MSG_El_CampoDeFechaDeVigenciaNoPuedeEstarVacio"
					default="Error! El campo de fecha de vigencia no puede estar vacia."	
					returnvariable="MSG_El_CampoDeFechaDeVigenciaNoPuedeEstarVacio"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="MSG_El_CampoTipoDeAnotacionNoPuedeEstarVacio"
					default="Error! El campo tipo de anotación no puede estar vacio."	
					returnvariable="MSG_El_CampoTipoDeAnotacionNoPuedeEstarVacio"/>	
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="MSG_El_CampoTextoDeLaAnotacionNoPuedeEstarVacio"
					default="Error! El campo texto de la anotación no puede estar vacio."	
					returnvariable="MSG_El_CampoTextoDeLaAnotacionNoPuedeEstarVacio"/>		
				<!--- valida la que campo de fecha DLfvigencia no sea nulo --->
				<cfif isdefined("dataTipoAccion.DLfvigencia") and len(trim(dataTipoAccion.DLfvigencia)) eq 0>
					<cf_throw message="#MSG_El_CampoDeFechaDeVigenciaNoPuedeEstarVacio#" errorCode="12135">
					<cfabort>
				</cfif>
				<!--- valida la que campo RHAtipo no sea nulo --->
				<cfif isdefined("dataTipoAccion.RHAtipo") and len(trim(dataTipoAccion.RHAtipo)) eq 0>
					<cf_throw message="#MSG_El_CampoTipoDeAnotacionNoPuedeEstarVacio#" errorCode="12140">
					<cfabort>
				</cfif>
				<!--- valida la que campo RHAdescripcion no sea nulo  y que no venga vacio.--->
				<cfif isdefined("dataTipoAccion.RHAdescripcion") and len(trim(dataTipoAccion.RHAdescripcion)) eq 0>
					<cf_throw message="#MSG_El_CampoTextoDeLaAnotacionNoPuedeEstarVacio#" errorCode="12140">
					<cfabort>
				</cfif>
			<cfelseif dataTipoAccion.RHTcomportam EQ 14><!--- CAMBIO DE PUESTO ALTERNO--->
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="MSG_El_CampoPuestoNoPuedeEstarVacio"
					default="Error! El campo Puesto no puede estar vacio."	
					returnvariable="MSG_El_CampoPuestoNoPuedeEstarVacio"/>		
				<!--- valida la que campo de fecha DLfvigencia no sea nulo --->
				<cfif isdefined("dataTipoAccion.RHPcodigo") and len(trim(dataTipoAccion.RHPcodigo)) eq 0>
					<cf_throw message="#MSG_El_CampoPuestoNoPuedeEstarVacio#" errorCode="12141">
					<cfabort>
				</cfif>
			</cfif>
		</cfif>
		<!--- Validaciones adicionales --->
		<cfif Arguments.validar>
			<!--- ********************************************************************************************* --->
			<!---                                 Acciones de tipo normal                                       --->
			<!--- ********************************************************************************************* --->
			<cfif RHTespecial eq  0>
				<!--- Quita las horas de las fechas --->
				<cfset LvarTemp = LSDateFormat(Fdesde, 'dd/mm/yyyy')>
				<cfset Fdesde = CreateDate(ListGetAt(LvarTemp, 3, '/'), ListGetAt(LvarTemp, 2, '/'), ListGetAt(LvarTemp, 1, '/'))>
				<cfset LvarTemp = LSDateFormat(Fhasta, 'dd/mm/yyyy')>
				<cfset Fhasta = CreateDate(ListGetAt(LvarTemp, 3, '/'), ListGetAt(LvarTemp, 2, '/'), ListGetAt(LvarTemp, 1, '/'))>
				<!--- Si la Acción NO es de nombramiento primero valida que deba de existir una de estas previamente. --->
				<cfif dataTipoAccion.RHTcomportam NEQ 1>
					<cfquery name="checkLT" datasource="#Arguments.conexion#">
						select 1 
						from LineaTiempo a 
						where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
					</cfquery>
					<cfif checkLT.recordCount EQ 0>
						<cfthrow message="#MSG_EAccionesPrevias#">
						<cfabort>
					</cfif>
				</cfif>
				<!--- Si la Accion es de Nombramiento --->
				<cfif dataTipoAccion.RHTcomportam EQ 1>
					<!---Si la acción es de Nombramiento, no puede caerle encima a otras acciones que tengan vigencia dentro de las fechas de la Accion --->
					<cfquery name="checkLT" datasource="#Arguments.conexion#">
						select 1 
						from LineaTiempo a 
						where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
						and (
							LTdesde between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
						 or LThasta between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
						)
					</cfquery>
					<cfif checkLT.recordCount>
						<cf_throw message="#MSG_EYaExisteAccionRegistrada#" errorCode="12145">
						<cfabort>
					</cfif>
					<!--- Si es de Nombramiento No debe de existir un CESE previo que No permita movimientos posteriores --->
					<cfquery name="checkLT" datasource="#Arguments.conexion#">
						select 1 
						from LineaTiempo a, RHTipoAccion b 
						where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
						and a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
						and a.RHTid = b.RHTid 
						and b.RHTcomportam = 2 
						and RHTposterior = 0
					</cfquery>
					<cfif checkLT.recordCount>
						<cf_throw message="#MSG_EmpleadoCesado#" errorCode="12150">
						<cfabort>
					</cfif>
					<!--- Si es de Nombramiento, No puede caerle encima a otro nombramiento que esté vigente --->
					<cfquery name="checkLT" datasource="#Arguments.conexion#">
						select 1 
						from LineaTiempo a, RHTipoAccion b 
						where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
						and b.RHTcomportam = 1 
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#"> between a.LTdesde and a.LThasta
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#"> between a.LTdesde and a.LThasta
					</cfquery>
					<cfif checkLT.recordCount>
						<cf_throw message="#MSG_YaExisteAccionNombramiento#" errorCode="12155">
						<cfabort>
					</cfif>
				</cfif>
				<!--- Si la Accion es de CESE --->
				<cfif dataTipoAccion.RHTcomportam EQ 2>
					<cfquery name="checkLT" datasource="#Arguments.conexion#">
						select 1 
						from LineaTiempo 
						where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#"> between LTdesde and LThasta
					</cfquery>
					<cfif checkLT.recordCount EQ 0>
						<cf_throw message="#MSG_EAccionCese#" errorCode="12160">
						<cfabort>
					</cfif>
				</cfif>			
				<cfif dataTipoAccion.RHTcomportam NEQ 1 and dataTipoAccion.RHTcomportam NEQ 2>
					<!--- La fecha desde tiene que caer en un rango existente --->
					<cfquery name="checkLT" datasource="#Arguments.conexion#">
						select 1 
						from LineaTiempo 
						where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#"> between LTdesde and LThasta
					</cfquery>
					<cfif checkLT.recordCount EQ 0>
						<cf_throw message="#MSG_EAccionLineaTiempo#" errorCode="12165">
						<cfabort>
					</cfif>
					<!--- La fecha desde tiene que caer en un rango existente --->
					<cfquery name="checkLT" datasource="#Arguments.conexion#">
						select 1 
						from LineaTiempo 
						where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#"> between LTdesde and LThasta
					</cfquery>
					<cfif checkLT.recordCount EQ 0>
						<cfquery name="checkMaxLTid" datasource="#Arguments.conexion#">
						select max (LThasta) as Fhasta
						from LineaTiempo 
						where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">						
						</cfquery>
						<cfif checkMaxLTid.recordCount EQ 0>					
									<cf_throw message="#MSG_EAccionLineaTiempo#" errorCode="12165">
									<cfabort>
						<cfelse>
									<cfset Fhasta= "#checkMaxLTid.Fhasta#">	
									<cfquery datasource="#Arguments.conexion#">
										update RHAcciones
										set DLffin = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
										Where RHAlinea= <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Arguments.RHAlinea#"/> 
									</cfquery>
						 </cfif>
	               </cfif>										
				</cfif>
				<!--- Validar el cantidad de dias antes de volver a compensar que se encuentre dentro de rango definido en el régimen --->
				<cfif dataTipoAccion.RHTcomportam EQ 3>
					<!--- Buscar fecha de antiguedad del empleado --->
					<cfquery name="rsFechaAntiguedad" datasource="#Arguments.conexion#">
						select EVfantig
						from EVacacionesEmpleado
						where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
					</cfquery>
					<cfif Len(Trim(rsFechaAntiguedad.EVfantig)) EQ 0>
						<cf_throw message="#MSG_ENoTieneAntiguedad#" errorCode="12170">
					</cfif>
					<cfset vFechaAntig = ListToArray(LSDateFormat(rsFechaAntiguedad.EVfantig,'dd/mm/yyyy'),'/')>
					<cfset fecha_ingreso = Createdate(vFechaAntig[3],vFechaAntig[2],vFechaAntig[1]) >
					<cfset vFecha = ListToArray(LSDateFormat(Fdesde,'dd/mm/yyyy'),'/')>
					<cfset fecha_corte = Createdate(vFecha[3],vFecha[2],vFecha[1]) >
					<!--- calcula la cantidad de años laborados, a partir de la fecha ingreso --->
					<cfset annoslaborados = DateDiff('yyyy', fecha_ingreso, fecha_corte)>
					<!--- dias de verificación de compensación según regimen --->
					<cfquery name="rsDiasvericomp" datasource="#Arguments.conexion#">
						select coalesce(rv.DRVdiasvericomp, 0) as DRVdiasvericomp
						from DRegimenVacaciones rv 
						where rv.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTipoAccion.RVid#">
						  and rv.DRVcant = ( select coalesce(max(DRVcant),1) 
											 from DRegimenVacaciones rv2 
											 where rv2.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTipoAccion.RVid#">
											   and rv2.DRVcant <= <cfqueryparam cfsqltype="cf_sql_float" value="#annoslaborados#"> 
											)
					</cfquery>
					<cfset vDiasvericomp = rsDiasvericomp.DRVdiasvericomp>
					<!--- Busca la fecha hasta de la ultima accion de vacaciones con compensación --->
					<cfquery name="rsFechaDL" datasource="#Arguments.conexion#">
						select max(DLffin) as DLffin
						from DLaboralesEmpleado dl
						inner join DVacacionesEmpleado dv
						   on dv.DEid = dl.DEid
						  and DVEcompensados != 0
						  and DVEreferencia = dl.DLlinea
						where dl.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
						  and dl.DLffin < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
					</cfquery>
					<cfif isdefined('rsFechaDL') and rsFechaDL.recordCount GT 0 and Len(Trim(rsFechaDL.DLffin)) NEQ 0>
						<cfset vFechaUltA = ListToArray(LSDateFormat(rsFechaDL.DLffin,'dd/mm/yyyy'),'/')>
						<cfset fechaUltA = Createdate(vFechaUltA[3],vFechaUltA[2],vFechaUltA[1]) >
						<cfset diasCompensacion = DateDiff('d', fechaUltA, Fdesde)>
						<cfif diasCompensacion LTE vDiasvericomp>
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							key="LB_msg4"
							default="Error! Ya existe una acción de compensación de vacaciones en el rango permitido por el régimen "
							returnvariable="LB_msg4"/> 
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							key="LB_msg5"
							default="La fecha rige de la nueva acción debe ser mayor.  Proceso Cancelado!"
							returnvariable="LB_msg5"/> 
							
							<cf_throw message="#MSG_ENoTieneAntiguedad#" errorCode="12170">
							<cfthrow message="#LB_msg4#&nbsp; (#vDiasvericomp# días)&nbsp;#LB_msg5#&nbsp;">
							<cfabort>
						</cfif>
					</cfif>
				</cfif>
				<!--- Se valida únicamente si el tipo de acción es nombramiento, cambio o cambio de empresa --->
				<cfif dataTipoAccion.RHTcomportam EQ 1 or dataTipoAccion.RHTcomportam EQ 6 or dataTipoAccion.RHTcomportam EQ 9>
					<!--- Validación del Presupuesto para la Plaza si el parámetro está encendido --->
					<cfif dataTipoAccion.RHTcomportam EQ 9 and Len(Trim(dataTipoAccion.EcodigoRef))>
						<cfset LvarEmpresa = dataTipoAccion.EcodigoRef>
					<cfelse>
						<cfset LvarEmpresa = Arguments.Ecodigo>
					</cfif>
					<cfquery name="paramValPresupuesto" datasource="#Arguments.conexion#">
						select Pvalor from RHParametros 
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">
						and Pcodigo = 540
					</cfquery>
					<cfif paramValPresupuesto.recordCount GT 0 and paramValPresupuesto.Pvalor EQ 1>
						<cfinvoke component="rh.Componentes.RH_PlazaVal" method="validarPlazaLT" returnvariable="LvarError">
							<cfinvokeargument name="RHAlinea" value="#Arguments.RHAlinea#"/> 
							<cfinvokeargument name="Ecodigo" value="#Arguments.Ecodigo#"/> 
							<cfinvokeargument name="conexion" value="#Arguments.conexion#"/> 
						</cfinvoke>
						<cfif Len(Trim(LvarError))>
							<cfthrow message="#LvarError#. #MSG_ProcesoCancelado#">
							<cfabort>
						</cfif>
					</cfif>
				</cfif>
			</cfif>
		</cfif> <!--- FIN Arguments.validar --->
	</cffunction>
    <!--- PROCESAMIENTO DE LA ACCION PARA REGISTRO EN DLABORALES EMPLEADO --->
	<cffunction name="Parte2" access="private" output="false">
    	<cfargument name="Ecodigo" 		type="numeric" 	required="yes" default="#Session.Ecodigo#">
		<cfargument name="RHAlinea" 	type="numeric" 	required="yes">	
		<cfargument name="Usucodigo" 	type="string" 	required="no" default="#Session.Usucodigo#">
		<cfargument name="conexion" 	type="string" 	required="no" default="#Session.DSN#">
		<cfargument name="validar" 		type="boolean" 	required="no" default="false">
		<cfargument name="respetarLT" 	type="boolean" 	required="no" default="false">		
		<cfargument name="debug" 		type="boolean" 	required="no" default="false">

			<cfquery name="nextConsec" datasource="#Arguments.conexion#">
				select coalesce(max(DLconsecutivo), 0) + 1 as consec
				from DLaboralesEmpleado 
				<!--- Cambio de Empresa --->
				<cfif dataTipoAccion.RHTcomportam EQ 9 and dataTipoAccion.RHTcempresa EQ 1>
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#dataTipoAccion.EcodigoRef#">
				<cfelse>
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				</cfif>
			</cfquery>
			<cfquery name="insDLaboralesEmpleado" datasource="#Arguments.conexion#">
				insert into DLaboralesEmpleado (
					DLconsecutivo,	DEid, 			RHTid, 
					Ecodigo, 		RHPid, 			RHPcodigo, 
					Tcodigo, 		RVid, 			Dcodigo, 
					Ocodigo, 		DLfvigencia, 	DLffin, 
					DLsalario, 		DLobs, 			DLfechaaplic, 
					Usucodigo, 		Ulocalizacion, 	DLporcplaza,
					DLporcsal,		DLidtramite,	RHJid,
					DLvdisf,		DLvcomp,		IEid,
					TEid,			RHCPlinea,		RHCconcurso,
					Indicador_de_Negociado,			RHAid,
					RHItiporiesgo,	RHIconsecuencia,RHIcontrolincapacidad,
					RHfolio,		RHporcimss,		RHTtiponomb,RHPcodigoAlt,
					DLsalarioSDI,	DLreplicacion
					)
				select 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#nextConsec.consec#">,
					a.DEid,			a.RHTid,
					<cfif dataTipoAccion.RHTcomportam EQ 9 and dataTipoAccion.RHTcempresa EQ 1>
						a.EcodigoRef,
					<cfelse>
						a.Ecodigo,
					</cfif>
					a.RHPid,
					a.RHPcodigo,
					<cfif dataTipoAccion.RHTcomportam EQ 9 and dataTipoAccion.RHTcempresa EQ 1>
						a.TcodigoRef,
					<cfelse>
						a.Tcodigo,
					</cfif>
					a.RVid,				a.Dcodigo,			a.Ocodigo,
					a.DLfvigencia, 		a.DLffin, 			a.DLsalario, 
					a.DLobs, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">,
					'00',
					a.RHAporc,			a.RHAporcsal,		a.RHAidtramite,
					a.RHJid,
					case when a.RHAvdisf is null then 0.00 else a.RHAvdisf end,
					case when a.RHAvcomp is null then 0.00 else a.RHAvcomp end,
					a.IEid,				a.TEid,						a.RHCPlinea,
					a.RHCconcurso,		a.Indicador_de_Negociado,	a.RHAid,
					<!---ljimenez incluye parametros adicionales para accion tipo incapacidad de mexico--->
					case when a.RHItiporiesgo is null then 0 else a.RHItiporiesgo end,
					case when a.RHIconsecuencia is null then 0 else a.RHIconsecuencia end,
					case when a.RHIcontrolincapacidad is null then 0 else a.RHIcontrolincapacidad end,
					a.RHfolio, a.RHporcimss,	
					<!---ljimenez incluye el tipo de nombramiento ya que no se registra en dlaborales utiliza en mexico--->
					b.RHTtiponomb,RHPcodigoAlt, coalesce(a.DLsalarioSDI,0) as DLsalarioSDI,coalesce(RHTipoAplicacion,0)
				from RHAcciones a, RHTipoAccion b
				where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
				  and a.RHTid = b.RHTid
				<cf_dbidentity1 datasource="#Arguments.conexion#" verificar_transaccion="no">
			</cfquery>
			<cf_dbidentity2 datasource="#Arguments.conexion#" name="insDLaboralesEmpleado" verificar_transaccion="no">
			<!--- Agregar detalle de Datos Laborales --->
			<cfquery name="insDDLaboralesEmpleado" datasource="#Arguments.conexion#">
				insert into DDLaboralesEmpleado (DLlinea, CSid, DDLtabla, DDLunidad, DDLmontobase, DDLmontores,DDLmetodoC, Usucodigo, Ulocalizacion, CIid)
				select 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#insDLaboralesEmpleado.identity#">,
					a.CSid, 			a.RHDAtabla, 	a.RHDAunidad, 
					a.RHDAmontobase, 	a.RHDAmontores, a.RHDAmetodoC, a.Usucodigo, 
					a.Ulocalizacion,	cs.CIid
				from RHDAcciones a
					inner join ComponentesSalariales cs
					   on cs.CSid = a.CSid
				where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
			</cfquery>
			<!--- Agregar Detallle de Conceptos de Pago por Accion --->
			<cfquery name="insDDConceptosEmpleado" datasource="#Arguments.conexion#">
				insert into DDConceptosEmpleado (DLlinea, CIid, DDCimporte, DDCres, DDCcant, DDCcalculo)
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#insDLaboralesEmpleado.identity#">, CIid, RHCAimporte, RHCAres, RHCAcant, CIcalculo
				from RHConceptosAccion
				where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
			</cfquery>
			<!---Agregar Salario Promedio Acciones en tabla Historicos. CarolRS--->
			<cfquery name="rsSalPromAcc" datasource="#Session.DSN#">
				Delete from DLSalPromAccion where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insDLaboralesEmpleado.identity#">
			</cfquery>
			<cfquery datasource="#Session.DSN#" name="rs">
				insert into DLSalPromAccion (RCNid,DLlinea,DEid,RHSPAmonto,RHSPAdias )
				select RCNid,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#insDLaboralesEmpleado.identity#">
					,DEid
					,RHSPAmonto
					,RHSPAdias
				from RHSalPromAccion
				where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
			</cfquery>
			
			<!--- Actualizo la situacion anterior en DatosLaboralesEmpleado y en el Detalle --->
			<cfquery name="LTiempo" datasource="#Arguments.conexion#">
				select
					b.Dcodigo, 		b.Ocodigo, 		b.RHPid,
					b.RHPcodigo,	b.Tcodigo,		b.LTsalario,
					b.RVid,			b.LTporcplaza,	b.LTporcsal,
					b.RHJid,		b.LTid,			b.Ecodigo,
					coalesce(b.LTsalarioSDI,0) as LTsalarioSDI
				from DLaboralesEmpleado a, LineaTiempo b
				where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insDLaboralesEmpleado.identity#">
				  and a.DEid = b.DEid
				  and a.DLfvigencia between b.LTdesde and b.LThasta
			</cfquery>
			<cfif LTiempo.recordCount GT 0>
				<cfquery name="updDLaboralesEmpleado" datasource="#Arguments.conexion#">
					update DLaboralesEmpleado set 
						Ecodigoant = <cfqueryparam cfsqltype="cf_sql_integer" value="#LTiempo.Ecodigo#">,
						Dcodigoant = <cfqueryparam cfsqltype="cf_sql_integer" value="#LTiempo.Dcodigo#">,
						Ocodigoant = <cfqueryparam cfsqltype="cf_sql_integer" value="#LTiempo.Ocodigo#">,
						RHPidant = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LTiempo.RHPid#">,
						RHPcodigoant = <cfqueryparam cfsqltype="cf_sql_char" value="#LTiempo.RHPcodigo#">,
						Tcodigoant = <cfqueryparam cfsqltype="cf_sql_char" value="#LTiempo.Tcodigo#">,
						DLsalarioant = <cfqueryparam cfsqltype="cf_sql_money" value="#LTiempo.LTsalario#">,
						RVidant = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LTiempo.RVid#">,
						DLporcplazaant = <cfqueryparam cfsqltype="cf_sql_float" value="#LTiempo.LTporcplaza#">,
						DLporcsalant = <cfqueryparam cfsqltype="cf_sql_float" value="#LTiempo.LTporcsal#">,
						RHJidant = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LTiempo.RHJid#">,
						DLsalarioSDIant = <cfqueryparam cfsqltype="cf_sql_money" value="#LTiempo.LTsalarioSDI#">
					where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insDLaboralesEmpleado.identity#">
				</cfquery>
				<cfquery name="updDDLaboralesEmpleado" datasource="#Arguments.conexion#">
					update DDLaboralesEmpleado 
					   set
						DDLunidadant = 
							(
								select c.DLTunidades
								  from DLineaTiempo c
								 where c.LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LTiempo.LTid#">
								   and c.CSid = DDLaboralesEmpleado.CSid
							),
						DDLmontobaseant =
							(
								select c.DLTmonto
								  from DLineaTiempo c
								 where c.LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LTiempo.LTid#">
								   and c.CSid = DDLaboralesEmpleado.CSid
							),
						DDLmontoresant = 
							(
								select c.DLTmonto
								  from DLineaTiempo c
								 where c.LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LTiempo.LTid#">
								   and c.CSid = DDLaboralesEmpleado.CSid
							),
						DDLmetodoCant =
							(
								select c.DLTmetodoC
								  from DLineaTiempo c
								 where c.LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LTiempo.LTid#">
								   and c.CSid = DDLaboralesEmpleado.CSid
							)	
					where DDLaboralesEmpleado.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insDLaboralesEmpleado.identity#">
					  and exists 
							(
								select 1
								  from DLineaTiempo c
								 where c.LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LTiempo.LTid#">
								   and c.CSid = DDLaboralesEmpleado.CSid
							)
				</cfquery>
			</cfif>
		<cfreturn insDLaboralesEmpleado.identity>
    </cffunction>
	<!--- PROCESO PARA ACCIONES ESPECIALES --->
	<cffunction name="Parte3" access="private" output="false">
    	<cfargument name="Ecodigo" 		type="numeric" 	required="yes" default="#Session.Ecodigo#">
		<cfargument name="RHAlinea" 	type="numeric" 	required="yes">	
		<cfargument name="Usucodigo" 	type="string" 	required="no" default="#Session.Usucodigo#">
		<cfargument name="conexion" 	type="string" 	required="no" default="#Session.DSN#">
		<cfargument name="validar" 		type="boolean" 	required="no" default="false">
		<cfargument name="respetarLT" 	type="boolean" 	required="no" default="false">		
		<cfargument name="debug" 		type="boolean" 	required="no" default="false">
			<cfif dataTipoAccion.RHTcomportam EQ 10>
			<!--- inserta la anotación --->
				
				<cfquery name="RSInsAnotacion" datasource="#Arguments.conexion#">
					insert into RHAnotaciones 
							(DEid, RHAfecha, RHAfsistema, RHAdescripcion, Usucodigo, Ulocalizacion, RHAtipo)
							values (
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTipoAccion.DEid#">,
								<cfqueryparam value="#dataTipoAccion.fechadesde#" cfsqltype="cf_sql_timestamp">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#dataTipoAccion.RHAdescripcion#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Ulocalizacion#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#dataTipoAccion.RHAtipo#">
					)
				</cfquery>
			<cfelseif dataTipoAccion.RHTcomportam EQ 11>
				<!--- recupera la fecha de antiguedad y la fecha de la ultima asignacion de vacaciones --->
				<cfquery name="rs_fechas" datasource="#Arguments.conexion#">
					select EVfantig, EVfecha
					from EVacacionesEmpleado
					where DEid = #dataTipoAccion.DEid#
				</cfquery>
				<cfset fecha_antig = rs_fechas.EVfantig >
				<!---<cfset fecha_vacac = rs_fechas.EVfecha >--->
				<cfset fecha_vacac = now() >
				<cfset fecha_antig_propuesta = dataTipoAccion.EVfantig >
				<cfset fecha_vacac_propuesta = createdate(datepart('yyyy', fecha_vacac), datepart('m', fecha_antig_propuesta), datepart('d', fecha_antig_propuesta) ) >
				<!--- 	Fecha de vacaciones proppuesta es mayor a la fecha de vacaciones actual 
						Esto implica que debe restarse un anno a la fech avacaciones propuesta.
				--->
				
				<cfif DateCompare(fecha_vacac_propuesta, fecha_vacac) eq 1 >
					<cfset fecha_vacac_propuesta = dateadd('yyyy', -1, fecha_vacac_propuesta) >
				</cfif>
				
				<!--- fecha propuesta no puede ser menor a fecha de antiguedad --->
				<cfif DateCompare(fecha_vacac_propuesta, fecha_antig_propuesta) eq -1 >
					<cfset fecha_vacac_propuesta = fecha_antig_propuesta >
				</cfif> 	

				<!--- modifica la fecha de antiguedad --->
				<cfquery name="RSUpAntiguedad" datasource="#Arguments.conexion#">
					update EVacacionesEmpleado 
					set EVfantig = <cfqueryparam value="#dataTipoAccion.EVfantig#" cfsqltype="cf_sql_date"> ,
						EVfecha  = <cfqueryparam value="#fecha_vacac_propuesta#" cfsqltype="cf_sql_date">,
						EVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#datepart('m',fecha_antig_propuesta)#">,
						EVdia = <cfqueryparam cfsqltype="cf_sql_integer" value="#datepart('d',fecha_antig_propuesta)#">
					where DEid = #dataTipoAccion.DEid#
				</cfquery>
			<cfelseif dataTipoAccion.RHTcomportam EQ 14><!--- ASIGNA UN PUESTO ALTERNO AL FUNCIONARIO --->
				<cfquery name="rsLTid" datasource="#session.DSN#">
					select max(LTid) as LTid
					from LineaTiempo
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTipoAccion.DEid#">
					  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#"> between LTdesde and LThasta
				</cfquery>
				<cfquery name="rsUpdateLT" datasource="#session.DSN#">
					update LineaTiempo
					set RHPcodigoAlt = <cfqueryparam cfsqltype="cf_sql_char" value="#dataTipoAccion.RHPcodigo#">,
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTid.LTid#">
					  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTipoAccion.DEid#">
				</cfquery>
			</cfif>
			
			<!--- Agregar la Accion a los Datos Laborales del Empleado --->
			<cfquery name="nextConsec" datasource="#Arguments.conexion#">
				select coalesce(max(DLconsecutivo), 0) + 1 as consec
				from DLaboralesEmpleado 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			</cfquery>
			<cfquery name="rsAccion" datasource="#arguments.conexion#">
				select *
				from RHAcciones
				where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#"> 
			</cfquery>

			<cfquery name="insDLaboralesEmpleado" datasource="#Arguments.conexion#">
				 insert into DLaboralesEmpleado (
					DLconsecutivo,  		DEid, 				RHTid, 
					Ecodigo, 				RHPid, 				RHPcodigo, 
					Tcodigo, 				RVid, 				Dcodigo, 
					Ocodigo, 				DLfvigencia, 		DLffin, 
					DLsalario, 				DLobs, 				DLfechaaplic, 
					Usucodigo, 				Ulocalizacion, 		DLporcplaza,
					DLporcsal,				DLidtramite,		RHJid,
					DLvdisf,				DLvcomp,			IEid,
					TEid,					RHCPlinea,			RHCconcurso,
					Indicador_de_Negociado,	RHAid,				RHAtipo,
					RHAdescripcion,			EVfantig					
					) 
				select 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#nextConsec.consec#">,
					a.DEid,
					a.RHTid,
					a.Ecodigo,
					c.RHPid,
					c.RHPcodigo,
					a.Tcodigo,
					c.RVid,
					a.Dcodigo,
					a.Ocodigo,
					a.DLfvigencia, 
					a.DLffin, 
					c.LTsalario, 
					a.DLobs, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">,
					'00',
					a.RHAporc,
                    case when b.RHTespecial = 1 then 0 else a.RHAporcsal end as RHAporcsal,
					a.RHAidtramite,
					c.RHJid,
					case when a.RHAvdisf is null then 0.00 else a.RHAvdisf end,
					case when a.RHAvcomp is null then 0.00 else a.RHAvcomp end,
					a.IEid,
					a.TEid,
					a.RHCPlinea,
					a.RHCconcurso,
					a.Indicador_de_Negociado,
					a.RHAid,
					<cfif dataTipoAccion.RHTcomportam EQ 10>
						a.RHAtipo,
						a.RHAdescripcion,
						null	
					<cfelseif dataTipoAccion.RHTcomportam EQ 11>
						null,
						null,
						a.EVfantig	
					<cfelse>
						null,null,null
					</cfif>
				from RHAcciones a, RHTipoAccion b , LineaTiempo c 
				where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
				  and a.RHTid = b.RHTid
				  and a.DLfvigencia between c.LTdesde and c.LThasta
				  and a.Ecodigo = c.Ecodigo
				  and a.DEid= c.DEid 
				  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			</cfquery>
			<!--- Borrar las Acciones en Proceso --->
			<cfquery name="delConceptos" datasource="#Arguments.conexion#">
				delete from RHConceptosAccion 
				where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
			</cfquery>
			<cfquery name="delDAcciones" datasource="#Arguments.conexion#">
				delete from RHDAcciones 
				where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
			</cfquery>
			<cfquery name="delAcciones" datasource="#Arguments.conexion#">
				delete from RHAcciones 
				where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
			</cfquery>
			<cftransaction action="commit" />
		<cfreturn>
    </cffunction>
	<!--- PROCESO POR TIPO DE COMPORTAMIENTO DE LA ACCION --->
	<cffunction name="Parte4" access="private" output="false">
    	<cfargument name="Ecodigo" 		type="numeric" 	required="yes" default="#Session.Ecodigo#">
		<cfargument name="RHAlinea" 	type="numeric" 	required="yes">	
		<cfargument name="Usucodigo" 	type="string" 	required="no" default="#Session.Usucodigo#">
		<cfargument name="conexion" 	type="string" 	required="no" default="#Session.DSN#">
		<cfargument name="validar" 		type="boolean" 	required="no" default="false">
		<cfargument name="respetarLT" 	type="boolean" 	required="no" default="false">		
		<cfargument name="debug" 		type="boolean" 	required="no" default="false">
			<!--- ESTO SE DEBE HACER SOLO SI EL COMPORTAMIENTO ES NOMBRAMIENTO --->
			<cfif dataTipoAccion.RHTcomportam EQ 1>
				<!--- AQUI SE AGREGAN LAS CARGAS AUTOMATICAS (DE LEY) A LA TABLA DE CARGAS POR EMPLEADO --->
				<cfquery name="insCargas" datasource="#Arguments.conexion#">
					insert into CargasEmpleado (DEid, DClinea, CEdesde, CEhasta)
					select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">, 
						   b.DClinea, 
					       <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">, 
						   null
					from ECargas a, DCargas b
					where a.ECauto = 1
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and a.ECid = b.ECid
					and not exists (
						select 1 
						from CargasEmpleado ce 
						where ce.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
						and ce.DClinea = b.DClinea
					)
				</cfquery>
				
			<!--- EN CASO DE QUE EL COMPORTAMIENTO SEA UN CAMBIO DE EMPRESA --->
			<cfelseif dataTipoAccion.RHTcomportam EQ 9 and dataTipoAccion.RHTcempresa EQ 1>
				<!--- 1. Actualizar las cargas de ley de la empresa origen como fecha hasta = fecha traslado - 1 --->
				<cfquery name="updCargas" datasource="#Arguments.conexion#">
					update CargasEmpleado set 
						CEhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', -1, Fdesde)#">
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
					and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#"> between CEdesde and coalesce(CEhasta, <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(6100, 01, 01)#">)
				</cfquery>
				<!--- 2. Actualizar las cargas empleado que existieran anteriormente para la nueva empresa, Reactivación de Cargas --->
				<cfquery name="updCargas" datasource="#Arguments.conexion#">
					update CargasEmpleado
						set CEdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">, CEhasta = null
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
					and exists (
						select 1
						from ECargas a, DCargas b
						where a.ECauto = 1
						and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#dataTipoAccion.EcodigoRef#">
						and a.ECid = b.ECid
						and b.DClinea = CargasEmpleado.DClinea
					)
				</cfquery>
				<!--- 3. Agregar las cargas de ley al empleado en la nueva empresa, con CEdesde = fecha traslado --->
				<cfquery name="insCargas" datasource="#Arguments.conexion#">
					insert into CargasEmpleado (DEid, DClinea, CEdesde, CEhasta)
					select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">, 
						   b.DClinea, 
					       <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">, 
						   null
					from ECargas a, DCargas b
					where a.ECauto = 1
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#dataTipoAccion.EcodigoRef#">
					and a.ECid = b.ECid
					and not exists (
						select 1 
						from CargasEmpleado ce 
						where ce.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
						and ce.DClinea = b.DClinea
					)
				</cfquery>
			</cfif>
			<!--- Desarrollo DHC - Baroda --->
			<!--- Solo se ejecuta si la accion es de incapacidad (5) y el parametro 960 esta prendido, osea si al empresa trabaja con dias de enfermedad --->			
			<cfif dataTipoAccion.RHTcomportam EQ 5>
				<cfquery name="rs_p960" datasource="#session.DSN#">
					select Pvalor
					from RHParametros
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and Pcodigo = 960
				</cfquery>
	
				<cfif trim(rs_p960.Pvalor) eq 1>
					<cfquery name="rs_saldodiasenf" datasource="#session.DSN#">
						select DEid, coalesce(sum(DVEenfermedad), 0) as dias
						from DVacacionesEmpleado
						where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
						group by DEid				
					</cfquery>
					<!--- solo si el saldo de dias de enfermedad del empleado son mayores a cero y si la accion va a rebajar una cantidad de dias mayor a cero --->
					<cfif len(trim(dataTipoAccion.RHAdiasenfermedad)) and dataTipoAccion.RHAdiasenfermedad gt 0 and len(trim(rs_saldodiasenf.dias)) and rs_saldodiasenf.dias gt 0 >
						<cfset vRebajarDiasEnf = dataTipoAccion.RHAdiasenfermedad >
						<cfif rs_saldodiasenf.dias - dataTipoAccion.RHAdiasenfermedad lte 0 >
							<cfset vRebajarDiasEnf = rs_saldodiasenf.dias >
						</cfif>	
						<!--- insertar Registro en DVacacionesEmpleado para el campo DVEenfermedad --->
						<cfset vRebajarDiasEnf = vRebajarDiasEnf * -1 >						
						<cfquery datasource="#session.DSN#">
							insert into DVacacionesEmpleado(	DEid,
																Ecodigo, 
																DVEfecha, 
																DVEdescripcion,
																DVEreferencia, 
																DVEdisfrutados, 
																DVEcompensados, 
																DVEenfermedad, 
																DVEadicionales, 
																DVEmonto, 
																Usucodigo, 
																Ulocalizacion)
							values( 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
										<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
										'Rebajo de días de enfermedad por accion de incapacidad',
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHAlinea#">,
										0,
										0,
										<cfqueryparam cfsqltype="cf_sql_float" value="#vRebajarDiasEnf#">,
										0,
										0.00,
										1,
										'00' )
						</cfquery>
					</cfif> <!--- saldos y dias a rebajar mayores a cero --->
				</cfif> <!--- empresa usa dias de enfermedad --->
			</cfif>	<!--- accion tipo 5 --->  
			<!--- Si la accion es de Vacaciones --->
			<!---<cfif dataTipoAccion.RHTcomportam EQ 1 OR dataTipoAccion.RHTcomportam EQ 2 OR dataTipoAccion.RHTcomportam EQ 3>--->
			<!--- Comportamiento de cese (2): 
				  Este codigo no va a ejecutar mas para las acciones de tipo de cese desde este punto. Ahora cuando la accion es de tipo cese, se realiza una programacion
				  diferente y se hace en el archivo rh/nomina/liquidacion/liquidacionProceso-paso4-SQL.cfm
			--->
			<cfif dataTipoAccion.RHTcomportam EQ 1 OR dataTipoAccion.RHTcomportam EQ 3 >
				<cfset ir_a_vacaciones = true >
				
				<!--- para las acciones de nombramiento temporal debe realizarse algunas validaciones previas antes de llamar al componente de vacaciones --->
				<cfif dataTipoAccion.RHTcomportam EQ 1>
					<!--- el empleado tiene historia --->
					<cfquery name="rs_tienehistoria" datasource="#arguments.conexion#">
						select 1
						from EVacacionesEmpleado
						where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
					</cfquery>

					<!--- en teoria el empleado va a ser recontratado (cese/recontratar, nombramiento temporal/continuidad al nombramiento) --->
					<cfif rs_tienehistoria.recordcount gt 0 >
						<!--- recupera la ultima fecha de cese del empleado --->
						<cfquery name="rs_ultimocese" datasource="#arguments.conexion#">
							select max(a.DLfvigencia) as fecha_cese
							from DLaboralesEmpleado a, RHTipoAccion b
							where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
							  and b.RHTid=a.RHTid
							  and b.RHTcomportam = 2
						</cfquery>

						<!--- recupera la ultima fecha de nombramiento del empleado y que no es el nombramiento actual--->
						<cfquery name="rs_ultimonombramiento" datasource="#arguments.conexion#">
							select max(a.DLfvigencia) as fecha_nombramiento
							from DLaboralesEmpleado a, RHTipoAccion b
							where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
							  and b.RHTid=a.RHTid
							  and b.RHTcomportam = 1
							  and a.DLfvigencia < <cfqueryparam cfsqltype="cf_sql_date" value="#dataTipoAccion.fechadesde#">
						</cfquery>
						
						<!--- caso 1. empleado es cesado y recontratado --->
						<cfif len(trim(rs_ultimocese.fecha_cese)) and datecompare(rs_ultimocese.fecha_cese, rs_ultimonombramiento.fecha_nombramiento) gt 0 >
							<!--- recupera el id del cese para referenciar DLaboralesEmpleado --->
							<cfquery name="rs_DLlinea" datasource="#arguments.conexion#">
								select DLlinea
								from DLaboralesEmpleado a, RHTipoAccion b
								where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
								  and b.RHTid=a.RHTid
								  and b.RHTcomportam = 2
								  and a.DLfvigencia = <cfqueryparam cfsqltype="cf_sql_date" value="#rs_ultimocese.fecha_cese#">
							</cfquery>
							<!--- verifica que al empleado en su cese se el haya aprobado la boleta de liquidacion --->
							<cfquery name="rs_liquidacion" datasource="#arguments.conexion#">
								select RHLPestado
								from RHLiquidacionPersonal
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
								  and DLlinea = <cfif len(trim(rs_DLlinea.DLlinea))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_DLlinea.DLlinea#"><cfelse>0</cfif>
							</cfquery>

							<!--- si la liquidacion no se aprobo, no se debe ejecutar el componente de vacaciones --->
							<cfif rs_liquidacion.RHLPestado eq 0 >
								<cfset ir_a_vacaciones = false >
							</cfif>

						<!--- caso 2. empleado es temporal y le renuevan contrato (no hay cese de por medio ), la validacion para esto ya 
									  quedo hecha en el if padre del else, pues ahi se determina que hay un ingreso sin cese y cae en este else.
									  Por eso se pone el valor false a la variable directamente --->
						<cfelse>	
							<cfset ir_a_vacaciones = false >
						</cfif>
						<!--- Actualizacion del parametro para la inicializacion de la antiguedad del empleado en caso de que se le vuelva a nombrar --->
						<cfif ir_a_vacaciones >
							<cfquery name="updEVacaciones" datasource="#Arguments.conexion#">
								update EVacacionesEmpleado
								set EVinicializar = 1
								where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#empleado#">
							</cfquery>
						</cfif>
					</cfif>
				</cfif>
				
				<cfif ir_a_vacaciones >
					<cfinvoke component="rh.Componentes.RH_VacacionesEmpleado" method="VacacionesEmpleado" returnvariable="LvarResult">
						<cfinvokeargument name="Ecodigo" value="#Arguments.Ecodigo#"/> 
						<cfinvokeargument name="RHAlinea" value="#Arguments.RHAlinea#"/> 
						<cfinvokeargument name="DLlinea" value="#insDLaboralesEmpleado.identity#"/> 
						<cfinvokeargument name="DEid" value="#Empleado#"/> 
						<cfinvokeargument name="Usucodigo" value="#Arguments.Usucodigo#"/> 
						<cfinvokeargument name="conexion" value="#Arguments.conexion#"/> 
						<cfinvokeargument name="debug" value="#Arguments.debug#"/> 
					</cfinvoke>
				</cfif>
			</cfif>
		<cfreturn>
        
	</cffunction>  
    
	<!--- INSERCION DE LOS INGRESOS PARA LIQUIDACIONES --->
	<cffunction name="Parte5" access="private" output="false">
    	<cfargument name="Ecodigo" 		type="numeric" 	required="yes" default="#Session.Ecodigo#">
		<cfargument name="RHAlinea" 	type="numeric" 	required="yes">	
		<cfargument name="Usucodigo" 	type="string" 	required="no" default="#Session.Usucodigo#">
		<cfargument name="conexion" 	type="string" 	required="no" default="#Session.DSN#">
		<cfargument name="validar" 		type="boolean" 	required="no" default="false">
		<cfargument name="respetarLT" 	type="boolean" 	required="no" default="false">		
		<cfargument name="debug" 		type="boolean" 	required="no" default="false">

		<!---<cftry>--->
        <cfif dataTipoAccion.RHTliquidatotal eq 1 >
            <cfinvoke component="rh.Componentes.RH_LiquidacionRenta" method="calcular_Renta" returnvariable="monto_renta">
                <cfinvokeargument name="DEid" value="#Empleado#">
            </cfinvoke>
        </cfif>
        
        
        <cfinvoke component="rh.Componentes.RH_AplicaAccion" method="FechaIngreso" returnvariable="LvarFingreso">
            <cfinvokeargument name="Ecodigo" 	value="#Arguments.Ecodigo#"/> 
            <cfinvokeargument name="RHAlinea"	value="#Arguments.RHAlinea#"/> 
            <cfinvokeargument name="DEid" 		value="#Empleado#"/> 
		</cfinvoke>

        <cfquery name="rsInsertLiqPersonal" datasource="#Arguments.conexion#">
            insert into RHLiquidacionPersonal (DLlinea, Ecodigo, DEid, RHLPestado, BMUsucodigo, fechaalta, RHLPrenta, RHLPfingreso)
            values (
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#insDLaboralesEmpleado.identity#">,
                <cfqueryparam  cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">, 
                0, 
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
                <cfif isdefined("monto_renta") and len(trim(monto_renta))><cfqueryparam cfsqltype="cf_sql_money" value="#abs(monto_renta)#"><cfelse>0</cfif>
                , <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFingreso#">
            )
        </cfquery>
        <!--- Inserción de Ingresos por Liquidación en forma automática --->
        <cfquery name="rsInsertLiqIngresos" datasource="#Arguments.conexion#">
            insert into RHLiqIngresos (DLlinea, DEid, CIid, Ecodigo, RHLPdescripcion, importe, fechaalta, RHLPautomatico, BMUsucodigo) 
            select <cfqueryparam cfsqltype="cf_sql_numeric" value="#insDLaboralesEmpleado.identity#">, 
                   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">, 
                   a.CIid,
                   <cfqueryparam  cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">,
                   b.CIdescripcion,
                   a.RHCAres, 
                   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
                   1,
                   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
            from RHConceptosAccion a, CIncidentes b
            where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
            and a.CIid = b.CIid
            and b.CItipo in (2,3) <!--- Solo sugiere los conceptos de tipo importe y los de tipo cálculo --->
        </cfquery>
        <!--- Inserción de Deducciones por Liquidación en forma automática --->
        <cfquery name="rsInsertLiqDeduccion" datasource="#Arguments.conexion#">
            insert into RHLiqDeduccion (DLlinea, DEid, Did, RHLDdescripcion, RHLDreferencia, SNcodigo, importe, fechaalta, RHLDautomatico, BMUsucodigo)
            select a.DLlinea, 
                   a.DEid, 
                   b.Did,
                   b.Ddescripcion, 
                   b.Dreferencia,
                   b.SNcodigo, 
                   b.Dsaldo,
                   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
                   1,
                   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
            from RHLiquidacionPersonal a, DeduccionesEmpleado b
            where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insDLaboralesEmpleado.identity#">
            and a.Ecodigo = b.Ecodigo
            and a.DEid = b.DEid
            and b.Dsaldo > 0
            and b.Dcontrolsaldo = 1
        </cfquery>
        <cfreturn>
	</cffunction> 
  
	<!---
        Generar los Conceptos de Pago 
        Asociados a la Accion 
        como Incidencias para la siguiente nomina
        
        Fecha de Incidencia = Fecha desde Acción que la esta generando
    --->

  	<cffunction name="Parte6" access="private" output="false">
    	<cfargument name="Ecodigo" 		type="numeric" 	required="yes" default="#Session.Ecodigo#">
		<cfargument name="RHAlinea" 	type="numeric" 	required="yes">	
		<cfargument name="Usucodigo" 	type="string" 	required="no" default="#Session.Usucodigo#">
		<cfargument name="conexion" 	type="string" 	required="no" default="#Session.DSN#">
		<cfargument name="validar" 		type="boolean" 	required="no" default="false">
		<cfargument name="respetarLT" 	type="boolean" 	required="no" default="false">		
		<cfargument name="debug" 		type="boolean" 	required="no" default="false">

        <cfset FechaIncidencia = Fdesde>
        <!---
            Actualizar el empleado como no calculado para todas las relaciones de calculo abietas (en proceso)
            Las relaciones abiertas son aquellas donde la fecha de envio sea nula.
        --->
        <cfquery name="updSalario" datasource="#Arguments.conexion#">
            update SalarioEmpleado 
                set SEcalculado = 0
            where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
            and SEcalculado != 0
            and exists (
                select 1
                from RCalculoNomina cn
                where cn.RCNid = SalarioEmpleado.RCNid
                and cn.RChasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaIncidencia#">
                and cn.RCestado = 0
                and exists (
                    select 1 
                    from CalendarioPagos cp 
                    where cp.CPid = cn.RCNid 
                    and cp.CPfcalculo is not null
                    and cp.CPfenvio is null
                )
            )
        </cfquery>  
        <!---
            -- Si ya para la fecha desde de la Accion hay un pago generado, Fecha Incidencia = Fecha hasta de la Accion
            if exists (select 1 from CalendarioPagos where Ecodigo = @Ecodigo and Tcodigo = @Tcodigo and @fechadesde between CPdesde and CPhasta and CPfenvio is not null) begin
                select @fechaincidencia = @fechahasta
            end
            -- Si ya la fecha hasta está pagada, Fecha Incidencia = Fecha desde del siguiente calendario de Pago (minima libre)
        --->
        <!--- Actualiza los conceptos de Pago si ya existen (los suma) --->
        <cfset fechaformateada = LSDateFormat(FechaIncidencia, 'dd/mm/yyyy')>
        <cfquery name="updIncidencias" datasource="#Arguments.conexion#">
            update Incidencias
                set Ivalor = Ivalor + coalesce((select a.RHCAcant
                                                from RHAcciones c, RHConceptosAccion a, ConceptosTipoAccion b
                                                where c.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                                and a.RHCAres != 0.00
                                                and c.RHAlinea = a.RHAlinea
                                                and b.RHTid = c.RHTid
                                                and b.CIid = a.CIid
                                                and b.CTAsalario = 0
                                                and Incidencias.DEid = c.DEid
                                                and Incidencias.CIid = a.CIid
                                                ), 0),
                        Imonto = Imonto + coalesce((select a.RHCAres
                                                from RHAcciones c, RHConceptosAccion a, ConceptosTipoAccion b
                                                where c.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                                and a.RHCAres != 0.00
                                                and c.RHAlinea = a.RHAlinea
                                                and b.RHTid = c.RHTid
                                                and b.CIid = a.CIid
                                                and b.CTAsalario = 0
                                                and Incidencias.DEid = c.DEid
                                                and Incidencias.CIid = a.CIid
                                                ), 0)													
            where Ifecha = (	select case when coalesce(CImodFechaReg,0) = 1 then
                                        <cf_dbfunction name="dateadd" args="(CItipoAjuste*CIdiasAjuste),'#fechaformateada#'"> 
                                    else
                                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaIncidencia#">
                                 end
                                from RHAcciones c, RHConceptosAccion a, ConceptosTipoAccion b, CIncidentes  d
                                where c.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                and a.RHCAres != 0.00
                                and c.RHAlinea = a.RHAlinea
                                and c.RHTid = b.RHTid
                                and a.CIid = b.CIid
                                and b.CTAsalario = 0
                                and b.CIid = d.CIid
                                and Incidencias.DEid = c.DEid
                                and Incidencias.CIid = a.CIid
            )
            
            and exists (	select  1
                            from RHAcciones c, RHConceptosAccion a, ConceptosTipoAccion b
                            where c.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                            and a.RHCAres != 0.00

                            and c.RHAlinea = a.RHAlinea
                            and c.RHTid = b.RHTid
                            and a.CIid = b.CIid
                            and b.CTAsalario = 0
                            and Incidencias.DEid = c.DEid
                            and Incidencias.CIid = a.CIid
                        )
        </cfquery>
        <!--- Insertar los Conceptos de Pago como Incidencias --->
        
        <cfquery name="insIncidencias" datasource="#Arguments.conexion#">
            insert into Incidencias ( DEid, CIid, Ifecha, Ivalor,Imonto, Ifechasis, Usucodigo, Ulocalizacion, Icpespecial,
                                      Iestado, Iusuaprobacion, Ifechaaprobacion, Inumdocumento, NRP, NAP )
            select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">, 
                   a.CIid, 
                   case when coalesce(CImodFechaReg,0) = 1 then
                        <cf_dbfunction name="dateadd" args="(CItipoAjuste*CIdiasAjuste),'#fechaformateada#'"> 
                   else
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaIncidencia#">
                   end, 
                   a.RHCAcant,
                   a.RHCAres,
                   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
                   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">, 
                   '00',
                   case when coalesce(CImodNominaSP,0) = 1 then
                     1
                   else
                     0
                   end,
                   1,
                   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                   0,		<!--- puesto a dedo --->
                   null, 
                   200		<!--- puesto a dedo hasta que haya interfaz con presupuesto --->
                   
            from RHAcciones c, RHConceptosAccion a, ConceptosTipoAccion b , CIncidentes  d
            where c.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
            and a.RHAlinea = c.RHAlinea
            and a.RHCAres != 0.00
            and b.RHTid = c.RHTid
            and b.CIid = a.CIid
            and b.CTAsalario = 0
            and b.CIid = d.CIid
            and not exists(
                select 1 from Incidencias i
                where i.DEid = c.DEid 
                and i.Ifecha = (select  case when coalesce(x.CImodFechaReg,0) = 1 then
                                        <cf_dbfunction name="dateadd" args="(CItipoAjuste*CIdiasAjuste),'#fechaformateada#'"> 
                                   else
                                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaIncidencia#">
                                   end
                                from    CIncidentes x
                                where  i.CIid = x.CIid)
                and i.CIid = a.CIid
            )
        </cfquery>
        <cfquery name="rsSalarios" datasource="#Arguments.conexion#">
            select round(coalesce(dl.DLsalario, 0.00), 2) as DLsalario, 
                   round(coalesce(dl.DLsalarioant, 0.00), 2) as DLsalarioant
            from DLaboralesEmpleado dl
            where dl.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insDLaboralesEmpleado.identity#">
        </cfquery>
        <cfif rsSalarios.recordCount>
            <cfset LTsalario = rsSalarios.DLsalario>
            <cfset LTsalarioant = rsSalarios.DLsalarioant>
        <cfelse>
            <cfset LTsalario = 0.00>
            <cfset LTsalarioant = 0.00>
        </cfif>
        <cfif dataTipoAccion.RHTnoretroactiva EQ 1>
            <cfquery name="rsCIncidentes" datasource="#Arguments.conexion#">
                select CIncidente1, CIncidente2
                from RHTipoAccion 
                where RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTipoAccion.RHTid#">
            </cfquery>
            
            <cfif rsCIncidentes.recordCount AND Len(Trim(rsCIncidentes.CIncidente1))>
                <cfset FechaHastaControl = Fhasta>
                <!--- Afectar la tabla de Pagos en Exceso cuando la accion esta marcada como no retroactiva --->
                <cfif DateDiff('d', Fdesde, FechaHastaControl) GT 366>
                    <cfthrow message="#MSG_EVigenciaSuperior#">
                    <cfabort>
                </cfif>
                <!--- Salario Actual no debe ser superior al salario anterior.  Es incorrecto --->
                <cfif (Round(LTsalario) GT Round(LTsalarioant)) and (Len(Trim(rsCIncidentes.CIncidente2)) EQ 0)>
                    <cfthrow message="El Salario Nuevo #LSNumberFormat(LTsalario, ',9.00')#! no puede ser superior al Salario Anterior #LSNumberFormat(LTsalarioant, ',9.00')#! en una accion de este tipo. Proceso cancelado.">
                    <cfabort>
                </cfif>
                <!--- Tipo de Calculo de CIncidente1 debe ser de tipo IMPORTE o CALCULO y debe ser negativo --->
                <cfquery name="rsCIncidentes2" datasource="#Arguments.conexion#">
                    select 1 
                    from RHTipoAccion a, CIncidentes b
                    where a.RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTipoAccion.RHTid#">
                    and b.CIid = a.CIncidente1
                    and (b.CItipo < 2 or b.CInegativo > 0) 
                    and exists(
                        select 1 
                        from RHConceptosAccion ca, ConceptosTipoAccion ct
                        where ca.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                        and ct.RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTipoAccion.RHTid#">
                        and ct.CIid = ca.CIid
                        and ct.CTAsalario = 2
                    )
                </cfquery>
                <cfif rsCIncidentes2.recordCount>
                    <cfthrow message="#MSG_ConceptoPagoRebajo#">
                    <cfabort>
                </cfif>
                <!--- Tipo de Calculo de CIncidente2 debe ser importe y positivo --->
                <cfquery name="rsCIncidentes3" datasource="#Arguments.conexion#">
                    select 1 
                    from RHTipoAccion a, CIncidentes b
                    where a.RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTipoAccion.RHTid#">
                    and a.CIncidente2 is not null
                    and b.CIid = a.CIncidente2
                    and (b.CInegativo < 0 or b.CItipo < 2)
                    and exists(
                        select 1 
                        from RHConceptosAccion ca, ConceptosTipoAccion ct
                        where ca.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                        and ct.RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTipoAccion.RHTid#">
                        and ct.CIid = ca.CIid
                        and ct.CTAsalario = 3
                    )
                </cfquery>
                <cfif rsCIncidentes3.recordCount>
                    <cfthrow message="#MSG_ConceptoPagoSubsidio#">
                    <cfabort>
                </cfif>
                <!---
                    Valores:  
                        1. Dias a Rebajar
                        2. Importe Diario del Rebajo
                        3. Monto Total de Rebajo
                        4. Dias a Subsidiar
                        5. Subsidio Diario
                        6. Monto Total del Subsidio
                --->
                <cfquery name="rsValores1" datasource="#Arguments.conexion#">
                    select coalesce(sum(RHCAcant), 0) as dias, 
                           coalesce(sum(RHCAimporte), 0) as importe, 
                           coalesce(sum(RHCAres), 0) as total
                    from RHConceptosAccion ca, ConceptosTipoAccion ct
                    where ca.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                    and ct.CIid = ca.CIid
                    and ct.RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTipoAccion.RHTid#">
                    and ct.CTAsalario = 2
                </cfquery>
                <cfif rsValores1.recordCount>
                    <cfset dias = rsValores1.dias>
                    <cfset importe = rsValores1.importe>
                    <cfset total = rsValores1.total>
                <cfelse>
                    <cfset dias = 0>
                    <cfset importe = 0>
                    <cfset total = 0>
                </cfif>
                <cfquery name="rsValores2" datasource="#Arguments.conexion#">
                    select coalesce(sum(RHCAcant), 0) as diassub, 
                           coalesce(sum(RHCAimporte), 0) as importesub, 
                           coalesce(sum(RHCAres), 0) as totalsub
                    from RHConceptosAccion ca, ConceptosTipoAccion ct
                    where ca.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                    and ct.CIid = ca.CIid
                    and ct.RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTipoAccion.RHTid#">
                    and ct.CTAsalario = 3
                </cfquery>
                <cfif rsValores2.recordCount>
                    <cfset diassub = rsValores2.diassub>
                    <cfset importesub = rsValores2.importesub>
                    <cfset totalsub = rsValores2.totalsub>
                <cfelse>
                    <cfset diassub = 0>
                    <cfset importesub = 0>
                    <cfset totalsub = 0>
                </cfif>
                <!--- REVISAR EMPRESA --->
                <cfquery name="insPagos" datasource="#Arguments.conexion#">
                    insert into RHSaldoPagosExceso (Ecodigo, DEid, DLlinea, RHTid, RHSPEfdesde, RHSPEfhasta, RHSPEfecha, RHSPEfdesdesig, 
                                               RHSPEmontoreb, RHSPEsaldo, RHSPEmontosub, RHSPEsaldosub, RHSPEsaldiario, RHSPEsubdiario, RHSPEdiasreb, RHSPEdiassub)
                    select <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">, 
                           <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">, 
                           <cfqueryparam cfsqltype="cf_sql_numeric" value="#insDLaboralesEmpleado.identity#">, 
                           c.RHTid,
                           c.DLfvigencia, 
                           coalesce(c.DLffin, <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(6100, 01, 01)#">), 
                           <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
                           <cfqueryparam cfsqltype="cf_sql_date" value="#FechaIncidencia#">,
                           <cfqueryparam cfsqltype="cf_sql_money" value="#total#">, 
                           <cfqueryparam cfsqltype="cf_sql_money" value="#total#">, 
                           <cfqueryparam cfsqltype="cf_sql_money" value="#totalsub#">, 
                           <cfqueryparam cfsqltype="cf_sql_money" value="#totalsub#">, 
                           <cfqueryparam cfsqltype="cf_sql_money" value="#importe#">, 
                           <cfqueryparam cfsqltype="cf_sql_money" value="#importesub#">, 
                           <cfqueryparam cfsqltype="cf_sql_numeric" value="#dias#">, 
                           <cfqueryparam cfsqltype="cf_sql_numeric" value="#diassub#">
                    from RHAcciones c
                    where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                </cfquery>
            </cfif> <!--- rsCIncidentes.recordCount AND Len(Trim(rsCIncidentes.CIncidente1)) --->
        </cfif> <!--- dataTipoAccion.RHTnoretroactiva EQ 1 --->
        <cfreturn>
	</cffunction>

	<!--- Afectación de Reclutamiento y Selección, solo si el campo RHCconcurso no es nulo --->
  	<cffunction name="Parte7" access="private" output="false">
    	<cfargument name="Ecodigo" 		type="numeric" 	required="yes" default="#Session.Ecodigo#">
		<cfargument name="RHAlinea" 	type="numeric" 	required="yes">	
		<cfargument name="Usucodigo" 	type="string" 	required="no" default="#Session.Usucodigo#">
		<cfargument name="conexion" 	type="string" 	required="no" default="#Session.DSN#">
		<cfargument name="validar" 		type="boolean" 	required="no" default="false">
		<cfargument name="respetarLT" 	type="boolean" 	required="no" default="false">		
		<cfargument name="debug" 		type="boolean" 	required="no" default="false">

        <cfquery name="rsReclutamiento" datasource="#session.DSN#">
            select a.RHCconcurso
            from RHAcciones a
            where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
            and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
        </cfquery>
        <cfif rsReclutamiento.recordcount gt 0 and len(trim(rsReclutamiento.RHCconcurso))>
            <!--- 1. Cambia estado al oferente --->
            <cfset LvarOferente = false >
            <!--- 1.1 Recupera el RHOid (id de oferente para el concurso) --->
            <cfquery name="rsOferente" datasource="#session.DSN#">
                select RHOid
                from DatosOferentes a
                where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
                  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
            </cfquery>
            <cfif rsOferente.recordcount gt 0 and len(trim(rsOferente.RHOid))>
                <cfset LvarOferente = true >
                <cfset oferente = rsOferente.RHOid >
            </cfif>
            <!--- 1.2 Recupera el RHCPid segun el empleado/oferente y el concurso --->
            <cfquery name="rsConcursante" datasource="#session.DSN#">
                select a.RHCPid
                from RHConcursantes a
                where a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReclutamiento.RHCconcurso#">
                <cfif LvarOferente >
                    and a.RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#oferente#">
                <cfelse>
                    and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#empleado#">
                </cfif>
            </cfquery>
            <!--- Si existe el concursante modifica su estado para el concurso --->
            <cfif rsConcursante.recordcount gt 0 and len(trim(rsConcursante.RHCPid)) >
                <cfquery datasource="#session.DSN#">
                    update RHAdjudicacion
                    set RHAestado = 20
                    where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReclutamiento.RHCconcurso#">
                      and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConcursante.RHCPid#">
                </cfquery>
            <cfelse>
                <cfthrow message="#MSG_EmpleadoNoConcursante#">
            </cfif>
            <!--- 2. Cambia estado al Concurso si ya se asignaron todas las plazas --->
            <!--- QUERY que devuelve las plazas NO asignadas, o sea si el recordcount es mas grande que cero  --->
            <!--- hay uan plazas por asignar --->
            <cfquery name="rsNoAsignadas" datasource="#session.DSN#">
                select b.RHPid
                from RHPlazasConcurso a
                
                inner join RHPlazas b
                on a.Ecodigo = b.Ecodigo
                and a.RHPid = b.RHPid
                
                where a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReclutamiento.RHCconcurso#">
                and b.RHPid not in ( select c.RHPid 
                                    from RHAdjudicacion c
                                    where c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                                      and c.RHCconcurso=a.RHCconcurso
                                      and c.RHAestado = 20 )
            </cfquery>
            <cfif rsNoAsignadas.recordcount eq 0>
                <cfquery datasource="#session.DSN#">
                    update RHConcursos
                    set RHCestado = 80 <!--- averiguar el estado que deja listo al concurso --->
                    where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReclutamiento.RHCconcurso#">
                      and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                </cfquery>
            </cfif>
        </cfif>
        <!--- Fin de Reclutamiento y Seleccion --->
        <cfreturn>
	</cffunction>

	<!--- Cuando se cambia de empresa a un empleado hay que modificar la tabla de UsuarioReferencia en la BD de 'asp' para mantener la seguridad del portal consistente --->
  	<cffunction name="Parte8" access="private" output="false">
    	<cfargument name="Ecodigo" 		type="numeric" 	required="yes" default="#Session.Ecodigo#">
		<cfargument name="RHAlinea" 	type="numeric" 	required="yes">	
		<cfargument name="Usucodigo" 	type="string" 	required="no" default="#Session.Usucodigo#">
		<cfargument name="conexion" 	type="string" 	required="no" default="#Session.DSN#">
		<cfargument name="validar" 		type="boolean" 	required="no" default="false">
		<cfargument name="respetarLT" 	type="boolean" 	required="no" default="false">		
		<cfargument name="debug" 		type="boolean" 	required="no" default="false">
		<!--- Empresa Anterior --->
        <cfquery name="ref1" datasource="#Arguments.conexion#">
            select Ecodigo
            from Empresa
            where Ereferencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
            and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
        </cfquery>
        <!--- Empresa Nueva --->
        <cfquery name="ref2" datasource="#Arguments.conexion#">
            select Ecodigo
            from Empresa
            where Ereferencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#dataTipoAccion.EcodigoRef#">
            and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
        </cfquery>
        <!--- Cambio de Empresa, Tipo de Nómina, Banco y Moneda para el Empleado --->
        <cfquery name="updDatosEmpleado" datasource="#Arguments.conexion#">
            update DatosEmpleado set 
                Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#dataTipoAccion.EcodigoRef#">,
                Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#dataTipoAccion.TcodigoRef#">,
                Bid = (
                    select c.Bid
                    from Bancos b, Bancos c
                    where DatosEmpleado.Bid = b.Bid
                    and b.Iaba = c.Iaba
                    and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#dataTipoAccion.EcodigoRef#">
                ),
                Mcodigo = coalesce((
                    select c.Mcodigo
                    from Monedas b, Monedas c
                    where DatosEmpleado.Mcodigo = b.Mcodigo
                    and b.Miso4217 = c.Miso4217
                    and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#dataTipoAccion.EcodigoRef#">
                ), (
                    select Mcodigo
                    from Empresas
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#dataTipoAccion.EcodigoRef#">
                ))
            where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
        </cfquery>
        <cftransaction action="commit"/>
        <cfquery name="refEmp" datasource="#Arguments.conexion#">
            select Usucodigo
            from UsuarioReferencia
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ref1.Ecodigo#">
            and STabla = 'DatosEmpleado'
            and llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Empleado#">
        </cfquery>
        <!--- Estos campos se actualizan solamente si el empleado tiene asociado un usuario de aplicación --->
        <cfif refEmp.RecordCount NEQ 0> 
            <cfset update = true>
            <cftry>
                <cfquery name="updReferencia" datasource="#Arguments.conexion#">
                    update UsuarioReferencia
                    set Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ref2.Ecodigo#">
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ref1.Ecodigo#">
                    and STabla = 'DatosEmpleado'
                    and llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Empleado#">
                </cfquery>
            <cfcatch>
                <cfset update = false>
            </cfcatch>
            </cftry>
            <cfif update>
                <cfquery name="updReferencia" datasource="#Arguments.conexion#">
                    update UsuarioReferencia
                    set Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ref2.Ecodigo#">
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ref1.Ecodigo#">
                    and STabla = 'DatosEmpleado'
                    and llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Empleado#">
                </cfquery>
            </cfif>
            <cfset update = true>
            <cftry>
                <cfquery name="updRol" datasource="#Arguments.conexion#">
                    update UsuarioRol
                    set Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ref2.Ecodigo#">
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ref1.Ecodigo#">
                    and SScodigo = 'RH'
                    and SRcodigo = 'AUTO'
                    and Usucodigo = (
                        select Usucodigo
                        from UsuarioReferencia
                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ref2.Ecodigo#">
                        and STabla = 'DatosEmpleado'
                        and llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Empleado#">
                    )
                </cfquery>	
            <cfcatch>
                <cfset update = false>
            </cfcatch>

            </cftry>
            <cfif update>
                <cfquery name="updRol" datasource="#Arguments.conexion#">
                    update UsuarioRol
                    set Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ref2.Ecodigo#">
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ref1.Ecodigo#">
                    and SScodigo = 'RH'
                    and SRcodigo = 'AUTO'
                    and Usucodigo = (
                        select Usucodigo
                        from UsuarioReferencia
                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ref2.Ecodigo#">
                        and STabla = 'DatosEmpleado'
                        and llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Empleado#">
                    )
                </cfquery>						
            </cfif>	
            <!--- Invocación del Componente para la actualización del Usuario --->
            <cfinvoke component="home.Componentes.MantenimientoUsuarioProcesos" method="actualizar">
                <cfinvokeargument name="Usucodigo" value="#refEmp.Usucodigo#">
                <cfinvokeargument name="SScodigo" value="RH">
            </cfinvoke>
        </cfif>
    
    	<cfreturn>
	</cffunction>

        
	<cffunction name="AplicaAccion" access="public" output="true" returntype="boolean">
		<cfargument name="Ecodigo" type="numeric" required="yes" default="#Session.Ecodigo#">
		<cfargument name="RHAlinea" type="numeric" required="yes">	<!--- Accion en Proceso --->
		<cfargument name="Usucodigo" type="string" required="no" default="#Session.Usucodigo#">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#">
		<cfargument name="validar" type="boolean" required="no" default="false">
		<cfargument name="respetarLT" type="boolean" required="no" default="false">		<!--- Indica si quiere respetar los cortes en la Linea del Tiempo / Utilizado unicamente para actualizar LTsalario y los componentes de la linea del tiempo --->
		<cfargument name="debug" type="boolean" required="no" default="false">
		<cfset CreaEtiquetas()>
		<cfquery name="dataTipoAccion" datasource="#Arguments.conexion#">
			select  a.RHTcomportam,
					b.DEid,
					b.DLfvigencia as fechadesde,
					b.DLffin as fechahasta,
					a.RHTpfijo,
					a.RHTpmax,
					b.RHTid,
					a.RHTnoretroactiva,
					b.Ecodigo,
					b.Tcodigo,
					b.EcodigoRef,
					b.TcodigoRef,
					a.RHTcempresa,
					b.RVid,
					a.RHTespecial,
					b.RHAtipo,
					b.RHAdescripcion,
					b.EVfantig,
					b.RHAdiasenfermedad,
					a.RHTliquidatotal,
					IDInterfaz,
					coalesce(b.RHItiporiesgo,0) as RHItiporiesgo,
					coalesce(b.RHIconsecuencia,0) as RHIconsecuencia,
					coalesce(b.RHIcontrolincapacidad,0) as RHIcontrolincapacidad,
					b.RHfolio,
					coalesce(b.RHporcimss,0) as RHporcimss,
					b.RHPcodigo,
					coalesce(b.DLsalarioSDI,0) as DLsalarioSDI,
					coalesce(b.DLsalario,0) as DLsalario
					
			from RHTipoAccion a, RHAcciones b 
			where a.RHTid = b.RHTid
			and b.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
		</cfquery>

		<cfif dataTipoAccion.RecordCount Is 0>
			<cf_throw message="#LB_La_accion_Num#&nbsp;#Arguments.RHAlinea#&nbsp;#LB_no_existe_o_es_invalida#" errorCode="12085">
		</cfif>
		<cfset Empleado = dataTipoAccion.DEid>
		<cfset Fdesde = dataTipoAccion.fechadesde>
		<cfif Len(Trim(dataTipoAccion.fechahasta))>
			<cfset Fhasta = dataTipoAccion.fechahasta>
		<cfelse>
			<cfset Fhasta = CreateDate(6100, 01, 01)>
		</cfif>
		<cfset RHTespecial =  dataTipoAccion.RHTespecial>
		<!--- VALIDACIONES --->
		<cfset Parte1(Arguments.Ecodigo, Arguments.RHAlinea, Arguments.Usucodigo, Arguments.conexion, Arguments.validar, Arguments.respetarLT, Arguments.debug)>
        <cfif Arguments.validar><cfreturn true></cfif>
		<!--- ********************************************************************************************* --->
		<!---                                 Acciones de tipo normal                                       --->
		<!--- ********************************************************************************************* --->
		<cfif RHTespecial eq  0 > 
			<!--- FechaHastaPago es la fecha del ultimo pago realizado al funcionario --->
			<cfquery name="rsFecha" datasource="#Arguments.conexion#">
				select max(hr.RChasta) as fechahastapago
				from HSalarioEmpleado hs, HRCalculoNomina hr
				where hs.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
				and hr.RCNid = hs.RCNid
			</cfquery>
			<cfif Len(Trim(rsFecha.fechahastapago))>
				<cfset FHastaPago = rsFecha.fechahastapago>
			<cfelse>
				<cfset FHastaPago = CreateDate(1900, 01, 01)> <!--- Fecha minima del sistema --->
			</cfif>
			<!--- Calcula el Salario para el Empleado en la Tabla de Acciones --->
			<cfquery name="updSalario" datasource="#Arguments.conexion#">
				update RHAcciones 
					set DLsalario = coalesce((
						select sum(RHDAmontores)
						from RHDAcciones b, ComponentesSalariales cs
						where b.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
						and b.CSid = cs.CSid
						and cs.CIid is null
					), 0.00)
				where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
			</cfquery>
			<!--- Actualizar los montos con los conceptos del tipo de Accion que modifican el salario --->
			<cfquery name="rsMontos" datasource="#Arguments.conexion#">
				select 1 
				from RHConceptosAccion ca, ConceptosTipoAccion ct
				where ca.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
				and ct.CIid = ca.CIid
				and ct.RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTipoAccion.RHTid#">
				and ct.CTAsalario = 1
			</cfquery>
			<cfif rsMontos.recordCount>
				<cfquery name="updSalario" datasource="#Arguments.conexion#">
					update RHAcciones 
						set DLsalario = coalesce((
							select sum(ca.RHCAres)
							from RHConceptosAccion ca, ConceptosTipoAccion ct
							where ca.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
							and ct.CIid = ca.CIid
							and ct.RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTipoAccion.RHTid#">
							and ct.CTAsalario = 1
						), 0.00)
					where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
				</cfquery>
			</cfif>
			
			<!---ljimenez Calcula el SDI para empleado cuando la accio es de tipo nombramiento--->
			<cfinvoke component="RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="2025" default="" returnvariable="vUsaSBC"/>
			<cfif #vUsaSBC# EQ 1 >	
				<cfquery name="rsDLsalario" datasource="#Arguments.conexion#">
					select coalesce(DLsalario,0) as DLsalario
						from RHAcciones
						where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
				</cfquery>
				
				<cfquery name="rsLTsalario" datasource="#Arguments.conexion#">
					select coalesce(LTsalario,0) as LTsalario
						from LineaTiempo a
						where DEid = #Empleado#
						  and Ecodigo = #Arguments.Ecodigo#
						  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">  between LTdesde and LThasta 
				</cfquery>
				
				<cfset vDLsalario = rsDLsalario.DLsalario>
				<cfset vLTsalario = rsLTsalario.LTsalario>
		
				<cfif dataTipoAccion.RHTcomportam EQ 1 > <!---Nombramiento--->
					<cfinvoke component="rh.Componentes.RH_CalculoSDI" method="fnSDINombramiento" returnvariable="vSDI">	
						<cfinvokeargument name="DEid" 		value="#Empleado#"/>
						<cfinvokeargument name="RVid" 		value="#dataTipoAccion.RVid#"/>
						<cfinvokeargument name="RHAlinea" 	value="#Arguments.RHAlinea#"/>
                        <cfinvokeargument name="Fecha" 		value="#Fdesde#"/>
					</cfinvoke>
                    
					<!--- Actualiza el SDI para la accion --->
					<cfquery name="updSalarioSDI" datasource="#Arguments.conexion#">
						update RHAcciones 
							set DLsalarioSDI = #vSDI#
						where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
					</cfquery>
					<cfquery datasource="#session.DSN#">
						update DatosEmpleado
							set DEsdi =  #vSDI#
							where DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
					</cfquery>	
                    				
				<cfelseif dataTipoAccion.RHTcomportam EQ 6 and #vDLsalario# NEQ #vLTsalario#> <!---Aumento--->
					
					<cfinvoke component="rh.Componentes.RH_CalculoSDI" method="fnSDI" returnvariable="vSDI">	
						<cfinvokeargument name="DEid" 		value="#Empleado#"/>
						<cfinvokeargument name="RVid" 		value="#dataTipoAccion.RVid#"/>
						<cfinvokeargument name="RHAlinea" 	value="#Arguments.RHAlinea#"/>
					</cfinvoke>
					<!--- Actualiza el SDI para la accion --->
					<cfquery name="updSalarioSDI" datasource="#Arguments.conexion#">
						update RHAcciones 
							set DLsalarioSDI = #vSDI#
						where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
					</cfquery>
					<cfquery datasource="#session.DSN#">
						update DatosEmpleado
							set DEsdi =  #vSDI#
							where DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
					</cfquery>					
				</cfif>
			</cfif>
			<!--- Agregar la Accion a los Datos Laborales del Empleado --->
			<cfset Lvar_DLlinea = Parte2(Arguments.Ecodigo, Arguments.RHAlinea, Arguments.Usucodigo, Arguments.conexion, Arguments.validar, Arguments.respetarLT, Arguments.debug)>
			<!--- PROCESO POR TIPO DE COMPORTAMIENTO DE LA ACCION --->
			<cfset Parte4(Arguments.Ecodigo, Arguments.RHAlinea, Arguments.Usucodigo, Arguments.conexion, Arguments.validar, Arguments.respetarLT, Arguments.debug)>

			<!---
				La afectacion de la linea del tiempo solo se hace si la accion (Tipo de Accion) 
				indica que afecta la linea del tiempo. 
				Retroactiva = 0 indica que la linea del tiempo se construye retroactivamente
			--->
			<cfif dataTipoAccion.RHTnoretroactiva EQ 0>
				<cfinvoke component="rh.Componentes.RH_ConstruyeLT" method="ConstruyeLT" returnvariable="LvarResult">
					<cfinvokeargument name="Ecodigo" value="#Arguments.Ecodigo#"/> 
					<cfinvokeargument name="RHAlinea" value="#Arguments.RHAlinea#"/> 
					<cfinvokeargument name="DEid" value="#Empleado#"/> 
					<cfinvokeargument name="RHTcomportam" value="#dataTipoAccion.RHTcomportam#"/> 
					<cfinvokeargument name="Usucodigo" value="#Arguments.Usucodigo#"/> 
					<cfinvokeargument name="respetarLT" value="#Arguments.respetarLT#"/> 
                    <cfinvokeargument name="DLlinea" value="#Lvar_DLlinea#"/> 
					<cfinvokeargument name="conexion" value="#Arguments.conexion#"/> 
					<cfinvokeargument name="debug" value="#Arguments.debug#"/> 
				</cfinvoke>
			</cfif>

			<!---
				Generar los Conceptos de Pago 
				Asociados a la Accion 
				como Incidencias para la siguiente nomina
				
				Fecha de Incidencia = Fecha desde Acción que la esta generando
			--->

			<cfset Parte6(Arguments.Ecodigo, Arguments.RHAlinea, Arguments.Usucodigo, Arguments.conexion, Arguments.validar, Arguments.respetarLT, Arguments.debug)>

            
			<!--- Cuando el Tipo de Acción es de Tipo de Cese --->
			<!--- INSERCION DE LOS INGRESOS PARA LIQUIDACIONES --->
			<cfif dataTipoAccion.RHTcomportam EQ 2>
				<cfset Parte5(Arguments.Ecodigo, Arguments.RHAlinea, Arguments.Usucodigo, Arguments.conexion, Arguments.validar, Arguments.respetarLT, Arguments.debug)>
			</cfif>
			<!--- Afectación de Reclutamiento y Selección, solo si el campo RHCconcurso no es nulo --->
			<cfset Parte7(Arguments.Ecodigo, Arguments.RHAlinea, Arguments.Usucodigo, Arguments.conexion, Arguments.validar, Arguments.respetarLT, Arguments.debug)>
			
			<!--- Borrar las Acciones en Proceso --->
			<cfquery datasource="#Session.DSN#">
				Delete from RHSalPromAccion 
				where RHAlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
			</cfquery>
			<cfquery name="delConceptos" datasource="#Arguments.conexion#">
				delete from RHConceptosAccion 
				where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
			</cfquery>
			<cfquery name="delDAcciones" datasource="#Arguments.conexion#">
				delete from RHDAcciones 
				where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
			</cfquery>
			<cfquery name="delAcciones" datasource="#Arguments.conexion#">
				delete from RHAcciones 
				where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
			</cfquery>
			<!--- Cuando se cambia de empresa a un empleado hay que modificar la tabla de UsuarioReferencia en la BD de 'asp' para mantener la seguridad del portal consistente --->
			<cfif dataTipoAccion.RHTcomportam EQ 9 and dataTipoAccion.RHTcempresa EQ 1>
				<cfset Parte8(Arguments.Ecodigo, Arguments.RHAlinea, Arguments.Usucodigo, Arguments.conexion, Arguments.validar, Arguments.respetarLT, Arguments.debug)>
			</cfif>
		<!--- ********************************************************************************************* --->
		<!---                                 Acciones de tipo especial                                     --->
		<!--- ********************************************************************************************* --->
		<cfelseif RHTespecial eq  1 > 
			<cfset Parte3(Arguments.Ecodigo, Arguments.RHAlinea, Arguments.Usucodigo, Arguments.conexion, Arguments.validar, Arguments.respetarLT, Arguments.debug)>
		</cfif>
		<cfreturn true>
	</cffunction>
    
    <cffunction name="CreaEtiquetas" access="private" output="false">
        <cfinvoke component="sif.Componentes.Translate"
            method="Translate"
            key="MSG_El_tipo_de_comportamiento_de_la_acción_Aumento_no_se_permite_en_este_proceso"
            default="Error! El tipo de comportamiento de la acción (Aumento) no se permite en este proceso. Procese los aumentos en la opción de registro de Relaciones de Aumento en el Menú Principal del Sistema.!"	
            returnvariable="MSG_ETipoComportamientoAumento"/>
        <cfinvoke component="sif.Componentes.Translate"
            method="Translate"
            key="MSG_El_tipo_de_comportamiento_de_la_accion_Anulacion_no_se_permite_en_este_proceso"
            default="Error! El tipo de comportamiento de la acción (Anulación) no se permite en este proceso. Procese las anulaciones en la opción correspondiente.!"	
            returnvariable="MSG_ETipoComportamientoAnulacion"/>
        <cfinvoke component="sif.Componentes.Translate"
            method="Translate"
            key="MSG_La_fecha_rige_de_la_Accion_no_puede_ser_mayor_a_la_fecha_hasta_Proceso_Cancelado"
            default="Error! La fecha rige de la Acción no puede ser mayor a la fecha hasta. Proceso Cancelado!"	
            returnvariable="MSG_EFechaRigeMayor"/>
        <cfinvoke component="sif.Componentes.Translate"
            method="Translate"
            key="MSG_No_se_ha_definido_el_parametro_de_dias_para_el_calculo_de_salario_diario_Proceso_Cancelado"
            default="Error! No se ha definido el parámetro de días para el cálculo de salario diario (Tipos de Nómina). Proceso Cancelado!"	
            returnvariable="MSG_EParametroDiasCalculo"/>
        <cfinvoke component="sif.Componentes.Translate"
            method="Translate"
            key="MSG_La_Accion_no_se_ha_grabado_correctamente_Proceso_Cancelado"
            default="Error! La Accion no se ha grabado correctamente. Proceso Cancelado!"	
            returnvariable="MSG_EGrabadoAccion"/>
        <cfinvoke component="sif.Componentes.Translate"
            method="Translate"
            key="MSG_No_existen_Componentes_Salariales_definidos_Proceso_Cancelado"
            default="Error! No existen Componentes Salariales definidos. Proceso Cancelado!"	
            returnvariable="MSG_EComponentesDefinidos"/>
        <cfinvoke component="sif.Componentes.Translate"
            method="Translate"
            key="MSG_ElTipoDeAccionFueConfiguradaParaPlazoFijoYLaCantidadDeDiasExcedeElMaximoConfigurado"
            default="Error,  el tipo de la acción que se está tratando de aplicar fue configurada para plazo fijo y la cantidad de días de la acción excede el máximo de días de dicha configuración. No se puede continuar."	
            returnvariable="MSG_EConfiguracionTipoAccion"/>		
        <cfinvoke component="sif.Componentes.Translate"
            method="Translate"
            key="MSG_La_fechas_de_la_Accion_se_traslapan_con_otra_accion_no_retroactiva_anterior_Proceso_Cancelado"
            default="La fechas de la Accion se traslapan con otra accion no retroactiva anterior. Proceso Cancelado!"	
            returnvariable="MSG_EFechasTraslapadas"/>
        <cfinvoke component="sif.Componentes.Translate"
            method="Translate"
            key="MSG_La_accion_de_Nombramiento_indicada_causara_la_perdida_de_informacion_del_empleado"
            default="Error! La acción de Nombramiento indicada causará la pérdida de información del empleado ya que tiene acciones registradas para la fecha indicada. Proceso Cancelado!"	
            returnvariable="MSG_EYaExisteAccionRegistrada"/>
        <cfinvoke component="sif.Componentes.Translate"
            method="Translate"
            key="MSG_El_empleado_ya_fue_cesado_previamente_y_el_tipo_de_cese_no_permite_movimientos_posteriores"
            default="Error! El empleado ya fue cesado previamente y el tipo de cese no permite movimientos posteriores! Proceso Cancelado!"	
            returnvariable="MSG_EmpleadoCesado"/>
        <cfinvoke component="sif.Componentes.Translate"
            method="Translate"
            key="MSG_Ya_existe_una_accion_de_Nombramiento_vigente_para_el_empleado_indicado"
            default="Error! Ya existe una acción de Nombramiento vigente para el empleado indicado! Proceso Cancelado!"	
            returnvariable="MSG_YaExisteAccionNombramiento"/>
        <cfinvoke component="sif.Componentes.Translate"
            method="Translate"
            key="MSG_La_accion_de_Cese_indicada_causara_la_perdida_de_informacion_del_empleado"
            default="Error! La acción de Cese indicada causará la pérdida de información del empleado ya que tiene acciones registradas para la fecha indicada. Proceso Cancelado!"	
            returnvariable="MSG_EAccionCese"/>
        <cfinvoke component="sif.Componentes.Translate"
            method="Translate"
            key="MSG_La_accion_indicada_no_puede_ser_ubicada_en_la_Linea_del_Tiempo"
            default="Error! La acción indicada no puede ser ubicada en la Línea del Tiempo. Proceso Cancelado!"	
            returnvariable="MSG_EAccionLineaTiempo"/>
        <cfinvoke component="sif.Componentes.Translate"
            method="Translate"
            key="MSG_El_empleado_no_tiene_fecha_de_antiguedad"
            default="Error! El empleado no tiene fecha de antiguedad. Proceso Cancelado!"	
            returnvariable="MSG_ENoTieneAntiguedad"/>
        <cfinvoke component="sif.Componentes.Translate"
            method="Translate"
            key="MSG_Proceso_Cancelado"
            default="Proceso Cancelado!"	
            returnvariable="MSG_ProcesoCancelado"/>
        <cfinvoke component="sif.Componentes.Translate"
            method="Translate"
            key="MSG_Una_Accion_de_este_tipo_no_puede_tener_una_vigencia_superior_a_1_año_calendario"
            default="Una Accion de este tipo no puede tener una vigencia superior a 1 año calendario."	
            returnvariable="MSG_EVigenciaSuperior"/>
        <cfinvoke component="sif.Componentes.Translate"
            method="Translate"
            key="MSG_El_Concepto_de_Pago_de_Rebajo_de_Salario_asociado_a_la_accion_debe_ser_de_tipo_IMPORTE_o_CALCULO"
            default="El Concepto de Pago de Rebajo de Salario asociado a la acción debe ser de tipo IMPORTE o CALCULO y con Factor Negativo. Proceso Cancelado."	
            returnvariable="MSG_ConceptoPagoRebajo"/>
        <cfinvoke component="sif.Componentes.Translate"
            method="Translate"
            key="MSG_El_Concepto_de_Pago_de_Subsidio_de_Salario_asociado_a_la_accion_debe_ser_de_tipo_IMPORTE_o_CALCULO"
            default="El Concepto de Pago de Subsidio de Salario asociado a la accion debe ser de tipo IMPORTE o CALCULO y de calculo Positivo. Proceso Cancelado."	
            returnvariable="MSG_ConceptoPagoSubsidio"/>
        <cfinvoke component="sif.Componentes.Translate"
            method="Translate"
            key="MSG_El_empleado_no_esta_definido_como_concursante_en_algun_concurso"
            default="Error! El empleado no esta definido como concursante en alg&uacute;n concurso."	
            returnvariable="MSG_EmpleadoNoConcursante"/>
        <cfinvoke component="sif.Componentes.Translate"
        method="Translate"
        key="LB_La_accion_Num"
        default="La acci&oacute;n Num."
        returnvariable="LB_La_accion_Num"/> 
        
        <cfinvoke component="sif.Componentes.Translate"
        method="Translate"
        key="LB_no_existe_o_es_invalida"
        default="no existe o es inv&aacute;lida."
        returnvariable="LB_no_existe_o_es_invalida"/>
        <cfinvoke component="sif.Componentes.Translate"
        method="Translate"
        key="LB_msg1"
        default="Existe una Accion No retroactiva posterior. Proceso Cancelado! Tipo de Acción Posterior:"
        returnvariable="LB_msg1"/> 
        
        <cfinvoke component="sif.Componentes.Translate"
        method="Translate"
        key="LB_msg2"
        default="Vigencia de:"
        returnvariable="LB_msg2"/> 
        
        <cfinvoke component="sif.Componentes.Translate"
        method="Translate"
        key="LB_msg3"
        default="hasta:"
        returnvariable="LB_msg3"/>
            
    </cffunction>
	
	<!---Recalcula componentes, se usa solo para acciones de nombramiento por el momento, 	
	especial para cuando se realizan acciones de nombramiento masivas en las cargas iniciales de datos. 
	toma en cuenta si la empresa utiliza o no estructura salarial y si debe verificar contra presupuesto, solamente. CarolRS--->
	<cffunction name="RecalculaComponentes" access="public" output="true" returntype="boolean">
		<cfargument name="Ecodigo" type="numeric" required="yes" default="#Session.Ecodigo#">
		<cfargument name="RHAlinea" type="numeric" required="yes">	<!--- Accion en Proceso --->
		<cfargument name="DEid" type="numeric" required="yes" default="#Session.DSN#">
		<cfargument name="Usucodigo" type="string" required="no" default="#Session.Usucodigo#">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#">
			
			<!---Toma los datos de la accion actual--->
			<cfquery name="rsAccionInfo" datasource="#Session.DSN#">
				select a.*
				from RHAcciones a
				where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
			</cfquery>
			
			<!---Toma los componentes asociados a la accion actual--->
			<cfquery name="rsComponentesInfo" datasource="#Session.DSN#">
				select b.*
				from RHAcciones a
				inner join RHDAcciones b
				on b.RHAlinea = a.RHAlinea
				where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
			</cfquery>

			<!--- Averiguar si el salario de la plaza es negociado --->
			<cfquery name="rsNegociado" datasource="#Session.DSN#">
				select a.RHMPnegociado
				from RHLineaTiempoPlaza a
				where a.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccionInfo.RHPid#">
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(rsAccionInfo.DLfvigencia)#"> between a.RHLTPfdesde and a.RHLTPfhasta
			</cfquery>
			<cfset LvarNegociado = (rsNegociado.RHMPnegociado EQ 'N')>

			<!--- Averiguar si hay que utilizar la tabla salarial --->
			<cfquery name="rsTipoTabla" datasource="#Session.DSN#">
				select CSusatabla
				from ComponentesSalariales
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and CSsalariobase = 1
			</cfquery>
			<cfif rsTipoTabla.recordCount GT 0>
				<cfset usaEstructuraSalarial = rsTipoTabla.CSusatabla>
			<cfelse>
				<cfset usaEstructuraSalarial = 0>
			</cfif>

			<cftransaction>
				
				<cfif rsComponentesInfo.RecordCount GT 0>
					<cfloop query="rsComponentesInfo">
						<cfset RHDAlinea = rsComponentesInfo.RHDAlinea>
						<cfset unidades = rsComponentesInfo.RHDAunidad>
						<cfset montobase = rsComponentesInfo.RHDAmontobase>
						<cfset monto = rsComponentesInfo.RHDAmontores>
						<cfset metodo = 'M'>
						<cfif usaEstructuraSalarial EQ 1 >
							<cfset Lvar_RHTTid = 0>
							<cfset Lvar_RHMPPid = 0>
							<cfset Lvar_RHCid = 0>
							<cfquery name="rsAccionES" datasource="#Session.DSN#">
								select b.DEid,b.DLfvigencia, coalesce(b.DLffin,'61000101') as DLffin, b.RHCPlinea as RHCPlinea, a.CSid,a.RHDAmetodoC,RHPcodigoAlt,coalesce(RHCPlineaP,0) as RHCPlineaP, b.RHAporcsal
								from RHDAcciones a, RHAcciones b
								where a.RHDAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHDAlinea#">
								and a.RHAlinea = b.RHAlinea
							</cfquery>
							<cfset Lvar_CatAlt = rsAccionES.RHCPlinea>
							<cfif isdefined('Arguments.RHTTid3') and Len(Trim(Arguments.RHTTid3)) and Arguments.RHTTid3 GT 0>
								<cfset Lvar_RHTTid = Arguments.RHTTid3>
								<cfset Lvar_RHMPPid = Arguments.RHMPPid3>
								<cfset Lvar_RHCid = Arguments.RHCid3>
							</cfif>
							
							<cfinvoke component="rh.Componentes.RH_EstructuraSalarial" method="calculaComponente" returnvariable="calculaComponenteRet">
								<cfinvokeargument name="CSid" value="#rsAccionES.CSid#"/>
								<cfinvokeargument name="fecha" value="#rsAccionES.DLfvigencia#"/>
								<cfinvokeargument name="fechah" value="#rsAccionES.DLffin#"/>
								<cfinvokeargument name="DEid" value="#rsAccionES.DEid#"/>
								<cfinvokeargument name="RHCPlinea" value="#Lvar_CatAlt#"/>
								<cfinvokeargument name="BaseMontoCalculo" value="0.00"/>
								<cfinvokeargument name="negociado" value="#LvarNegociado#"/>
								<cfinvokeargument name="Unidades" value="#unidades#"/>
								<cfinvokeargument name="MontoBase" value="#montobase#"/>
								<cfinvokeargument name="Monto" value="#monto#"/>
								<cfinvokeargument name="Metodo" value="#rsAccionES.RHDAmetodoC#"/>
								<cfinvokeargument name="TablaComponentes" value="RHDAcciones"/>
								<cfinvokeargument name="CampoLlaveTC" value="RHAlinea"/>
								<cfinvokeargument name="ValorLlaveTC" value="#Arguments.RHAlinea#"/>
								<cfinvokeargument name="CampoMontoTC" value="RHDAmontores"/>
								<cfinvokeargument name="RHTTid" value="#Lvar_RHTTid#">
								<cfinvokeargument name="RHCid" value="#Lvar_RHMPPid#">
								<cfinvokeargument name="RHMPPid" value="#Lvar_RHCid#">
								<cfinvokeargument name="PorcSalario" value="#rsAccionES.RHAporcsal#"/>
								<cfinvokeargument name="RHCPlineaP" value="#rsAccionES.RHCPlineaP#"/>
							</cfinvoke>

							<cfset unidades = calculaComponenteRet.Unidades>
							<cfset montobase = calculaComponenteRet.MontoBase>
							<cfset monto = calculaComponenteRet.Monto>
							<cfset metodo = calculaComponenteRet.Metodo>
						<cfelse>
							
							<!---Datos de la Acción--->
							<cfquery name="rsAccionES" datasource="#Session.DSN#">
								select b.DEid,b.DLfvigencia, coalesce(b.DLffin,'61000101') as DLffin, b.RHCPlinea as RHCPlinea, a.CSid,a.RHDAmetodoC,RHPcodigoAlt,coalesce(RHCPlineaP,0) as RHCPlineaP, b.RHAporcsal
								from RHDAcciones a, RHAcciones b
								where a.RHDAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHDAlinea#">
								and a.RHAlinea = b.RHAlinea
							</cfquery>
							
							<!--- NO SE VERIFICA SI TIENE UN PUESTO ALTERNO, NI CATEGORIA--->
							<cfset Lvar_CatAlt = 0>
							
							<cfinvoke component="rh.Componentes.RH_SinEstructuraSalarial" method="calculaComponente" returnvariable="calculaComponenteRet">
								<cfinvokeargument name="CSid" value="#rsAccionES.CSid#"/>
								<cfinvokeargument name="fecha" value="#rsAccionES.DLfvigencia#"/>
								<cfinvokeargument name="fechah" value="#rsAccionES.DLffin#"/>
								<cfinvokeargument name="DEid" value="#rsAccionES.DEid#"/>
								<cfinvokeargument name="RHCPlinea" value="#Lvar_CatAlt#"/>
								<cfinvokeargument name="BaseMontoCalculo" value="0.00"/>
								<cfinvokeargument name="negociado" value="#LvarNegociado#"/>
								<cfinvokeargument name="Unidades" value="#unidades#"/>
								<cfinvokeargument name="MontoBase" value="#montobase#"/>
								<cfinvokeargument name="Monto" value="#monto#"/>
								<cfinvokeargument name="Metodo" value="#rsAccionES.RHDAmetodoC#"/>
								<cfinvokeargument name="TablaComponentes" value="RHDAcciones"/>
								<cfinvokeargument name="CampoLlaveTC" value="RHAlinea"/>
								<cfinvokeargument name="ValorLlaveTC" value="#Arguments.RHAlinea#"/>
								<cfinvokeargument name="CampoMontoTC" value="RHDAmontores"/>
								<cfinvokeargument name="PorcSalario" value="#rsAccionES.RHAporcsal#"/><!---LTporcsal--->
								<cfinvokeargument name="RHCPlineaP" value="#rsAccionES.RHCPlineaP#"/>
								<cfinvokeargument name="RHAlinea" value="#Arguments.RHAlinea#"/>
							</cfinvoke>
						
							<cfset unidades = calculaComponenteRet.unidades>
							<cfset montobase = calculaComponenteRet.monto>
							<cfset monto = calculaComponenteRet.monto>
							<cfset metodo = 'M'>
							
						</cfif>
						<cfif Len(Trim(unidades)) EQ 0 or Len(Trim(montobase)) EQ 0 or Len(Trim(monto)) EQ 0>
							<cf_throw message="#MSG_NoPuedeAplicarAccion#">
						</cfif>
		
						<cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
							update RHDAcciones
								set RHDAunidad = <cfqueryparam cfsqltype="cf_sql_float" value="#unidades#">,
								RHDAmontobase= <cfqueryparam cfsqltype="cf_sql_money" value="#replace(montobase, ',','','all')#">,
								RHDAmontores = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(monto, ',','','all')#">,
								RHDAmetodoC = <cfqueryparam cfsqltype="cf_sql_char" value="#metodo#">,
								BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
								BMfechamodif = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
							where RHDAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHDAlinea#">
						</cfquery>
					</cfloop> 
				</cfif>
	
				<!--- Limpia tablas y agrega de nuevo en la tabla RHConceptosAccion--->
				<cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
					delete from RHSalPromAccion
					where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
				</cfquery>
				<cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
					delete from RHConceptosAccion 
					where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
				</cfquery>
				<!--- Procesamiento de los Conceptos de Pago --->
				<cfquery name="rsConceptos" datasource="#Session.DSN#">
					select a.DLfvigencia, 
						   a.DLffin, 
						   a.DEid, 
						   a.Ecodigo, 
						   a.RHTid, 
						   a.RHAlinea, 
						   coalesce(a.RHJid, 0) as RHJid, 
						   c.CIid, 
						   c.CIcantidad, c.CIrango, c.CItipo, c.CIcalculo, c.CIdia, c.CImes
						   ,CIsprango, coalesce(CIspcantidad,0) as CIspcantidad, coalesce(CImescompleto,0) as CImescompleto
					from RHAcciones a, ConceptosTipoAccion b, CIncidentesD c
					where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
					and a.RHTid = b.RHTid
					and b.CIid = c.CIid
				</cfquery>
				<cfloop query="rsConceptos">					
					<cfset FVigencia = LSDateFormat(rsConceptos.DLfvigencia, 'DD/MM/YYYY')>
					<cfset FFin = LSDateFormat(rsConceptos.DLffin, 'DD/MM/YYYY')>
					
					<cfset current_formulas = rsConceptos.CIcalculo>
					<cfset presets_text = RH_Calculadora.get_presets(CreateDate(ListGetAt(FVigencia,3,'/'), ListGetAt(FVigencia,2,'/'), ListGetAt(FVigencia,1,'/')),
												   CreateDate(ListGetAt(FFin,3,'/'), ListGetAt(FFin,2,'/'), ListGetAt(FFin,1,'/')),
												   rsConceptos.CIcantidad,
												   rsConceptos.CIrango,
												   rsConceptos.CItipo,
												   rsConceptos.DEid,
												   rsConceptos.RHJid,
												   rsConceptos.Ecodigo,
												   rsConceptos.RHTid,
												   rsConceptos.RHAlinea,
												   rsConceptos.CIdia,
												   rsConceptos.CImes,
												   "", <!--- Tcodigo solo se requiere si no va RHAlinea--->
												   FindNoCase('SalarioPromedio', current_formulas), <!--- optimizacion - SalarioPromedio es el calculo más pesado--->
												   'false',
												   '',
												   FindNoCase('DiasRealesCalculoNomina', current_formulas) <!--- optimizacion - DiasRealesCalculoNomina es el segundo calculo mas pesado--->
												   , 0
												   , '' 
												   ,rsConceptos.CIsprango
												   ,rsConceptos.CIspcantidad
												   ,rsConceptos.CImescompleto)>
					<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
					<cfset calc_error = RH_Calculadora.getCalc_error()>
					<cfif Not IsDefined("values")>
						<cfif isdefined("presets_text")>
							<cf_throw message="#presets_text# & '----' & #current_formulas# & '-----' & #calc_error#">
						<cfelse>
							<cf_throw message="#calc_error#" >
						</cfif>
					</cfif>
					
					
					<cfquery name="updConceptos" datasource="#Session.DSN#">
						insert into RHConceptosAccion(RHAlinea, CIid, RHCAimporte, RHCAres, RHCAcant, CIcalculo,BMUsucodigo,BMfecha)
						values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConceptos.CIid#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#values.get('importe').toString()#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#values.get('resultado').toString()#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#values.get('cantidad').toString()#">,
							<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#presets_text & ';' & current_formulas#">
							,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
							,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						)
					</cfquery> 
				</cfloop>
				
				<!--- Valida si debe realizar verificacion de presupuesto--->
				<cfquery name="vParam" datasource="#session.dsn#">
					select Pvalor from RHParametros where Pcodigo=540 and Ecodigo=#session.Ecodigo#
				</cfquery>
				<cfif vParam.Pvalor eq 1>
					<cfif isdefined("Form.btnAplicar")>
							<cfquery name="rsArt" datasource="#session.dsn#">
								select RHCatParcial from RHTipoAccion where RHTid=#form.RHTid#
							</cfquery>
							<cfif rsArt.RHCatParcial eq 1>
								<cfinvoke component="rh.Componentes.RH_ValidaPresupuesto"  method="Art40">
								 <cfinvokeargument name="RHAlinea" value="#Arguments.RHAlinea#"/>
								</cfinvoke>
							</cfif>
							<cfif isdefined('rsConsTipoAccion') and (rsConsTipoAccion.RHTcomportam eq 1 or rsConsTipoAccion.RHTcomportam eq 6 or rsConsTipoAccion.RHTcomportam eq 8 or rsConsTipoAccion.RHTcomportam eq 11 or rsConsTipoAccion.RHTcomportam eq 12)>
								<cfinvoke component="rh.Componentes.RH_ValidaPresupuesto"  method="ReservaAccion">
									 <cfinvokeargument name="RHAlinea" value="#Arguments.RHAlinea#"/>
								 </cfinvoke>
							</cfif>
					</cfif>
				</cfif>
				
			</cftransaction>
		
		<cfreturn true>
		
	</cffunction>
</cfcomponent>
