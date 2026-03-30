<!--- ABL: Integracion de Tesoreria PMI Houston--->
<!--- La Integracion de Tesoreria, procesa todos lo pagos con cheque y cancelaciones y los envia a unas tablas intermedias para su proceso en el sistema de Tesoreria de PMI --->
<!--- La Interfaz solo funciona con versiones de Coldfusion 8.0 en adelante --->
<!--- Elaboró: Maria de los Angeles Blanco López 10 de Enero del 2011--->


<cfcomponent extends="Interfaz_Base">
	<cffunction name="Ejecuta" access="public" returntype="string" output="no">
    	<cfargument name="Disparo" required="no" type="boolean" default="false">
		<!--- Rutina para Obtener Parametros a Ocupar --->
		<cfset ParImp = true>
		<!--- Crear un Parametro Ver 2.0 --->
		<cfset ParBorrado = false>
		
		 <!---Obtiene los caches para la busqueda de las ordenes de compra --->
        <cfquery datasource="asp" name="rscaches">
            select e.Ereferencia as Ecodigo, e.CEcodigo, c.Ccache
            from Empresa e
                join Caches c
                on e.Cid = c.Cid and e.Ereferencia is not null
                and e.Ereferencia = 13
        </cfquery>
		
				<cfset RegistrosTes = CargarRegistrosTesoreria(rscaches)>	
				<cfset ValidaDatos = ValidarRegistrosTesoreria()>			
	</cffunction>		
		
    <cffunction name="CargarRegistrosTesoreria">
	   <cfargument name="rscaches" required="yes" type="query">
	   <cfset caches = #Arguments.rscaches#> 
	   <cfsilent>	  
	   <cfloop query="caches"> <!--- Caches loop --->
	   <cftry>
	   		<cfset Verifica = Parametros(Ecodigo=caches.Ecodigo,Pcodigo=101,Parametro="101 Ejecutar Tesorería",ExtBusqueda=true)>
       <cfcatch>
			<cfset Verifica = 0>
       </cfcatch>
       </cftry>
       <cfif Verifica EQ 1>
	   		<!---Invocar al GC para liberar memoria--->
            <cfset javaRT = createobject("java","java.lang.Runtime").getRuntime()>
            <cfset javaRT.gc()><!--- invoca el GC --->
		
			<!---LEE LOS CHEQUES IMPRESOS, ENTREGADOS O ENTREGADO DE LA TESORERIA--->
			<cfquery  name="rsRTesoreria" datasource="#caches.Ccache#">
				select 'RE' as TipoP, OP.TESOPid, OP.EcodigoPago, OP.TESOPfechaPago, OP.TESCFLid, 		                	                TB.TESCFDnumFormulario,B.Iaba, CB.CBcodigo, OP.TESOPtotalPago, OP.Miso4217Pago, OP.TESOPtipoCambioPago,                TB.TESCFBobservacion, U.Usulogin 
				from TEScontrolFormulariosB TB
			    inner join TEScontrolFormulariosD TD on TB.TESid = TD.TESid and TB.CBid = TD.CBid and TB.TESMPcodigo = 										 				TD.TESMPcodigo and TB.TESCFDnumFormulario  = TD.TESCFDnumFormulario
	  			inner join TESordenPago OP on OP.TESOPid = TD.TESOPid
       			inner join TESCFestados TE on TB.TESid = TE.TESid and TB.TESCFEid = TE.TESCFEid and TE.TESCFEcodigo in 																                ('IMP', 'ENT', '000')
		       inner join TESmedioPago TM   
			   		inner join TEStipoMedioPago TP on TM.TESTMPtipo = TP.TESTMPtipo and TP.TESTMPdescripcion 
			   		like 'CHK = Cheque' 
       			on TB.TESid = TM.TESid and TB.TESMPcodigo = TM.TESMPcodigo and TB.CBid = TM.CBid
	   			inner join CuentasBancos CB on CB.CBid = TB.CBid
	   			inner join Bancos B on B.Bid = CB.Bid
				inner join Usuario U on TB.BMUsucodigo = U.Usucodigo
				where TB.Integracion = 0 and OP.EcodigoPago = <cfqueryparam cfsqltype="cf_sql_integer" value="#caches.Ecodigo#">
				union
				select 'AN' as TipoP, OP.TESOPid, OP.EcodigoPago, OP.TESOPfechaPago, OP.TESCFLid,                	                TB.TESCFDnumFormulario, B.Iaba, CB.CBcodigo, OP.TESOPtotalPago, OP.Miso4217Pago, OP.TESOPtipoCambioPago,                TB.TESCFBobservacion, U.Usulogin 
				from TEScontrolFormulariosB TB
			    inner join TEScontrolFormulariosD TD on TB.TESid = TD.TESid and TB.CBid = TD.CBid and TB.TESMPcodigo = 										 				TD.TESMPcodigo and TB.TESCFDnumFormulario  = TD.TESCFDnumFormulario
	  			inner join TESordenPago OP on OP.TESOPid = TD.TESOPid
       			inner join TESCFestados TE on TB.TESid = TE.TESid and TB.TESCFEid = TE.TESCFEid 
				and TE.TESCFEcodigo = 'ANU'
		        inner join TESmedioPago TM   
			   		inner join TEStipoMedioPago TP on TM.TESTMPtipo = TP.TESTMPtipo and TP.TESTMPdescripcion 
			   		like 'CHK = Cheque' 
       			on TB.TESid = TM.TESid and TB.TESMPcodigo = TM.TESMPcodigo and TB.CBid = TM.CBid
	   			inner join CuentasBancos CB on CB.CBid = TB.CBid
	   			inner join Bancos B on B.Bid = CB.Bid
				inner join Usuario U on TB.BMUsucodigo = U.Usucodigo
				where TB.Integracion = 0 and OP.EcodigoPago = <cfqueryparam cfsqltype="cf_sql_integer" value="#caches.Ecodigo#">
				and  exists (select 1 from TEScontrolFormulariosB TB1
			    inner join TESCFestados TE1 on TB1.TESid = TE1.TESid and TB1.TESCFEid = TE1.TESCFEid 
				and TE1.TESCFEcodigo in  ('IMP', 'ENT', '000') and TB1.TESCFDnumFormulario= TB.TESCFDnumFormulario and                TB1.TESid = TB.TESid and TB1.CBid = TB.CBid)
				order by TipoP desc
			</cfquery>
	   		
			<cfif rsRTesoreria.recordcount GT 0>
			<cfloop query="rsRTesoreria"> <!---Extraccion--->
				<cftry>
				<!---Obtener el ID maximo de la tabla--->
				<cfquery name="rsMaxID" datasource="sifinterfaces">
					select isnull(max(ID_Pago), 0) + 1 as Maximo 
					from ESIFLD_Cobros_Pagos
				</cfquery> 
               
			    <cfset Maximo = #rsMaxID.Maximo#>
				
				<cfquery datasource="sifinterfaces">
					insert into ESIFLD_Cobros_Pagos	
					(Ecodigo, 
					Origen,
					ID_Pago,
					Tipo_Pago,
                    Transaccion_Pago, 
					Fecha_Pago,
					Numero_Documento,                                                             
					Banco,                                                                        
					Cuenta_Banco,                                                                
					Total,                                                                       
					Moneda,                                                                      
					Tipo_Cambio,                                                                 
					Observaciones,                                                               
					Usuario,                                                                     
					Estatus,
					Periodo,                                                                     
					Mes)                      
				values
					(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsRTesoreria.EcodigoPago#">,
					'ICTS',
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Maximo#">,
					'P',
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsRTesoreria.TipoP#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#rsRTesoreria.TESOPfechaPago#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsRTesoreria.TESCFDnumFormulario#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsRTesoreria.Iaba#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsRTesoreria.CBcodigo#">,					
					round(#rsRTesoreria.TESOPtotalPago#,2),
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsRTesoreria.Miso4217Pago#">,		
					round(#rsRTesoreria.TESOPtipoCambioPago#,4),	
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsRTesoreria.TESCFBobservacion#">,		
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsRTesoreria.Usulogin#">,		
					30, <!---Estatus mientras se trabaja con los registros--->
					year(getdate()),
					month(getdate()))
				</cfquery>
				
				<!---Detalles de la orden de pago--->
				<cfquery name="rsDetPago" datasource="#caches.Ccache#">
						select DP.EcodigoPago, DP.TESDPreferenciaOri, SN.SNcodigoext, DP.TESDPdocumentoOri,                        DP.TESDPmontoPago, DP.Miso4217Ori, DP.TESDPtipoCambioOri, DP.TESDPmontoAprobadoOri
                        from TESdetallePago DP
                        left join SNegocios SN on DP.SNcodigoOri = SN.SNcodigo and DP.EcodigoPago = SN.Ecodigo
						where TESOPid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsRTesoreria.TESOPid#">
                </cfquery>
				
				<cfset ID_Linea = 1>
				<cfloop query="rsDetPago"> <!--- Detalles --->
					 <cfquery datasource="sifinterfaces">
					 	insert into DSIFLD_Cobros_Pagos(
							Ecodigo,
							ID_Pago,
							ID_linea,
							Tipo_Documento_Pago,
							Socio_Documento_Pago,
							Documento_Pago,
							Monto_Pago,
							Moneda_Documento,
							Tipo_Cambio_Pago,
							Monto_Documento)
						values
							(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDetPago.EcodigoPago#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Maximo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#ID_Linea#">,
							 isnull(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDetPago.TESDPreferenciaOri#">,''),		
							 isnull(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDetPago.SNcodigoext#">,''),
							 isnull(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDetPago.TESDPdocumentoOri#">,''),				
							 round(#rsDetPago.TESDPmontoPago#,2),
							 isnull(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDetPago.Miso4217Ori#">,''),				
							 round(#rsDetPago.TESDPtipoCambioOri#,4),
							 round(#rsDetPago.TESDPmontoAprobadoOri#,2))							 
					 </cfquery>
					 <cfset ID_Linea = ID_Linea + 1>					 
				</cfloop> <!--- Detalles --->
				<cfquery datasource="#caches.Ccache#">
				 	update TEScontrolFormulariosB set Integracion = 1   <!----cambiar a 1---->
					from TEScontrolFormulariosB TB
					inner join TEScontrolFormulariosD TD on TB.TESid = TD.TESid and TB.CBid = TD.CBid 
					and TB.TESMPcodigo = TD.TESMPcodigo and TB.TESCFDnumFormulario  = TD.TESCFDnumFormulario
					where TD.TESOPid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsRTesoreria.TESOPid#">
				</cfquery>
				
				<!---Actualiza los registros insertados---->
				<cfquery datasource="sifinterfaces">
					update ESIFLD_Cobros_Pagos set Estatus = 31 where Estatus = 30 and ID_Pago = 							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Maximo#">
				</cfquery>
			
	<cfcatch>
			<!---- Elimina registros que causaron error---->
			<cfquery datasource="sifinterfaces">
				delete DSIFLD_Cobros_Pagos where ID_Pago = <cfqueryparam cfsqltype="cf_sql_integer" value="#Maximo#">
			</cfquery>
			<cfquery datasource="sifinterfaces">
				delete ESIFLD_Cobros_Pagos where ID_Pago = <cfqueryparam cfsqltype="cf_sql_integer" value="#Maximo#">
			</cfquery>
			<cfif isdefined("cfcatch.Message")>
				<cfset Mensaje="#cfcatch.Message#">
			<cfelse>
				<cfset Mensaje="">
            </cfif>
            <cfif isdefined("cfcatch.Detail")>
               	<cfset Detalle="#cfcatch.Detail#">
			<cfelse>
				<cfset Detalle="">
            </cfif>
			<cfif isdefined("cfcatch.sql")>
               	<cfset SQL="#cfcatch.sql#">
			<cfelse>
				<cfset SQL="">
            </cfif>
			<cfif isdefined("cfcatch.where")>
               	<cfset PARAM="#cfcatch.where#">
			<cfelse>
				<cfset PARAM="">
            </cfif>
			<cfif isdefined("cfcatch.StackTrace")>
               	<cfset PILA="#cfcatch.StackTrace#">
			<cfelse>
				<cfset PILA="">				
            </cfif>
            <cfset MensajeError= #Mensaje# & #Detalle#>
			<cfthrow message="#MensajeError#">
		</cfcatch>
		</cftry>
		</cfloop> <!---Encabezados--->
		</cfif>
        </cfif>
        </cfloop> <!---Caches--->
		</cfsilent>
	  </cffunction> 
	  
	  
	  <cffunction name="ValidarRegistrosTesoreria">
	  <cfsilent>
	 	 	   		
		<cfquery name="rsEncCountReg" datasource="sifinterfaces">
			select ID_Pago, Banco, Cuenta_Banco, Ecodigo, Numero_Documento, Moneda from ESIFLD_Cobros_Pagos where Estatus = 31
		</cfquery>
		
		<cfset EcodigoCP = #rsEncCountReg.Ecodigo#>
							
		<cfif rsEncCountReg.recordcount NEQ 0 >
			<cfloop query="rsEncCountReg">
			<cftransaction action="begin">
			<cftry>
						
			<cfset IDPago = #rsEncCountReg.ID_Pago#>
			
			<!--- Busca equivalencia con el codigo externo de Empresa --->
 			<cfquery datasource="sifinterfaces" name="rsEquivalenciaEmp">
               select  SIScodigo, CATcodigo, EQUempOrigen, EQUcodigoOrigen, EQUempSIF, EQUcodigoSIF, EQUidSIF  
               from SIFLD_Equivalencia
               where SIScodigo = 'ICTS'  
                   and CATcodigo = 'CADENA'
                   and EQUempSIF = <cfqueryparam cfsqltype="cf_sql_integer" value="#EcodigoCP#">
                   and EQUidSIF = <cfqueryparam cfsqltype= "cf_sql_varchar" value="#rsEncCountReg.Ecodigo#">
           </cfquery>
		   
		    <cfif rsEquivalenciaEmp.recordcount EQ 0>
		   		<cfthrow message="No existe equivalencia para la empresa">
			<cfelse>
				<cfquery datasource="sifinterfaces">
				update ESIFLD_Cobros_Pagos set Ecodigo = convert(integer,<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEquivalenciaEmp.EQUcodigoOrigen#">) where ID_Pago = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEncCountReg.ID_Pago#">
				</cfquery>
				<cfquery datasource="sifinterfaces">
				update DSIFLD_Cobros_Pagos set Ecodigo = convert(integer,<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEquivalenciaEmp.EQUcodigoOrigen#">) where ID_Pago = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEncCountReg.ID_Pago#">
				</cfquery>
			</cfif>
		   
		   <!--- Busca equivalencia con el codigo externo de Moneda --->
			   	<cfquery datasource="sifinterfaces" name="rsEquivalenciaMon">
               select  SIScodigo, CATcodigo, EQUempOrigen, EQUcodigoOrigen, EQUempSIF, EQUcodigoSIF, EQUidSIF  
               from SIFLD_Equivalencia
               where SIScodigo = 'ICTS'  
                   and CATcodigo = 'MONEDA'
                   and EQUempSIF = <cfqueryparam cfsqltype="cf_sql_integer" value="#EcodigoCP#">
                   and EQUcodigoSIF = <cfqueryparam cfsqltype= "cf_sql_varchar" value="#rsEncCountReg.Moneda#">
           </cfquery>
		   
		   <cfif rsEquivalenciaMon.recordcount EQ 0>
		   		<cfthrow message="No existe equivalencia para la moneda de la Orden de Pago">
			<cfelse>
				<cfquery datasource="sifinterfaces">
				update ESIFLD_Cobros_Pagos set Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEquivalenciaMon.EQUcodigoOrigen#"> where ID_Pago = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEncCountReg.ID_Pago#">
				</cfquery>
			</cfif>	
			
			<cfif not isdefined("rsEncCountReg.Banco") or trim(rsEncCountReg.Banco) EQ "" >
				<cfthrow message="La Orden de Pago #rsEncCountReg.Numero_Documento# no tiene un codigo de Banco">
			</cfif>
				
			<cfif not isdefined("rsEncCountReg.Cuenta_Banco") or trim(rsEncCountReg.Cuenta_Banco) EQ "" >
				<cfthrow message="La Orden de Pago #rsEncCountReg.Numero_Documento# no tiene una cuenta para el banco #rsEncCountReg.Banco#">
			</cfif>
			
			<cfquery name="rsDetCountReg" datasource="sifinterfaces">
				select ID_linea, Tipo_Documento_Pago, Socio_Documento_Pago, Documento_Pago, Monto_Pago, Moneda_Documento, 			                Ecodigo 
				from DSIFLD_Cobros_Pagos 
				where ID_Pago = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncCountReg.ID_Pago#">
			</cfquery>	
			
			<cfif rsDetCountReg.recordcount GT 0>
			<cfloop query="rsDetCountReg">
				 <!--- Busca equivalencia con el codigo externo de Moneda --->
			   	<cfquery datasource="sifinterfaces" name="rsEquivalenciaMon">
              	 select  SIScodigo, CATcodigo, EQUempOrigen, EQUcodigoOrigen, EQUempSIF, EQUcodigoSIF, EQUidSIF  
               	 from SIFLD_Equivalencia
               	 where SIScodigo = 'ICTS'  
                 and CATcodigo = 'MONEDA'
                 and EQUempSIF = <cfqueryparam cfsqltype="cf_sql_integer" value="#EcodigoCP#">
                 and EQUcodigoSIF = <cfqueryparam cfsqltype= "cf_sql_varchar" value="#rsDetCountReg.Moneda_Documento#">
           		</cfquery>
		   
		   		<cfif rsEquivalenciaMon.recordcount EQ 0>
		   			<cfthrow message="No existe equivalencia para la moneda de la Orden de Pago">
				<cfelse>
					<cfquery datasource="sifinterfaces">
						update DSIFLD_Cobros_Pagos set Moneda_Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEquivalenciaMon.EQUcodigoOrigen#"> where ID_Pago = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEncCountReg.ID_Pago#">
						and ID_linea = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDetCountReg.ID_linea#">
					</cfquery>
				</cfif>	
				
				<cfif not isdefined("rsDetCountReg.Tipo_Documento_Pago") or trim(rsDetCountReg.Tipo_Documento_Pago) EQ "" >
					<cfthrow message="La Orden de Pago #rsEncCountReg.Numero_Documento# no tiene la transacción del docto a pagar">
				</cfif>
				
				<cfif not isdefined("rsDetCountReg.Socio_Documento_Pago") or trim(rsDetCountReg.Socio_Documento_Pago) EQ "" >
					<cfthrow message="La Orden de Pago #rsEncCountReg.Numero_Documento# no tiene el socio del docto a pagar">
				</cfif>	
				
				<cfif not isdefined("rsDetCountReg.Documento_Pago") or trim(rsDetCountReg.Documento_Pago) EQ "" >
					<cfthrow message="La Orden de Pago #rsEncCountReg.Numero_Documento# no tiene el numero del docto a pagar">
				</cfif>	
				
				<cfif not isdefined("rsDetCountReg.Documento_Pago") or trim(rsDetCountReg.Documento_Pago) EQ "" >
					<cfthrow message="La Orden de Pago #rsEncCountReg.Numero_Documento# no tiene el numero del docto a pagar">
				</cfif>	
				<cfif not isdefined("rsDetCountReg.Moneda_Documento") or trim(rsDetCountReg.Moneda_Documento) EQ "" >
					<cfthrow message="La Orden de Pago #rsEncCountReg.Numero_Documento# no tiene la moneda del docto a pagar">
				</cfif>	
				<cfquery datasource="sifinterfaces">
					update ESIFLD_Cobros_Pagos set Estatus = 1 where Estatus = 31 and ID_Pago = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEncCountReg.ID_Pago#">
				</cfquery>
			</cfloop>
			</cfif>		

		<cftransaction action="commit"/> 
					
	  <cfcatch>
	  		<cftransaction action="rollback"/> 	  		
			<cfif isdefined("cfcatch.Message")>
				<cfset Mensaje="#cfcatch.Message#">
			<cfelse>
				<cfset Mensaje="">
            </cfif>
            <cfif isdefined("cfcatch.Detail")>
               	<cfset Detalle="#cfcatch.Detail#">
			<cfelse>
				<cfset Detalle="">
            </cfif>
			<cfif isdefined("cfcatch.sql")>
               	<cfset SQL="#cfcatch.sql#">
			<cfelse>
				<cfset SQL="">
            </cfif>
			<cfif isdefined("cfcatch.where")>
               	<cfset PARAM="#cfcatch.where#">
			<cfelse>
				<cfset PARAM="">
            </cfif>
			<cfif isdefined("cfcatch.StackTrace")>
               	<cfset PILA="#cfcatch.StackTrace#">
			<cfelse>
				<cfset PILA="">
            </cfif>
            <cfset MensajeError= #Mensaje# & #Detalle#>
					
			<cfquery datasource="sifinterfaces">
                        insert into SIFLD_Errores 
                        (Interfaz, Tabla, ID_Documento, MsgError, MsgErrorDet, MsgErrorSQL, MsgErrorParam, MsgErrorPila, Ecodigo, Usuario)
                        select 'CP_Tesoreria', 'ESIFLD_Cobros_Pagos', ID_Pago,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,				 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#EcodigoCP#">,
                            Usuario
                        from ESIFLD_Cobros_Pagos
                        where Estatus in (31)  
                        and ID_Pago = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDPago#">	
              </cfquery>
			  
			  <cfquery datasource="sifinterfaces">
				update ESIFLD_Cobros_Pagos set Estatus = 33 where ID_Pago = <cfqueryparam cfsqltype="cf_sql_numeric" 
				value="#IDPago#">			
			</cfquery>
		</cfcatch>
		</cftry>
		</cftransaction>
		</cfloop>
		</cfif>	
		</cfsilent>
	  </cffunction>
	
	
</cfcomponent>