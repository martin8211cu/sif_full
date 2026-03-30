<cfif not isdefined("url.chk")>
	<cflocation url="gastosDistribuir-verificacion.cfm?periodo=#url.periodo#&mes=#url.mes#">
</cfif>

<cfset EmpresaEliminacion = 242>

<cfif isdefined("url.btnAplicar") or isdefined("url.btnAjustar")>
	<cfloop list="#url.chk#" index="i">

		<cfquery name="rsTipoDistribucion" datasource="#session.DSN#">
			select Criterio, DGCDid, DGCid, DGCiddest
			from DGGastosDistribuir
			where DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
		</cfquery>
		
		<cfset CriterioDistribucion = rsTipoDistribucion.Criterio>
		<cfset DGCDid = rsTipoDistribucion.DGCDid>
		<cfset DGCid = rsTipoDistribucion.DGCid>
		<cfset DGCiddest = rsTipoDistribucion.DGCiddest>

		<cfset LvarDGDid = -1>
		<cfset LvarCEcodigo = -1>

		<cfquery name="rsDivisionEmpresa" datasource="#session.DSN#">
			select DGDid, CEcodigo
			from DGEmpresasDivision
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>

		<cfif isdefined('rsDivisionEmpresa') and rsDivisionEmpresa.recordcount GT 0>
			<cfset LvarDGDid = rsDivisionEmpresa.DGDid>
			<cfset LvarCEcodigo = rsDivisionEmpresa.CEcodigo>
		</cfif>

		<!--- 1. Eliminacion de Datos que ya existen --->

		<cfif isdefined("url.btnAplicar")>
		
		
			<cfquery datasource="#session.DSN#">
				delete from DGGastosxDistribuir
				where Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
				  and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
				  and DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
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
			
			<cfquery datasource="#session.DSN#">
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
					min(e.DGCDid),
					min(e.DGCid),
					min(e.DGCiddest) as ConceptoDestino,
					#url.periodo# as Periodo,
					#url.mes# as Mes,
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
						  and s.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
						  and s.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
						  ), 0.00) as Debitos,

					coalesce(( 
						select sum(s.CLcreditos)
						from SaldosContables s 
						where s.Ccuenta = cta.Ccuenta 
						  and s.Ocodigo = o.Ocodigo
						  and s.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
						  and s.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
						  ), 0.00) as Creditos,

					coalesce(( 
						select sum(s.DLdebitos)
						from SaldosContables s 
						where s.Ccuenta = cta.Ccuenta 
						  and s.Ocodigo = o.Ocodigo
						  and s.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
						  and s.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
						  ), 0.00) as DebitosOri,

					coalesce(( 
						select sum(s.CLcreditos)
						from SaldosContables s 
						where s.Ccuenta = cta.Ccuenta 
						  and s.Ocodigo = o.Ocodigo
						  and s.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
						  and s.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
						  ), 0.00) as CreditosOri,

					coalesce(( 
						select sum((cp.CPCpresupuestado + cp.CPCmodificado + cp.CPCvariacion + cp.CPCtrasladado) * case when m.Ctipo = 'I' then -1 else 1 end)
						from CFinanciera cf
								inner join CPresupuestoControl cp 
										on cp.CPcuenta = cf.CPcuenta
									  
									  and cp.CPCano   = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
									  and cp.CPCmes   = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
								inner join CtasMayor m
									on m.Ecodigo = cf.Ecodigo
									and m.Cmayor = cf.Cmayor
						where cf.Ccuenta = cta.Ccuenta
						and cp.Ocodigo  = o.Ocodigo
						  ), 0.00) as Presupuesto,

					coalesce(( 
						select sum((cp.CPCpresupuestado + cp.CPCmodificado + cp.CPCvariacion + cp.CPCtrasladado) * case when m.Ctipo = 'I' then -1 else 1 end)
						from CFinanciera cf
								inner join CPresupuestoControl cp 
										on cp.CPcuenta = cf.CPcuenta
									 
									  and cp.CPCano   = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
									  and cp.CPCmes   = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
								inner join CtasMayor m
									on m.Ecodigo = cf.Ecodigo
									and m.Cmayor = cf.Cmayor
						where cf.Ccuenta = cta.Ccuenta
						  and cp.Ocodigo  = o.Ocodigo
						  ), 0.00) as PresupuestoOri,

					coalesce(( 
						select sum(s.DLdebitos - s.CLcreditos)
						from SaldosContables s 
						where s.Ccuenta = cta.Ccuenta 
						  and s.Ocodigo = o.Ocodigo
						  and s.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
						  and s.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
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
				where e.DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
				  and e.DGCiddest is not null
				  and (
				  	cta.Ecodigo <> #EmpresaEliminacion#
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
				group by e.DGGDid, 
						 d.PCDcatid,
						 cta.Ecodigo,
						 o.Ocodigo,
						 cta.Ccuenta

			</cfquery>	

			<cfquery name="rsBorrarDatosCero" datasource="#Session.DSN#">
				delete from DGGastosxDistribuir
				where DGGDid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
				  and Periodo  = #url.periodo# 
				  and Mes      = #url.mes#
				  and Criterio = #CriterioDistribucion#
				  and Debitos = 0
				  and Creditos = 0
				  and DebitosOri = 0
				  and CreditosOri = 0
				  and Presupuesto = 0
				  and PresupuestoOri = 0
			</cfquery>

		</cfif>
		
		<cfquery datasource="#session.DSN#" name="rsTotalDistribuir">
			select sum(montodist) as MontoDistribuir, sum(Presupuesto) as PresupuestoDist
			from DGGastosxDistribuir
			where Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
			  and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
			  and DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
		</cfquery>

		<cfset MontoADistribuir = 0.00>
		<cfset PresADistribuir = 0.00>
		<cfif isdefined('rsTotalDistribuir') and len(trim(rsTotalDistribuir.MontoDistribuir)) GT 0>
			<cfset MontoADistribuir = rsTotalDistribuir.MontoDistribuir>
			<cfset PresADistribuir = rsTotalDistribuir.PresupuestoDist>
		</cfif>

		<cfquery datasource="#session.DSN#">
			delete from DGGastosDistribuidos
			where Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
			  and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
			  and DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
		</cfquery>
		
		<cfif len(trim(DGCDid)) GT 0>

			<!--- Se utiliza un criterio de distribución.  Solo se consideran los valores que tienen datos --->
			<cfquery datasource="#session.DSN#">
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
						#url.periodo# as Periodo,
						#url.mes# as Mes,
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
														and vd.Periodo  = #url.periodo#
														and vd.Mes      = #url.mes#
														and vd.DGCDid   = #DGCDid#
									  on da.DGAid = d.DGAid
						   on d.DGGDid = e.DGGDid
				where e.DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
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
			<cfquery datasource="#session.DSN#">
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
						min(e.DGCDid), <!---#DGCDid#,--->
						e.DGCid,
						e.DGCiddest,
						#url.periodo# as Periodo,
						#url.mes# as Mes,
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
														   and s.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
														   and s.Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
														   
												on cc.Ccuenta = cu.Ccuentaniv
										on cu.PCDcatid = da.PCDcatid
								on da.DGAid = d.DGAid
					on d.DGGDid = e.DGGDid
				where e.DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
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
		<cfquery datasource="#session.DSN#">
			delete from DGGastosDistribuidos
			where Periodo       =  <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
			  and Mes           =  <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
			  and DGGDid        =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
			  and valorcriterio = 0
		</cfquery>

		<cfquery name="rsValorTotalCriterio" datasource="#session.DSN#">
			select sum(valorcriterio) as ValorTotalCriterio
			from DGGastosDistribuidos a
			where Periodo=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
			  and Mes=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
			  and DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
		</cfquery>	

		<cfset ValorTotalCriterio = 0.00>
		
		<cfif isdefined('rsValorTotalCriterio') and len(trim(rsValorTotalCriterio.ValorTotalCriterio))>
			<cfset ValorTotalCriterio = rsValorTotalCriterio.ValorTotalCriterio>
		</cfif>

		<cfif len(Trim(ValorTotalCriterio)) and ValorTotalCriterio NEQ 0.00>
			<cfquery datasource="#session.DSN#"   >
				update DGGastosDistribuidos
				set 
					valortotcriterio = #ValorTotalCriterio#,
					montoasignado = round( montodist * (valorcriterio / #ValorTotalCriterio#), 2),
					presasignado = round( presdist * (valorcriterio / #ValorTotalCriterio#), 2)
				where Periodo=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
				  and Mes=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
				  and valorcriterio is not null 
				  and valorcriterio <> 0
				  and DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">		  
			</cfquery>
		</cfif>

		<cfquery name="rsValorTotalDistribuido" datasource="#session.dsn#">
			select sum(montoasignado) as ValorTotalDistribuido, sum(presasignado) as PresTotalDistribuido
			from DGGastosDistribuidos a
			where Periodo=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
			  and Mes=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
			  and DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
		</cfquery>

		<cfset ValorTotalDistribuido = 0.00>
		<cfset PresTotalDistribuido = 0.00>
		
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
			<cfquery name="rsMayorDistribuicion" datasource="#session.DSN#">
				select min(DGGDDid) as DGGDDid
				from DGGastosDistribuidos a
				where a.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
				  and a.Mes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
				  and a.DGGDid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
				  and a.montoasignado = ((
				  			select max(montoasignado)
							from DGGastosDistribuidos b
							where b.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
							  and b.Mes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
							  and b.DGGDid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
							 ))
			</cfquery>
			
			<cfset LvarDGGDDid = rsMayorDistribuicion.DGGDDid>
			
			<cfif len(trim(LvarDGGDDid))>
				<cfquery datasource="#session.DSN#">
					update DGGastosDistribuidos 
						set 
							montoasignado   = montoasignado   + round(#MontoDiferencia#, 2),
							presasignado = presasignado + round(#PresDiferencia#, 2)
					where DGGDDid = #LvarDGGDDid#
				</cfquery>
			
			</cfif>

		</cfif>

		<!--- Borrar los valores que tiene gastos distribuidos en cero, para no llenar de registros la tabla --->
		<cfquery datasource="#session.DSN#">
			delete from DGGastosDistribuidos
			where Periodo         =  <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
			  and Mes             =  <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
			  and DGGDid          =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
			  and montoasignado   = 0
			  and presasignado = 0
		</cfquery>


		<!--- pasar los registros de DGGastosxDistribuir a DGGastosDistribuidos --->
		<cfquery datasource="#session.DSN#">
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
			where Periodo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
			  and Mes       = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">		
			  and DGGDid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">		  
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
	</cfloop>

<cfelseif isdefined("url.btnEliminar") >
	<cfloop list="#url.chk#" index="i">
		<cftransaction>
			<!--- 1. Eliminacion de Datos --->
			<cfquery datasource="#session.DSN#">
				delete from DGGastosxDistribuir
				where Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
				  and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
				  and DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
			</cfquery>
			<cfquery datasource="#session.DSN#">
				delete from DGGastosDistribuidos
				where Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
				  and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
				  and DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
			</cfquery>
		</cftransaction>
	</cfloop>
</cfif>
<cflocation url="gastosDistribuir-verificacion.cfm?periodo=#url.periodo#&mes=#url.mes#">


