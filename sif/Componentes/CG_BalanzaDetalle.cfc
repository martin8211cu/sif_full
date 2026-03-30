
<!--- 
	Modificado por Gustavo Fonseca H.	
		Fecha: 9-11-2005.
		Motivo: Se limita el reporte a 12000 registros.
	Modificado por danim, 31-Ene-2006
		Se quita el limitante de 12000 registros.
		Se pone opcional el update para el acumulado.
 --->

<cfcomponent>
 	
	<!--- Balanza a Detalle --->
	<cffunction name="balanzaDetalle" access="public" output="true" returntype="numeric">
		<cfargument name="Ecodigo" 			 type="numeric" required="yes">
		<cfargument name="periodo1" 		 type="numeric" required="yes">
		<cfargument name="mes1" 			 type="numeric" required="yes">
		<cfargument name="periodo2" 		 type="numeric" required="no">
		<cfargument name="mes2" 			 type="numeric" required="no">
		<cfargument name="cuentaini" 		 type="string" default="">
		<cfargument name="cuentafin" 		 type="string" default="">
		<cfargument name="fechaini" 		 type="date">
		<cfargument name="fechafin"			 type="date">
		<cfargument name="Ocodigo" 		     type="numeric" default="-1">
		<cfargument name="conexion" 		 type="string" required="false" default="#Session.DSN#">
		<cfargument name="Mcodigo" 			 type="numeric" required="true"  default="-1">
		<cfargument name="calcularAcumulado" type="boolean" required="yes" default="yes">
		<cfargument name="Ordenamiento" 	 type="string" required="false" default="0">
		<cfargument name="MesCierre" 	  	 type="numeric" required="false" default="0">
		<cfargument name="sinMovimientos" 	 type="boolean" required="false" default="true">
		<!--- Creación del Encabezado del Reporte --->
		<cfset idBalDetalle = 0>
		<cftransaction>
			<cfquery name="rsEncabezado" datasource="#Arguments.conexion#">
				insert into CGRBalanzaDetalle (SessionID, Ecodigo, Usucodigo, fechareporte, BMUsucodigo)
				values (
					#session.monitoreo.SessionID#, 
					#Arguments.Ecodigo#, 
					#Session.Usucodigo#, 
					<cf_dbfunction name="now">, 
					#Session.Usucodigo#
				)
				<cf_dbidentity1 datasource="#Arguments.conexion#">
			</cfquery>
			<cf_dbidentity2 datasource="#arguments.conexion#" name="rsEncabezado">
			<cfset idBalDetalle = rsEncabezado.identity>
		</cftransaction>
		
		<cfif isdefined("idBalDetalle") and Len(Trim(idBalDetalle))>
			<cfset LvarCHKMesCierre = arguments.MesCierre>

			<cfquery name="rsMesCierreConta" datasource="#arguments.conexion#">
				select Pvalor
				from Parametros
				where Ecodigo = #arguments.Ecodigo#
				and Pcodigo = 45
			</cfquery>
			

			<cfif rsMesCierreConta.Pvalor NEQ arguments.mes1 and arguments.MesCierre EQ "1">
				<cfset LvarCHKMesCierre = "0">
			</cfif>
		
			<!--- Inserta una línea por cada cuenta para obtener los saldos de inicio --->
			<cfquery name="ECuentas" datasource="#Arguments.conexion#">
				insert into DCGRBalanzaDetalle (CGRBDid, IDcontable, Dlinea, Ecodigo, Ccuenta, saldoini, Eperiodo, Emes, Efecha, acumulado, BMUsucodigo)
				select 
						#idBalDetalle#,
					   -10, 
					   -10, 
					   b.Ecodigo, 
					   b.Ccuenta, 
					   coalesce(
					   		coalesce((
									<cfif isdefined("Arguments.Mcodigo") and Len(Trim(Arguments.Mcodigo)) and Arguments.Mcodigo NEQ -1>
										<cfif not LvarCHKMesCierre>
											select sum(SOinicial)
										<cfelse>
											select sum(SOinicial + DOdebitos - COcreditos)
										</cfif>
									<cfelse>
										<cfif not LvarCHKMesCierre>
											select sum(SLinicial)
										<cfelse>
											select sum(SLinicial + DLdebitos - CLcreditos)						  
										</cfif>
									</cfif>
									  from SaldosContables s
									  where s.Ecodigo  = b.Ecodigo
										and s.Ccuenta  = b.Ccuenta
										and s.Speriodo = #Arguments.periodo1#
										and s.Smes     = #Arguments.mes1#
										<cfif isdefined("Arguments.Ocodigo") and Len(Trim(Arguments.Ocodigo)) and Arguments.Ocodigo NEQ -1>
										   and s.Ocodigo = #Arguments.Ocodigo#
										</cfif>
										<cfif isdefined("Arguments.Mcodigo") and Len(Trim(Arguments.Mcodigo)) and Arguments.Mcodigo NEQ -1>
										   and s.Mcodigo = #Arguments.Mcodigo#
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
										and d.Eperiodo = #Arguments.periodo1#
										and d.Emes = #Arguments.mes1#
										<cfif isdefined("Arguments.Ocodigo") and Len(Trim(Arguments.Ocodigo)) and Arguments.Ocodigo NEQ -1>
										  and d.Ocodigo = #Arguments.Ocodigo#
										</cfif>
										<cfif isdefined("Arguments.Mcodigo") and Len(Trim(Arguments.Mcodigo)) and Arguments.Mcodigo NEQ -1>
										  and d.Mcodigo = #Arguments.Mcodigo#
										</cfif>
									    and e.IDcontable = d.IDcontable
									    and e.Efecha < <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.fechaini#">
										), 0.00)
							</cfif>
							, 0.00),
					   #Arguments.periodo1#,   <!---Primer periodo de parametros--->
					   #Arguments.mes1#,       <!---Primer mes de parametros    --->
					   <cfif isdefined("Arguments.fechaini") and Len(Trim(Arguments.fechaini))>   <!---Fecha de parametros o primer dia del mes inicial si no viene--->
						   <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Arguments.fechaini#">,
					   <cfelse>
						   <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#CreateDate(Arguments.periodo1, Arguments.mes1, 1)#">,
					   </cfif>
					
					   0.00,
					   #Session.Usucodigo#
				from CContables b <cf_dbforceindex name="CContables_UI01">
				where b.Ecodigo = #Arguments.Ecodigo#
				<cfif isdefined("Arguments.cuentaini") and Len(Trim(Arguments.cuentaini)) and isdefined("Arguments.cuentafin") and Len(Trim(Arguments.cuentafin))>
				  and b.Cformato >= '#Arguments.cuentaini#'
				  and b.Cformato <= '#Arguments.cuentafin#'
				  and b.Cformato between '#Arguments.cuentaini#' and '#Arguments.cuentafin#'
				<cfelseif isdefined("Arguments.cuentaini") and Len(Trim(Arguments.cuentaini))>
				  and b.Cformato >= '#Arguments.cuentaini#'
				<cfelseif isdefined("Arguments.cuentafin") and Len(Trim(Arguments.cuentafin))>
				  and b.Cformato <= '#Arguments.cuentafin#'
				</cfif>
				  and b.Cmovimiento = 'S'
				  <!--- Cuando no se desea presentar información en cero --->
				  <cfif isdefined('Arguments.sinMovimientos') and Arguments.sinMovimientos>
				  and exists(
				  		select 1
						from SaldosContables sald
						where sald.Ccuenta = b.Ccuenta
						<cfif Arguments.periodo1 EQ Arguments.periodo2>
							and sald.Speriodo = #Arguments.periodo1#
							<cfif Arguments.mes1 EQ Arguments.mes2>
								and sald.Smes = #Arguments.mes1#
							<cfelse>
								and sald.Smes >= #Arguments.mes1#
								and sald.Smes <= #Arguments.mes2#
							</cfif>
						<cfelse>
							and sald.Speriodo >= #Arguments.periodo1#
							and sald.Speriodo <= #Arguments.periodo2#
							and (sald.Speriodo * 100 + sald.Smes) between <cfqueryparam cfsqltype="cf_sql_integer" value="#(Arguments.periodo1*100)+Arguments.mes1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#(Arguments.periodo2*100)+Arguments.mes2#">
						</cfif>
						<cfif isdefined("Arguments.Ocodigo") and Len(Trim(Arguments.Ocodigo)) and Arguments.Ocodigo NEQ -1>
						    and sald.Ocodigo = #Arguments.Ocodigo#
						</cfif>
						<cfif isdefined("Arguments.Mcodigo") and Len(Trim(Arguments.Mcodigo)) and Arguments.Mcodigo NEQ -1>
						    and sald.Mcodigo = #Arguments.Mcodigo#
						</cfif>
						)
					</cfif>
				order by b.Cmayor, b.Cformato
			</cfquery>
			
			<cfquery datasource="#arguments.conexion#">
				update DCGRBalanzaDetalle
				set debitos     = 0.00,
					creditos    = 0.00,
					acumulado   = saldoini,
					montoorigen = saldoini
				where CGRBDid =#idBalDetalle#
			</cfquery>
		
		
			<!---- Cambio para procesar la inserción de los asientos del reporte por cuenta incluida ---->
			<cfquery name="rsCuentasInsertadas" datasource="#arguments.conexion#">
				select Ccuenta, saldoini
				from DCGRBalanzaDetalle
				where CGRBDid = #idBalDetalle#
				order by DCGRBDlinea
			</cfquery>
			
					
			<cfloop query="rsCuentasInsertadas">

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
						#idBalDetalle#,
						c.IDcontable, 
						c.Dlinea, 
						c.Ecodigo, 
						#rsCuentasInsertadas.Ccuenta#, 
						#rsCuentasInsertadas.saldoini#, 
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
						0.00,
						#Session.Usucodigo#

					from HDContables c <cf_dbforceindex name="HDContables_ID02">

						inner join HEContables d <cf_dbforceindex name="HEContables_PK">
							on d.IDcontable = c.IDcontable
							<cfif not LvarCHKMesCierre>
								and d.ECtipo <> 1
							<cfelse>
								and d.ECtipo = 1
							</cfif>

					where c.Ccuenta = #rsCuentasInsertadas.Ccuenta#

					<cfif Arguments.periodo1 eq Arguments.periodo2>
						and c.Eperiodo = #Arguments.periodo1#
						<cfif Arguments.mes1 eq Arguments.mes2>
							and c.Emes = #Arguments.mes1#
						<cfelse>
							and c.Emes >= #Arguments.mes1#
							and c.Emes <= #Arguments.mes2#
						</cfif>

					<cfelse>
						and c.Eperiodo >= #Arguments.periodo1#
						and c.Eperiodo <= #Arguments.periodo2#
						and (c.Eperiodo * 100 + c.Emes) between <cfqueryparam cfsqltype="cf_sql_integer" value="#(Arguments.periodo1*100)+Arguments.mes1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#(Arguments.periodo2*100)+Arguments.mes2#">
					</cfif>

					<cfif isdefined("Arguments.Ocodigo") and Len(Trim(Arguments.Ocodigo)) and Arguments.Ocodigo NEQ -1>
						and c.Ocodigo = #Arguments.Ocodigo#
					</cfif>

					<cfif isdefined("Arguments.Mcodigo") and Len(Trim(Arguments.Mcodigo)) and Arguments.Mcodigo NEQ -1>
						and c.Mcodigo = #Arguments.Mcodigo#
					</cfif>

					<cfif isdefined("Arguments.fechaini") and Len(Trim(Arguments.fechaini)) GT 0>
						and d.Efecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.fechaini#">
					</cfif>

					<cfif isdefined("Arguments.fechafin") and Len(Trim(Arguments.fechafin)) GT 0>
						and d.Efecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.fechafin#">
					</cfif>

					order by c.Eperiodo, c.Emes, d.Efecha, c.Cconcepto, c.Ddocumento
				</cfquery>	
				
				
				<cfif Arguments.calcularAcumulado>
				
				<!--- esto se podría pasar al app.server para no hacer el update. --->
				<cfquery name="updAcumulado" datasource="#arguments.conexion#">
					update DCGRBalanzaDetalle set 
						acumulado = 
							DCGRBalanzaDetalle.saldoini 
							+ coalesce((
								select sum(debitos-creditos)
								from DCGRBalanzaDetalle b
								where b.CGRBDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idBalDetalle#">
								  and b.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentasInsertadas.Ccuenta#">
								  and b.CGRBDid = DCGRBalanzaDetalle.CGRBDid
								  and b.Ccuenta = DCGRBalanzaDetalle.Ccuenta
								  and b.DCGRBDlinea <= DCGRBalanzaDetalle.DCGRBDlinea)
							, 0.00)
					where CGRBDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idBalDetalle#">
					  and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentasInsertadas.Ccuenta#">
				</cfquery>
				</cfif>

			</cfloop>

		</cfif>

		<cfreturn idBalDetalle>
	</cffunction>
</cfcomponent>
