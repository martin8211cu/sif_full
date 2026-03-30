
<cfcomponent>
	<cffunction name="ConstruyeLT" access="public" output="true" returntype="boolean">
		<cfargument name="Ecodigo" type="numeric" required="yes">
		<cfargument name="RHAlinea" type="numeric" required="yes">		<!--- Accion en Proceso --->
		<cfargument name="DEid" type="numeric" required="yes">			<!--- Empleado --->
		<cfargument name="RHTcomportam" type="numeric" required="yes">	<!--- Comportamiento de la Accion --->
		<cfargument name="respetarLT" type="boolean" required="no" default="false">		<!--- Indica si quiere respetar los cortes en la Linea del Tiempo / Utilizado unicamente para actualizar LTsalario y los componentes de la linea del tiempo --->
        <cfargument name="DLlinea" type="numeric" required="no" default="0">   <!--- ID de DatosLaboralesEmpleado  --->
		<cfargument name="Usucodigo" type="string" required="no" default="#Session.Usucodigo#">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#">
		<cfargument name="debug" type="boolean" required="no" default="false">

<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="MSG_Error_La_accion_de_personal_no_existe" default="Error! La acción de personal no existe"	 returnvariable="MSG_AccionNoExiste" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_El_empleado_no_tiene_un_corte_en_la_Linea_del_Tiempo_Vigente" default="Error! El empleado no tiene un corte en la Línea del Tiempo Vigente. Por favor verifique las fechas Desde y Hasta de La Acción."	 returnvariable="MSG_EmpleadoNoTieneCortes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_la_empresa_destino_no_tiene_definida_una_accion_de_cambio_de_empresa_con_el_mismo_codigo_de_la_empresa_origen" default="Error! la empresa destino no tiene definida una acci&oacute;n de cambio de empresa con el mismo c&oacute;digo de la empresa origen "	 returnvariable="MSG_errorcambioempresa" component="sif.Componentes.Translate" method="Translate"/>
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
                    coalesce(b.RHTipoAplicacion,0) as RHTipoAplicacion
			from RHTipoAccion a, RHAcciones b
			where a.RHTid = b.RHTid
			and b.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
		</cfquery>
		<cfif dataTipoAccion.recordCount EQ 0>
			<cfthrow message="#MSG_AccionNoExiste#">
			<cfabort>
		</cfif>

		<!--- Averiguar si hay Usa Estructura salarial --->
        <cfquery name="rsTipoTabla" datasource="#Session.DSN#">
            select CSusatabla
            from ComponentesSalariales
            <!--- Cambio de Empresa --->
            <cfif dataTipoAccion.RHTcomportam EQ 9 and dataTipoAccion.RHTcempresa EQ 1 and isdefined("dataTipoAccion.EcodigoRef") and Len(Trim(dataTipoAccion.EcodigoRef))>
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#dataTipoAccion.EcodigoRef#">
            <cfelse>
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            </cfif>
            and CSsalariobase = 1
        </cfquery>
        <cfif rsTipoTabla.recordCount GT 0>
            <cfset usaEstructuraSalarial = rsTipoTabla.CSusatabla>
        <cfelse>
            <cfset usaEstructuraSalarial = 0>
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
			<cfif DateCompare(FechaRCNid,Fdesde) GT 0 and Len(Trim(minifRCNid))
				and DateCompare(FechaRCNid, minifRCNid) GT 0 and dataTipoAccion.RHTnoretroactiva EQ 0>
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
				select *,#LvarComportamiento#  as  LvarComportamiento from LineaTiempo
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				order by LTdesde
			</cfquery>
			<cfdump var="#rsLTAntes#" label="LineaTiempo Antes">
		</cfif>

		<!--- PROCESO --->
		<!--- Si es NOMBRAMIENTO --->
		<cfif LvarComportamiento EQ 1>
			<cfquery name="insLineaTiempo" datasource="#Arguments.conexion#">
				insert into LineaTiempo (DEid, Ecodigo, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTdesde, LThasta, LTporcplaza, LTsalario, LTporcsal, RHJid, CPid, IEid, TEid, RHCPlinea, RHTtiponomb,RHPcodigoAlt,RHCPlineaP,LTsalarioSDI)
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">,
					   <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">,
					   <cfqueryparam cfsqltype="cf_sql_char" value="#TipoNomina#">,
					   a.RHTid, a.Ocodigo, a.Dcodigo, a.RHPid, a.RHPcodigo, a.RVid,
					   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">,
					   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">,
					   a.RHAporc, a.DLsalario, a.RHAporcsal, a.RHJid,
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#" null="#Not Isdefined('RCNid') Or (Isdefined('RCNid') and RCNid EQ 0)#">,
					   a.IEid, a.TEid, a.RHCPlinea,
					   b.RHTtiponomb,RHPcodigoAlt,RHCPlineaP,coalesce(a.DLsalarioSDI,0)

				from RHAcciones a
					inner join RHTipoAccion b
						on a.RHTid = b.RHTid

				where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
				<cf_dbidentity1 datasource="#Arguments.conexion#" verificar_transaccion="no" returnvariable="Lvar">
			</cfquery>
			<cf_dbidentity2 datasource="#Arguments.conexion#" name="insLineaTiempo" verificar_transaccion="no" returnvariable="Lvar">

			<cfquery datasource="#Arguments.conexion#">
				insert into DLineaTiempo (LTid, CSid, DLTmonto, DLTunidades, DLTtabla, CIid, DLTmetodoC)
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#insLineaTiempo.identity#">, a.CSid, a.RHDAmontores,
						a.RHDAunidad, a.RHDAtabla, cs.CIid,a.RHDAmetodoC
				from RHDAcciones a
					inner join ComponentesSalariales cs
					on cs.CSid = a.CSid
				where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
				and RHDAmontores != 0.00
			</cfquery>

			<cfif Arguments.debug>
				<cfquery name="rsLTDespues" datasource="#Arguments.conexion#">
					select * from LineaTiempo
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					order by LTdesde
				</cfquery>
				<cfdump var="#rsLTDespues#" label="LineaTiempo Final">
			</cfif>
			<cfquery datasource="#session.DSN#">
				update LineaTiempo
				set LTsalario = ( 	select coalesce(sum(DLTmonto),0)
									from DLineaTiempo
									where LTid = LineaTiempo.LTid  ),
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				where LTid = #Lvar#
			</cfquery>
			<cfreturn true>
		</cfif>

		<!--- Si es un CESE --->
		<cfif LvarComportamiento EQ 2>
			<!--- Buscar el segmento de la Linea del Tiempo donde cae la acción de cese --->
			<cfquery name="rsFechaTrabajo" datasource="#Arguments.conexion#">
				select min(LThasta) as fechatrab
				from LineaTiempo
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				and LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
				and LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
			</cfquery>
			<cfset FechaTrab = rsFechaTrabajo.fechatrab>

			<cfif Len(Trim(FechaTrab))>
				<!--- Buscar el código del segmento de la Linea del Tiempo donde cae la acción de cese --->
				<cfquery name="rsRango1" datasource="#Arguments.conexion#">
					select LTid
					from LineaTiempo
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					and LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaTrab#">
				</cfquery>
				<cfset Rango1 = rsRango1.LTid>

				<!--- Actualiza el segmento de la Linea del Tiempo donde cae la acción de cese con la fecha de la acción --->
				<cfquery datasource="#Arguments.conexion#">
					update LineaTiempo
						set LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Fdesde,'YYYY-MM-dd')#">,
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
            		where LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Rango1#">
				</cfquery>

				<!--- Marcar las relaciones de calculo activas como no calculadas --->
				<cfquery datasource="#Arguments.conexion#">
					update SalarioEmpleado
						set SEcalculado = 0
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					and exists (
						select 1
						from LineaTiempo lt, PagosEmpleado pe, RCalculoNomina rc
						where lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
						and lt.LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
						and pe.LTid = lt.LTid
						and rc.RCNid = pe.RCNid
						and rc.RCestado = 0
						and SalarioEmpleado.RCNid = rc.RCNid
					)
				</cfquery>

				<!--- Elimina todos los segmentos de la Linea de Tiempo posteriores a la fecha de la acción de cese --->
				<cfquery datasource="#Arguments.conexion#">
					delete from DLineaTiempo
					where exists (
						select 1
						from LineaTiempo a
						where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
						and a.LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
						and DLineaTiempo.LTid = a.LTid
					)
				</cfquery>
				<cfquery datasource="#Arguments.conexion#">
					delete from LineaTiempo
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					and LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
				</cfquery>

				<!--- RECARGOS --->
                <!--- Buscar el código del segmento de la Linea del Tiempo donde cae la acción de cese --->
                <cfquery name="rsRangoR1" datasource="#Arguments.conexion#">
                    select LTRid
                    from LineaTiempoR
                    where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                    and LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaTrab#">
                </cfquery>
                <cfset RangoR1 = ValueList(rsRangoR1.LTRid)>
                <cfif rsRangoR1.RecordCount>
					<!--- Actualiza el segmento de la Linea del Tiempo donde cae la acción de cese con la fecha de la acción --->
                    <cfquery datasource="#Arguments.conexion#">
                        update LineaTiempoR
                            set LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Fdesde,'YYYY-MM-dd')#">,
                            BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                        where LTRid in(<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#RangoR1#">)
                    </cfquery>
                    <!--- Elimina todos los segmentos de la Linea de Tiempo posteriores a la fecha de la acción de cese --->
                    <cfquery datasource="#Arguments.conexion#">
                        delete from DLineaTiempoR
                        where exists (
                            select 1
                            from LineaTiempoR a
                            where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                            and a.LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
                            and DLineaTiempo.LTRid = a.LTRid
                        )
                    </cfquery>
                    <cfquery datasource="#Arguments.conexion#">
                        delete from LineaTiempoR
                        where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                        and LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
                    </cfquery>
                 </cfif>
                 <!--- FIN DE RECARGOS --->

			</cfif>

			<cfif Arguments.debug>
				<cfquery name="rsLTDespues" datasource="#Arguments.conexion#">
					select * from LineaTiempo
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					order by LTdesde
				</cfquery>
				<cfdump var="#rsLTDespues#" label="LineaTiempo Final">
			</cfif>

			<cfreturn true>
		</cfif>

		<!--- Si es un CAMBIO DE EMPRESA --->
		<cfif LvarComportamiento EQ 9 and dataTipoAccion.RHTcempresa EQ 1>
			<!--- Buscar el segmento de la Linea del Tiempo donde cae la acción de cambio de empresa --->
			<cfquery name="rsFechaTrabajo" datasource="#Arguments.conexion#">
				select min(LThasta) as fechatrab
				from LineaTiempo
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				and LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
				and LTdesde < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
			</cfquery>
			<cfset FechaTrab = rsFechaTrabajo.fechatrab>

			<cfif Len(Trim(FechaTrab))>
				<!--- Buscar el código del segmento de la Linea del Tiempo donde cae la acción de cambio de empresa --->
				<cfquery name="rsRango1" datasource="#Arguments.conexion#">
					select LTid
					from LineaTiempo
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					and LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaTrab#">
				</cfquery>
				<cfset Rango1 = rsRango1.LTid>

				<!--- Actualiza el segmento de la Linea del Tiempo donde cae la acción de cambio de empresa con la fecha de la acción --->
				<cfquery datasource="#Arguments.conexion#">
					update LineaTiempo
						set LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',-1,Fdesde)#">,
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
            		where LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Rango1#">
				</cfquery>

				<!--- Marcar las relaciones de calculo activas como no calculadas --->
				<cfquery datasource="#Arguments.conexion#">
					update SalarioEmpleado
						set SEcalculado = 0
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					and exists (
						select 1
						from LineaTiempo lt, PagosEmpleado pe, RCalculoNomina rc
						where lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
						and lt.LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
						and pe.LTid = lt.LTid
						and rc.RCNid = pe.RCNid
						and rc.RCestado = 0
						and SalarioEmpleado.RCNid = rc.RCNid
					)
				</cfquery>

				<!--- Elimina todos los segmentos de la Linea de Tiempo posteriores a la fecha de la acción de cambio de empresa --->
				<cfquery datasource="#Arguments.conexion#">
					delete from DLineaTiempo
					where exists (
						select 1
						from LineaTiempo a
						where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
						and a.LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
						and DLineaTiempo.LTid = a.LTid
					)
				</cfquery>
				<cfquery datasource="#Arguments.conexion#">
					delete from LineaTiempo
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					and LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
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
						<cfquery name="ins_RHTipoAccionDEST" datasource="#Arguments.conexion#">
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
                <cfquery datasource="#Arguments.conexion#" name="insLineaTiempo">
					insert into LineaTiempo (DEid, Ecodigo, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTdesde, LThasta, LTporcplaza, LTsalario, LTporcsal, RHJid, CPid, IEid, TEid, RHCPlinea,RHPcodigoAlt, RHTtiponomb,RHCPlineaP)
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
				<cf_dbidentity2 datasource="#Arguments.conexion#" name="insLineaTiempo" verificar_transaccion="no">

				<cfquery datasource="#Arguments.conexion#">
					insert into DLineaTiempo (LTid, CSid, DLTmonto, DLTunidades, DLTtabla, CIid, DLTmetodoC)
					select <cfqueryparam cfsqltype="cf_sql_numeric" value="#insLineaTiempo.identity#">, a.CSid, a.RHDAmontores,
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
					select * from LineaTiempo
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					order by LTdesde
				</cfquery>
				<cfdump var="#rsLTDespues#" label="LineaTiempo Final">
			</cfif>

			<cfreturn true>
		</cfif>
        <cfif dataTipoAccion.RHTipoAplicacion EQ 0><!--- MODIFICA TODA LA LINEA DE TIEMPO, NO SOLAMENTE UN COMPONENTE SALARIAL --->
			<!--- Las demás Acciones --->
            <cfquery name="LT1" datasource="#Arguments.conexion#">
                select LTid as id1, LTdesde as fechatrab1
                from LineaTiempo
                where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#"> between LTdesde and LThasta
            </cfquery>
            <cfset id1 = LT1.id1>
            <cfset fechatrab1 = LT1.fechatrab1>
            <cfquery name="LT2" datasource="#Arguments.conexion#">
                select LTid as id2, LThasta as fechatrab2
                from LineaTiempo
                where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#"> between LTdesde and LThasta
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
                    select 1 from LineaTiempo a
                    where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                    and LTdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', 1, Fhasta)#">
                </cfquery>

                <cfif LTiempo.recordCount EQ 0>
                	<cfquery name="insLineaTiempo2" datasource="#Arguments.conexion#">
                        insert into LineaTiempo(DEid, Ecodigo, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTdesde, LThasta, LTporcplaza, LTsalario, LTporcsal, RHJid, CPid, IEid, TEid, RHCPlinea, RHTtiponomb,RHPcodigoAlt,RHCPlineaP, LTsalarioSDI)
                        select DEid,
                               Ecodigo,
                               Tcodigo,
                               RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid,
                               <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', 1, Fhasta)#">,
                               <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechatrab2#">,
                               LTporcplaza, LTsalario, LTporcsal, RHJid,
                               <cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#" null="#Not Isdefined('RCNid') Or (Isdefined('RCNid') and RCNid EQ 0)#">,
                               IEid, TEid, RHCPlinea, RHTtiponomb,RHPcodigoAlt,RHCPlineaP, coalesce(LTsalarioSDI,0)
                        from LineaTiempo
                        where LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
                        and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                        and LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechatrab2#">
                        <cf_dbidentity1 datasource="#Arguments.conexion#" verificar_transaccion="no">
                    </cfquery>
                    <cf_dbidentity2 datasource="#Arguments.conexion#" name="insLineaTiempo2" verificar_transaccion="no">


                        <cfquery datasource="#Arguments.conexion#">
                        insert into DLineaTiempo (LTid, CSid, DLTmonto, DLTunidades, DLTtabla, CIid, DLTmetodoC)
                        select <cfqueryparam cfsqltype="cf_sql_numeric" value="#insLineaTiempo2.identity#">,
                               b.CSid, b.DLTmonto, b.DLTunidades, b.DLTtabla, b.CIid, DLTmetodoC
                        from LineaTiempo a, DLineaTiempo b
                        where a.LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
                        and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                        and a.LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechatrab2#">
                        and a.LTid = b.LTid
                        and b.DLTmonto != 0.00
                    </cfquery>

                    <!--------------------------- Agregado por Yu Hui 30/11/2005 --------------------------->
                        <cfquery datasource="#Arguments.conexion#">
                        update LineaTiempo
                            set LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">,
                            BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                        where LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
                        and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                        and LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechatrab2#">
                    </cfquery>
                    <!-------------------------------------------------------------------------------------->
                </cfif>

            <!--- Actualizo el corte Posterior --->
            <cfelse>
                    <cfquery datasource="#Arguments.conexion#">
                    update LineaTiempo
                        set LTdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', 1, Fhasta)#">,
                            CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#" null="#Not Isdefined('RCNid') Or (Isdefined('RCNid') and RCNid EQ 0)#">,
                            BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                    where LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
                    and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                    and LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechatrab2#">
                    and not exists (
                        select 1 from LineaTiempo b
                        where b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                        and b.LTdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', 1, Fhasta)#">
                    )
                </cfquery>

            </cfif>

            <!--- Actualizo el Corte anterior --->
           	<cfquery datasource="#Arguments.conexion#">
                update LineaTiempo
                    set LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', -1, Fdesde)#">,
                        BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                where LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id1#">
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
                    from LineaTiempo lt, PagosEmpleado pe, RCalculoNomina rc
                    where lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                    and lt.LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
                    and lt.LThasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
                    and pe.LTid = lt.LTid
                    and rc.RCNid = pe.RCNid
                    and rc.RCestado = 0
                    and SalarioEmpleado.RCNid = rc.RCNid
                )
            </cfquery>


            <!--- Modificado por Yu Hui 30/11/2005
                Para permitir modificar la linea del tiempo respetando los cortes que ya existen
            --->


            <cfif not Arguments.respetarLT>
                <!--- Borra Detalles --->
            	<cfquery datasource="#Arguments.conexion#">
                    delete from DLineaTiempo
                    where exists (
                        select 1
                        from LineaTiempo a
                        where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                        and a.LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
                        and a.LThasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
                        and a.LTid = DLineaTiempo.LTid
                    )
                </cfquery>

                <!--- Borra la Linea --->
                    <cfquery datasource="#Arguments.conexion#">
                    delete from LineaTiempo
                    where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                    and LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
                    and LThasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
                </cfquery>



                <!--- Inserto la Accion en la Linea de Tiempo --->
                    <cfquery name="insLineaTiempo3" datasource="#Arguments.conexion#">
                        insert into LineaTiempo(DEid, Ecodigo, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTdesde, LThasta, LTporcplaza, LTsalario, LTporcsal, RHJid, CPid, IEid, TEid, RHCPlinea, RHTtiponomb,RHPcodigoAlt,RHCPlineaP,LTsalarioSDI)
                        select a.DEid, a.Ecodigo, a.Tcodigo, a.RHTid, a.Ocodigo, a.Dcodigo, a.RHPid, a.RHPcodigo, a.RVid, a.DLfvigencia,
                               coalesce(a.DLffin, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">),
                               a.RHAporc, a.DLsalario, a.RHAporcsal, a.RHJid,
                               <cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#" null="#Not Isdefined('RCNid') Or (Isdefined('RCNid') and RCNid EQ 0)#">,
                               a.IEid, a.TEid, a.RHCPlinea,
                               b.RHTtiponomb,RHPcodigoAlt,RHCPlineaP, coalesce(a.DLsalarioSDI,0)

                        from RHAcciones a
                            inner join RHTipoAccion b
                                on a.RHTid = b.RHTid

                        where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                        <cf_dbidentity1 datasource="#Arguments.conexion#" verificar_transaccion="no">
                    </cfquery>
                    <cf_dbidentity2 datasource="#Arguments.conexion#" name="insLineaTiempo3" verificar_transaccion="no" returnvariable="LvarLTid">

                    <cfquery datasource="#Arguments.conexion#">
                    insert into DLineaTiempo (LTid, CSid, DLTmonto, DLTunidades, DLTtabla, CIid, DLTmetodoC)
                    select <cfqueryparam cfsqltype="cf_sql_numeric" value="#insLineaTiempo3.identity#">,
                           a.CSid, a.RHDAmontores, a.RHDAunidad, a.RHDAtabla, cs.CIid, a.RHDAmetodoC
                    from RHDAcciones a
                        inner join ComponentesSalariales cs
                        on cs.CSid = a.CSid
                    where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                    and RHDAmontores != 0.00
                </cfquery>

                <!---Melissa Cambronero: para crear una consistencia entre las relaciones de aumento y realizadas por las acciones esto debido a que en la LineaTiempo el LTsalario corresponde a la suma del salario y todos sus componentes --->
                <cfquery datasource="#session.DSN#">
                    update LineaTiempo
                    set LTsalario = ( 	select sum(DLTmonto)
                                        from DLineaTiempo
                                        where LTid = LineaTiempo.LTid  ),
                            BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                    where LTid = #insLineaTiempo3.identity#
                </cfquery>

			<cfelse>  <!--- Se van a respetar los cortes de la linea del tiempo --->

				<!--- Buscar el siguiente corte para la acción a insertar --->
                <cfquery name="rsProxCorte" datasource="#Arguments.conexion#">
                    select min(LTdesde) as proxCorte
                    from LineaTiempo
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
                <cfquery datasource="#Arguments.conexion#"  name="insLineaTiempo3">
                    insert into LineaTiempo(DEid, Ecodigo, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTdesde, LThasta, LTporcplaza, LTsalario, LTporcsal, RHJid, CPid, IEid, TEid, RHCPlinea, RHTtiponomb,RHPcodigoAlt,RHCPlineaP, LTsalarioSDI)
                    select a.DEid, a.Ecodigo, a.Tcodigo, a.RHTid, a.Ocodigo, a.Dcodigo, a.RHPid, a.RHPcodigo, a.RVid, a.DLfvigencia,
                           <cfqueryparam cfsqltype="cf_sql_timestamp" value="#nuevoLThasta#">,
                           a.RHAporc, a.DLsalario, a.RHAporcsal, a.RHJid,
                           <cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#" null="#Not Isdefined('RCNid') Or (Isdefined('RCNid') and RCNid EQ 0)#">,
                           a.IEid, a.TEid, a.RHCPlinea,
                           b.RHTtiponomb,RHPcodigoAlt,RHCPlineaP, coalesce(a.DLsalarioSDI,0)

                    from RHAcciones a
                        inner join RHTipoAccion b
                            on a.RHTid = b.RHTid

                    where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                    <cf_dbidentity1 datasource="#Arguments.conexion#" verificar_transaccion="no">
                </cfquery>
                <cf_dbidentity2 datasource="#Arguments.conexion#" name="insLineaTiempo3" verificar_transaccion="no">

                <cfquery datasource="#Arguments.conexion#">
                    insert into DLineaTiempo (LTid, CSid, DLTmonto, DLTunidades, DLTtabla, CIid,DLTmetodoC)
                    select <cfqueryparam cfsqltype="cf_sql_numeric" value="#insLineaTiempo3.identity#">,
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
                    update DLineaTiempo
                    set DLTunidades = (	select b.RHDAunidad
                                        from RHAcciones a, RHDAcciones b, LineaTiempo c
                                        where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                            and b.RHAlinea = a.RHAlinea
                                            and c.DEid = a.DEid
                                            and c.LTdesde between a.DLfvigencia and a.DLffin
                                            and DLineaTiempo.LTid = c.LTid
                                            and DLineaTiempo.CSid = b.CSid ),

                        DLTmonto = ( 	select b.RHDAmontores
                                        from RHAcciones a, RHDAcciones b, LineaTiempo c
                                        where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                            and b.RHAlinea = a.RHAlinea
                                            and c.DEid = a.DEid
                                            and c.LTdesde between a.DLfvigencia and a.DLffin
                                            and DLineaTiempo.LTid = c.LTid
                                            and DLineaTiempo.CSid = b.CSid ),

                        DLTmetodoC = ( 	select b.RHDAmetodoC
                                        from RHAcciones a, RHDAcciones b, LineaTiempo c
                                        where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                            and b.RHAlinea = a.RHAlinea
                                            and c.DEid = a.DEid
                                            and c.LTdesde between a.DLfvigencia and a.DLffin
                                            and DLineaTiempo.LTid = c.LTid
                                            and DLineaTiempo.CSid = b.CSid )

                    where exists (	select 1
                                    from RHAcciones a, RHDAcciones b, LineaTiempo c
                                    where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                        and b.RHAlinea = a.RHAlinea
                                        and c.DEid = a.DEid
                                        and c.LTdesde between a.DLfvigencia and a.DLffin
                                        and DLineaTiempo.LTid = c.LTid
                                        and DLineaTiempo.CSid = b.CSid )
                </cfquery>
                <!---Se realiza un eliminado de los detalles de la línea del tiempo, eliminando los componentes salariales, que ya no forman parte del detalle de la línea del tiempo.--->
                    <cfquery datasource="#Arguments.conexion#">
                    delete from DLineaTiempo
                    where exists (
                        select 1
                        from RHAcciones a, LineaTiempo c
                        where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                        and c.DEid = a.DEid
                        and c.LTdesde between a.DLfvigencia and a.DLffin
                        and DLineaTiempo.LTid = c.LTid
                        and not exists (
                            select 1
                            from RHDAcciones b
                            where b.RHAlinea = a.RHAlinea
                            and b.CSid = DLineaTiempo.CSid
                        )
                    )
                </cfquery>
                <!---Actualiza LTsalario realizando la suma de DLTmonto del detalle de la línea del tiempo, en caso de que se hayan borrado algunos detalles de la línea del tiempo…--->
                    <cfquery datasource="#Arguments.conexion#">
                    update LineaTiempo
                    set LTsalario = ( 	select coalesce((	select sum(DLTmonto)
                                                        from DLineaTiempo z
                                                        where z.LTid = LineaTiempo.LTid ), 0)
                                        from RHAcciones a
                                        where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                            and LineaTiempo.DEid = a.DEid
                                            and LineaTiempo.LTdesde between a.DLfvigencia and a.DLffin ),
                            BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                    where exists (	select 1
                                    from RHAcciones a
                                    where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                        and LineaTiempo.DEid = a.DEid
                                        and LineaTiempo.LTdesde between a.DLfvigencia and a.DLffin )
                </cfquery>
            </cfif>
            <!--- borrar el registro infinito cuando se genera otro corte infinito --->
            <cfquery name="chkLTiempo" datasource="#Arguments.conexion#">
                select 1
                from LineaTiempo a
                where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                and a.LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">
                and a.LTid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
            </cfquery>
            <cfif DateCompare(fechatrab2, CreateDate(6100, 01, 01)) EQ 0 and chkLTiempo.recordCount>
                <cfquery name="chkLTiempo2" datasource="#Arguments.conexion#">
                    select 1
                    from LineaTiempo
                    where LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
                    and LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">
                </cfquery>
                <cfif chkLTiempo2.recordCount>
                    <cfquery name="delDLineaTiempo" datasource="#Arguments.conexion#">
                        delete from DLineaTiempo
                        where LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
                    </cfquery>
                    <cfquery datasource="#Arguments.conexion#">
                        delete from LineaTiempo
                        where LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
                    </cfquery>
                </cfif>
            </cfif>


		<cfelse><!--- MODIFICA SOLAMENTE UN COMPONENTE SALARIAL EN LA LINEA DE TIEMPO--->
			<!--- Recontruccion de la linea tiempo un componente<br> --->
 	 		<!--- RECONTRUIR LA LINEA DE TIEMPO, HACE CORTES SI ES NECESARIO --->
			<!--- si ha un corte donde la fecha desde es menor a la fecha desde de la acción se hace el corte nuevo con la fecha desde de la accion --->
            <cfquery name="LT1" datasource="#Arguments.conexion#">
                select LTid as id1, LTdesde as fechatrab1, LThasta as fechatrabh1
                from LineaTiempo
                where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#"> between LTdesde and LThasta
            </cfquery>
            <cfset id1 = LT1.id1>
            <cfset fechatrab1 = LT1.fechatrab1>
            <cfset fechatrabH1 = LT1.fechatrabh1>
            <cfif isdefined('id1') and id1 GT 0 and DateCompare(fechatrab1, Fdesde) EQ -1>
                <!--- SE HACE CORTE DE LA LINEA DE TIEMPO Y NUEVO CORTE --->
                <cfquery datasource="#session.DSN#">
                    update LineaTiempo
                    set LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', -1, Fdesde)#">
                    where LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id1#">
                </cfquery>
                <!--- NUEVO CORTE --->
                <cfquery name="insLineaTiempo1" datasource="#Arguments.conexion#">
                    insert into LineaTiempo(DEid, Ecodigo, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTdesde, LThasta, LTporcplaza, LTsalario,
                    						LTporcsal, RHJid, CPid, IEid, TEid, RHCPlinea, RHTtiponomb,RHPcodigoAlt,RHCPlineaP, LTsalarioSDI)
                            select DEid,
                                   Ecodigo,
                                   Tcodigo,
                                   RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid,
                                   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">,
                                   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechatrabH1#">,
                                   LTporcplaza, LTsalario, LTporcsal, RHJid,
                                   <cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#" null="#Not Isdefined('RCNid') Or (Isdefined('RCNid') and RCNid EQ 0)#">,
                                   IEid, TEid, RHCPlinea, RHTtiponomb,RHPcodigoAlt,RHCPlineaP,LTsalarioSDI
                            from LineaTiempo
                            where LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id1#">
                            and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                    <cf_dbidentity1 datasource="#Arguments.conexion#" verificar_transaccion="no">
                </cfquery>
                <cf_dbidentity2 datasource="#Arguments.conexion#" name="insLineaTiempo1" verificar_transaccion="no">

                <cfquery datasource="#Arguments.conexion#">
                    insert into DLineaTiempo (LTid, CSid, DLTmonto, DLTunidades, DLTtabla, CIid, DLTmetodoC)
                    select <cfqueryparam cfsqltype="cf_sql_numeric" value="#insLineaTiempo1.identity#">,
                           b.CSid, b.DLTmonto, b.DLTunidades, b.DLTtabla, b.CIid, DLTmetodoC
                    from LineaTiempo a, DLineaTiempo b
                    where a.LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id1#">
                    and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                    and a.LTid = b.LTid
                    and b.DLTmonto != 0.00
                </cfquery>
            </cfif>

            <cfquery name="LT2" datasource="#Arguments.conexion#">
                select LTid as id2, LThasta as fechatrab2
                from LineaTiempo
                where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#"> between LTdesde and LThasta
            </cfquery>
            <cfset id2 = LT2.id2>
            <cfset fechatrab2 = LT2.fechatrab2>
            <!--- si hay un corte donde la fecha hasta es mayor a la fecha hasta de la acción se hace el corte nuevo
                    con fecha desde = hasta accion +1
                      y fecha hasta = fecha hasta del corte --->
			<cfif isdefined('id2') and id2 GT 0 and DateCompare(fechatrab2,Fhasta) EQ 1>
                <!--- SE HACE CORTE DE LA LINEA DE TIEMPO Y NUEVO CORTE --->
                <cfquery datasource="#session.DSN#">
                    update LineaTiempo
                    set LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
                    where LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
                </cfquery>
                <!--- NUEVO CORTE --->
                <cfquery name="insLineaTiempo2" datasource="#Arguments.conexion#">
                    insert into LineaTiempo(DEid, Ecodigo, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTdesde, LThasta, LTporcplaza, LTsalario, LTporcsal,
                    	RHJid, CPid, IEid, TEid, RHCPlinea, RHTtiponomb,RHPcodigoAlt,RHCPlineaP, LTsalarioSDI)
                            select DEid,
                                   Ecodigo,
                                   Tcodigo,
                                   RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid,
                                   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', 1, Fhasta)#">,
                                   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechatrab2#">,
                                   LTporcplaza, LTsalario, LTporcsal, RHJid,
                                   <cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#" null="#Not Isdefined('RCNid') Or (Isdefined('RCNid') and RCNid EQ 0)#">,
                                   IEid, TEid, RHCPlinea, RHTtiponomb,RHPcodigoAlt,RHCPlineaP,LTsalarioSDI
                            from LineaTiempo
                            where LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
                            and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                    <cf_dbidentity1 datasource="#Arguments.conexion#" verificar_transaccion="no">
                </cfquery>
                <cf_dbidentity2 datasource="#Arguments.conexion#" name="insLineaTiempo2" verificar_transaccion="no">

				<!---CarolRS. Actualiza el tipo de accion para la plaza principal--->
				<cfquery datasource="#session.DSN#">
					update LineaTiempo
					set RHTid= (select RHTid from RHAcciones where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">)
					where LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
				</cfquery>

                <cfquery datasource="#Arguments.conexion#">
                    insert into DLineaTiempo (LTid, CSid, DLTmonto, DLTunidades, DLTtabla, CIid, DLTmetodoC)
                    select <cfqueryparam cfsqltype="cf_sql_numeric" value="#insLineaTiempo2.identity#">,
                           b.CSid, b.DLTmonto, b.DLTunidades, b.DLTtabla, b.CIid, DLTmetodoC
                    from LineaTiempo a, DLineaTiempo b
                    where a.LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
                    and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                    and a.LTid = b.LTid
                    and b.DLTmonto != 0.00
                </cfquery>
            </cfif>

			<!---CarolRS. Hasta el momento se realizaron actualizaciones en las lineas del tiempo que fueron cortadas para que queden en las fechas de desde y hasta de corte de la nueva
				acccion en la linea del tiempo, en los espacios que quedan se agregan lineas con los mismos datos de la linea que fue cortada, para 'rellenar esos huecos'.
				Ahora podemos eliminar los cortes que esten dentro de la linea del tiempo y generar la nueva linea del tiempo con los datos de la nueva accion.
				Para todos los casos--->
			<cfquery datasource="#Arguments.conexion#" name="rsLineasIntermedias">
				Select LTid from LineaTiempo
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				and LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
				and LThasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
			</cfquery>

			<cfif rsLineasIntermedias.RecordCount gt 0>
					<!---Elimina los cortes intermedios --->
					<cfquery datasource="#session.DSN#">
						Delete from DLineaTiempo
						where LTid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#valueList(rsLineasIntermedias.LTid)#" list="yes">)
					</cfquery>
					<cfquery datasource="#session.DSN#">
						Delete from LineaTiempo
						where LTid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#valueList(rsLineasIntermedias.LTid)#" list="yes">)
					</cfquery>

					<!--- Inserto la nueva linea del tiempo--->
					<cfquery datasource="#Arguments.conexion#"  name="insLineaTiempo5">
						insert into LineaTiempo(DEid, Ecodigo, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTdesde, LThasta, LTporcplaza, LTsalario, LTporcsal, RHJid, CPid, IEid, TEid, RHCPlinea, RHTtiponomb,RHPcodigoAlt,RHCPlineaP, LTsalarioSDI)
						select a.DEid, a.Ecodigo, a.Tcodigo, a.RHTid, a.Ocodigo, a.Dcodigo, a.RHPid, a.RHPcodigo, a.RVid,
							   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">,
							   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">,
							   a.RHAporc, a.DLsalario, a.RHAporcsal, a.RHJid,
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#" null="#Not Isdefined('RCNid') Or (Isdefined('RCNid') and RCNid EQ 0)#">,
							   a.IEid, a.TEid, a.RHCPlinea,
							   b.RHTtiponomb,RHPcodigoAlt,RHCPlineaP, coalesce(a.DLsalarioSDI,0)
						from RHAcciones a
							inner join RHTipoAccion b
								on a.RHTid = b.RHTid

						where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
						<cf_dbidentity1 datasource="#Arguments.conexion#" verificar_transaccion="no">
					</cfquery>
					<cf_dbidentity2 datasource="#Arguments.conexion#" name="insLineaTiempo5" verificar_transaccion="no">

					<cfquery datasource="#Arguments.conexion#">
						insert into DLineaTiempo (LTid, CSid, DLTmonto, DLTunidades, DLTtabla, CIid,DLTmetodoC)
						select <cfqueryparam cfsqltype="cf_sql_numeric" value="#insLineaTiempo5.identity#">,
							   a.CSid, a.RHDAmontores, a.RHDAunidad, a.RHDAtabla, cs.CIid, a.RHDAmetodoC
						from RHDAcciones a
							inner join ComponentesSalariales cs
							on cs.CSid = a.CSid
						where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
						and RHDAmontores != 0.00
					</cfquery>
			</cfif>
			<!---.........--->

			<!--- *********************************** --->

            <!--- TABLA TEMPORAL PARA MANEJO DE COMPONENTES APLICA SOLO PARA EL CASO EN QUE SE MODIFICA UN SOLO COMPONENTE --->
            <cf_dbtemp name="ComponentesSLT" returnvariable="ComponentesSLT" datasource="#Arguments.conexion#">
                <cf_dbtempcol name="RHAlinea" 	 type="numeric"  mandatory="yes">
                <cf_dbtempcol name="LTid" 		 type="numeric"  mandatory="yes">
                <cf_dbtempcol name="CSid" 		 type="numeric" mandatory="yes">
                <cf_dbtempcol name="DLTmonto" 	 type="money"   mandatory="yes">
                <cf_dbtempcol name="DLTunidades" type="float"   mandatory="yes">
                <cf_dbtempcol name="CIid" 		 type="numeric" mandatory="no">
                <cf_dbtempcol name="DLTmetodoC"  type="char"    mandatory="no">
            </cf_dbtemp>
			<!--- INSERTA LOS COMPONENTES ACTUALES --->
        	<cfquery name="rsLTid" datasource="#session.DSN#">
                select distinct a.LTid as LTid
                from LineaTiempo a
                inner join DLineaTiempo b
                	on b.LTid = a.LTid
                inner join ComponentesSalariales cs
                	on cs.CSid = b.CSid
                where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				  and ((a.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
					  and a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">)
					  or (a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
					  and a.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">))
                  and CSusatabla <> 1
            </cfquery>
            <cfoutput query="rsLTid">
				<!--- INSERTA LOS NUEVOS COMPONENTES SI LOS HAY PARA CADA UNO DE LOS CORTES --->
                 <cfquery  datasource="#session.DSN#">
                    insert into #ComponentesSLT#(RHAlinea,LTid,CSid,DLTmonto,DLTunidades,b.CIid,DLTmetodoC)
                    select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTid.LTid#">,
                        cs.CSid,a.RHDAmontores, a.RHDAunidad,cs.CIid,a.RHDAmetodoC
                    from RHDAcciones a
                        inner join ComponentesSalariales cs
                        on cs.CSid = a.CSid
                    where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                    and RHDAmontores != 0.00
                    and cs.CSusatabla <> 1
                    and a.CSid not in(select CSid from #ComponentesSLT# where LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTid.LTid#"> )
                </cfquery>
			</cfoutput>
            <cfquery datasource="#session.DSN#">
                update #ComponentesSLT#
                set DLTmonto = (select RHDAmontores
                                from RHDAcciones a
                                inner join ComponentesSalariales cs
                                    on cs.CSid = a.CSid
                                where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                and RHDAmontores != 0.00
                                and cs.CSusatabla <> 1
                                and a.CSid = #ComponentesSLT#.CSid),
                    DLTunidades= (select RHDAunidad
                                from RHDAcciones a
                                inner join ComponentesSalariales cs
                                    on cs.CSid = a.CSid
                                where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                and RHDAmontores != 0.00
                                and cs.CSusatabla <> 1
                                and a.CSid = #ComponentesSLT#.CSid),
                    CIid= (select CIid
                                from RHDAcciones a
                                inner join ComponentesSalariales cs

                                on cs.CSid = a.CSid
                                where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                and RHDAmontores != 0.00
                                and cs.CSusatabla <> 1
                                and a.CSid = #ComponentesSLT#.CSid),
                    DLTmetodoC= (select RHDAmetodoC
                                from RHDAcciones a
                                inner join ComponentesSalariales cs
                                on cs.CSid = a.CSid
                                where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                and RHDAmontores != 0.00
                                and cs.CSusatabla <> 1
                                and a.CSid = #ComponentesSLT#.CSid)
                where exists (select 1
                            from RHDAcciones a
                            inner join ComponentesSalariales cs
                                on cs.CSid = a.CSid
                            where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                            and RHDAmontores != 0.00
                            and cs.CSusatabla <> 1
                            and a.CSid = #ComponentesSLT#.CSid)
            </cfquery>

            <!--- ACTUALIZA LOS COMPONENTES DE LA LINEA DE TIEMPO CON EL MONTO ACTUAL CON EL MONTO A CAMBIAR --->
           	<cfquery datasource="#Arguments.conexion#">
                update DLineaTiempo
                set DLTunidades = (	select DLTunidades
                                    from #ComponentesSLT#
                                    where LTid = DLineaTiempo.LTid
                                        and CSid = DLineaTiempo.CSid ),

                    DLTmonto = ( 	select DLTmonto
                                    from #ComponentesSLT#
                                    where LTid = DLineaTiempo.LTid
                                        and CSid = DLineaTiempo.CSid ),

                    DLTmetodoC = ( 	select DLTmetodoC
                                    from #ComponentesSLT#
                                    where LTid = DLineaTiempo.LTid
                                        and CSid = DLineaTiempo.CSid  )

                where exists (	select 1
                                    from #ComponentesSLT#
                                    where LTid = DLineaTiempo.LTid
                                        and CSid = DLineaTiempo.CSid )
            </cfquery>
			<!--- INSERTA COMPONENTES QUE NO ESTÁN EN LA LINEA DE TIEMPO --->
           	<cfquery datasource="#Arguments.conexion#">
               	insert into DLineaTiempo (LTid, CSid, DLTmonto, DLTunidades, DLTtabla, CIid,DLTmetodoC)
                select LTid,CSid, DLTmonto, DLTunidades, '0', CIid, DLTmetodoC
                from #ComponentesSLT#
                where CSid not in(select CSid from DLineaTiempo where LTid = #ComponentesSLT#.LTid)
            </cfquery>

            <!---SML. Inicio Insertar Componentes que no esten despues de la fecha de corte del FOA--->
            <cfquery datasource="#Arguments.conexion#" name="rsAccionesP">
               	select LTid as idFOA
                from LineaTiempo
                where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                and LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
                <!---and LTid not in (#ComponentesSLT#.LTid)--->
            </cfquery>

            <cfif isdefined('rsAccionesP') and rsAccionesP.RecordCount GT 0>
            	<cfloop query="rsAccionesP">
            	<cfquery datasource="#Arguments.conexion#">
               		insert into DLineaTiempo (LTid, CSid, DLTmonto, DLTunidades, DLTtabla, CIid,DLTmetodoC)
                	select <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccionesP.idFOA#">,CSid, DLTmonto, DLTunidades, '0', CIid, DLTmetodoC
                	from #ComponentesSLT#
               		where CSid not in(select CSid from DLineaTiempo where LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccionesP.idFOA#">)
            	</cfquery>
                </cfloop>
            </cfif>
            <!---SML. Final Insertar Componentes que no esten despues de la fecha de corte del FOA--->

            <!--- ELIMINA LOS COMPONENTE QUE NO ESTAN EN LA ACCION Y ESTAN EN LAS LINEA DE TIEMPO QUE SE ESTAN TOCANDO --->
			<cfquery datasource="#Arguments.conexion#">
            	delete from DLineaTiempo
                from DLineaTiempo a
                where LTid in(select LTid from #ComponentesSLT#)
                  and CSid not in(select CSid from RHDAcciones where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">)
            </cfquery>

			<!--- RECALCULO DE COMPONENTES --->
			<cfset result = RecalculoComponentes(arguments.Ecodigo,arguments.DEid,Fdesde,Fhasta,arguments.RHAlinea,RCNid,arguments.conexion)>
			<!--- VERIFICAR SI SE TIENE QUE REPLICAR LOS CAMBIOS EN LAS PLAZAS DE RECARGO --->
            <cfquery name="rsVerifRep" datasource="#session.DSN#">
            	select 1
                from RHAcciones a
                inner join RHDAcciones b
                	on b.RHAlinea = a.RHAlinea
                inner join ComponentesSalariales c
                	on c.CSid = b.CSid
                where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                  and CSreplica = 1
            </cfquery>
            <cfif rsVerifRep.RecordCount GTE 1>

				<!---TRAE LAS FECHAS DE VIGENCIA DE LA ACCION DE PERSONAL--->
                <cfquery name="rsVigencia" datasource="#session.DSN#">
                    select a.DLfvigencia
                    from RHAcciones a
                    where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                </cfquery>


				<!--- VERIFICA SI TIENE RECARGOS--->
                <cfquery name="rsRecargos" datasource="#session.DSN#">
                    select distinct a.RHPid<!--- ,b.RHPcodigo,LTdesde,LThasta --->
                    from LineaTiempoR a
                    inner join RHPlazas b
                    	on b.RHPid = a.RHPid
                    where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                      and ((a.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
                          and a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">)
                          or (a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
                          and a.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">))
					   and <cfqueryparam cfsqltype="cf_sql_date" value="#rsVigencia.DLfvigencia#"> between a.LTdesde and a.LThasta
                </cfquery>
                <!--- PARA CADA UNA DE LAS PLAZAS SE REPLICA EL CAMBIO --->
                <cfloop query="rsRecargos">
	            	<cfset result = ReplicaRecargos(arguments.Ecodigo,arguments.DEid,Fdesde,Fhasta,rsRecargos.RHPid,arguments.RHAlinea,arguments.DLlinea,arguments.conexion)>
                </cfloop>
            </cfif>
		</cfif>
		<cfif Arguments.debug>
			<cfquery name="rsLTDespues" datasource="#Arguments.conexion#">
				select * from LineaTiempo
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				order by LTdesde
			</cfquery>
			<cfdump var="#rsLTDespues#" label="LineaTiempo Final">
		</cfif>
		<cfreturn true>
	</cffunction>

   	<cffunction name="RegistraHistorico" access="private" output="true" returntype="boolean">
		<cfargument name="Ecodigo" 	type="numeric" required="yes">
		<cfargument name="DEid"    	type="numeric" required="yes">
        <cfargument name="LTRid"		type="numeric" required="yes">
        <cfargument name="RHAlinea"	type="numeric" required="yes">
        <cfargument name="DLlinea"	type="numeric" required="yes">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#">
		<cfargument name="debug" 	type="boolean" required="no" default="false">


		<!--- Agregar la Accion a los Datos Laborales del Empleado --->
        <cfquery name="nextConsec" datasource="#Arguments.conexion#">
            select coalesce(max(DLconsecutivo), 0) + 1 as consec
            from DLaboralesEmpleadoRec
            <!--- Cambio de Empresa --->
            <cfif dataTipoAccion.RHTcomportam EQ 9 and dataTipoAccion.RHTcempresa EQ 1>
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#dataTipoAccion.EcodigoRef#">
            <cfelse>
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
            </cfif>
        </cfquery>
        <!--- DATOS DE LA ACCION --->
        <cfquery name="rsDatosA" datasource="#Arguments.conexion#">
        	select a.RHTid,coalesce(RHTtiponomb,0) as RHTtiponomb,DLfvigencia,a.DLffin,a.DLobs,coalesce(a.RHAidtramite,0) as RHAidtramite
            from RHAcciones a
            inner join RHTipoAccion b
            	on b.Ecodigo = a.Ecodigo
                and b.RHTid = a.RHTid
            where a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
              and a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
        </cfquery>
        <!--- INSERTA EL ENCABEZADO DE LA ACCION PARA EL RECARGO --->
        <cfquery name="insDLaboralesEmpleado" datasource="#Arguments.conexion#">
            insert into DLaboralesEmpleadoRec (
            	DLlinea,
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
                RHfolio,		RHporcimss,		RHTtiponomb,			RHPcodigoAlt,
                DLsalarioSDI,
                Ecodigoant ,	Dcodigoant,		Ocodigoant,				RHPidant,
                RHPcodigoant,	Tcodigoant,		DLsalarioant,			RVidant,
                DLporcplazaant,	DLporcsalant,	RHJidant,				DLsalarioSDIant
                )
            select
            	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DLlinea#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#nextConsec.consec#">,
                a.DEid,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosA.RHTid#">,
                a.Ecodigo,	a.RHPid,		a.RHPcodigo,	a.Tcodigo,
                a.RVid,		a.Dcodigo,		a.Ocodigo,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDatosA.DLfvigencia#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDatosA.DLffin#">,
                0,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatosA.DLobs#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                '00',
                a.LTporcplaza,	a.LTporcsal,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosA.RHAidtramite#">,
                a.RHJid,
                0,0,
                a.IEid,				a.TEid,						a.RHCPlinea,
                null,		null,	null,
                <!---ljimenez incluye parametros adicionales para accion tipo incapacidad de mexico--->
                0,0,0,null, null,<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatosA.RHTtiponomb#">,
                a.RHPcodigoAlt, 0,
                a.Ecodigo, a.Dcodigo, a.Ocodigo,a.RHPid,
                a.RHPcodigo,a.Tcodigo, null, a.RVid,
                a.LTporcplaza,a.LTporcsal,a.RHJid,0
            from LineaTiempoR a
            where a.LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LTRid#">
        </cfquery>
        <!--- Agregar detalle de Datos Laborales --->
        <cfquery name="insDDLaboralesEmpleado" datasource="#Arguments.conexion#">
            insert into DDLaboralesEmpleadoRec (DLlinea, DEid, RHPid, CSid, DDLtabla, DDLunidad, DDLmontobase, DDLmontores,
            									DDLmetodoC, Usucodigo, Ulocalizacion, CIid,
                                                DDLunidadant,DDLmontobaseant,DDLmontoresant,DDLmetodoCant)
            select
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DLlinea#">,
                a.DEid, a.RHPid,
                b.CSid, 		b.DLTtabla, 	b.DLTunidades,
                b.DLTmonto, 	b.DLTmonto, 	b.DLTmetodoC,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                '00',	b.CIid,
                b.DLTunidades, b.DLTmonto, 	b.DLTmonto, b.DLTmetodoC
            from LineaTiempoR a
            inner join DLineaTiempoR b
            	on b.LTRid = a.LTRid
            where a.LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LTRid#">
        </cfquery>
        <cfreturn true>
	</cffunction>


    <!--- FUNCION PARA ACTUALIZAR LOS NUEVOS DATOS DEL RECARGO --->


	<!--- FUNCION PARA REPLICAR CAMBIO EN RECARGOS --->
   	<cffunction name="ReplicaRecargos" access="public" output="true" returntype="boolean">
		<cfargument name="Ecodigo" 	type="numeric" required="yes">
		<cfargument name="DEid"    	type="numeric" required="yes">
        <cfargument name="Fdesde"	type="date" required="yes">
        <cfargument name="Fhasta"	type="date" required="yes">
        <cfargument name="Plaza"   	type="numeric" required="yes">
        <cfargument name="RHAlinea" type="numeric" required="yes">
        <cfargument name="DLlinea"	type="numeric" required="yes">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#">
		<cfargument name="debug" 	type="boolean" required="no" default="false">


		<!--- Cortes de plaza --->
        <!--- si ha un corte donde la fecha desde es menor a la fecha desde de la acción se hace el corte nuevo con la fecha desde de la accion --->
		<cfquery name="LT1" datasource="#Arguments.conexion#">
			select LTRid as id1, LTdesde as fechatrab1, LThasta as fechatrabh1
			,RHTid as RHTid1 <!---CarolRS--->
			from LineaTiempoR
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#"> between LTdesde and LThasta
            and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Plaza#">
		</cfquery>

		<!--- PARA CADA UNA DE LAS PLAZAS SE GUARDA LA INFORMACIÓN ANTES DE QUE SE REALICE EL CAMBIO --->
        <cfset RegistraHistorico(arguments.Ecodigo,arguments.DEid,LT1.id1,arguments.RHAlinea,arguments.DLlinea,arguments.conexion)>

		<cfset id1 = LT1.id1>
		<cfset fechatrab1 = LT1.fechatrab1>
		<cfset fechatrabH1 = LT1.fechatrabh1>
		<cfset RHTid1 = LT1.RHTid1>				<!---CarolRS. atrapa el tipo de accion--->
		<cfif isdefined('id1') and id1 GT 0 and DateCompare(fechatrab1, arguments.Fdesde) EQ -1>
        	<!--- SE HACE CORTE DE LA LINEA DE TIEMPO Y NUEVO CORTE --->
        	<cfquery datasource="#session.DSN#">
            	update LineaTiempoR
                set LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', -1, Fdesde)#">
                where LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id1#">
                  and RHPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Plaza#">
            </cfquery>
            <!--- NUEVO CORTE --->
            <cfquery name="insLineaTiempo3" datasource="#Arguments.conexion#">
                insert into LineaTiempoR(DEid, Ecodigo, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTdesde, LThasta,
                				LTporcplaza, LTsalario, LTporcsal, RHJid, CPid, IEid, TEid, RHCPlinea, RHTtiponomb,RHPcodigoAlt,RHCPlineaP)
						select DEid,
                               Ecodigo,
                               Tcodigo,
                               (select RHTid from RHAcciones where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">),
							   Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid,
                               <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">,
							   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechatrabH1#">,
                               LTporcplaza, LTsalario, LTporcsal, RHJid,
                               <cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#" null="#Not Isdefined('RCNid') Or (Isdefined('RCNid') and RCNid EQ 0)#">,
                               IEid, TEid, RHCPlinea, RHTtiponomb,RHPcodigoAlt,RHCPlineaP
                        from LineaTiempoR
                        where LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id1#">
                        and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                        and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Plaza#">
                <cf_dbidentity1 datasource="#Arguments.conexion#" verificar_transaccion="no">
            </cfquery>
            <cf_dbidentity2 datasource="#Arguments.conexion#" name="insLineaTiempo3" verificar_transaccion="no">

            <cfquery datasource="#Arguments.conexion#">
                insert into DLineaTiempoR (LTRid, CSid, DLTmonto, DLTunidades, DLTtabla, CIid, DLTmetodoC)
                select <cfqueryparam cfsqltype="cf_sql_numeric" value="#insLineaTiempo3.identity#">,
                       b.CSid, b.DLTmonto, b.DLTunidades, b.DLTtabla, b.CIid, DLTmetodoC
                from LineaTiempoR a, DLineaTiempoR b
                where a.LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id1#">
                and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                and a.LTRid = b.LTRid
                and b.DLTmonto != 0.00
                and a.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Plaza#">
                and CSid in (select CSid from RHDAcciones where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">)
            </cfquery>
        </cfif>
		<cfquery name="LT2" datasource="#Arguments.conexion#">
			select LTRid as id2, LThasta as fechatrab2
			from LineaTiempoR
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#"> between LTdesde and LThasta
            and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Plaza#">
		</cfquery>
		<cfset id2 = LT2.id2>
		<cfset fechatrab2 = LT2.fechatrab2>
        <!--- si hay un corte donde la fecha hasta es mayor a la fecha hasta de la acción se hace el corte nuevo
				con fecha desde = hasta accion +1
			      y fecha hasta = fecha hasta del corte --->
        <cfif isdefined('id2') and id2 GT 0 and DateCompare(fechatrab2, arguments.Fhasta) EQ 1>
        <!--- SE HACE CORTE DE LA LINEA DE TIEMPO Y NUEVO CORTE --->
        	<cfquery datasource="#session.DSN#">
            	update LineaTiempoR
                set LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
                where LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
                  and RHPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Plaza#">
            </cfquery>
            <!--- NUEVO CORTE --->
            <cfquery name="insLineaTiempo4"  datasource="#Arguments.conexion#">
                insert into LineaTiempoR(DEid, Ecodigo, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTdesde, LThasta, LTporcplaza,
                	LTsalario, LTporcsal, RHJid, CPid, IEid, TEid, RHCPlinea, RHTtiponomb,RHPcodigoAlt,RHCPlineaP)
						select DEid,
                               Ecodigo,
                               Tcodigo,
                               <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHTid1#">, <!---CarolRS. Conserva el tipo de accion original ya que se realizo corte desde y corte hasta de la accion actual--->
							   Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid,
                               <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', 1, Fhasta)#">,
                               <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechatrab2#">,
                               LTporcplaza, LTsalario, LTporcsal, RHJid,
                               <cfqueryparam cfsqltype="cf_sql_numeric" value="#RCNid#" null="#Not Isdefined('RCNid') Or (Isdefined('RCNid') and RCNid EQ 0)#">,
                               IEid, TEid, RHCPlinea, RHTtiponomb,RHPcodigoAlt,RHCPlineaP
                        from LineaTiempoR
                        where LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
                        and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                        and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Plaza#">
                <cf_dbidentity1 datasource="#Arguments.conexion#" verificar_transaccion="no">
            </cfquery>
            <cf_dbidentity2 datasource="#Arguments.conexion#" name="insLineaTiempo4" verificar_transaccion="no">

            <cfquery datasource="#Arguments.conexion#">
                insert into DLineaTiempoR (LTRid, CSid, DLTmonto, DLTunidades, DLTtabla, CIid, DLTmetodoC)
                select <cfqueryparam cfsqltype="cf_sql_numeric" value="#insLineaTiempo4.identity#">,
                       b.CSid, b.DLTmonto, b.DLTunidades, b.DLTtabla, b.CIid, DLTmetodoC
                from LineaTiempoR a, DLineaTiempoR b
                where a.LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
                and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                and a.LTRid = b.LTRid
                and b.DLTmonto != 0.00
                and a.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Plaza#">
                and CSid in (select CSid from RHDAcciones where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">)
            </cfquery>
        </cfif>

			<!---CarolRS. La nueva accion se da en las mismas fechas desde y hasta donde ya existen cortes, si hay varias acciones intermedias las elimina y solo actualiza la primera--->
			<cfif isdefined('id1') and id1 GT 0 and DateCompare(fechatrab1, arguments.Fdesde) EQ 0 and isdefined('id2') and id2 GT 0 and DateCompare(fechatrab2, arguments.Fhasta) EQ 0
				OR isdefined('id1') and id1 GT 0 and DateCompare(fechatrab1, arguments.Fdesde) EQ 0 and isdefined('id2') and id2 GT 0 and DateCompare(fechatrab2, arguments.Fhasta) EQ 1
				OR isdefined('id1') and id1 GT 0 and DateCompare(fechatrab1, arguments.Fdesde) EQ -1 and isdefined('id2') and id2 GT 0 and DateCompare(fechatrab2, arguments.Fhasta) EQ 0 >

				<cfif DateCompare(fechatrab1,Fdesde) EQ -1>
					<cfset id1 = insLineaTiempo3.identity>
				</cfif>
				<cfquery datasource="#session.DSN#">
					update LineaTiempoR
					set RHTid= (select RHTid from RHAcciones where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">)
						, LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
					where LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id1#">
				</cfquery>
				<cfquery datasource="#session.DSN#">
					Delete from DLineaTiempoR
					where LTRid in (
								Select LTRid from LineaTiempoR
								where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
								and LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
								and LThasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
								and LTRid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#id1#">)
				</cfquery>
				<cfquery datasource="#session.DSN#">
					Delete from LineaTiempoR
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					and LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
					and LThasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
					and LTRid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#id1#">
				</cfquery>
			</cfif>
			<!---.........--->

            <!--- TABLA TEMPORAL PARA MANEJO DE COMPONENTES APLICA SOLO PARA EL CASO EN QUE SE MODIFICA UN SOLO COMPONENTE --->
            <cf_dbtemp name="ComponentesSR" returnvariable="ComponentesSR" datasource="#Arguments.conexion#">
                <cf_dbtempcol name="RHAlinea" 	 type="numeric"  mandatory="yes">
                <cf_dbtempcol name="LTRid" 		 type="numeric"  mandatory="yes">
                <cf_dbtempcol name="CSid" 		 type="numeric" mandatory="yes">
                <cf_dbtempcol name="DLTmonto" 	 type="money"   mandatory="yes">
                <cf_dbtempcol name="DLTunidades" type="float"   mandatory="yes">
                <cf_dbtempcol name="CIid" 		 type="numeric" mandatory="no">
                <cf_dbtempcol name="DLTmetodoC"  type="char"    mandatory="no">
            </cf_dbtemp>
			<!--- INSERTA LOS COMPONENTES ACTUALES --->
        	<cfquery name="rs" datasource="#session.DSN#">
            	insert into #ComponentesSR#(RHAlinea,LTRid,CSid,DLTmonto,DLTunidades,b.CIid,DLTmetodoC)
                select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">,
                    	a.LTRid, b.CSid,DLTmonto,DLTunidades,b.CIid,DLTmetodoC
                from LineaTiempoR a
                inner join DLineaTiempoR b
                	on b.LTRid = a.LTRid
                inner join ComponentesSalariales cs
                	on cs.CSid = b.CSid
                where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				  and ((a.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
					  and a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">)
					  or (a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
					  and a.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">))
                  and a.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Plaza#">
                  and CSusatabla <> 1
                  and b.CSid in (select CSid from RHDAcciones where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">)
            </cfquery>
            <!--- CONSULTA DE LOS CORTES QUE SE TIENEN QUE MODIFICAR --->
            <cfquery name="rsLTid" datasource="#session.DSN#">
            	select distinct LTRid
                from #ComponentesSR#
            </cfquery>
            <cfoutput query="rsLTid">
				<!--- INSERTA LOS NUEVOS COMPONENTES SI LOS HAY PARA CADA UNO DE LOS CORTES --->
                 <cfquery name="rs" datasource="#session.DSN#">
                     insert into #ComponentesSR#(RHAlinea,LTRid,CSid,DLTmonto,DLTunidades,b.CIid,DLTmetodoC)
                    select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTid.LTRid#">,
                        cs.CSid,a.RHDAmontores, a.RHDAunidad,cs.CIid,a.RHDAmetodoC
                    from RHDAcciones a
                        inner join ComponentesSalariales cs
                        on cs.CSid = a.CSid
                    where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                    and RHDAmontores != 0.00
                    and cs.CSusatabla <> 1
                    and cs.CSreplica = 1
                    and a.CSid not in(select CSid from #ComponentesSR# where LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTid.LTRid#"> )
                </cfquery>
			</cfoutput>
            <cfquery datasource="#session.DSN#">
                update #ComponentesSR#
                set DLTmonto = (select RHDAmontores
                                from RHDAcciones a
                                inner join ComponentesSalariales cs
                                    on cs.CSid = a.CSid
                                where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                and RHDAmontores != 0.00
                                and cs.CSusatabla <> 1
                                and cs.CSreplica = 1
                                and a.CSid = #ComponentesSR#.CSid),
                    DLTunidades= (select RHDAunidad
                                from RHDAcciones a
                                inner join ComponentesSalariales cs
                                    on cs.CSid = a.CSid
                                where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                and RHDAmontores != 0.00
                                and cs.CSusatabla <> 1
                                and cs.CSreplica = 1
                                and a.CSid = #ComponentesSR#.CSid),
                    CIid= (select CIid
                                from RHDAcciones a
                                inner join ComponentesSalariales cs
                                on cs.CSid = a.CSid
                                where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                and RHDAmontores != 0.00
                                and cs.CSusatabla <> 1
                                and a.CSid = #ComponentesSR#.CSid),
                    DLTmetodoC= (select RHDAmetodoC
                                from RHDAcciones a
                                inner join ComponentesSalariales cs
                                on cs.CSid = a.CSid
                                where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                                and RHDAmontores != 0.00
                                and cs.CSusatabla <> 1
                                and cs.CSreplica = 1
                                and a.CSid = #ComponentesSR#.CSid)
                where exists (select 1
                            from RHDAcciones a
                            inner join ComponentesSalariales cs
                                on cs.CSid = a.CSid
                            where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                            and RHDAmontores != 0.00
                            and cs.CSusatabla <> 1
                            and cs.CSreplica = 1
                            and a.CSid = #ComponentesSR#.CSid)
            </cfquery>
            <!--- ACTUALIZA LOS COMPONENTES DE LA LINEA DE TIEMPO CON EL MONTO ACTUAL CON EL MONTO A CAMBIAR --->
           	<cfquery datasource="#Arguments.conexion#">
                update DLineaTiempoR
                set DLTunidades = (	select DLTunidades
                                    from #ComponentesSr#
                                    where LTRid = DLineaTiempoR.LTRid
                                        and CSid = DLineaTiempoR.CSid ),

                    DLTmonto = ( 	select DLTmonto
                                    from #ComponentesSR#
                                    where LTRid = DLineaTiempoR.LTRid
                                        and CSid = DLineaTiempoR.CSid ),

                    DLTmetodoC = ( 	select DLTmetodoC
                                    from #ComponentesSR#
                                    where LTRid = DLineaTiempoR.LTRid
                                        and CSid = DLineaTiempoR.CSid  )

                where exists (	select 1
                                    from #ComponentesSR#
                                    where LTRid = DLineaTiempoR.LTRid
                                        and CSid = DLineaTiempoR.CSid )
            </cfquery>
			<!--- INSERTA COMPONENTES QUE NO ESTÁN EN LA LINEA DE TIEMPO --->
           	<cfquery name="rs" datasource="#Arguments.conexion#">
               	insert into DLineaTiempoR (LTRid, CSid, DLTmonto, DLTunidades, DLTtabla, CIid,DLTmetodoC)
                select LTRid,CSid, DLTmonto, DLTunidades, '0', CIid, DLTmetodoC
                from #ComponentesSR#
                where CSid not in(select CSid from DLineaTiempoR where LTRid = #ComponentesSR#.LTRid)
            </cfquery>
			<!--- ELIMINA LOS COMPONENTE QUE NO ESTAN EN LA ACCION Y ESTAN EN LAS LINEA DE TIEMPO QUE SE ESTAN TOCANDO --->
			<cfquery datasource="#Arguments.conexion#">
            	delete from DLineaTiempoR
                from DLineaTiempoR a
                where LTRid in(select LTRid from #ComponentesSR#)
                  and a.CSid not in(select CSid from RHDAcciones where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">)
            </cfquery>
		<!--- RECALCULO DE COMPONENTES --->
        <cfset result = RecalculoComponentesR(arguments.Ecodigo,arguments.DEid,arguments.Plaza,Fdesde,Fhasta,RCNid,arguments.DLlinea,arguments.conexion)>
        <!--- ACTUALIZAR LA INFORMACIÓN DE LA ACCION PARA LOS RECARGOS, LUEGO DEL RECALCULO --->
        <cfset result = RegistraDatosActuales(arguments.Ecodigo,arguments.DEid,arguments.DLlinea,arguments.Plaza,Fdesde,Fhasta,arguments.conexion)>
    	<cfreturn true>
    </cffunction>

	<!--- RECALCULO DE LOS COMPONENTES DE LA LINEA DE TIEMPO --->
   	<cffunction name="RecalculoComponentes" access="public" output="true" returntype="boolean">
		<cfargument name="Ecodigo" 	type="numeric" required="yes">
		<cfargument name="DEid"    	type="numeric" required="yes">
        <cfargument name="Fdesde"	type="date" required="yes">
        <cfargument name="Fhasta"	type="date" required="yes">
        <cfargument name="RHAlinea" type="numeric" required="true">
        <cfargument name="RCNid" 	type="numeric" required="true">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#">
		<cfargument name="debug" 	type="boolean" required="no" default="false">

		<!--- LINEAS DE TIEMPO QUE SE TIENEN QUE RECALCULAR --->
        <cfquery name="rsLTid" datasource="#conexion#">
       		select a.LTid
            from LineaTiempo a
            where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
              and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
              and ((a.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fdesde#">
                  and a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fhasta#">)
                  or (a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fhasta#">
                  and a.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fdesde#">))
        </cfquery>
        <cfloop query="rsLTid">
			<!--- Recalcular todos los componentes --->
            <cfquery name="rsComp" datasource="#Session.DSN#">
                select c.DEid,a.LTid, a.CSid, a.DLTunidades, a.DLTmonto,
                       c.LTdesde,coalesce(c.LThasta,'61000101') as LThasta, c.RHCPlinea, LTporcsal,c.RHPcodigoAlt,coalesce(RHCPlineaP,0) as RHCPlineaP,a.DLTmetodoC
                from DLineaTiempo a
                    inner join ComponentesSalariales b
                        on b.CSid = a.CSid
                    inner join LineaTiempo c
                        on c.LTid = a.LTid
                        and c.Ecodigo = b.Ecodigo
                where a.LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTid.LTid#">
                  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                order by b.CSorden, b.CScodigo, b.CSdescripcion
            </cfquery>
            <cfset Lvar_CatAlt = rsComp.RHCPlinea>
             <!--- VERIFICA SI LA ACCIÓN DEBE DE APLICAR UN PUESTO ALTERNO --->
            <cfquery name="rsAccion" datasource="#session.DSN#">
            	select RHPcodigoAlt
                from RHAcciones
                where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHAlinea#">
            </cfquery>
            <cfif rsAccion.RecordCount and LEN(TRIM(rsAccion.RHPcodigoAlt)) GT 0>
            	<cfset rsComp.RHPcodigoAlt = rsAccion.RHPcodigoAlt>
            </cfif>
			<!--- VERIFICAR SI TIENE UN PUESTO ALTERNO QUE CAMBIA LA CATEGORIA --->
            <cfset Lvar_RHTTid = 0>
            <cfset Lvar_RHMPPid = 0>
            <cfset Lvar_RHCid = 0>
            <cfif rsComp.RecordCount GT 0 and rsComp.RHPcodigoAlt GT 0>
                <cfquery name="rsCatPuestoAlt" datasource="#session.DSN#">
                    select RHCPlinea
                    from RHPuestos a
                    inner join RHMaestroPuestoP b
                        on b.RHMPPid = a.RHMPPid
                        and b.Ecodigo = a.Ecodigo
                    inner join RHCategoriasPuesto c
                        on c.RHMPPid = b.RHMPPid
                        and c.Ecodigo = b.Ecodigo
                    where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsComp.RHPcodigoAlt#">
                      and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                </cfquery>
                <cfset Lvar_CatAlt = rsCatPuestoAlt.RHCPlinea>
                <cfif isdefined('rsCatPuestoAlt') and rsCatPuestoAlt.RecordCount>
                    <cfset Lvar_CatAlt = rsCatPuestoAlt.RHCPlinea>
               <cfelse>
                    <cfset Lvar_CatAlt = 0>
                </cfif>
            </cfif>
            <cfloop query="rsComp">

            <cfif usaEstructuraSalarial>
                <cfinvoke
                 component="rh.Componentes.RH_EstructuraSalarial"
                 method="calculaComponente"
                 returnvariable="calculaComponenteR">
                    <cfinvokeargument name="CSid" value="#rsComp.CSid#"/>
                    <cfinvokeargument name="fecha" value="#rsComp.LTdesde#"/>
                    <cfinvokeargument name="fechah" value="#rsComp.LThasta#"/>
                    <cfinvokeargument name="DEid" value="#rsComp.DEid#"/>
                    <cfinvokeargument name="RHCPlinea" value="#Lvar_CatAlt#"/>
                    <cfinvokeargument name="BaseMontoCalculo" value="0.00"/>
                    <cfinvokeargument name="Unidades" value="#rsComp.DLTunidades#"/>
                    <cfinvokeargument name="Monto" value="#rsComp.DLTmonto#"/>
                    <cfinvokeargument name="Metodo" value="#rsComp.DLTmetodoC#"/>
                    <cfinvokeargument name="TablaComponentes" value="DLineaTiempo"/>
                    <cfinvokeargument name="CampoLlaveTC" value="LTid"/>
                    <cfinvokeargument name="ValorLlaveTC" value="#rsLTid.LTid#"/>
                    <cfinvokeargument name="CampoMontoTC" value="DLTmonto"/>
                    <cfinvokeargument name="RHTTid" value="0">
                    <cfinvokeargument name="RHCid" value="0">
                    <cfinvokeargument name="RHMPPid" value="0">
                    <cfinvokeargument name="PorcSalario" value="#rsComp.LTporcsal#"/>
                    <cfinvokeargument name="RHCPlineaP" value="#rsComp.RHCPlineaP#"/>
                </cfinvoke>
             <cfelse> <!--- SML. Modificacion para empresas que no tienen Estructura Salarial--->
             	<cfinvoke
                 component="rh.Componentes.RH_SinEstructuraSalarial"
                 method="calculaComponente"
                 returnvariable="calculaComponenteR">
                    <cfinvokeargument name="CSid" value="#rsComp.CSid#"/>
                    <cfinvokeargument name="fecha" value="#rsComp.LTdesde#"/>
                    <cfinvokeargument name="fechah" value="#rsComp.LThasta#"/>
                    <cfinvokeargument name="DEid" value="#rsComp.DEid#"/>
                    <!---<cfinvokeargument name="RHCPlinea" value="#Lvar_CatAlt#"/>--->
                    <cfinvokeargument name="BaseMontoCalculo" value="0.00"/>
                    <cfinvokeargument name="Unidades" value="#rsComp.DLTunidades#"/>
                    <cfinvokeargument name="Monto" value="#rsComp.DLTmonto#"/>
                    <cfinvokeargument name="Metodo" value="#rsComp.DLTmetodoC#"/>
                    <cfinvokeargument name="TablaComponentes" value="DLineaTiempo"/>
                    <cfinvokeargument name="CampoLlaveTC" value="LTid"/>
                    <cfinvokeargument name="ValorLlaveTC" value="#rsLTid.LTid#"/>
                    <cfinvokeargument name="CampoMontoTC" value="DLTmonto"/>
                    <cfinvokeargument name="RHTTid" value="0">
                    <cfinvokeargument name="RHCid" value="0">
                    <cfinvokeargument name="RHMPPid" value="0">
                    <cfinvokeargument name="PorcSalario" value="#rsComp.LTporcsal#"/>
                    <cfinvokeargument name="RHCPlineaP" value="#rsComp.RHCPlineaP#"/>
                    <cfinvokeargument name="RHAlinea" value="#Arguments.RHAlinea#"/>
                </cfinvoke>
             </cfif>

                <cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
                    update DLineaTiempo
                       set DLTunidades 	= <cfqueryparam cfsqltype="cf_sql_float" value="#calculaComponenteR.Unidades#">,
                           DLTmonto		= <cfqueryparam cfsqltype="cf_sql_money" value="#calculaComponenteR.Monto#">,
                           DLTmetodoC 	= <cfqueryparam cfsqltype="cf_sql_char" value="#calculaComponenteR.Metodo#">,
                           BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
                     where LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTid.LTid#">
                       and CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComp.CSid#">
                </cfquery>
            </cfloop>
            <!--- se hace la suma de los componente para el total del salario --->
            <cfquery datasource="#session.DSN#">
                update LineaTiempo
                set LTsalario = coalesce((select sum(DLTmonto)
                                from LineaTiempo a
                                inner join DLineaTiempo b
                                    on b.LTid = a.LTid
                                where a.LTid = LineaTiempo.LTid
                                  and a.Ecodigo = LineaTiempo.Ecodigo),0),
                     CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#" null="#Not Isdefined('arguments.RCNid') Or (Isdefined('arguments.RCNid') and arguments.RCNid EQ 0)#">,
                     RHPcodigoAlt = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComp.RHPcodigoAlt#" null="#Not Isdefined('rsComp.RHPcodigoAlt') Or (Isdefined('rsComp.RHPcodigoAlt') and rsComp.RHPcodigoAlt LTE 0)#">,
					 BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                where LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTid.LTid#">
                  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            </cfquery>
        </cfloop>
        <cfreturn true>
	</cffunction>

    <!--- RECALCULO DE LOS COMPONENTES DE RECARGOS --->
   	<cffunction name="RecalculoComponentesR" access="public" output="true" returntype="boolean">
		<cfargument name="Ecodigo" 	type="numeric" required="yes">
		<cfargument name="DEid"    	type="numeric" required="yes">
        <cfargument name="Plaza"   	type="numeric" required="yes">
        <cfargument name="Fdesde"	type="date" required="yes">
        <cfargument name="Fhasta"	type="date" required="yes">
        <cfargument name="RCNid" 	type="numeric" required="true">
        <cfargument name="DLlinea" 	type="numeric" required="true">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#">
		<cfargument name="debug" 	type="boolean" required="no" default="false">

		<!--- LINEAS DE TIEMPO QUE SE TIENEN QUE RECALCULAR --->
        <cfquery name="rsLTid" datasource="#conexion#">
       		select a.LTRid
            from LineaTiempoR a
            where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
              and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
              and ((a.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fdesde#">
                  and a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fhasta#">)
                  or (a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fhasta#">
                  and a.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fdesde#">))
        </cfquery>
        <cfloop query="rsLTid">
            <!--- ACTUALIZA SALARIO BASE SI LLEVA UN CAMBIO SALARIAL --->
			<cfquery name="datosLT" datasource="#session.DSN#">
            	select RHCPlinea,RHCPlineaP,RHPcodigoAlt
                from LineaTiempoR
                where LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTid.LTRid#">
            </cfquery>
			<!----=================================----->
            <!--- Averiguar y almacena el Monto de Salario base --->
            <cfquery name="rsMontoSalarioBase" datasource="#Session.DSN#">
                select b.RHMCmonto as SB
                from RHCategoriasPuesto a
                inner join RHMontosCategoria b
                    on b.RHCid = a.RHCid
                inner join RHVigenciasTabla c
                    on c.Ecodigo = a.Ecodigo
                    and c.RHVTid = b.RHVTid
                    and c.RHTTid = a.RHTTid
                where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                  and RHVTestado = 'A'
                  and a.RHCPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datosLT.RHCPlinea#">
                      and <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fdesde#"> between  RHVTfecharige  and RHVTfechahasta
            </cfquery>
            <cfif rsMontoSalarioBase.RecordCount EQ 0>
                <cf_throw message="No hay una tabla salarial para el periodo seleccionado. Proceso Cancelado." errorcode="9002">
            </cfif>
            <cfset SalarioBase = rsMontoSalarioBase.SB>

            <!--- VERIRFICA SI HAY UNA CATEGORIA DE PAGO PROPUESTA ART. 40 --->
            <cfif isdefined('arguments.RHCPlineaP') and arguments.RHCPlineaP GT 0>
                <cfquery name="rsMontoSalarioBaseProp" datasource="#Session.DSN#">
                    select max(coalesce(b.RHMCmonto,0)) as SB
                    from RHCategoriasPuesto a
                    inner join RHMontosCategoria b
                        on b.RHCid = a.RHCid
                    inner join RHVigenciasTabla c
                        on c.Ecodigo = a.Ecodigo
                        and c.RHVTid = b.RHVTid
                        and c.RHTTid = a.RHTTid
                    where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                      and RHVTestado = 'A'
                      and a.RHCPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datosLT.RHCPlineaP#">
                      and <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fdesde#"> between  RHVTfecharige  and RHVTfechahasta
                </cfquery>
                <cfif rsMontoSalarioBaseProp.RecordCount EQ 0>
                    <cf_throw message="No hay una tabla salarial para el periodo seleccionado de la Categoría Propuesta. Proceso Cancelado." errorcode="9002">
                </cfif>
                <cfset LvarMontoCatProp=rsMontoSalarioBase.SB+abs(((rsMontoSalarioBaseProp.SB-rsMontoSalarioBase.SB)/2))>
                <cfset SalarioBase = LvarMontoCatProp>
            </cfif>
			<!--- ACTUALIZA EL COMPONENTE SALARIO BASE --->
            <cfquery datasource="#session.DSN#">
            	update DLineaTiempoR
                set DLTmonto = <cfqueryparam cfsqltype="cf_sql_money" value="#SalarioBase#">
                from DLineaTiempoR a
                inner join ComponentesSalariales b
                	on b.CSid = a.CSid
                where a.LTRid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTid.LTRid#">
                  and b.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                  and b.CSusatabla = 1
            </cfquery>
			<!--- Recalcular todos los componentes --->
            <cfquery name="rsComp" datasource="#Session.DSN#">
                select c.DEid,a.LTRid, a.CSid, a.DLTunidades, a.DLTmonto,
                       c.LTdesde,coalesce(c.LThasta,'61000101') as LThasta, c.RHCPlinea, LTporcsal,c.RHPcodigoAlt,coalesce(RHCPlineaP,0) as RHCPlineaP,a.DLTmetodoC
                from DLineaTiempoR a
                    inner join ComponentesSalariales b
                        on b.CSid = a.CSid
                    inner join LineaTiempoR c
                        on c.LTRid = a.LTRid
                        and c.Ecodigo = b.Ecodigo
                where a.LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTid.LTRid#">
                  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                order by b.CSorden, b.CScodigo, b.CSdescripcion
            </cfquery>
            <cfset Lvar_CatAlt = rsComp.RHCPlinea>
            <!--- VERIFICAR SI TIENE UN PUESTO ALTERNO QUE CAMBIA LA CATEGORIA --->
            <cfset Lvar_RHTTid = 0>
            <cfset Lvar_RHMPPid = 0>
            <cfset Lvar_RHCid = 0>
            <cfif rsComp.RecordCount GT 0 and rsComp.RHPcodigoAlt GT 0>
                <cfquery name="rsCatPuestoAlt" datasource="#session.DSN#">
                    select RHCPlinea
                    from RHPuestos a
                    inner join RHMaestroPuestoP b
                        on b.RHMPPid = a.RHMPPid
                        and b.Ecodigo = a.Ecodigo
                    inner join RHCategoriasPuesto c
                        on c.RHMPPid = b.RHMPPid
                        and c.Ecodigo = b.Ecodigo
                    where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsComp.RHPcodigoAlt#">
                      and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                </cfquery>
                <cfset Lvar_CatAlt = rsCatPuestoAlt.RHCPlinea>
                <cfif isdefined('rsCatPuestoAlt') and rsCatPuestoAlt.RecordCount>
                    <cfset Lvar_CatAlt = rsCatPuestoAlt.RHCPlinea>
               <cfelse>
                    <cfset Lvar_CatAlt = 0>
                </cfif>
            </cfif>
            <cfloop query="rsComp">

                <cfinvoke
                 component="rh.Componentes.RH_EstructuraSalarial"
                 method="calculaComponente"
                 returnvariable="calculaComponenteR">
                    <cfinvokeargument name="CSid" value="#rsComp.CSid#"/>
                    <cfinvokeargument name="fecha" value="#rsComp.LTdesde#"/>
                    <cfinvokeargument name="fechah" value="#rsComp.LThasta#"/>
                    <cfinvokeargument name="DEid" value="#rsComp.DEid#"/>
                    <cfinvokeargument name="RHCPlinea" value="#Lvar_CatAlt#"/>
                    <cfinvokeargument name="BaseMontoCalculo" value="0.00"/>
                    <cfinvokeargument name="Unidades" value="#rsComp.DLTunidades#"/>
                    <cfinvokeargument name="Monto" value="#rsComp.DLTmonto#"/>
                    <cfinvokeargument name="Metodo" value="#rsComp.DLTmetodoC#"/>
                    <cfinvokeargument name="TablaComponentes" value="DLineaTiempoR"/>
                    <cfinvokeargument name="CampoLlaveTC" value="LTRid"/>
                    <cfinvokeargument name="ValorLlaveTC" value="#rsLTid.LTRid#"/>
                    <cfinvokeargument name="CampoMontoTC" value="DLTmonto"/>
                    <cfinvokeargument name="RHTTid" value="0">
                    <cfinvokeargument name="RHCid" value="0">
                    <cfinvokeargument name="RHMPPid" value="0">
                    <cfinvokeargument name="PorcSalario" value="#rsComp.LTporcsal#"/>
                    <cfinvokeargument name="RHCPlineaP" value="#rsComp.RHCPlineaP#"/>
                </cfinvoke>

                <cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
                    update DLineaTiempoR
                       set DLTunidades 	= <cfqueryparam cfsqltype="cf_sql_float" value="#calculaComponenteR.Unidades#">,
                           DLTmonto		= <cfqueryparam cfsqltype="cf_sql_money" value="#calculaComponenteR.Monto#">,
                           DLTmetodoC 	= <cfqueryparam cfsqltype="cf_sql_char" value="#calculaComponenteR.Metodo#">,
                           BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
                     where LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTid.LTRid#">
                       and CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComp.CSid#">
                </cfquery>
            </cfloop>
            <!--- se hace la suma de los componente para el total del salario --->
            <cfquery datasource="#session.DSN#">
                update LineaTiempoR
                set LTsalario = coalesce((select sum(DLTmonto)
                                from LineaTiempoR a
                                inner join DLineaTiempoR b
                                    on b.LTRid = a.LTRid
                                where a.LTRid = LineaTiempoR.LTRid
                                  and a.Ecodigo = LineaTiempoR.Ecodigo),0),
                     BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                where LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTid.LTRid#">
                  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            </cfquery>
            <!--- se hace la suma de los componente para el total del salario --->
            <cfquery datasource="#session.DSN#">
                update LineaTiempoR
                set CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#" null="#Not Isdefined('arguments.RCNid') Or (Isdefined('arguments.RCNid') and arguments.RCNid EQ 0)#">,
                    BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                where LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTid.LTRid#">
                  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                  and LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fdesde#">
            </cfquery>
        </cfloop>
        <cfreturn true>
	</cffunction>

    <!--- FUNCION PARA LA ACTUALIZACION DE LOS DATOS NUEVOS DE LA ACCION --->
    <cffunction name="RegistraDatosActuales" access="public" output="true" returntype="boolean">
		<cfargument name="Ecodigo" 	type="numeric" required="yes">
		<cfargument name="DEid"    	type="numeric" required="yes">
        <cfargument name="DLlinea"	type="numeric" required="yes">
        <cfargument name="Plaza"	type="numeric" required="yes">
        <cfargument name="Fdesde"	type="date" required="yes">
        <cfargument name="Fhasta"	type="date" required="yes">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#">
		<cfargument name="debug" 	type="boolean" required="no" default="false">


		<!--- LINEAS DE TIEMPO QUE SE TIENEN QUE RECALCULAR --->
        <cfquery name="rsLTid" datasource="#conexion#">
       		select a.LTRid
            from LineaTiempoR a
            where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
              and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
              and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Plaza#">
              and ((a.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fdesde#">
                  and a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fhasta#">)
                  or (a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fhasta#">
                  and a.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fdesde#">))
        </cfquery>
    	<!--- INSERTA NUEVOS COMPONENTES SI NO EXISTEN EN DDLaboralesEmpleadoRec --->
		<cfquery name="insDDLaboralesEmpleado" datasource="#Arguments.conexion#">
             insert into DDLaboralesEmpleadoRec (DLlinea, DEid, RHPid, CSid, DDLtabla, DDLunidad, DDLmontobase, DDLmontores,
            									DDLmetodoC, Usucodigo, Ulocalizacion, CIid,
                                                DDLunidadant,DDLmontobaseant,DDLmontoresant,DDLmetodoCant)
            select
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DLlinea#">,
                a.DEid, a.RHPid,
                b.CSid, 		b.DLTtabla, 	b.DLTunidades,
                b.DLTmonto, 	b.DLTmonto, b.DLTmetodoC,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                '00',	b.CIid,
                0,0,0,'0'
            from LineaTiempoR a
            inner join DLineaTiempoR b
            	on b.LTRid = a.LTRid
            where a.LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTid.LTRid#">
              and b.CSid not in(select CSid
              					from DDLaboralesEmpleadoRec ddl
                                where ddl.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DLlinea#">
                                  and ddl.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
                                  and ddl.RHPid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Plaza#">)
        </cfquery>
        <!--- ACTTUALIZA LOS DATOS DE LOS COMPONENTEN QUE FUERON RECALCULADOS --->
        <cfquery name="updDDLaboralesEmpleado" datasource="#Arguments.conexion#">
            update DDLaboralesEmpleadoRec
               set
                DDLunidad =
                    (
                        select c.DLTunidades
                          from DLineaTiempoR c
                         where c.LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTid.LTRid#">
                           and c.CSid = DDLaboralesEmpleadoRec.CSid
                    ),
                DDLmontobase =
                    (
                        select c.DLTmonto
                          from DLineaTiempoR c
                         where c.LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTid.LTRid#">
                           and c.CSid = DDLaboralesEmpleadoRec.CSid
                    ),
                DDLmontores =
                    (
                        select c.DLTmonto
                          from DLineaTiempoR c
                         where c.LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTid.LTRid#">
                           and c.CSid = DDLaboralesEmpleadoRec.CSid
                    ),
                DDLmetodoC =
                    (
                        select c.DLTmetodoC
                          from DLineaTiempoR c
                         where c.LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTid.LTRid#">
                           and c.CSid = DDLaboralesEmpleadoRec.CSid
                    ),
                BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
            where DDLaboralesEmpleadoRec.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DLlinea#">
              and DDLaboralesEmpleadoRec.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
              and DDLaboralesEmpleadoRec.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Plaza#">
              and exists
                    (
                        select 1
                          from DLineaTiempoR c
                         where c.LTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLTid.LTRid#">
                           and c.CSid = DDLaboralesEmpleadoRec.CSid
                    )
        </cfquery>
    	<cfreturn true>
    </cffunction>
</cfcomponent>
