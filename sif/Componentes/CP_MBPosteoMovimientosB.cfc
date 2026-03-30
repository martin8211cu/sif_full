
<cfcomponent>
<cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">
	
	<cffunction name="PosteoMovimientos" access="public" returntype="string" output="false">
		<!---- Definición de Parámetros --->
		<cfargument name='Ecodigo'			type='numeric' 	required='true'>	 				<!--- Codigo empresa ---->
		<cfargument name='EMid' 			type='numeric' 	required='true'>	 				<!--- Codigo del movimiento---->
		<cfargument name='usuario' 			type='numeric' 	required='true'>	 				<!--- Codigo del usuario ---->
		<cfargument name='debug' 			type='string' 	required='false' 	default="N">	<!--- Ejecuta el debug S= si  N= no---->
		<cfargument name='Conexion' 		type='string' 	required='false'>
		<cfargument name='transaccionActiva'type='boolean' 	required='false' 	default="false">
        <cfargument name='IDGarantia' 		type='numeric' 	required='false'	default="-1">
        <cfargument name='ubicacion' 		type='numeric'  required='true'		default="0">
        <cfargument name='MovRetroactivo' 	type='boolean'  required='false'	default="false"><!--- Movimientos desde la conciliacion bancaria---->
        <cfargument name='ECid' 			type='numeric'  required='false' 	default="-1">	<!--- id de estado de cuenta ---->
        <cfargument name='ConciliaML' type='boolean' 	required='false' default="false">
		<!---  Creación de la tabla INTARC ----->
		<cfinvoke component="CG_GeneraAsiento" returnvariable="Intarc" method="CreaIntarc" ></cfinvoke>	


		<cfif (not isdefined("arguments.Conexion"))>
			<cfset arguments.Conexion = session.dsn>
		</cfif>
		
		<cfif Arguments.transaccionActiva>
			<cfinvoke 
					method="PosteoMovimientosPrivate"
					Ecodigo="#Arguments.Ecodigo#"
					EMid="#Arguments.EMid#"	
                    IDGarantia="#Arguments.IDGarantia#"			
					usuario="#Arguments.usuario#"
					Conexion="#Arguments.Conexion#"		
					debug="#Arguments.debug#"
					Intarc="#Intarc#"
                    ubicacion="#Arguments.ubicacion#"
                    MovRetroactivo="#Arguments.MovRetroactivo#"
                    ECid="#Arguments.ECid#"
					ConciliaML="#Arguments.ConciliaML#"
				/>
		<cfelse>
			<cftransaction>
				<cfinvoke
					method="PosteoMovimientosPrivate"
					Ecodigo="#Arguments.Ecodigo#"
					EMid="#Arguments.EMid#"			
                    IDGarantia="#Arguments.IDGarantia#"	
					usuario="#Arguments.usuario#"
					Conexion="#Arguments.Conexion#"		
					debug="#Arguments.debug#"
					Intarc="#Intarc#"								
                    ubicacion="#Arguments.ubicacion#"	
                    MovRetroactivo="#Arguments.MovRetroactivo#"
                    ECid="#Arguments.ECid#"
					ConciliaML="#Arguments.ConciliaML#"
				/>
			</cftransaction>
		</cfif>
	
	</cffunction>
	
	<cffunction name="PosteoMovimientosPrivate" access="private" returntype="string" output="false">
		<!---- Definición de Parámetros --->
		<cfargument name='Ecodigo'	  		type='numeric' 	required='true'>	 <!--- Codigo empresa ---->
		<cfargument name='EMid' 	  		type='numeric' 	required='true'>	 <!--- Codigo del movimiento---->
		<cfargument name='usuario' 	  		type='numeric' 	required='true'>	 <!--- Codigo del usuario ---->
        <cfargument name='IDGarantia' 		type='numeric' 	required='false' 	default="-1">	 <!--- id de la garantia ---->
		<cfargument name='debug' 	  		type='string' 	required='false' 	default="N">	 <!--- Ejecutra el debug S= si  N= no---->
		<cfargument name='Conexion'   		type='string' 	required='false'>
		<cfargument name='Intarc' 	  		type='string' 	required='false'>
        <cfargument name='ubicacion' 		type='numeric'  required='true' 	default="0">
        <cfargument name='MovRetroactivo' 	type='boolean'  required='false'	default="false"><!--- Movimientos desde la conciliacion bancaria---->
        <cfargument name='ECid' 			type='numeric'  required='false' 	default="-1">	<!--- id de estado de cuenta ---->
		<cfargument name='ConciliaML' type='boolean' 	required='false' default="false">
		<!--- Definicion de variables ---->
		<cfset lin = 0>
		<cfset Periodo = 0>
		<cfset Mes = 0>
		<cfset Fecha = ''>
		<cfset descripcion =''>
		<cfset Monedacta =0>
		<cfset Monloc =0>
		<cfset EMdocumento =''>
		<cfset EMreferencia =''>
		<cfset error =0>
		<cfset MLid =0>
		<cfset TIPO = 0>
		<cfset MovRetroactivo= arguments.MovRetroactivo>
		<cfset Intarc = Arguments.Intarc>
		<!---- Existe el movimiento ya?  Si existe se sale del componente por medio del Abort ---->
		<cfquery name="ExisteMovimiento" datasource="#Arguments.Conexion#">
			select  coalesce(TpoSocio  ,0) as TpoSocio
			from EMovimientos
			where EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#">
		</cfquery>
        
		
		
		<cfif isdefined("ExisteMovimiento") and ExisteMovimiento.RecordCount EQ 0>
			<cf_errorCode	code = "51129" msg = "El ID del Movimiento indicado no existe! Verifique que el Movimiento exista!">				
		</cfif>
		<cfif isdefined("ExisteMovimiento") and ExisteMovimiento.RecordCount GT 0>
			<cfset TIPO = ExisteMovimiento.TpoSocio>
		</cfif>
				
		<cfif TIPO eq 0> <!--- Valida el detalle solo si el TpoSocio es cero o null (Bancos) ---> 
			<!---- Existe el detalle de movimiento ya?  Si existe se sale del componente por medio del Abort ---->
			<cfquery name="ExisteMovimiento2" datasource="#Arguments.Conexion#">
				select 1 
				from DMovimientos
				where EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#">
				and DMmonto <> 0.00
				  <!--- and (DMmonto <> 0.00 and CFid is not null) --->
			</cfquery>
			<cfif isdefined("ExisteMovimiento2") and ExisteMovimiento2.RecordCount EQ 0>
				<cf_errorCode	code = "51130" msg = "El Documento Indicado no tiene Información de Detalle o es incorrecta! Verifique los Datos!">
			</cfif>
		</cfif>

		<!--- Carga de Variables>	---->
		<cfset lin = 1>
		<cfset error = 0>
		<cfset Fecha = Now()>
        <cfset descripcion = 'Movimientos Bancarios'>
        <cfif isdefined("Arguments.ubicacion") and Arguments.ubicacion eq 1>
			<cfset descripcion = 'Movimientos de TCE: '>
        </cfif>
		
		<!--- Carga de moneda local --->
		<cfquery name="rsMonloc" datasource="#Arguments.Conexion#">
			select Mcodigo
			from Empresas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>
		
		<cfif isdefined("rsMonloc")>
			<cfset Montloc =  rsMonloc.Mcodigo>			
		</cfif>
		
		<!---- Carga del periodo --->
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
		
		<!---- Carga del mes --->
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
		
		<!---- Carga de la  Moneda de la cuenta --->
		<cfquery name="rsMonedacta" datasource="#Arguments.Conexion#">
			select b.Mcodigo, a.EMdocumento, a.EMreferencia, a.EMfecha
			from EMovimientos a
				inner join CuentasBancos b
					on a.CBid = b.CBid
			Where a.EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#">
            	and b.CBesTCE = <cfqueryparam value="#Arguments.ubicacion#" cfsqltype="cf_sql_numeric">
		</cfquery>			
		
		<cfif isdefined("rsMonedacta")>
			<cfset Monedacta =  rsMonedacta.Mcodigo>
			<cfset EMdocumento = rsMonedacta.EMdocumento>
			<cfset EMreferencia = rsMonedacta.EMreferencia>		
			<cfset Fecha = rsMonedacta.EMfecha>
		</cfif>
        
        <!---Cuando el movimiento es de un mes anterior al auxiliar y mayor al contable--->
		<cfif MovRetroactivo>
			<cfset Mes =  datepart("m",rsMonedacta.EMfecha)>
			<cfset Periodo = datepart("yyyy",rsMonedacta.EMfecha)>
        </cfif>


		<!---- 1. Validaciones ---->
			<cfif Mes EQ 0 or Periodo EQ 0>
				<cf_errorCode	code = "50406" msg = "No se ha definido el parámetro de Período o Mes para los sistemas Auxiliares. El proceso ha sido cancelado">
			</cfif>
						
		<!---- 2. Insertar en Movimientos Libros ----->		
		<!---- Verificar que si ya existe ya la combinacion de datos BTid,CBid,EMdocumento ---->
		<cfquery name="rsDestino" datasource="#Arguments.Conexion#">
			select 	a.BTid,
					a.CBid,
					a.EMdocumento 
			from EMovimientos a
				inner join CuentasBancos b
					on a.CBid = b.CBid
				inner join BTransacciones c
					on a.BTid = c.BTid
			where a.EMid = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#">
            	and b.CBesTCE = <cfqueryparam value="#Arguments.ubicacion#" cfsqltype="cf_sql_numeric">
		</cfquery>
			
		<!---- Si ya existe el movimiento re verifica que si existe en MLibros esa combinacion ----->
		<cfif rsDestino.recordCount GT 0>
			<cfquery name="rsInsertar" datasource="#Arguments.Conexion#">
				select 1
				from MLibros
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and MLdocumento=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDestino.EMdocumento#">
					and BTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDestino.BTid#">
					and CBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDestino.CBid#">
			</cfquery>		
	
			<!---- Si no existe ya esa combinacion de datos realizar el insert en MLibros ---->
			<cfif isdefined('rsInsertar') and rsInsertar.recordCount EQ 0>												
				<cftry>
                <cfif Arguments.IDGarantia neq -1  and len(trim(Arguments.IDGarantia)) neq 0>
		
						<cfquery name="rsGarantiaSN" datasource="#session.DSN#">
								select 
									c.SNnumero,
									c.SNnombre
								from COEGarantia b                             
									left join SNegocios c<!---Consultar si usar left en ves de inner--->
									on c.SNid = b.SNid                              
								where b.COEGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDGarantia#">
    					</cfquery>	
						<cfif rsGarantiaSN.recordcount gt 0>
                          <cfset Lvarsocio =  rsGarantiaSN.SNnombre>
                        <cfelse>
                          <cfset Lvarsocio =  ''>   
                        </cfif>
				<cfelse>
				   <cfset Lvarsocio =  ''>    		
     			</cfif>	
                
					<cfquery name="rsSelectDatosMovLibros" datasource="#Arguments.Conexion#">
						select 		b.Bid, 
									a.BTid,
									a.CBid, 
									b.Mcodigo, 
									a.EMfecha, 
									(a.EMdescripcion #_Cat# ': #Lvarsocio#') as EMdescripcion, 
									a.EMdocumento, 
									a.EMreferencia, 
									a.EMtipocambio, 
									a.EMtotal, 
									round(a.EMtotal*a.EMtipocambio,2) as MLMontoLoc, 
									c.BTtipo, 
									a.EMusuario,
									a.EMdescripcionOd,
									a.EMBancoidOD
							from EMovimientos a
								inner join CuentasBancos b
									on a.CBid = b.CBid
								inner join BTransacciones c
									on a.BTid = c.BTid
							where a.EMid = 	#Arguments.EMid#
                            	and b.CBesTCE = <cfqueryparam value="#Arguments.ubicacion#" cfsqltype="cf_sql_numeric">
					</cfquery>
					
					<cfquery name="rsInsertMovLibros" datasource="#Arguments.Conexion#">
						insert into MLibros (Ecodigo, Bid, BTid, CBid, Mcodigo, MLfecha, MLdescripcion, MLdocumento,
											MLreferencia, MLconciliado, MLtipocambio, MLmonto, MLmontoloc, MLperiodo,
											MLmes, MLtipomov, MLusuario, IDcontable, BMUsucodigo, Bid_Ordenante, Cta_Ordenante)
							values(#Arguments.Ecodigo#,
									#rsSelectDatosMovLibros.Bid#,
									#rsSelectDatosMovLibros.BTid#,
									#rsSelectDatosMovLibros.CBid#,
									#rsSelectDatosMovLibros.Mcodigo#,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsSelectDatosMovLibros.EMfecha#" null="#rsSelectDatosMovLibros.EMfecha eq ''#">,
									 <cf_jdbcquery_param 	value="#rsSelectDatosMovLibros.EMdescripcion#" 	len="50" 	cfsqltype="cf_sql_varchar">,
									'#rsSelectDatosMovLibros.EMdocumento#',
									'#rsSelectDatosMovLibros.EMreferencia#',
									'N',
									#rsSelectDatosMovLibros.EMtipocambio#,
									#rsSelectDatosMovLibros.EMtotal#,
									#rsSelectDatosMovLibros.MLMontoLoc#,
									#Periodo#,#Mes#,
									'#rsSelectDatosMovLibros.BTtipo#',
									'#rsSelectDatosMovLibros.EMusuario#',
									<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">,
									#Arguments.usuario#,
									<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsSelectDatosMovLibros.EMBancoidOD#" null="#len(rsSelectDatosMovLibros.EMBancoidOD) eq 0#">,
									'#rsSelectDatosMovLibros.EMdescripcionOd#'
							)
						<cf_dbidentity1 datasource="#Arguments.Conexion#">
					</cfquery>									
					<cf_dbidentity2 datasource="#Arguments.Conexion#" name="rsInsertMovLibros">	
					<!-----  Asignacion de la variable MLid ---->
                    <cfset MLid = rsInsertMovLibros.identity>	
					<!----- Error en el insert ----->
					<cfcatch type="any">
						<cf_errorCode	code = "51131"
										msg  = "No se pudo insertar el Movimiento en Libros. El proceso fue cancelado (Tabla: MLibros) #cfcatch.message#"
										errorDat_1="#cfcatch.sql#"
						>
					</cfcatch>									
				</cftry>
			<cfelse>
				<cf_errorCode	code = "51132"
								msg  = "No se pudo insertar el Movimiento en Libros porque ya existe un Movimiento con estos valores: MLdocumento=@errorDat_1@ / BTid=@errorDat_2@ /CBid= @errorDat_3@. El proceso fue cancelado (Tabla: MLibros)"
								errorDat_1="#rsDestino.EMdocumento#"
								errorDat_2="#rsDestino.BTid#"
								errorDat_3="#rsDestino.CBid#"
				>								
			</cfif>
		</cfif>

		<!--- ACTUALIZA MLID EN HEMovimientos, HISTORICA --->
		<cfif MLid GT 0>
			<cfquery name="rsUpdateHE" datasource="#Arguments.Conexion#">
				UPDATE HEMovimientos
				SET MLid = <cfqueryparam cfsqltype="numeric" value="#MLid#">
				WHERE Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				AND EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#">
			</cfquery>
		</cfif>
		
		<cfif Arguments.debug EQ 'S'>
			<cfquery name="rsDebug" datasource="#Arguments.Conexion#">
				select 	a.MLid, a.Ecodigo, a.Bid, a.BTid, a.CBid, a.Mcodigo, a.MLfecha, a.MLdescripcion,
						a.MLdocumento, a.MLreferencia, a.MLconciliado, a.MLtipocambio, a.MLmonto,
						a.MLmontoloc, a.MLperiodo, a.MLmes, a.MLtipomov, a.MLusuario, a.IDcontable, 
						a.CDLgrupo, a.MLfechamov, a.ts_rversion
				from	MLibros
				where MLid = <cfqueryparam cfsqltype="numeric" value="#MLid#">
			</cfquery>						
		</cfif>
		
        <!---
			Modificado: 30/06/2012
			Alejandro Bolaños APH-Mexico ABG
			
			CONTROL DE EVENTOS
		--->	
        
        <!--- Obtiene los datos del movimiento Bancario --->
        <cfquery datasource="#Arguments.Conexion#" name="rsMBancario">
        	select 'MBMV' as Origen, c.CBcodigo as Cuenta, b.BTcodigo as Transaccion, a.EMdocumento as Documento
            from EMovimientos a
            inner join BTransacciones b on a.Ecodigo = b.Ecodigo and a.BTid = b.BTid
            inner join CuentasBancos c on a.Ecodigo = c.Ecodigo and a.CBid = c.CBid
            where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
            and EMid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.EMid#">
        </cfquery>
        
        <!--- Se valida el control de eventos para la transaccion de Tesoreria --->
        <cfinvoke component="sif.Componentes.CG_ControlEvento" 
            method="ValidaEvento" 
            Origen="#rsMBancario.Origen#"
            Transaccion="#rsMBancario.Transaccion#"
            Complemento="#rsMBancario.Cuenta#"
            Conexion="#Arguments.Conexion#"
            Ecodigo="#Arguments.Ecodigo#"
            returnvariable="varValidaEvento"
        /> 	
        <cfset varNumeroEvento = "">
        <!--- Si esta activo el control de Eventos se procede a generar el Numero de Evento--->
        <cfif varValidaEvento GT 0>
        	<cfinvoke component="sif.Componentes.CG_ControlEvento" 
                    method		= "CG_GeneraEvento"  
                    Origen		="#rsMBancario.Origen#"
                    Transaccion	="#rsMBancario.Transaccion#"
                    Complemento	="#rsMBancario.Cuenta#"
                    Documento	= "#rsMBancario.Documento#"
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

		<!---- 3. Insert asiento contable ---->
		<cf_dbfunction name="string_part" args="d.DMdescripcion,1,80" returnvariable='LvarDMdescripcion' datasource="#Arguments.Conexion#">
		<cf_dbfunction name="string_part" args="a.EMdocumento,1,20" returnvariable='LvarEMdocumento' datasource="#Arguments.Conexion#">
		<cf_dbfunction name="string_part" args="a.EMreferencia,1,25" returnvariable='LvarEMreferencia' datasource="#Arguments.Conexion#">	
		<cf_dbfunction name="string_part" args="b.BTtipo,1,1" returnvariable='LvarBTtipo' datasource="#Arguments.Conexion#">
		<cf_dbfunction name="string_part" args="a.EMdescripcion,1,80" returnvariable='LvarEMdescripcion' datasource="#Arguments.Conexion#">
		<cf_dbfunction name="string_part" args="a.EMreferencia,1,25" returnvariable='LvarEMreferencia' datasource="#Arguments.Conexion#">				
		<cfquery name="rsInsertAsientoCont" datasource="#Arguments.Conexion#">
			insert INTO #Intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento,CFid)
				select 
					'MBMV',
					1,
					#LvarEMdocumento#,
					#LvarEMreferencia#, 
					round(a.EMtotal*EMtipocambio,2),								
					#LvarBTtipo#, 
					#LvarEMdescripcion#,
					'#LSDateFormat(Now(),'yyyymmdd')#',
					a.EMtipocambio,
					<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Periodo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Mes#">,
					c.Ccuenta,
					c.Mcodigo,
                    coalesce(a.Ocodigo,c.Ocodigo),
					a.EMtotal,
                    '#varNumeroEvento#',a.CFid
				from EMovimientos a
					inner join BTransacciones b
						on a.Ecodigo = b.Ecodigo
						and a.BTid = b.BTid
					inner join CuentasBancos c
						on a.CBid = c.CBid
				where a.EMid =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#">
                	and c.CBesTCE = <cfqueryparam value="#Arguments.ubicacion#" cfsqltype="cf_sql_numeric">
		</cfquery>      

		<!--- Bancos --->
		<cfif TIPO eq 0>          
                   
			<!---- 4. Cuentas contables afectadas en el detalle del movimiento ----->		
			<cfquery name="rsInsertAsientoCont" datasource="#Arguments.Conexion#">
				insert INTO #Intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta,CFcuenta, Mcodigo, Ocodigo, INTMOE, 
									   LIN_IDREF, PCGDid, NumeroEvento,CFid)
				select 
					'MBMV',
					1,
					#LvarEMdocumento#,
					#LvarEMreferencia#, 
					round(d.DMmonto*a.EMtipocambio,2),
					case when b.BTtipo = 'D' 
							then 'C' else 'D' end, 
					#LvarDMdescripcion#,
					'#LSDateFormat(now(),'yyyymmdd')#',
					a.EMtipocambio,
					<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Periodo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Mes#">,
					d.Ccuenta,
					d.CFcuenta,
					c.Mcodigo,
					coalesce(cf.Ocodigo,a.Ocodigo),
					d.DMmonto,
					d.DMlinea,
					d.PCGDid,
                    '#varNumeroEvento#',a.CFid
				from EMovimientos a
					inner join BTransacciones b
						on a.Ecodigo = b.Ecodigo
						and a.BTid = b.BTid
						
					inner join CuentasBancos c
						on a.CBid = c.CBid
						
					inner join DMovimientos d
						on a.EMid = d.EMid
					
					left outer join CFuncional cf
						 on cf.CFid = d.CFid
						 and cf.Ecodigo = d.Ecodigo
						 
					inner join CContables e
						on d.Ccuenta = e.Ccuenta										
				where a.EMid =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#">
                	and c.CBesTCE = <cfqueryparam value="#Arguments.ubicacion#" cfsqltype="cf_sql_numeric">
			</cfquery>		
            <cfquery name="rsIntarc" datasource="#Arguments.Conexion#">
            select * from #Intarc#			
            </cfquery>	
           
			<cfif Arguments.debug EQ 'S'>
				<cfquery name="rsIntarc" datasource="#Arguments.Conexion#">
					select INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE
					from #Intarc#
				</cfquery>	
			</cfif>
			
			
		<!---  DIOT  --->
		<!--- Detalles del pago --->
		<cfquery name="rsDetalleMov" datasource="#session.dsn#">
			select EMid, sum(DMmonto) 
			from DMovimientos d
			inner join CFinanciera c on d.Ccuenta = c.Ccuenta and d.Ecodigo = c.Ecodigo
			inner join Impuestos i on i.Icodigo = d.Icodigo and i.Ecodigo = d.Ecodigo
			where d.EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#">
			and d.Icodigo <> '' 
			and i.Iporcentaje > 0
			group by EMid
		</cfquery>
		
		<cfset _today = now()>
		<cfif isdefined('rsDetalleMov') and rsDetalleMov.recordcount GT 0>
			<cfquery name="rsDIOT" datasource="#session.dsn#">
				select e.Ecodigo, 
							0 as SNcodigo, 
							'MBMV' as Origen, 
							'EMovimientos' as Tabla, 
							e.EMid, 
							i.Icodigo, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Periodo#"> as Periodo,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Mes#"> as Mes, 
							((d.DMmonto*100)/i.Iporcentaje) as MontoBaseOri,
							((((d.DMmonto*100)/i.Iporcentaje)) * e.EMtipocambio) as MontoBaseLoc,
							 d.DMmonto as MontoIVAOri, 
							 (d.DMmonto * e.EMtipocambio) as MontoIVALoc,
							 e.EMtipocambio, 
							 #session.usucodigo# as Usucodigo, 
							 #session.usucodigo# as BMUsucodigo, 
							 #_today# as Fecha,
							 e.EMDocumento, 
							 1 as Pagado,
							 b.Bid,
							 impDIOT.DIOTivacodigo
					from EMovimientos e
					inner join DMovimientos d on e.EMid = d.EMid
					inner join Impuestos i on i.Icodigo = d.Icodigo
					inner join ImpuestoDIOT impDIOT on impDIOT.Icodigo = i.Icodigo and impDIOT.Ecodigo = i.Ecodigo 
					inner join CuentasBancos cb on e.CBid = cb.CBid
					inner join Bancos b on b.Bid = cb.Bid
					where d.EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#">
			</cfquery>
			
			<cfquery name="rsDIOTBanco" dbtype="query">
				select Ecodigo,  Origen, Tabla, EMid, Icodigo, Periodo, Mes, sum(MontoBaseOri) as MontoBaseOri, sum(MontoBaseLoc) as MontoBaseLoc,
				sum(MontoIVAOri) as MontoIVAOri, sum(MontoIVALoc) as MontoIVALoc, EMtipocambio, Usucodigo, BMUsucodigo,  #_today# as Fecha, EMDocumento,
				Pagado, Bid , SNcodigo, DIOTivacodigo from rsDIOT
				group by Ecodigo, Origen, Tabla, EMid, Icodigo, Periodo, Mes, EMtipocambio, 
				Usucodigo, BMUsucodigo, Fecha, EMDocumento, Pagado, Bid, SNcodigo,DIOTivacodigo		
			</cfquery>		
			
			<cfloop query="rsDIOTBanco">
				<cfquery datasource="#session.dsn#">
   					INSERT INTO DIOT_Control (
							Ecodigo, 
							SNcodigo,
							Oorigen, 
							TablaOrigen,
							CampoId, 
							Icodigo, 
							IPeriodo, 
							IMes, 
							OMontoBaseIVA, 
							LMontoBaseIVA,
	                    	OIVAPagado, 
							LIVAPagado, 
							TipoCambioIVA,	
							Usucodigo, 
							BMUsucodigo, 
							ts_rversion, 
							Documento,
							DIOTivacodigo, 
							Pagado,
							Bid)
   					values (<cfqueryparam cfsqltype="cf_sql_integer"	 value="#rsDIOTBanco.Ecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_integer" 	 value="#rsDIOTBanco.SNcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" 	 value="#rsDIOTBanco.Origen#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDIOTBanco.Tabla#">,
							<cfqueryparam cfsqltype="cf_sql_integer" 	 value="#rsDIOTBanco.EMid#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDIOTBanco.Icodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDIOTBanco.Periodo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDIOTBanco.Mes#">,
							<cfqueryparam cfsqltype="cf_sql_Money" 	 value="#rsDIOTBanco.MontoBaseOri#">,
							<cfqueryparam cfsqltype="cf_sql_Money" 	 value="#rsDIOTBanco.MontoBaseLoc#">,
							<cfqueryparam cfsqltype="cf_sql_Money" 	 value="#rsDIOTBanco.MontoIVAOri#">,
							<cfqueryparam cfsqltype="cf_sql_Money" 	 value="#rsDIOTBanco.MontoIVALoc#">,
							<cfqueryparam cfsqltype="cf_sql_Money" 	 value="#rsDIOTBanco.EMtipocambio#">,
							<cfqueryparam cfsqltype="cf_sql_integer"	 value="#rsDIOTBanco.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_integer"	 value="#rsDIOTBanco.BMUsucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDIOTBanco.Fecha#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDIOTBanco.EMDocumento#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDIOTBanco.DIOTivacodigo#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDIOTBanco.Pagado#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDIOTBanco.Bid#">
							)				
   				</cfquery>
			</cfloop>
		</cfif>					
		
	<!---	<cfquery name="xx" datasource="#Arguments.Conexion#">
				select *
				from  DIOT_Control a
				where Iperiodo = 2016 and Imes = 5
			</cfquery>	
			
			<cf_dump var="#xx#">--->
	<!--- TERMINA DIOT--->
			
		<!---Cliente --->
		<cfelseif  TIPO eq 1>	 
			<cfquery name="RSLlaves" datasource="#Arguments.Conexion#">
				select TpoTransaccion,EMdocumento,SNcodigo 
				from  EMovimientos a
				where a.Ecodigo = #Session.Ecodigo#
				and   a.EMid    = #Arguments.EMid#
			</cfquery>
			<cfset CCTcodigo  = RSLlaves.TpoTransaccion>
			<cfset Ddocumento = RSLlaves.EMdocumento>
			<cfset SNcodigo   = RSLlaves.SNcodigo>

			<!--- inserta  Documentos --->
            <!---Verifica el Parametro 200030 para seleccionar la Cuenta de Cliente Correcta--->
           	<cfquery name="rsParametroCta" datasource="#Session.DSN#">
                select Pvalor
                from Parametros
                where Ecodigo = #Session.Ecodigo#  
                  and Pcodigo = '200030'
            </cfquery>
            <cfif isdefined("rsParametroCta") and rsParametroCta.recordcount GT 0 and rsParametroCta.Pvalor NEQ "">
            	<cfset ParametroCta = rsParametroCta.Pvalor>
            <cfelse>
            	<cfset ParametroCta = 0>
            </cfif>
			<cfquery name="insertaDocumentos" datasource="#Arguments.Conexion#">
				insert into Documentos (
						Ecodigo, 			
						CCTcodigo, 			Ddocumento, 		Ocodigo,
						SNcodigo, 			Mcodigo, 			Dtipocambio, 		
						Dtotal,				Dsaldo,				Dfecha, 			
						Dvencimiento,		Ccuenta,
						Dtcultrev,			Dusuario,				Rcodigo,
						Dmontoretori,		Dtref,					Ddocref,
						Icodigo,			
						Dreferencia,			
						DEidVendedor,
						DEidCobrador,		
						DEdiasVencimiento,		DEordenCompra,
						DEnumReclamo,		
						DEobservacion,			
						DEdiasMoratorio,
						id_direccionFact, 	id_direccionEnvio, 		CFid,
						CDCcodigo, 			EDtipocambioVal, 		EDtipocambioFecha,
				     	CodTipoPago
				)
				select 	
					#Arguments.Ecodigo#,
					a.TpoTransaccion,	a.EMdocumento,		a.Ocodigo, 
					a.SNcodigo,			b.Mcodigo,			a.EMtipocambio,
					a.EMtotal,			a.EMtotal,			a.EMfecha,
					a.EMfecha,			coalesce(<cfif ParametroCta EQ 1>cfct.Ccuenta,</cfif>sd.SNDCFcuentaCliente, s.SNcuentacxc),
					a.EMtipocambio,		a.EMusuario,		<cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="null">,
					0,					a.TpoTransaccion,	a.EMdocumento,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="null">,				
					<cf_jdbcquery_param cfsqltype="cf_sql_decimal"  value="null">,				
					<cf_jdbcquery_param cfsqltype="cf_sql_decimal"  value="null">,	
					<cf_jdbcquery_param cfsqltype="cf_sql_decimal"  value="null">,				
					0,					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="null">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="null">,				
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"  value="null">,				
					0,
					a.id_direccion,		a.id_direccion,		a.CFid,
					a.CDCcodigo, 		a.EMtipocambio, 	a.EMfecha,
					a.CodTipoPago
				from EMovimientos a
				inner join CuentasBancos b
					on b.CBid=a.CBid
					and b.Ecodigo=a.Ecodigo	
				inner join SNegocios s	
					on a.SNcodigo=s.SNcodigo
					and a.Ecodigo=s.Ecodigo	
				inner join SNDirecciones sd
					on a.SNid= sd.SNid
					and a.id_direccion=  sd.id_direccion
                <cfif ParametroCta EQ 1>
                    left join SNCCTcuentas sct
                        inner join CFinanciera cfct
                            on  sct.Ecodigo = cfct.Ecodigo
                            and sct.CFcuenta = cfct.CFcuenta
                        on s.Ecodigo = sct.Ecodigo 
                        and s.SNcodigo = sct.SNcodigo
                        and a.TpoTransaccion = sct.CCTcodigo
                </cfif>
				where a.Ecodigo = #Session.Ecodigo#
				and   a.EMid    = #Arguments.EMid#	
                and   b.CBesTCE = <cfqueryparam value="#Arguments.ubicacion#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<!--- inserta  HDocumentos---> 
			<cfquery name="insertaHDocumentos" datasource="#Arguments.Conexion#">
				insert into HDocumentos (
					Ecodigo, 			CCTcodigo, 			Ddocumento, 
					Ocodigo,			SNcodigo, 			Mcodigo, 
					Dtipocambio, 		Dtotal,				Dsaldo,
					Dfecha, 			Dvencimiento,		Ccuenta,
					Dtcultrev,			Dusuario,			Rcodigo,
					Dmontoretori,		Dtref,				Ddocref, 
					Icodigo,			Dreferencia,		DEidVendedor,
					DEidCobrador,		DEdiasVencimiento,	DEordenCompra,
					DEnumReclamo,		DEobservacion,		DEdiasMoratorio,
					id_direccionFact, 	id_direccionEnvio,  CFid,
					CDCcodigo,			EDtipocambioVal, 	EDtipocambioFecha
					)
				select 
					Ecodigo, 			CCTcodigo, 			Ddocumento, 
					Ocodigo,			SNcodigo, 			Mcodigo, 
					Dtipocambio, 		Dtotal,				Dsaldo,
					Dfecha, 			Dvencimiento,		Ccuenta,
					Dtcultrev,			Dusuario,			Rcodigo,
					Dmontoretori,		Dtref,				Ddocref, 
					Icodigo,			Dreferencia,		DEidVendedor,
					DEidCobrador,		DEdiasVencimiento,	DEordenCompra,
					DEnumReclamo,		DEobservacion,		DEdiasMoratorio,
					id_direccionFact, 	id_direccionEnvio, 	CFid,
					CDCcodigo,			EDtipocambioVal,	EDtipocambioFecha
				from Documentos
				where Ecodigo = #Session.Ecodigo#
				  and CCTcodigo = <cf_jdbcquery_param value="#CCTcodigo#" cfsqltype="cf_sql_char" > 
				  and Ddocumento = <cf_jdbcquery_param value="#Ddocumento#" cfsqltype="cf_sql_char" >
				  and SNcodigo =<cf_jdbcquery_param value="#SNcodigo#" cfsqltype="cf_sql_integer" >
			</cfquery>
			<!--- inserta  INTARC --->
			<cf_dbfunction name="concat" args="'MBMV: Cliente ' + c.SNidentificacion  + c.SNidentificacion" delimiters='+' returnvariable="LvarCI">
			<cfquery name="insertaINTARC" datasource="#Arguments.Conexion#">
					insert INTO #Intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento,CFid)
					select 
							'MBMV',
							1,
							a.Ddocumento,
							a.CCTcodigo, 
							round(a.Dtotal *	a.Dtipocambio,2),
							b.CCTtipo,
							#PreserveSingleQuotes(LvarCI)#,
							'#LSDateFormat(Now(),'yyyymmdd')#',
							a.Dtipocambio,
							<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Periodo#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Mes#">,
							a.Ccuenta,
							a.Mcodigo,
							a.Ocodigo,
							a.Dtotal,
                            '#varNumeroEvento#',a.CFid
						from Documentos a, CCTransacciones b, SNegocios c
						where a.Ecodigo = #Session.Ecodigo#
						  and a.CCTcodigo = <cf_jdbcquery_param value="#CCTcodigo#" cfsqltype="cf_sql_char" > 
						  and a.Ddocumento = <cf_jdbcquery_param value="#Ddocumento#" cfsqltype="cf_sql_char" >
						  and a.SNcodigo = <cf_jdbcquery_param value="#SNcodigo#" cfsqltype="cf_sql_integer" >
						  and a.Ecodigo = b.Ecodigo
						  and a.CCTcodigo = b.CCTcodigo
						  and a.Ecodigo = c.Ecodigo
						  and a.SNcodigo = c.SNcodigo
						  and a.Dtotal != 0
				</cfquery>
                
            <cfquery name="rsIntarc" datasource="#Arguments.Conexion#">
             select * from #Intarc#			
            </cfquery>	
           
			<!--- inserta  BMovimientos --->
			<cfquery name="insertaBMovimientos" datasource="#Arguments.Conexion#">
				insert into BMovimientos (
					Ecodigo, 		CCTcodigo, 		Ddocumento, 
					CCTRcodigo, 	DRdocumento, 	BMfecha, 
					Ccuenta, 		Ocodigo, 		SNcodigo, 
					Mcodigo, 		Dtipocambio, 	Dtotal, 
					Dfecha, 		Dvencimiento, 	IDcontable, 
					BMperiodo, 		BMmes, 			Dtcultrev, 
					BMusuario, 		Rcodigo, 		BMmontoretori, 
					BMtref, 		BMdocref, 		Dtotalloc, 	
					Dtotalref, 		Icodigo, 		Dreferencia, CFid)
				select 
					Ecodigo, 		CCTcodigo, 		Ddocumento, 
					CCTcodigo, 	    Ddocumento, 	<cf_jdbcquery_param value="#now()#" cfsqltype="cf_sql_timestamp">, 
					Ccuenta, 		Ocodigo, 		SNcodigo, 
					Mcodigo, 		Dtipocambio,	Dtotal, 
					Dfecha, 		Dvencimiento,	<cf_jdbcquery_param cfsqltype="cf_sql_decimal" value="null">, 
					<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Periodo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Mes#">,
					Dtipocambio, 
					Dusuario, 		Rcodigo,		Dmontoretori, 
					Dtref, 			Ddocref, 		round(Dtotal * Dtipocambio,2), 
					Dtotal, 		Icodigo, 		Dreferencia, CFid
				from Documentos
				where Ecodigo = #Session.Ecodigo#
				and CCTcodigo = <cf_jdbcquery_param value="#CCTcodigo#" cfsqltype="cf_sql_char" > 
				and Ddocumento = <cf_jdbcquery_param value="#Ddocumento#" cfsqltype="cf_sql_char" >
				and SNcodigo = <cf_jdbcquery_param value="#SNcodigo#" cfsqltype="cf_sql_integer" >				
			</cfquery>	
		<!--- Proveedor --->
		<cfelseif  TIPO eq 2>	
			<!--- inserta  EDocumentosCP --->
			<cfquery name="selectDatEDocCP" datasource="#Arguments.Conexion#">
				select 	
						#Arguments.Ecodigo#,a.TpoTransaccion,	a.EMdocumento,		
						a.SNcodigo,			b.Mcodigo,			a.Ocodigo,  		
						a.EMtipocambio,		a.EMtotal,			a.EMtotal,			
						a.EMfecha,			a.EMfecha,			a.EMfecha,			
						coalesce(sd.SNDCFcuentaProveedor, s.SNcuentacxp) as Cuenta,
						a.EMtipocambio,		a.EMusuario,		<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">,
						0,					a.TpoTransaccion,	a.EMdocumento,		
						a.CFid,	(select min(TESRPTCid) from TESRPTconcepto where CEcodigo=#session.CEcodigo# and TESRPTCcxp=1) as TESRPTCid
					from EMovimientos a
					inner join CuentasBancos b
						on b.CBid=a.CBid
						and b.Ecodigo=a.Ecodigo	
					inner join SNegocios s	
						on a.SNcodigo=s.SNcodigo
						and a.Ecodigo=s.Ecodigo	
					inner join SNDirecciones sd
						on a.SNid= sd.SNid
						and a.id_direccion=  sd.id_direccion
					where a.Ecodigo = #Session.Ecodigo#
                    and   b.CBesTCE = <cfqueryparam value="#Arguments.ubicacion#" cfsqltype="cf_sql_numeric">
					and   a.EMid    = #Arguments.EMid#
			</cfquery>
			<cfquery name="insertaEDocumentosCP" datasource="#Arguments.Conexion#">
				insert into EDocumentosCP (
					Ecodigo, 			CPTcodigo, 			Ddocumento, 		
					SNcodigo, 			Mcodigo, 			Ocodigo,		
					Dtipocambio, 		Dtotal,				EDsaldo,		
					Dfecha, 			Dfechavenc,			Dfechaarribo,	
					Ccuenta,			
					EDtcultrev,			EDusuario,			Rcodigo,			
					EDmontoretori,		EDtref,				EDdocref,			
					CFid,				Icodigo,			TESRPTCid)
				values(#Arguments.Ecodigo#,		'#selectDatEDocCP.TpoTransaccion#',	'#selectDatEDocCP.EMdocumento#',
				#selectDatEDocCP.SNcodigo#,		#selectDatEDocCP.Mcodigo#,			#selectDatEDocCP.Ocodigo#,
				#selectDatEDocCP.EMtipocambio#,	#selectDatEDocCP.EMtotal#,			#selectDatEDocCP.EMtotal#,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#selectDatEDocCP.EMfecha#" null="#selectDatEDocCP.EMfecha eq ''#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#selectDatEDocCP.EMfecha#" null="#selectDatEDocCP.EMfecha eq ''#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#selectDatEDocCP.EMfecha#" null="#selectDatEDocCP.EMfecha eq ''#">,
				#selectDatEDocCP.Cuenta#,		
				#selectDatEDocCP.EMtipocambio#,	'#selectDatEDocCP.EMusuario#',		<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">,		
				0,								'#selectDatEDocCP.TpoTransaccion#',	'#selectDatEDocCP.EMdocumento#',
				<cfif #selectDatEDocCP.CFid# eq "">
				<cf_jdbcquery_param cfsqltype="cf_sql_decimal" value="null">,
				<cfelse>
				#selectDatEDocCP.CFid#,
				</cfif>
				<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">,	
				#selectDatEDocCP.TESRPTCid#
				)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>	
			<cf_dbidentity2 datasource="#session.DSN#" name="insertaEDocumentosCP">
			<cfset llave = "#insertaEDocumentosCP.identity#">	

			<!--- inserta  HEDocumentosCP --->
			<cfquery name="insertaHEDocumentosCP" datasource="#Arguments.Conexion#">
				insert into HEDocumentosCP (
					IDdocumento,	Ecodigo, 		CPTcodigo, 			Ddocumento, 	SNcodigo, 
					Mcodigo, 		Ocodigo,		Dtipocambio, 		Dtotal,			EDsaldo,
					Dfecha,			Dfechavenc,		Dfechaarribo,		Ccuenta,		EDtcultrev,
					EDusuario,		Rcodigo,		EDmontoretori,		EDtref,			EDdocref,
					Icodigo,		TESRPTCid,		CFid)
				select
					IDdocumento,	Ecodigo, 		CPTcodigo, 			Ddocumento, 	SNcodigo, 
					Mcodigo, 		Ocodigo,		Dtipocambio, 		Dtotal,			EDsaldo,
					Dfecha, 		Dfechavenc,		Dfechaarribo,		Ccuenta,		EDtcultrev,
					EDusuario,		Rcodigo,		EDmontoretori,		EDtref,			EDdocref,
					Icodigo,		TESRPTCid,		CFid
				from EDocumentosCP
				where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#llave#">
			</cfquery>
			
			<!--- inserta  Intarc --->
			<cf_dbfunction name="string_part" args="c.SNidentificacion, 1,30" returnvariable="LvarSNidentificacion">
			<cf_dbfunction name="concat" args="'MBMV:' + #LvarSNidentificacion# + ' ' + c.SNnombre" delimiters='+' returnvariable="LvarINTDES">
			<cfquery name="insertaIntarc" datasource="#Arguments.Conexion#">
				insert INTO #Intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento,CFid)
				select 
						'MBMV',			1,										a.Ddocumento,
						a.Ddocumento, 	round(a.Dtotal * a.Dtipocambio,2),		b.CPTtipo,
						#PreserveSingleQuotes(LvarINTDES)#,
						'#LSDateFormat(Now(),'yyyymmdd')#',
						a.Dtipocambio,	
						<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Periodo#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Mes#">,
						a.Ccuenta,		a.Mcodigo,		a.Ocodigo,
						a.Dtotal, '#varNumeroEvento#',a.CFid
				from EDocumentosCP a,  CPTransacciones b , SNegocios c
				where a.IDdocumento = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#llave#">
				  and a.Ecodigo = b.Ecodigo
				  and a.CPTcodigo = b.CPTcodigo
				  and a.Ecodigo = c.Ecodigo
				  and a.SNcodigo = c.SNcodigo
			</cfquery>
			
			<cfquery name="rsIntarc" datasource="#Arguments.Conexion#">
              select * from #Intarc#			
            </cfquery>	            

			<!--- inserta  BMovimientosCxP --->
			<cfquery name="insertaBMovimientosCxP" datasource="#Arguments.Conexion#">
				insert into BMovimientosCxP (
					Ecodigo, 		CPTcodigo, 		Ddocumento, 
					CPTRcodigo, 	DRdocumento, 	BMfecha, 
					Ccuenta, 		Ocodigo,		SNcodigo, 
					Mcodigo, 		Dtipocambio, 	Dtotal, 
					Dfecha, 		Dvencimiento, 	IDcontable, 
					BMperiodo, 		BMmes, 			EDtcultrev, 
					BMusuario, 		Rcodigo, 		BMmontoretori, 
					BMtref, 		BMdocref,		Icodigo,
					CFid)
				select 
					Ecodigo, 		CPTcodigo, 		Ddocumento, 
					CPTcodigo, 		Ddocumento, 	<cf_jdbcquery_param value="#now()#" cfsqltype="cf_sql_timestamp">, 
					Ccuenta, 		Ocodigo, 		SNcodigo, 
					Mcodigo, 		Dtipocambio, 	Dtotal, 
					Dfechaarribo, 	Dfechavenc, 	<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">, 
					<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Periodo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Mes#">, 
					Dtipocambio, 	EDusuario, 		Rcodigo, 
					EDmontoretori, 	EDtref, 		EDdocref, 
					Icodigo,		CFid
				from EDocumentosCP
					where IDdocumento = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#llave#">
			</cfquery>
		 <cfelseif  TIPO eq 3>	 <!---Mov. Documentos Cliente --->
			<cf_abort errorInterfaz="">
		 <cfelseif  TIPO eq 4>	 <!---Mov. Documentos Proveedor --->
			<cf_abort errorInterfaz="">
		</cfif>


		<!---- 5. Ejecutar el Genera asiento ---->
		<cfquery name="rsDescripcion" datasource="#Arguments.Conexion#">
			select b.CBcodigo
			from EMovimientos a
				inner join CuentasBancos b
					on a.CBid = b.CBid
			where a.EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#">	
            	and b.CBesTCE = <cfqueryparam value="#Arguments.ubicacion#" cfsqltype="cf_sql_numeric">
		</cfquery>
					
		<!---- Carga de descripcion ---->
		<cfif isdefined("rsDescripcion")>
			<cfset descripcion = descripcion & rsDescripcion.CBcodigo>
		</cfif>
		
		<cfquery name="rs_revisa_Intarc" datasource="#arguments.conexion#">
			select count(1) as lineas
			from #Intarc#
		</cfquery>			

		<cfquery name="rsVerificaBalance" datasource="#Arguments.conexion#">
			select 
				coalesce(sum(case when INTTIP = 'D' then INTMON else 0.00 end),0) as Debitos,
				coalesce(sum(case when INTTIP = 'C' then INTMON else 0.00 end),0) as Creditos,
				coalesce(sum(case when INTTIP = 'D' then INTMOE else 0.00 end),0) as DebitosE,
				coalesce(sum(case when INTTIP = 'C' then INTMOE else 0.00 end),0) as CreditosE
				from #intarc#
		</cfquery>         
		<cfif rsVerificaBalance.recordcount GT 0 >
        
			<cfif rsVerificaBalance.DebitosE NEQ rsVerificaBalance.CreditosE or abs(rsVerificaBalance.Debitos - rsVerificaBalance.Creditos) GT 0.05>
				<!---   Revisión de los Datos de la tabla antes de enviar a Posteo de Asientos  --->
				<br>
				No se logró balancear el Asiento Generado
				<br>

				<cfquery name="rsVerifica" datasource="#Arguments.conexion#">
					select 
						d.INTDOC as A_Documento,
						'A_Financiera' as B_TipoCuenta, 
						c.CFformato as C_Cuenta, 
						d.INTTIP Mov_Tipo, 
						d.INTMON as Mov_Monto, 
						case when d.INTTIP = 'D' then INTMON else 0.00 end as Mov_Debitos,
						case when d.INTTIP = 'C' then INTMON else 0.00 end as Mov_Creditos,
						d.INTDES as Mov_Descripcion, 
						coalesce(c.CFdescripcion, ' **** NO EXISTE **** ') as C_DescripcionCuenta
					from #intarc# d
					  left join CFinanciera c
						on c.CFcuenta = d.CFcuenta
					where d.CFcuenta is not null 

					union all

					select 
						d.INTDOC as A_Documento,
						'A_Contable' as B_TipoCuenta, 
						c.Cformato as C_Cuenta, 
						d.INTTIP as Mov_Tipo, 
						d.INTMON as Mov_Monto, 
						case when d.INTTIP = 'D' then INTMOE else 0.00 end as Mov_Debitos,
						case when d.INTTIP = 'C' then INTMOE else 0.00 end as Mov_Creditos,
						d.INTDES as Mov_Descripcion, 
						coalesce(c.Cdescripcion, ' **** NO EXISTE **** ') as C_DescripcionCuenta
					from #intarc# d
					  left join CContables c
					on c.Ccuenta = d.Ccuenta
					where d.CFcuenta is null 
					  and d.Ccuenta is not null 
					order by 1
				</cfquery>
               	
				<cfdump var="#rsVerifica#" label="AsientoGenerado">

				<cfquery name="rsdebug" datasource="#Arguments.conexion#">
					select * from #intarc#
				</cfquery>

				<cfdump var="#rsdebug#" label="Datos de la INTARC">
					<cftransaction action="rollback"/>
				<cf_abort errorInterfaz="">

			<!---  Fin de Revisión de los Datos de la tabla antes de enviar a Posteo de Asientos  --->


			</cfif>
		</cfif>        
		<cfif isdefined('rs_revisa_Intarc') and rs_revisa_Intarc.lineas GT 1>
			<cfquery name="rsOcodigo" datasource="#Arguments.conexion#">
				select Ocodigo 
				from EMovimientos
				where EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			</cfquery>
            
            <cfset Oorigen = 'MBMV'>
			<cfif isdefined("Arguments.ubicacion") and Arguments.ubicacion eq 1>
            	<cfset Oorigen = 'TCMV'>
            </cfif>
			
            <cfinvoke component="CG_GeneraAsiento" method="GeneraAsiento" returnvariable="IDcontable">
				<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
				<cfinvokeargument name="Oorigen" value="#Oorigen#"/>
				<cfinvokeargument name="Eperiodo" value="#Periodo#"/>
				<cfinvokeargument name="Emes" value="#Mes#"/>
				<cfinvokeargument name="Efecha" value="#Fecha#"/>
				<cfinvokeargument name="Edescripcion" value="#descripcion#"/>
				<cfinvokeargument name="Edocbase" value="#EMdocumento#"/>
				<cfinvokeargument name="Ereferencia" value="#EMreferencia#"/>
				<cfinvokeargument name="Ocodigo" value="#rsOcodigo.Ocodigo#"/>
				<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/>
				<cfinvokeargument name="ConciliaML" value="#ConciliaML#"/>
			</cfinvoke>
         
			<cfquery datasource="#Arguments.Conexion#">
				update TESRPTcontables
				   set IDcontable	= #IDcontable#
				     , Dlinea		= (select Dlinea from #intarc# where LIN_IDREF = TESRPTcontables.Dlinea)
				 where EMid = #Arguments.EMid#
				   and (select count(1) from #intarc# where LIN_IDREF = TESRPTcontables.Dlinea) > 0
			</cfquery>
		</cfif>
           
		<cfif not isdefined("IDcontable") or IDcontable LT 1 or IDcontable EQ ''>
			<cftransaction action="rollback"/>
			<cf_errorCode	code = "51012" msg = "Error en la Generación del Asiento">
		</cfif> 
		
		<cfquery name="updateMLibros" datasource="#arguments.conexion#">
			update MLibros 
			set IDcontable = <cfqueryparam cfsqltype="numeric" value="#IDcontable#">
			where MLid = #MLid#				
		</cfquery>
					
		<!--- INICIO --->
	 	<cfquery name="getContE" datasource="#Session.DSN#">
			select ERepositorio from Empresa
			where Ereferencia = #Session.Ecodigo#
		</cfquery>
		<cfif isdefined("getContE.ERepositorio") and getContE.ERepositorio EQ "1">
			<cfquery name="rsinfBanSAT" datasource="#session.DSN#">
		    	INSERT INTO CEInfoBancariaSAT(IDcontable,Dlinea,
	                TESDPid,TESOPid,
	                TESTMPtipo,IBSATdocumento,ClaveSAT,
	                CBcodigo,TESOPfechaPago,TESOPtotalPago,
	                IBSATbeneficiario,IBSATRFC,IBSAClaveSATtran,IBSATctadestinotran,cveMtdoPgoSAT)
		        SELECT
			        #IDcontable# as IDcontable,
					MAX(dco.Dlinea),
					null,
					null,
					case mtdoPago.cveMtdoPagoSAT
						when '2' then 'CHK'
						when '3' then 'TRM'
						else 'PT'
					end,
					emo.EMdocumento as IBSATdocumento,
					CASE WHEN emo.Tipo = 'D' THEN emo.EMdescripcionOD
					     WHEN emo.Tipo = 'C' THEN cveSAT.Clave
					END as ClaveSAT,
					CASE WHEN emo.Tipo = 'D' THEN emo.EMBancoIdOD
					     WHEN emo.Tipo = 'C' THEN cb.CBcodigo
					END as CBcodigo,
					emo.EMfecha as TESOPfechaPago,
					emo.EMtotal as TESOPtotalPago,
					coalesce(emo.EMNombreBenefic,'') as IBSATbeneficiario,
					coalesce(emo.EMRfcBenefic,'') as IBSATRFC,
					CASE WHEN emo.Tipo = 'D' THEN cveSAT.Clave
					     WHEN emo.Tipo = 'C' THEN emo.EMdescripcionOD
					END as IBSAClaveSATtran,
					CASE WHEN emo.Tipo = 'D' THEN cb.CBcodigo
					     WHEN emo.Tipo = 'C' THEN emo.EMBancoIdOD
					END as IBSATctadestinotran,
					isnull(mtdoPago.cveMtdoPagoSAT,99) cveMtdoPagoSAT
				FROM (
					SELECT DISTINCT e.EMid, cb.Clave
					FROM EMovimientos e, Bancos b, CEBancos cb
					WHERE e.CBid = b.Bid AND b.CEBSid = cb.Id_Banco
						AND b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
						AND e.Ecodigo = b.Ecodigo
						and e. EMid = #Arguments.EMid#
				) as cveSAT
				INNER JOIN EMovimientos emo
					on cveSAT.EMid = emo.EMid
				INNER JOIN (
					SELECT DISTINCT bt.BTMetdoPago as cveMtdoPagoSAT, em.EMid
					FROM BTransacciones bt, EMovimientos em WHERE em.BTid = bt.BTid AND em.Ecodigo = bt.Ecodigo
				) as mtdoPago
					on  mtdoPago.EMid = emo.EMid
				INNER JOIN CuentasBancos cb ON cb.CBid = emo.CBid
				INNER JOIN Bancos ban ON ban.Bid = cb.Bid
				INNER JOIN CEBancos ceb ON ceb.Id_Banco = ban.CEBSid
				INNER JOIN (SELECT Dlinea, Ccuenta FROM DContables Where IDcontable = #IDcontable#) dco
					ON dco.Ccuenta = cb.Ccuenta
				WHERE 1=1
					and emo.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				GROUP BY emo.EMdocumento, emo.Tipo, cveSAT.Clave, cb.CBcodigo, emo.EMfecha, emo.EMtotal, emo.EMNombreBenefic,
					emo.EMRfcBenefic, emo.EMdescripcionOD, emo.EMBancoIdOD, mtdoPago.cveMtdoPagoSAT
		    </cfquery>
		</cfif>
		<!---- 6. Borrado de estructuras ----->
		<cftry>
			<cfquery name="deleteDMovimientos" datasource="#arguments.conexion#">
				delete from DMovimientos
				where EMid = #Arguments.EMid#
			</cfquery>			
			<cfcatch type="any">
				<cf_errorCode	code = "51133" msg = "No se pudo eliminar el Detalle del Movimiento. El proceso ha sido cancelado (Tabla: EMovimientos)">
			</cfcatch>
		</cftry>		
		
		<cftry>
			<cfquery name="deleteEMovimientos" datasource="#arguments.conexion#">
				delete from EMovimientos
				where EMid = #Arguments.EMid#
			</cfquery>			
			<cfcatch type="any">
				<cf_errorCode	code = "51134" msg = "No se pudo eliminar el Encabezado del Movimiento. El proceso ha sido cancelado (Tabla: EMovimientos)">
			</cfcatch>
		</cftry>	
		
		<cfif arguments.debug EQ 'S'>
			<cf_abort errorInterfaz="">
		<cfelse>
			<cftransaction action="commit"/>
			<cfquery name="DropIntarc" datasource="#arguments.conexion#">
				delete from #Intarc#					
			</cfquery>					
		</cfif>	
        
        
        <!---Cuando el movimiento es de un mes anterior al auxiliar y mayor al contable
		hay que insertar en CDlibros para que se incluya en la conciliacion y actualizar el saldoBancario--->
		<cfif MovRetroactivo>
        	
			<!---Inserta los documentos En CDlibros para poder verlos en la conciliacion --->
			<cfquery name="rsMLibros" datasource="#session.DSN#">
				select 	MLid, BTid, MLdocumento, MLmonto, MLperiodo,MLmes,
						MLconciliado, MLtipomov, MLfecha, MLusuario ,CBid
				from MLibros 
				where Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				  and MLconciliado 	= 'N' 
				  and MLid 		    = #MLid#
			</cfquery>
		
		
            <cfquery name="updCDlibros" datasource="#session.DSN#">
                insert into CDLibros 
                    (
                        ECid, 
                        MLid, CDLidtrans, CDLdocumento, CDLmonto, 
                        CDLconciliado, CDLmanual, CDLtipomov, CDLfecha, CDLusuario
                    )
                select 	#arguments.ECid#, 
                    MLid, BTid, MLdocumento, MLmonto, 
                    MLconciliado, 'S', MLtipomov, MLfecha, MLusuario 
                from MLibros 
                where Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                  and MLconciliado 	= 'N' 
                  and MLid 		    = #MLid#
            </cfquery>
            
        
            <cfset LvarAnno = rsMLibros.MLperiodo>
            <cfset LvarMes = rsMLibros.MLmes>
            
			<cfif #rsMLibros.MLtipomov# eq 'D'>
           		<cfset DebCre= '+' >
            <cfelse>    
				<cfset DebCre= '-' >
            </cfif>    
            
            
            <cfquery name="rsSaldosBancarios" datasource="#session.DSN#">
                select 1 from SaldosBancarios
                where Periodo*100+Mes > #LvarAnno*100+LvarMes# 
                    and CBid = #rsMLibros.CBid#
            </cfquery>
            
            <cfif rsSaldosBancarios.recordcount eq 0>
                <cfquery name="insertSaldosBancarios" datasource="#session.DSN#">
                    insert into SaldosBancarios(
                    	CBid,        
                        Periodo,   
                        Mes,         
                        Sinicial,   
                        Slocal,     
                        BMUsucodigo    
                        )
                    
                    values(
                    	#rsMLibros.CBid#,
                        <cfif LvarMes eq 12>
                        	#LvarAnno+1#,
                        	1,
                        <cfelse>  
                        	#LvarAnno#,  
                        	#LvarMes+1#,
                        </cfif>    
                        #rsMLibros.MLmonto#,
                        #rsMLibros.MLmonto#,
                        #session.Usucodigo#
                        )
                </cfquery>
            <cfelse>
                <cfquery name="updateSaldosBancarios" datasource="#session.DSN#">
                    Update SaldosBancarios
                        set Slocal = (Slocal/Sinicial)*(Sinicial #DebCre# #rsMLibros.MLmonto#),
                            Sinicial = Sinicial #DebCre# #rsMLibros.MLmonto#
                    where Periodo*100+Mes > #LvarAnno*100+LvarMes# 
                        and CBid = #rsMLibros.CBid#
                </cfquery>
            </cfif>
            
        </cfif>
        														
	</cffunction>
</cfcomponent>

