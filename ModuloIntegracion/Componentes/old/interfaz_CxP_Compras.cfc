<!--- ABG: Transformacion Operaciones de Compra Interfaz LD-SIF Ver. 1.0 --->
<!--- La interfaz de Operaciones de Compra, procesa todas las compras generando los documentos de CxP correspondientes --->
<!--- La Interfaz LD-SIF solo funciona con versiones de Coldfusion 8.0 en adelante --->
<!---
<!--- Rutina para Obtener Parametros a Ocupar --->
<!--- Equivalencia Oficina --->
	<cfset ParOfic = false>
<!--- Equivalencia Centro Funcional --->
	<cfset ParCF = false>
<!--- Crear un Parametro Ver 2.0 --->
	<cfset ParBorrado = false> 
--->

<cfcomponent extends="Interfaz_Base">
	<cffunction name="Ejecuta" access="public" returntype="string" output="yes">
    	<cfargument name="Disparo" required="no" type="boolean" default="false"> <!---ABG--->
        
        <!---Invocar al GC para liberar memoria---> <!---ABG--->
        <cfset javaRT = createobject("java","java.lang.Runtime").getRuntime()>
        <cfset javaRT.gc()><!--- invoca el GC --->
        
		<!--- toma registros cabecera de las Compras --->
		<cfquery datasource="sifinterfaces" result="Rupdate">
			update top (300) ESIFLD_Facturas_Compra
			set Estatus = 10
			where 
            <cfif isdefined("Arguments.Disparo") and Arguments.Disparo>
                Estatus = 1
                and not exists (select 1 from ESIFLD_Facturas_Compra where Estatus in (10, 11,94,92,99,100))
            <cfelse>
            	Estatus = 99
                and not exists (select 1 from ESIFLD_Facturas_Compra where Estatus in (10,11))
            </cfif>
		</cfquery>
		<cfquery name="rsIDECompras" datasource="sifinterfaces">
			select Ecodigo, Origen, Id_DocumentoC, Proveedor, Tipo_Documento, 
				Numero_Documento, Moneda, Fecha_Compra, Fecha_Arribo, Retencion, 
				Sucursal, Almacen, Direccion_Fact 
			from ESIFLD_Facturas_Compra
			where Estatus = 10
            <cfif Rupdate.recordcount EQ 0>
            	and 1 = 2
            </cfif>
		</cfquery>
		
	  	<cfif isdefined("rsIDECompras") AND rsIDECompras.recordcount GT 0>
		<cfloop query="rsIDECompras">
		<cftry>
        	<cfquery name="rsECompras" datasource="sifinterfaces">
                select Ecodigo, Origen, ID_DocumentoC, Proveedor, Tipo_Documento, 
                    Numero_Documento, Moneda, Fecha_Compra, Fecha_Arribo, Retencion, 
                    Sucursal, Almacen, Direccion_Fact 
                from ESIFLD_Facturas_Compra
                where ID_DocumentoC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIDECompras.ID_DocumentoC#">
            </cfquery>
			<cfset DocumentoFact = rsECompras.Id_DocumentoC>
            
            <cfquery datasource="sifinterfaces">
                update ESIFLD_Facturas_Compra
                set Fecha_Inicio_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                where ID_DocumentoC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DocumentoFact#">
            </cfquery>
			
			<!--- Extrae Maximo+1 de tabla IE10 para insertar nuevo reg, en IE10 --->                      
            <cfset RsMaximo = ExtraeMaximo("IE10","ID")>
            <cfif isdefined(#RsMaximo.Maximo#) or #RsMaximo.Maximo# gt 0>
				<cfset Maximus = #RsMaximo.Maximo#>
			<cfelse>
				<cfset Maximus = 1>
			</cfif>
			
			<!---BUSCA EQUIVALENCIAS--->
			<!--- EMPRESAS --->
			<cfset Equiv = ConversionEquivalencia (rsECompras.Origen, 'CADENA', rsECompras.Ecodigo, rsECompras.Ecodigo, 'Cadena')>
			<cfset varEcodigo = Equiv.EQUidSIF>
			<cfset varEcodigoSDC = Equiv.EQUcodigoSIF>
			<cfset session.dsn = getConexion(varEcodigo)>
			<cfset varCEcodigo = getCEcodigo(varEcodigo)>
            
            <!--- Obtiene los parametros --->
            <cfset ParOfic = Parametros(Ecodigo=varEcodigo,Pcodigo=1,Sucursal=rsECompras.Sucursal,Parametro="Equivalencia Oficina",ExtBusqueda=true, Sistema = rsECompras.Origen)>
            
            <!--- Equivalencia Centro Funcional --->
            <cfset ParCF = Parametros(Ecodigo=varEcodigo,Pcodigo=2,Sucursal=rsECompras.Sucursal,Parametro="Equivalencia Centro Funcional",ExtBusqueda=true, Sistema = rsECompras.Origen)>
            
			<!--- Borrar Registro --->
            <cfset ParBorrado = Parametros(Ecodigo=varEcodigo,Pcodigo=4,Sucursal=rsECompras.Sucursal,Parametro="Borrar Registros",ExtBusqueda=true, Sistema = rsECompras.Origen)>
            
            <!--- Obtiene el usuario de Interfaz --->
	        <cfset Usuario = UInterfaz (getCEcodigo(varEcodigo))>
			<cfset varUlogin = Usuario.Usulogin>
            <cfset varUcodigo = Usuario.Usucodigo>
            
            <cfif ParOfic>
				<!---OFICINA --->
                <cfset Equiv = ConversionEquivalencia (rsECompras.Origen, 'SUCURSAL', rsECompras.Ecodigo, rsECompras.Sucursal, 'Sucursal')>
                <cfset VarOcodigo = Equiv.EQUidSIF>
				<cfset VarOficina = Equiv.EQUcodigoSIF>
            <cfelse>
            	 <cfset VarOficina = rsECompras.Sucursal>
                 <cfquery name="rsOFid" datasource="#session.dsn#">
                 	select Ocodigo 
                    from Oficinas
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
                    and Oficodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#VarOficina#">
                 </cfquery>	
                 <cfif isdefined("rsOFid") and rsOFid.recordcount GT 0>
                 	<cfset VarOcodigo = rsOFid.Ocodigo>
                 </cfif>
            </cfif>
			
            <cfif ParCF>
				<!--- CENTRO FUNCIONAL--->
                <cfset Equiv = ConversionEquivalencia (rsECompras.Origen, 'CENTRO_FUN', rsECompras.Ecodigo, rsECompras.Sucursal, 'Centro_Funcional')>
                <cfset varidCF = Equiv.EQUidSIF>
				<cfset varCF = Equiv.EQUcodigoSIF>
            <cfelse>
           		<cfset varCF = rsECompras.Sucursal>
                <cfquery name="rsOFid" datasource="#session.dsn#">
                 	select CFid 
                    from CFuncional
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
                    and CFcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">
                 </cfquery>	
                 <cfif isdefined("rsOFid") and rsOFid.recordcount GT 0>
                 	<cfset varidCF = rsOFid.CFid>
                 </cfif>
            </cfif>

            <!--- MONEDA --->
            <cfset Equiv = ConversionEquivalencia (rsECompras.Origen, 'MONEDA', rsECompras.Ecodigo, rsECompras.Moneda, 'Moneda')>
			<cfset varMoneda = Equiv.EQUcodigoSIF>
            
            <!--- Busca Periodo en Minisif --->
			<cfquery name="BuscaPeriodo" datasource="#session.dsn#">
				select Pvalor from Parametros 
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
                and Pcodigo = 50
			</cfquery>
			<cfset Periodo = BuscaPeriodo.Pvalor>
			
			<!--- Busca Mes en Minisif --->
			<cfquery name="BuscaMes" datasource="#session.dsn#">
				select Pvalor from Parametros 
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
                and Pcodigo = 60
			</cfquery>
			<cfset Mes = BuscaMes.Pvalor>
             
            <!--- IETU --->
         	<cfset Equiv = ConversionEquivalencia (rsECompras.Origen, 'IETU', rsECompras.Ecodigo, 'CM', 'Tipo Operacion')>
			<cfset varIETU = Equiv.EQUcodigoSIF>

			<!--- , 'CLIENTE', 'ECODIGO' --->
	         <cfset VarPrv = ExtraeCliente(rsECompras.Proveedor, varEcodigo)>  
			 						
			<!--- Insercion de cabecera en IE10 --->
			<cfquery datasource="sifinterfaces">
				insert into SIFLD_IE10 
					(ID, EcodigoSDC, NumeroSocio, Modulo, CodigoTransacion, 
					 Documento, Estado, CodigoMoneda, FechaDocumento, FechaVencimiento,
					 DiasVencimiento, Facturado, Origen, VoucherNo, CodigoRetencion, CodigoOficina, 
					 CuentaFinanciera, CodigoConceptoServicio, CodigoDireccionEnvio, CodigoDireccionFact, 
					 BMUsucodigo, ConceptoCobroPago, StatusProceso, CEcodigo,
                     Usulogin, Usucodigo)
				values 
				(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
				 <cfqueryparam cfsqltype ="cf_sql_numeric" value="#varEcodigoSDC#">, 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Proveedor#">,
				 'CP',
				 <cfqueryparam cfsqltype="cf_sql_char" value="#rsECompras.Tipo_Documento#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Numero_Documento#">,
				 null, 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
				 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsECompras.Fecha_Compra,"yyyy/mm/dd")#">, 
				 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsECompras.Fecha_Arribo,"yyyy/mm/dd")#">, 
				 0, 
				 'S', 
				 'LDCP',
				 '0', 
				 <cfif rsECompras.Retencion EQ "">
				 	null,
				 <cfelse>
				 	<cfqueryparam cfsqltype="cf_sql_char" value="#rsECompras.Retencion#">,
				 </cfif> 
				 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficina#">,
				 null, null, 
                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Direccion_Fact#">, 
                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Direccion_Fact#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varUcodigo#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varIETU#">,
				 10,
                 <cfqueryparam cfsqltype ="cf_sql_numeric" value="#varCEcodigo#">,
                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varUlogin#">,
                 <cfqueryparam cfsqltype="cf_sql_numeric" value="#varUcodigo#">)
			</cfquery>
			
			<!--- Seleccion de Detalles --->
			<cfquery name="rsDCompras" datasource="sifinterfaces">
				select Ecodigo, Id_Linea,  isnull(Precio_Unitario, 0) as Precio_Unitario, Cantidad, 
					Cod_Impuesto, Impuesto_Lin, Descuento_Lin, Tipo_Item, Total_Lin, Clas_Item, 
					Cod_Fabricante, Tipo_Lin, Cod_Item, Subtotal_Lin
				from DSIFLD_Facturas_Compra
				where ID_DocumentoC = #DocumentoFact#
			</cfquery>
			
			<cfset IDlinea = 1>
			<cfif isdefined("rsDCompras") and rsDCompras.recordcount GT 0>
			<cfloop query = "rsDCompras">
				<!--- Busca equivalencia de Impuesto en SIF --->
				<cfset Equiv = ConversionEquivalencia (rsECompras.Origen, 'IMPUESTO', rsDCompras.Ecodigo, rsDCompras.Cod_Impuesto, 'Cod_Impuesto')>
				<cfset varImpuesto = Equiv.EQUcodigoSIF>
				
				<!--- Cuenta de Almacen --->
				<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
					Oorigen="LDCM"
					Ecodigo="#varEcodigo#"  
					Conexion="#session.dsn#"
					LDOperacion="ALM"
					LDDepartamento="#rsDCompras.Tipo_Item#"
					LDClasificacion="#rsDCompras.Clas_Item#"
					LDFabricante="#rsDCompras.Cod_Fabricante#"
					LDTipoVenta="NOUSAR"
					SNegocios="#VarPrv.SNcodigo#"
					Impuestos="#varImpuesto#"
					Oficinas="#VarOcodigo#"		
					LDConceptoRetiroCaja=""
					Almacen="NOUSAR"
					Bancos="NOUSAR"
					LDCuentaBanco="NOUSAR"
					LDMovimientoInventario="NOUSAR"
					LDAlmacen="#rsECompras.Almacen#"
					LDTipoRetiroCaja="NOUSAR"
					>				
				</cfinvoke>          			
				<cfset CuentaLDCA = Cuenta>
	
				 <cfquery datasource="sifinterfaces">
					insert into SIFLD_ID10 
						(ID,Consecutivo, TipoItem, CodigoItem, NombreBarco, FechaHoraCarga, FechaHoraSalida, 
						PrecioUnitario,	CodigoUnidadMedida,CantidadTotal,CantidadNeta, CodEmbarque, 
						NumeroBOL, FechaBOL, TripNo, ContractNo, CodigoImpuesto, ImporteImpuesto, 
						ImporteDescuento, CodigoAlmacen, CodigoDepartamento, CentroFuncional,
						CuentaFinancieraDet, BMUsucodigo, PrecioTotal)
					values 
					(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDlinea#">, 
					 <cfqueryparam cfsqltype="cf_sql_char" value="#rsDCompras.Tipo_Lin#">,  
					 <cfqueryparam cfsqltype="cf_sql_char" value="#rsDCompras.Cod_Item#"> , 
					 ' ', getdate(), getdate(), 
					 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDCompras.Precio_Unitario,'9.99')#">,                 	 ' ', 
					 <cfqueryparam cfsqltype="cf_sql_float" value="#rsDCompras.Cantidad#">,
					 <cfqueryparam cfsqltype="cf_sql_float" value="#rsDCompras.Cantidad#">,
					 ' ', ' ', getdate(), ' ', ' ', 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varImpuesto#">, 
					 <cfif isdefined("varImpuesto") and len(varImpuesto) GT 0>
                     	null,
                     <cfelse>
                     	<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDCompras.Impuesto_Lin,'9.99')#">, 
                     </cfif>
					 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDCompras.Descuento_Lin,'9.99')#">,                 	 <cfif rsDCompras.Tipo_Lin EQ 'A'>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="rsECompras.Almacen">
					 <cfelse>
						null,
					 </cfif>
					 null,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">, 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDCA.CFformato#">, 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varUcodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDCompras.SubTotal_Lin,'9.99')#">)
				</cfquery>
				<cfset IDlinea = IDlinea + 1>
			</cfloop>
			</cfif> <!--- Detalles Ventas --->
			
			<!--- Marca o Borra las Tablas Origen Registro Procesado --->
			<!--- BORRADO DE TABLAS ORIGEN --->  
            <cfset stMemInfo = javaRT.totalMemory()-javaRT.freeMemory()>
        	<cfquery name="rsBorraDet_FactVen" datasource="sifinterfaces"> 
        		<cfif Parborrado>
					delete 	DSIFLD_Facturas_Compra where Id_DocumentoC = #DocumentoFact# 
    	        	delete	ESIFLD_Facturas_Compra where Id_DocumentoC = #DocumentoFact#     
				<cfelse>
					update ESIFLD_Facturas_Compra
					set Estatus = 92,
					ID10 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Maximus#">,
                    Fecha_Fin_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    ControlMem = #stMemInfo#,
                    Periodo = #Periodo#,
                    Mes = #Mes#
					where Id_DocumentoC = #DocumentoFact#
				</cfif>
        	</cfquery>    
		<cfcatch>
			<!--- Marca El registro con Error--->
			<cfquery datasource="sifinterfaces">
				update ESIFLD_Facturas_Compra
				set Estatus = 3,
                Fecha_Fin_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				where Id_DocumentoC = #DocumentoFact#
			</cfquery>
			<!--- Elimina Registros Insertados. Verifica si se grabo algo en las tablas --->
			<cfif isdefined("Maximus")>
				<cfquery datasource="sifinterfaces">
					delete SIFLD_ID10
					where ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
				</cfquery>
				<cfquery datasource="sifinterfaces">
					delete SIFLD_IE10
					where ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
				</cfquery>
			</cfif>
			
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
				values 
				('CP_Compras', 
				 'ESIFLD_Facturas_Compra',
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#DocumentoFact#">, 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,
                 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsECompras.Ecodigo#">,
                 null) 
			</cfquery>
		</cfcatch>
		</cftry>
		</cfloop> <!--- Encabezado de Compras --->
	        <cfquery name="rsVerifica" datasource="sifinterfaces">
            	select count(1) as Registros from ESIFLD_Facturas_Compra
                where Estatus in (99,10)
            </cfquery>
            <cfif rsVerifica.Registros LT 1>
        		<!---Se Dispara la Interfaz de forma Masiva--->
                <cftransaction action="begin">
                <cftry>
                	<!---Prepara los registros para ser insertados--->
                    <cfquery datasource="sifinterfaces">
                    	update SIFLD_IE10 
                        	set Interfaz = 'CP_Compras', Estatus = 1
                        where ID in (select ID10
                        			 from ESIFLD_Facturas_Compra
                                     where Estatus in (92))
                    </cfquery>
                	
                    <cfquery datasource="sifinterfaces">
                        insert into IE10
                            (ID, 
                             EcodigoSDC, 
                             NumeroSocio, 
                             Modulo, 
                             CodigoTransacion, 
                             Documento, 
                             Estado, 
                             CodigoMoneda, 
                             FechaDocumento, 
                             FechaVencimiento,
                             DiasVencimiento,
                             Facturado, 
                             Origen, 
                             VoucherNo, 
                             CodigoRetencion, 
                             CodigoOficina, 
                             CuentaFinanciera, 
                             CodigoConceptoServicio, 
                             CodigoDireccionEnvio, 
                             CodigoDireccionFact, 
                             FechaTipoCambio,
                             Dtipocambio,
                             BMUsucodigo, 
                             ConceptoCobroPago, 
                             StatusProceso)
                         select a.ID, a.EcodigoSDC, a.NumeroSocio, a.Modulo, a.CodigoTransacion, 
                             a.Documento, a.Estado, a.CodigoMoneda, a.FechaDocumento, a.FechaVencimiento,
                             a.DiasVencimiento, a.Facturado, a.Origen, a.VoucherNo, a.CodigoRetencion, 
                             a.CodigoOficina, a.CuentaFinanciera, a.CodigoConceptoServicio, 
                             a.CodigoDireccionEnvio, a.CodigoDireccionFact, 
                             a.FechaTipoCambio, a.Dtipocambio, a.BMUsucodigo, a.ConceptoCobroPago, a.StatusProceso
                         from SIFLD_IE10 a 
                         where Interfaz = 'CP_Compras' and Estatus = 1
                    </cfquery>
                    <cfquery datasource="sifinterfaces">
                        insert into ID10 
                                (ID,
                                 Consecutivo, 
                                 TipoItem, 
                                 CodigoItem, 
                                 NombreBarco, 
                                 FechaHoraCarga, 
                                 FechaHoraSalida, 
                                 PrecioUnitario,
                                 CodigoUnidadMedida,
                                 CantidadTotal,
                                 CantidadNeta, 
                                 CodEmbarque, 
                                 NumeroBOL, 
                                 FechaBOL, 
                                 TripNo, 
                                 ContractNo, 
                                 CodigoImpuesto, 
                                 ImporteImpuesto, 
                                 ImporteDescuento, 
                                 CodigoAlmacen, 
                                 CodigoDepartamento, 
                                 CentroFuncional,
                                 CuentaFinancieraDet, 
                                 BMUsucodigo, 
                                 PrecioTotal,
                                 DDdescripcion)
                        select a.ID, a.Consecutivo, a.TipoItem, a.CodigoItem, a.NombreBarco, 
                                 a.FechaHoraCarga, a.FechaHoraSalida, a.PrecioUnitario, a.CodigoUnidadMedida, a.CantidadTotal,
                                 a.CantidadNeta, a.CodEmbarque, a.NumeroBOL, a.FechaBOL, a.TripNo, 

                                 a.ContractNo, a.CodigoImpuesto, a.ImporteImpuesto, a.ImporteDescuento, a.CodigoAlmacen, 
                                 a.CodigoDepartamento, a.CentroFuncional, a.CuentaFinancieraDet, a.BMUsucodigo, 
                                 a.PrecioTotal, a.DDdescripcion
                        from SIFLD_ID10 a 
                        where exists (select 1 
                            			  from SIFLD_IE10 b
                                          where a.ID = b.ID and b.Interfaz = 'CP_Compras' and b.Estatus = 1)
                    </cfquery>
                    
                    <cfquery datasource="sifinterfaces">
                        insert into InterfazColaProcesos (
                            CEcodigo, NumeroInterfaz, IdProceso, SecReproceso,
                            EcodigoSDC, OrigenInterfaz, TipoProcesamiento, StatusProceso,
                            FechaInclusion, Cancelar, UsucodigoInclusion, UsuarioBdInclusion)
                        select
                          a.CEcodigo,
                          10,
                          ID,
                          0 as SecReproceso,
                          a.EcodigoSDC,
                          'E' as OrigenInterfaz,
                          'A' as TipoProcesamiento,
                          1 as StatusProceso,
                          <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,<!--- timestamp para que guarde fecha de proceso --->
                          0 as Cancelar,
                          a.Usucodigo,
                          a.Usulogin
                        from SIFLD_IE10 a 
                        where Interfaz = 'CP_Compras' and Estatus = 1
                    </cfquery>
                    
                    <cfquery datasource="sifinterfaces">
                        update ESIFLD_Facturas_Compra
                            set Estatus = 2
                        where Estatus in (92)
                        and ID10 in (select ID from SIFLD_IE10)
                    </cfquery>
                    
                    <cftransaction action="commit" />
                <cfcatch>
                    <cftransaction action="rollback" />
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
                        select 'CP_Compras', 'ESIFLD_Facturas_Compra', ID_DocumentoC,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,				 
                            Ecodigo,
                            Usuario
                        from ESIFLD_Facturas_Compra
                        where Estatus in (92)  
                        and ID10 in (select ID from SIFLD_IE10)
                    </cfquery>
                    <cfquery datasource="sifinterfaces">
                        update ESIFLD_Facturas_Compra set Estatus = 3
                        where Estatus in (92) 
                        and ID10 in (select ID from SIFLD_IE10)
                    </cfquery>
                </cfcatch>
                </cftry>
                </cftransaction>
                
                <cfquery datasource="sifinterfaces">
                    delete SIFLD_ID10
                    where ID in (select ID10 from ESIFLD_Facturas_Compra where Estatus in (2,3))
                </cfquery>
                <cfquery datasource="sifinterfaces">
                    delete SIFLD_IE10
                    where ID in (select ID10 from ESIFLD_Facturas_Compra where Estatus in (2,3))
                </cfquery>
            </cfif>
		</cfif>
	</cffunction>
</cfcomponent>


   
					
		
		