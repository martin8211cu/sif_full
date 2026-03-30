
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
    6 Cambio
	12 Nombramiento Recargo de Plazas
	
	se eliminan los procesos de las siguientes acciones, porque no aplican para los recargos, estas aplican para la linea de tiempo principal.
	1 Nombramiento ESTE SE CAMBIA POR EL 12
    2 Cese
    3 Vacaciones
    4 Permiso
    5 Incapacidad
    7 Anulación
    8 Aumento
	9 Cambio de Empresa
	10 Anotación
	11 antigüedad
	
	solamente debe de consirar modificaciones en la linea de tiempo (CAMBIO)
    --->	
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
                    b.RHPid,
                    b.RHAccionRecargo
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
		<cfif LEN(TRIM(dataTipoAccion.RHAccionRecargo))>
            <cfquery name="DatosPlaza" datasource="#session.DSN#">
                select RHPid
                from LineaTiempoR
                where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
                  and LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTipoAccion.RHAccionRecargo#">
            </cfquery>
        </cfif>
        <cfif isdefined('DatosPlaza') and  DatosPlaza.RecordCount>
            <cfset Lvar_Plaza = DatosPlaza.RHPid>
        <cfelse>
            <cfset Lvar_Plaza = 0>
        </cfif>



		<!--- El proceso se va a dividir en 2 partes el actual en donde se procesan las acciones normales       --->
		<!--- y el nuevo donde se van a procesar las acciones especiales ANTIGÜEDAD, ANOTACION  Y CAMBIO PUESTO --->
		<!--- Para poder indentificarlas se utiliza la variable  RHTespecial donde 0 es normal y 1 especial     --->
		<!--- *********************************************************************************************     --->
		<!---                                 Acciones de tipo normal                                           --->
		<!--- *********************************************************************************************     --->
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
		<!--- Validaciones adicionales --->
		<cfif Arguments.validar>
			<!--- ********************************************************************************************* --->
			<!---                                 Acciones de tipo normal                                       --->
			<!--- ********************************************************************************************* --->
			<!--- Quita las horas de las fechas --->
            <cfset LvarTemp = LSDateFormat(Fdesde, 'dd/mm/yyyy')>
            <cfset Fdesde = CreateDate(ListGetAt(LvarTemp, 3, '/'), ListGetAt(LvarTemp, 2, '/'), ListGetAt(LvarTemp, 1, '/'))>
            <cfset LvarTemp = LSDateFormat(Fhasta, 'dd/mm/yyyy')>
            <cfset Fhasta = CreateDate(ListGetAt(LvarTemp, 3, '/'), ListGetAt(LvarTemp, 2, '/'), ListGetAt(LvarTemp, 1, '/'))>
            <cfset Plaza = RHPid>
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
				<!--- Si la Accion es de Nombramiento de RECARGO--->
				<cfif dataTipoAccion.RHTcomportam EQ 12>
					<!---Si la acción es de Nombramiento, no puede caerle encima a otras acciones que tengan vigencia dentro de las fechas de la Accion --->
					<cfquery name="checkLT" datasource="#Arguments.conexion#">
						select 1 
						from LineaTiempoR a 
						where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
						and (
							LTdesde between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
						 or LThasta between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
						)
                        and a.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Plaza#">
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
						from LineaTiempoR a, RHTipoAccion b 
						where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
						and b.RHTcomportam = 12 
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#"> between a.LTdesde and a.LThasta
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#"> between a.LTdesde and a.LThasta
                        and a.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Plaza#">
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
				<cfif dataTipoAccion.RHTcomportam NEQ 12 and dataTipoAccion.RHTcomportam NEQ 2>
					<!--- La fecha desde tiene que caer en un rango existente --->
					<cfquery name="checkLT" datasource="#Arguments.conexion#">
						select 1 
						from LineaTiempoR 
						where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#"> between LTdesde and LThasta
                        and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Plaza#">
					</cfquery>
					<cfif checkLT.recordCount EQ 0>
						<cf_throw message="#MSG_EAccionLineaTiempo#" errorCode="12165">
						<cfabort>
					</cfif>
					<!--- La fecha desde tiene que caer en un rango existente --->
					<cfquery name="checkLT" datasource="#Arguments.conexion#">
						select 1 
						from LineaTiempoR
						where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#"> between LTdesde and LThasta
                        and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Plaza#">
					</cfquery>
					<cfif checkLT.recordCount EQ 0>
						<cfquery name="checkMaxLTRid" datasource="#Arguments.conexion#">
						select max (LThasta) as Fhasta
						from LineaTiempoR 
						where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">						
                          and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Plaza#">
						</cfquery>
						<cfif checkMaxLTRid.recordCount EQ 0>					
                            <cf_throw message="#MSG_EAccionLineaTiempo#" errorCode="12165">
                            <cfabort>
						<cfelse>
							<cfset Fhasta= "#checkMaxLTRid.Fhasta#">	
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
							<cf_throw message="#MSG_ENoTieneAntiguedad#" errorCode="12170">
							<cfthrow message="#LB_msg4#&nbsp; (#vDiasvericomp# días)&nbsp;#LB_msg5#&nbsp;">
							<cfabort>
						</cfif>
					</cfif>
				</cfif>
				<!--- Se valida únicamente si el tipo de acción es nombramiento, cambio o cambio de empresa --->
				<cfif dataTipoAccion.RHTcomportam EQ 12 or dataTipoAccion.RHTcomportam EQ 6 or dataTipoAccion.RHTcomportam EQ 9>					
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
			<cfreturn true>
		</cfif> <!--- FIN Arguments.validar --->
		<!--- ********************************************************************************************* --->
		<!---                                 Acciones de tipo normal                                       --->
		<!--- ********************************************************************************************* --->
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
			<!--- Agregar la Accion a los Datos Laborales del Empleado --->
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
					RHfolio,		RHporcimss,		RHTtiponomb,RHPcodigoAlt
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
					b.RHTtiponomb,RHPcodigoAlt
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
			<!--- Actualizo la situacion anterior en DatosLaboralesEmpleado y en el Detalle --->
			<cfquery name="LTiempo" datasource="#Arguments.conexion#">
				select
					b.Dcodigo, 		b.Ocodigo, 		b.RHPid,
					b.RHPcodigo,	b.Tcodigo,		b.LTsalario,
					b.RVid,			b.LTporcplaza,	b.LTporcsal,
					b.RHJid,		b.LTRid,			b.Ecodigo
				from DLaboralesEmpleado a
                inner join LineaTiempoR b
                	on b.DEid = a.DEid
				    and a.DLfvigencia between b.LTdesde and b.LThasta
				where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insDLaboralesEmpleado.identity#">
                  and b.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Plaza#">
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
						RHJidant = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LTiempo.RHJid#">
					where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insDLaboralesEmpleado.identity#">
				</cfquery>
				<cfquery name="updDDLaboralesEmpleado" datasource="#Arguments.conexion#">
					update DDLaboralesEmpleado 
					   set
						DDLunidadant = 
							(
								select c.DLTunidades
								  from DLineaTiempoR c
								 where c.LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LTiempo.LTRid#">
								   and c.CSid = DDLaboralesEmpleado.CSid
							),
						DDLmontobaseant =
							(
								select c.DLTmonto
								  from DLineaTiempoR c
								 where c.LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LTiempo.LTRid#">
								   and c.CSid = DDLaboralesEmpleado.CSid
							),
						DDLmontoresant = 
							(
								select c.DLTmonto
								  from DLineaTiempoR c
								 where c.LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LTiempo.LTRid#">
								   and c.CSid = DDLaboralesEmpleado.CSid
							),
						DDLmetodoCant =
							(
								select c.DLTmetodoC
								  from DLineaTiempoR c
								 where c.LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LTiempo.LTRid#">
								   and c.CSid = DDLaboralesEmpleado.CSid
							)	
					where DDLaboralesEmpleado.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insDLaboralesEmpleado.identity#">
					  and exists 
							(
								select 1
								  from DLineaTiempoR c
								 where c.LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LTiempo.LTRid#">
								   and c.CSid = DDLaboralesEmpleado.CSid
							)
				</cfquery>
			</cfif>
			<!---
				La afectacion de la linea del tiempo solo se hace si la accion (Tipo de Accion) 
				indica que afecta la linea del tiempo. 
				Retroactiva = 0 indica que la linea del tiempo se construye retroactivamente
			--->
			<cfif dataTipoAccion.RHTnoretroactiva EQ 0>
				<cfinvoke component="rh.Componentes.RH_ConstruyeLTRecargo" method="ConstruyeLT" returnvariable="LvarResult">
					<cfinvokeargument name="Ecodigo" value="#Arguments.Ecodigo#"/> 
					<cfinvokeargument name="RHAlinea" value="#Arguments.RHAlinea#"/> 
					<cfinvokeargument name="DEid" value="#Empleado#"/> 
					<cfinvokeargument name="RHTcomportam" value="#dataTipoAccion.RHTcomportam#"/> 
					<cfinvokeargument name="Usucodigo" value="#Arguments.Usucodigo#"/> 
					<cfinvokeargument name="respetarLT" value="#Arguments.respetarLT#"/> 
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
			<cfset FechaIncidencia = Fdesde>
			<!---
				Actualizar el empleado como no calculado para todas las relaciones de calculo abiertas (en proceso)
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
					set Ivalor = Ivalor + coalesce((select a.RHCAres
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
                       a.RHCAres,
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
            default="Error! No se ha definido el par&acute;metro de d&iacute;as para el c&aacute;lculo de salario diario (Tipos de Nómina). Proceso Cancelado!"	
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
    </cffunction>
</cfcomponent>
