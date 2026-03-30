<cfcomponent>
	<cffunction name="ConstruyeLT" access="public" output="true" returntype="boolean">
		<cfargument name="Ecodigo" type="numeric" required="yes">
		<cfargument name="RHAlinea" type="numeric" required="yes">		<!--- Accion en Proceso --->
		<cfargument name="DEid" type="numeric" required="yes">			<!--- Empleado --->
		<cfargument name="RHTcomportam" type="numeric" required="yes">	<!--- Comportamiento de la Accion --->
		<cfargument name="respetarLT" type="boolean" required="no" default="false">		<!--- Indica si quiere respetar los cortes en la Linea del Tiempo / Utilizado unicamente para actualizar LTsalario y los componentes de la linea del tiempo --->
		<cfargument name="Usucodigo" type="string" required="no" default="#Session.Usucodigo#">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#">
		<cfargument name="debug" type="boolean" required="no" default="false">
		
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="MSG_Error_La_accion_de_personal_no_existe" default="Error! La acción de personal no existe"	 returnvariable="MSG_AccionNoExiste" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_El_empleado_no_tiene_un_corte_en_la_Linea_del_Tiempo_Vigente" default="Error! El empleado no tiene un corte en la Línea del Tiempo Vigente. Por favor verifique las fechas Desde y Hasta de La Acción."	 returnvariable="MSG_EmpleadoNoTieneCortes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_la_empresa_destino_no_tiene_definida_una_accion_de_cambio_de_empresa_con_el_mismo_codigo_de_la_empresa_origen" default="Error! la empresa destino no tiene definida una acci&oacute;n de cambio de empresa con el mismo c&oacute;digo de la empresa origen "	 returnvariable="MSG_errorcambioempresa" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="MSG_ErrorLaPlazaUtilizadaEsLaPlazaPrincipal" default="Error! La plaza utilizada es la plaza principal, favor verificar."	 returnvariable="MSG_ErrorLaPlazaUtilizadaEsLaPlazaPrincipal" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
		<cfquery name="dataTipoAccion" datasource="#Arguments.conexion#">
			select  b.DLfvigencia as fechadesde,
					b.DLffin as fechahasta,
					b.Ecodigo,
					b.Tcodigo,
					b.EcodigoRef,
					b.TcodigoRef,
					a.RHTtiponomb,
					a.RHTnoretroactiva,
					a.RHTcomportam,
					a.RHTcempresa,
					a.RHTid,
                    b.RHAccionRecargo,
                    b.DEid,
                    b.RHPid,
                    RHTipoAplicacion
			from RHTipoAccion a, RHAcciones b 
			where a.RHTid = b.RHTid
			and b.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
		</cfquery>

		<cfif dataTipoAccion.recordCount EQ 0>
			<cfthrow message="#MSG_AccionNoExiste#">
			<cfabort>
		</cfif>
		
        
		<!--- Variables Iniciales --->
		<cfset LvarComportamiento = Arguments.RHTcomportam>
		
		<!--- Empresa cuando el comportamiento es un Cambio de Empresa --->
		<cfset LvarEmpresa = Arguments.Ecodigo>
		<!--- Quitar las horas de las fechas --->
		<cfset LvarTemp = LSDateFormat(dataTipoAccion.fechadesde, 'dd/mm/yyyy')>
		<cfset Fdesde = CreateDate(ListGetAt(LvarTemp, 3, '/'), ListGetAt(LvarTemp, 2, '/'), ListGetAt(LvarTemp, 1, '/'))>
		<cfif Len(Trim(dataTipoAccion.fechahasta))>
			<cfset LvarTemp = LSDateFormat(dataTipoAccion.fechahasta, 'dd/mm/yyyy')>
			<cfset Fhasta = CreateDate(ListGetAt(LvarTemp, 3, '/'), ListGetAt(LvarTemp, 2, '/'), ListGetAt(LvarTemp, 1, '/'))>
		<cfelse>
			<cfset Fhasta = CreateDate(6100, 01, 01)>
		</cfif>
		<!--- Tipo de Nomina cuando el comportamiento es un Cambio de Empresa --->
		<cfset TipoNomina = dataTipoAccion.Tcodigo>
		<cfset RCNid = 0>
        <cfset Empleado = dataTipoAccion.DEid>
		<cfif LEN(TRIM(dataTipoAccion.RHAccionRecargo))>
		   <!---  PLAZA  A LA QUE SE LE ESTA REALIZANDO EL CAMBIO --->
            <cfquery name="DatosPlaza" datasource="#session.DSN#">
                select RHPid
                from LineaTiempoR
                where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Empleado#">
                  and LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTipoAccion.RHAccionRecargo#">
            </cfquery>
        </cfif>
        <cfif isdefined('DatosPlaza') and DatosPlaza.RecordCount>
            <cfset Lvar_Plaza = DatosPlaza.RHPid>
        <cfelse>
            <cfset Lvar_Plaza = 0>
        </cfif>
        
        <!--- VERIFICA QUE LA PLAZA UTILIZADA NO SEA LA PRINCIPAL (LINEATIEMPO) --->
		<cfquery name="LineaTiempoP" datasource="#Arguments.conexion#">
			select 1
			from LineaTiempo
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			and (<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#"> between LTdesde and LThasta
            	or <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#"> between LTdesde and LThasta)
            and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTipoAccion.RHPid#">
		</cfquery>
        <cfif LineaTiempoP.recordCount GT 0>
			<cfthrow message="#MSG_ErrorLaPlazaUtilizadaEsLaPlazaPrincipal#">
			<cfabort>
		</cfif>
        
        
		<!--- Buscar la fecha del próximo calendario de pagos (NO ESPECIAL) que no ha sido calculado para el tipo de nómina de la acción --->
		<cfquery name="rsFechaRCNid" datasource="#Arguments.conexion#">
			select min(CPdesde) as FechaRCNid
			from CalendarioPagos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">
			and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#TipoNomina#">
			and CPfcalculo is null
			and CPtipo = 0
		</cfquery>
		<cfset FechaRCNid = rsFechaRCNid.FechaRCNid>
		
		<cfif Len(Trim(FechaRCNid))>
			<!--- Buscar la fecha del primer calendario de pagos (NO ESPECIAL) para el tipo de nómina de la acción --->
			<cfquery name="rsFechaRCNid" datasource="#Arguments.conexion#">
				select min(CPdesde) as minifRCNid
				from CalendarioPagos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">
				and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#TipoNomina#">
				and CPtipo = 0
			</cfquery>
			<cfset minifRCNid = rsFechaRCNid.minifRCNid>
			
			<cfif DateCompare(FechaRCNid,Fdesde) GT 0 and Len(Trim(minifRCNid)) and DateCompare(FechaRCNid, minifRCNid) GT 0 and dataTipoAccion.RHTnoretroactiva EQ 0>
				<cfquery name="rsRCNid" datasource="#Arguments.conexion#">
					select CPid as RCNid
					from CalendarioPagos
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">
					and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#TipoNomina#">
					and CPdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaRCNid#">
					and CPtipo = 0
				</cfquery>
				<!--- ID de Relación de Cálculo en que se incluirá esta acción --->
				<cfset RCNid = rsRCNid.RCNid>
				<!--- Actualizar las nóminas abiertas para poner el indicador en SEcalculado = 0 --->
				<cfquery datasource="#Arguments.conexion#">
					update SalarioEmpleado 
					   set SEcalculado = 0
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					and SEcalculado = 1
					and exists (
						select 1
						from RCalculoNomina a
						where a.RCdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaRCNid#">
						and a.RCestado = 0
						and a.RCNid = SalarioEmpleado.RCNid
					)
				</cfquery>
			</cfif>
			
			<!--- Actualizar las nóminas abiertas para poner el indicador en SEcalculado = 0 --->
			<cfquery datasource="#Arguments.conexion#">
				update SalarioEmpleado 
				   set SEcalculado = 0
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				and SEcalculado = 1
				and exists (
					select 1
					from RCalculoNomina a
					where a.RCdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
					and a.RCestado = 0
					and a.RCNid = SalarioEmpleado.RCNid
				)
			</cfquery>
		</cfif> <!--- Len(Trim(FechaRCNid)) --->

		<cfif Arguments.debug>
			<cfquery name="rsLTAntes" datasource="#Arguments.conexion#">
				select *,#LvarComportamiento#  as  LvarComportamiento from LineaTiempoR 
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				order by LTdesde
			</cfquery>
			<cfdump var="#rsLTAntes#" label="LineaTiempoR Antes">

		</cfif>
		
		<!--- PROCESO --->
		<!--- Si es NOMBRAMIENTO RECARGO--->
		<cfif LvarComportamiento EQ 12>
			<cfquery name="insLineaTiempoR" datasource="#Arguments.conexion#">
				insert into LineaTiempoR (DEid, Ecodigo, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTdesde, LThasta, LTporcplaza, LTsalario, LTporcsal, RHJid, CPid, IEid, TEid, RHCPlinea, RHTtiponomb,RHPcodigoAlt,RHCPlineaP)
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">, 
					   <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">, 
					   <cfqueryparam cfsqltype="cf_sql_char" value="#TipoNomina#">, 
					   a.RHTid, a.Ocodigo, a.Dcodigo, a.RHPid, a.RHPcodigo, a.RVid, 
					   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">, 
					   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">,
					   a.RHAporc, a.DLsalario, a.RHAporcsal, a.RHJid, 
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#" null="#Not Isdefined('RCNid') Or (Isdefined('RCNid') and RCNid EQ 0)#">,
					   a.IEid, a.TEid, a.RHCPlinea,
					   b.RHTtiponomb,RHPcodigoAlt,RHCPlineaP

				from RHAcciones a
					inner join RHTipoAccion b
						on a.RHTid = b.RHTid

				where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
				<cf_dbidentity1 datasource="#Arguments.conexion#" verificar_transaccion="no" returnvariable="Lvar">
			</cfquery>
			<cf_dbidentity2 datasource="#Arguments.conexion#" name="insLineaTiempoR" verificar_transaccion="no" returnvariable="Lvar">
            
			<cfquery datasource="#Arguments.conexion#">
				insert into DLineaTiempoR (LTRid, CSid, DLTmonto, DLTunidades, DLTtabla, CIid, DLTmetodoC)
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#insLineaTiempoR.identity#">, a.CSid, a.RHDAmontores, 
						a.RHDAunidad, a.RHDAtabla, cs.CIid,a.RHDAmetodoC
				from RHDAcciones a
					inner join ComponentesSalariales cs
					on cs.CSid = a.CSid
				where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
				and RHDAmontores != 0.00
			</cfquery>
			
			<cfif Arguments.debug>
				<cfquery name="rsLTDespues" datasource="#Arguments.conexion#">
					select * from LineaTiempoR 
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					order by LTdesde
				</cfquery>
				<cfdump var="#rsLTDespues#" label="LineaTiempoR Final">
			</cfif>
			<cfquery datasource="#session.DSN#">
				update LineaTiempoR
				set LTsalario = ( 	select sum(DLTmonto)
									from DLineaTiempoR
									where LTRid = LineaTiempoR.LTRid  ),
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				where LTRid = #Lvar#
			</cfquery>
			<cfreturn true>
		</cfif>
        

		<!--- Si es un CESE --->
		<cfif LvarComportamiento EQ 2>
			<!--- Buscar el segmento de la Linea del Tiempo donde cae la acción de cese --->
			<cfquery name="rsFechaTrabajo" datasource="#Arguments.conexion#">
				select min(LThasta) as fechatrab
				from LineaTiempoR 
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				and LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
				and LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
			</cfquery>
			<cfset FechaTrab = rsFechaTrabajo.fechatrab>

			<cfif Len(Trim(FechaTrab))>
				<!--- Buscar el código del segmento de la Linea del Tiempo donde cae la acción de cese --->
				<cfquery name="rsRango1" datasource="#Arguments.conexion#">
					select LTRid
					from LineaTiempoR 
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					and LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaTrab#">
				</cfquery>
				<cfset Rango1 = rsRango1.LTRid>
				
				<!--- Actualiza el segmento de la Linea del Tiempo donde cae la acción de cese con la fecha de la acción --->
				<cfquery datasource="#Arguments.conexion#">
					update LineaTiempoR 
						set LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',-1,Fdesde)#">,
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
            		where LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Rango1#">
				</cfquery>
				
				<!--- Marcar las relaciones de calculo activas como no calculadas --->
				<cfquery datasource="#Arguments.conexion#">
					update SalarioEmpleado
						set SEcalculado = 0
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					and exists (
						select 1
						from LineaTiempoR lt, PagosEmpleado pe, RCalculoNomina rc
						where lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
						and lt.LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
						and pe.LTRid = lt.LTRid
						and rc.RCNid = pe.RCNid
						and rc.RCestado = 0
						and SalarioEmpleado.RCNid = rc.RCNid
					)
				</cfquery>
				
				<!--- Elimina todos los segmentos de la Linea de Tiempo posteriores a la fecha de la acción de cese --->
				<cfquery name="delDLT" datasource="#Arguments.conexion#">
					delete from DLineaTiempoR
					where exists (
						select 1
						from LineaTiempoR a
						where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
						and a.LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
                        and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Plaza#">
						and DLineaTiempoR.LTRid = a.LTRid
					)
				</cfquery>
				<cfquery name="delLT" datasource="#Arguments.conexion#">
					delete from LineaTiempoR 
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					and LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
                    and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Plaza#">
				</cfquery>
			</cfif>
			
			<cfif Arguments.debug>
				<cfquery name="rsLTDespues" datasource="#Arguments.conexion#">
					select * from LineaTiempoR 
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					order by LTdesde
				</cfquery>
				<cfdump var="#rsLTDespues#" label="LineaTiempoR Final">
			</cfif>
			
			<cfreturn true>
		</cfif>
        
        <!--- Si es un Finalizar Recargo --->
		<cfif LvarComportamiento EQ 15>
			<!--- Buscar el segmento de la Linea del Tiempo donde cae la acción de cese --->
			<cfquery name="rsFechaTrabajo" datasource="#Arguments.conexion#">
				select min(LThasta) as fechatrab
				from LineaTiempoR 
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				and LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
				and LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
                and LTRid = #dataTipoAccion.RHAccionRecargo#
			</cfquery>
			<cfset FechaTrab = rsFechaTrabajo.fechatrab>

			<cfif Len(Trim(FechaTrab))>
				<!--- Buscar el código del segmento de la Linea del Tiempo donde cae la acción de cese --->
				<cfquery name="rsRango1" datasource="#Arguments.conexion#">
					select LTRid
					from LineaTiempoR 
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					and LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaTrab#">
                    and LTRid = #dataTipoAccion.RHAccionRecargo#
				</cfquery>
				<cfset Rango1 = rsRango1.LTRid>
				
				<!--- Actualiza el segmento de la Linea del Tiempo donde cae la acción de cese con la fecha de la acción --->
				<cfquery datasource="#Arguments.conexion#">
					update LineaTiempoR 
						set LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">,
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
            		where LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Rango1#">
				</cfquery>
				
				<!--- Marcar las relaciones de calculo activas como no calculadas --->
				<cfquery datasource="#Arguments.conexion#">
					update SalarioEmpleado
						set SEcalculado = 0
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					and exists (
						select 1
						from LineaTiempoR lt, PagosEmpleado pe, RCalculoNomina rc
						where lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
						and lt.LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
						and pe.LTRid = lt.LTRid
						and rc.RCNid = pe.RCNid
						and rc.RCestado = 0
						and SalarioEmpleado.RCNid = rc.RCNid
					)
				</cfquery>
				
				<!--- Elimina todos los segmentos de la Linea de Tiempo posteriores a la fecha de la acción de Finalizacion --->
				<cfquery name="delDLT" datasource="#Arguments.conexion#">
					delete from DLineaTiempoR
					where exists (
						select 1
						from LineaTiempoR a
						where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
						and a.LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
                        and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Plaza#">
						and DLineaTiempoR.LTRid = a.LTRid
					)
				</cfquery>
				<cfquery name="delLT" datasource="#Arguments.conexion#">
					delete from LineaTiempoR 
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					and LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
                    and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Plaza#">
				</cfquery>
			</cfif>
			
			<cfif Arguments.debug>
				<cfquery name="rsLTDespues" datasource="#Arguments.conexion#">
					select * from LineaTiempoR 
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					order by LTdesde
				</cfquery>
				<cfdump var="#rsLTDespues#" label="LineaTiempoR Final">
			</cfif>
			
			<cfreturn true>
		</cfif>

		<!--- Si es un CAMBIO DE EMPRESA --->
		<cfif LvarComportamiento EQ 9 and dataTipoAccion.RHTcempresa EQ 1>
			<!--- Buscar el segmento de la Linea del Tiempo donde cae la acción de cambio de empresa --->
			<cfquery name="rsFechaTrabajo" datasource="#Arguments.conexion#">
				select min(LThasta) as fechatrab
				from LineaTiempoR 
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				and LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
				and LTdesde < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
			</cfquery>
			<cfset FechaTrab = rsFechaTrabajo.fechatrab>

			<cfif Len(Trim(FechaTrab))>
				<!--- Buscar el código del segmento de la Linea del Tiempo donde cae la acción de cambio de empresa --->
				<cfquery name="rsRango1" datasource="#Arguments.conexion#">
					select LTRid
					from LineaTiempoR 
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					and LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaTrab#">
				</cfquery>
				<cfset Rango1 = rsRango1.LTRid>
				
				<!--- Actualiza el segmento de la Linea del Tiempo donde cae la acción de cambio de empresa con la fecha de la acción --->
				<cfquery datasource="#Arguments.conexion#">
					update LineaTiempoR 
						set LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',-1,Fdesde)#">,
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
            		where LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Rango1#">
				</cfquery>
				
				<!--- Marcar las relaciones de calculo activas como no calculadas --->
				<cfquery datasource="#Arguments.conexion#">
					update SalarioEmpleado
						set SEcalculado = 0
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					and exists (
						select 1
						from LineaTiempoR lt, PagosEmpleado pe, RCalculoNomina rc
						where lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
						and lt.LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
						and pe.LTRid = lt.LTRid
						and rc.RCNid = pe.RCNid
						and rc.RCestado = 0
						and SalarioEmpleado.RCNid = rc.RCNid
					)
				</cfquery>
				
				<!--- Elimina todos los segmentos de la Linea de Tiempo posteriores a la fecha de la acción de cambio de empresa --->
				<cfquery name="delDLT" datasource="#Arguments.conexion#">
					delete from DLineaTiempoR
					where exists (
						select 1
						from LineaTiempoR a
						where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
						and a.LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
                        and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Plaza#">
						and DLineaTiempoR.LTRid = a.LTRid
					)
				</cfquery>
				<cfquery name="delLT" datasource="#Arguments.conexion#">
					delete from LineaTiempoR 
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					and LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
                    and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Plaza#">
				</cfquery>
				
				<!--- Insertar el nuevo segmento de la Linea del Tiempo del Empleado para la nueva Empresa --->
				<cfif LvarComportamiento EQ 9>
					<cfquery name="RS_RHTipoAccionDEST" datasource="#Arguments.conexion#">
                    	select x.RHTid,x.RHTtiponomb
                        from RHTipoAccion x
                        where x.RHTcodigo =
                            (select b.RHTcodigo 
                                from RHAcciones a
                                inner join RHTipoAccion b
                                on a.RHTid = b.RHTid
                                and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">
                           		where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">)  
                        and x.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#dataTipoAccion.EcodigoRef#">    
						and x.RHTcomportam = 9       
                    </cfquery>
					
					<cfif RS_RHTipoAccionDEST.recordCount EQ 0>
						<!--- si en la empresa destino no se encuentra una accion de tipo cambio de empresa con el mismo codigo se au --->
						<cfquery datasource="#Arguments.conexion#">
								insert into RHTipoAccion 
								(
									Ecodigo, 			
									RHTcodigo, 			RHTdesc, 
									RHTpaga, 			RHTpfijo,			RHTpmax, 
									RHTcomportam,		RHTposterior,		RHTautogestion, 
									RHTindefinido, 		RHTcempresa, 		RHTctiponomina, 
									RHTcregimenv, 		RHTcoficina, 		RHTcdepto, 
									RHTcplaza, 			RHTcpuesto, 		RHTccomp, 
									RHTcsalariofijo,	RHTccatpaso, 		RHTvisible, 
									RHTcjornada, 		RHTidtramite, 		RHTnorenta, 
									RHTnocargas, 		RHTnodeducciones, 	RHTnoretroactiva, 
									RHTcuentac, 		CIncidente1, 		CIncidente2, 
									RHTcantdiascont, 	RHTnocargasley, 	RHTnoveriplaza, 
									RHTliquidatotal, 	BMUsucodigo, 		RHTdatoinforme, 
									RHTpension, 		RHTnomarca, 		RHTfanual, 
									RHTfvacacion, 		RHTalerta, 			RHTdiasalerta, 
									RHTtiponomb, 		RHTafectafantig, 	RHTafectafvac, 
									RHTespecial, 		RHTnopagaincidencias)
							select  <cfqueryparam cfsqltype="cf_sql_integer" value="#dataTipoAccion.EcodigoRef#">, 			
									RHTcodigo, 			RHTdesc, 
									RHTpaga, 			RHTpfijo,			RHTpmax, 
									RHTcomportam,		RHTposterior,		RHTautogestion, 
									RHTindefinido, 		RHTcempresa, 		RHTctiponomina, 
									RHTcregimenv, 		RHTcoficina, 		RHTcdepto, 
									RHTcplaza, 			RHTcpuesto, 		RHTccomp, 
									RHTcsalariofijo,	RHTccatpaso, 		RHTvisible, 
									RHTcjornada, 		RHTidtramite, 		RHTnorenta, 
									RHTnocargas, 		RHTnodeducciones, 	RHTnoretroactiva, 
									RHTcuentac, 		CIncidente1, 		CIncidente2, 
									RHTcantdiascont, 	RHTnocargasley, 	RHTnoveriplaza, 
									RHTliquidatotal, 	
									<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">, 		
									RHTdatoinforme, 
									RHTpension, 		RHTnomarca, 		RHTfanual, 
									RHTfvacacion, 		RHTalerta, 			RHTdiasalerta, 
									RHTtiponomb, 		RHTafectafantig, 	RHTafectafvac, 
									RHTespecial, 		RHTnopagaincidencias
							from 	RHTipoAccion	
							where   Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">
							and     RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTipoAccion.RHTid#">		
						</cfquery>
						<cfquery name="RS_RHTipoAccionDEST" datasource="#Arguments.conexion#">
							select x.RHTid,x.RHTtiponomb
							from RHTipoAccion x
							where x.RHTcodigo =
								(select b.RHTcodigo 
									from RHAcciones a
									inner join RHTipoAccion b
									on a.RHTid = b.RHTid
									and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">
									where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">)  
							and x.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#dataTipoAccion.EcodigoRef#">    
							and x.RHTcomportam = 9       
                    	</cfquery>
					</cfif>
				</cfif>
                <cfquery datasource="#Arguments.conexion#">
					insert into LineaTiempoR (DEid, Ecodigo, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTdesde, LThasta, LTporcplaza, LTsalario, LTporcsal, RHJid, CPid, IEid, TEid, RHCPlinea,RHPcodigoAlt, RHTtiponomb,RHCPlineaP)
					select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">, 
							<cfif LvarComportamiento EQ 9 and dataTipoAccion.RHTcempresa EQ 1>
                               <cfqueryparam cfsqltype="cf_sql_integer" value="#dataTipoAccion.EcodigoRef#">, 
                               <cfqueryparam cfsqltype="cf_sql_char" value="#dataTipoAccion.TcodigoRef#">, 
                            <cfelse>
                               <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">, 
                               <cfqueryparam cfsqltype="cf_sql_char" value="#TipoNomina#">, 
                            </cfif>
                           <cfif LvarComportamiento NEQ 9>a.RHTid<cfelse>#RS_RHTipoAccionDEST.RHTid#</cfif>,
                           a.Ocodigo, a.Dcodigo, a.RHPid, a.RHPcodigo, a.RVid, 
						   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">, 
						   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">,
						   a.RHAporc, a.DLsalario, a.RHAporcsal, a.RHJid, 
						   <cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#" null="#Not Isdefined('RCNid') Or (Isdefined('RCNid') and RCNid EQ 0)#">,
						   a.IEid, a.TEid, a.RHCPlinea,RHPcodigoAlt,
						   <cfif LvarComportamiento NEQ 9>
						   		b.RHTtiponomb,
						   <cfelse>
						   		<cfif isdefined("RS_RHTipoAccionDEST.RHTtiponomb") and Len(Trim(RS_RHTipoAccionDEST.RHTtiponomb)) NEQ 0>
						   			#RS_RHTipoAccionDEST.RHTtiponomb#,
						   		<cfelse>
						   			null,
						   		</cfif>	
						   </cfif>
                           RHCPlineaP
					from RHAcciones a
						<cfif LvarComportamiento NEQ 9>
                            inner join RHTipoAccion b
                            on a.RHTid = b.RHTid
                            and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">
                        </cfif>
					where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
					<cf_dbidentity1 datasource="#Arguments.conexion#" verificar_transaccion="no">
				</cfquery>
				<cf_dbidentity2 datasource="#Arguments.conexion#" name="insLineaTiempoR" verificar_transaccion="no">
				
				<cfquery datasource="#Arguments.conexion#">
					insert into DLineaTiempoR (LTRid, CSid, DLTmonto, DLTunidades, DLTtabla, CIid, DLTmetodoC)
					select <cfqueryparam cfsqltype="cf_sql_numeric" value="#insLineaTiempoR.identity#">, a.CSid, a.RHDAmontores, 
						a.RHDAunidad, a.RHDAtabla, cs.CIid,a.RHDAmetodoC
					from RHDAcciones a
						inner join ComponentesSalariales cs
						on cs.CSid = a.CSid
					where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
					and RHDAmontores != 0.00
				</cfquery>
	
			</cfif>
			
			<cfif Arguments.debug>
				<cfquery name="rsLTDespues" datasource="#Arguments.conexion#">
					select * from LineaTiempoR 
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					order by LTdesde
				</cfquery>
				<cfdump var="#rsLTDespues#" label="LineaTiempoR Final">
			</cfif>
			
			<cfreturn true>
		</cfif>
		
		<!--- Las demás Acciones --->
		<cfquery name="LT1" datasource="#Arguments.conexion#">
			select LTRid as id1, LTdesde as fechatrab1
			from LineaTiempoR 
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#"> between LTdesde and LThasta
            and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Plaza#">
		</cfquery>
		<cfset id1 = LT1.id1>
		<cfset fechatrab1 = LT1.fechatrab1>
		<cfquery name="LT2" datasource="#Arguments.conexion#">
			select LTRid as id2, LThasta as fechatrab2
			from LineaTiempoR 
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#"> between LTdesde and LThasta
            and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Plaza#">
		</cfquery>
		<cfset id2 = LT2.id2>
		<cfset fechatrab2 = LT2.fechatrab2>
		
		<cfif Arguments.debug>
			<cfoutput>fechatrab1: #fechatrab1#</cfoutput><br>
			<cfoutput>fechatrab2: #fechatrab2#</cfoutput><br>
		</cfif>
		
		<!--- Validar que tenga un corte vigente en la Linea del Tiempo --->
		<cfif Len(trim(fechatrab2)) eq 0>
			<cfthrow message="#MSG_EmpleadoNoTieneCortes#">
			<cfabort>
		</cfif>
		
        <!--- Inserta el movimiento final --->
		<cfif Len(fechatrab2) And (DateCompare(fechatrab2, CreateDate(6100, 01, 01)) EQ 0 OR id1 EQ id2)>
			<cfquery name="LTiempo" datasource="#Arguments.conexion#">
				select 1 from LineaTiempoR a 
				where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				and LTdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', 1, Fhasta)#">
                and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Plaza#">
			</cfquery>

			<cfif LTiempo.recordCount EQ 0>
				<cfquery name="insLineaTiempoR2" datasource="#Arguments.conexion#">
					insert into LineaTiempoR(DEid, Ecodigo, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTdesde, LThasta, LTporcplaza, LTsalario, LTporcsal, RHJid, CPid, IEid, TEid, RHCPlinea, RHTtiponomb,RHPcodigoAlt,RHCPlineaP)
					select DEid, 
						   Ecodigo, 
						   Tcodigo, 
						   RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, 
						   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', 1, Fhasta)#">,
						   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechatrab2#">, 
						   LTporcplaza, LTsalario, LTporcsal, RHJid, 
						   <cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#" null="#Not Isdefined('RCNid') Or (Isdefined('RCNid') and RCNid EQ 0)#">, 
						   IEid, TEid, RHCPlinea, RHTtiponomb,RHPcodigoAlt,RHCPlineaP
					from LineaTiempoR
					where LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					and LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechatrab2#">
					<cf_dbidentity1 datasource="#Arguments.conexion#" verificar_transaccion="no">
				</cfquery>
				<cf_dbidentity2 datasource="#Arguments.conexion#" name="insLineaTiempoR2" verificar_transaccion="no">
		

				<cfquery datasource="#Arguments.conexion#">
					insert into DLineaTiempoR (LTRid, CSid, DLTmonto, DLTunidades, DLTtabla, CIid, DLTmetodoC)
					select <cfqueryparam cfsqltype="cf_sql_numeric" value="#insLineaTiempoR2.identity#">, 
						   b.CSid, b.DLTmonto, b.DLTunidades, b.DLTtabla, b.CIid, DLTmetodoC
					from LineaTiempoR a
                    inner join DLineaTiempoR b
						on a.LTRid = b.LTRid
					where a.LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					and a.LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechatrab2#">
					and b.DLTmonto != 0.00
				</cfquery>

				<!--------------------------- Agregado por Yu Hui 30/11/2005 --------------------------->
				<cfquery datasource="#Arguments.conexion#">
					update LineaTiempoR 
						set LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">,
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					where LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					and LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechatrab2#">
				</cfquery>
				<!-------------------------------------------------------------------------------------->
			</cfif>
				
        <!--- Actualizo el corte Posterior --->
		<cfelse>
			<cfquery datasource="#Arguments.conexion#">
				update LineaTiempoR 
					set LTdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', 1, Fhasta)#">, 
						CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#" null="#Not Isdefined('RCNid') Or (Isdefined('RCNid') and RCNid EQ 0)#">,
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				where LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				and LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechatrab2#">
				and not exists (
					select 1 from LineaTiempoR b 
					where b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					and b.LTdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', 1, Fhasta)#">
				)
			</cfquery>
			
		</cfif>

        <!--- Actualizo el Corte anterior --->
		<cfquery datasource="#Arguments.conexion#">
			update LineaTiempoR 
				set LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', -1, Fdesde)#">,
				 	BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			where LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id1#">
			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			and LTdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechatrab1#">
		</cfquery>

        <!--- Borrar La linea del Tiempo que esta dentro del tiempo de la Accion --->

        <!--- Marcar las relaciones de calculo activas como no calculadas --->
		<cfquery datasource="#Arguments.conexion#">
			update SalarioEmpleado
				set SEcalculado = 0
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			and exists (
				select 1
				from LineaTiempoR lt, PagosEmpleado pe, RCalculoNomina rc
				where lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				and lt.LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
				and lt.LThasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
				and pe.LTRid = lt.LTRid
				and rc.RCNid = pe.RCNid
				and rc.RCestado = 0
				and SalarioEmpleado.RCNid = rc.RCNid
			)
		</cfquery>


		<!--- Modificado por Yu Hui 30/11/2005
			Para permitir modificar la linea del tiempo respetando los cortes que ya existen
		--->
				
			
		<cfif not Arguments.respetarLT>
            <cfif dataTipoAccion.RHTipoAplicacion EQ 1>
				<!--- TABLA TEMPORAL PARA MANEJO DE COMPONENTES
                APLICA SOLO PARA EL CASO EN QUE SE MODIFICA UN SOLO COMPONENTE --->
                <cf_dbtemp name="ComponentesS" returnvariable="ComponentesS" datasource="#Arguments.conexion#">
                	<cf_dbtempcol name="RHAlinea" 	 type="numeric"  mandatory="yes"> 
                    <cf_dbtempcol name="LTRid" 		 type="numeric"  mandatory="yes"> 
                    <cf_dbtempcol name="CSid" 		 type="numeric" mandatory="yes">
                    <cf_dbtempcol name="DLTmonto" 	 type="money"   mandatory="yes">
                    <cf_dbtempcol name="DLTunidades" type="float"   mandatory="yes">
                    <cf_dbtempcol name="CIid" 		 type="numeric" mandatory="no">
                    <cf_dbtempcol name="DLTmetodoC"  type="char"    mandatory="no">
                </cf_dbtemp>
                
                
                <!--- INSERTAR LOS COMPONENTES ASOCIADOS EN LA LINEA DE TIEMPO EN LA FECHA DE LA ACCION --->
                <cfquery datasource="#session.DSN#">
                	insert into #ComponentesS#(RHAlinea,LTRid,CSid,DLTmonto,DLTunidades,b.CIid,DLTmetodoC)
                    select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">,
                    	a.LTRid, b.CSid,DLTmonto,DLTunidades,b.CIid,DLTmetodoC
                    from LineaTiempoR a
                    inner join DLineaTiempoR b
                        on b.LTRid = a.LTRid
                    inner join ComponentesSalariales c
                        on c.CSid = b.CSid
                    where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                      and a.LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
                      and a.LThasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
                      and a.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Plaza#">
                </cfquery>
                
                <cfquery  datasource="#session.DSN#">
                	insert into #ComponentesS#(RHAlinea,LTRid,CSid,DLTmonto,DLTunidades,b.CIid,DLTmetodoC)
                    select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">,
                    	0, cs.CSid,a.RHDAmontores, a.RHDAunidad,cs.CIid,a.RHDAmetodoC
                    from RHDAcciones a
                        inner join ComponentesSalariales cs
                        on cs.CSid = a.CSid
                    where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                    and RHDAmontores != 0.00
                    and cs.CSusatabla <> 1
                    and a.CSid not in(select CSid from #ComponentesS#)
                </cfquery>
                
                <cfquery datasource="#session.DSN#">
                	update #ComponentesS#
                    set DLTmonto = (select RHDAmontores
                                    from RHDAcciones a
    	                            inner join ComponentesSalariales cs
				                        on cs.CSid = a.CSid
                                    where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                    and RHDAmontores != 0.00
                                    and cs.CSusatabla <> 1
                                    and a.CSid = #ComponentesS#.CSid),
                    	DLTunidades= (select RHDAunidad
                                    from RHDAcciones a
    	                            inner join ComponentesSalariales cs
				                        on cs.CSid = a.CSid
                                    where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                    and RHDAmontores != 0.00
                                    and cs.CSusatabla <> 1
                                    and a.CSid = #ComponentesS#.CSid),
                        CIid= (select CIid
                                    from RHDAcciones a
	                                inner join ComponentesSalariales cs
			                        on cs.CSid = a.CSid
                                    where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                    and RHDAmontores != 0.00
                                    and cs.CSusatabla <> 1
                                    and a.CSid = #ComponentesS#.CSid),
                        DLTmetodoC= (select RHDAmetodoC
                                    from RHDAcciones a
	                                inner join ComponentesSalariales cs
			                        on cs.CSid = a.CSid
                                    where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                    and RHDAmontores != 0.00
                                    and cs.CSusatabla <> 1
                                    and a.CSid = #ComponentesS#.CSid)
                    where exists (select 1 
                    			from RHDAcciones a 
                                inner join ComponentesSalariales cs
			                        on cs.CSid = a.CSid
                                where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                and RHDAmontores != 0.00
                                and cs.CSusatabla <> 1
                                and a.CSid = #ComponentesS#.CSid)
                </cfquery>
 				<!--- Borra Detalles --->
                <cfquery datasource="#Arguments.conexion#">
                    delete from DLineaTiempoR
                    where exists (
                        select 1
                        from LineaTiempoR a
                        where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                        and a.LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
                        and a.LThasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
                        and a.LTRid = DLineaTiempo.LTRid
                    )
                </cfquery>
        
                <!--- Borra la Linea --->
                <cfquery datasource="#Arguments.conexion#">
                    delete from LineaTiempoR
                    where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                    and LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
                    and LThasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
                </cfquery>
    
    
                
                <!--- Inserto la Accion en la Linea de Tiempo --->
                <cfquery name="insLineaTiempo3" datasource="#Arguments.conexion#">
                    insert into LineaTiempo R(DEid, Ecodigo, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTdesde, LThasta, LTporcplaza, LTsalario, LTporcsal, RHJid, CPid, IEid, TEid, RHCPlinea, RHTtiponomb,RHPcodigoAlt,RHCPlineaP)
                    select a.DEid, a.Ecodigo, a.Tcodigo, a.RHTid, a.Ocodigo, a.Dcodigo, a.RHPid, a.RHPcodigo, a.RVid, a.DLfvigencia, 
                           coalesce(a.DLffin, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">), 
                           a.RHAporc, a.DLsalario, a.RHAporcsal, a.RHJid, 
                           <cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#" null="#Not Isdefined('RCNid') Or (Isdefined('RCNid') and RCNid EQ 0)#">, 
                           a.IEid, a.TEid, a.RHCPlinea, 
                           b.RHTtiponomb,RHPcodigoAlt,RHCPlineaP
    
                    from RHAcciones a
                        inner join RHTipoAccion b
                            on a.RHTid = b.RHTid
            
                    where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                    <cf_dbidentity1 datasource="#Arguments.conexion#" verificar_transaccion="no">
                </cfquery>
                <cf_dbidentity2 datasource="#Arguments.conexion#" name="insLineaTiempo3" verificar_transaccion="no" returnvariable="LvarLTid">
    
                <cfquery datasource="#Arguments.conexion#">
                    insert into DLineaTiempoR (LTRid, CSid, DLTmonto, DLTunidades,  CIid, DLTmetodoC)
                    select <cfqueryparam cfsqltype="cf_sql_numeric" value="#insLineaTiempo3.identity#">, 
                           a.CSid, a.DLTmonto, a.DLTunidades,  cs.CIid, a.DLTmetodoC
                    from #ComponentesS# a
                        inner join ComponentesSalariales cs
                        on cs.CSid = a.CSid
                    where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                    and DLTmonto != 0.00
                </cfquery>
            <cfelse>
				<!--- Borra Detalles --->
                <cfquery name="updDLineaTiempoR" datasource="#Arguments.conexion#">
                    delete from DLineaTiempoR
                    where exists (
                        select 1
                        from LineaTiempoR a
                        where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                        and a.LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
                        and a.LThasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
                        and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Plaza#">
                        and a.LTRid = DLineaTiempoR.LTRid
                    )
                </cfquery>
        
                <!--- Borra la Linea --->
                <cfquery name="delLTiempo" datasource="#Arguments.conexion#">
                    delete from LineaTiempoR
                    where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                    and LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
                    and LThasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
                    and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Plaza#">
                </cfquery>
    
    
                
                <!--- Inserto la Accion en la Linea de Tiempo --->
                <cfquery name="insLineaTiempoR3" datasource="#Arguments.conexion#">
                    insert into LineaTiempoR(DEid, Ecodigo, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTdesde, LThasta, LTporcplaza, LTsalario, LTporcsal, RHJid, CPid, IEid, TEid, RHCPlinea, RHTtiponomb,RHPcodigoAlt,RHCPlineaP)
                    select a.DEid, a.Ecodigo, a.Tcodigo, a.RHTid, a.Ocodigo, a.Dcodigo, a.RHPid, a.RHPcodigo, a.RVid, a.DLfvigencia, 
                           coalesce(a.DLffin, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">), 
                           a.RHAporc, a.DLsalario, a.RHAporcsal, a.RHJid, 
                           <cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#" null="#Not Isdefined('RCNid') Or (Isdefined('RCNid') and RCNid EQ 0)#">, 
                           a.IEid, a.TEid, a.RHCPlinea, 
                           b.RHTtiponomb,RHPcodigoAlt,RHCPlineaP
    
                    from RHAcciones a
                        inner join RHTipoAccion b
                            on a.RHTid = b.RHTid
            
                    where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                    <cf_dbidentity1 datasource="#Arguments.conexion#" verificar_transaccion="no">
                </cfquery>
                <cf_dbidentity2 datasource="#Arguments.conexion#" name="insLineaTiempoR3" verificar_transaccion="no" returnvariable="LvarLTRid">
    
                <cfquery datasource="#Arguments.conexion#">
                    insert into DLineaTiempoR (LTRid, CSid, DLTmonto, DLTunidades, DLTtabla, CIid, DLTmetodoC)
                    select <cfqueryparam cfsqltype="cf_sql_numeric" value="#insLineaTiempoR3.identity#">, 
                           a.CSid, a.RHDAmontores, a.RHDAunidad, a.RHDAtabla, cs.CIid, a.RHDAmetodoC
                    from RHDAcciones a
                        inner join ComponentesSalariales cs
                        on cs.CSid = a.CSid
                    where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                    and RHDAmontores != 0.00
                </cfquery>
    
            </cfif>
			<cfquery datasource="#session.DSN#">
                update LineaTiempoR
                set LTsalario = coalesce((select sum(DLTmonto)
                                from LineaTiempoR a
                                inner join DLineaTiempoR b
                                    on b.LTRid = a.LTRid
                                inner join DatosEmpleado c
                                    on c.DEid = a.DEid
                                where a.LTRid = LineaTiempoR.LTRid
                                group by a.LTRid),0)
				where LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insLineaTiempoR3.identity#">
			</cfquery>

		<cfelse>  <!--- Se van a respetar los cortes de la linea del tiempo --->
        	<!--- SI APLICA LOS CAMBIOS SOLAMENTE A LOS COMPONENTES DE LA ACCIÓN Y MANTIENE LOS OTROS. --->
            <cfif dataTipoAccion.RHTipoAplicacion EQ 1>
				<!--- TABLA TEMPORAL PARA MANEJO DE COMPONENTES
                APLICA SOLO PARA EL CASO EN QUE SE MODIFICA UN SOLO COMPONENTE --->
                <cf_dbtemp name="ComponentesS" returnvariable="ComponentesS" datasource="#Arguments.conexion#">
                	<cf_dbtempcol name="RHAlinea" 	 type="numeric"  mandatory="yes"> 
                    <cf_dbtempcol name="LTRid" 		 type="numeric"  mandatory="yes"> 
                    <cf_dbtempcol name="CSid" 		 type="numeric" mandatory="yes">
                    <cf_dbtempcol name="DLTmonto" 	 type="money"   mandatory="yes">
                    <cf_dbtempcol name="DLTunidades" type="float"   mandatory="yes">
                    <cf_dbtempcol name="CIid" 		 type="numeric" mandatory="no">
                    <cf_dbtempcol name="DLTmetodoC"  type="char"    mandatory="no">
                </cf_dbtemp>
                
                
                <!--- INSERTAR LOS COMPONENTES ASOCIADOS EN LA LINEA DE TIEMPO EN LA FECHA DE LA ACCION --->
                <cfquery datasource="#session.DSN#">
                	insert into #ComponentesS#(RHAlinea,LTRid,CSid,DLTmonto,DLTunidades,b.CIid,DLTmetodoC)
                    select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">,
                    	a.LTRid, b.CSid,DLTmonto,DLTunidades,b.CIid,DLTmetodoC
                    from LineaTiempoR a
                    inner join DLineaTiempoR b
                        on b.LTRid = a.LTRid
                    inner join ComponentesSalariales c
                        on c.CSid = b.CSid
                    where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                      and a.LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
                      and a.LThasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
                </cfquery>
                
                <cfquery  datasource="#session.DSN#">
                	insert into #ComponentesS#(RHAlinea,LTRid,CSid,DLTmonto,DLTunidades,b.CIid,DLTmetodoC)
                    select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">,
                    	0, cs.CSid,a.RHDAmontores, a.RHDAunidad,cs.CIid,a.RHDAmetodoC
                    from RHDAcciones a
                        inner join ComponentesSalariales cs
                        on cs.CSid = a.CSid
                    where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                    and RHDAmontores != 0.00
                    and cs.CSusatabla <> 1
                    and a.CSid not in(select CSid from #ComponentesS#)
                </cfquery>
                
                <cfquery datasource="#session.DSN#">
                	update #ComponentesS#
                    set DLTmonto = (select RHDAmontores
                                    from RHDAcciones a
    	                            inner join ComponentesSalariales cs
				                        on cs.CSid = a.CSid
                                    where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                    and RHDAmontores != 0.00
                                    and cs.CSusatabla <> 1
                                    and a.CSid = #ComponentesS#.CSid),
                    	DLTunidades= (select RHDAunidad
                                    from RHDAcciones a
    	                            inner join ComponentesSalariales cs
				                        on cs.CSid = a.CSid
                                    where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                    and RHDAmontores != 0.00
                                    and cs.CSusatabla <> 1
                                    and a.CSid = #ComponentesS#.CSid),
                        CIid= (select CIid
                                    from RHDAcciones a
	                                inner join ComponentesSalariales cs
			                        on cs.CSid = a.CSid
                                    where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                    and RHDAmontores != 0.00
                                    and cs.CSusatabla <> 1
                                    and a.CSid = #ComponentesS#.CSid),
                        DLTmetodoC= (select RHDAmetodoC
                                    from RHDAcciones a
	                                inner join ComponentesSalariales cs
			                        on cs.CSid = a.CSid
                                    where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                    and RHDAmontores != 0.00
                                    and cs.CSusatabla <> 1
                                    and a.CSid = #ComponentesS#.CSid)
                    where exists (select 1 
                    			from RHDAcciones a 
                                inner join ComponentesSalariales cs
			                        on cs.CSid = a.CSid
                                where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                and RHDAmontores != 0.00
                                and cs.CSusatabla <> 1
                                and a.CSid = #ComponentesS#.CSid)
                </cfquery>
				<!--- Buscar el siguiente corte para la acción a insertar --->
                <cfquery name="rsProxCorte" datasource="#Arguments.conexion#">
                    select min(LTdesde) as proxCorte
                    from LineaTiempoR 
                    where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                    and LTdesde between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
                </cfquery>
                <!--- Si hay un proximo corte poner el nuevo LThasta del corte a insertar como (proxCorte - 1) --->
                <cfif Len(Trim(rsProxCorte.proxCorte))>
                    <cfset nuevoLThasta = DateAdd('d', -1, rsProxCorte.proxCorte)>
                <cfelse>
                    <cfset nuevoLThasta = Fhasta>
                </cfif>
                
                <!--- Inserto la Accion en la Linea de Tiempo en corte que hace falta --->
                <cfquery name="insLineaTiempo3" datasource="#Arguments.conexion#">
                    insert into LineaTiempoR(DEid, Ecodigo, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTdesde, LThasta, LTporcplaza, LTsalario, LTporcsal, RHJid, CPid, IEid, TEid, RHCPlinea, RHTtiponomb,RHPcodigoAlt,RHCPlineaP)
                    select a.DEid, a.Ecodigo, a.Tcodigo, a.RHTid, a.Ocodigo, a.Dcodigo, a.RHPid, a.RHPcodigo, a.RVid, a.DLfvigencia, 
                           <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nuevoLThasta#">, 
                           a.RHAporc, a.DLsalario, a.RHAporcsal, a.RHJid, 
                           <cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#" null="#Not Isdefined('RCNid') Or (Isdefined('RCNid') and RCNid EQ 0)#">, 
                           a.IEid, a.TEid, a.RHCPlinea,
                           b.RHTtiponomb,RHPcodigoAlt,RHCPlineaP
                           
                    from RHAcciones a
                        inner join RHTipoAccion b
                            on a.RHTid = b.RHTid
            
                    where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                    <cf_dbidentity1 datasource="#Arguments.conexion#" verificar_transaccion="no">
                </cfquery>
                <cf_dbidentity2 datasource="#Arguments.conexion#" name="insLineaTiempo3" verificar_transaccion="no">
            
                <cfquery datasource="#Arguments.conexion#">
                    insert into DLineaTiempoR (LTRid, CSid, DLTmonto, DLTunidades, DLTtabla, CIid,DLTmetodoC)
                    select <cfqueryparam cfsqltype="cf_sql_numeric" value="#insLineaTiempo3.identity#">, 
                           a.CSid, a.DLTmonto, a.DLTunidades, 0, cs.CIid, a.DLTmetodoC
                    from #ComponentesS# a
                        inner join ComponentesSalariales cs
                        on cs.CSid = a.CSid
                    where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                    and DLTmonto != 0.00
                </cfquery>
			<cfelse>        
			<!--- APLICA EL CAMBIO A TODOS LOS COMPONENTES --->
				<!--- Buscar el siguiente corte para la acción a insertar --->
                <cfquery name="rsProxCorte" datasource="#Arguments.conexion#">
                    select min(LTdesde) as proxCorte
                    from LineaTiempoR 
                    where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                      and LTdesde between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
                      and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Plaza#">
                </cfquery>
                <!--- Si hay un proximo corte poner el nuevo LThasta del corte a insertar como (proxCorte - 1) --->
                <cfif Len(Trim(rsProxCorte.proxCorte))>
                    <cfset nuevoLThasta = DateAdd('d', -1, rsProxCorte.proxCorte)>
                <cfelse>
                    <cfset nuevoLThasta = Fhasta>
                </cfif>
                
                <!--- Inserto la Accion en la Linea de Tiempo en corte que hace falta --->
                <cfquery name="insLineaTiempoR3" datasource="#Arguments.conexion#">
                    insert into LineaTiempoR(DEid, Ecodigo, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTdesde, LThasta, LTporcplaza, LTsalario, LTporcsal, RHJid, CPid, IEid, TEid, RHCPlinea, RHTtiponomb,RHPcodigoAlt,RHCPlineaP)
                    select a.DEid, a.Ecodigo, a.Tcodigo, a.RHTid, a.Ocodigo, a.Dcodigo, a.RHPid, a.RHPcodigo, a.RVid, a.DLfvigencia, 
                           <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nuevoLThasta#">, 
                           a.RHAporc, a.DLsalario, a.RHAporcsal, a.RHJid, 
                           <cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#" null="#Not Isdefined('RCNid') Or (Isdefined('RCNid') and RCNid EQ 0)#">, 
                           a.IEid, a.TEid, a.RHCPlinea,
                           b.RHTtiponomb,RHPcodigoAlt,RHCPlineaP
                           
                    from RHAcciones a
                        inner join RHTipoAccion b
                            on a.RHTid = b.RHTid
            
                    where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                    <cf_dbidentity1 datasource="#Arguments.conexion#" verificar_transaccion="no">
                </cfquery>
                <cf_dbidentity2 datasource="#Arguments.conexion#" name="insLineaTiempoR3" verificar_transaccion="no">
        
                <cfquery datasource="#Arguments.conexion#">
                    insert into DLineaTiempoR (LTRid, CSid, DLTmonto, DLTunidades, DLTtabla, CIid,DLTmetodoC)
                    select <cfqueryparam cfsqltype="cf_sql_numeric" value="#insLineaTiempoR3.identity#">, 
                           a.CSid, a.RHDAmontores, a.RHDAunidad, a.RHDAtabla, cs.CIid, a.RHDAmetodoC
                    from RHDAcciones a
                        inner join ComponentesSalariales cs
                        on cs.CSid = a.CSid
                    where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                    and RHDAmontores != 0.00
                </cfquery>
        
                <!--- Se procede a actualizar el salario y todos los componentes en los cortes de la linea del tiempo 
                      que se encuentran dentro del rango de fechas de la accion 
                      ---- OJO ----
                      Los componentes no se recalculan, se toman tal como estan en la accion y se actualizan en todos los cortes
                      de la linea del tiempo que cubre la accion de personal. Se asume que vienen ya calculados correctamente 
                      desde la accion y no deberia haber incongruencias
                --->
                <cfquery datasource="#Arguments.conexion#">
                    update DLineaTiempoR 
                    set DLTunidades = (	select b.RHDAunidad
                                        from RHAcciones a, RHDAcciones b, LineaTiempoR c
                                        where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                            and b.RHAlinea = a.RHAlinea
                                            and c.DEid = a.DEid
                                            and c.LTdesde between a.DLfvigencia and a.DLffin
                                            and DLineaTiempoR.LTRid = c.LTRid
                                            and DLineaTiempoR.CSid = b.CSid ),
                                            
                        DLTmonto = ( 	select b.RHDAmontores
                                        from RHAcciones a, RHDAcciones b, LineaTiempoR c
                                        where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                            and b.RHAlinea = a.RHAlinea
                                            and c.DEid = a.DEid
                                            and c.LTdesde between a.DLfvigencia and a.DLffin
                                            and DLineaTiempoR.LTRid = c.LTRid
                                            and DLineaTiempoR.CSid = b.CSid ),
                                            
                        DLTmetodoC = ( 	select b.RHDAmetodoC
                                        from RHAcciones a, RHDAcciones b, LineaTiempoR c
                                        where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                            and b.RHAlinea = a.RHAlinea
                                            and c.DEid = a.DEid
                                            and c.LTdesde between a.DLfvigencia and a.DLffin
                                            and DLineaTiempoR.LTRid = c.LTRid
                                            and DLineaTiempoR.CSid = b.CSid )
                                            
                    where exists (	select 1 
                                    from RHAcciones a, RHDAcciones b, LineaTiempoR c
                                    where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                        and b.RHAlinea = a.RHAlinea
                                        and c.DEid = a.DEid
                                        and c.LTdesde between a.DLfvigencia and a.DLffin
                                        and DLineaTiempoR.LTRid = c.LTRid
                                        and DLineaTiempoR.CSid = b.CSid )
                </cfquery>
			</cfif>
			<cfquery name="delCortes" datasource="#Arguments.conexion#">
				delete from DLineaTiempoR
				where exists (
					select 1
					from RHAcciones a, LineaTiempoR c
					where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
					and c.DEid = a.DEid
					and c.LTdesde between a.DLfvigencia and a.DLffin
                    and c.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Plaza#">
					and DLineaTiempoR.LTRid = c.LTRid
					and not exists (
						select 1
						from RHDAcciones b
						where b.RHAlinea = a.RHAlinea
						and b.CSid = DLineaTiempoR.CSid
					)
				)
			</cfquery>

			<cfquery datasource="#Arguments.conexion#">
				update LineaTiempoR 
				set LTsalario = ( 	select coalesce((	select sum(DLTmonto)
													from DLineaTiempoR z
													where z.LTRid = LineaTiempoR.LTRid ), 0)
									from RHAcciones a
									where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
										and LineaTiempoR.DEid = a.DEid
										and LineaTiempoR.LTdesde between a.DLfvigencia and a.DLffin
                                        and LineaTiempoR.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Plaza#"> ),
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				where exists (	select 1 
								from RHAcciones a
								where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
									and LineaTiempoR.DEid = a.DEid
									and LineaTiempoR.LTdesde between a.DLfvigencia and a.DLffin
                                    and LineaTiempoR.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Plaza#"> )
			</cfquery>
		</cfif>


    	<!--- borrar el registro infinito cuando se genera otro corte infinito --->
		<cfquery name="chkLTiempo" datasource="#Arguments.conexion#">
    		select 1 
    		from LineaTiempoR a
    		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
			and a.LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">
			and a.LTRid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
		</cfquery>
		<cfif DateCompare(fechatrab2, CreateDate(6100, 01, 01)) EQ 0 and chkLTiempo.recordCount>
			<cfquery name="chkLTiempo2" datasource="#Arguments.conexion#">
				select 1
				from LineaTiempoR
				where LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
				and LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">
			</cfquery>
			<cfif chkLTiempo2.recordCount>
				<cfquery name="delDLineaTiempoR" datasource="#Arguments.conexion#">
                    delete from DLineaTiempoR
                    where LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
				</cfquery>
				<cfquery name="delLineaTiempoR" datasource="#Arguments.conexion#">
                    delete from LineaTiempoR
                    where LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
				</cfquery>
			</cfif>
		</cfif>

		<cfif Arguments.debug>
			<cfquery name="rsLTDespues" datasource="#Arguments.conexion#">
				select * 
                from LineaTiempoR 
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				order by LTdesde
			</cfquery>
			<cfdump var="#rsLTDespues#" label="LineaTiempoR Final">
		</cfif>

		<cfreturn true>
	</cffunction>
</cfcomponent>
