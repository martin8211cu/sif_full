<cfcomponent>

	<cffunction name="AF_CambioValorRescate" access="public">
		<cfargument name="AFTRid"   type="numeric" required="yes">
		<cfargument name="Conexion" type="string"  required="no" default="#Session.DSN#">

		<cfquery name="rsRelacion" datasource="#arguments.Conexion#">
			select AFTRtipo, Ecodigo
			from AFTRelacionCambio
			where AFTRid = #arguments.AFTRid#
		</cfquery>
		<cfset LvarAFTRtipo = rsRelacion.AFTRtipo>
		<cfset LvarEcodigo = rsRelacion.Ecodigo>

		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetPeriodoAux" returnvariable="LvarPeriodo"/>
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetMesAux" 	returnvariable="LvarMes"/>

		<cfset LvarPeriodoMesInicial = LvarPeriodo * 100 + LvarMes>

		<cfif LvarMes eq 1>
			<cfset AFTDpermeshasta  = (LvarPeriodo - 1) * 100 + 12>
		<cfelse>
			<cfset AFTDpermeshasta  = LvarPeriodo * 100 + LvarMes - 1>
		</cfif>

		<!--- Validaciones:
			1.  Se debe validar que no existan activos fijos duplicados
			2.  No puede existir un registro en AFTRelacionCambioD donde
					Aid        = relacion.Aid
					Periodo    = relacion.Periodo
					Mes        = relacion.Mes
					AFTRid     <>relacion.AFTRid
					AFTDtipo   = relacion.AFTDtipo
			3.  El valor de rescate no puede ser mayor que el valor de adquisicion
		 --->
		<cfquery name="rsValida1" datasource="#Arguments.Conexion#">
			select d.Aid, count(1) as Cantidad
			  from AFTRelacionCambioD d
			where AFTRid = #arguments.AFTRid#
			group by d.Aid
			having count(1) > 1
		</cfquery>

		<!--- No aplica esta validacion para garantias --->
		<cfif LvarAFTRtipo NEQ 5>
		<cfquery name="rsValida2" datasource="#Arguments.Conexion#">
			select count(1) as Cantidad
			from AFTRelacionCambioD d
			where AFTRid = #arguments.AFTRid#
			  and (
					select count(1)
					from AFTRelacionCambioD d2
					where d2.Aid              = d.Aid
					  and d2.AFTDtipo		  = d.AFTDtipo
					  and d2.AFTDperiodo      = #LvarPeriodo#
					  and d2.AFTDmes          = #LvarMes#
					  and d2.AFTDpermesdesde <> 0
					  and d2.AFTDpermeshasta <> 0
					  and d2.AFTRid          <> #arguments.AFTRid#
				  ) > 0
		</cfquery>
		</cfif>

		<cfquery name="rsValida3" datasource="#Arguments.Conexion#">
			select count(1) as Cantidad
			from AFTRelacionCambioD d
				inner join AFSaldos s
				on s.Aid = d.Aid
				and s.AFSperiodo = #LvarPeriodo#
				and s.AFSmes     = #LvarMes#
			where d.AFTRid         = #arguments.AFTRid#
			  and d.AFTDvalrescate > 0
			  and d.AFTDvalrescate > (s.AFSvaladq - s.AFSdepacumadq)
		</cfquery>

        <cfquery name="rsValida4" datasource="#Arguments.Conexion#">
			select count(1) as Cantidad
			from AFTRelacionCambioD d
			where d.AFMMid IS NULL
            and d.AFTRid = #arguments.AFTRid#
		</cfquery>

		<cfif rsValida1.recordcount GT 0 or (isdefined("rsValida2.Cantidad") and rsValida2.Cantidad GT 0) or rsValida3.Cantidad GT 0  or rsValida4.Cantidad GT 0>
			<cfinclude template="ValorRescateErrores.cfm">
			<cfabort>
		</cfif>

		<cftransaction>
			<!---Cambio valor de rescate--->
			<cfif LvarAFTRtipo EQ 1>
				<cfquery datasource="#Arguments.Conexion#">
					delete from AFTRelacionCambioD
					where AFTRid = #arguments.AFTRid#
					  and AFTDvalrescate = (
						select min(a.Avalrescate)
						from Activos a
						where a.Aid = AFTRelacionCambioD.Aid
						)
				</cfquery>
			</cfif>
			<!---Cambio de descripcion--->
			<cfif LvarAFTRtipo EQ 2>
				<cfquery datasource="#Arguments.Conexion#">
					delete from AFTRelacionCambioD
					where AFTRid = #arguments.AFTRid#
					  and AFTDdescripcion = (
						select min(a.Adescripcion)
						from Activos a
						where a.Aid = AFTRelacionCambioD.Aid
						)
				</cfquery>
			</cfif>
			<!---Cambio valor rescate-Descripcion-Fecha inicio depreciacion--->
			<cfif LvarAFTRtipo EQ 3>
				<cfquery datasource="#Arguments.Conexion#">
					delete from AFTRelacionCambioD
					where AFTRid = #arguments.AFTRid#
					  and AFTDvalrescate = (
						select min(a.Avalrescate)
						from Activos a
						where a.Aid = AFTRelacionCambioD.Aid
						)
					  and AFTDdescripcion = (
						select min(a.Adescripcion)
						from Activos a
						where a.Aid = AFTRelacionCambioD.Aid
						)
					  and AFTDfechainidep  = (
						select min(a.Afechainidep)
						from Activos a
						where a.Aid = AFTRelacionCambioD.Aid
						)
				</cfquery>
			</cfif>
			<!---Cambio Fecha inicio depreciacion--->
			<cfif LvarAFTRtipo EQ 4>
				<cfquery datasource="#Arguments.Conexion#">
					delete from AFTRelacionCambioD
					where AFTRid = #arguments.AFTRid#
					  and AFTDfechainidep = (
						select min(a.Afechainidep)
						from Activos a
						where a.Aid = AFTRelacionCambioD.Aid
						)
				</cfquery>
			</cfif>

<!---Se agrega en cambio de Valores a activo por Garantía RVD 04/06/2014--->

			<cfif LvarAFTRtipo EQ 5>
				<cfquery datasource="#Arguments.Conexion#">
					delete from AFTRelacionCambioD
					where AFTRid = #arguments.AFTRid#
					  and AFMid = (
						select min(a.AFMid)
						from Activos a
						where a.Aid = AFTRelacionCambioD.Aid
						)
                      and AFMMid = (
                      select min(a.AFMMid)
                      from Activos a
                      where a.Aid = AFTRelacionCambioD.Aid
						)
                      and AFCcodigo = (
                      select min(a.AFCcodigo)
                      from Activos a
                      where a.Aid = AFTRelacionCambioD.Aid
						)
					  and Aserie = (
                      select min(a.Aserie)
                      from Activos a
                      where a.Aid = AFTRelacionCambioD.Aid					<!--- JMRV. Para el num de serie. 18/07/2014 --->
						)
            	</cfquery>
        	</cfif>


<!---Termina cambio de Valores a activo por Garantía RVD 04/06/2014---->

			<!--- Obtener el periodo y mes de auxiliares --->
			<cfquery name= "rsActualiza" datasource=#arguments.Conexion#>
				select
					Aid,
					AFTDvalrescate,
					AFTDdescripcion,
					AFTDfechainidep,
                    AFMid,
                    AFMMid,
                    AFCcodigo,
                    AFTRid,
					Aserie,									<!--- JMRV. num de serie. 18/07/2014 --->
					Observaciones							<!--- JMRV. Observaciones. 18/07/2014 --->
				from AFTRelacionCambioD
				where AFTRid = #arguments.AFTRid#
			</cfquery>



			<cfloop query="rsActualiza">

				<cfquery name="Activos" datasource="#arguments.Conexion#">
					select Avalrescate, Adescripcion, Afechainidep, AFMid, AFMMid, AFCcodigo
					from Activos
					where Aid = #rsActualiza.Aid#
				</cfquery>

				<cfquery name="rsExisteAnterior" datasource="#arguments.conexion#">
					select max(AFTDpermesdesde) as PeriodoMesRegistro
					from AFTRelacionCambioD
					where Aid = #rsActualiza.Aid#
					  and AFTDpermeshasta = 999999
				</cfquery>

				<!--- Actualizar:
						- periodo inicial del cambio equivale al periodo actual siempre
						- periodo final del cambio equivale a:
									999999 para el cambio vigente
									periodoinicial - 1 para el cambio anterior
				--->

				<cfif rsExisteAnterior.recordcount GT 0 and len(rsExisteAnterior.PeriodoMesRegistro) NEQ 0>
					<cfquery datasource="#arguments.Conexion#">
						update AFTRelacionCambioD
						set AFTDpermeshasta = #AFTDpermeshasta#
						where Aid = #rsActualiza.Aid#
						and AFTDpermesdesde = #rsExisteAnterior.PeriodoMesRegistro#
						and AFTDpermeshasta = 999999
					</cfquery>
				</cfif>
				<cfquery datasource="#arguments.Conexion#">
					update AFTRelacionCambioD
					set
						Avalrescate         =  #Activos.Avalrescate#,
						Adescripcion        =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#preservesinglequotes(Activos.Adescripcion)#">,
						Afechainidep		=  <cfqueryparam cfsqltype="cf_sql_date"    value="#Activos.Afechainidep#">,
						AFTDtipo            =  #LvarAFTRtipo#,
						AFTDperiodo         =  #LvarPeriodo#,
						AFTDmes             =  #LvarMes#,
						AFTDpermesdesde     =  #LvarPeriodoMesInicial#,
						AFTDpermeshasta     =  999999
					where AFTRid = #arguments.AFTRid#
					  and Aid               =  #rsActualiza.Aid#
				</cfquery>

				<cfif LvarAFTRtipo EQ 1 or LvarAFTRtipo EQ 3>
					<cfquery datasource="#arguments.Conexion#">
						update Activos
						set Avalrescate = #rsActualiza.AFTDvalrescate#
						where Aid = #rsActualiza.Aid#
					</cfquery>
				</cfif>

				<cfif LvarAFTRtipo EQ 2 or LvarAFTRtipo EQ 3>
					<cfquery datasource="#arguments.Conexion#">
						update Activos
						set Adescripcion = '#rsActualiza.AFTDdescripcion#'
						where Aid = #rsActualiza.Aid#
					</cfquery>
				</cfif>
				<cfif LvarAFTRtipo EQ 4>
					<cfquery datasource="#arguments.Conexion#">
						update Activos
						set Afechainidep = <cfqueryparam cfsqltype="cf_sql_date" value="#rsActualiza.AFTDfechainidep#">
						where Aid = #rsActualiza.Aid#
					</cfquery>
				</cfif>

                <cfif LvarAFTRtipo EQ 5><!---Se agrega en cambio de Valores a activo por Garantía RVD 04/06/2014--->

					<!---JMRV. Inicio. Solo garantia, tomar los datos que cambian para colocarlos en "observaciones" en la tabla AFTRelacionCambioD. 18/07/2014 --->

					<cfquery name="registrosPorModificar" datasource="#arguments.Conexion#">
                    	select (select AFMcodigo from AFMarcas where Ecodigo = a.Ecodigo and AFMid = a.AFMid) as MarcaAnterior, 
						(select AFMMcodigo from AFMModelos where Ecodigo = a.Ecodigo and AFMMid = a.AFMMid) as ModeloAnterior, 
						a.AFMid as MarcaAnt, a.AFMMid as ModeloAnt, 
						b.AFMid as MarcaNue, b.AFMMid as ModeloNue, a.Aserie as SerieAnt, b.Aserie as SerieNue
						from Activos a
                                inner join AFTRelacionCambioD b
                            on b.Aid = a.Aid
                            and (b.AFMid != a.AFMid
                            or b.AFMMid != a.AFMMid
                            or b.AFCcodigo != a.AFCcodigo
							or b.Aserie != a.Aserie)
                        where a.Aid = #rsActualiza.Aid#
                        and b.AFTRid = #rsActualiza.AFTRid#
                        and a.Ecodigo = #session.Ecodigo#
                	</cfquery>

					<!---JMRV.Fin. 18/07/2014 --->


					<cfquery datasource="#arguments.Conexion#">
                    	update Activos
						set AFMid = #rsActualiza.AFMid#,
                        AFMMid = #rsActualiza.AFMMid#,
                        AFCcodigo = #rsActualiza.AFCcodigo#,
						Aserie = '#rsActualiza.Aserie#'						<!--- JMRV. num de serie. 18/07/2014 --->
                            from Activos a
                                inner join AFTRelacionCambioD b
                            on b.Aid = a.Aid
                            and (b.AFMid != a.AFMid
                            or b.AFMMid != a.AFMMid
                            or b.AFCcodigo != a.AFCcodigo
							or b.Aserie != a.Aserie)						<!--- JMRV. num de serie. 18/07/2014 --->
                        where a.Aid = #rsActualiza.Aid#
                        and b.AFTRid = #rsActualiza.AFTRid#
                	</cfquery>


					<!---JMRV. Inicio. Solo garantia, para agregar "observaciones" y "anotaciones" en la tabla AFAnotaciones. 18/07/2014 --->

					<cfif registrosPorModificar.recordCount gt 0>

						<cfset AFAfecha2 = '01/01/6100'>

						<cfset parametro = "Anteriores: ">

						<cfif registrosPorModificar.MarcaAnt neq #registrosPorModificar.MarcaNue#>
							<cfset parametro = parametro & "Marca #registrosPorModificar.MarcaAnterior#;">
						</cfif>

						<cfif registrosPorModificar.ModeloAnt neq #registrosPorModificar.ModeloNue#>
							<cfset parametro = parametro & "Modelo #registrosPorModificar.ModeloAnterior#;">
						</cfif>

						<cfif registrosPorModificar.SerieAnt neq #registrosPorModificar.SerieNue#>
							<cfset parametro = parametro & "Serie #registrosPorModificar.SerieAnt#;">
						</cfif>

						<cfset parametro = parametro & "#rsActualiza.Observaciones#">

						<cfquery name="rsInsert" datasource="#session.DSN#">
							insert into AFAnotaciones
							(Ecodigo, Aid, AFAtipo, AFAfecha, AFAtexto, AFAfecha1, AFAfecha2, Observaciones) values (
							#session.Ecodigo#,
							<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsActualiza.Aid#">, 0,
							<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#Now()#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" 	value="Cambio por Garantia">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#Now()#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#lsParseDateTime(AFAfecha2)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#parametro#">)
						</cfquery>
					</cfif><!--- registrosPorModificar.recordCount gt 0 --->

				<!---JMRV.Fin. 18/07/2014 --->


				</cfif><!---Termina cambio de Valores a activo por Garantía RVD 04/06/2014---->
			</cfloop>
			<cfquery datasource="#arguments.Conexion#">
				update AFTRelacionCambio
				 set AFTRaplicado = 1
				 where AFTRid = #arguments.AFTRid#
			</cfquery>
			<cftransaction action="commit"/>
		</cftransaction>
		<cfreturn>
	</cffunction>
</cfcomponent>