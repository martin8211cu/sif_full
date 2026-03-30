<!----
	Posteo de Movimientos Bancarios
	Creado por: Angélica Loría Chavarría, Rodolfo 
	Fecha de creación: 25-Octubre-2004
	Modificado por: Angélica Loría Chavarría	
---->

<!---------
	Modificado por Gustavo Fonseca H.
		Fecha: 31-1-2006.
		Motivo: Se permite que los detalles de los movientos tengan centro funcional en nulo porque solo se ocupa 
		para obtener la oficina. Ahora si el detalle del movimiento no tiene centro funcional va a obtener la oficina 
		del encabezado de ese Movimiento (Consejo de Muaricio Esquivel).
	
	Modificado por: Ana Villavicencio
	Fecha de modificación: 26 de mayo del 2005
	Motivo:	Modificación del parametro Fecha; se asignó el parámetro ya q no tenia el dato del documento, 
			por el contrario era la fecha actual y la validación del periodo y mes no dejaba terminar el proceso.
----------->


<cfcomponent>
<cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">

	<cffunction name="PosteoMovimientos" access="public" returntype="string" output="false">
		<!---- Definición de Parámetros --->
		<cfargument name='Ecodigo'	type='numeric' 	required='true'>	 <!--- Codigo empresa ---->
		<cfargument name='EMid' 	type='numeric' 	required='true'>	 <!--- Codigo del movimiento---->
		<cfargument name='usuario' 	type='numeric' 	required='true'>	 <!--- Codigo del usuario ---->
		<cfargument name='debug' 	type='string' 	required='false' default="N">	 <!--- Ejecutra el debug S= si  N= no---->
		<cfargument name='Conexion' type='string' 	required='false'>
		<cfargument name='transaccionActiva' type='boolean' required='false' default="false">
        <cfargument name='IDGarantia' type='numeric' required='false' default="-1">
        <cfargument name='ubicacion' type='numeric'  required='true' default="0">
		
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
				/>
			</cftransaction>
		</cfif>
	
	</cffunction>
	
	<cffunction name="PosteoMovimientosPrivate" access="private" returntype="string" output="false">
		<!---- Definición de Parámetros --->
		<cfargument name='Ecodigo'	  type='numeric' 	required='true'>	 <!--- Codigo empresa ---->
		<cfargument name='EMid' 	  type='numeric' 	required='true'>	 <!--- Codigo del movimiento---->
		<cfargument name='usuario' 	  type='numeric' 	required='true'>	 <!--- Codigo del usuario ---->
       
        <cfargument name='IDGarantia' type='numeric' 	required='false' default="-1">	 <!--- id de la garantia ---->
		<cfargument name='debug' 	  type='string' 	required='false' default="N">	 <!--- Ejecutra el debug S= si  N= no---->
		<cfargument name='Conexion'   type='string' 	required='false'>
		<cfargument name='Intarc' 	  type='string' 	required='false'>
        <cfargument name='ubicacion' type='numeric'  required='true' default="0">
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
									a.EMusuario
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
											MLmes, MLtipomov, MLusuario, IDcontable, BMUsucodigo)
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
									#Arguments.usuario#
							)
						<cf_dbidentity1 datasource="#Arguments.Conexion#">
					</cfquery>									
					<cf_dbidentity2 datasource="#Arguments.Conexion#" name="rsInsertMovLibros">	
					<!-----  Asignacion de la variable MLid ---->
                    <cfset MLid = rsInsertMovLibros.identity>	
					<!----- Error en el insert ----->
					<cfcatch type="any">
						<cf_errorCode	code = "51131"
										msg  = "No se pudo insertar el Movimiento en Libros. El proceso fue cancelado (Tabla: MLibros)"
										errorDat_1="#cfcatch.detail#"
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
					
		<!---- 3. Insert asiento contable ---->
		<cf_dbfunction name="string_part" args="d.DMdescripcion,1,80" returnvariable='LvarDMdescripcion' datasource="#Arguments.Conexion#">
		<cf_dbfunction name="string_part" args="a.EMdocumento,1,20" returnvariable='LvarEMdocumento' datasource="#Arguments.Conexion#">
		<cf_dbfunction name="string_part" args="a.EMreferencia,1,25" returnvariable='LvarEMreferencia' datasource="#Arguments.Conexion#">	
		<cf_dbfunction name="string_part" args="b.BTtipo,1,1" returnvariable='LvarBTtipo' datasource="#Arguments.Conexion#">
		<cf_dbfunction name="string_part" args="a.EMdescripcion,1,80" returnvariable='LvarEMdescripcion' datasource="#Arguments.Conexion#">
		<cf_dbfunction name="string_part" args="a.EMreferencia,1,25" returnvariable='LvarEMreferencia' datasource="#Arguments.Conexion#">				
		<cfquery name="rsInsertAsientoCont" datasource="#Arguments.Conexion#">
			insert INTO #Intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
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
					a.EMtotal
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
             <cfquery name="rsGG" datasource="#Arguments.Conexion#">
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
					coalesce(a.Ocodigo,cf.Ocodigo),
					d.DMmonto,
					d.DMlinea,
					d.PCGDid
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
            <cf_dump var="#rsGG#">          
                   
			<!---- 4. Cuentas contables afectadas en el detalle del movimiento ----->		
			<cfquery name="rsInsertAsientoCont" datasource="#Arguments.Conexion#">
				insert INTO #Intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta,CFcuenta, Mcodigo, Ocodigo, INTMOE, 
									   LIN_IDREF, PCGDid)
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
					coalesce(a.Ocodigo,cf.Ocodigo),
					d.DMmonto,
					d.DMlinea,
					d.PCGDid
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
            <cfdump var="#rsIntarc#">
			<cfif Arguments.debug EQ 'S'>
				<cfquery name="rsIntarc" datasource="#Arguments.Conexion#">
					select INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE
					form #Intarc#			
				</cfquery>	
			</cfif>
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
						CDCcodigo, 			EDtipocambioVal, 		EDtipocambioFecha
				)
				select 	
					#Arguments.Ecodigo#,
					a.TpoTransaccion,	a.EMdocumento,		a.Ocodigo, 
					a.SNcodigo,			b.Mcodigo,			a.EMtipocambio,
					a.EMtotal,			a.EMtotal,			a.EMfecha,
					a.EMfecha,			coalesce(sd.SNDCFcuentaCliente, s.SNcuentacxc),
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
					a.CDCcodigo, 		a.EMtipocambio, 	a.EMfecha
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
					insert INTO #Intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
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
							a.Dtotal
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
            <cfdump var="#rsIntarc#">
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
				insert INTO #Intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
				select 
						'MBMV',			1,										a.Ddocumento,
						a.Ddocumento, 	round(a.Dtotal * a.Dtipocambio,2),		b.CPTtipo,
						#PreserveSingleQuotes(LvarINTDES)#,
						'#LSDateFormat(Now(),'yyyymmdd')#',
						a.Dtipocambio,	
						<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Periodo#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Mes#">,
						a.Ccuenta,		a.Mcodigo,		a.Ocodigo,
						a.Dtotal
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
            <cfdump var="#rsIntarc#">

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
         <cfdump var="#rsVerificaBalance#">
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
        <cf_dump var="#rs_revisa_Intarc.lineas#"> 
		<cfif isdefined('rs_revisa_Intarc') and rs_revisa_Intarc.lineas GT 1>
			<cfquery name="rsOcodigo" datasource="#Arguments.conexion#">
				select Ocodigo 
				from EMovimientos
				where EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			</cfquery>
			<cfinvoke component="CG_GeneraAsiento" method="GeneraAsiento" returnvariable="IDcontable">
				<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
				<cfinvokeargument name="Oorigen" value="MBMV"/>
				<cfinvokeargument name="Eperiodo" value="#Periodo#"/>
				<cfinvokeargument name="Emes" value="#Mes#"/>
				<cfinvokeargument name="Efecha" value="#Fecha#"/>
				<cfinvokeargument name="Edescripcion" value="#descripcion#"/>
				<cfinvokeargument name="Edocbase" value="#EMdocumento#"/>
				<cfinvokeargument name="Ereferencia" value="#EMreferencia#"/>
				<cfinvokeargument name="Ocodigo" value="#rsOcodigo.Ocodigo#"/>
				<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/>
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
	</cffunction>
</cfcomponent>

