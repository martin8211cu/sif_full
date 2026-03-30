<!--- ABG: Integracion de Ventas PMI --->
<!--- La Integracion de Compra, procesa todas las ventas de producto FACT y NOFACT generando los documentos de CxC correspondientes --->
<!--- La Interfaz solo funciona con versiones de Coldfusion 8.0 en adelante --->
<!--- Elaboró: Maria de los Angeles Blanco López 03 de Noviembre del 2009--->
<!---Se Agrega el campo de Timbre Fiscal  para Contabilidad Electrónica  IRR Oct 2014  --->

<cfcomponent extends="Interfaz_Base">
	<cffunction name="Ejecuta" access="public" returntype="string" output="no">
    	<cfargument name="Disparo" required="no" type="boolean" default="false">
		<!--- Rutina para Obtener Parametros a Ocupar --->
		<cfset ParImp = true>
		<!--- Crear un Parametro Ver 2.0 --->
		<cfset ParBorrado = false>
		
		<!---Invocar al GC para liberar memoria--->
        <cfset javaRT = createobject("java","java.lang.Runtime").getRuntime()>
        <cfset javaRT.gc()><!--- invoca el GC --->
		
		<!---Actualiza los registros a Estatus en Proceso--->
		<cfif Application.dsinfo.sifinterfaces.type EQ "sybase">
			<cfquery name="rsActualiza" datasource="sifinterfaces" result="Rupdate">
				update top 50 ESIFLD_Facturas_Venta 
                set Estatus = 10 
                where 
                <cfif isdefined("Arguments.Disparo") and Arguments.Disparo>
                    Estatus = 1 
                    and not exists (select 1 from ESIFLD_Facturas_Venta where Estatus in (10, 11,94,92,99,100))
                <cfelse>    
                    Estatus = 99
                    and not exists (select 1 from ESIFLD_Facturas_Venta where Estatus in (10, 11))
                </cfif>
                and	Clas_Venta in ('PRFC', 'PRNF', 'PFFC', 'PFNC', 'PNFC', 'PNNC')
                <!--- and Tipo_Documento in ('FC','ND', 'NC', 'EC', 'DC')--->
			</cfquery>
		<cfelseif Application.dsinfo.sifinterfaces.type EQ "sqlserver">
			<cfquery name="rsActualiza" datasource="sifinterfaces" result="Rupdate">
				update top (50) ESIFLD_Facturas_Venta 
                set Estatus = 10 
                where 
                <cfif isdefined("Arguments.Disparo") and Arguments.Disparo>
                    Estatus = 1 
                    and not exists (select 1 from ESIFLD_Facturas_Venta where Estatus in (10, 11,94,92,99,100))
                <cfelse>    
                    Estatus = 99
                    and not exists (select 1 from ESIFLD_Facturas_Venta where Estatus in (10, 11))
                </cfif>
                and	Clas_Venta in ('PRFC', 'PRNF', 'PFFC', 'PFNC', 'PNFC', 'PNNC')
                <!--- and Tipo_Documento in ('FC','ND', 'NC', 'EC', 'DC')--->
			</cfquery>
        <cfelseif Application.dsinfo.sifinterfaces.type EQ "oracle">
			<cfthrow message="Base de datos #Application.dsinfo.sifinterfaces.type# no implementada">
        <cfelse>
        	<cfthrow message="Base de datos no reconocida">
		</cfif>
       
		<!--- toma registros cabecera de las Ventas --->
		<cfquery name="rsIDEVentas" datasource="sifinterfaces">
			select ID_DocumentoV
			from ESIFLD_Facturas_Venta
			where 				
				Clas_Venta in ('PRFC', 'PRNF', 'PFFC', 'PFNC', 'PNFC', 'PNNC')
				and Estatus = 10  
				<!--- Si se quiere basar la logica en el tipo de documento utilizar esta linea 
				(Tipo_Documento in ('FC','ND', 'NC', 'EC', 'DC'))--->
			<cfif Rupdate.recordcount EQ 0>
	            and 1 = 2
            </cfif> 
		</cfquery>
		
	  	<cfif isdefined("rsIDEVentas") AND rsIDEVentas.recordcount GT 0>
        <cfloop query="rsIDEVentas">
        <cfsilent>
		<cftry>
			<!--- toma registros cabecera de las Ventas --->
            <cfquery name="rsEVentas" datasource="sifinterfaces">
                select Ecodigo, Origen, ID_DocumentoV, Tipo_Documento, Fecha_Venta, Fecha_Vencimiento, Contrato,
                    Numero_Documento, Cliente, Sucursal, Moneda, Fecha_Tipo_Cambio, Tipo_Cambio,
                    Retencion, Clas_Venta, Origen_Venta, Usuario, TimbreFiscal
                from ESIFLD_Facturas_Venta
                where 				
                    ID_DocumentoV = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIDEVentas.ID_DocumentoV#">
            </cfquery>
			<cfset DocumentoFact = rsEVentas.Id_DocumentoV>
			
            <cfquery datasource="sifinterfaces">
                update ESIFLD_Facturas_Venta
                set Fecha_Inicio_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                where ID_DocumentoV = #DocumentoFact# 
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
			<cfset varEcodigo = ConversionEquivalencia (rsEVentas.Origen, 'CADENA', rsEVentas.Ecodigo, rsEVentas.Ecodigo, 'Cadena')>
			<cfset session.dsn = getConexion(varEcodigo.EQUidSIF)>
			
			 <!--- MONEDA --->
			<cfset varMoneda = ConversionEquivalencia (rsEVentas.Origen, 'MONEDA', rsEVentas.Ecodigo, rsEVentas.Moneda, 'Moneda')>
			
			<!---OFICINA --->
            <cfset VarOficina = ConversionEquivalencia (rsEVentas.Origen, 'SUCURSAL', rsEVentas.Ecodigo, rsEVentas.Sucursal, 'Sucursal')>
			
            <!--- , 'CLIENTE', 'ECODIGO' --->
	         <cfset VarCli = ExtraeCliente(rsEVentas.Cliente, varEcodigo.EQUidSIF,"C","S")>  
			 
			 <!---Tipo de Contraparte --->
			 <cfset varCEcodigo = getCEcodigo(varEcodigo.EQUidSIF)>
			 
			<cfquery name="rsContraparte" datasource="#session.dsn#">
				select sn.SNcodigo, snd.SNCDdescripcion from 
				SNClasificacionSN csn
				inner join SNegocios sn	on csn.SNid = sn.SNid 
				and sn.Ecodigo = <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">
				and sn.SNcodigo = <cfqueryparam cfsqltype ="cf_sql_integer" value="#VarCli.SNcodigo#"> 
				inner join SNClasificacionD snd
		        inner join SNClasificacionE sne on snd.SNCEid = sne.SNCEid
	 	        and sne.CEcodigo = <cfqueryparam cfsqltype ="cf_sql_integer" value="#varCEcodigo#">
		        and SNCEcodigo like 'SN-001' on csn.SNCDid = snd.SNCDid
			</cfquery>
			
			<cfif isdefined("rsContraparte") and rsContraparte.recordcount GT 0>
				<cfset varContraParte = rsContraparte.SNCDdescripcion>
			<cfelse>
				<cfthrow message="El Socio de Negocio #rsEVentas.Cliente# no tiene asignado un valor para su contraparte">
			</cfif>
			<!---Origen Socio --->
			<cfset varCEcodigo = getCEcodigo(varEcodigo.EQUidSIF)>
			<cfquery name="rsSN002" datasource="#session.dsn#">
            	select count(SNCEcodigo) as existe from SNClasificacionE
                where SNCEcodigo ='SN-002'
                and PCCEactivo=1
            </cfquery>
            <cfif isdefined("rsSN002") and rsSN002.existe EQ 1>			
                <cfquery name="rsOrigenSocio" datasource="#session.dsn#">
                    select sn.SNcodigo, snd.SNCDdescripcion from 
                    SNClasificacionSN csn
                    inner join SNegocios sn	on csn.SNid = sn.SNid 
                    and sn.Ecodigo = <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">
                    and sn.SNcodigo = <cfqueryparam cfsqltype ="cf_sql_integer" value="#VarCli.SNcodigo#"> 
                    inner join SNClasificacionD snd
                    inner join SNClasificacionE sne on snd.SNCEid = sne.SNCEid
                    and sne.CEcodigo = <cfqueryparam cfsqltype ="cf_sql_integer" value="#varCEcodigo#">
                    and SNCEcodigo like 'SN-002' on csn.SNCDid = snd.SNCDid
                </cfquery>
                <cfif isdefined("rsOrigenSocio") and rsOrigenSocio.recordcount GT 0>
                    <cfset varOrigenSocio = rsOrigenSocio.SNCDdescripcion>
                <cfelse>
                    <cfthrow message="El Socio de Negocio #rsECompras.Proveedor# no tiene asignado un valor de Origen del Socio">
                </cfif>
            <cfelse>    
            	<cfset varOrigenSocio = "NA">
            </cfif>    
            <!---Region Socio --->
			<cfset varCEcodigo = getCEcodigo(varEcodigo.EQUidSIF)>
			<cfquery name="rsSN003" datasource="#session.dsn#">
            	select count(SNCEcodigo) as existe from SNClasificacionE
                where SNCEcodigo ='SN-003'
                and PCCEactivo=1
            </cfquery>
            <cfif isdefined("rsSN003") and rsSN003.existe EQ 1>
            	<cfquery name="rsRegionSocio" datasource="#session.dsn#">
                    select sn.SNcodigo, snd.SNCDdescripcion from 
                    SNClasificacionSN csn
                    inner join SNegocios sn	on csn.SNid = sn.SNid 
                    and sn.Ecodigo = <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">
                    and sn.SNcodigo = <cfqueryparam cfsqltype ="cf_sql_integer" value="#VarCli.SNcodigo#"> 
                    inner join SNClasificacionD snd
                    inner join SNClasificacionE sne on snd.SNCEid = sne.SNCEid
                    and sne.CEcodigo = <cfqueryparam cfsqltype ="cf_sql_integer" value="#varCEcodigo#">
                    and SNCEcodigo like 'SN-003' on csn.SNCDid = snd.SNCDid
                </cfquery>                
                <cfif isdefined("rsRegionSocio") and rsRegionSocio.recordcount GT 0>
                    <cfset varRegionSocio = rsRegionSocio.SNCDdescripcion>
                <cfelse>
                    <cfthrow message="El Socio de Negocio #rsECompras.Proveedor# no tiene asignado un valor de Region del Socio">
                </cfif>
            <cfelse>    
            	<cfset varRegionSocio = "NA">
            </cfif>			 
			 <!---Usuario --->
			 <cfset UsuInterfaz = UInterfaz(getCEcodigo(varEcodigo.EQUidSIF), rsEVentas.Usuario)>	
			
			<!---RETENCION--->
			<cfif isdefined("rsEVentas.Retencion") and trim(rsEVentas.Retencion) NEQ "">
				<cfset Equiv = ConversionEquivalencia (rsEVentas.Origen, 'RETENCION', rsEVentas.Ecodigo, rsEVentas.Retencion, 	                 'Retencion')>     
				<cfset VarRetencion = Equiv.EQUcodigoSIF>
			</cfif>
			
            <!--- Busca la Moneda Local para la empresa --->
            <cfquery name="rsMonedaL" datasource="#session.dsn#">	
                select m.Miso4217
                from Monedas m
	                inner join Empresas e
    	            on m.Ecodigo = e.Ecodigo
        	        and m.Mcodigo = e.Mcodigo
            	    and e.Ecodigo = <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">
            </cfquery>
            <cfif rsMonedaL.recordcount EQ 1 AND len(rsMonedaL.Miso4217) GT 0>
            	<cfset varMonedaL = rsMonedaL.Miso4217>
            <cfelse>
            	<cfthrow message="Imposible obtener la moneda local para la empresa">
            </cfif>
            	
            
			<!---Ver si existe el tipo de cambio para la fecha indicada --->
			<cfif varMoneda.EQUcodigoSIF NEQ varMonedaL>
				<cfset varTipoCambio = ExtraeTipoCambio(varMoneda.EQUcodigoSIF,varEcodigo.EQUidSIF,rsEVentas.Fecha_Tipo_Cambio)>
			</cfif> 
			 						
			<!--- Insercion de cabecera en IE10 --->
			<cfquery datasource="sifinterfaces">
				insert into SIFLD_IE10
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
					 StatusProceso,
                     CEcodigo,
                     Usulogin,
                     Usucodigo,
                     TimbreFiscal)
				values 
				(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
				 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUcodigoSIF#">, 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEVentas.Cliente#">,
				 'CC',
				 <cfqueryparam cfsqltype="cf_sql_char" value="#rsEVentas.Tipo_Documento#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEVentas.Numero_Documento#">,
				 null, 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda.EQUcodigoSIF#">,
				 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta,'yyyy/mm/dd')#">, 
				 <cfif isdefined("rsEVentas.Fecha_Vencimiento") and trim(rsEVentas.Fecha_Vencimiento) NEQ "">
				 	<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Vencimiento,'yyyy/mm/dd')#">,  
				 <cfelse>
				 	<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta,'yyyy/mm/dd')#">,  
				 </cfif>
				 0, 
				 'S', 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEVentas.Origen#">,
				 '0', 
				 <cfif isdefined("rsEVentas.Retencion") and trim(rsEVentas.Retencion) EQ "">
				 	null,
				 <cfelse>
				 	<cfqueryparam cfsqltype="cf_sql_char" value="#VarRetencion#">,
				 </cfif> 
				 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficina.EQUcodigoSIF#">,
				 null, 
				 null, 
				 null, 
				 null,
                 <cfqueryparam cfsqltype="cf_sql_date" value="#rsEVentas.Fecha_Tipo_Cambio#">,
                 <cfif isdefined(rsEVentas.Tipo_Cambio) and rsEVentas.Tipo_Cambio NEQ	'' >				 
	                <cfqueryparam cfsqltype="cf_sql_float" value="#rsEVentas.Tipo_Cambio#">, <!---Controla los nulos en campo float--->			 
                 <cfelse>
					 null,
				 </cfif>
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#UsuInterfaz.Usucodigo#">,
				 null,
				 1,
                 <cfqueryparam cfsqltype ="cf_sql_numeric" value="#varCEcodigo#">,
                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#UsuInterfaz.Usulogin#">,
                 <cfqueryparam cfsqltype="cf_sql_integer" value="#UsuInterfaz.Usucodigo#">,
                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEVentas.TimbreFiscal#">)
			</cfquery>
			
			<!--- Seleccion de Detalles --->
			<cfquery name="rsDVentas" datasource="sifinterfaces">
				select Ecodigo, ID_linea, Tipo_Lin, Tipo_Item, Clas_Item, Cod_Item, Cod_Impuesto, Cantidad,
				       isnull(Precio_Unitario, 0) as Precio_Unitario, isnull(Descuento_Lin, 0) as Descuento_Lin, 
					   isnull (Subtotal_Lin, 0) as Subtotal_Lin, isnull(Impuesto_Lin, 0) as Impuesto_Lin, 
					   isnull(Total_Lin, 0) as Total_Lin, Clas_Venta_Lin, Origen_Venta_Lin, Contrato_Lin,
                       CFuncional   
				from DSIFLD_Facturas_Venta
				where ID_DocumentoV = #DocumentoFact#
			</cfquery>
			
			<cfset IDlinea = 1>
			<cfif isdefined("rsDVentas") and rsDVentas.recordcount GT 0>
			<cfloop query = "rsDVentas">
            <cfsilent>
				<!--- Busca equivalencia de Impuesto en SIF --->
				<cfset VarImpuesto = ConversionEquivalencia (rsEVentas.Origen, 'IMPUESTO', rsDVentas.Ecodigo, 
				rsDVentas.Cod_Impuesto, 'Cod_Impuesto')>
				
                <!--- CENTRO FUNCIONAL--->
				<cfif rsDVentas.CFuncional NEQ "" and len(rsDVentas.CFuncional) GT 0>
					<cfset varCF = ConversionEquivalencia (rsEVentas.Origen, 'CENTRO_FUN', rsEVentas.Ecodigo, rsDVentas.CFuncional,
				'Centro_Funcional')>
                <cfelse>
                	<cfquery name="rsCF" datasource="#session.dsn#">
                    	select isnull(CFid,0) as CFid 
                        from CFuncional 
                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo.EQUidSIF#">
                        and CFcodigo like 'RAIZ'
                    </cfquery>
                	<cfset varCF = StructNew()>
					<cfset varCF.EQUcodigoSIF = "RAIZ">
                    <cfset varCF.EQUidSIF = rsCF.CFid>
                </cfif>
                
				<!--- , 'CONCEPTO SERVICIO' --->
				<cfset VarConcepServicio = ExtraeConceptoServicio(rsDVentas.Cod_Item, varEcodigo.EQUidSIF)>
				<cfset VarCodigoServicio = VarConcepServicio.Cid>
				
                <!---ABG: Rutina para IETU --->
                <!--- Valida parametro para verificar si aplica IETU a la empresa --->
                <!--- Obtiene los parametros --->
				<cftry>
					<cfset IETU = Parametros(Ecodigo=varEcodigo.EQUidSIF,Pcodigo=110,Parametro="Aplicación de IETU",ExtBusqueda=true, Sistema = rsEVentas.Origen)>
                <cfcatch>
                	<cfset IETU = 0>
                </cfcatch>
                </cftry>
                <cfif IETU EQ 1>
					<cfset VarIETU = ConversionEquivalencia (rsEVentas.Origen, 'IETU', rsDVentas.Ecodigo, rsDVentas.Cod_Item, 'Cod_Item')>
					<!--- Verifica el Concepto Cobro Pago, Si tiene IETU actualiza el encabezado --->
                    <cfquery name="rsIETU" datasource="#session.dsn#">
                    	select 1 
                        from TESRPTconcepto a
                        inner join TESRPTCietu b
                        on a.TESRPTCid=b.TESRPTCid
                        and a.TESRPTCcxc = 1
                        and a.TESRPTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varIETU.EQUidSIF#">
                        and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo.EQUidSIF#">
                    </cfquery>
                    
                    <cfif rsIETU.recordcount GT 0>
                    	<!--- Actualiza el concepto de Pago --->
                        <cfquery datasource="sifinterfaces">
                        	update SIFLD_IE10
                            set ConceptoCobroPago = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varIETU.EQUcodigoSIF#">
                            where ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
                        </cfquery>
                    </cfif>
                </cfif>
                
				<!---Validar Importes Negativos--->
				<cfif rsDVentas.Subtotal_Lin LT 0 or rsDVentas.Impuesto_Lin LT 0 or rsDVentas.Total_Lin LT 0 or 
				rsDVentas.Descuento_Lin LT 0>
					<cfthrow message="El documento contiene valores negativos, no pueden ser procesados valores negativos">
				</cfif>		
			
				<!--- Cuenta de Resultados --->
				<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
					Oorigen="PMIV"
					Ecodigo="#varEcodigo.EQUidSIF#" 
					Conexion="#session.dsn#"
					CConceptos="#rsDVentas.Clas_Item#"
                    PMI_Cmdty_Padre="#rsDVentas.Clas_Item#"
					Conceptos="#VarCodigoServicio#"
					Oficinas="#varOficina.EQUidSIF#"
					SNegocios="#VarCli.SNcodigo#"
					CCTransacciones="#rsEVentas.Tipo_Documento#"
					Impuestos="#varImpuesto.EQUidSIF#"
                    CFuncional="#varCF.EQUidSIF#"
					PMI_Clas_Venta="#rsEVentas.Clas_Venta#"
					PMI_Clas_Venta_Lin="#rsDVentas.Clas_Venta_Lin#"
					PMI_Origen_Venta_Lin="#rsDVentas.Origen_Venta_Lin#"
					PMI_Origen_Venta="NA"
					PMI_Linea_Negocio="#rsDVentas.Tipo_Item#"
					PMI_Orden_Comercial="#rsEVentas.Contrato#"
					PMI_Tipo_Contraparte="#varContraparte#"
                    PMI_Origen_Socio="#varOrigenSocio#"
                    PMI_Region_Socio="#varRegionSocio#"
					>				
				</cfinvoke>          			
				<cfset Cuenta = Cuenta>
	
				 <cfquery datasource="sifinterfaces">
					insert into SIFLD_ID10
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
					values 
					(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
					 <cfqueryparam cfsqltype="cf_sql_char" value="#rsDVentas.Tipo_Lin#">,  
					 <cfqueryparam cfsqltype="cf_sql_char" value="#rsDVentas.Cod_Item#">, 				 
					 ' ',
					 getdate(), 
					 getdate(), 
					 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Precio_Unitario,'9.99')#">,                 	 					                     ' ', 
					 round(#rsDVentas.Cantidad#, 5),
					 round(#rsDVentas.Cantidad#, 5),
					 ' ',
					 ' ', 
					 getdate(), 
					 ' ', 
					 ' ', 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varImpuesto.EQUcodigoSIF#">, 
					 <cfif rsDVentas.Impuesto_Lin GT 0>
						 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Impuesto_Lin,'9.99')#">,
					 <cfelse>
					 	 null,
					 </cfif>
					 null,
					 null,
					 null,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF.EQUcodigoSIF#">, 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Cuenta.CFformato#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#UsuInterfaz.Usucodigo#">,
					 round(#rsDVentas.Total_Lin#,2),
					 'OC-O.#rsDVentas.Contrato_Lin#.#rsDVentas.Cod_Item#')
				</cfquery>
				<cfset IDlinea = IDlinea + 1>
			</cfsilent>
            </cfloop>
			</cfif> <!--- Detalles Ventas --->
			
			<!--- Marca o Borra las Tablas Origen Registro Procesado --->
			<!--- BORRADO DE TABLAS ORIGEN --->  
            <cfset stMemInfo = javaRT.totalMemory()-javaRT.freeMemory()>
        	<cfquery datasource="sifinterfaces">
        		<cfif Parborrado>
					delete 	DSIFLD_Facturas_Venta where ID_DocumentoV = #DocumentoFact# 
    	        	delete	ESIFLD_Facturas_Venta where ID_DocumentoV = #DocumentoFact#     
				<cfelse>
					update ESIFLD_Facturas_Venta
					set Estatus = 92, ID10 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Maximus#">,
                        Fecha_Fin_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						ControlMem = #stMemInfo#
					where ID_DocumentoV = #DocumentoFact# 
				</cfif>					
			</cfquery>

			 <cfset rsContraparte = javacast("null","")>
			 <cfset rsDVentas = javacast("null","")>
             <cfset rsEVentas = javacast("null","")>
	         <cfset javaRT.gc()><!--- invoca el GC --->
			
		<cfcatch>
			
			<!--- Marca El registro con Error--->
			<cfquery datasource="sifinterfaces">
				update ESIFLD_Facturas_Venta
				set Estatus = 3, 
                Fecha_Fin_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				where ID_DocumentoV = #DocumentoFact#
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
				('CC_Ventas', 
				 'ESIFLD_Facturas_Venta',
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#DocumentoFact#">, 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,
    			 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEVentas.Ecodigo#">,
                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEVentas.Usuario#">) 
			</cfquery>
		</cfcatch>
		</cftry>
        </cfsilent>
		</cfloop> <!--- Encabezado de Ventas --->
        	<cfquery name="rsVerifica" datasource="sifinterfaces">
            	select count(1) as Registros from ESIFLD_Facturas_Venta
                where Estatus in (99,10)
            </cfquery>
            <cfif rsVerifica.Registros LT 1>
				<!---Se Dispara la Interfaz de forma Masiva--->
                <cftransaction action="begin">
                <cftry>
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
                             StatusProceso,
                             TimbreFiscal)
                         select a.ID, a.EcodigoSDC, a.NumeroSocio, a.Modulo, a.CodigoTransacion, 
                             a.Documento, a.Estado, a.CodigoMoneda, a.FechaDocumento, a.FechaVencimiento,
                             a.DiasVencimiento, a.Facturado, a.Origen, a.VoucherNo, a.CodigoRetencion, 
                             a.CodigoOficina, a.CuentaFinanciera, a.CodigoConceptoServicio, 
                             a.CodigoDireccionEnvio, a.CodigoDireccionFact, 
                             a.FechaTipoCambio, a.Dtipocambio, a.BMUsucodigo, a.ConceptoCobroPago, a.StatusProceso, a.TimbreFiscal
                         from SIFLD_IE10 a 
                         where exists (select 1 from ESIFLD_Facturas_Venta b where a.ID = b.ID10 and b.Estatus in (92))
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
                        select ID, Consecutivo, TipoItem, CodigoItem, NombreBarco, 
                                 FechaHoraCarga, FechaHoraSalida, PrecioUnitario, CodigoUnidadMedida, CantidadTotal,
                                 CantidadNeta, CodEmbarque, NumeroBOL, FechaBOL, TripNo, 
                                 ContractNo, CodigoImpuesto, ImporteImpuesto, ImporteDescuento, CodigoAlmacen, 
                                 CodigoDepartamento, CentroFuncional, CuentaFinancieraDet, BMUsucodigo, 
                                 PrecioTotal, DDdescripcion
                        from SIFLD_ID10 a 
                        where exists (select 1 from ESIFLD_Facturas_Venta b where a.ID = b.ID10 and b.Estatus in (92))
                    </cfquery>
                    
                    <cfquery datasource="sifinterfaces">
                        insert into InterfazColaProcesos (
                            CEcodigo, NumeroInterfaz, IdProceso, SecReproceso,
                            EcodigoSDC, OrigenInterfaz, TipoProcesamiento, StatusProceso,
                            FechaInclusion, UsucodigoInclusion, UsuarioBdInclusion, Cancelar)
                        select
                          CEcodigo,
                          10,
    
                          ID,
                          0 as SecReproceso,
                          EcodigoSDC,
                          'E' as OrigenInterfaz,
                          'A' as TipoProcesamiento,
                          1 as StatusProceso,
                          <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,<!--- timestamp para que guarde fecha de proceso --->
                          Usucodigo,
                          Usulogin,
                          0 as Cancelar
                        from SIFLD_IE10 a 
                        where exists (select 1 from ESIFLD_Facturas_Venta b where a.ID = b.ID10 and b.Estatus in (92))
                    </cfquery>
                    
                    <cfquery datasource="sifinterfaces">
                        update ESIFLD_Facturas_Venta
                            set Estatus = 2
                        where Estatus = 92
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
                        select 'CC_Ventas', 'ESIFLD_Facturas_Venta', ID_DocumentoV,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,				 
                            Ecodigo,
                            Usuario
                        from ESIFLD_Facturas_Venta
                        where Estatus = 92  
                        and ID10 in (select ID from SIFLD_IE10)
                    </cfquery>
                    <cfquery datasource="sifinterfaces">
                        update ESIFLD_Facturas_Venta set Estatus = 3
                        where Estatus = 92
                        and ID10 in (select ID from SIFLD_IE10)
                    </cfquery>
                </cfcatch>
                </cftry>
                </cftransaction>
                <cfquery datasource="sifinterfaces">
                    delete SIFLD_ID10
                    where ID in (select ID10 from ESIFLD_Facturas_Venta where Estatus in (2,3))
                </cfquery>
                <cfquery datasource="sifinterfaces">
                    delete SIFLD_IE10
                    where ID in (select ID10 from ESIFLD_Facturas_Venta where Estatus in (2,3))
                </cfquery>
            </cfif>
		</cfif>
	</cffunction>
</cfcomponent>