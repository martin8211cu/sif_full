<cfcomponent>
	 <!--- Obtiene los datos de la tabla de Parámetros según el pcodigo --->
		<cffunction name="ObtenerDato" returntype="query">
			<cfargument name="pcodigo" type="numeric" required="true">	
			<cfquery name="rs" datasource="#Session.DSN#">
				select Pvalor
				from Parametros
				where Ecodigo = #Session.Ecodigo#  
				  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
			</cfquery>
			<cfreturn #rs#>
		</cffunction>

		<cfset Lvar_BTidPR = ObtenerDato(2000).Pvalor>
		
		<cfif #Lvar_BTidPR# eq ''>
			<cfthrow message="No se ha definido Tipo de Movimiento Bancario Pago de Renta - Agregar en: Bancos/Cat&aacute;logos/Tipos de Transacci&oacute;n  y Definir en: Administraci&oacute;n del Sistema/Par&aacute;metros Adicionales">
		</cfif>

	<!---==================Genera Retención ==================--->
	<cffunction name="generaRetencion"  access="public"  returntype="string">
		<cfargument name="Conexion" 	 	  type="string"  required="false" default="#session.dsn#">
		<cfargument name="DREstado" 		  type="numeric" required="true">
		<cfargument name="periodo" 	  	  type="numeric" required="true">
		<cfargument name="mes" 				  type="numeric"  required="true">
		<cfargument name="Oficina" 		  type="numeric" required="true">
		<cfargument name="Rcodigo" 		  type="string"  required="false">
		<cfargument name="Ecodigo"    	  type="numeric" required="true" default="#Session.Ecodigo#">
		<cfargument name="BMUsucodigo"    type="numeric" required="false" default="#Session.Usucodigo#">


		<cfset mes_  = RepeatString("0", 2-len(trim(Arguments.mes)) ) & "#trim(Arguments.mes)#">
		
		<cfquery datasource="#Arguments.Conexion#" name="rsFacturasRegistradas">
		  	select  count(1) as cantidad
				from TESsolicitudPago sp
					inner join TESdetallePago dp
								on dp.TESSPid = sp.TESSPid 
								and dp.RlineaId is null and dp.MlineaId is null									
								and dp.TESDPtipoDocumento = 1
					inner join TESacuerdoPago ap
							on ap.TESAPid  = sp.TESAPid 
					left join HEDocumentosCP cxp
							on cxp.IDdocumento = dp.TESDPidDocumento and dp.TESDPtipoDocumento = 1
					inner join BMovimientosCxP a
							on cxp.Ddocumento = a.Ddocumento 
							and cxp.CPTcodigo = a.CPTcodigo
							and cxp.SNcodigo = a.SNcodigo
					inner join Monedas m
							on m.Ecodigo = sp.EcodigoOri and m.Mcodigo = sp.McodigoOri
					inner join Retenciones rt
							on rt.Rcodigo = dp.Rcodigo
							
					left outer join  RetencionesComp comp
							on comp.Ecodigo = rt.Ecodigo
							and comp.Rcodigo = rt.Rcodigo
					left outer join Retenciones rt2
							 on comp.RcodigoDet = rt2.Rcodigo
							 and comp.Ecodigo = rt2.Ecodigo									
							
					inner join SNegocios  sn
							on  sp.EcodigoOri 	= sn.Ecodigo
							and sp.SNcodigoOri = sn.SNcodigo	
					where <!---dp.OcodigoOri = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Oficina#"> --->
							ap.Ocodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Oficina#"> 
							and <cf_dbfunction name="date_part" args="yyyy,ap.TASAPfecha"> = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.periodo#">
							and <cf_dbfunction name="date_part" args="mm,ap.TASAPfecha"> = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.mes#">
							and coalesce(comp.RcodigoDet,dp.Rcodigo) = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.Rcodigo#">
							and sp.EcodigoOri =   #session.Ecodigo#
							and coalesce(dp.Rmonto,0) > 0								
					group by
						sp.TESSPid,
						ap.TESAPnumero,												 
						sp.EcodigoOri , 
						a.CPTcodigo , 		
						a.Ddocumento , 
						sp.SNcodigoOri ,
						dp.Rcodigo , 
						comp.RcodigoDet,
						sp.McodigoOri , 		
						ap.TASAPfecha ,
						dp.TESDPtipoCambioOri  
									
				union all 
						
				select  count(1) as cantidad
					from GEliquidacionGasto a
						inner join Retenciones rt
							on  rt.Rcodigo = a.Rcodigo
							and rt.Ecodigo = a.Ecodigo 
							
						left outer join  RetencionesComp comp
							on comp.Ecodigo = rt.Ecodigo
							and comp.Rcodigo = rt.Rcodigo
							
						inner join Monedas m
							on a.Mcodigo 	= m.Mcodigo
						inner join SNegocios  sn
							on  sn.SNcodigo = a.SNcodigo
							and sn.Ecodigo = a.Ecodigo 
						inner join CFuncional cf
							on a.CFid = cf.CFid 
					where cf.Ocodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Oficina#"> 
					and <cf_dbfunction name="date_format" args="GELGfecha,YYYY"> = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.periodo#">
					and <cf_dbfunction name="date_format" args="GELGfecha,MM">	 = '#mes_#'
					and rt.Ecodigo = #Arguments.Ecodigo#	
		</cfquery>


		<cfquery dbtype="query" name="totalReg">
			select sum(cantidad) as sumaR from rsFacturasRegistradas
		</cfquery>
		
		<cfif #totalReg.sumaR# NEQ 0>
			<cfquery datasource="#Arguments.Conexion#" name="rsExisteRegistro">
				select count(*) as cantidad from EDRetenciones enc
				inner join ddretenciones det
				  on enc.drid=det.drid
					where enc.Ecodigo = #session.Ecodigo#
					and enc.Ocodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Oficina#"> 
					and enc.DRPeriodo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.periodo#">
					and enc.DRMes	  = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.mes#">
					and det.rcodigo= <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.Rcodigo#">
					

<!---	  select count(1) as cantidad
				from EDRetenciones
					where Ocodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Oficina#"> 
					and DRPeriodo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.periodo#">
					and DRMes	  = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.mes#">
					--->
			 </cfquery>
			
				<cfif #rsExisteRegistro.cantidad# EQ 0>
				
				<cfquery datasource="#Arguments.Conexion#" name="rsInsertaEncabezado">
						insert into EDRetenciones (
							Ecodigo,
							DREstado, 
							DRTotal, 
							DRMes,  
							DRPeriodo,     
							DRNumConfirmacion, 
							Bid,
							CBid,  
							CFid,
							BTid,   
							Mcodigo,        
							Ocodigo,    
							BMfecha,    
							BMUsucodigo   
							)
						values(
							#Arguments.Ecodigo#,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.DREstado#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="0.00">,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.mes#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	   value="#Arguments.periodo#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="null">,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="null">,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="null">,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="null">,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Lvar_BTidPR#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="null">,
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.Oficina#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" 	value="#now()#">,
							 #Arguments.BMUsucodigo#
							)
						 <cf_dbidentity1>
					  </cfquery>
						 <cf_dbidentity2 name="rsInsertaEncabezado" verificar_transaccion="false" returnvariable="LvarId">
		  
				<cfset mes_  = RepeatString("0", 2-len(trim(Arguments.mes)) ) & "#trim(Arguments.mes)#">
						<cfquery datasource="#Arguments.Conexion#" name="rsInsertaDetalle">
							insert into DDRetenciones (
								TESSPid,
							    TESAPnumero, 
								DRid, 
								Ecodigo,
								DROrigen,
								CPTcodigo,
								Ddocumento,
								CPTRcodigo,
								DRdocumento,
								SNcodigo,
								Rcodigo,
								Mcodigo,
								Pfecha,
								MontoR,
								MTotal,
								Dtipocambio,
								BMfecha,
								BMUsucodigo)
				
						select  sp.TESSPid,
							    ap.TESAPnumero,								
								#LvarId# as id,							 
								sp.EcodigoOri as Ecodigo, 
								'CP' as origen,		
								a.CPTcodigo as CPTcodigo, 		
								a.Ddocumento as documento, 
								a.CPTcodigo as CPTRcodigo, 	
								a.Ddocumento as documento_, 	
								sp.SNcodigoOri as SNcodigo,
								coalesce(comp.RcodigoDet,dp.Rcodigo) as Rcodigo, 
								sp.McodigoOri as Mcodigo, 		
								ap.TASAPfecha as fecha, 
								sum(case when comp.RcodigoDet is not null 
									then  dp.TESDPmontoSolicitadoOri * rt2.Rporcentaje /100
									 else dp.Rmonto end)as monto,
								sum(case
									when dp.TESDPtipoDocumento in (0,5) AND dp.TESDPmontoSolicitadoOri < 0 then 0 else dp.TESDPmontoSolicitadoOri
								end) as mtotal,
								case when dp.TESDPtipoCambioOri is null then 1 else dp.TESDPtipoCambioOri end as tipocambio,
								<cf_jdbcquery_param value="#now()#" cfsqltype="cf_sql_timestamp">, 
								#Arguments.BMUsucodigo#
						from TESsolicitudPago sp
							inner join TESdetallePago dp
										on dp.TESSPid = sp.TESSPid 
										and dp.RlineaId is null and dp.MlineaId is null									
										and dp.TESDPtipoDocumento = 1
							inner join TESacuerdoPago ap
									on ap.TESAPid  = sp.TESAPid 
							left join HEDocumentosCP cxp
									on cxp.IDdocumento = dp.TESDPidDocumento and dp.TESDPtipoDocumento = 1
							inner join BMovimientosCxP a
			  						on cxp.Ddocumento = a.Ddocumento 
									and cxp.CPTcodigo = a.CPTcodigo
									and cxp.SNcodigo = a.SNcodigo
							inner join Monedas m
									on m.Ecodigo = sp.EcodigoOri and m.Mcodigo = sp.McodigoOri
							inner join Retenciones rt
									on rt.Rcodigo = dp.Rcodigo
									
							left outer join  RetencionesComp comp
									on comp.Ecodigo = rt.Ecodigo
									and comp.Rcodigo = rt.Rcodigo
							left outer join Retenciones rt2
									 on comp.RcodigoDet = rt2.Rcodigo
									 and comp.Ecodigo = rt2.Ecodigo									
									
							inner join SNegocios  sn
									on  sp.EcodigoOri 	= sn.Ecodigo
									and sp.SNcodigoOri = sn.SNcodigo	
							where <!---dp.OcodigoOri = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Oficina#"> --->
									ap.Ocodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Oficina#"> 
									and <cf_dbfunction name="date_part" args="yyyy,ap.TASAPfecha"> = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.periodo#">
									and <cf_dbfunction name="date_part" args="mm,ap.TASAPfecha"> = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.mes#">
									<!---and coalesce(comp.RcodigoDet,dp.Rcodigo) = '02'--->
									and coalesce(comp.RcodigoDet,dp.Rcodigo) = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.Rcodigo#">
									and sp.EcodigoOri =   #session.Ecodigo#
									and coalesce(dp.Rmonto,0) > 0								
							group by
							    sp.TESSPid,
								ap.TESAPnumero,												 
								sp.EcodigoOri , 
								a.CPTcodigo , 		
								a.Ddocumento , 
								sp.SNcodigoOri ,
								dp.Rcodigo , 
								comp.RcodigoDet,
								sp.McodigoOri , 		
								ap.TASAPfecha ,
								dp.TESDPtipoCambioOri  
									
					union all 
						
						select  1,
								'GESTION EMPLEADO',
							  #LvarId# as id,
							   #Arguments.Ecodigo# as Ecodigo,
								'CH' as origen,
								'CH' as CPTcodigo,
								a.GELGnumeroDoc as documento, 
								'CH' as CPTRcodigo, 	
								a.GELGnumeroDoc as documento_, 	
								a.SNcodigo as SNcodigo,
								coalesce(comp.RcodigoDet,a.Rcodigo) as Rcodigo, 
								a.Mcodigo as Mcodigo, 		
								a.GELGfecha as fecha, 
								Coalesce(a.GELGtotalRet,0) as monto,
								Coalesce(a.GELGtotalOri,0) as monto,
								a.GELGtipoCambio as tipocambio,
								<cf_jdbcquery_param value="#now()#" cfsqltype="cf_sql_timestamp">, 
								#Arguments.BMUsucodigo#
							from GEliquidacionGasto a
								inner join Retenciones rt
									on  rt.Rcodigo = a.Rcodigo
									and rt.Ecodigo = a.Ecodigo 
									
								left outer join  RetencionesComp comp
									on comp.Ecodigo = rt.Ecodigo
									and comp.Rcodigo = rt.Rcodigo
									
								inner join Monedas m
									on a.Mcodigo 	= m.Mcodigo
								inner join SNegocios  sn
									on  sn.SNcodigo = a.SNcodigo
									and sn.Ecodigo = a.Ecodigo 
								inner join CFuncional cf
									on a.CFid = cf.CFid 
							where cf.Ocodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Oficina#"> 
							and <cf_dbfunction name="date_format" args="GELGfecha,YYYY"> = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.periodo#">
							and <cf_dbfunction name="date_format" args="GELGfecha,MM">	 = '#mes_#'
							and rt.Ecodigo = #Arguments.Ecodigo#				
						</cfquery>
					<cfelse>
						<cfthrow message="El Registro para el Periodo:#Arguments.periodo# Mes:#Arguments.mes# ya se gener&oacute;">
					</cfif>	
					
						<cfquery name="sumRegistros" datasource="#session.dsn#">
						select 
								Coalesce(sum(a.MontoR * a.Dtipocambio),0) as suma
							from EDRetenciones enc
							inner  join DDRetenciones a
								on enc.DRid = a.DRid
						  where  enc.DRid = #LvarId#
							and a.Ecodigo =  #Arguments.Ecodigo#
						</cfquery>
						
						<cfquery name="rsMoneda" datasource="#session.DSN#">
							select Mcodigo as value
							  from Empresas 
							where Ecodigo =  #session.Ecodigo# 
						</cfquery>

						<cfquery datasource="#session.dsn#">
						
							update EDRetenciones enc
							set DRTotal = #sumRegistros.suma#,
							Mcodigo =#rsMoneda.value#
							
									where enc.Ecodigo = #Arguments.Ecodigo#
									and enc.Ocodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Oficina#"> 
									and enc.DRPeriodo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.periodo#">
									and enc.DRMes	  = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.mes#">
									and  exists(select 1 from ddretenciones det
				  							where enc.drid=det.drid
											and det.rcodigo= <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.Rcodigo#">	
										)															  							  
						</cfquery>
				<cfelse>
					<cfthrow message="El Registro para el Periodo:#Arguments.periodo# - Mes:#Arguments.mes# no puede ser Generado, porque no posee facturas asociadas.">
			</cfif>
	</cffunction>
	
	
	<!---==================MODIFICAR==================--->
	<cffunction name="CAMBIO_Dpago_Retencion" access="public" returntype="string">
		<cfargument name="Conexion" 	   	type="string"  required="false" default="#session.dsn#">
		<cfargument name="Ecodigo" 			type="numeric" required="false" default="#session.Ecodigo#">
		<cfargument name="DRid" 		   	type="numeric" required="true">
		<cfargument name="Bid"     			type="numeric"  required="true">
		<cfargument name="CBid"  				type="numeric"  required="true">
		<cfargument name="CFid"  				type="numeric"  required="true">
		<cfargument name="DRNumConfirmacion"type="numeric"  required="true">
		<cfargument name="BMfecha"    		type="date" required="false" default="#now()#">
		<cfargument name="BMUsucodigo"    	type="numeric" required="false" default="#Session.Usucodigo#">

		<cfquery datasource="#Arguments.Conexion#">	
			update EDRetenciones set 
				Bid 						= 	<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Bid#">,
				CBid 						= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.CBid#">,
				CFid						= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.CFid#">,
				DRNumConfirmacion 	= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.DRNumConfirmacion#">,
				BMUsucodigo	 			= #Arguments.BMUsucodigo#,
				BMfecha  	 			= #Arguments.BMfecha#
			where DRid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.DRid#">
		</cfquery>
	</cffunction>
	
	<!---==================ELIMINAR UN Tipo Evento==================--->
	<cffunction name="Elimina_declaracion_pago_retencion"  access="public" returntype="string">
		<cfargument name="Conexion" 	type="string"  required="false" default="#session.dsn#">
		<cfargument name="DRid" 		type="numeric" required="true">
		
			<cfquery name="rsExisteE" datasource="#session.DSN#">
				select count(1) as cantidad 
				from EDRetenciones a
					where a.DRid   = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.DRid#">
					and a.DREstado = 2
			</cfquery>
		
			<cfif #rsExisteE.cantidad# EQ 0>
				<cfquery datasource="#Arguments.Conexion#">	
					delete from DDRetenciones 
					where DRid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.DRid#"> 
				</cfquery>
				
				<cfquery datasource="#Arguments.Conexion#">	
					delete from EDRetenciones 
					where DRid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.DRid#"> 
				</cfquery>
			<cfelse>
				<cfthrow message="No se puede eliminar porque La Declaración de Pago de Renta ya fue aplicada.">
			</cfif>
	</cffunction>
	
	
	<cffunction name="APLICAR" access="public" returntype="numeric">
		<cfargument name="DRid" 		type="numeric" required="yes">
		<cfargument name="estado" 		type="numeric" required="no"    default="2">
		<cfargument name="BMfecha"    type="date" 	required="false" default="#now()#">
		<cfargument name="BMUsucodigo"type="numeric" required="false" default="#Session.Usucodigo#">
		<cfargument name="Conexion" 	type="string"  required="no" 	  default="#session.DSN#">
		
		<cfquery name="modificarAjuste" datasource="#arguments.Conexion#">
			update EDRetenciones set
				DREstado 		= <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Arguments.estado#">, 
				BMUsucodigo	 	= #Arguments.BMUsucodigo#,
				BMfecha  	 	= #Arguments.BMfecha#
			where DRid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.DRid#"> 
		</cfquery>
		<cfreturn #arguments.DRid#>
	</cffunction>
</cfcomponent>
