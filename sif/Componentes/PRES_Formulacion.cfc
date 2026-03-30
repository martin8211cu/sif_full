<cfcomponent>
 	<cffunction name="AjustaFormulacion" output="false" access="public">
		<cfargument name='CVid' type="numeric" required='true'>
		<cfargument name='CVPcuenta' type="numeric" required='false' default="-1">
		<cfargument name='Ocodigo' type="numeric" required='false' default="-1">
		<cfargument name='CPCano' type="numeric" required='false' default="-1">
		<cfargument name='CPCmes' type="numeric" required='false' default="-1">
		<cfargument name='Arranque' type="numeric" required='false' default="true">
		
	<!--- Obtiene la Moneda de la Empresa --->
	<cfquery name="qry_monedaEmpresa" datasource="#session.dsn#">
		select Mcodigo
		from Empresas 
		where Ecodigo = #Session.Ecodigo#
	</cfquery>
	
	<!--- Obtiene el mes de Auxiliares --->
	<cfquery name="rsSQL" datasource="#session.dsn#">
	select Pvalor
	  from Parametros
	 where Ecodigo = #session.Ecodigo#
	   and Pcodigo = 50
	</cfquery>
	<cfset LvarAuxAno = rsSQL.Pvalor>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select Pvalor
		  from Parametros
		 where Ecodigo = #session.Ecodigo#
		   and Pcodigo = 60
	</cfquery>
	<cfset LvarAuxMes = rsSQL.Pvalor>
	<cfset LvarAuxAnoMes = LvarAuxAno*100+LvarAuxMes>

	<!--- Obtiene el tipo de Periodo de Presupuesto --->
	<cfquery name="rsPeriodo" datasource="#session.dsn#">
		select 	v.CVid, v.CVaprobada, v.CVtipo, 
				p.CPPid, p.CPPfechaDesde, p.CPPtipoPeriodo, p.CPPestado
		  from CVersion v
				INNER JOIN CPresupuestoPeriodo p
					ON p.CPPid = v.CPPid
		 where v.Ecodigo 	= #session.Ecodigo#
		   and CVid 		= #Arguments.CVid#
	</cfquery>
	
	<cfset LvarCVid 	= rsPeriodo.CVid>
	<cfset LvarCPPid 	= rsPeriodo.CPPid>
	<cfset LvarFechaIni = rsPeriodo.CPPfechaDesde>

	<cfif rsPeriodo.recordCount EQ 0>
		<cf_errorCode	code = "51261"
						msg  = "No existe la Version de Formulación Presupuestaria a Trabajar id='[@errorDat_1@]'"
						errorDat_1="#LvarCVid#"
		>
	<cfelseif rsPeriodo.CVaprobada NEQ "0">
		<cf_errorCode	code = "51262" msg = "La Versión de Presupuesto ya fue aprobada">
	<cfelseif rsPeriodo.CVtipo EQ "1">
		<cfif rsPeriodo.CPPestado EQ "0">
			<cfset LvarAprobacion = true>
		<cfelse>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select 	count(1) as cantidad
				  from CVersion v
						INNER JOIN CPresupuestoPeriodo p
							ON p.CPPid = v.CPPid
				 where v.Ecodigo 	= #session.Ecodigo#
				   and v.CPPid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCPPid#">
				   and v.CVtipo		= '2'
				   and v.CVaprobada	= 1
			</cfquery>
			<cfif rsSQL.cantidad NEQ 0>
				<cf_errorCode	code = "51263" msg = "La versión de Presupuesto Ordinario pero el Período ya tiene Modificaciones Presupuestarias aprobadas">
			<cfelse>
				<cfset LvarAprobacion = true>
			</cfif>
		</cfif>
	<cfelse>
		<cfif rsPeriodo.CPPestado EQ "1">
			<cfset LvarAprobacion = false>
		<cfelse>
			<cf_errorCode	code = "51264" msg = "La versión de Modificación Presupuestaria pero el Período de Presupuesto no está abierto">
		</cfif>
	</cfif>

	<!--- Verifica y calcula Cuentas Vinculadas --->
	<cfset sbProcesaCtasVinculadas(LvarCPPid, LvarCVid, Arguments.CVPcuenta, Arguments.Ocodigo, Arguments.CPCano, Arguments.CPCmes)>

	<!--- Obtiene las Cuentas de Presupuesto existentes (correspondientes a las cuentas de Version --->
	<cfquery datasource="#session.DSN#">
		update CVPresupuesto
		   set CPcuenta =
		   			( 
						select min(CPcuenta)
						  from  CPresupuesto c, 
						  		CVMayor vm
									inner join CPVigencia vg
										 on vg.CPVid 	= vm.CPVidOri
										and vg.PCEMid 	= coalesce (vm.PCEMidNueva,vm.PCEMidOri)
									    and #dateformat(LvarFechaIni,"YYYYMM")# between vg.CPVdesdeAnoMes and vg.CPVhastaAnoMes
						 where c.Ecodigo   = CVPresupuesto.Ecodigo
						   and c.Cmayor    = CVPresupuesto.Cmayor
						   and c.CPVid     = vm.CPVidOri
						   and c.CPformato = CVPresupuesto.CPformato

						   and vm.Ecodigo 	= CVPresupuesto.Ecodigo
						   and vm.CVid 		= CVPresupuesto.CVid
						   and vm.Cmayor	= CVPresupuesto.Cmayor
					)
		 where Ecodigo	= #session.Ecodigo#
		   and CVid 	= #LvarCVid#
		   <cfif Arguments.CVPcuenta NEQ -1>
		   and CVPcuenta = #Arguments.CVPcuenta#
		   </cfif>
	</cfquery>

	<cfif LvarAprobacion>
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select p.CPformato, o.Oficodigo
			  from CVFormulacionMonedas f
				inner join Oficinas o
					  on o.Ecodigo = f.Ecodigo
					 and o.Ocodigo = f.Ocodigo
				inner join CVPresupuesto v
					inner join CPresupuesto p
						 on p.CPcuenta = v.CPcuenta
					 on v.Ecodigo 	= f.Ecodigo
					and v.CVid 		= f.CVid
					and v.CVPcuenta	= f.CVPcuenta
			  	inner join CPresupuestoControl c
					  on c.Ecodigo 	= f.Ecodigo
					 and c.CPPid 	= #LvarCPPid#
					 and c.CPcuenta = v.CPcuenta
					 and c.Ocodigo	= f.Ocodigo
					 and c.CPCano	= f.CPCano
					 and c.CPCmes	= f.CPCmes
			 where f.Ecodigo	= #session.Ecodigo#
			   and f.CVid 		= #LvarCVid#
			   <cfif Arguments.CVPcuenta NEQ -1>
			   and f.CVPcuenta	= #Arguments.CVPcuenta#
			   </cfif>
			   <cfif Arguments.Ocodigo NEQ -1>
			   and f.Ocodigo	= #Arguments.Ocodigo#
			   </cfif>
		</cfquery>
		<cfif rsSQL.CPformato NEQ "">
			<cf_errorCode	code = "51265"
							msg  = "La cuenta de presupuesto @errorDat_1@ ya fue Formulada en la Oficina='@errorDat_2@'. No puede volver a incluirse en una Version de Presupuesto Original"
							errorDat_1="#rsSQL.CPformato#"
							errorDat_2="#rsSQL.Oficodigo#"
			>
		</cfif>
	</cfif>

	<!--- Elimina Formulaciones anteriores al Mes de Auxiliares --->
	<cfif NOT isdefined("request.CFaprobacion_MesesAnt")>
		<cfif  Arguments.CVPcuenta EQ -1 AND Arguments.Ocodigo EQ -1>
			<cfif not Arguments.Arranque>
				<cfquery name="rsAnterior" datasource="#session.dsn#">
					select count(1) as cantidad
					  from CVFormulacionMonedas
					 where Ecodigo	= #session.Ecodigo#
					   and CVid 	= #LvarCVid#
					   and CPCano*100+CPCmes < #LvarAuxAnoMes#
				</cfquery>
				<cfif rsAnterior.cantidad GT 0>
					<cf_errorCode	code = "51266" msg = "Existen formulaciones para meses anteriores al mes actual">
				</cfif>
			</cfif>
		<cfelse>
			<cfquery datasource="#session.dsn#">
				delete from CVFormulacionMonedas
				 where Ecodigo	= #session.Ecodigo#
				   and CVid 	= #LvarCVid#
				   <cfif Arguments.CVPcuenta NEQ -1>
				   and CVPcuenta = #Arguments.CVPcuenta#
				   </cfif>
				   <cfif Arguments.Ocodigo NEQ -1>
				   and Ocodigo = #Arguments.Ocodigo#
				   </cfif>
				   and CPCano*100+CPCmes < #LvarAuxAnoMes#
			</cfquery>
			<cfquery datasource="#session.dsn#">
				delete from CVFormulacionTotales
				 where Ecodigo	= #session.Ecodigo#
				   and CVid 	= #LvarCVid#
				   <cfif Arguments.CVPcuenta NEQ -1>
				   and CVPcuenta = #Arguments.CVPcuenta#
				   </cfif>
				   <cfif Arguments.Ocodigo NEQ -1>
				   and Ocodigo = #Arguments.Ocodigo#
				   </cfif>
				   and CPCano*100+CPCmes < #LvarAuxAnoMes#
			</cfquery>
		</cfif>
	</cfif>

	<!--- Incluye todos los montos aprobados para una cuenta en particular --->
	<!--- No se ejecuta en aprobacion --->
	<cfif rsPeriodo.CVtipo EQ "2" AND Arguments.CVPcuenta NEQ -1>
		<cfquery datasource="#session.dsn#">
			insert into CVFormulacionTotales
				(Ecodigo,CVid,CVPcuenta,CPCano,CPCmes,Ocodigo,CVFTmontoSolicitado)
			select distinct
				vc.Ecodigo, vc.CVid, vc.CVPcuenta, cm.CPCano, cm.CPCmes, cm.Ocodigo, 0
			  from CVPresupuesto vc, CPControlMoneda cm
			 where vc.Ecodigo	= #session.Ecodigo#
			   and vc.CVid 		= #LvarCVid#
			   and vc.CVPcuenta = #Arguments.CVPcuenta#
			   and vc.CPcuenta is not null

			   and cm.Ecodigo	= vc.Ecodigo
			   and cm.CPPid 	= #LvarCPPid#
			   and cm.CPcuenta 	= vc.CPcuenta
			   and not exists 
			   		(
			   		select 1 from CVFormulacionTotales f
					 where f.Ecodigo	= cm.Ecodigo
					   and f.CVid		= #LvarCVid#
					   and f.CPCano		= cm.CPCano
					   and f.CPCmes		= cm.CPCmes
					   and f.CVPcuenta	= #Arguments.CVPcuenta#
					   and f.Ocodigo	= cm.Ocodigo
					)
			   <cfif Arguments.Ocodigo NEQ -1>
			   and cm.Ocodigo = #Arguments.Ocodigo#
			   </cfif>
			   <cfif Arguments.CPCano NEQ -1>
			   and cm.CPCano = #Arguments.CPCano#
			   </cfif>
			   <cfif Arguments.CPCmes NEQ -1>
			   and cm.CPCmes = #Arguments.CPCmes#
			   </cfif>
			<cfif NOT isdefined("request.CFaprobacion_MesesAnt")>
			   and cm.CPCano*100+cm.CPCmes >= #LvarAuxAnoMes#
			</cfif>
		</cfquery>
		<cfquery datasource="#session.dsn#">
			insert into CVFormulacionMonedas
				(Ecodigo,CVid,CVPcuenta,CPCano,CPCmes,Ocodigo,Mcodigo,CVFMmontoBase)
			select 
				vc.Ecodigo, vc.CVid, vc.CVPcuenta, cm.CPCano, cm.CPCmes, cm.Ocodigo, cm.Mcodigo, cm.CPCMpresupuestado+cm.CPCMmodificado
			  from CVPresupuesto vc, CPControlMoneda cm
			 where vc.Ecodigo	= #session.Ecodigo#
			   and vc.CVid 		= #LvarCVid#
			   and vc.CVPcuenta = #Arguments.CVPcuenta#
			   and vc.CPcuenta is not null

			   and cm.Ecodigo	= vc.Ecodigo
			   and cm.CPPid 	= #LvarCPPid#
			   and cm.CPcuenta 	= vc.CPcuenta
			   and not exists 
			   		(
			   		select 1 from CVFormulacionMonedas f
					 where f.Ecodigo	= cm.Ecodigo
					   and f.CVid		= #LvarCVid#
					   and f.CPCano		= cm.CPCano
					   and f.CPCmes		= cm.CPCmes
					   and f.CVPcuenta	= #Arguments.CVPcuenta#
					   and f.Ocodigo	= cm.Ocodigo
					   and f.Mcodigo	= cm.Mcodigo
					)
			   <cfif Arguments.Ocodigo NEQ -1>
			   and cm.Ocodigo = #Arguments.Ocodigo#
			   </cfif>
			   <cfif Arguments.CPCano NEQ -1>
			   and cm.CPCano = #Arguments.CPCano#
			   </cfif>
			   <cfif Arguments.CPCmes NEQ -1>
			   and cm.CPCmes = #Arguments.CPCmes#
			   </cfif>
			<cfif NOT isdefined("request.CFaprobacion_MesesAnt")>
			   and cm.CPCano*100+cm.CPCmes >= #LvarAuxAnoMes#
			</cfif>
		</cfquery>
   </cfif>

	<!--- Actualiza los tipos de Cambio Proyectados por Mes y actualiza el monto a aplicar--->
	<cfquery datasource="#session.dsn#">
		update CVFormulacionMonedas
		   set CVFMtipoCambio =
				case
					when CVFormulacionMonedas.Mcodigo = #qry_monedaEmpresa.Mcodigo# 
						then 1.00
						else
							(
								select 	
										case 
											when rtrim(m.Ctipo) in ('A','G')
												then CPTipoCambioVenta
												else CPTipoCambioCompra
										end
								  from CPTipoCambioProyectadoMes p, CVPresupuesto c, CVMayor m
								 where p.Ecodigo 	= CVFormulacionMonedas.Ecodigo
								   and p.CPCano 	= CVFormulacionMonedas.CPCano
								   and p.CPCmes 	= CVFormulacionMonedas.CPCmes
								   and p.Mcodigo 	= CVFormulacionMonedas.Mcodigo
								   and  case 
											when rtrim(m.Ctipo) in ('A','G')
												then p.CPTipoCambioVenta
												else p.CPTipoCambioCompra
										end > 0
									and c.Ecodigo 	= CVFormulacionMonedas.Ecodigo
									and c.CVid 		= CVFormulacionMonedas.CVid
									and c.CVPcuenta	= CVFormulacionMonedas.CVPcuenta
									and m.Ecodigo 	= CVFormulacionMonedas.Ecodigo
									and m.CVid 		= CVFormulacionMonedas.CVid
									and m.Cmayor 	= c.Cmayor
							)
				end,
			<cfif LvarAprobacion>
				CVFMmontoAplicar = CVFMmontoBase + CVFMajusteUsuario + CVFMajusteFinal
			<cfelse>
				CVFMmontoAplicar = CVFMmontoBase + CVFMajusteUsuario + CVFMajusteFinal -
					coalesce(
						(
							select (CPCMpresupuestado + CPCMmodificado)
							  from CVPresupuesto vc, CPControlMoneda cm
							 where vc.Ecodigo	= CVFormulacionMonedas.Ecodigo
							   and vc.CVid 		= CVFormulacionMonedas.CVid
							   and vc.CVPcuenta = CVFormulacionMonedas.CVPcuenta

							   and cm.Ecodigo	= CVFormulacionMonedas.Ecodigo
							   and cm.CPPid 	= #LvarCPPid#
							   and cm.CPCano 	= CVFormulacionMonedas.CPCano
							   and cm.CPCmes 	= CVFormulacionMonedas.CPCmes
							   and cm.CPcuenta 	= vc.CPcuenta
							   and cm.Ocodigo 	= CVFormulacionMonedas.Ocodigo
							   and cm.Mcodigo 	= CVFormulacionMonedas.Mcodigo
						)
							,0)
			</cfif>
		where Ecodigo 	= #session.Ecodigo#
		  and CVid 		= #LvarCVid#
		   <cfif Arguments.CVPcuenta NEQ -1>
		   and CVPcuenta = #Arguments.CVPcuenta#
		   </cfif>
		   <cfif Arguments.Ocodigo NEQ -1>
		   and Ocodigo = #Arguments.Ocodigo#
		   </cfif>
		   <cfif Arguments.CPCano NEQ -1>
		   and CPCano = #Arguments.CPCano#
		   </cfif>
		   <cfif Arguments.CPCmes NEQ -1>
		   and CPCmes = #Arguments.CPCmes#
		   </cfif>
	</cfquery>

	<!--- Actualiza los Totales de Formulacion por Cuenta+Año+Mes+Oficina (sin Moneda) --->
	<cfquery name="update_cvftotales" datasource="#session.dsn#">
		update CVFormulacionTotales
		   set 	CVFTmontoSolicitado = 
		   		case
					when
						(
							select count(1)
							  from CVFormulacionMonedas b
							 where b.Ecodigo 	= CVFormulacionTotales.Ecodigo
							   and b.CVid 		= CVFormulacionTotales.CVid
							   and b.CVPcuenta 	= CVFormulacionTotales.CVPcuenta
							   and b.CPCano 	= CVFormulacionTotales.CPCano
							   and b.CPCmes 	= CVFormulacionTotales.CPCmes
							   and b.Ocodigo 	= CVFormulacionTotales.Ocodigo
							   and coalesce(b.CVFMtipoCambio,0.00) = 0.00
						) > 0
					then
						0
					else
						coalesce (
						(
							select sum((b.CVFMmontoBase + b.CVFMajusteUsuario + b.CVFMajusteFinal)*b.CVFMtipoCambio) 
							  from CVFormulacionMonedas b
							 where b.Ecodigo 	= CVFormulacionTotales.Ecodigo
							   and b.CVid 		= CVFormulacionTotales.CVid
							   and b.CVPcuenta 	= CVFormulacionTotales.CVPcuenta
							   and b.CPCano 	= CVFormulacionTotales.CPCano
							   and b.CPCmes 	= CVFormulacionTotales.CPCmes
							   and b.Ocodigo 	= CVFormulacionTotales.Ocodigo
						), 0)
				end,
				CVFTmontoAplicar = 
		   		case
					when
						(
							select count(1)
							  from CVFormulacionMonedas b
							 where b.Ecodigo 	= CVFormulacionTotales.Ecodigo
							   and b.CVid 		= CVFormulacionTotales.CVid
							   and b.CVPcuenta 	= CVFormulacionTotales.CVPcuenta
							   and b.CPCano 	= CVFormulacionTotales.CPCano
							   and b.CPCmes 	= CVFormulacionTotales.CPCmes
							   and b.Ocodigo 	= CVFormulacionTotales.Ocodigo
							   and coalesce(b.CVFMtipoCambio,0.00) = 0.00
						) > 0
					then
						0
					else
						coalesce (
						(
							select sum(b.CVFMmontoAplicar*b.CVFMtipoCambio) 
							  from CVFormulacionMonedas b
							 where b.Ecodigo 	= CVFormulacionTotales.Ecodigo
							   and b.CVid 		= CVFormulacionTotales.CVid
							   and b.CVPcuenta 	= CVFormulacionTotales.CVPcuenta
							   and b.CPCano 	= CVFormulacionTotales.CPCano
							   and b.CPCmes 	= CVFormulacionTotales.CPCmes
							   and b.Ocodigo 	= CVFormulacionTotales.Ocodigo
						), 0)
				end
		  where Ecodigo 	= #session.Ecodigo#
		    and CVid 		= #LvarCVid#
		   <cfif Arguments.CVPcuenta NEQ -1>
		   and CVPcuenta = #Arguments.CVPcuenta#
		   </cfif>
		   <cfif Arguments.Ocodigo NEQ -1>
		   and Ocodigo = #Arguments.Ocodigo#
		   </cfif>
		   <cfif Arguments.CPCano NEQ -1>
		   and CPCano = #Arguments.CPCano#
		   </cfif>
		   <cfif Arguments.CPCmes NEQ -1>
		   and CPCmes = #Arguments.CPCmes#
		   </cfif>
	</cfquery>
	
	</cffunction>

  	<cffunction name="sbProcesaCtasVinculadas" output="false" access="public">
		<cfargument name='CPPid'		type="numeric"	required='yes'>
		<cfargument name='CVid'			type="numeric"	required='yes'>
		<cfargument name='CVPcuenta' 	type="numeric"	required='yes'>
		<cfargument name='Ocodigo' 		type="numeric" 	required='yes'>
		<cfargument name='CPCano' 		type="numeric" 	required='yes'>
		<cfargument name='CPCmes' 		type="numeric" 	required='yes'>

		<cfset var rsSQL = QueryNew("nada")>

		<cfif  Arguments.CVPcuenta NEQ -1>
			<cfquery name="rsFormato" datasource="#session.dsn#">
				select Cmayor, CPformato
				  from CVPresupuesto c
				 where c.Ecodigo 	= #session.Ecodigo#
				   and c.CVid 		= #Arguments.CVid#
				   and c.CVPcuenta	= #Arguments.CVPcuenta#
			</cfquery>
		</cfif>
		<cfquery name="rsVinculadasConPadres" datasource="#session.dsn#">
			select v.CPformato, v.CPdescripcion, count(1) as cantidadPadres
			  from CPCtaVinculada v
				inner join CPCtaVinculadaPadres p
					 on p.CPCVid = v.CPCVid
				inner join CVPresupuesto c
					 on c.Ecodigo 	= v.Ecodigo
					and c.CVid 		= #Arguments.CVid#
					and c.Cmayor 	= <cf_dbfunction name="sPart" args="p.CPformatoPadre,1,4">
					and c.CPformato = p.CPformatoPadre
			 where v.Ecodigo	= #session.Ecodigo#
			   and v.CPPid 		= #Arguments.CPPid#
			<cfif  Arguments.CVPcuenta NEQ -1>
			   and v.CPformato	= '#rsFormato.CPformato#'
			</cfif>
			group by v.CPformato, v.CPdescripcion
		</cfquery>
		<cfif rsVinculadasConPadres.recordcount GT 0>
			<cfloop query="rsVinculadasConPadres">
				<!--- Verifica que todos los padres estén formulados --->
				<cfquery name="rsVinculadas" datasource="#session.dsn#">
					select count(1) as CantidadPadres
					  from CPCtaVinculada v
						inner join CPCtaVinculadaPadres p
							 on p.CPCVid = v.CPCVid
					 where v.Ecodigo	= #session.Ecodigo#
					   and v.CPPid 		= #Arguments.CPPid#
					   and v.CPformato	= '#rsVinculadasConPadres.CPformato#'
				</cfquery>
				<cfif  Arguments.CVPcuenta EQ -1 AND Arguments.Ocodigo EQ -1>
					<cfquery name="rsVinculadas" datasource="#session.dsn#">
						select count(1) as CantidadPadres
						  from CPCtaVinculada v
							inner join CPCtaVinculadaPadres p
								 on p.CPCVid = v.CPCVid
						 where v.Ecodigo	= #session.Ecodigo#
						   and v.CPPid 		= #Arguments.CPPid#
						   and v.CPformato	= '#rsVinculadasConPadres.CPformato#'
					</cfquery>
					<cfif rsVinculadas.CantidadPadres NEQ rsVinculadasConPadres.CantidadPadres>
						<cf_errorCode	code = "51267"
										msg  = "La cuenta vinculada '@errorDat_1@' no tiene formulación de todos sus padres en la Versión"
										errorDat_1="#rsVinculadasConPadres.CPformato#"
						>
					</cfif>
				</cfif>

				<!--- Crear Cuenta de Mayor de la cuenta vinculada --->
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select count(1) as Cantidad
					  from CVMayor
					 where Ecodigo 	= #session.Ecodigo#
					   and CVid 	= #Arguments.CVid#
					   and Cmayor	= '#mid(rsFormato.CPformato,1,4)#'
				</cfquery>
				<cfif rsSQL.cantidad EQ 0>
					<cfquery name="rsSQL" datasource="#session.dsn#">
						insert into CVMayor
							(
								Ecodigo, 
								CVid, 
								Cmayor, 
								Ctipo, 
								CPVidOri, 
								PCEMidOri, 
								Cmascara,
								CVMtipoControl,
								CVMcalculoControl
							)
						select 	a.Ecodigo,
								#Arguments.CVid#, 
								a.Cmayor,	
								a.Ctipo, 
								b.CPVid as CPVidOri, 
								b.PCEMid as PCEMidOri, 
								d.PCEMformatoP as Cmascara,
								(case a.Ctipo when 'A' then 1 when 'G' then 1 else 0 end) as tipoControl,
								2 as calculoControl
						  from CtasMayor a
							inner join CPVigencia b	<!--- Primera Vigencia del Inicio del Periodo o que empiece despues del Inicio --->
									inner join PCEMascaras d
									  on d.PCEMid = b.PCEMid
								 ON b.Ecodigo = a.Ecodigo
								and b.Cmayor  = a.Cmayor
								and b.CPVdesde =
									(select min(v.CPVdesde)
									   from CPVigencia v, CPresupuestoPeriodo p
									  where v.Ecodigo 	= a.Ecodigo
										and v.Cmayor  	= a.Cmayor
										and p.CPPid 	= #Arguments.CPPid#
										and (
												p.CPPfechaDesde between v.CPVdesde 		and v.CPVhasta
											OR 
												v.CPVdesde		between p.CPPfechaDesde and p.CPPfechaHasta
											)
									)
						 where Ecodigo 	= #session.Ecodigo#
						   and Cmayor	= '#mid(rsFormato.CPformato,1,4)#'
					</cfquery>
				</cfif>
				<cfquery name="rsMontosVinculadas" datasource="#session.dsn#">
					select m.CPCano, m.CPCmes, m.Ocodigo, m.Mcodigo,
							sum(m.CVFMmontoBase		* v.CPCVporcentaje/100)	as Base,
							sum(m.CVFMajusteUsuario	* v.CPCVporcentaje/100)	as Usuario,
							sum(m.CVFMajusteFinal	* v.CPCVporcentaje/100)	as Final
					  from CPCtaVinculada v
						inner join CPCtaVinculadaPadres p
							 on p.CPCVid = v.CPCVid
						inner join CVPresupuesto c
							inner join CVFormulacionMonedas m
								 on m.Ecodigo 	= c.Ecodigo
								and m.CVid 		= c.CVid
								and m.CVPcuenta = c.CVPcuenta
							   <cfif Arguments.Ocodigo NEQ -1>
							   and m.Ocodigo = #Arguments.Ocodigo#
							   </cfif>
							   <cfif Arguments.CPCano NEQ -1>
							   and m.CPCano = #Arguments.CPCano#
							   </cfif>
							   <cfif Arguments.CPCmes NEQ -1>
							   and m.CPCmes = #Arguments.CPCmes#
							   </cfif>
							 on c.Ecodigo 	= v.Ecodigo
							and c.CVid 		= #Arguments.CVid#
							and c.Cmayor 	= <cf_dbfunction name="sPart" args="p.CPformatoPadre,1,4">
							and c.CPformato = p.CPformatoPadre
					 where v.Ecodigo	= #session.Ecodigo#
					   and v.CPPid 		= #Arguments.CPPid#
					   and v.CPformato	= '#rsVinculadasConPadres.CPformato#'
					 group by m.CPCano, m.CPCmes, m.Ocodigo, m.Mcodigo
				</cfquery>
	
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select CVPcuenta
					  from CVPresupuesto c
					 where Ecodigo 	= #session.Ecodigo#
					   and CVid 	= #Arguments.CVid#
					   and Cmayor 	= '#mid(rsVinculadasConPadres.CPformato,1,4)#'
					   and CPformato= '#rsVinculadasConPadres.CPformato#'
				</cfquery>
				<cfif rsSQL.recordCount EQ 0>
					<cfinvoke 
					 component="sif.Componentes.PC_GeneraCuentaFinanciera"
					 method="fnGeneraCuentaFinanciera"
					 returnvariable="LvarMSG">
						<cfinvokeargument name="Lprm_CFformato" value="#rsVinculadasConPadres.CPformato#"/>
						<cfinvokeargument name="Lprm_fecha" value="#now()#"/>
						<cfinvokeargument name="Lprm_Ocodigo" value="0"/>
						<cfinvokeargument name="Lprm_Cdescripcion" value="#rsVinculadasConPadres.CPdescripcion#"/>
						<cfinvokeargument name="Lprm_EsDePresupuesto" value="true"/>
						<cfinvokeargument name="Lprm_CrearPresupuesto" value="true"/>
						<cfinvokeargument name="Lprm_CVid" value="#Arguments.CVid#"/>
						<cfinvokeargument name="Lprm_debug" value="no"/>
						<cfinvokeargument name="Lprm_TransaccionActiva" value="yes"/>
					</cfinvoke>
					<cfif LvarMSG NEQ "NEW" AND LvarMSG NEQ "OLD">
						<cf_errorCode	code = "51268"
										msg  = "ERROR EN LA CREACION DE CUENTA VINCULADA: @errorDat_1@"
										errorDat_1="#LvarMSG#"
						>
					</cfif>
					<cfquery name="rsSQL" datasource="#session.dsn#">
						select CVPcuenta
						  from CVPresupuesto c
						 where Ecodigo 	= #session.Ecodigo#
						   and CVid 	= #Arguments.CVid#
						   and Cmayor 	= '#mid(rsVinculadasConPadres.CPformato,1,4)#'
						   and CPformato= '#rsVinculadasConPadres.CPformato#'
					</cfquery>
				</cfif>
				<cfset LvarCVPcuenta = rsSQL.CVPcuenta>
				
				<cfloop query="rsMontosVinculadas">
					<cfquery name="rsSQL" datasource="#session.dsn#">
						select CVPcuenta
						  from CVFormulacionTotales
						 where Ecodigo 	= #session.Ecodigo#
						   and CVid 	= #Arguments.CVid#
						   and CPCano	= #rsMontosVinculadas.CPCano#
						   and CPCmes	= #rsMontosVinculadas.CPCmes#
						   and CVPcuenta= #LvarCVPcuenta#
						   and Ocodigo	= #rsMontosVinculadas.Ocodigo#
					</cfquery>
					<cfif rsSQL.recordCount EQ 0>
						<cfquery name="rsSQL" datasource="#session.dsn#">
							insert into CVFormulacionTotales (Ecodigo, CVid, CPCano, CPCmes, CVPcuenta, Ocodigo, CVFTmontoSolicitado, CVFTmontoAplicar)
							values 
								(#session.Ecodigo#, #Arguments.CVid#, #rsMontosVinculadas.CPCano#, #rsMontosVinculadas.CPCmes#, 
								#LvarCVPcuenta#, #rsMontosVinculadas.Ocodigo#, 
								0,0)
						</cfquery>
					</cfif>
			
					<cfquery name="rsSQL" datasource="#session.dsn#">
						select CVPcuenta
						  from CVFormulacionMonedas
						 where Ecodigo 	= #session.Ecodigo#
						   and CVid 	= #Arguments.CVid#
						   and CPCano	= #rsMontosVinculadas.CPCano#
						   and CPCmes	= #rsMontosVinculadas.CPCmes#
						   and CVPcuenta= #LvarCVPcuenta#
						   and Ocodigo	= #rsMontosVinculadas.Ocodigo#
						   and Mcodigo	= #rsMontosVinculadas.Mcodigo#
					</cfquery>
					<cfif rsSQL.recordCount EQ 0>
						<cfquery name="rsSQL" datasource="#session.dsn#">
							insert into CVFormulacionMonedas (Ecodigo, CVid, CPCano, CPCmes, CVPcuenta, Ocodigo, Mcodigo, 
										CVFMtipoCambio, CVFMmontoBase, CVFMajusteUsuario, CVFMajusteFinal, CVFMmontoAplicar)
							values 
								(#session.Ecodigo#, #Arguments.CVid#, #rsMontosVinculadas.CPCano#, #rsMontosVinculadas.CPCmes#, 
								#LvarCVPcuenta#, #rsMontosVinculadas.Ocodigo#, #rsMontosVinculadas.Mcodigo#, 
								0, #rsMontosVinculadas.Base#, #rsMontosVinculadas.Usuario#, #rsMontosVinculadas.Final#, 
								0)
						</cfquery>
					<cfelse>
						<cfquery name="rsSQL" datasource="#session.dsn#">
							update CVFormulacionMonedas 
								set CVFMmontoBase 		= #rsMontosVinculadas.Base#
								  , CVFMajusteUsuario 	= #rsMontosVinculadas.Usuario#
								  , CVFMajusteFinal		= #rsMontosVinculadas.Final#
							 where Ecodigo 	= #session.Ecodigo#
							   and CVid 	= #Arguments.CVid#
							   and CPCano	= #rsMontosVinculadas.CPCano#
							   and CPCmes	= #rsMontosVinculadas.CPCmes#
							   and CVPcuenta= #LvarCVPcuenta#
							   and Ocodigo	= #rsMontosVinculadas.Ocodigo#
							   and Mcodigo	= #rsMontosVinculadas.Mcodigo#
						</cfquery>
					</cfif>
				</cfloop>
			</cfloop>
		<cfelseif  Arguments.CVPcuenta NEQ -1>
			<cfquery name="rsVinculadasPadres" datasource="#session.dsn#">
				select v.CPformato, v.CPdescripcion
				  from CPCtaVinculadaPadres p
					inner join CPCtaVinculada v
						 on v.CPCVid = p.CPCVid
					    and v.Ecodigo=  #session.Ecodigo#
					    and v.CPPid  = #Arguments.CPPid#
				 where p.CPformatoPadre	= '#rsFormato.CPformato#'
			</cfquery>
			<cfloop query="rsVinculadasPadres">
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select CVPcuenta
					  from CVPresupuesto c
					 where Ecodigo 	= #session.Ecodigo#
					   and CVid 	= #Arguments.CVid#
					   and Cmayor 	= '#mid(rsVinculadasPadres.CPformato,1,4)#'
					   and CPformato= '#rsVinculadasPadres.CPformato#'
				</cfquery>
				<cfif rsSQL.recordCount EQ 0>
					<cfinvoke 
					 component="sif.Componentes.PC_GeneraCuentaFinanciera"
					 method="fnGeneraCuentaFinanciera"
					 returnvariable="LvarMSG">
						<cfinvokeargument name="Lprm_CFformato" value="#rsVinculadasPadres.CPformato#"/>
						<cfinvokeargument name="Lprm_fecha" value="#now()#"/>
						<cfinvokeargument name="Lprm_Ocodigo" value="0"/>
						<cfinvokeargument name="Lprm_Cdescripcion" value="#rsVinculadasPadres.CPdescripcion#"/>
						<cfinvokeargument name="Lprm_EsDePresupuesto" value="true"/>
						<cfinvokeargument name="Lprm_CrearPresupuesto" value="true"/>
						<cfinvokeargument name="Lprm_CVid" value="#Arguments.CVid#"/>
						<cfinvokeargument name="Lprm_debug" value="no"/>
						<cfinvokeargument name="Lprm_TransaccionActiva" value="yes"/>
					</cfinvoke>
					<cfif LvarMSG NEQ "NEW" AND LvarMSG NEQ "OLD">
						<cf_errorCode	code = "51268"
										msg  = "ERROR EN LA CREACION DE CUENTA VINCULADA: @errorDat_1@"
										errorDat_1="#LvarMSG#"
						>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
	</cffunction>

	<cffunction name="sbGenerarEscenario" output="false" access="public">
		<cfargument name='RHEid'		type="numeric"	required='yes'>
		<cfargument name='CVid'			type="numeric"	required='no' default="-1">
		
		<!--- Obtiene el Período Presupuestario --->
		<cfquery name="rsEscenario" datasource="#session.dsn#">
			select CPPid, Ecodigo, RHEestado, RHEfdesde, RHEfhasta
			  from RHEscenarios
			 where RHEid 	= #Arguments.RHEid#
		</cfquery>
		<cfif rsEscenario.RecordCount EQ 0>
			<cf_errorCode	code = "51269"
							msg  = "No existe el Escenario de Planilla Presupuestaria (ID=@errorDat_1@)"
							errorDat_1="#Arguments.RHEid#"
			>
		<cfelseif rsEscenario.Ecodigo NEQ Session.Ecodigo>
			<cf_errorCode	code = "51270" msg = "El Escenario de Planilla Presupuestaria no pertenece a la Empresa">
		<cfelseif rsEscenario.RHEestado NEQ "A">
			<cf_errorCode	code = "51271" msg = "El Escenario de Planilla Presupuestaria no está en proceso de Aprobación">
		<cfelseif rsEscenario.CPPid EQ "">
			<cf_errorCode	code = "51272" msg = "No se ha asignado el Período Presupuestario al Escenario de Planilla Presupuestaria ">
		</cfif>

		<cfquery name="rsCPperiodo" datasource="#session.dsn#">
			select CPPestado, Ecodigo, CPPfechaDesde, CPPfechaHasta
			  from CPresupuestoPeriodo
			 where CPPid = #rsEscenario.CPPid#
		</cfquery>

		<cfif rsCPperiodo.RecordCount EQ 0>
			<cf_errorCode	code = "51273" msg = "No existe el Período Presupuestario">
		<cfelseif rsCPperiodo.Ecodigo NEQ Session.Ecodigo>
			<cf_errorCode	code = "51274" msg = "El Período Presupuestario no pertenece a la Empresa">
		<cfelseif dateFormat(rsCPperiodo.CPPfechaDesde,"YYYYMMDD") NEQ dateFormat(rsEscenario.RHEfdesde,"YYYYMMDD") OR dateFormat(rsCPperiodo.CPPfechaHasta,"YYYYMMDD") NEQ dateFormat(rsEscenario.RHEfhasta,"YYYYMMDD")>
			<cf_errorCode	code = "51275" msg = "Las Fechas Desde y Hasta del Período Presupuestario no coinciden con las del Escenario de Planilla Presupuestaria">
		<cfelseif rsCPperiodo.CPPestado EQ 0>
			<cfset LvarCVtipo = "1">
		<cfelseif rsCPperiodo.CPPestado EQ 1>
			<cfset LvarCVtipo = "2">
		<cfelse>
			<cf_errorCode	code = "51276" msg = "El Período Presupuestario está cerrado y no se puede modificar">
		</cfif>

		<!--- Obtiene la Version de Presupuestario --->
		<cfquery name="rsVersiones" datasource="#session.dsn#">
			select CVid, RHEid, CPPid, CVestado, CVaprobada, CVtipo
			  from CVersion
			 where Ecodigo = #session.Ecodigo#
			<cfif Arguments.CVid EQ -1>
			   and CPPid = #rsEscenario.CPPid#
			<cfelse>
			   and CVid = #Arguments.CVid#
			</cfif>
		</cfquery>

		<cfif rsVersiones.recordCount EQ 0>
			<cfif Arguments.CVid NEQ -1>
				<cf_errorCode	code = "51277" msg = "La Version de Formulación Presupuestaria no existe">
			</cfif>
			<!--- CREA LA PRIMERA VERSION --->
			<cfquery name="rsVersiones" datasource="#session.dsn#">
				insert into CVersion
					(Ecodigo, CVtipo, CVdescripcion, CPPid, CVestado, CVaprobada)
				values
					(#session.Ecodigo#, '#LvarCVtipo#', 'Planilla Presupuestaria V.#rsVersiones.recordCount+1#', #rsEscenario.CPPid#, 0, 0)
					<cf_dbidentity1 name="rsVersiones" datasource="#session.dsn#" verificar_transaccion="no">
			</cfquery>
			<cf_dbidentity2 name="rsVersiones" datasource="#session.dsn#" verificar_transaccion="no">
			
			<cfset LvarCVid = rsVersiones.identity>
		<cfelseif Arguments.CVid NEQ -1>
			<cfif rsVersiones.CPPid NEQ Arguments.CPPid>
				<cf_errorCode	code = "51278" msg = "La Version de Formulación Presupuestaria no pertenece al Período Presupuestario">
			<cfelseif rsVersiones.CVaprobada EQ 1>
				<cf_errorCode	code = "51279" msg = "La Version de Formulación Presupuestaria ya fue aprobada y no puede ser modificada">
			<cfelseif rsVersiones.RHEid NEQ "" AND rsVersiones.RHEid NEQ Arguments.RHEid>
				<cf_errorCode	code = "51280" msg = "La Version de Formulación Presupuestaria esta asociada a otro Escenario de Planilla Presupuestaria">
			</cfif>
			<cfset LvarCVid = rsVersiones.CVid>
		<cfelse>
			<cfquery name="qryVersiones" dbtype="query">
				select CVid, CVestado, CVaprobada, CVtipo
				  from rsVersiones
				 where RHEid = #Arguments.RHEid#
				   and CVaprobada = 0
			</cfquery>
			<cfif qryVersiones.recordCount EQ 0>
				<!--- CREA LA SIGUIENTE VERSION --->
				<cfquery name="rsVersiones" datasource="#session.dsn#">
					insert into CVersion
						(Ecodigo, CVtipo, CVdescripcion, CPPid, CVestado, CVaprobada)
					values
						(#session.Ecodigo#, '#LvarCVtipo#', 'Planilla Presupuestaria V.#rsVersiones.recordCount+1#', #rsEscenario.CPPid#, 0, 0)
						<cf_dbidentity1 name="rsVersiones" datasource="#session.dsn#" verificar_transaccion="no">
				</cfquery>
				<cf_dbidentity2 name="rsVersiones" datasource="#session.dsn#" verificar_transaccion="no">

				<cfset LvarCVid = rsVersiones.identity>
			<cfelseif qryVersiones.recordCount EQ 1>
				<cfset LvarCVid = qryVersiones.CVid>
			<cfelse>
				<cf_errorCode	code = "51281" msg = "Existe más de una Version de Formulación Presupuestaria asociada a este Escenario de Planilla Presupuestaria">
			</cfif>
		</cfif>

		<cfquery datasource="#session.dsn#">
			update CVersion
			   set RHEid  = #Arguments.RHEid#
			     , CVtipo = '#LvarCVtipo#'
			 where CVid   = #LvarCVid#
		</cfquery>

		<!--- ELIMINA TODAS LAS FORMULACIONES de Planilla Presupuestaria --->
		<cfquery datasource="#session.dsn#">
			delete from CVFormulacionMonedas
			 where Ecodigo 	= #session.Ecodigo#
			   and CVid 	= #LvarCVid#
			   and exists (
						select 1
						  from CVPresupuesto
						 where Ecodigo 	 = CVFormulacionMonedas.Ecodigo
						   and CVid		 = CVFormulacionMonedas.CVid
						   and CVPcuenta = CVFormulacionMonedas.CVPcuenta
						   and CVPorigen = 'RH'
						)
		</cfquery>
		<cfquery datasource="#session.dsn#">
			delete from CVFormulacionTotales
			 where Ecodigo 	= #session.Ecodigo#
			   and CVid 	= #LvarCVid#
			   and exists (
						select 1
						  from CVPresupuesto
						 where Ecodigo 	 = CVFormulacionTotales.Ecodigo
						   and CVid		 = CVFormulacionTotales.CVid
						   and CVPcuenta = CVFormulacionTotales.CVPcuenta
						   and CVPorigen = 'RH'
						)
		</cfquery>
		<cfquery datasource="#session.dsn#">
			delete from CVPresupuesto
			 where Ecodigo 	 = #session.Ecodigo#
			   and CVid		 = #LvarCVid#
			   and CVPorigen = 'RH'
		</cfquery>

		<cf_dbtemp name="PRE_V1" returnvariable="FORMULACION" datasource="#session.dsn#">
			<cf_dbtempcol name="ID" 				type="numeric" 		mandatory="yes"
						  identity="yes">
			<cf_dbtempcol name="CPCano"    			type="int"          mandatory="no">
			<cf_dbtempcol name="CPCmes"    			type="int"          mandatory="no">
			<cf_dbtempcol name="Cmayor" 			type="varchar(4)" 	mandatory="no">
			<cf_dbtempcol name="CPformato" 			type="varchar(100)" mandatory="no">
			<cf_dbtempcol name="CVPcuenta" 			type="numeric"      mandatory="no">
			<cf_dbtempcol name="Ocodigo"		 	type="numeric"      mandatory="no">
			<cf_dbtempcol name="Mcodigo"		 	type="numeric"      mandatory="no">
			<cf_dbtempcol name="MontoBase"			type="money"        mandatory="no">

			<cf_dbtempkey cols="ID">
			<cf_dbtempindex cols="CPCano,CPCmes,CPformato,Ocodigo,ID">
		</cf_dbtemp>
		
		<!--- OBTIENE EL TOTAL DE MONTOS POR MES+CUENTA+OFICINA+MONEDA --->
		<cfquery datasource="#session.dsn#">
			insert into #FORMULACION# 
					(CPCano, CPCmes, 
					 Cmayor, CPformato, Ocodigo, 
					 Mcodigo, MontoBase)
			select 	 Periodo, Mes, 
					 <cf_dbfunction name="sPart" args="fc.CPformato,1,4">, fc.CPformato, cf.Ocodigo, 
					 f.Mcodigo, sum(fcm.Monto)
			  from RHFormulacion f
				inner join RHCFormulacion fc
					inner join RHCortesPeriodoF fcm
						on fcm.RHCFid = fc.RHCFid
					on fc.RHFid = f.RHFid
				left join CFuncional cf
					on cf.CFid = f.CFidnuevo
			 where f.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEid#" >
			   and fc.CPformato is not null
			group by Periodo, Mes, fc.CPformato, cf.Ocodigo, f.Mcodigo
		</cfquery>
		<!--- OBTIENE EL TOTAL DE LOS MONTO POR MES+CUENTA DE OTRAS PARTIDAS --->
		<cfquery datasource="#session.dsn#">
			insert into #FORMULACION# 
					(CPCano, CPCmes, 
					 Cmayor, CPformato,
					 Mcodigo, MontoBase)
			select b.Periodo, b.Mes,
					<cf_dbfunction name="sPart" args="d.CPformato,1,4">,
					d.CPformato
					a.Mcodigo,sum(b.Monto)
			from RHOPFormulacion a
			inner join RHOPDFormulacion b
				on b.RHOPFid = a.RHOPFid
			inner join RHOtrasPartidas c
				on c.RHOPid = a.RHOPid
			inner join RHPOtrasPartidas d
				on d.RHPOPid = c.RHPOPid
			where a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEid#" >
			group by b.Periodo, b.Mes,a.Mcodigo,d.CPformato
		</cfquery>
		<!--- OBTIENE EL TOTAL DE LOS MONTOS POR MES+CUENTA DE LAS CARGAS --->
        <cfquery datasource="#session.DSN#">
        	insert into #FORMULACION# 
					(CPCano, CPCmes, 
					 Cmayor, CPformato,
					 Mcodigo, MontoBase)
            select Periodo,Mes,<cf_dbfunction name="sPart" args="CPformato,1,4">,Mcodigo,sum(RHCPFmontoCarga)
            from RHCPFormulacion 
            where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHEid#" >
            group by Periodo, Mes,Mcodigo,CPformato
        </cfquery>
		<cf_dump var="#FORMULACION#">
		<!--- 
			SE DEBEN LLENAR LAS TABLAS DE VERSIONES EN EL SIGUIENTE ORDEN:
				CVMayor, CVPrespuesto, CVFormulacionTotales, CVFormulacionMonedas
			TANTO EL TIPO DE CAMBIO COMO EL MONTO APLICAR EN FormulacionMonedas, 
			COMO TOTAL MONTOS SOLICITADO Y APLICAR EN FormulacionTotales
			SE CALCULAN AUTOMATICAMENTE
		--->
		<cfinclude template="../Utiles/sifConcat.cfm">
		<cfquery datasource="#session.dsn#">
			insert into CVMayor
				(Ecodigo, 
				CVid, 
				Cmayor, 
				Ctipo, 
				CPVidOri, 
				PCEMidOri, 
				Cmascara,
				CVMtipoControl,
				CVMcalculoControl)
			select distinct
				a.Ecodigo, 
				#LvarCVid#, 
				a.Cmayor, 
				a.Ctipo, 
				b.CPVid as CPVidOri, 
				b.PCEMid as PCEMidOri, 
				d.PCEMformatoP as Cmascara,
				(case Ctipo when 'A' then 1 when 'G' then 1 else 0 end),
				2
			from #FORMULACION#
				inner join CtasMayor a
					inner join CPVigencia b	<!--- Primera Vigencia del Inicio del Periodo o que empiece despues del Inicio --->
							inner join PCEMascaras d
							  on d.PCEMid = b.PCEMid
							 <cfif LvarCVtipo EQ "2">
							 and coalesce(rtrim(d.PCEMformatoP) #_Cat# ' ',' ') <> ' '
							 </cfif>
						 ON b.Ecodigo = a.Ecodigo
						and b.Cmayor  = a.Cmayor
						and b.CPVdesde =
							(select min(v.CPVdesde)
							   from CPVigencia v, CPresupuestoPeriodo p
							  where v.Ecodigo 	= a.Ecodigo
								and v.Cmayor  	= a.Cmayor
								and p.CPPid 	= #rsEscenario.CPPid#
								and (
										p.CPPfechaDesde between v.CPVdesde 		and v.CPVhasta
									OR 
										v.CPVdesde		between p.CPPfechaDesde and p.CPPfechaHasta
									)
							)
					 on a.Ecodigo = #session.Ecodigo#
					and a.Cmayor = #FORMULACION#.Cmayor
			where not Exists 
				(
					select 1 from CVMayor
					 where Ecodigo 	= #session.Ecodigo#
					   and CVid		= #LvarCVid#
					   and Cmayor	= #FORMULACION#.Cmayor
				)
		</cfquery>

		<!--- Para evitar choques del CVPcuenta con Cuentas de Presupuesto que
				no vengan de Planilla Presupuestaria, se saca la mayor CVPcuenta
				existente y se le suma el min(#FORMULACION#.id) (xk se repite la cuenta)
		--->
		<cfquery name="rsMaximo" datasource="#session.dsn#">
			select coalesce(max(CPcuenta),0) as valor
			  from CVPresupuesto 
			 where Ecodigo	= #session.Ecodigo#
			   and CVid	= #LvarCVid#
		</cfquery>
		<cfquery datasource="#session.dsn#">
			update #FORMULACION# 
			   set CVPcuenta =
					(select min(ID)
					   from #FORMULACION# f2
					  where f2.CPformato = 	#FORMULACION#.CPformato
					) + #rsMaximo.valor#
		</cfquery>

		<cfquery datasource="#session.dsn#">
			insert into CVPresupuesto
				(
					Ecodigo, 
					CVid, 
					CVPcuenta,
					Cmayor, 
					CPcuenta,
					CPformato,
					CPdescripcion,
					CVPtipoControl, 
					CVPcalculoControl,
					CVPorigen
				)
			select distinct
					#session.Ecodigo#,
					#LvarCVid#,
					#FORMULACION#.CVPcuenta,
					#FORMULACION#.Cmayor,
					null,
					#FORMULACION#.CPformato,
					#FORMULACION#.CPformato,
					1,
					1,
					'RH'
			  from #FORMULACION#
		</cfquery>

		<cfquery datasource="#session.dsn#">
			insert into CVFormulacionTotales
				(
					Ecodigo, 
					CVid, 
					CPCano,
					CPCmes,
					CVPcuenta,
					Ocodigo
				)
			select distinct
					#session.Ecodigo#,
					#LvarCVid#,
					#FORMULACION#.CPCano,
					#FORMULACION#.CPCmes,
					#FORMULACION#.CVPcuenta,
					#FORMULACION#.Ocodigo
			  from #FORMULACION#
		</cfquery>

		<cfquery datasource="#session.dsn#">
			insert into CVFormulacionMonedas
				(
					Ecodigo, 
					CVid, 
					CPCano,
					CPCmes,
					CVPcuenta,
					Ocodigo,
					Mcodigo,
					CVFMmontoBase
				)
			select 	#session.Ecodigo#,
					#LvarCVid#,
					#FORMULACION#.CPCano,
					#FORMULACION#.CPCmes,
					#FORMULACION#.CVPcuenta,
					#FORMULACION#.Ocodigo,
					#FORMULACION#.Mcodigo,
					#FORMULACION#.MontoBase
			  from #FORMULACION#
		</cfquery>
		
		<cfset AjustaFormulacion(LvarCVid)>

		<cfquery name="rsEscenario" datasource="#session.dsn#">
			update RHEscenarios
			   set RHEestado = 'V'
			 where RHEid 	= #Arguments.RHEid#
		</cfquery>

	</cffunction>
<!---================Genera la Versión de Presupuesto, segun la estimación de Fuentes de Financiamiento y Egresos==================--->
	<cffunction name="GeneraPresupuesto" output="false" access="public">
		<cfargument name="Conexion"		type="string"	required="no">
		<cfargument name="Ecodigo"		type="numeric"	required="no">
		<cfargument name="CPPid"		type="numeric"	required="yes">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>	
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>	
		
		<cf_dbfunction name="OP_concat" returnvariable="_Cat" datasource="#Arguments.Conexion#">
		<!---Valida el periodo Presupuestal--->
		<cfquery name="rsCPperiodo" datasource="#Arguments.Conexion#">
			select CPPestado, Ecodigo, CPPfechaDesde, CPPfechaHasta
			  from CPresupuestoPeriodo
			 where CPPid = #Arguments.CPPid#
		</cfquery>
		<cfif rsCPperiodo.RecordCount EQ 0>
			<cf_errorCode	code = "51273" msg = "No existe el Período Presupuestario">
		<cfelseif rsCPperiodo.Ecodigo NEQ Arguments.Ecodigo>
			<cf_errorCode	code = "51274" msg = "El Período Presupuestario no pertenece a la Empresa">
		<cfelseif rsCPperiodo.CPPestado EQ 0>
			<cfset LvarCVtipo = "1">
		<cfelseif rsCPperiodo.CPPestado EQ 1>
			<cfset LvarCVtipo = "2">
		<cfelse>
			<cf_errorCode	code = "51276" msg = "El Período Presupuestario está cerrado y no se puede modificar">
		</cfif>
		<!---Valida que existan estimaciones, para el periodo presupuestal en estado "Aprobacion Externa"--->
		<cfquery name="rsEstimacionP" datasource="#Arguments.Conexion#">
			select count(1) as cantidad 
				from FPEEstimacion 
			where CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPPid#">
			  and FPEEestado = 4
		</cfquery>
		<cfif rsEstimacionP.cantidad EQ 0>
			<cfthrow message="No existen estimaciones para el periodo presupuestal en aprobación externa">
		</cfif>
		<!---Valida que no existan estimaciones, para el periodo presupuestal en estado Distinto a "Aprobacion Externa, Descartadas"--->
		<cfquery name="rsEstimacionP" datasource="#Arguments.Conexion#">
			select count(1) as cantidad 
				from FPEEstimacion 
			where CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPPid#">
			  and FPEEestado not in (4,7,6)
		</cfquery>
		<cfif rsEstimacionP.cantidad GT 0>
			<cfthrow message="Existe(n) #rsEstimacionP.cantidad# estimacion(es) para el periodo presupuestal que esta(n) Pendiente(s) de Aprobación">
		</cfif>
		<!---Valida la moneda local--->
		<cfquery name="rsMlocal" datasource="#Arguments.Conexion#">
			select Mcodigo from Empresas where Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfif rsMlocal.recordCount EQ 0 or not len(trim(rsMlocal.Mcodigo))>
			<cfthrow message="La empresa no tiene configurada la Moneda local">
		</cfif>
		<!---Se inserta la version de formulación presupuestal"--->
		<cfquery name="rsVersiones" datasource="#Arguments.Conexion#">
			select count(1) as cantidad
			from CVersion
			where Ecodigo = #Arguments.Ecodigo#
			  and CPPid   =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPPid#">
			  and CVtipo 	= <cfqueryparam cfsqltype="cf_sql_char" value="#LvarCVtipo#">
		</cfquery>
        <cfset ArrayAuxiliares = fnGetAuxiliares()>
        
	<cftransaction>
		<cfset LvarCVid = fnAltaVersion(LvarCVtipo, fnDescripcion(Arguments.CPPid, LvarCVtipo, rsCPperiodo.CPPfechaDesde, rsVersiones.cantidad, Arguments.Ecodigo, Arguments.Conexion), Arguments.CPPid, 2, 0, Arguments.Ecodigo, Arguments.Conexion)>
		<!---======Se Inserta CVMayor:Cuentas de Mayor Version
		CtasMayor.Ctipo (A= Activo  P=Pasivo C=Capital I=Ingreso G=Gasto O=Orden)
		CVMayor.CVMtipoControl (0=Abierto 1= Restringido 2=Restrictivo)
		=========--->
		<cfquery datasource="#Arguments.Conexion#">
			insert into CVMayor
				(Ecodigo, 
				CVid, 
				Cmayor, 
				Ctipo, 
				CPVidOri, 
				PCEMidOri, 
				Cmascara,
				CVMtipoControl,
				CVMcalculoControl)
			select distinct
				a.Ecodigo, 
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarCVid#">,
				<cf_dbfunction name="sPart" args="c.CFformato,1,4">,
				d.Ctipo, 
				c.CPVid, 
				e.PCEMid, 
				f.PCEMformatoP,
				(case d.Ctipo when 'A' then 1 when 'G' then 1 else 0 end),
				3
			from FPEEstimacion a 
				inner join  FPDEstimacion  b 
					on a.FPEEid = b.FPEEid 
				inner join PCGcuentas c
					on c.PCGcuenta = b.PCGcuenta
				inner join CtasMayor d
					on d.Ecodigo =  a.Ecodigo
					and d.Cmayor = <cf_dbfunction name="sPart" args="c.CPformato,1,4">
				inner join CPVigencia e
					on e.CPVid = c.CPVid
				inner join PCEMascaras f
					on f.PCEMid = e.PCEMid
			where a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPPid#">
			  and a.FPEEestado = 4
			  and not Exists 
				(
					select 1 from CVMayor
					 where Ecodigo 	= a.Ecodigo
					   and CVid		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarCVid#">
					   and Cmayor	= <cf_dbfunction name="sPart" args="c.CPformato,1,4">
				)
		</cfquery>
		<!---CVPresupuesto: Cuentas de Presupuesto Version--->
		<cfquery datasource="#Arguments.Conexion#">
			insert into CVPresupuesto
				(
					Ecodigo, 
					CVid, 
					CVPcuenta,
					Cmayor, 
					CPcuenta,
					CPformato,
					CPdescripcion,
					CVPtipoControl, 
					CVPcalculoControl,
					CVPorigen
				)
			select distinct
					a.Ecodigo,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarCVid#">,
					c.PCGcuenta,
					<cf_dbfunction name="sPart" args="c.CFformato,1,4">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
					c.CPformato,
					c.CPformato,
					2,<!---Restrictivo--->
					3,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">
			  from FPEEstimacion a 
				inner join  FPDEstimacion  b 
					on a.FPEEid = b.FPEEid 
				inner join PCGcuentas c
					on c.PCGcuenta = b.PCGcuenta
			where a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPPid#">
			  and a.FPEEestado = 4
		</cfquery>
		<!---CVFormulacionTotales:Formulacion Presupuesto Version--->
		<cfquery datasource="#Arguments.Conexion#">
			insert into CVFormulacionTotales
				(
					Ecodigo, 
					CVid, 
					CPCano,
					CPCmes,
					CVPcuenta,
					Ocodigo
				)
			select distinct
					a.Ecodigo,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarCVid#">,
					Case 
                    	when #ArrayAuxiliares[3]# < d.CPPanoMesDesde then d.CPPanoMesDesde /100
                        when #ArrayAuxiliares[3]# > d.CPPanoMesHasta then d.CPPanoMesHasta /100
                        else #ArrayAuxiliares[1]# end,
                    Case 
                    	when #ArrayAuxiliares[3]# < d.CPPanoMesDesde then d.CPPanoMesDesde - d.CPPanoMesDesde /100 *100
                        when #ArrayAuxiliares[3]# > d.CPPanoMesHasta then d.CPPanoMesHasta - d.CPPanoMesHasta /100 *100
                        else #ArrayAuxiliares[2]# end,
					c.PCGcuenta,
					e.Ocodigo
			   from FPEEstimacion a 
				inner join  FPDEstimacion  b 
					on a.FPEEid = b.FPEEid 
				inner join PCGcuentas c
					on c.PCGcuenta = b.PCGcuenta
				inner join CPresupuestoPeriodo d
					on d.CPPid = a.CPPid
				inner join CFuncional e
					on e.CFid = a.CFid
			where a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPPid#">
			  and a.FPEEestado = 4
		</cfquery>
		<cfquery name="rsAnoMes" datasource="#Arguments.Conexion#">
			select
					Case 
                    	when #ArrayAuxiliares[3]# < d.CPPanoMesDesde then d.CPPanoMesDesde /100
                        when #ArrayAuxiliares[3]# > d.CPPanoMesHasta then d.CPPanoMesHasta /100
                        else #ArrayAuxiliares[1]# end as Ano,
                    Case 
                    	when #ArrayAuxiliares[3]# < d.CPPanoMesDesde then d.CPPanoMesDesde - d.CPPanoMesDesde /100 *100
                        when #ArrayAuxiliares[3]# > d.CPPanoMesHasta then d.CPPanoMesHasta - d.CPPanoMesHasta /100 *100
                        else #ArrayAuxiliares[2]# end as Mes
			  from CPresupuestoPeriodo d
			where d.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPPid#">
		</cfquery>
		<cfquery datasource="#Arguments.Conexion#">
			insert into CVFormulacionMonedas
				(
					Ecodigo, 
					CVid, 
					CPCano,
					CPCmes,
					CVPcuenta,
					Ocodigo,
					Mcodigo,
					CVFMmontoBase
				)
			select a.Ecodigo,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarCVid#">,
					#rsAnoMes.Ano#, #rsAnoMes.Mes#,
					c.PCGcuenta,
					e.Ocodigo,
					#rsMlocal.Mcodigo#,
					min(coalesce(d.CPCpresupuestado + d.CPCmodificado,0)) + sum(b.DPDEmontoAjuste * b.Dtipocambio)
			  from FPEEstimacion a 
				inner join  FPDEstimacion  b 
					on a.FPEEid = b.FPEEid 
				inner join PCGcuentas c
					on c.PCGcuenta = b.PCGcuenta
				inner join CFuncional e
					on e.CFid = a.CFid
			 	 left join CPresupuestoControl d
				   on d.Ecodigo	= a.Ecodigo
				  and d.CPPid		= a.CPPid
				  and d.CPCano		= #rsAnoMes.Ano#
				  and d.CPCmes		= #rsAnoMes.Mes#
				  and d.CPcuenta	= c.CPcuenta
				  and d.Ocodigo	= e.Ocodigo
			where a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPPid#">
			  and a.FPEEestado = 4
			  and coalesce(b.DPDEmontoAjuste,0) <> 0
			 group by a.Ecodigo, c.PCGcuenta, e.Ocodigo
		</cfquery>
		
		<cfset AjustaFormulacion(LvarCVid)>
		<cfinvoke component="sif.Componentes.FPRES_Equilibrio" method="CambioEstadoMasivo">
			<cfinvokeargument name="FPEEestado" value="5">
			<cfinvokeargument name="Filtro" 	value="CPPid = #Arguments.CPPid# and FPEEestado = 4">
		</cfinvoke>

	</cftransaction>
	</cffunction>
<!---=================rsAltaVersion: Inserta la version de formulación presupuestal=======--->
	<cffunction name="fnAltaVersion"  	access="private" returntype="numeric">
		<cfargument name="CVtipo" 			type="string" 	required="yes">
		<cfargument name="CVdescripcion" 	type="string" 	required="yes">
		<cfargument name="CPPid" 			type="numeric" 	required="yes">
		<cfargument name="CVestado" 		type="numeric"  required="yes">
		<cfargument name="CVaprobada" 		type="numeric"  required="no" default="0">
		<cfargument name="Ecodigo" 			type="numeric"  required="no">
		<cfargument name="Conexion" 		type="string"  	required="no">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>	
		
		<cfquery name="rsAltaVersion" datasource="#Arguments.Conexion#">
			insert into CVersion(Ecodigo, CVtipo, CVdescripcion, CPPid, CVestado, CVaprobada)
			values(	<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#Arguments.CVtipo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.CVdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.CPPid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.CVestado#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.CVaprobada#">
			)<cf_dbidentity1>
		</cfquery>
		<cf_dbidentity2 name="rsAltaVersion">
		<cfreturn rsAltaVersion.identity>
	</cffunction>		

<!---=================fnDescripcion: genera la descripción de la version de formulación presupuestal=======--->
	<cffunction name="fnDescripcion" returntype="string" output="false">
		<cfargument name="CPPid"		type="numeric"	required="yes">
		<cfargument name="Tipo"			type="numeric"	required="yes">
		<cfargument name="Fecha"		type="date"		required="yes">
		<cfargument name="Cantidad"		type="numeric"	required="yes">
		<cfargument name="Ecodigo" 		type="numeric"  required="no">
		<cfargument name="Conexion"		type="string"	required="no">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>	
		
		<cfset LvarVersion = Arguments.Cantidad + 1>
		
		<cfloop condition="true">
			<cfif LvarVersion GT 1000>
				<cfset LvarVer = "V.#right('0000' & (LvarVersion),4)#">
			<cfelse>
				<cfset LvarVer = "V.#right('000' & (LvarVersion),3)#">
			</cfif>
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select count(1) as cantidad
				  from CVersion v
				 where v.Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				   and v.CPPid 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPPid#">
				   and v.CVtipo 		= <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.tipo#">
				   and v.CVdescripcion <cf_dbfunction name="OP_concat"> ' ' like '%#LvarVer# %'
			</cfquery>
			<cfif rsSQL.cantidad EQ 0>
				<cfif Arguments.Tipo EQ 1>
					<cfreturn "Presupuesto Ordinario #dateFormat(Arguments.Fecha,'YYYY-MM')# #LvarVer#">
				<cfelse>
					<cfreturn "Modificación Presupuestaria #dateFormat(Arguments.Fecha,'YYYY-MM')# #LvarVer#">
				</cfif>
			</cfif>
			<cfset LvarVersion = LvarVersion + 1>
		</cfloop>
	</cffunction>
   <!---====================================================
		     ArrayAuxiliares[0] = Periodo Auxiliar    
		     ArrayAuxiliares[1] = Mes Auxiliar        
		     ArrayAuxiliares[2] = PeriodoMes Auxiliar 
	====================================================--->
	<cffunction name="fnGetAuxiliares" returntype="array" output="false">
		<cfargument name="Ecodigo" 		type="numeric"  required="no">
		<cfargument name="Conexion"		type="string"	required="no">
        	
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>	
        
        <cfquery name="rsPeriodo" datasource="#Arguments.Conexion#">
            select Pvalor
              from Parametros
             where Ecodigo = #Arguments.Ecodigo#
               and Pcodigo = 50
        </cfquery>
        <cfif rsPeriodo.recordCount EQ 0>
        	<cf_errorCode	code = "50031" msg = "No se ha definido el parámetro Periodo para los Sistemas Auxiliares! Proceso Cancelado!">
        </cfif>
        <cfquery name="rsMes" datasource="#Arguments.Conexion#">
            select Pvalor
              from Parametros
             where Ecodigo = #Arguments.Ecodigo#
               and Pcodigo = 60
        </cfquery>
         <cfif rsMes.recordCount EQ 0>
			<cf_errorCode	code = "50032" msg = "No se ha definido el parámetro Mes para los Sistemas Auxiliares! Proceso Cancelado!">
         </cfif> 
           
    	<cfset Array_Auxiliar = ArrayNew(1)>
		<cfset Array_Auxiliar[1] = rsPeriodo.Pvalor>
        <cfset Array_Auxiliar[2] = rsMes.Pvalor>
        <cfset Array_Auxiliar[3] = rsPeriodo.Pvalor*100+rsMes.Pvalor>
    
        <cfreturn Array_Auxiliar>
	</cffunction>
</cfcomponent>
