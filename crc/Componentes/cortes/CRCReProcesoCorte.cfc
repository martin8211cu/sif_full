<cfcomponent displayname="CRCReProcesoCorte" extends="crc.Componentes.cortes.CRCProcesoCorte" hint="Recalcula el corte en los estados de saldo vencido calculado(2) y monto a pagar(1). Extiende del componente de proceos de corte">

	<cffunction name="reProcesarCorte">
		<cfargument name="cuentaID" type ="string" required="false" default="">  
		<cfargument name="dsn" type ="string" required="false" default="#session.DSN#">  
		<cfargument name="ecodigo" type ="string" required="false" default="#this.Ecodigo#">  
    
		<!--- se procesan el corte en estado dos donde esta involucrada la cuenta--->
		<cfset cCorte = createobject("component", "crc.Componentes.cortes.CRCCortes").init(TipoCorte = "",
																					       conexion  = #arguments.dsn#, 
																					       ECodigo   = #arguments.ecodigo#)>	 
		<cfset init(isReproceso=true)>
		<cfset this.isReproceso=true>
		<cfset inicializarParametros()>
		<cfset validarArgumentoTipoCuenta(cuentaID=#arguments.cuentaID#)>
		<cfset This.cortesAnteriores = cCorte.obtenerCortePorStatus(Tipo_Producto=#This.Tipo_Producto#, status = 2)>
		<cfset this.cortesACerrar = cCorte.obtenerCortePorStatus(Tipo_Producto=#This.Tipo_Producto#, status = 1)>
		<cfset This.C_TT_INTERESES = 'IN'>
		<cfset This.C_TT_MAYORISTA = 'TM'>  

		<cfset This.listadoCortesACerrar = ArrayNew(1)>
		<cfquery name="qPeriodoMP"  datasource="#arguments.dsn#">
 	    	select Codigo, Tipo, FechaFin, FechaInicio
        	from CRCCortes 
        	where Codigo = '#this.cortesACerrar#'
 	    </cfquery>
		
		<cfset index = 1>
		<cfloop query = "qPeriodoMP"  > 
			<cfset cortesInfo.codigo 		= qPeriodoMP.Codigo>
			<cfset cortesInfo.tipo   		= qPeriodoMP.Tipo> 
			<cfset cortesInfo.FechaFin      = qPeriodoMP.FechaFin>
			<cfset cortesInfo.FechaInicio   = qPeriodoMP.FechaInicio>  
			<cfset this.listadoCortesACerrar[index] = #cortesInfo#>  
			<cfset index = index + 1>
		</cfloop>	

 		
		<cfif  This.cortesAnteriores neq ''>
			<cfset calculoParaCorteAnterior()>
			<cfset crearParcialidadPorSaldoVencido()>
			<cfset CrearActualizarMccPorCortes(cortes=#This.cortesAnteriores#, anterior=true)>
		</cfif>

		<cfif This.cortesACerrar neq ''>
			<cfset calculoParaMC()>
			<cfset CrearActualizarMccPorCortes(cortes=#This.cortesACerrar# , anterior=false)>	
		</cfif>

		<cfif  This.cortesAnteriores neq ''>
			<cfset afectarSoloSAldo(#arguments.cuentaID#)>
		</cfif>

		<cfset crearTransactionPorInteresesRE()>

		<cfset actualizarCuentas()>

		<cfset actualizarEstadoCuenta()>
	      
	</cffunction>

	<cffunction name="crearTransactionPorInteresesRE" returntype="void" hint="se crean transacciones por intereses generados en los cortes anteriores"> 
  		
 		<cfquery name="qMovCuentaInt" datasource="#This.dsn#">
 			select c.id cuentaID, c.Tipo, mc.Intereses, mc.Corte, t.Fecha FechaTransaccion, t.TipoTransaccion, t.id transaccionID,
			 	cc.FechaInicioSV, cc.FechaFinSV
			from  CRCMovimientoCuenta mc
			inner join CRCTransaccion t
			on mc.CRCTransaccionid = t.id
			inner join CRCCortes cc on mc.Corte = cc.Codigo and cc.Tipo in (
									select Tipo from CRCCortes where Codigo in(
									<cfqueryparam value="#This.cortesACerrar#" cfsqltype="cf_sql_varchar" list="yes"/>)
			)
			inner join CRCCuentas c
			on t.CRCCuentasid  = c.id
			left join (
				select CRCCuentasid, Corte 
				from CRCMovimientoCuentaCorte
				where Corte in (<cfqueryparam value="#This.cortesACerrar#" cfsqltype="cf_sql_varchar" list="yes"/>)
			) mcccr on c.id = mcccr.CRCCuentasid
			where mc.Intereses > 0
			and  mc.Corte in (<cfqueryparam value="#This.cortesAnteriores#" 
							                cfsqltype="cf_sql_varchar"
							                list="yes"/> ) 
			and not exists (select * 
				from CRCTransaccion
				where  Fecha = cc.FechaInicioSV and CRCCuentasid  = c.id)
			<cfif  This.cuentaID neq "">
				  and c.id = #This.cuentaID#
			</cfif>
		</cfquery>		

  		<cfif qMovCuentaInt.recordCount gt 0 > 
			<cfquery name="rsTipoTransaccionIN" datasource="#This.DSN#">
				select id, Codigo as Tipo_Transaccion, Descripcion, TipoMov, afectaSaldo, afectaInteres, afectaCompras, afectaPagos, afectaCondonaciones,afectaGastoCobranza
				from CRCTipoTransaccion where Codigo = '#This.C_TT_INTERESES#'
			</cfquery> 	

			<cfif rsTipoTransaccionIN.recordCount gt 0 >
				<cfloop query="qMovCuentaInt">
					
					<cfif qMovCuentaInt.Tipo eq 'TM'>
						<cfquery name="rsMaxCorte" dbtype="query">
							select max(Corte) as Corte, cuentaID
							from qMovCuentaInt
							where cuentaID = #qMovCuentaInt.CuentaId#
							group by cuentaID
						</cfquery>
					</cfif>

					<cfif (  qMovCuentaInt.Tipo eq 'TM' 
							and DateDiff('d', now(), qMovCuentaInt.FechaInicioSV) lte 0 
							and DateDiff('d', now(), qMovCuentaInt.FechaFinSV) gt 0
							and (isdefined("rsMaxCorte") and rsMaxCorte.recordCount gt 0)
							and qMovCuentaInt.Corte eq rsMaxCorte.Corte
						  )
							
							or (qMovCuentaInt.Tipo neq 'TM')
					>
					
						<cfset loc.FechaT = ''>

						<cfif qMovCuentaInt.TipoTransaccion eq #This.C_TT_MAYORISTA#>
							<cfset loc.FechaT = #qMovCuentaInt.FechaTransaccion#>
						<cfelse>

							<cfset loc.FechaT = obtenerFechaFinCorteACerrar(Tipo_Producto = #qMovCuentaInt.Tipo#)>   
						</cfif>

						<cfif loc.FechaT neq ''>

							<cfset loc.FechaT = CreateDate(DatePart('yyyy',#loc.FechaT#), DatePart('m',#loc.FechaT#),DatePart('d',#loc.FechaT#))>

							<cfset crearTransaccion(CuentaID 		   = #qMovCuentaInt.cuentaID#,
													Tipo_TransaccionID = #rsTipoTransaccionIN.id#, 
													Fecha_Transaccion  = #loc.FechaT#,  
													Monto         	   = #qMovCuentaInt.Intereses#, 
													Parcialidades 	   =  1, 
													Observaciones 	   =  '#rsTipoTransaccionIN.Descripcion#',
													Descripcion 	   =  '[#qMovCuentaInt.transaccionID#] - #rsTipoTransaccionIN.Descripcion#',
													usarTagLastID      = false,
													MontoAPagar        = #qMovCuentaInt.Intereses#,
													AfectaMovCuenta    = false)>  
						</cfif>
					</cfif>
				</cfloop>
		 	</cfif>
 		</cfif>  

    </cffunction>

</cfcomponent>