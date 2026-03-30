<cfcomponent>
	<cffunction name="PosteoTransferencias" access="public" returntype="string" output="false">
		<cfargument name='Ecodigo'		type='numeric' 	required='false' default="#session.Ecodigo#">	 	<!--- Codigo empresa ---->
		<cfargument name='ETid' 		type='numeric' 	required='true'>	 								<!--- Codigo de la transferencia ---->
		<cfargument name='usuario' 		type='numeric' 	required='false'  default="#session.Usucodigo#">	<!--- Codigo del usuario ---->
		<cfargument name='LoginUsuario' type='string' 	required='false'  default="#session.Usulogin#">		<!--- Login del usuario ---->
		<cfargument name='debug' 		type='string' 	required='false' default="N">	 					<!--- Ejecutra el debug (muestra los sqls) S= si  N= no---->
		<cfargument name='Conexion' 	type='string' 	required='false' default="#session.DSN#">
		<cfargument name='trans' 		type='string' 	required='false' default="Y">	
		
		<cfset var varRet = '0'>
		<cfset LvarLoginUsuario = Arguments.LoginUsuario>
		<cfset LvarUsuario = Arguments.Usuario>
		<cfset LvarETid = Arguments.ETid>

		<cfset Periodo = 0>
		<cfset Mes = 0>
		<cfset Fecha = ''>
		<cfset descripcion =''>
		<cfset Monloc =0>
		<cfset edocbase =''>
		<cfset error =0>
		<cfset CuentaPuente =0>
		<cfset lin = 1>

		<!--- Validaciones: --->

			<!--- 1. Existe la transferencia ya?  Si existe se sale del componente por medio del Abort ---->
			<cfquery name="ExisteTransferencia" datasource="#Arguments.Conexion#">
				select 1 
				from ETraspasos
				where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
			</cfquery>
			
			<cfif isdefined("ExisteTransferencia") and ExisteTransferencia.RecordCount EQ 0>
				<cf_errorCode	code = "51135" msg = "El ID de la Transferencia entre cuentas indicado no existe. El proceso ha sido cancelado">				
			</cfif>
			
			<!--- 2. Existe el detalle ? --->
			<cfquery name="ExisteDetTransferencia" datasource="#Arguments.Conexion#">
				select count(1) as Cantidad 
				from DTraspasos
				where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
			</cfquery>
		
			<cfif isdefined("ExisteDetTransferencia") and ExisteDetTransferencia.Cantidad EQ 0>
				<cf_errorCode	code = "51136" msg = "En la relación de Transferencias indicada no hay líneas de detalle. El proceso ha sido cancelado">				
			</cfif>

		
			<!--- 3. Carga del periodo --->
			<cfquery name="rsPeriodo" datasource="#Arguments.Conexion#">
				select <cf_dbfunction name="to_number" args="Pvalor"> as Periodo
				from Parametros
				Where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and Mcodigo = 'GN'
					and Pcodigo = 50		
			</cfquery>			
			
			<cfif isdefined("rsPeriodo")>
				<cfset Periodo =  rsPeriodo.Periodo>			
			</cfif>
			
			<!--- 4.Carga del mes --->
			<cfquery name="rsMes" datasource="#Arguments.Conexion#">
				select <cf_dbfunction name="to_number" args="Pvalor"> as Mes
				from Parametros
				Where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and Mcodigo = 'GN'
					and Pcodigo = 60		
			</cfquery>			
			
			<cfif isdefined("rsMes")>
				<cfset Mes =  rsMes.Mes>			
			</cfif>
			
			<cfif Mes EQ 0 or Periodo EQ 0>
				<cf_errorCode	code = "50406" msg = "No se ha definido el parámetro de Período o Mes para los sistemas Auxiliares. El proceso ha sido cancelado">
			</cfif>

			<!---- 5.Carga de Cuenta Puente ---->
			<cfquery name="rsCuentaPuente" datasource="#Arguments.Conexion#">
				select <cf_dbfunction name="to_number" args="Pvalor"> as CuentaPuente
				from Parametros
				Where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and Pcodigo = 200		
			</cfquery>							

			<cfif isdefined("rsCuentaPuente")>
				<cfset CuentaPuente =  rsCuentaPuente.CuentaPuente>			
			</cfif>
			
			<!--- Si hay una cuenta puente ---->
			<cfif rsCuentaPuente.RecordCount EQ 0>
				<cfquery name="ExisteCuentaCont" datasource="#Arguments.Conexion#">
					select 1
					from CContables 
					where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CuentaPuente#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				</cfquery>
				<cfif ExisteCuentaCont.RecordCount EQ 0><!---- Si hay una cuenta contable ----->
					<cf_errorCode	code = "51137" msg = "La cuenta contable seleccionada para Balance de Monedas no existe o no acepta movimientos. El proceso ha sido cancelado">
				</cfif>
			</cfif>
			
			<!--- 6. Existe cuenta contable para la comisión --->
			<cfquery name="ExisteCCComision" datasource="#Arguments.Conexion#">
				select count(1) as Cantidad
				from DTraspasos a
						inner join CuentasBancos b
							on a.CBidori = b.CBid
				where a.ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
                    and b.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">	
					and b.Ccuentacom is null			
			</cfquery>				
			<cfif isdefined("ExisteCCComision") and ExisteCCComision.Cantidad GTE 1>
				<cf_errorCode	code = "51138" msg = "No se ha definido la cuenta contable para la comisión en el catálogo de Cuentas Bancarias. El proceso ha sido cancelado">
			</cfif>
			
			<!---  7. Acepta la cuenta movimientos ---->
			<cfquery name="CuentaAceptaMovim" datasource="#Arguments.Conexion#">
				select count(1) as Cantidad
				from DTraspasos a
					inner join CuentasBancos b
						inner join CContables c
						on b.Ccuentacom = c.Ccuenta
					on a.CBidori = b.CBid
				where a.ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
                  and b.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
				  and a.DTmontocomori > 0.00
				  and c.Cmovimiento = 'N'
				  and b.Ccuentacom is not null	
			</cfquery>
			
			<cfif isdefined("CuentaAceptaMovim") and CuentaAceptaMovim.Cantidad GTE 1>
				<cf_errorCode	code = "51139" msg = "La Cuenta Contable de la comisión no acepta movimientos. El proceso ha sido cancelado.">
			</cfif>
							
			<!--- 8. Validar que los montos no sean cero ---->
			<cfset LvarMensaje = ''>
			<cfquery name="MontosEnCero" datasource="#Arguments.Conexion#">
				select DTdocumento, DTmontoori, DTmontodest, DTmontolocal
				from DTraspasos
				where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
				  and (DTmontoori = 0.00 or DTmontodest = 0.00)
			</cfquery>
					
			<cfif isdefined("MontosEnCero") and MontosEnCero.Recordcount GT 0>
				<cfset LvarMensaje = "Montos incorrectos en Transferencia. Proceso Cancelado."> 
				<cfloop query="MontosEnCero">
					<cfoutput>
						<cfset LvarMensaje = LvarMensaje & "<br>" & "Doc: #MontosEnCero.DTdocumento#, #NumberFormat(MontosEnCero.DTmontoori, ',.00')#  #NumberFormat(MontosEnCero.DTmontodest, ',.00')# #NumberFormat(MontosEnCero.DTmontolocal, ',.00')#">
					</cfoutput>
				</cfloop>
				<cfthrow message="#LvarMensaje#">
			</cfif>

		<!--- Fin de Validaciones --->

		<!--- Moneda Local --->
		<cfquery name="rsMonedalocal" datasource="#Arguments.Conexion#">
			select Mcodigo
			from Empresas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>
		
		<cfif isdefined("rsMonedalocal")>
			<cfset LvarMonedalocal =  rsMonedalocal.Mcodigo>			
		</cfif>
		
		<!---  Creación de la tabla INTARC ----->
		<cfinvoke component="CG_GeneraAsiento" returnvariable="Intarc" method="CreaIntarc" ></cfinvoke>	

		<!---- Carga de descripcion y Fecha del Documento ---->
		<cfquery name="rsDescripcion" datasource="#Arguments.Conexion#">
			select a.ETdescripcion, a.ETfecha, a.Edocbase
			from ETraspasos a
			where a.ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">	
		</cfquery>
						
		<cfset descripcion = 'Bancos: Transferencia ' >
		<cfset Fecha = Now()>
		
		<cfif isdefined("rsDescripcion")>
			<cfset descripcion = descripcion & rsDescripcion.ETdescripcion>
			<cfset Fecha = rsDescripcion.ETfecha>
		</cfif>

 		<cfif Arguments.trans EQ 'Y'>
			<cftransaction>
				<cfset varRet = PosteoTransferenciasPrivada(
								Arguments.Ecodigo,
								Arguments.ETid,
								rsDescripcion.Edocbase,
								Arguments.usuario,
								Arguments.LoginUsuario,
								Arguments.debug,
								Arguments.Conexion)>
			</cftransaction>
		<cfelse>
				<cfset varRet = PosteoTransferenciasPrivada(
								Arguments.Ecodigo,
								Arguments.ETid,
								rsDescripcion.Edocbase,
								Arguments.usuario,
								Arguments.LoginUsuario,
								Arguments.debug,
								Arguments.Conexion)>
		</cfif>		
				
		<cfreturn varRet>
	</cffunction>
	
	<cffunction name="PosteoTransferenciasPrivada" access="private" returntype="string" output="false">
		<cfargument name='Ecodigo'		type='numeric' 	required='false' default="#session.Ecodigo#">	 	<!--- Codigo empresa ---->
		<cfargument name='ETid' 		type='numeric' 	required='true'>									<!--- Codigo de la transferencia ---->
		<cfargument name='Edocbase'		type='string' 	required='true'>	 								<!--- Documento --->
		<cfargument name='usuario' 		type='numeric' 	required='false'  default="#session.Usucodigo#">	<!--- Codigo del usuario ---->
		<cfargument name='LoginUsuario' type='string' 	required='false'  default="#session.Usulogin#">		<!--- Login del usuario ---->
		<cfargument name='debug' 		type='string' 	required='false' default="N">	 					<!--- Ejecutra el debug (muestra los sqls) S= si  N= no---->
		<cfargument name='Conexion' 	type='string' 	required='false'>

		<!--- Actualizar los montos ( redondeo a dos decimales ) --->
		<cfquery datasource="#Arguments.Conexion#">
			update DTraspasos
				set 
					DTmontoori = round(DTmontoori, 2), 
					DTmontodest = round(DTmontodest, 2),
					DTmontolocal = 
						case 
							when 
								(( 
									select bori.Mcodigo 
									from CuentasBancos bori
									where bori.CBid = DTraspasos.CBidori
                                    	and bori.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
								)) = #LvarMonedalocal# 
							then round(DTmontoori, 2)
							when 
								(( 
									select bdest.Mcodigo 
									from CuentasBancos bdest
									where bdest.CBid = DTraspasos.CBiddest
                                    	and bdest.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
								)) = #LvarMonedalocal# 
							then round(DTmontodest, 2)
							else round(DTmontolocal, 2)
						end,
					DTmontocomori = round(DTmontocomori, 2),
					DTmontocomloc = 
						case 
							when 
								(( 
									select bori.Mcodigo 
									from CuentasBancos bori
									where bori.CBid = DTraspasos.CBidori
                                    	and bori.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
								)) = #LvarMonedalocal# 
							then round(DTmontocomori, 2)
							else round(DTmontocomloc, 2)
						end
			where ETid = #Arguments.ETid#
		</cfquery>

		<!--- Procesar los documentos --->
		<cfquery name="rsMovimientos" datasource="#Arguments.Conexion#">
			select 
				d.DTid,				d.ETid,				d.CBidori,
				d.CBiddest,			d.BTidori,			d.BTiddest,
				d.DTmontoori,		d.DTmontodest,		d.DTmontolocal,
				coalesce(d.DTmontocomori, 0.00) as DTmontocomori,
				coalesce(d.DTmontocomloc, 0.00) as DTmontocomloc,
				d.DTdocumento,
				d.DTreferencia,		d.DTtipocambio,		d.DTtipocambiof,
				e.ETfecha,
				bo.CBcodigo as CBcodigoori,
				bd.CBcodigo as CBcodigodest,
                d.DTdocumentodest, d.DTreferenciadest
			from DTraspasos d
				inner join CuentasBancos bo
				on bo.CBid = d.CBidori
				
				inner join CuentasBancos bd
				on bd.CBid = d.CBiddest
				
				inner join ETraspasos e
				on e.ETid = d.ETid
			where d.ETid = #Arguments.ETid#
            	and bd.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
                and bo.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		</cfquery>

		<cfset LvarMensajeError = "">	
		<cfset LvarError = false>
		<cfset LvarErrorGeneral = false>
		<cfloop query="rsMovimientos">

			<cfset LvarError1 = validamovimiento (rsMovimientos.CBidori, rsMovimientos.BTidori, rsMovimientos.DTdocumento, Arguments.Conexion)>
			<cfif LvarError1>
				<cfset LvarMensajeError = LvarMensajeError & "<br> Documento:#rsMovimientos.DTdocumento# duplicado. Cuenta #rsMovimientos.CBcodigoori#">
				<cfset LvarErrorGeneral = true>
			</cfif>

			<cfset LvarError2 = validamovimiento (rsMovimientos.CBiddest, rsMovimientos.BTiddest, rsMovimientos.DTdocumentodest, Arguments.Conexion)>
			<cfif LvarError2>
				<cfset LvarMensajeError = LvarMensajeError & "<br> Documento:#rsMovimientos.DTdocumentodest# duplicado. Cuenta #rsMovimientos.CBcodigodest#">
				<cfset LvarErrorGeneral = true>
			</cfif>

			<cfif not LvarError1>
            	<!---
					Modificado: 30/06/2012
					Alejandro Bolaños APH-Mexico ABG
					
					CONTROL DE EVENTOS Cuenta Origen
				--->	
				<!--- Obtiene la Transaccion --->
                <cfquery datasource="#Arguments.Conexion#" name="rsTBancaria">
                	select BTcodigo as Transaccion
                    from BTransacciones 
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                    and BTid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMovimientos.BTidori#">
                </cfquery>
                
				<!--- Se valida el control de eventos para la transaccion de Tesoreria --->
				<cfinvoke component="sif.Componentes.CG_ControlEvento" 
					method="ValidaEvento" 
					Origen="MBTR"
					Transaccion="#rsTBancaria.Transaccion#"
					Complemento="#rsMovimientos.CBcodigoori#"
					Conexion="#Arguments.Conexion#"
					Ecodigo="#Arguments.Ecodigo#"
					returnvariable="varValidaEvento"
				/> 	
				<cfset varNumeroEvento = "">
				<!--- Si esta activo el control de Eventos se procede a generar el Numero de Evento--->
				<cfif varValidaEvento GT 0>
					<cfinvoke component="sif.Componentes.CG_ControlEvento" 
							method		= "CG_GeneraEvento"  
							Origen="MBTR"
                            Transaccion="#rsTBancaria.Transaccion#"
                            Complemento="#rsMovimientos.CBcodigoori#"
							Documento	= "#Arguments.Edocbase#"
							Conexion	= "#Arguments.Conexion#"
							Ecodigo		= "#Arguments.Ecodigo#"
							returnvariable	= "arNumeroEvento"
						/>
						<cfif arNumeroEvento[3] EQ "">
							<cfthrow message="ERROR CONTROL EVENTO: No se obtuvo un control de evento valido para la operación">
						</cfif>
						<cfset varNumeroEvento = arNumeroEvento[3]>
						<cfset varIDEvento = arNumeroEvento[4]>
				</cfif>					
                
				<cfset LvarError = insertamovimiento (
						rsMovimientos.CBidori,
						rsMovimientos.BTidori,
						rsMovimientos.DTmontoori,
						rsMovimientos.DTmontolocal,
						rsMovimientos.DTmontocomori,
						rsMovimientos.DTmontocomloc,
						rsMovimientos.DTdocumento,
						rsMovimientos.DTreferencia,
						rsMovimientos.DTtipocambio,
						rsMovimientos.DTtipocambiof,
						LvarUsuario,
						rsMovimientos.ETfecha,
						Arguments.Conexion,
						varNumeroEvento
						)>
				<cfif LvarError>
					<cfset LvarMensajeError = LvarMensajeError & "<br> Error en Documento #rsMovimientos.DTdocumento# Cuenta #rsMovimientos.CBcodigoori#">
					<cfset LvarErrorGeneral = true>
				</cfif>
                <!--- Se agrega el Numero de Evento a DTraspaso para el caso de Multimoneda--->
				<cfquery datasource="#Arguments.Conexion#">
                	update DTraspasos set NumeroEvento = '#varNumeroEvento#'
                    where ETid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMovimientos.ETid#">
                    and DTid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMovimientos.DTid#">
                </cfquery>
			</cfif>

			<cfif not LvarError2>
	            <!---
					Modificado: 30/06/2012
					Alejandro Bolaños APH-Mexico ABG
					
					CONTROL DE EVENTOS Cuenta Origen
				--->	
				<!--- Obtiene la Transaccion --->
                <cfquery datasource="#Arguments.Conexion#" name="rsTBancaria">
                	select BTcodigo as Transaccion
                    from BTransacciones 
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                    and BTid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMovimientos.BTiddest#">
                </cfquery>
                
				<!--- Se valida el control de eventos para la transaccion de Tesoreria --->
				<cfinvoke component="sif.Componentes.CG_ControlEvento" 
					method="ValidaEvento" 
					Origen="MBTR"
					Transaccion="#rsTBancaria.Transaccion#"
					Complemento="#rsMovimientos.CBcodigodest#"
					Conexion="#Arguments.Conexion#"
					Ecodigo="#Arguments.Ecodigo#"
					returnvariable="varValidaEvento"
				/> 	
				<cfset varNumeroEvento = "">
				<!--- Si esta activo el control de Eventos se procede a generar el Numero de Evento--->
				<cfif varValidaEvento GT 0>
					<cfinvoke component="sif.Componentes.CG_ControlEvento" 
							method		= "CG_GeneraEvento"  
							Origen="MBTR"
                            Transaccion="#rsTBancaria.Transaccion#"
                            Complemento="#rsMovimientos.CBcodigodest#"
							Documento	= "#Arguments.Edocbase#"
							Conexion	= "#Arguments.Conexion#"
							Ecodigo		= "#Arguments.Ecodigo#"
							returnvariable	= "arNumeroEvento"
						/>
						<cfif arNumeroEvento[3] EQ "">
							<cfthrow message="ERROR CONTROL EVENTO: No se obtuvo un control de evento valido para la operación">
						</cfif>
						<cfset varNumeroEvento = arNumeroEvento[3]>
						<cfset varIDEvento = arNumeroEvento[4]>
				</cfif>					
				<cfset LvarError = insertamovimiento (
						rsMovimientos.CBiddest,
						rsMovimientos.BTiddest,
						rsMovimientos.DTmontodest,
						rsMovimientos.DTmontolocal,
						0.00,
						0.00,
						rsMovimientos.DTdocumentodest,
						rsMovimientos.DTreferenciadest,
						rsMovimientos.DTtipocambio,
						rsMovimientos.DTtipocambiof,
						LvarUsuario,
						rsMovimientos.ETfecha,
						Arguments.Conexion,
						varNumeroEvento
						)>
				<cfif LvarError>
					<cfset LvarMensajeError = LvarMensajeError & "<br> Error en Documento #rsMovimientos.DTdocumentodest# Cuenta #rsMovimientos.CBcodigodest#">
					<cfset LvarErrorGeneral = true>
				</cfif>
                <!--- Se agrega el Numero de Evento a DTraspaso para el caso de Multimoneda--->
				<cfquery datasource="#Arguments.Conexion#">
                	update DTraspasos set NumeroEvento = '#varNumeroEvento#'
                    where ETid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMovimientos.ETid#">
                    and DTid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMovimientos.DTid#">
                </cfquery>
			</cfif>
		</cfloop>

		<cfif LvarErrorGeneral>
			<cftransaction action="rollback" />
			<cf_errorCode	code = "51140"
							msg  = "Se Presentaron Errores al aplicar la Transferencia: @errorDat_1@"
							errorDat_1="#LvarMensajeError#"
			>
		</cfif>
		
		<cfif Arguments.debug EQ 'S'>
			<cfquery name="rsDebug" datasource="#Arguments.Conexion#">
				select 	a.MLid, a.Ecodigo, a.Bid, a.BTid, a.CBid, a.Mcodigo, a.MLfecha, a.MLdescripcion,
						a.MLdocumento, a.MLreferencia, a.MLconciliado, a.MLtipocambio, a.MLmonto,
						a.MLmontoloc, a.MLperiodo, a.MLmes, a.MLtipomov, a.MLusuario, a.IDcontable, 
						a.CDLgrupo, a.MLfechamov
				from	MLibros a
							inner join ETraspasos b
								on a.Ecodigo = b.Ecodigo
								and a.MLfecha = b.ETfecha									
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">	
			</cfquery>
			<cfdump var="#rsDebug#">					
		</cfif>

		<cfset InsertaBalanceMultimoneda(arguments.conexion)>			

		<!--- Ejecutar el Genera asiento --->
		<cfset edocbase = Arguments.Edocbase>

		<cfquery name="rs_revisa_Intarc" datasource="#arguments.conexion#">
			select 
				count(1) as Cantidad, 
				sum(INTMON * case when INTTIP = 'D' then 1.00 else 0.00 end ) as Debitos,
				sum(INTMON * case when INTTIP = 'C' then 1.00 else 0.00 end ) as Creditos
			from #Intarc# i
				inner join CContables c
				on c.Ccuenta = i.Ccuenta
			where INTMON <> 0
			  and c.Cmovimiento = 'S'
			  and c.Cformato <> c.Cmayor
		</cfquery>			

		<cfif isdefined('rs_revisa_Intarc') and rs_revisa_Intarc.Cantidad LT 1>
			<cf_errorCode	code = "51141" msg = "Error al Generar el Asiento Contable. No se Generaron Cuentas para el Documento Contable">
		</cfif>

		<cfif rs_revisa_Intarc.Debitos NEQ rs_revisa_Intarc.Creditos>
			<cf_errorCode	code = "51142"
							msg  = "Error al Generar el Documento Contable. Los Debitos y los Creditos no corresponden (no son iguales). Debitos: @errorDat_1@ Creditos: @errorDat_2@"
							errorDat_1="#NumberFormat(rs_revisa_Intarc.Debitos, ',9.00')#"
							errorDat_2="#NumberFormat(rs_revisa_Intarc.Creditos, ',9.00')#"
			>
		</cfif>

		<cfinvoke component="CG_GeneraAsiento" method="GeneraAsiento" returnvariable="IDcontable">
			<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
			<cfinvokeargument name="Oorigen" value="MBTR"/>
			<cfinvokeargument name="Eperiodo" value="#Periodo#"/>
			<cfinvokeargument name="Emes" value="#Mes#"/>
			<cfinvokeargument name="Efecha" value="#Fecha#"/>
			<cfinvokeargument name="Edescripcion" value="#descripcion#"/>
			<cfinvokeargument name="Edocbase" value="#edocbase#"/>
			<cfinvokeargument name="Ereferencia" value="Transferencia"/>
		</cfinvoke>

		<cfif len(IDcontable) LT 1 or IDcontable lt 1>
			<cf_errorCode	code = "51143" msg = "Error al Generar el Asiento Contable. Por favor aplique desde el sistema de Bancos este movimiento">
		</cfif>

		<!--- Actualizar el Asiento Contable en los movimientos de Bancos --->
		<cfloop query="rsMovimientos">
			<cfset LvarError = ActualizaIDcontable (rsMovimientos.CBidori, rsMovimientos.BTidori, rsMovimientos.DTdocumento, Arguments.Conexion, IDcontable)>
			<cfset LvarError = ActualizaIDcontable (rsMovimientos.CBiddest, rsMovimientos.BTiddest, rsMovimientos.DTdocumentodest, Arguments.Conexion, IDcontable)>
		</cfloop>

		<!---- 6. Borrado de estructuras ----->
		<cftry>
			<cfquery name="deleteDTraspasos" datasource="#arguments.conexion#">
				delete from DTraspasos
				where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">						
			</cfquery>			

			<cfcatch type="any">
				<cf_errorCode	code = "51144" msg = "No se pudo eliminar el Detalle de la Transferencia entre Cuentas. El proceso ha sido cancelado (Tabla: DTraspasos)">
			</cfcatch>
		</cftry>		
			
		<cftry>
			<cfquery name="deleteETraspasos" datasource="#arguments.conexion#">
				delete from ETraspasos
				where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">						
			</cfquery>			
			<cfcatch type="any">
				<cf_errorCode	code = "51145" msg = "No se pudo eliminar el Encabezado de la Transferencia entre Cuentas. El proceso ha sido cancelado (Tabla: EMovimientos)">
			</cfcatch>
		</cftry>	
			
		<cfif arguments.debug EQ 'S'>
			<cftransaction action="rollback"/>									
			<cf_abort errorInterfaz="">
		<cfelse>
			<cftransaction action="commit"/>									
		</cfif>
			
		<cfquery datasource="#arguments.conexion#">
			delete from #Intarc#					
		</cfquery>		
			
		<cfreturn 1>
	</cffunction>
	
	<cffunction name="validamovimiento" output="false" returntype="boolean" access="private">
		<cfargument name="cbid" type="numeric" required="yes">
		<cfargument name="Btid" type="numeric" required="yes">
		<cfargument name="dtdocumento" type="string" required="yes">
		<cfargument name="conexion" type="string" required="yes">
	
		<cfquery name="rsValidaMovimiento" datasource="#arguments.conexion#">
			select count(1) as Cantidad
			from MLibros
			where CBid = #Arguments.cbid#
			  and BTid = #Arguments.btid#
			  and MLdocumento = '#Arguments.dtdocumento#'
		</cfquery>

		<cfif rsValidaMovimiento.recordcount GT 0 and rsValidaMovimiento.Cantidad GT 0>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	<cffunction name="insertamovimiento" access="private" output="false" returntype="boolean">
		<cfargument name="CBid" required="yes" type="numeric">
		<cfargument name="BTid" required="yes" type="numeric">
		<cfargument name="DTmonto" required="yes" type="numeric">
		<cfargument name="DTmontolocal" required="yes" type="numeric">
		<cfargument name="DTmontocomision" required="yes" type="numeric">
		<cfargument name="DTmontocomloc" required="yes" type="numeric">
		<cfargument name="DTdocumento" required="yes" type="string">
		<cfargument name="DTreferencia" required="yes" type="string">
		<cfargument name="DTtipocambio" required="yes" type="numeric">
		<cfargument name="DTtipocambiof" required="yes" type="numeric">
		<cfargument name="BMUsucodigo" required="yes" type="numeric">
		<cfargument name="Fecha" required="yes" type="date">
		<cfargument name="conexion" type="string" required="yes">
        <cfargument name="NumeroEvento" type="string"   required="no" default="">


		<cfset LvarMonto = Arguments.DTmonto + Arguments.DTmontocomision>
		<cfset LvarMontoLoc = Arguments.DTmontolocal + Arguments.DTmontocomloc>

		<cfquery name="rsBTtipo" datasource="#Arguments.Conexion#">
			select bt.BTtipo
			from BTransacciones bt 
			where bt.BTid = #Arguments.BTid#
		</cfquery>

		<cfset LvarBTtipo = rsBTtipo.BTtipo>
			
		<cftry>
			<cfquery datasource="#Arguments.Conexion#">
				insert into MLibros (
					Ecodigo, 		Bid, 		BTid, 				CBid, 
					Mcodigo, 		MLfecha,
					MLdescripcion,	
					MLdocumento, 
					MLreferencia, 	
					MLconciliado,
					MLtipocambio, 	
					MLmonto, 
					MLmontoloc, 	MLperiodo, 	MLmes, 				MLtipomov, 
					MLusuario, 		IDcontable,	BMUsucodigo)

				select 
					b.Ecodigo, 		b.Bid, 		#Arguments.BTid#, 	#Arguments.CBid#,
					b.Mcodigo, 		<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Arguments.Fecha#">, 
					<cf_jdbcquery_param cfsqltype="cf_sql_char" value="#descripcion#" len="50">, 
					'#Arguments.DTdocumento#', 
					'#Arguments.DTreferencia#', 
					'N', 
					#arguments.DTtipocambio#, 
					#LvarMonto#, 
					<!---<cfif LvarMontoLoc eq LvarMonto>1.00<cfelse>#LvarMontoLoc / LvarMonto#</cfif>,---> 
					<cfif LvarMontoLoc eq LvarMonto>#LvarMontoLoc#<cfelse>#LvarMontoLoc / LvarMonto#</cfif>,
					#Periodo#,
					#Mes#,
					'#LvarBTtipo#', 
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#LvarLoginUsuario#">, 
					<cf_jdbcquery_param cfsqltype="cf_sql_decimal" value="null">,
					#LvarUsuario#
				from CuentasBancos b
				where b.CBid = #Arguments.CBid#
                	and b.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			</cfquery>

			<cfquery datasource="#Arguments.Conexion#">
				insert INTO #Intarc# ( 
					INTORI, INTREL, INTDOC, INTREF, 
					INTMON, 
					INTTIP, INTDES, 
					INTFEC, 
					INTCAM, Periodo, Mes, Ccuenta, 
					Mcodigo, Ocodigo, INTMOE,
                    NumeroEvento)
				select 
					'MBTR',	1,	
					'#mid(Arguments.DTdocumento,1,20)#', 
					'#mid(Arguments.DTreferencia,1,25)#', 
					#NumberFormat(LvarMontoLoc, "9.00")#,	
					'#LvarBTtipo#', 'Transferencia Doc: #Arguments.DTdocumento#',
					'#Dateformat(Fecha, "yyyymmdd")#',
					<cfif LvarMontoLoc eq LvarMonto>1.00<cfelse>#LvarMontoLoc / LvarMonto#</cfif>,
					<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Periodo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Mes#">,
					c.Ccuenta,
					c.Mcodigo,
					c.Ocodigo,
					#NumberFormat(LvarMonto, "9.00")#,
                    '#Arguments.NumeroEvento#'
				from CuentasBancos c
				where c.CBid =	#Arguments.CBid#
                	and c.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			</cfquery>

			<cfif Arguments.DTmontocomision NEQ 0>
				<cfquery datasource="#Arguments.Conexion#">
					insert INTO #Intarc# ( 
						INTORI, INTREL, INTDOC, INTREF, 
						INTMON, 
						INTTIP, INTDES, 
						INTFEC, 
						INTCAM, Periodo, Mes, Ccuenta, 
						Mcodigo, Ocodigo, INTMOE,
                        NumeroEvento)
					select 
						'MBTR',	1,	
						'#mid(Arguments.DTdocumento,1,20)#', 
						'#mid(Arguments.DTreferencia,1,25)#', 
						#NumberFormat(Arguments.DTmontocomloc, "9.00")#,	
						'D', 'Gasto por comision Doc: #Arguments.DTdocumento#',
						'#Dateformat(Fecha, "yyyymmdd")#',
						<cfif Arguments.DTmontocomision eq Arguments.DTmontocomloc>1.00<cfelse>#Arguments.DTmontocomloc / Arguments.DTmontocomision#</cfif>,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
						c.Ccuentacom,
						c.Mcodigo,
						c.Ocodigo,
						#NumberFormat(Arguments.DTmontocomision, "9.00")#,
                        '#Arguments.NumeroEvento#'
					from CuentasBancos c
					where c.CBid =	#Arguments.CBid#
                    	and c.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
				</cfquery>
			</cfif>
			<cfcatch type="any">
				<cfreturn true>
			</cfcatch>
		</cftry>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="ActualizaIDcontable" output="false" returntype="boolean" access="private">
		<cfargument name="cbid" type="numeric" required="yes">
		<cfargument name="Btid" type="numeric" required="yes">
		<cfargument name="dtdocumento" type="string" required="yes">
		<cfargument name="conexion" type="string" required="yes">
		<cfargument name="IDcontable" type="numeric" required="yes">
	
		<cfquery datasource="#arguments.conexion#">
			update MLibros set IDcontable = #IDcontable#
			where CBid = #Arguments.cbid#
			  and BTid = #Arguments.btid#
			  and MLdocumento = '#Arguments.dtdocumento#'
		</cfquery>

		<cfreturn true>

	</cffunction>

	<cffunction name="InsertaBalanceMultimoneda" access="private">
		<cfargument name="conexion" type="string" required="yes">
		<!---- Débitos a las cuentas de balance por moneda ----->
		<cfset fechaHoy=LSDateFormat(#Now()#,'yyyymmdd')>
		<cf_dbfunction name="string_part" args="'#fechaHoy#',1,8" returnvariable="LVarFechaHoy" datasource="#Arguments.Conexion#">
		<cf_dbfunction name="string_part" args="b.DTdocumento,1,20" returnvariable="LVarDTdocumento" datasource="#Arguments.Conexion#">
		<cf_dbfunction name="string_part" args="b.DTreferencia,1,25" returnvariable="LVarDTreferencia" datasource="#Arguments.Conexion#">
		<cfquery datasource="#Arguments.Conexion#">
			insert INTO #Intarc# (INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento)
			select 
				'MBTR',
				1,
				#LVarDTdocumento#,
				#LVarDTreferencia#, 
				b.DTmontolocal,
				'D', 
				<cf_dbfunction name="concat" args="'Balance x Moneda Documento:',b.DTdocumento">,
				#PreserveSingleQuotes(LVarFechaHoy)#,
				case when o.Mcodigo != <cfqueryparam cfsqltype="cf_sql_money" value="#Monloc#">
					then round(b.DTmontolocal/b.DTmontoori,4)
					else 1.00 end,
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Periodo#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Mes#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#CuentaPuente#">,
				o.Mcodigo,
				o.Ocodigo,
				b.DTmontoori,
                b.NumeroEvento
			from DTraspasos b
					inner join CuentasBancos o
						on b.CBidori = o.CBid
					inner join CuentasBancos d
						on d.CBid = b.CBiddest
			where b.ETid =	#LvarETid#
            and d.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
            and o.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			and o.Mcodigo != d.Mcodigo
		</cfquery>
			
		<!-----  Créditos a las cuentas de balance por moneda ------>
		<cf_dbfunction name="string_part" args="b.DTreferencia,1,8" returnvariable="LVarDTreferencia" datasource="#Arguments.Conexion#">
		<cfquery datasource="#Arguments.Conexion#">
			insert INTO #Intarc# (INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento)
			select 
				'MBTR',
				1,
				#LVarDTdocumento#,
				#LVarDTreferencia#, 
				b.DTmontolocal,
				'C', 
				<cf_dbfunction name="concat" args="'Balance x Moneda Documento:',b.DTdocumento">,
				#PreserveSingleQuotes(LVarFechaHoy)#,
				case when d.Mcodigo != <cfqueryparam cfsqltype="cf_sql_money" value="#Monloc#">
					then round(b.DTmontolocal/b.DTmontodest,4)
					else 1.00 end,
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Periodo#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Mes#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#CuentaPuente#">,
				d.Mcodigo,
				d.Ocodigo,
				b.DTmontodest,
                b.NumeroEvento
			from DTraspasos b
					inner join CuentasBancos o
						on b.CBidori = o.CBid
					inner join CuentasBancos d
						on d.CBid = b.CBiddest
			where b.ETid =	#LvarETid#
            and o.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			and d.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
            and o.Mcodigo != d.Mcodigo
		</cfquery>
	</cffunction>
	
</cfcomponent>



