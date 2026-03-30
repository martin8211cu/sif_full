<!--- ABG: Polizas Contables PMI --->
<!--- Polizas contables genera las polizas correspondientes a los movimientos que afectan el Costo de Ventas--->
<!--- La Interfaz solo funciona con versiones de Coldfusion 8.0 en adelante --->
<!--- Elaboró:Maria de los Angeles Blanco López 26 de Octubre del 2009--->


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
				update top 50 ESIFLD_Facturas_Compra 
                set Estatus = 11 
                where 			
                <cfif isdefined("Arguments.Disparo") and Arguments.Disparo>
                    Estatus = 4
                    <!---Tipo_Documento in ('FC','ND', 'NC', 'EC', 'DC') --->
                    and not exists (select 1 from ESIFLD_Facturas_Compra where Estatus in (10, 11,94,92,99,100))
                <cfelse>
                    Estatus = 100
                    <!---Tipo_Documento in ('FC','ND', 'NC', 'EC', 'DC') --->
                    and not exists (select 1 from ESIFLD_Facturas_Compra where Estatus in (10, 11))
                </cfif>
			</cfquery>
		<cfelseif Application.dsinfo.sifinterfaces.type EQ "sqlserver">
			<cfquery name="rsActualiza" datasource="sifinterfaces" result="Rupdate">
				update top (50) ESIFLD_Facturas_Compra 
                set Estatus = 11 
                where 			
                <cfif isdefined("Arguments.Disparo") and Arguments.Disparo>
                    Estatus = 4
                    <!---Tipo_Documento in ('FC','ND', 'NC', 'EC', 'DC') --->
                    and not exists (select 1 from ESIFLD_Facturas_Compra where Estatus in (10, 11,94,92,99,100))
                <cfelse>
                    Estatus = 100
                    <!---Tipo_Documento in ('FC','ND', 'NC', 'EC', 'DC') --->
                    and not exists (select 1 from ESIFLD_Facturas_Compra where Estatus in (10, 11))
                </cfif>
			</cfquery>
		<cfelseif Application.dsinfo.sifinterfaces.type EQ "oracle">
			<cfthrow message="Base de datos #Application.dsinfo.sifinterfaces.type# no implementada">
        <cfelse>
        	<cfthrow message="Base de datos no reconocida">
		</cfif>
        
		<!--- Toma registros cabecera de las Compras --->
		<cfquery name="rsIDECompras" datasource="sifinterfaces">
			select ID_DocumentoC
			from ESIFLD_Facturas_Compra
			where 
				Estatus = 11  
            <cfif Rupdate.recordcount EQ 0>
	            and 1 = 2
            </cfif> 
		</cfquery>
	  	<cfif isdefined("rsIDECompras") AND rsIDECompras.recordcount GT 0>
        <cfloop query="rsIDECompras">
        <cfsilent>
		<cftry>
        	<!--- Toma registros cabecera de las Compras --->
            <cfquery name="rsECompras" datasource="sifinterfaces">
                select Ecodigo, Origen, ID_DocumentoC, Tipo_Documento, Fecha_Compra, Fecha_Arribo, Contrato,
                    Numero_Documento,  Proveedor, Sucursal, Moneda, Fecha_Tipo_Cambio, Tipo_Cambio, 
                    Retencion, Almacen,  Clas_Compra, Dest_Compra, Usuario 
                from ESIFLD_Facturas_Compra
                where 
                   ID_DocumentoC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIDECompras.ID_DocumentoC#">
            </cfquery>
			<cfset DocumentoFact = rsECompras.ID_DocumentoC>
			<cfset varBorraRegistro = false>
            
            <!---BUSCA EQUIVALENCIAS--->
			<!--- EMPRESAS --->
			<cfset varEcodigo = ConversionEquivalencia (rsECompras.Origen, 'CADENA', rsECompras.Ecodigo, rsECompras.Ecodigo, 'Cadena')>
            
			<!---Verifica si debe insertar encabezado o no --->
			<cfquery name="rsVerificaE" datasource="sifinterfaces">
				select ID, Ecodigo, EcodigoSDC, Empresa, 
                	Usuario, Proveedor, Tipo_Documento
				from SIFLD_IE18
				where Empresa = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsECompras.Ecodigo#">
				and Tipo_Documento like <cfqueryparam cfsqltype="cf_sql_char" value="#trim(rsECompras.Tipo_Documento)#">
                and Usuario like <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsECompras.Usuario)#">
			</cfquery>	
            
            <cfif rsVerificaE.recordcount GT 0>
	            <cfset Maximus = rsVerificaE.ID>
                <cfquery name="rsLinea" datasource="sifinterfaces">
					select isnull(max(DCIconsecutivo),0) + 1 as Linea
					from SIFLD_ID18
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo.EQUidSIF#">
					and ID = <cfqueryparam cfsqltype ="cf_sql_integer" value="#rsVerificaE.ID#">
				</cfquery>
				<cfset IDlinea = rsLinea.Linea>
				<cfset IDStart = IDlinea - 1>
            <cfelse>
				<!--- Extrae Maximo+1 de tabla IE18 para insertar nuevo reg, en IE18 --->                      
                <cfset RsMaximo = ExtraeMaximo("IE18","ID")>
                <cfif isdefined(#RsMaximo.Maximo#) or #RsMaximo.Maximo# gt 0>
                    <cfset Maximus = #RsMaximo.Maximo#>
                <cfelse>
                    <cfset Maximus = 1>
                </cfif>
                <cfset varBorraRegistro = true>
                <cfset IDlinea = 1>
            </cfif>
			
			<cfset session.dsn = getConexion(varEcodigo.EQUidSIF)>
			
			<!---OFICINA --->
	      <cfset VarOficina = ConversionEquivalencia (rsECompras.Origen, 'SUCURSAL', rsECompras.Ecodigo, rsECompras.Sucursal, 'Sucursal')>
			
			 <!--- MONEDA --->
			<cfset varMoneda = ConversionEquivalencia (rsECompras.Origen, 'MONEDA', rsECompras.Ecodigo, rsECompras.Moneda, 'Moneda')>
			
			 <!--- , 'PROVEEDOR', 'ECODIGO' --->
	         <cfset VarPrv = ExtraeCliente(rsECompras.Proveedor, varEcodigo.EQUidSIF,"P","S")>  
		
			<!---Tipo de Contraparte --->
			<cfset varCEcodigo = getCEcodigo(varEcodigo.EQUidSIF)>
			
			<cfquery name="rsContraparte" datasource="#session.dsn#">
				select sn.SNcodigo, snd.SNCDdescripcion from 
				SNClasificacionSN csn
				inner join SNegocios sn	on csn.SNid = sn.SNid 
				and sn.Ecodigo = <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">
				and sn.SNcodigo =<cfqueryparam cfsqltype ="cf_sql_integer" value="#VarPrv.SNcodigo#"> 
				inner join SNClasificacionD snd
		        inner join SNClasificacionE sne on snd.SNCEid = sne.SNCEid
	 	        and sne.CEcodigo = <cfqueryparam cfsqltype ="cf_sql_integer" value="#varCEcodigo#">
		        and SNCEcodigo like 'SN-001' on csn.SNCDid = snd.SNCDid
			</cfquery>
			
			<cfif isdefined("rsContraparte") and rsContraparte.recordcount GT 0>
				<cfset varContraParte = rsContraparte.SNCDdescripcion>
			<cfelse>
				<cfthrow message="El Socio de Negocio #rsECompras.Proveedor# no tiene asignado un valor para su contraparte">
			</cfif>
			
			<!---Usuario --->
			<cfset UsuInterfaz = UInterfaz(getCEcodigo(varEcodigo.EQUidSIF), rsECompras.Usuario)>	
			
			<!--- Busca Moneda Local SIF ---> 
			<cfquery name="rsMonedaL" datasource="#session.dsn#">
				select e.Ecodigo, m.Mnombre, m.Miso4217, e.Edescripcion
				from Monedas m
					inner join Empresas e
					on m.Ecodigo = e.Ecodigo and m.Mcodigo = e.Mcodigo
				where e.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo.EQUidSIF#"> 
			
			</cfquery>
			<cfif isdefined("rsMonedaL") and rsMonedaL.recordcount EQ 1>
				<cfset varMonedaL = rsMonedaL.Miso4217>
			<cfelse>
				<cfthrow message="Error al Obtener la Moneda Local de la empresa: #rsECompras.Ecodigo#">
			</cfif>	
			
			<!--- Busca Periodo en Minisif --->
			<cfquery name="BuscaPeriodo" datasource="#session.dsn#">
				select Pvalor from Parametros where Ecodigo = #varEcodigo.EQUidSIF# AND Pcodigo = 50
			</cfquery>
			<cfset Periodo = #BuscaPeriodo.Pvalor#>
			
			<!--- Busca Mes en Minisif --->
			<cfquery name="BuscaMes" datasource="#session.dsn#">
				select Pvalor from Parametros where Ecodigo = #varEcodigo.EQUidSIF# AND Pcodigo = 60
			</cfquery>
			<cfset Mes = #BuscaMes.Pvalor#>
			
			<!---Tipo de cambio y codigo moneda del Dolar---> 
			<cfset varTipoCambioD = ExtraeTipoCambio('USD',varEcodigo.EQUidSIF,rsECompras.Fecha_Tipo_Cambio)>
			<cfset varMonedaD = ConversionEquivalencia (rsECompras.Origen, 'MONEDA', rsECompras.Ecodigo,'USD','Moneda')>
				
			<!---Tipo cambio para la moneda origen --->
			<!---Verificar que valor va a  devolver el llamado a la Equivalencia --->
			<cfif varMoneda.EQUcodigoSIF NEQ 'MXP'>
				<cfset varTipoCambio = ExtraeTipoCambio(varMoneda.EQUcodigoSIF,varEcodigo.EQUidSIF,rsECompras.Fecha_Tipo_Cambio)>
			</cfif> 
			
			<!---Obtener el numero de socio--->
			<cfquery name="rsSNnumero" datasource="#session.dsn#">
				select SNnumero
				from SNegocios 
				where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo.EQUidSIF#"> 
				and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#VarPrv.SNcodigo#"> 
			
			</cfquery>
			<cfif isdefined("rsSNnumero") and rsSNnumero.recordcount EQ 1>
				<cfset varSNnumero = rsSNnumero.SNnumero>
			<cfelse>
				<cfthrow message="El socio #VarPrv.SNcodigo# no tiene un numero de socio asignado">
			</cfif>	
			
            <cfif rsVerificaE.recordcount LTE 0>
				<!--- Insercion de cabecera en IE18 --->
                <cfquery datasource="sifinterfaces">
                    insert into SIFLD_IE18 
                        (ID, 
                        Ecodigo, 
                        Cconcepto, 
                        Eperiodo, 
                        Emes, 
                        Efecha,
                        Edescripcion, 
                        Edocbase, 
                        Ereferencia, 
                        Falta, 
                        Usuario,
                        ECIreversible,
                        EcodigoSDC,
                        Empresa,
                        CEcodigo,
                        Usulogin,
                        Usucodigo,
                        Proveedor,
                        Tipo_Documento)
                    values(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
                        <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">, 	
                        20,
                        <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
                        <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsECompras.Fecha_Compra,'yyyy/mm/dd')#">,
                        <cfif isdefined("rsECompras.Contrato") and trim(rsECompras.Contrato) NEQ ""> 
                        	<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Contrato#">,
                        <cfelse>
                        	<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Numero_Documento#">,												
                        </cfif>
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Numero_Documento#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Tipo_Documento#">,
                        getdate(),
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#UsuInterfaz.Usulogin#">,
                        <cfif isdefined("rsECompras.Clas_Compra") and trim(rsECompras.Clas_Compra) EQ 'PRNF' or 
                        trim(rsECompras.Clas_Compra) EQ 'GANF'>	
                        	1,
                        <cfelse>
                        	0,
                        </cfif>
                        <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUcodigoSIF#">, 
                        <cfqueryparam cfsqltype ="cf_sql_integer" value="#rsECompras.Ecodigo#">, 	
                        <cfqueryparam cfsqltype ="cf_sql_numeric" value="#varCEcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#UsuInterfaz.Usulogin#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#UsuInterfaz.Usucodigo#">,
                        <cfqueryparam cfsqltype ="cf_sql_varchar" value="#rsECompras.Proveedor#">,
                     	<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsECompras.Tipo_Documento)#">)
                </cfquery>
            </cfif>

			<!--- Seleccion de Detalles --->
			<cfquery name="rsDCompras" datasource="sifinterfaces">
				select Ecodigo, ID_linea, Tipo_Lin, Tipo_Item, Clas_Item, Cod_Item, Cod_Impuesto, Cantidad,
				       isnull(Precio_Unitario, 0) as Precio_Unitario, isnull(Descuento_Lin, 0) as Descuento_Lin, 
					   isnull (Subtotal_Lin, 0) as Subtotal_Lin, isnull(Impuesto_Lin, 0) as Impuesto_Lin, 
					   isnull(Total_Lin, 0) as Total_Lin, Clas_Compra_Lin, Dest_Compra_Lin, Contrato_Lin, Clas_Venta_Ref,
					CFuncional
				from DSIFLD_Facturas_Compra
				where ID_DocumentoC = #DocumentoFact#
			</cfquery>
			
			<cfif isdefined("rsDCompras") and rsDCompras.recordcount GT 0>
				<cfloop query="rsDCompras">
                <cfsilent>
				<cfif rsDCompras.Clas_Compra_Lin EQ 'GACV' or rsDCompras.Clas_Compra_Lin EQ 'PRODUCTO'> 
					<!---Monto por linea --->
					<cfset MontoLin = rsDCompras.Total_Lin> <!---Importe Origen por linea--->
				 	<cfif varMoneda.EQUcodigoSIF NEQ varMonedaL> 
						<cfif varMonedaL NEQ 'MXP' and varMoneda.EQUcodigoSIF EQ 'MXP'>
							<cfset varTipoCambioL = ExtraeTipoCambio(varMonedaL,varEcodigo.EQUidSIF,rsECompras.Fecha_Tipo_Cambio)>
							<cfset MontoLinL = (MontoLin / varTipoCambioL.TCcompra)>
						<cfelseif varMonedaL EQ 'MXP' and varMoneda.EQUcodigoSIF NEQ 'MXP'>
							<cfset MontoLinL = (MontoLin * varTipoCambio.TCcompra)>
						<cfelseif varMonedaL NEQ 'MXP' and varMoneda.EQUcodigoSIF NEQ 'MXP'>
						   <cfset varTipoCambioL = ExtraeTipoCambio(varMonedaL,varEcodigo.EQUidSIF,rsECompras.Fecha_Tipo_Cambio)>
					   	   <cfset MontoLinL = ((MontoLin * varTipoCambio.TCcompra) / varTipoCambioL.TCcompra)>
  						</cfif>
					<cfelse>
						<cfset MontoLinL = MontoLin>
					</cfif>
					
																										
					<!--- Busca equivalencia de Impuesto en SIF --->
					<cfset VarImpuesto = ConversionEquivalencia (rsECompras.Origen, 'IMPUESTO', rsDCompras.Ecodigo, 
					rsDCompras.Cod_Impuesto, 'Cod_Impuesto')>
                    
                    <!--- CENTRO FUNCIONAL--->
					<cfif rsDCompras.CFuncional NEQ "" and len(rsDCompras.CFuncional) GT 0>
                        <cfset varCF = ConversionEquivalencia (rsECompras.Origen, 'CENTRO_FUN', rsECompras.Ecodigo, rsDCompras.CFuncional, 'Centro_Funcional')>
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
    	 			<cfset VarConcepServicio = ExtraeConceptoServicio(rsDCompras.Cod_Item, varEcodigo.EQUidSIF)>
					<cfset VarCodigoServicio = VarConcepServicio.Cid>
					
					<!---Validar Importes Negativos--->
					<cfif rsDCompras.Precio_Unitario LT 0 or rsDCompras.Subtotal_Lin LT 0 or rsDCompras.Impuesto_Lin LT 0 or                    rsDCompras.Total_Lin LT 0 or rsDCompras.Descuento_Lin LT 0>
						<cfthrow message="El documento contiene valores negativos, no pueden ser procesados valores negativos">
					</cfif>	
					
					<!---Cuenta Puente de Compra Costeo Inventarios--->
					<cfinvoke returnvariable="CuentaPuente" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="PMIP"
						Ecodigo="#varEcodigo.EQUidSIF#"
						Conexion="#session.dsn#"
						CConceptos="#rsDCompras.Clas_Item#"
                        PMI_Cmdty_Padre="#rsDCompras.Clas_Item#"
						Conceptos="#VarCodigoServicio#"
						Oficinas="#varOficina.EQUidSIF#"
						SNegocios="#VarPrv.SNcodigo#"
						CPTransacciones="#rsECompras.Tipo_Documento#"
						Impuestos="#varImpuesto.EQUidSIF#"
						PMI_Clas_Compra="#rsECompras.Clas_Compra#"
						PMI_Clas_Compra_Lin="#rsDCompras.Clas_Compra_Lin#"
						PMI_Destino_Compra_Lin="NA"
						PMI_Destino_Compra="NA"
						PMI_Linea_Negocio="#rsDCompras.Tipo_Item#"
						PMI_Orden_Comercial="#rsECompras.Contrato#"
						>				
					</cfinvoke>  
					<cfset CuentaCInventario = CuentaPuente>
										
						<cfif rsDCompras.Clas_Compra_Lin EQ 'PRODUCTO'>							 			
						<!---Cuenta Puente Traspaso ---> 
						<cfinvoke returnvariable="CuentaPuente" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="PMIC"
							Ecodigo="#varEcodigo.EQUidSIF#"
							Conexion="#session.dsn#"
							CConceptos="#rsDCompras.Clas_Item#"
                            PMI_Cmdty_Padre="#rsDCompras.Clas_Item#"
							Conceptos="#VarCodigoServicio#"
							Oficinas="#varOficina.EQUidSIF#"
							SNegocios="#VarPrv.SNcodigo#"
							CPTransacciones="CP"
							Impuestos="#varImpuesto.EQUidSIF#"
                            CFuncional="#varCF.EQUidSIF#"
							PMI_Clas_Compra="#rsECompras.Clas_Compra#"
							PMI_Clas_Compra_Lin="#rsDCompras.Clas_Compra_Lin#"
							PMI_Destino_Compra_Lin="#rsDCompras.Dest_Compra_Lin#"
							PMI_Destino_Compra="NA"
							PMI_Linea_Negocio="#rsDCompras.Tipo_Item#"
							PMI_Orden_Comercial="#rsECompras.Contrato#"
							PMI_Tipo_Acreedor="TRASPASO CTA COSTEO DE INV"
							PMI_Tipo_Contraparte="#varContraparte#"
							PMI_Clas_Venta_Ref="#rsDCompras.Clas_Venta_Ref#"
							>				
						</cfinvoke>          			
						<cfset CuentaPTraspaso = CuentaPuente>
					<cfelse>
							<!---Cuenta Puente Traspaso--->
							<cfinvoke returnvariable="CuentaPuente" component="sif.Componentes.CG_Complementos" 
							method="TraeCuenta"									
							Oorigen="PMIG"
							Ecodigo="#varEcodigo.EQUidSIF#" 
							Conexion="#session.dsn#"
							CConceptos="#rsDCompras.Clas_Item#"
                            PMI_Cmdty_Padre="#rsDCompras.Clas_Item#"
							Conceptos="#VarCodigoServicio#"
							Oficinas="#varOficina.EQUidSIF#"
							SNegocios="#VarPrv.SNcodigo#"
							CPTransacciones="CP"
							Impuestos="#varImpuesto.EQUidSIF#"
							PMI_Clas_Compra="#rsECompras.Clas_Compra#"
							PMI_Clas_Compra_Lin="#rsDCompras.Clas_Compra_Lin#"
							PMI_Destino_Compra_Lin="#rsDCompras.Dest_Compra_Lin#"
							PMI_Destino_Compra="NA"
							PMI_Linea_Negocio="#rsDCompras.Tipo_Item#"
							PMI_Orden_Comercial="#rsECompras.Contrato#"
							PMI_Tipo_Acreedor="TRASPASO CTA COSTEO DE INV"
							PMI_Tipo_Contraparte="#varContraparte#"
							>				
						</cfinvoke>          			
						<cfset CuentaPTraspaso = CuentaPuente>
					</cfif>				
				
				<!---				
				<!--- Cuenta Multimoneda--->
				<cfquery name="CuentaMultimoneda" datasource="#session.dsn#">
					select Cformato from CContables where Ccuenta = convert (integer, (select Pvalor from Parametros 
                    where Pcodigo = 200 and Mcodigo = 'CG' and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 
					value= "#varEcodigo.EQUidSIF#">))
				</cfquery>
			    <cfif not isdefined("CuentaMultimoneda") and CuentaMultimoneda.recordcount LT 1>
					<cfthrow message="Error al Obtener la cuenta Multimoneda">
				</cfif> --->
				
				<!---Validar que la transaccion se comporte como Factura o Nota de Credito--->
				<cfset rsTipoTran= VTran(varEcodigo.EQUidSIF, rsECompras.Tipo_Documento, 'CP')>
				<cfset varTipoTran = rsTipoTran.CTtipo>
										
				<!---REGISTRO DEL ASIENTO DE LA CUENTA PUENTE DE COMPRAS---><br>
				 <cfquery datasource="sifinterfaces">
					insert into SIFLD_ID18 
						(ID, 
						 DCIconsecutivo, 
						 Ecodigo, 
						 DCIEfecha, 
						 Eperiodo, 
						 Emes,
						 Ddescripcion, 
						 Ddocumento, 
						 Dreferencia, 
						 Dmovimiento, 
						 Ccuenta,
						 CFcuenta, 
						 Ocodigo, 
						 Mcodigo, 
						 Doriginal, 
						 Dlocal, 
						 Dtipocambio,
						 Cconcepto, 
						 BMfalta, 
						 EcodigoRef, 
						 CFformato, 
						 Oficodigo, 
						 Miso4217,
						 Referencia1, 
						 Referencia2, 
						 Referencia3, 
						 CFcodigo)
			      values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
				         <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
  					     <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">, 
						 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsECompras.Fecha_Compra,'yyyy/mm/dd')#">,
						 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
						 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
						 'Concepto: OC-O.#rsDCompras.Contrato_Lin#.#rsDCompras.Cod_Item#',
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Numero_Documento#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Tipo_Documento# #varSNnumero#">,
						 <cfif isdefined("varTipoTran") and trim(varTipoTran) EQ "C">
    						'C',
						 <cfelse>
						    'D',
						 </cfif>
						 null,
						 null,
						 null,
						 null,
						 round(#MontoLin#,2),
						 round(#MontoLinL#,2),
						 <cfif varMoneda.EQUcodigoSIF NEQ 'MXP'>
							<cfqueryparam cfsqltype ="cf_sql_money" value="#varTipoCambio.TCcompra#">,
						 <cfelse>
						 	1,
						 </cfif> 
						 20, 
						 getdate(),
   					     <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">,
					     <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaPTraspaso.CFformato#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina.EQUcodigoSIF#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda.EQUcodigoSIF#">, 
						 null,
						 null,
						 null,
					     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF.EQUcodigoSIF#">)				
										          
				</cfquery>
				<cfset IDlinea = IDlinea + 1>
				
				<!---REGISTRO DEL ASIENTO DE LA CUENTA PUENTE INVENTARIOS--->
				<!---Tipo de cambio --->
				<cfif varMoneda.EQUcodigoSIF NEQ 'USD'>
				    <cfif varMoneda.EQUcodigoSIF NEQ 'MXP'>
						<cfset MontoLinD = (MontoLin * varTipoCambio.TCcompra) / varTipoCambioD.TCcompra>
					<cfelse>
						<cfset MontoLinD = MontoLin / varTipoCambioD.TCcompra>
					</cfif>
				<cfelse>
					<cfset MontoLinD = MontoLin>
	     		</cfif>
		
				 <cfquery datasource="sifinterfaces">
					insert into SIFLD_ID18 
						(ID, 
						 DCIconsecutivo, 
						 Ecodigo, 
						 DCIEfecha, 
						 Eperiodo, 
						 Emes,
						 Ddescripcion, 
						 Ddocumento, 
						 Dreferencia, 
						 Dmovimiento, 
						 Ccuenta,
						 CFcuenta, 
						 Ocodigo, 
						 Mcodigo, 
						 Doriginal, 
						 Dlocal, 
						 Dtipocambio,
						 Cconcepto, 
						 BMfalta, 
						 EcodigoRef, 
						 CFformato, 
						 Oficodigo, 
						 Miso4217,
						 Referencia1, 
						 Referencia2, 
						 Referencia3, 
						 CFcodigo)
			      values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
				         <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
  					     <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">, 
						 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsECompras.Fecha_Compra,'yyyy/mm/dd')#">,
						 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
						 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
						 'Concepto: OC-O.#rsDCompras.Contrato_Lin#.#rsDCompras.Cod_Item#',
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Numero_Documento#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Tipo_Documento# #varSNnumero#">,
						 <cfif isdefined("varTipoTran") and trim(varTipoTran) EQ "C">
						    'D',
						 <cfelse>
						    'C',
						 </cfif>
						 null,
						 null,
						 null,
						 null,
						 round(#MontoLinD#,2),
						 round(#MontoLinL#,2),
						 <cfqueryparam cfsqltype ="cf_sql_money" value="#varTipoCambioD.TCcompra#">,
						 20, 
						 getdate(),
						 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">,
					     <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaCInventario.CFformato#">,
						 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficina.EQUcodigoSIF#">,
						 <cfqueryparam cfsqltype="cf_sql_char" value="#varMonedaD.EQUcodigoSIF#">, 
						 null,
						 null,
						 null,
					     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF.EQUcodigoSIF#">)		
										          
				</cfquery>
				<cfset IDlinea = IDlinea + 1>
				
				<cfif varMoneda.EQUcodigoSIF NEQ 'USD'>	
				
				<!---Cuenta Efecto por Conversión de Monedas locales a Dolares--->
				<cfif rsDCompras.Clas_Compra_Lin EQ 'PRODUCTO'>							 			
					<!---Cuenta Puente Traspaso ---> 
					<cfinvoke returnvariable="CuentaConversion" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
					Oorigen="PMIC"
					Ecodigo="#varEcodigo.EQUidSIF#"
					Conexion="#session.dsn#"
					CConceptos="#rsDCompras.Clas_Item#"
                    PMI_Cmdty_Padre="#rsDCompras.Clas_Item#"
					Conceptos="#VarCodigoServicio#"
					Oficinas="#varOficina.EQUidSIF#"
					SNegocios="#VarPrv.SNcodigo#"
					CPTransacciones="CP"
					Impuestos="#varImpuesto.EQUidSIF#"
                    CFuncional="#varCF.EQUidSIF#"
					PMI_Clas_Compra="#rsECompras.Clas_Compra#"
					PMI_Clas_Compra_Lin="CONVER"
					PMI_Destino_Compra_Lin="#rsDCompras.Dest_Compra_Lin#"
					PMI_Destino_Compra="NA"
					PMI_Linea_Negocio="#rsDCompras.Tipo_Item#"
					PMI_Orden_Comercial="#rsECompras.Contrato#"
					PMI_Tipo_Acreedor="TRASPASO CTA COSTEO DE INV"
					PMI_Tipo_Contraparte="#varContraparte#"
					PMI_Clas_Venta_Ref="#rsDCompras.Clas_Venta_Ref#"
					>				
					</cfinvoke>          			
					<cfset CuentaConverMonedas = CuentaConversion>
				<cfelse>
					<!---Cuenta Puente Traspaso--->
					<cfinvoke returnvariable="CuentaConversion" component="sif.Componentes.CG_Complementos" method="TraeCuenta"									
					Oorigen="PMIG"
					Ecodigo="#varEcodigo.EQUidSIF#" 
					Conexion="#session.dsn#"
					CConceptos="#rsDCompras.Clas_Item#"
                    PMI_Cmdty_Padre="#rsDCompras.Clas_Item#"
					Conceptos="#VarCodigoServicio#"
					Oficinas="#varOficina.EQUidSIF#"
					SNegocios="#VarPrv.SNcodigo#"
					CPTransacciones="CP"
					Impuestos="#varImpuesto.EQUidSIF#"
					PMI_Clas_Compra="#rsECompras.Clas_Compra#"
					PMI_Clas_Compra_Lin="CONVER"
					PMI_Destino_Compra_Lin="#rsDCompras.Dest_Compra_Lin#"
					PMI_Destino_Compra="NA"
					PMI_Linea_Negocio="#rsDCompras.Tipo_Item#"
					PMI_Orden_Comercial="#rsECompras.Contrato#"
					PMI_Tipo_Acreedor="TRASPASO CTA COSTEO DE INV"
					PMI_Tipo_Contraparte="#varContraparte#"
					>				
					</cfinvoke>          			
					<cfset CuentaConverMonedas = CuentaConversion>
				</cfif>				

			
					<!---REGISTRO DEL ASIENTO DE LA CUENTA MULTIMONEDA DOLARES--->
					<!---Tipo de cambio --->
					
						<cfif varMoneda.EQUcodigoSIF NEQ 'MXP'>
							<cfset MontoLinD = (MontoLin * varTipoCambio.TCcompra) / varTipoCambioD.TCcompra>
						<cfelse>
							<cfset MontoLinD = MontoLin / varTipoCambioD.TCcompra>
						</cfif>
						
						<cfquery datasource="sifinterfaces">
							insert into SIFLD_ID18 
								(ID, 
								 DCIconsecutivo, 
								 Ecodigo, 
								 DCIEfecha, 
								 Eperiodo, 
								 Emes,
	           			 	     Ddescripcion, 
								 Ddocumento, 
								 Dreferencia, 
								 Dmovimiento, 
								 Ccuenta,
								 CFcuenta, 
								 Ocodigo, 
								 Mcodigo, 
								 Doriginal, 
								 Dlocal, 
								 Dtipocambio,
								 Cconcepto, 
								 BMfalta, 
								 EcodigoRef, 
								 CFformato, 
								 Oficodigo, 
								 Miso4217,
								 Referencia1, 
						 		 Referencia2, 
							 	 Referencia3, 
							 	 CFcodigo)
					      values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
						         <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
  								 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">, 
								 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsECompras.Fecha_Compra,'yyyy/mm/dd')#">,
								 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
								 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
								 'Balance entre Monedas',
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Numero_Documento#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Tipo_Documento# #varSNnumero#">,
								 <cfif isdefined("varTipoTran") and trim(varTipoTran) EQ "C">
						    		'C',
		  					     <cfelse>
						    		'D',
						 		 </cfif>
								 null,
								 null,
								 null,
								 null,
								 round(#MontoLinD#,2), 
								 round(#MontoLinL#,2),
								 <cfqueryparam cfsqltype ="cf_sql_money" value="#varTipoCambioD.TCcompra#">,
								 20, 
								 getdate(),
								 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">,
					    		 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaConverMonedas.CFformato#">,
								 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficina.EQUcodigoSIF#">,
								 <cfqueryparam cfsqltype="cf_sql_char" value="#varMonedaD.EQUcodigoSIF#">, 
								 null,
								 null,
								 null,
							     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF.EQUcodigoSIF#">)				
							</cfquery>
							<cfset IDlinea = IDlinea + 1>
				
							<!---REGISTRO DEL ASIENTO DE LA CUENTA MULTIMONEDA--->
									
	     					<cfquery datasource="sifinterfaces">
							insert into SIFLD_ID18 
								(ID, 
								 DCIconsecutivo, 
								 Ecodigo, 
								 DCIEfecha, 
								 Eperiodo, 
								 Emes,
								 Ddescripcion, 
								 Ddocumento, 
								 Dreferencia, 
								 Dmovimiento, 
								 Ccuenta,
								 CFcuenta, 
								 Ocodigo, 
								 Mcodigo, 
								 Doriginal, 
								 Dlocal, 
								 Dtipocambio,
								 Cconcepto, 
								 BMfalta, 
								 EcodigoRef, 
								 CFformato, 
								 Oficodigo, 
								 Miso4217,
								 Referencia1, 
								 Referencia2, 
								 Referencia3, 
								 CFcodigo)
				    	  values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
					    	     <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
  						    	 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">, 
								 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsECompras.Fecha_Compra,'yyyy/mm/dd')#">,
								 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
								 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
								 'Balance entre Monedas',
		 						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Numero_Documento#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Tipo_Documento# #varSNnumero#">,
								 <cfif isdefined("varTipoTran") and trim(varTipoTran) EQ "C">
    								'D',
		  					     <cfelse>
						    		'C',
								 </cfif> 
								 null,
								 null,
								 null,
								 null,
								 round(#MontoLin#,2), 
								 round(#MontoLinL#,2),
								 <cfif varMoneda.EQUcodigoSIF NEQ 'MXP'>
									<cfqueryparam cfsqltype ="cf_sql_money" value="#varTipoCambio.TCcompra#">,
							 	<cfelse>
							 		1,
							 	</cfif> 
								 20, <!---concepto contable --->
								 getdate(),
								 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">,
						    	 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaConverMonedas.CFformato#">,
								 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficina.EQUcodigoSIF#">,
								 <cfqueryparam cfsqltype="cf_sql_char" value="#varMoneda.EQUcodigoSIF#">, 
								 null,
								 null,
								 null,
							     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF.EQUcodigoSIF#">)				
							</cfquery>
							<cfset IDlinea = IDlinea + 1>
						</cfif>	
				</cfif>
                </cfsilent>
				</cfloop>
			</cfif> <!--- Detalles Poliza--->
			
			<!--- Marca o Borra las Tablas Origen Registro Procesado --->
			<!--- BORRADO DE TABLAS ORIGEN --->  
        	<cfset stMemInfo = javaRT.totalMemory()-javaRT.freeMemory()>
            <cfquery datasource="sifinterfaces"> 
        		<cfif Parborrado>
					delete 	DSIFLD_Facturas_Compra where ID_DocumentoC = #DocumentoFact# 
    	        	delete	ESIFLD_Facturas_Compra where ID_DocumentoC = #DocumentoFact#     
				<cfelse>
					update ESIFLD_Facturas_Compra
					set Estatus = 92,
                    ID18 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Maximus#">,
	                Fecha_Fin_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    ControlMem = #stMemInfo#
					where ID_DocumentoC = #DocumentoFact#
				</cfif>
        	</cfquery>
            
            <cfset rsVerificaE = javacast("null","")>
            <cfset rsLinea = javacast("null","")>
            <cfset rsContraparte = javacast("null","")>
            <cfset rsMonedaL = javacast("null","")>
            <cfset BuscaPeriodo = javacast("null","")>
            <cfset BuscaMes = javacast("null","")>
            <cfset rsSNnumero = javacast("null","")>
			<cfset rsDCompras = javacast("null","")>
            <cfset rsECompras = javacast("null","")>
            <cfset javaRT.gc()><!--- invoca el GC --->
		<cfcatch>
			<!--- Marca El registro con Error--->
			<cfquery datasource="sifinterfaces">
				update ESIFLD_Facturas_Compra
				set Estatus = 6,
                Fecha_Fin_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				where ID_DocumentoC = #DocumentoFact#
			</cfquery>
			<!--- Elimina Registros Insertados. Verifica si se grabo algo en las tablas --->
			<cfif varBorraRegistro>
				<cfif isdefined("Maximus")>
                    <cfquery datasource="sifinterfaces">
                        delete SIFLD_ID18
                        where ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
                    </cfquery>
                    <cfquery datasource="sifinterfaces">
                        delete SIFLD_IE18
                        where ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
                    </cfquery>
                </cfif>
            <cfelse>
            	<cfif isdefined("Maximus")>
                    <cfif not isdefined("IDStart")>
                    	<cfabort showerror="Error #rsEcompras.ID_DocumentoC# y #Maximus# #rsVerificaE.ID#">
                    </cfif>
                    <cfquery datasource="sifinterfaces">
                        delete SIFLD_ID18
                        where ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
                        and DCIconsecutivo > <cfqueryparam cfsqltype ="cf_sql_numeric" value="#IDStart#">
                    </cfquery>
               </cfif>
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
				('CP_Compras_Contabilidad', 
				 'ESIFLD_Facturas_Compra',
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#DocumentoFact#">, 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
  				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsECompras.Ecodigo#">,
                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Usuario#">) 
			</cfquery>
		</cfcatch>
		</cftry>
        </cfsilent>
		</cfloop> <!--- Encabezado de Compras --->
        	<cfquery name="rsVerifica" datasource="sifinterfaces">
            	select count(1) as Registros from ESIFLD_Facturas_Compra
                where Estatus in (100,11)
            </cfquery>
            <cfif rsVerifica.Registros LT 1>
				<!---Se Dispara la Interfaz 18 de forma Masiva--->
                <cftransaction action="begin">
                <cftry>
                    <cfquery datasource="sifinterfaces">
                        insert into IE18
                            (ID, 
                            Ecodigo, 
                            Cconcepto, 
                            Eperiodo, 
                            Emes, 
                            Efecha,
                            Edescripcion, 
                            Edocbase, 
                            Ereferencia, 
                            Falta, 
                            Usuario,
                            ECIreversible)
                         select a.ID, a.Ecodigo, a.Cconcepto, a.Eperiodo, a.Emes, 
                            a.Efecha, a.Edescripcion, a.Edocbase, a.Ereferencia, 
                            a.Falta, a.Usuario, a.ECIreversible
                         from SIFLD_IE18 a
                         where exists (select 1 from ESIFLD_Facturas_Compra b where a.ID = b.ID18 and b.Estatus in (92))
                    </cfquery>
                    <cfquery datasource="sifinterfaces">
                        insert into ID18 
                            (ID, 
                             DCIconsecutivo, 
                             Ecodigo, 
                             DCIEfecha, 
                             Eperiodo, 
                             Emes,
                             Ddescripcion, 
                             Ddocumento, 
                             Dreferencia, 
                             Dmovimiento, 
                             Ccuenta,
                             CFcuenta, 
                             Ocodigo, 
                             Mcodigo, 
                             Doriginal, 
                             Dlocal, 
                             Dtipocambio,
                             Cconcepto, 
                             BMfalta, 
                             EcodigoRef, 
                             CFformato, 
                             Oficodigo, 
                             Miso4217,
                             Referencia1, 
                             Referencia2, 
                             Referencia3, 
                             CFcodigo)
                        select a.ID, a.DCIconsecutivo, a.Ecodigo, a.DCIEfecha, a.Eperiodo, 
                             a.Emes, a.Ddescripcion, a.Ddocumento, a.Dreferencia, a.Dmovimiento, 
                             a.Ccuenta, a.CFcuenta, a.Ocodigo, a.Mcodigo, a.Doriginal, 
                             a.Dlocal, a.Dtipocambio, a.Cconcepto, a.BMfalta, a.EcodigoRef, 
                             a.CFformato, a.Oficodigo, a.Miso4217, a.Referencia1, a.Referencia2, 
                             a.Referencia3, a.CFcodigo
                        from SIFLD_ID18 a 
                        where exists (select 1 from ESIFLD_Facturas_Compra b where a.ID = b.ID18 and b.Estatus in (92))
                    </cfquery>
                    
                    <cfquery datasource="sifinterfaces">
                        insert into InterfazColaProcesos (
                            CEcodigo, NumeroInterfaz, IdProceso, SecReproceso,
                            EcodigoSDC, OrigenInterfaz, TipoProcesamiento, StatusProceso,
                            FechaInclusion, UsucodigoInclusion, UsuarioBdInclusion, Cancelar)
                        select
                          a.CEcodigo,
                          18,
                          a.ID,
                          0 as SecReproceso,
                          a.EcodigoSDC,
                          'E' as OrigenInterfaz,
                          'A' as TipoProcesamiento,
                          1 as StatusProceso,
                          <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,<!--- timestamp para que guarde fecha de proceso --->
                          a.Usucodigo,
                          a.Usulogin,
                          0 as Cancelar
                        from SIFLD_IE18 a 
                        where exists (select 1 from ESIFLD_Facturas_Compra b where a.ID = b.ID18 and b.Estatus in (92))
                    </cfquery>
                    
                    <cfquery datasource="sifinterfaces">
                        update ESIFLD_Facturas_Compra
                            set Estatus = 2
                        where Estatus = 92
                        and ID18 in (select ID from SIFLD_IE18)
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
                        select 'CP_Compras_Contabilidad', 'ESIFLD_Facturas_Compra', ID_DocumentoC,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,				 
                            Ecodigo,
                            Usuario
                        from ESIFLD_Facturas_Compra
                        where Estatus in (92)  
                        and ID18 in (select ID from SIFLD_IE18)
                    </cfquery>
                    <cfquery datasource="sifinterfaces">
                        update ESIFLD_Facturas_Compra set Estatus = 3
                        where Estatus in (92) 
                        and ID18 in (select ID from SIFLD_IE18)
                    </cfquery>
                </cfcatch>
                </cftry>
                </cftransaction>
                
                <cfquery datasource="sifinterfaces">
                    delete SIFLD_ID18
                    where ID in (select ID18 from ESIFLD_Facturas_Compra where Estatus in (2,3))
                </cfquery>
                <cfquery datasource="sifinterfaces">
                    delete SIFLD_IE18
                    where ID in (select ID18 from ESIFLD_Facturas_Compra where Estatus in (2,3))
                </cfquery>
            </cfif>    
		</cfif>
	</cffunction>
</cfcomponent>