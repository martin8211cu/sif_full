<cfcomponent >
	<cffunction name="DistribuirGastoMasivo" access="public" returntype="string" hint="Distribución masiva de gastos para invocar desde un scheduled task">
		<cfargument name="LargDSN"      type="string"  required="yes" hint="Nombre de la conexión a utilizar">
		<cfargument name="LargEcodigo"  type="string" required="yes" hint="Codigo de la Empresa que está invocando">
		<cfargument name="LargCEcodigo" type="string" required="yes" hint="Codigo de la Corporación a la que pertence la empresa que invoca" >

		<cfquery datasource="#session.dsn#" name="rsPeriodo">
			select Pvalor from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargEcodigo#">
			  and Pcodigo = 30
		</cfquery>

		<cfquery datasource="#session.dsn#" name="rsMes">
			select Pvalor from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargEcodigo#">
			  and Pcodigo = 40
		</cfquery>

		<cfif rsPeriodo.recordcount EQ 1 and rsMes.recordcount EQ 1>

			<cfset LvarMesParametros        = rsPeriodo.Pvalor>
			<cfset LvarPeriodoParametros    = rsMes.Pvalor>

			<cfquery name="rsDistribuciones" datasource="#LargDSN#">
					select Criterio, DGCDid, DGCid, DGCiddest
					from DGGastosDistribuir
					where CEcodigo = #LargCEcodigo#
					  and DGCiddest is not null
			</cfquery>

			<cfloop query="rsDistribuciones">
				<cfset LvarResultado = DistribuirGasto(Arguments.LargDSN, Arguments.LargEcodigo, Arguments.LargCEcodigo, rsDistribuciones.DGGDid, LvarPeriodoParametros, LvarMesParametros, true)>
			</cfloop>
		</cfif>

	</cffunction>

	<cffunction name="DistribuirGasto" access="public" returntype="string">
		<cfargument name="LargDSN"      type="string"  required="yes" hint="Nombre de la conexión a utilizar">
		<cfargument name="LargEcodigo"  type="string" required="yes" hint="Codigo de la Empresa que está invocando">
		<cfargument name="LargCEcodigo" type="string" required="yes" hint="Codigo de la Corporación a la que pertence la empresa que invoca" >
		<cfargument name="LargDGGDid"   type="string" required="yes" hint="Gasto (Grupo) a Distribuir">
		<cfargument name="LargPeriodo"  type="string" required="yes" hint="Periodo - Año - que se va a distribuir">
		<cfargument name="LargMes"      type="string" required="yes" hint="Mes que se va a distribuir">
		<cfargument name="LargCalcular" type="boolean" required="yes" hint="Calcular - true - o unicamente ajustar la distribución a realizar cuando se pasa en false">
		
				<cfset LvarEmpresaEliminacion = 242>

				<cfquery name="rsTipoDistribucion" datasource="#Arguments.LargDSN#">
					select Criterio, DGCDid, DGCid, DGCiddest
					from DGGastosDistribuir
					where DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LargDGGDid#">
				</cfquery>

				<cfset CriterioDistribucion = rsTipoDistribucion.Criterio>
				<cfset DGCDid = rsTipoDistribucion.DGCDid>
				<cfset DGCid = rsTipoDistribucion.DGCid>
				<cfset DGCiddest = rsTipoDistribucion.DGCiddest>
		
				<cfset LvarDGDid = -1>
				<cfset LvarCEcodigo = Arguments.LargCEcodigo>
		
				<cfquery name="rsDivisionEmpresa" datasource="#Arguments.LargDSN#">
					select DGDid, CEcodigo
					from DGEmpresasDivision
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargEcodigo#">
				</cfquery>
		
				<cfif isdefined('rsDivisionEmpresa') and rsDivisionEmpresa.recordcount GT 0>
					<cfset LvarDGDid = rsDivisionEmpresa.DGDid>
					<cfset LvarCEcodigo = rsDivisionEmpresa.CEcodigo>
				</cfif>
		
				<cfif LargCalcular>
				
					<!--- 1. Eliminacion de Datos que ya existen --->
					<cfquery datasource="#Arguments.LargDSN#">
						delete from DGGastosxDistribuir
						where Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargPeriodo#">
						  and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargMes#">
						  and DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LargDGGDid#">
					</cfquery>
				
					<!--- 
						2. Inserta DGCGastosxDistribuir 
						Se insertan unicamente los registros que cumplan con las siguientes condiciones:
							1. Departamento está definido en DGDeptosGastosDistribuir para este gasto
							2. El departamento se encuentra en la tabla PCDCatalogoCuenta - cubo de cuentas por catálogo
							3. La cuenta de mayor - tabla CtasMayor - asociada a la cuenta en CContables debe ser de tipo "Gasto"
							4. Debe tener movimientos en la tabla SaldosContables o Presupuesto Asignado
							5. El concepto destino debe ser diferente de null
							6. La empresa no es la empresa de ajustes o el catálogo no está incluido 
							   en la estructura de cuentas a excluir en la consolidacion - DGCuentasConceptoActEli
							7. Debe existir movimientos (debitos - creditos) o debitos en el mes o Presupuesto Asignado
							8. La empresa de la cuenta debe ser de la misma división de la empresa de sesion, variable 
					--->
					<cfquery datasource="#Arguments.LargDSN#">
						insert into DGGastosxDistribuir( 
							 DGGDid, 
							 DGCDid, 
							 DGCid, 
							 DGCiddestino, 
							 Periodo, 
							 Mes, 
							 Criterio, 
							 Departamento, 
							 Empresa, 
							 Ocodigo, 
							 Ccuenta,
							 Debitos,
							 Creditos,
							 DebitosOri,
							 CreditosOri,
							 Presupuesto,
							 PresupuestoOri,
							 montodist 
						)
						select	
							e.DGGDid as Gasto, 
							e.DGCDid,
							e.DGCid,
							e.DGCiddest as ConceptoDestino,
							#Arguments.LargPeriodo# as Periodo,
							#Arguments.LargMes# as Mes,
							#CriterioDistribucion# as Criterio,			
							d.PCDcatid as Depto,
							cta.Ecodigo as Empresa,
							o.Ocodigo as Oficina,
							cta.Ccuenta as Cuenta,

							coalesce(( 
								select sum(s.DLdebitos)
								from SaldosContables s 
								where s.Ccuenta = cta.Ccuenta 
								  and s.Ocodigo = o.Ocodigo
								  and s.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargPeriodo#">
								  and s.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargMes#">
								  ), 0.00) as Debitos,

							coalesce(( 
								select sum(s.CLcreditos)
								from SaldosContables s 
								where s.Ccuenta = cta.Ccuenta 
								  and s.Ocodigo = o.Ocodigo
								  and s.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargPeriodo#">
								  and s.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargMes#">
								  ), 0.00) as Creditos,
		
							coalesce(( 
								select sum(s.DLdebitos)
								from SaldosContables s 
								where s.Ccuenta = cta.Ccuenta 
								  and s.Ocodigo = o.Ocodigo
								  and s.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargPeriodo#">
								  and s.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargMes#">
								  ), 0.00) as DebitosOri,
		
							coalesce(( 
								select sum(s.CLcreditos)
								from SaldosContables s 
								where s.Ccuenta = cta.Ccuenta 
								  and s.Ocodigo = o.Ocodigo
								  and s.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargPeriodo#">
								  and s.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargMes#">
								  ), 0.00) as CreditosOri,
		
							coalesce(( 
								select sum((cp.CPCpresupuestado + cp.CPCmodificado + cp.CPCvariacion + cp.CPCtrasladado)) * case when m.Ctipo = 'I' then -1 else 1 end)
								from CFinanciera cf
										inner join CPresupuestoControl cp 
												on cp.CPcuenta = cf.CPcuenta
											  and cp.Ocodigo  = o.Ocodigo
											  and cp.CPCano   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargPeriodo#">
											  and cp.CPCmes   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargMes#">
										inner join CtasMayor m
											on m.Ecodigo = cf.Ecodigo
											and m.Cmayor = cf.Cmayor
								where cf.Ccuenta = cta.Ccuenta
								  ), 0.00) as Presupuesto,
		
							coalesce(( 
								select sum((cp.CPCpresupuestado + cp.CPCmodificado + cp.CPCvariacion + cp.CPCtrasladado)) * case when m.Ctipo = 'I' then -1 else 1 end)
								from CFinanciera cf
										inner join CPresupuestoControl cp 
												on cp.CPcuenta = cf.CPcuenta
											  and cp.Ocodigo  = o.Ocodigo
											  and cp.CPCano   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargPeriodo#">
											  and cp.CPCmes   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargMes#">
										inner join CtasMayor m
											on m.Ecodigo = cf.Ecodigo
											and m.Cmayor = cf.Cmayor
								where cf.Ccuenta = cta.Ccuenta
								  ), 0.00) as PresupuestoOri,

							coalesce(( 
								select sum(s.DLdebitos - s.CLcreditos)
								from SaldosContables s 
								where s.Ccuenta = cta.Ccuenta 
								  and s.Ocodigo = o.Ocodigo
								  and s.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargPeriodo#">
								  and s.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargMes#">
								  ), 0.00) as MontoDist
		
						from DGGastosDistribuir e
								inner join DGDeptosGastosDistribuir d
										inner join PCDCatalogoCuenta cu
												inner join CContables cta
		
													inner join CtasMayor cm
														 on cm.Cmayor  = cta.Cmayor
														and cm.Ecodigo = cta.Ecodigo
														and cm.Ctipo in ('I', 'G')
		
													inner join Oficinas o
														on o.Ecodigo = cta.Ecodigo
		
												on  cta.Ccuenta = cu.Ccuenta
		
										on cu.PCDcatid = d.PCDcatid	 
								on d.DGGDid = e.DGGDid
						where e.DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LargDGGDid#">
						  and e.DGCiddest is not null
						  and (
							cta.Ecodigo <> #LvarEmpresaEliminacion#
							 or not exists(
								select 1
								from PCDCatalogoCuenta cu2
									inner join DGCuentasConceptoActEli eli
											 on eli.idCat1 = cu2.PCEcatid
											and eli.idCat2 = cu2.PCDcatid
								where cu2.Ccuenta = cu.Ccuenta
								))
		
						  <!---  Solamente sobre empresas definidas en la misma división de la empresa actual --->
						  and exists (
							select 1
							from DGEmpresasDivision ediv
							where ediv.Ecodigo  = cta.Ecodigo
							  and ediv.DGDid    = #LvarDGDid#
							  and ediv.CEcodigo = #LvarCEcodigo#
							)
		
					</cfquery>	
		
					<cfquery name="rsBorrarDatosCero" datasource="#Arguments.LargDSN#">
						delete from DGGastosxDistribuir
						from DGGastosxDistribuir gd
						where gd.DGGDid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LargDGGDid#">
						  and gd.Periodo  = #Arguments.LargPeriodo# 
						  and gd.Mes      = #Arguments.LargMes#
						  and gd.Criterio = #CriterioDistribucion#
						  and (Debitos = 0 and Creditos = 0 and DebitosOri = 0 and CreditosOri = 0 and Presupuesto = 0 and PresupuestoOri = 0)
					</cfquery>
		
				</cfif>
				
				<cfset MontoADistribuir = 0.00>

				<cfquery datasource="#Arguments.LargDSN#" name="rsTotalDistribuir">
					select sum(montodist) as MontoDistribuir, sum(Presupuesto) as PresupuestoDist
					from DGGastosxDistribuir
					where Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargPeriodo#">
					  and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargMes#">
					  and DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LargDGGDid#">
				</cfquery>
		
				<cfif isdefined('rsTotalDistribuir') and len(trim(rsTotalDistribuir.MontoDistribuir)) GT 0>
					<cfset MontoADistribuir = rsTotalDistribuir.MontoDistribuir>
					<cfset PresADistribuir = rsTotalDistribuir.PresupuestoDist>
				</cfif>
		
				<cfquery datasource="#Arguments.LargDSN#">
					delete from DGGastosDistribuidos
					where Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargPeriodo#">
					  and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargMes#">
					  and DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LargDGGDid#">
				</cfquery>
				
				<cfif len(trim(DGCDid)) GT 0>
		
					<!--- Se utiliza un criterio de distribución.  Solo se consideran los valores que tienen datos --->
					<cfquery datasource="#Arguments.LargDSN#">
						insert into DGGastosDistribuidos (
								DGGDid, 
								DGCDid, 
								DGCid, 
								DGCiddestino, 
								Periodo, 
								Mes, 
								Departamento, 
								Empresa, 
								Ocodigo, 
								Criterio, 
								valorcriterio, 
								valortotcriterio, 
								montodist, 
								montoasignado, 
								presdist,
								presasignado,
								trasladoDMF, 
								BMfechaalta, 
								fechaDMF)
					
						select 	
								e.DGGDid,
								e.DGCDid, <!---#DGCDid#,--->
								e.DGCid,
								e.DGCiddest,
								#Arguments.LargPeriodo# as Periodo,
								#Arguments.LargMes# as Mes,
								vd.PCDcatid,
								vd.Ecodigo,
								vd.Ocodigo,
								#CriterioDistribucion# as Criterio,
								vd.Valor,
								0,
								#MontoADistribuir#,
								0,	
								#PresADistribuir#,
								0,
								0,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
								
						from DGGastosDistribuir e												<!--- Gasto --->
								inner join DGGastosActividad d									<!--- Actividades que reciben el Gasto --->
										inner join DGDepartamentosA da							<!--- Departamentos por Actividad      --->
														inner join DGDCriterioDeptoE vd			<!--- Valores de Distribucion - Destino --->
																 on vd.PCEcatid = da.PCEcatid
																and vd.PCDcatid = da.PCDcatid
																and vd.Periodo  = #Arguments.LargPeriodo#
																and vd.Mes      = #Arguments.LargMes#
																and vd.DGCDid   = #DGCDid#
											  on da.DGAid = d.DGAid
								   on d.DGGDid = e.DGGDid
						where e.DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LargDGGDid#">
						  and e.DGCiddest is not null			  
						  and vd.Valor <> 0
		
						  <!---  Solamente sobre empresas definidas en la misma división de la empresa actual --->
						  and exists (
							select 1
							from DGEmpresasDivision ediv
							where ediv.Ecodigo  = vd.Ecodigo
							  and ediv.DGDid    = #LvarDGDid#
							  and ediv.CEcodigo = #LvarCEcodigo#
							)
		
						  <!---  No se distribuye gastos a departamentos que existan como generadores de gastos indirectos --->
						  and not exists(
								select 1
								from DGDeptosGastosDistribuir dg
								where dg.PCDcatid = da.PCDcatid
								  and dg.PCEcatid = da.PCEcatid
								)
					</cfquery>
		
				<cfelseif CriterioDistribucion EQ 40 or CriterioDistribucion EQ 60 or CriterioDistribucion EQ 30 or CriterioDistribucion EQ 50>
		
		
					<!--- 3. Inserta DGCGastosxDistribuir --->
					<cfquery datasource="#Arguments.LargDSN#">
						insert into DGGastosDistribuidos (
								DGGDid, 
								DGCDid, 
								DGCid, 
								DGCiddestino, 
								Periodo, 
								Mes, 
								Departamento, 
								Empresa, 
								Ocodigo, 
								Criterio, 
								valorcriterio, 
								valortotcriterio, 
								montodist, 
								montoasignado, 
								presdist,
								presasignado,
								trasladoDMF, 
								BMfechaalta, 
								fechaDMF)
					
						select 	
								e.DGGDid,
								min(e.DGCDid), 
								e.DGCid,
								e.DGCiddest,
								#Arguments.LargPeriodo# as Periodo,
								#Arguments.LargMes# as Mes,
								da.PCDcatid,
								s.Ecodigo,
								s.Ocodigo,
								#CriterioDistribucion# as Criterio,
								<cfif     CriterioDistribucion EQ 40>
									sum( s.SLinicial + s.DLdebitos - s.CLcreditos),
								<cfelseif CriterioDistribucion EQ 60>
									sum( s.DLdebitos - s.CLcreditos),
								<cfelseif CriterioDistribucion EQ 30>
									sum( s.SPfinal),
								<cfelseif CriterioDistribucion EQ 50>
									sum( s.MLmonto),
								</cfif>
								0,
								#MontoADistribuir#,
								0,	
		
								#PresADistribuir#,
								0,
		
								0,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						
							from DGGastosDistribuir e
							   inner join DGGastosActividad d
								  inner join DGDepartamentosA da
								     inner join PCDCatalogoCuenta cu
									    inner join CContables cc
		                                   inner join DGCuentasConcepto ccon
												on ccon.Cmayor = cc.Cmayor 
											   
		                                   inner join <cfif CriterioDistribucion EQ 40 or CriterioDistribucion EQ 60>SaldosContables s<cfelse>SaldosContablesP s</cfif>
												on s.Ccuenta = cc.Ccuenta
											   and s.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargPeriodo#">
											   and s.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargMes#">
										on cc.Ccuenta = cu.Ccuentaniv
									on cu.PCDcatid = da.PCDcatid
								on da.DGAid = d.DGAid
							on d.DGGDid = e.DGGDid
						where e.DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LargDGGDid#">
						  and e.DGCiddest is not null
						  and ccon.DGCid  = e.DGCid
						  <!---  Solamente sobre empresas definidas en la misma división de la empresa actual --->
						  and exists (
							select 1
							from DGEmpresasDivision ediv
							where ediv.Ecodigo  = cc.Ecodigo
							  and ediv.DGDid    = #LvarDGDid#
							  and ediv.CEcodigo = #LvarCEcodigo#
							)
		
						  <!---  No se distribuye gastos a departamentos que existan como generadores de gastos indirectos --->
						  and not exists(
								select 1
								from DGDeptosGastosDistribuir gd
								where gd.PCDcatid = da.PCDcatid
								  and gd.PCEcatid = da.PCEcatid
								)
						
						group by e.DGGDid,
								 e.DGCid,
								 e.DGCiddest,
								 da.PCDcatid,
								 s.Ecodigo,
								 s.Ocodigo
		
						<cfif     CriterioDistribucion EQ 40>
							having sum( s.SLinicial + s.DLdebitos - s.CLcreditos) <> 0
						<cfelseif CriterioDistribucion EQ 60>
							having sum( s.DLdebitos - s.CLcreditos) <> 0
						<cfelseif CriterioDistribucion EQ 30>
							having sum( s.SPfinal) <> 0
						<cfelseif CriterioDistribucion EQ 50>
							having sum( s.MLmonto) <> 0
						</cfif>
					</cfquery>
		
				<cfelse>
							<cf_errorCode	code = "50372" msg = "Error en el criterio de distribucion definido">
				</cfif>
		
				<!--- Borrar los valores de criterio que estén en cero, porque no se distribuye a estos --->
				<cfquery datasource="#Arguments.LargDSN#">
					delete from DGGastosDistribuidos
					where Periodo       =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargPeriodo#">
					  and Mes           =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargMes#">
					  and DGGDid        =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LargDGGDid#">
					  and valorcriterio = 0
				</cfquery>
		
				<cfquery name="rsValorTotalCriterio" datasource="#Arguments.LargDSN#">
					select sum(valorcriterio) as ValorTotalCriterio
					from DGGastosDistribuidos a
					where Periodo      = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargPeriodo#">
					  and Mes          = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargMes#">
					  and DGGDid       = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LargDGGDid#">
				</cfquery>	
		
				<cfset ValorTotalCriterio = 0.00>
				
				<cfif isdefined('rsValorTotalCriterio') and len(trim(rsValorTotalCriterio.ValorTotalCriterio))>
					<cfset ValorTotalCriterio = rsValorTotalCriterio.ValorTotalCriterio>
				</cfif>
		
				<cfif len(Trim(ValorTotalCriterio)) and ValorTotalCriterio NEQ 0.00>
					<cfquery datasource="#Arguments.LargDSN#">
						update DGGastosDistribuidos
						set 
							valortotcriterio = #ValorTotalCriterio#,
							montoasignado = round( montodist * (valorcriterio / #ValorTotalCriterio#), 2),
							presasignado = round( presdist * (valorcriterio / #ValorTotalCriterio#), 2)
						where Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargPeriodo#">
						  and Mes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargMes#">
						  and DGGDid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LargDGGDid#">		  
						  and valorcriterio is not null 
						  and valorcriterio <> 0
					</cfquery>
				</cfif>
		
				<cfquery name="rsValorTotalDistribuido" datasource="#Arguments.LargDSN#">
					select sum(montoasignado) as ValorTotalDistribuido, sum(presasignado) as PresTotalDistribuido
					from DGGastosDistribuidos a
					where Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargPeriodo#">
					  and Mes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargMes#">
					  and DGGDid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LargDGGDid#">
				</cfquery>
		
				<cfset ValorTotalDistribuido = 0.00>
				<cfset PresTotalDistribuido  = 0.00>
				
				<cfif isdefined('rsValorTotalDistribuido') and len(trim(rsValorTotalDistribuido.ValorTotalDistribuido))>
					<cfset ValorTotalDistribuido = rsValorTotalDistribuido.ValorTotalDistribuido>
				</cfif>
		
				<cfif isdefined('rsValorTotalDistribuido') and len(trim(rsValorTotalDistribuido.PresTotalDistribuido))>
					<cfset PresTotalDistribuido = rsValorTotalDistribuido.PresTotalDistribuido>
				</cfif>
		
				<cfset MontoDiferencia = MontoADistribuir - ValorTotalDistribuido>
				<cfset PresDiferencia  = PresADistribuir - PresTotalDistribuido>
		
				<cfif MontoDiferencia NEQ 0.00 or PresDiferencia NEQ 0.00>
					<!--- Aplicar la diferencia al registro con mayor monto asignado --->
					<cfquery name="rsMayorDistribuicion" datasource="#Arguments.LargDSN#">
						select min(DGGDDid) as DGGDDid
						from DGGastosDistribuidos a
						where a.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargPeriodo#">
						  and a.Mes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargMes#">
						  and a.DGGDid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LargDGGDid#">
						  and a.montoasignado = ((
									select max(montoasignado)
									from DGGastosDistribuidos b
									where b.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargPeriodo#">
									  and b.Mes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargMes#">
									  and b.DGGDid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LargDGGDid#">
									 ))
					</cfquery>
					
					<cfset LvarDGGDDid = rsMayorDistribuicion.DGGDDid>
					
					<cfif len(trim(LvarDGGDDid))>
						<cfquery datasource="#Arguments.LargDSN#">
							update DGGastosDistribuidos 
								set 
									montoasignado  = montoasignado + round(#MontoDiferencia#, 2),
									presasignado   = presasignado  + round(#PresDiferencia#, 2)
							where DGGDDid = #LvarDGGDDid#
						</cfquery>
					
					</cfif>
		
				</cfif>
		
				<!--- Borrar los valores que tiene gastos distribuidos en cero, para no llenar de registros la tabla --->
				<cfquery datasource="#Arguments.LargDSN#">
					delete from DGGastosDistribuidos
					where Periodo         =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargPeriodo#">
					  and Mes             =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargMes#">
					  and DGGDid          =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LargDGGDid#">
					  and montoasignado   = 0
					  and presasignado    = 0
				</cfquery>
		
				<!--- pasar los registros de DGGastosxDistribuir a DGGastosDistribuidos --->
				<cfquery datasource="#Arguments.LargDSN#">
					insert into DGGastosDistribuidos (	DGGDid, 
													DGCDid, 
													DGCid, 
													DGCiddestino, 
													Periodo, 
													Mes, 
													Departamento, 
													Empresa, 
													Ocodigo, 
													Criterio, 
													valorcriterio, 
													valortotcriterio, 
													montodist, 
													montoasignado, 
													trasladoDMF, 
													BMfechaalta, 
													fechaDMF,
													original )
					select	DGGDid, 
							DGCDid, 
							DGCid, 
							DGCiddestino, 
							Periodo, 
							Mes, 
							Departamento, 
							Empresa, 
							Ocodigo, 
							Criterio, 
							0, 
							0, 
							sum(montodist*-1), 
							sum(montodist*-1), 
							0, 
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							1
					from DGGastosxDistribuir
					where Periodo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargPeriodo#">
					  and Mes       = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargMes#">		
					  and DGGDid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LargDGGDid#">		  
					  and montodist <> 0
					group by
							DGGDid, 
							DGCDid, 
							DGCid, 
							DGCiddestino, 
							Periodo, 
							Mes, 
							Departamento, 
							Empresa, 
							Ocodigo, 
							Criterio
		
				</cfquery>
		<cfset myResult="OK">
		<cfreturn myResult>

	</cffunction>

	<cffunction name="EliminaGastosxDistribuir" access="public" returntype="string">
		<cfargument name="LargDSN"      type="string"  required="yes" hint="Nombre de la conexión a utilizar">
		<cfargument name="LargEcodigo"  type="string" required="yes" hint="Codigo de la Empresa que está invocando">
		<cfargument name="LargCEcodigo" type="string" required="yes" hint="Codigo de la Corporación a la que pertence la empresa que invoca" >
		<cfargument name="LargDGGDid"   type="string" required="yes" hint="Gasto (Grupo) a Distribuir">
		<cfargument name="LargPeriodo"  type="string" required="yes" hint="Periodo - Año - que se va a distribuir">
		<cfargument name="LargMes"      type="string" required="yes" hint="Mes que se va a distribuir">

		<cftransaction>

			<!--- Invocar a la funcion EliminaGastosDistribuidos --->
			<cfset lvarReturnVar = EliminaGastosDistribuidos(	Arguments.LargDSN, 	
																Arguments.LargEcodigo, 
																Arguments.LargCEcodigo, 
																Arguments.LargDGGDid, 
																Arguments.LargPeriodo, 
																Arguments.LargMes)>

			<!--- Eliminacion de Datos de Gastos a distribuir--->
			<cfquery datasource="#Arguments.LargDSN#">
				delete from DGGastosxDistribuir
				where Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargPeriodo#">
				  and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargMes#">
				  and DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LargDGGDid#">
			</cfquery>
		</cftransaction>
		<cfreturn "OK">


	</cffunction>

	<cffunction name="EliminaGastosDistribuidos" access="public" returntype="string">
		<cfargument name="LargDSN"      type="string"  required="yes" hint="Nombre de la conexión a utilizar">
		<cfargument name="LargEcodigo"  type="string" required="yes" hint="Codigo de la Empresa que está invocando">
		<cfargument name="LargCEcodigo" type="string" required="yes" hint="Codigo de la Corporación a la que pertence la empresa que invoca" >
		<cfargument name="LargDGGDid"   type="string" required="yes" hint="Gasto (Grupo) a Distribuir">
		<cfargument name="LargPeriodo"  type="string" required="yes" hint="Periodo - Año - que se va a distribuir">
		<cfargument name="LargMes"      type="string" required="yes" hint="Mes que se va a distribuir">>

			<!--- Eliminacion de Datos de Gastos Distribuidos--->
			<cfquery datasource="#Arguments.LargDSN#">
				delete from DGGastosDistribuidos
				where Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargPeriodo#">
				  and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LargMes#">
				  and DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LargDGGDid#">
			</cfquery>
		<cfreturn "OK">
	</cffunction>
	
	
</cfcomponent>

