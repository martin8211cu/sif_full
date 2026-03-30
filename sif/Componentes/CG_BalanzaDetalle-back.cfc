<!--- 
	Modificado por Gustavo Fonseca H.	
		Fecha: 9-11-2005.
		Motivo: Se limita el reporte a 12000 registros.
 --->

<cfcomponent>
 	
	<!--- Balanza a Detalle --->
	<cffunction name="balanzaDetalle" access="public" output="true" returntype="numeric">
		<cfargument name="Ecodigo" type="numeric" required="yes">
		<cfargument name="periodo1" type="numeric" required="yes">
		<cfargument name="mes1" type="numeric" required="yes">
		<cfargument name="periodo2" type="numeric" required="no">
		<cfargument name="mes2" type="numeric" required="no">
		<cfargument name="cuentaini" type="string" default="">
		<cfargument name="cuentafin" type="string" default="">
		<cfargument name="fechaini" type="date">
		<cfargument name="fechafin" type="date">
		<cfargument name="Ocodigo" type="numeric" default="-1">
		<cfargument name="conexion" type="string" required="false" default="#Session.DSN#">
		<cfargument name="Mcodigo" type="numeric" required="true"  default="-1">
		
		<!--- Creación del Encabezado del Reporte --->
		<cfset idBalDetalle = 0>
		<cftransaction>
			<cfquery name="rsEncabezado" datasource="#Arguments.conexion#">
				insert into CGRBalanzaDetalle (SessionID, Ecodigo, Usucodigo, fechareporte, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.SessionID#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				)
				<cf_dbidentity1 datasource="#Arguments.conexion#">
			</cfquery>
			<cf_dbidentity2 datasource="#arguments.conexion#" name="rsEncabezado">
			<cfset idBalDetalle = rsEncabezado.identity>
		</cftransaction>
		
		<cfif isdefined("idBalDetalle") and Len(Trim(idBalDetalle))>
			<!--- Inserta una línea por cada cuenta primero para obtener los saldos de inicio --->
			<cfquery name="ECuentas" datasource="#Arguments.conexion#">
				insert into DCGRBalanzaDetalle (CGRBDid, IDcontable, Dlinea, Ecodigo, Ccuenta, saldoini, Eperiodo, Emes, Efecha, Cconcepto, Ocodigo, montoorigen, debitos, creditos, acumulado, BMUsucodigo)
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#idBalDetalle#">,
					   -10, 
					   -10, 
					   b.Ecodigo, 
					   b.Ccuenta, 
					   coalesce(
					   		coalesce((
									<cfif isdefined("Arguments.Mcodigo") and Len(Trim(Arguments.Mcodigo)) and Arguments.Mcodigo NEQ -1>
									  select sum(SOinicial)
									<cfelse>
									  select sum(SLinicial)
									</cfif>
									  from SaldosContables s
									  where s.Ecodigo = b.Ecodigo
										and s.Ccuenta = b.Ccuenta
										and s.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.periodo1#">
										and s.Smes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.mes1#">
										<cfif isdefined("Arguments.Ocodigo") and Len(Trim(Arguments.Ocodigo)) and Arguments.Ocodigo NEQ -1>
										   and s.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ocodigo#">
										</cfif>
										<cfif isdefined("Arguments.Mcodigo") and Len(Trim(Arguments.Mcodigo)) and Arguments.Mcodigo NEQ -1>
										   and s.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#">
										</cfif>
										
										), 0.00)
							<cfif isdefined("Arguments.fechaini") and Len(Trim(Arguments.fechaini))>   <!--- and Day(Arguments.fechaini) NEQ 1 --->
							+ coalesce((
										select 
										<cfif isdefined("Arguments.Mcodigo") and Len(Trim(Arguments.Mcodigo)) and Arguments.Mcodigo NEQ -1>
											sum(case when Dmovimiento = 'D' then Doriginal else Doriginal * -1 end) 
										<cfelse>
											sum(case when Dmovimiento = 'D' then Dlocal else Dlocal * -1 end) 
										</cfif>
										from HDContables d, HEContables e
										where d.Ecodigo = b.Ecodigo
										and d.Ccuenta = b.Ccuenta
										and d.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.periodo1#">
										and d.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.mes1#">
										<cfif isdefined("Arguments.Ocodigo") and Len(Trim(Arguments.Ocodigo)) and Arguments.Ocodigo NEQ -1>
										  and d.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ocodigo#">
										</cfif>
										<cfif isdefined("Arguments.Mcodigo") and Len(Trim(Arguments.Mcodigo)) and Arguments.Mcodigo NEQ -1>
										  and d.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#">
										</cfif>
									    and e.IDcontable = d.IDcontable
									    and e.Efecha < <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.fechaini#">
										), 0.00)
							</cfif>
							, 0.00),
					   <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.periodo1#">,     -- Primer periodo de parametros
					   <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.mes1#">,        -- Primer mes de parametros
					   <cfif isdefined("Arguments.fechaini") and Len(Trim(Arguments.fechaini))>   -- Fecha de parametros o primer dia del mes inicial si no viene
						   <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.fechaini#">,
					   <cfelse>
							<cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(Arguments.periodo1, Arguments.mes1, 1)#">,
					   </cfif>
					   null, 
					   null,      --- Oficina seleccionada o nulo si no hay seleccion
					   null,
					   null,
					   null,
					   0.00,
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				from CContables b (index CContables_03)
				where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				<cfif isdefined("Arguments.cuentaini") and Len(Trim(Arguments.cuentaini)) and isdefined("Arguments.cuentafin") and Len(Trim(Arguments.cuentafin))>
				  and b.Cformato >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.cuentaini#">
				  and b.Cformato <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.cuentafin#">
				  and b.Cformato between <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.cuentaini#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.cuentafin#">
				<cfelseif isdefined("Arguments.cuentaini") and Len(Trim(Arguments.cuentaini))>
				  and b.Cformato >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.cuentaini#">
				<cfelseif isdefined("Arguments.cuentafin") and Len(Trim(Arguments.cuentafin))>
				  and b.Cformato <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.cuentafin#">
				</cfif>
				  and b.Cmovimiento = 'S'
				order by b.Cmayor, b.Cformato
			</cfquery>
		
			<!--- Inserta el Detalle --->
			<cfquery name="DCuentas" datasource="#arguments.conexion#">
				insert into DCGRBalanzaDetalle (
					CGRBDid, 
					IDcontable, 
					Dlinea, 
					Ecodigo, 
					Ccuenta, 
					saldoini, 
					Eperiodo, 
					Emes, 
					Efecha, 
					Cconcepto, 
					Ocodigo, 
					montoorigen, 
					debitos, 
					creditos, 
					acumulado, 
					BMUsucodigo)
				select 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#idBalDetalle#">,
					c.IDcontable, 
					c.Dlinea, 
					c.Ecodigo, 
					b.Ccuenta, 
					b.saldoini, 
					c.Eperiodo, 
					c.Emes, 
					d.Efecha, 
					c.Cconcepto, 
					c.Ocodigo,
					c.Doriginal,
					<cfif isdefined("Arguments.Mcodigo") and Len(Trim(Arguments.Mcodigo)) and Arguments.Mcodigo NEQ -1>
						case when c.Dmovimiento = 'D' then c.Doriginal else 0.00 end,
						case when c.Dmovimiento = 'C' then c.Doriginal else 0.00 end,
					<cfelse>
						case when c.Dmovimiento = 'D' then c.Dlocal else 0.00 end,
						case when c.Dmovimiento = 'C' then c.Dlocal else 0.00 end,
					</cfif>
					b.saldoini,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">

				from DCGRBalanzaDetalle b (index FK_DCGRBalanzaDetalle01)

					inner join HDContables c (index HDContables_Index1)
						 on c.Ccuenta = b.Ccuenta
						<cfif Arguments.periodo1 eq Arguments.periodo2>
							and c.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.periodo1#">

							<cfif Arguments.mes1 eq Arguments.mes2>
								and c.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.mes1#">
							<cfelse>
								and c.Emes >= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.mes1#">
								and c.Emes <= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.mes2#">
							</cfif>

						<cfelse>
							and c.Eperiodo >= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.periodo1#">
							and c.Eperiodo <= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.periodo2#">
							and (c.Eperiodo * 100 + c.Emes) between <cfqueryparam cfsqltype="cf_sql_integer" value="#(Arguments.periodo1*100)+Arguments.mes1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#(Arguments.periodo2*100)+Arguments.mes2#">

						</cfif>

						<cfif isdefined("Arguments.Ocodigo") and Len(Trim(Arguments.Ocodigo)) and Arguments.Ocodigo NEQ -1>
							and c.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ocodigo#">
						</cfif>

						<cfif isdefined("Arguments.Mcodigo") and Len(Trim(Arguments.Mcodigo)) and Arguments.Mcodigo NEQ -1>
							and c.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Mcodigo#">
						</cfif>

					inner join HEContables d (index PK_HECONTABLES)
						on d.IDcontable = c.IDcontable
						<cfif isdefined("Arguments.fechaini") and Len(Trim(Arguments.fechaini)) GT 0>
							and d.Efecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.fechaini#">
						</cfif>
						<cfif isdefined("Arguments.fechafin") and Len(Trim(Arguments.fechafin)) GT 0>
							and d.Efecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.fechafin#">
						</cfif>

				where b.CGRBDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idBalDetalle#">   --- Llave de encabezado

				order by c.Ccuenta, c.Eperiodo, c.Emes, d.Efecha, c.Cconcepto, c.Ddocumento
			</cfquery>		
		</cfif>
		<cfquery name="rsValida" datasource="#arguments.conexion#">
			select count(1) as valida
			from DCGRBalanzaDetalle
			where CGRBDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idBalDetalle#">   --- Llave de encabezado
		</cfquery>
		
		<cfif isdefined("rsValida") and rsValida.valida gt 20000>
			<cf_errorCode	code = "51039"
							msg  = "Se han procesado mas de 20000 registros (@errorDat_1@)."
							errorDat_1="#rsValida.valida#"
			>
			<cf_abort errorInterfaz="">		
			
		<cfelse>
		
			<cfquery name="updAcumulado" datasource="#arguments.conexion#">
				update DCGRBalanzaDetalle set 
					acumulado = 
						DCGRBalanzaDetalle.saldoini 
						+ coalesce((
							select sum(debitos-creditos)
							from DCGRBalanzaDetalle b
							where b.CGRBDid = DCGRBalanzaDetalle.CGRBDid
							  and b.Ccuenta = DCGRBalanzaDetalle.Ccuenta
							  and b.DCGRBDlinea <= DCGRBalanzaDetalle.DCGRBDlinea)
						, 0.00)
				where CGRBDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idBalDetalle#">
			</cfquery>
		</cfif>

		<cfreturn idBalDetalle>
	</cffunction>
</cfcomponent>

