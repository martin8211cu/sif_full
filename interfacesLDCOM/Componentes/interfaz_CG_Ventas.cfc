<!--- ABG: Transformacion Operaciones de Contado Interfaz LD-SIF Ver. 1.0 --->
<!--- La interfaz de Ventas Operaciones de Contado, procesa todos las ventas en su fraccion Contable --->
<!--- La Interfaz LD-SIF solo funciona con versiones de Coldfusion 8.0 en adelante --->

<cfcomponent extends="Interfaz_Base">
	<cffunction name="Ejecuta" access="public" returntype="string" output="yes">
		<cfsetting requesttimeout="3600">
		<cfoutput>
			Hora Inicio: #now()#
		</cfoutput>
		<!--- Rutina para Obtener Parametros a Ocupar --->
		<cfset ParImp = true>
		<!--- Crear un Parametro Ver 2.0 --->
		<cfset ParBorrado = false>
		<!--- Parametro de agrupamiento --->
		<cfset ParAgrupa = true>
		<!--- Parametro Prorrateo de Formas de Pago --->
		<cfset ParPrrat = false>
		<!--- Crea tabla Temporal para Trabajar --->
		<cf_dbtemp name="TmpIE18" returnvariable="TmpIE18" datasource="sifinterfaces">
			<cf_dbtempcol name="ID" type="numeric">
			<cf_dbtempcol name="Ecodigo" type="int">
			<cf_dbtempcol name="Cconcepto" type="int">
			<cf_dbtempcol name="Eperiodo" type="int">
			<cf_dbtempcol name="Emes" type="int">
			<cf_dbtempcol name="Efecha" type="datetime">
			<cf_dbtempcol name="Edescripcion" type="varchar(100)">
			<cf_dbtempcol name="Edocbase" type="varchar(20)">
			<cf_dbtempcol name="Ereferencia" type="varchar(25)">
			<cf_dbtempcol name="Falta" type="datetime">
			<cf_dbtempcol name="Usuario" type="varchar(30)">
		</cf_dbtemp>
		<cf_dbtemp name="TmpID18" returnvariable="TmpID18" datasource="sifinterfaces">
			<cf_dbtempcol name="ID" type="numeric">
			<cf_dbtempcol name="DCIconsecutivo" type="int">
			<cf_dbtempcol name="Ecodigo" type="int">
			<cf_dbtempcol name="DCIEfecha" type="datetime">
			<cf_dbtempcol name="Eperiodo" type="int">
			<cf_dbtempcol name="Emes" type="int">
			<cf_dbtempcol name="Ddescripcion" type="varchar(100)">
			<cf_dbtempcol name="Ddocumento" type="varchar(20)">
			<cf_dbtempcol name="Dreferencia" type="varchar(25)">
			<cf_dbtempcol name="Dmovimiento" type="char(1)">
			<cf_dbtempcol name="Ccuenta" type="numeric">
			<cf_dbtempcol name="CFcuenta" type="numeric">
			<cf_dbtempcol name="Ocodigo" type="int">
			<cf_dbtempcol name="Mcodigo" type="numeric">
			<cf_dbtempcol name="Doriginal" type="money">
			<cf_dbtempcol name="Dlocal" type="money">
			<cf_dbtempcol name="Dtipocambio" type="float">
			<cf_dbtempcol name="Cconcepto" type="int">
			<cf_dbtempcol name="BMfalta" type="datetime">
			<cf_dbtempcol name="EcodigoRef" type="int">
			<cf_dbtempcol name="CFformato" type="varchar(100)">
			<cf_dbtempcol name="Oficodigo" type="char(10)">
			<cf_dbtempcol name="Miso4217" type="char(3)">
			<cf_dbtempcol name="Referencia1" type="char(20)">
			<cf_dbtempcol name="Referencia2" type="char(20)">
			<cf_dbtempcol name="Referencia3" type="char(20)">
			<cf_dbtempcol name="CFcodigo" type="char(20)">
			<cf_dbtempcol name="TipoOperacion" type="int">
			<!--- Tipos de Operacion para Sumatoria
				1 = Ingresos, 2 = IVA, 3 = Pago Efectivo, 4 = Pago Tarjeta, 5 = Pago Vale, 6 = Pago Cheque
				7 = Pago MExtranjera, 8 = Pago Nota, 9 = Pago Monedero, 10 = Pago Puntos, 11 = Pago CoPago,
				12 = Almacen Venta, 13 = Costo Venta, 14 = DescuentoV, 15 = DescuentoE, 16 = Devolucion, 
				17 = Efectivo Caja, 18 = PagoBanco, 19 = ComBanco, 20 = Deudores, 21 = PendientesF, 22 = CambioEfec
			--->
		</cf_dbtemp>

		<!--- Tipo Venta
			P = Contado
			C = Credito
			D = Devolucion
			S = Servicio Domicilio --->
		<!--- Extrae Encabezados de Ventas --->
        <cfquery name="rsEVentas" datasource="sifinterfaces">
        	select Ecodigo, Origen, Id_DocumentoV, Tipo_Documento, Tipo_Venta, 
				Fecha_Venta, Numero_Documento, Cliente, IETU_Clas, Subtotal, Descuento, 
				Impuesto, Total, Vendedor,Sucursal, Dias_Credito, Moneda, Tipo_Cambio, 
				Direccion_Facturacion, Retencion, Observaciones, Tipo_Cedi, Factura_Cambio
            from ESIFLD_Facturas_Venta
            where Estatus in (1,4)
			<!--- and Tipo_Venta in ('P','D','S') Solo toma Ventas de contado, devoluciones y servicios a Domicilio --->
        </cfquery>
        <!--- Crea tabla temporal para control de Encabezados --->
		<cf_dbtemp name="rsVentasEnc" returnvariable="rsVentasEnc" datasource="sifinterfaces">
			<cf_dbtempcol name="ID" type="int">
			<cf_dbtempcol name="Ecodigo" type="int">
   	        <cf_dbtempcol name="Documento" type="varchar(20)"> 
		</cf_dbtemp>
		<cfif isdefined("rsEVentas") and rsEVentas.recordcount GT 0>
		<cfloop query="rsEVentas">
		<cftry>
			<cfset DocumentoFact = rsEVentas.Id_DocumentoV>
			
			<!--- Crea tabla temporal para Insersion de Temporales --->
			<cf_dbtemp name="rsColaP" returnvariable="rsColaP" datasource="sifinterfaces">
				<cf_dbtempcol name="ID" type="int">
				<cf_dbtempcol name="Ecodigo" type="int">
				<cf_dbtempcol name="Interfaz" type="int">
			</cf_dbtemp>
	
			<!--- Busca equivalencias --->
			<!---OFICINA --->
			<cfset Equiv = ConversionEquivalencia (rsEVentas.Origen, 'SUCURSAL', rsEVentas.Ecodigo, rsEVentas.Sucursal, 'Sucursal')>
            <cfset VarOficina = Equiv.EQUcodigoSIF>
			
			<!--- CENTRO FUNCIONAL--->
			<cfset Equiv = ConversionEquivalencia (rsEVentas.Origen, 'CENTRO_FUN', rsEVentas.Ecodigo, rsEVentas.Sucursal, 'Centro_Funcional')>
			<cfset varCF = Equiv.EQUcodigoSIF>

			<!--- EMPRESAS --->
			<cfset Equiv = ConversionEquivalencia (rsEVentas.Origen, 'CADENA', rsEVentas.Ecodigo, rsEVentas.Ecodigo, 'Cadena')>
			<cfset varEcodigo = Equiv.EQUcodigoSIF>
			<cfset session.dsn = getConexion(getEcodigo(varEcodigo))>
			
			<!--- BUSCA EQUIVALENCIA DE CUENTA PAGO PARA LA SUCURSAL EN CASO DE QUE NO EXISTA IRA POR LA 
			EQUIVALENCIA DE CUENTA PAGO POR EMPRESA  --->
            <cftry>    
				<cfset Equiv = ConversionEquivalencia (rsEVentas.Origen, 'CTA_PAGSUC', rsEVentas.Ecodigo, rsEVentas.Sucursal, 'Cuenta_Pago_Sucursal')>
            	<cfset varCtaBanco = Equiv.EQUcodigoSIF>
            <cfcatch>
				<cfset Equiv = ConversionEquivalencia (rsEVentas.Origen, 'CTA_PAGEMP', rsEVentas.Ecodigo, rsEVentas.Ecodigo, 'Cuenta_Pago_Empresa')>
				<cfset varCtaBanco = Equiv.EQUcodigoSIF>	
			</cfcatch>
			</cftry>
			<cfif isdefined("varCtaBanco") and len(varCtaBanco) GT 0>
				<cfquery name="rsCta_Banco" datasource="#session.dsn#">
		           	select CBid, Bid from CuentasBancos
               		where CBid = #varCtaBanco#
                    	and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
            	</cfquery>
				<cfset varCuentaB = rsCta_Banco.CBid>
	            <cfset varBanco = rsCta_Banco.Bid>
			<cfelse>
				<cfthrow message="Error Cuenta Bancaria No Existe">
			</cfif>
			
			<!--- MONEDA --->
            <cfset Equiv = ConversionEquivalencia (rsEVentas.Origen, 'MONEDA', rsEVentas.Ecodigo, rsEVentas.Moneda, 'Moneda')>
			<cfset varMoneda = Equiv.EQUcodigoSIF>
			           	
			<cfset Periodo = year(rsEVentas.Fecha_Venta)>
            <cfset Mes = month(rsEVentas.Fecha_Venta)>
            <cfset NumeroDoc = rsEVentas.Numero_Documento>
                    
            <!--- , 'CLIENTE', 'ECODIGO' --->
	        <cfset VarCte = ExtraeCliente(rsEVentas.Cliente, varEcodigo)>
                
			<!--- Se cargan con el mes y periodo de la Fecha de Venta   
            <!--- Busca Periodo en Minisif --->
            <cfquery name="BuscaPeriodo" datasource="#session.dsn#">
              	SELECT Pvalor 
				FROM Parametros 
				WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#getEcodigo(varEcodigo)#"> 
				AND Pcodigo = 50
            </cfquery>
            <cfset Periodo = BuscaPeriodo.Pvalor>
					
            <!--- Busca Mes en Minisif --->
			<cfquery name="BuscaMes" datasource="#session.dsn#">
               	SELECT Pvalor 
				FROM Parametros 
				WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#getEcodigo(varEcodigo)#"> 
				AND Pcodigo = 60
            </cfquery>
            <cfset Mes = BuscaMes.Pvalor>
            --->
			
			<!--- Para la Descripcion de la Poliza --->    
   	        <cfif rsEVentas.Tipo_Venta EQ "P">
       	        <cfset DescPoliza = "Contado">
           	<cfelseif rsEVentas.Tipo_Venta EQ "D">
                <cfset DescPoliza = "Devolucion">  
			<cfelseif rsEVentas.Tipo_Venta EQ "S">
       	        <cfset DescPoliza = "Contado-Domicilio">                          
           	</cfif>
			
			<!---Verifica si debe insertar encabezado o no --->
			<cfquery name="rsVerificaE" datasource="sifinterfaces">
				select * 
				from #rsVentasEnc#
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">
				and Documento like <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsEVentas.Numero_Documento)#">
			</cfquery>	
			<cfif rsVerificaE.recordcount EQ 0>
				<!--- Extrae Maximo+1 de tabla IE18 para insertar nuevo reg, en IE18 ---> 
                <cfset RsMaximo = ExtraeMaximo("IE18","ID")> 
                <cfif isdefined("RsMaximo.Maximo") And RsMaximo.Maximo GT 0>
					<cfset Maximus = RsMaximo.Maximo>
                <cfelse>
                	<cfset Maximus = 1>
                </cfif>
                   
                <!--- Insercion de Encabezado en IE18 --->
                <cfquery name="rsInsertaIE18" datasource="sifinterfaces">
                	insert into #TmpIE18#
						(ID, Ecodigo, Cconcepto, Eperiodo, Emes, Efecha, Edescripcion, 
					 	Edocbase, Ereferencia, Falta, Usuario)
                    values 
					(<cfqueryparam cfsqltype ="cf_sql_integer" value="#Maximus#">,
                     <cfqueryparam cfsqltype ="cf_sql_integer" value="#VarEcodigo#">, 
					 0,
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#Periodo#">,
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mes#">,
                     <cfqueryparam cfsqltype="cf_sql_date" value="#rsEVentas.Fecha_Venta#">,
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de Venta #DescPoliza# #rsEVentas.Cliente#">,
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#NumeroDoc#">,
                     ' ', getdate(), '0')
            	</cfquery>  
				
				<!---Inserta Registro de Control --->
				<cfquery datasource="sifinterfaces">
					insert into #rsVentasEnc# (ID, Ecodigo, Documento)
					values
					(<cfqueryparam cfsqltype ="cf_sql_integer" value="#Maximus#">,
                     <cfqueryparam cfsqltype ="cf_sql_integer" value="#VarEcodigo#">, 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#NumeroDoc#">)
				</cfquery>
				<cfset IDlinea = 1>
            <cfelse>
				<cfset Maximus = rsVerificaE.ID>
				<cfquery name="rsLinea" datasource="sifinterfaces">
					select isnull(max(DCIconsecutivo),0) + 1 as Linea
					from #TmpID18#
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">
					and ID = <cfqueryparam cfsqltype ="cf_sql_integer" value="#rsVerificaE.ID#">
				</cfquery>
				<cfset IDlinea = rsLinea.Linea>
				<cfset IDStart = rsLinea.Linea - 1>
			</cfif>     
            
			<!--- SELECCION DE REGISTROS DE DETALLE --->        
            <cfquery name="rsDVentas" datasource="sifinterfaces">
            	select Ecodigo, ID_DocumentoV, Id_Linea, Tipo_Lin, Tipo_Item,
					isnull(Subtotal_Lin,0) as Subtotal, 
					isnull(Descuento_Lin,0) as Descuento,
					isnull(Impuesto_Lin, 0) as Impuesto, 
					isnull(Total_Lin, 0) as Total, 
					Cod_Impuesto, Clas_Item, Cod_Fabricante, Costo_Venta
                from DSIFLD_Facturas_Venta
                where Id_DocumentoV = #DocumentoFact#
			</cfquery>
                    
			<!--- LISTA DE CUENTAS --->
			<!--- 
			CuentaLDIV Cta. Ventas doc. Contable
  			CuentaLDIP Cta. IVA Acreditable
  			CuentaLDAV Cta. Inventario doc. Contable Costo Ventas
  			CuentaLDCV Cta. Costo de Ventas doc. Contable
  			CuentaLDDD Cta. Deudores Diversos
  			CuentaLDCB Cta. Para Gastos Financieros comis.banc.
	        CuentaLDCF Cta. Ctes. pendientes por facturar
    	    CuentaLDVD Cta. Ventas Devolucion 			
        	CuentaLDEF Cta. Efectivo en Caja			
        
	        <!--- DECLARA ARREGLO DE CUENTA CONTABLE PARA PAGOS --->
        
    	    CuentaLDEF Cta. Efectivo en Caja Doctos Contables
        	CuentaLDBC Cta. Bancos Cuentas					
	        CuentaLDDV Cta. Descuento sobre Ventas			
    	    CuentaLDCB_Pago Cta. Para Gastos Financieros comis.banc.
        	CuentaLDDD_Pago Cta. Deudores Diversos					
        	--->
			
	       	<cfif isdefined("rsDVentas") and rsDVentas.recordcount GT 0> 
			<cfloop query = "rsDVentas">
       			<!--- Busca equivalencia de IMPUESTO en SIF --->
				<cfset Equiv = ConversionEquivalencia (rsEVentas.Origen, 'IMPUESTO', rsEVentas.Ecodigo, rsDVentas.Cod_Impuesto, 'Cod_Impuesto')>
            	<cfset VarImpuesto = Equiv.EQUcodigoSIF>
            	<!--- Obtiene cuenta Contable Parametrizada en el Impuesto --->
				<cfquery name="rsIVA" datasource="#session.dsn#">
					select Cformato
					from CContables c
						inner join Impuestos i
						on c.Ecodigo = i.Ecodigo and c.Ccuenta = i.CcuentaCxCAcred
					where i.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#getEcodigo(varEcodigo)#">
						and i.Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#VarImpuesto#">
				</cfquery>
	        	<cfif isdefined ("rsIVA") and rsIVA.recordcount GT 0>
					<cfset varCuentaImp = rsIVA.Cformato>
				<cfelse>
					<cfthrow message="El Impuesto #varImpuesto# No tiene Parametrizadas sus cuentas">
				</cfif>

				<!--- OBTIENE LAS CUENTAS PARA CADA UNO DE LOS MOVIMIENTOS --->
            
            	<!--- INGRESOS --->
                <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                	Oorigen="LDVT"
                    Ecodigo="#varEcodigo#"  
                    Conexion="#session.dsn#"
                    LDOperacion="ING"
					LDDepartamento="#rsDVentas.Tipo_Item#"
					LDClasificacion="#rsDVentas.Clas_Item#"
					LDFabricante="#rsDVentas.Cod_Fabricante#"
					LDTipoVenta="#rsEVentas.Tipo_Venta#"
					SNegocios="#varCte.sncodigo#"
					Impuestos="#varImpuesto#"
					Oficinas="#varOficina#"		
					LDConceptoRetiroCaja="NOUSAR"
					Almacen="NOUSAR"
					Bancos="#varBanco#"
					LDCuentaBanco="#varCuentaB#"
					LDMovimientoInventario="NOUSAR"
					LDAlmacen="NOUSAR"
					LDTipoRetiroCaja="NOUSAR"
				>
                </cfinvoke>     				
                <cfset CuentaLDIV = Cuenta> 
				
				<cfif rsEVentas.Impuesto GT 0>
					<!--- IVA --->
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="LDVT"
						Ecodigo="#varEcodigo#"  
						Conexion="#session.dsn#"
						LDOperacion="IVA"
						LDDepartamento="#rsDVentas.Tipo_Item#"
						LDClasificacion="#rsDVentas.Clas_Item#"
						LDFabricante="#rsDVentas.Cod_Fabricante#"
						LDTipoVenta="#rsEVentas.Tipo_Venta#"
						SNegocios="#varCte.sncodigo#"
						Impuestos="#varImpuesto#"
						Oficinas="#varOficina#"		
						LDConceptoRetiroCaja="NOUSAR"
						Almacen="NOUSAR"
						Bancos="#varBanco#"
						LDCuentaBanco="#varCuentaB#"
						LDMovimientoInventario="NOUSAR"
						LDAlmacen="NOUSAR"
						LDTipoRetiroCaja="NOUSAR"
					>
					</cfinvoke>   
					<cfset CuentaLDIP = Cuenta>
				</cfif>
            	
				<!--- ALMACEN VENTAS --->
                <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                	Oorigen="LDVT"
                    Ecodigo="#varEcodigo#"  
                    Conexion="#session.dsn#"
                    LDOperacion="AVT"
					LDDepartamento="#rsDVentas.Tipo_Item#"
					LDClasificacion="#rsDVentas.Clas_Item#"
					LDFabricante="#rsDVentas.Cod_Fabricante#"
					LDTipoVenta="#rsEVentas.Tipo_Venta#"
					SNegocios="#varCte.sncodigo#"
					Impuestos="#varImpuesto#"
					Oficinas="#varOficina#"		
					LDConceptoRetiroCaja="NOUSAR"
					Almacen="NOUSAR"
					Bancos="#varBanco#"
					LDCuentaBanco="#varCuentaB#"
					LDMovimientoInventario="NOUSAR"
					LDAlmacen="NOUSAR"
					LDTipoRetiroCaja="NOUSAR"
				>
                </cfinvoke>          			
                <cfset CuentaLDAV = Cuenta>
                
                <!--- COSTO VENTAS --->
                <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                	Oorigen="LDVT"
                    Ecodigo="#varEcodigo#"  
                    Conexion="#session.dsn#"
                    LDOperacion="CVT"
					LDDepartamento="#rsDVentas.Tipo_Item#"
					LDClasificacion="#rsDVentas.Clas_Item#"
					LDFabricante="#rsDVentas.Cod_Fabricante#"
					LDTipoVenta="#rsEVentas.Tipo_Venta#"
					SNegocios="#varCte.sncodigo#"
					Impuestos="#varImpuesto#"
					Oficinas="#varOficina#"		
					LDConceptoRetiroCaja="NOUSAR"
					Almacen="NOUSAR"
					Bancos="#varBanco#"
					LDCuentaBanco="#varCuentaB#"
					LDMovimientoInventario="NOUSAR"
					LDAlmacen="NOUSAR"
					LDTipoRetiroCaja="NOUSAR"
				>
                </cfinvoke>          			
                <cfset CuentaLDCV = Cuenta> 
                
				<cfif rsEVentas.Tipo_Venta EQ "D">	
					<!--- DEVOLUCION DE VENTAS  --->
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="LDVT"
						Ecodigo="#varEcodigo#"  
						Conexion="#session.dsn#"
						LDOperacion="DVT"
						LDDepartamento="#rsDVentas.Tipo_Item#"
						LDClasificacion="#rsDVentas.Clas_Item#"
						LDFabricante="#rsDVentas.Cod_Fabricante#"
						LDTipoVenta="#rsEVentas.Tipo_Venta#"
						SNegocios="#varCte.sncodigo#"
						Impuestos="#varImpuesto#"
						Oficinas="#varOficina#"		
						LDConceptoRetiroCaja="NOUSAR"
						Almacen="NOUSAR"
						Bancos="#varBanco#"
						LDCuentaBanco="#varCuentaB#"
						LDMovimientoInventario="NOUSAR"
						LDAlmacen="NOUSAR"
						LDTipoRetiroCaja="NOUSAR"
					>
					</cfinvoke>           			
					<cfset CuentaLDVD = Cuenta>
				</cfif> 
                          
                <!--- EFECTIVO EN CAJA  --->
                <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                	Oorigen="LDVT"
                    Ecodigo="#varEcodigo#"  
                    Conexion="#session.dsn#"
                    LDOperacion="EFC"
					LDDepartamento="#rsDVentas.Tipo_Item#"
					LDClasificacion="#rsDVentas.Clas_Item#"
					LDFabricante="#rsDVentas.Cod_Fabricante#"
					LDTipoVenta="#rsEVentas.Tipo_Venta#"
					SNegocios="#varCte.sncodigo#"
					Impuestos="#varImpuesto#"
					Oficinas="#varOficina#"		
					LDConceptoRetiroCaja="NOUSAR"
					Almacen="NOUSAR"
					Bancos="#varBanco#"
					LDCuentaBanco="#varCuentaB#"
					LDMovimientoInventario="NOUSAR"
					LDAlmacen="NOUSAR"
					LDTipoRetiroCaja="NOUSAR"
				>
                </cfinvoke>         			
                <cfset CuentaLDEF = Cuenta>
				
				<cfif rsEVentas.Tipo_Venta EQ "C">
					<!--- PENDIENTES DE FACTURAR  --->
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="LDVT"
						Ecodigo="#varEcodigo#"  
						Conexion="#session.dsn#"
						LDOperacion="PFC"
						LDDepartamento="#rsDVentas.Tipo_Item#"
						LDClasificacion="#rsDVentas.Clas_Item#"
						LDFabricante="#rsDVentas.Cod_Fabricante#"
						LDTipoVenta="#rsEVentas.Tipo_Venta#"
						SNegocios="#varCte.sncodigo#"
						Impuestos="#varImpuesto#"
						Oficinas="#varOficina#"		
						LDConceptoRetiroCaja="NOUSAR"
						Almacen="NOUSAR"
						Bancos="#varBanco#"
						LDCuentaBanco="#varCuentaB#"
						LDMovimientoInventario="NOUSAR"
						LDAlmacen="NOUSAR"
						LDTipoRetiroCaja="NOUSAR"
					>
					</cfinvoke>         			
					<cfset CuentaLDPF = Cuenta>         
                </cfif>
				
				<cfif rsEVentas.Tipo_Venta NEQ "D">
	         		<!--- Dependiendo del parametro de Prorrateo se ejecuta esta rutina --->
					<cfif ParPrrat>
						<!--- SELECCION DE REGISTROS DE DETALLE de Tipo de Pago--->
						<cfquery name="rsFPago" datasource="sifinterfaces" timeout="3600">
							select  Ecodigo, ID_DocumentoV, Id_Linea_Pago, Tipo_Pago, 
							isnull(Importe,0) as Importe, Moneda, Tipo_Cambio, Especial, 
							SocioDocumento, Comision_Porcentaje
							from SIFLD_Facturas_Tipo_Pago
							where Id_DocumentoV = <cfqueryparam cfsqltype="cf_sql_integer" value="#DocumentoFact#">
						</cfquery>
						<cfif isdefined("rsFPago") and rsFPago.recordcount GT 0>
						<cfloop query="rsFPago">
							<!--- Para no multiplicar los Casos Especiales --->
							<cfquery name="rsVerificaEsp" datasource="sifinterfaces">
								select *
								from #rsColaP#
							</cfquery>
			
							<!--- MONEDA --->
							<cfset Equiv = ConversionEquivalencia (rsEVentas.Origen, 'MONEDA', rsEVentas.Ecodigo, rsFPago.Moneda, 'Moneda')>
							<cfset varMonedaPag = Equiv.EQUcodigoSIF>
							
							<!--- Manejo Casos Especiales --->
							<cfif rsFPago.Especial EQ 1 AND rsVerificaEsp.recordcount EQ 0>
								<!--- Obtiene cliente --->
								<cfset VarCteEsp = ExtraeCliente(rsFPago.SocioDocumento, varEcodigo)>
								<!--- La cuenta Deudores Diversos solo se usa para los Casos especiales de Forma de Pago--->
								<!--- Cta. Deudores Diversos  --->
								<!--- DEUDORES DIVERSOS --->
								<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
									Oorigen="LDVT"
									Ecodigo="#varEcodigo#"  
									Conexion="#session.dsn#"
									LDOperacion="DDV"
									LDDepartamento="#rsDVentas.Tipo_Item#"
									LDClasificacion="#rsDVentas.Clas_Item#"
									LDFabricante="#rsDVentas.Cod_Fabricante#"
									LDTipoVenta="#rsEVentas.Tipo_Venta#"
									SNegocios="#varCteEsp.SNcodigo#"
									Impuestos="#varImpuesto#"
									Oficinas="#varOficina#"		
									LDConceptoRetiroCaja="NOUSAR"
									Almacen="NOUSAR"
									Bancos="#varBanco#"
									LDCuentaBanco="#varCuentaB#"
									LDMovimientoInventario="NOUSAR"
									LDAlmacen="NOUSAR"
									LDTipoRetiroCaja="NOUSAR"
									>
								</cfinvoke>	       			
								<cfset CuentaLDDD = Cuenta>	
								
								<cfset RsMaximo = ExtraeMaximo("IE10","ID")> 
								<cfif isdefined("RsMaximo.Maximo") And RsMaximo.Maximo GT 0>
									<cfset MaximusEsp = RsMaximo.Maximo>
								<cfelse>
									<cfset MaximusEsp = 1>
								</cfif>
							
								<!--- Arma Numero Documento --->
								<cfset NumDocEsp = "ESP-#numberformat(MaximusEsp,"000000000")#">
							
								<!--- Se Debe Insertar un Documento en la Interfaz 10 para el socio indicado y el monto pagado --->
								<cfquery datasource="sifinterfaces">
									insert into IE10 
										(ID, EcodigoSDC, NumeroSocio, Modulo, CodigoTransacion, 
										 Documento, Estado, CodigoMoneda, FechaDocumento, FechaVencimiento,
										 DiasVencimiento, Facturado, Origen, VoucherNo, CodigoRetencion, 
										 CodigoOficina, CuentaFinanciera, CodigoConceptoServicio, 
										 CodigoDireccionEnvio, CodigoDireccionFact, BMUsucodigo, 
										 ConceptoCobroPago, StatusProceso, Dtipocambio)
									values (
										  <cfqueryparam cfsqltype ="cf_sql_numeric" value="#MaximusEsp#">,
										  <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo#">,
										  <cfqueryparam cfsqltype="cf_sql_varchar" value="#VarCteEsp.SNcodigo#">,
										  'CC',
										  'FC',
										  <cfqueryparam cfsqltype="cf_sql_varchar" value="#NumDocEsp#">, 
										  null, 
										  <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMonedaPag#">,
										  <cfqueryparam cfsqltype="cf_sql_date" value="#rsEVentas.Fecha_Venta#">, 
										  <cfqueryparam cfsqltype="cf_sql_date" value="#rsEVentas.Fecha_Venta#">, 
										  0,
										  'S', 
										  'LDCC', 
										  0, 
										  null,
										  <cfqueryparam cfsqltype="cf_sql_char" value="#VarOficina#">,
										  null, null, null, null, 1<!---VERIFICAR ABG--->,
										  null <!---VERIFICAR--->,
										  10, 
										  <cfqueryparam cfsqltype="cf_sql_float" value="#numberformat(rsFPago.Tipo_Cambio,'9.9999')#">)
								</cfquery> 
	
								<cfquery datasource="sifinterfaces">
									insert into ID10 
										(ID, Consecutivo, TipoItem, CodigoItem, NombreBarco, FechaHoraCarga, FechaHoraSalida,
										 PrecioUnitario, CodigoUnidadMedida, CantidadTotal, CantidadNeta, CodEmbarque, 
										 NumeroBOL, FechaBOL, TripNo, ContractNo, CodigoImpuesto, ImporteImpuesto, 
										 ImporteDescuento, CodigoAlmacen, CodigoDepartamento, CentroFuncional, 
										 CuentaFinancieraDet, BMUsucodigo, PrecioTotal)
									values 
									(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#MaximusEsp#">,
									  1, 
									  'S',  
									  'VENTAS',
									  ' ', getdate(), getdate(), 
									  <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsFPago.Importe,"9.99")#">,
									  ' ', 
									  1,
									  1, 
									  ' ', ' ', getdate(), ' ', ' ', 
									  null, 
									  null, 
									  null,
									  ' ',
									  ' ', 
									  <cfqueryparam cfsqltype="cf_sql_char" value="#varCF#">, 
									  <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDDD.CFformato#">,
									  1, 
									  <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsFPago.Importe,"9.99")#">)
								</cfquery>
							
								<!--- Introduce registro en la Cola de Procesos de la interfaz  --->             
								<cfquery datasource="sifinterfaces">
									insert #rsColaP# (ID,Ecodigo,Interfaz)
									values 
									(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#MaximusEsp#">,
									 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo#">,
									 10)
								</cfquery>
							</cfif> <!---Casos Especiales--->
						
							<!--- Si el Documento tiene IVA, calcula el IVA correspondiente a Este Tipo de Pago --->
							<!---<cfif rsEVentas.Impuesto GT 0>
								<cfset PImpuesto = (rsFPago.Importe/rsEVentas.Total) * rsEVentas.Impuesto>
								<cfset Ingreso = rsFPago.Importe - PImpuesto>
							<cfelse> --->
								<cfset Ingreso = rsFPago.Importe>	
							<!---</cfif>--->
							<!--- Calcula y Quita el porcentaje de Comision al Ingreso --->
							<cfset Comision = rsFPago.Importe * rsFPago.Comision_Porcentaje>
							<cfset Ingreso = Ingreso - Comision>
							<!---Calcula el prorrateo del Ingreso para el detalle Procesado--->
							<cfset PIngreso = (rsDVentas.Total/rsEVentas.Total) * Ingreso>
							<!---Descripcion de la Poliza --->
							<cfif rsFPago.Tipo_Pago EQ "E">
								<cfset DescPol = "Efectivo">
							<cfelseif rsFPago.Tipo_Pago EQ "T">
								<cfset DescPol = "Tarjeta">
							<cfelseif rsFPago.Tipo_Pago EQ "V">
								<cfset DescPol = "Vales">
							<cfelseif rsFPago.Tipo_Pago EQ "H">
								<cfset DescPol = "Cheque">
							<cfelseif rsFPago.Tipo_Pago EQ "X">
								<cfset DescPol = "Moneda Extranjera">
							<cfelseif rsFPago.Tipo_Pago EQ "N">
								<cfset DescPol = "Nota de Credito">
							<cfelseif rsFPago.Tipo_Pago EQ "M">
								<cfset DescPol = "Monedero">
							<cfelseif rsFPago.Tipo_Pago EQ "P">
								<cfset DescPol = "Puntos">
							<cfelseif rsFPago.Tipo_Pago EQ "C">
								<cfset DescPol = "Co-Pago">
							</cfif>
							<cfif rsFPago.Especial EQ 1>
								<cfset DescPol = "Forma Pago Especial #DescPol#">
							</cfif>
							<!--- Cuentas Por tipo de Pago --->
							<cfif rsFPago.Tipo_Pago EQ "T" OR rsFPago.Tipo_Pago EQ "V" OR rsFPago.Tipo_Pago EQ "C">
								<!--- CUENTA BANCARIA  --->
								<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
									Oorigen="LDVT"
									Ecodigo="#varEcodigo#"  
									Conexion="#session.dsn#"
									LDOperacion="CBN"
									LDDepartamento="#rsDVentas.Tipo_Item#"
									LDClasificacion="#rsDVentas.Clas_Item#"
									LDFabricante="#rsDVentas.Cod_Fabricante#"
									LDTipoVenta="#rsEVentas.Tipo_Venta#"
									SNegocios="#varCte.sncodigo#"
									Impuestos="#varImpuesto#"
									Oficinas="#varOficina#"		
									LDConceptoRetiroCaja="NOUSAR"
									Almacen="NOUSAR"
									Bancos="#varBanco#"
									LDCuentaBanco="#varCuentaB#"
									LDMovimientoInventario="NOUSAR"
									LDAlmacen="NOUSAR"
									LDTipoRetiroCaja="NOUSAR"
								>
								</cfinvoke>
								<cfset CuentaLDBC = Cuenta>
								
								<!--- COMISIONES BANCARIAS  --->
								<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
									Oorigen="LDVT"
									Ecodigo="#varEcodigo#"  
									Conexion="#session.dsn#"
									LDOperacion="CMB"
									LDDepartamento="#rsDVentas.Tipo_Item#"
									LDClasificacion="#rsDVentas.Clas_Item#"
									LDFabricante="#rsDVentas.Cod_Fabricante#"
									LDTipoVenta="#rsEVentas.Tipo_Venta#"
									SNegocios="#varCte.sncodigo#"
									Impuestos="#varImpuesto#"
									Oficinas="#varOficina#"		
									LDConceptoRetiroCaja="NOUSAR"
									Almacen="NOUSAR"
									Bancos="#varBanco#"
									LDCuentaBanco="#varCuentaB#"
									LDMovimientoInventario="NOUSAR"
									LDAlmacen="NOUSAR"
									LDTipoRetiroCaja="NOUSAR"
								>
								</cfinvoke>
								<cfset CuentaLDCB = Cuenta>
							</cfif>
							
							<cfif rsFPago.Tipo_Pago EQ "N" OR rsFPago.Tipo_Pago EQ "M" OR rsFPago.Tipo_Pago EQ "P">
								<!--- DESCUENTOS SOBRE VENTAS  --->
								<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
									Oorigen="LDVT"
									Ecodigo="#varEcodigo#"  
									Conexion="#session.dsn#"
									LDOperacion="DSV"
									LDDepartamento="#rsDVentas.Tipo_Item#"
									LDClasificacion="#rsDVentas.Clas_Item#"
									LDFabricante="#rsDVentas.Cod_Fabricante#"
									LDTipoVenta="#rsEVentas.Tipo_Venta#"
									SNegocios="#varCte.sncodigo#"
									Impuestos="#varImpuesto#"
									Oficinas="#varOficina#"		
									LDConceptoRetiroCaja="NOUSAR"
									Almacen="NOUSAR"
									Bancos="#varBanco#"
									LDCuentaBanco="#varCuentaB#"
									LDMovimientoInventario="NOUSAR"
									LDAlmacen="NOUSAR"
									LDTipoRetiroCaja="NOUSAR"
								>
								</cfinvoke>	
								<cfset CuentaLDDV = Cuenta>
							</cfif>
							
							<!---Inserta el detalle a la poliza Para la Forma de Pago--->
							<cfquery datasource="sifinterfaces">
								insert into #TmpID18# (
									ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
									Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
									Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
									Oficodigo, Miso4217, CFcodigo,TipoOperacion)
								values 
								(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#IDLinea#">,
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">,
								 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, 'short')#">,
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">, 
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">, 
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="Pago en #DescPol#">, 
								 ' ', ' ', 'D', 0, 0, 0, 0,
								 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(PIngreso,'9.99')#">),
								 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(PIngreso * rsFPago.Tipo_Cambio,'9.99')#">),
								 <cfqueryparam cfsqltype="cf_sql_float" value="#rsFPago.Tipo_Cambio#">,
								 0, getdate(), 0, 
								 <cfif rsFPago.Especial EQ 1>
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDDD.CFformato#">,
								 <cfelse>	
									 <cfif rsFPago.Tipo_Pago EQ "E">
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDEF.CFformato#">,
									 <cfelseif rsFPago.Tipo_Pago EQ "T">
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDBC.CFformato#">,
									 <cfelseif rsFPago.Tipo_Pago EQ "V">
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDBC.CFformato#">,
									 <cfelseif rsFPago.Tipo_Pago EQ "H">
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDEF.CFformato#">,
									 <cfelseif rsFPago.Tipo_Pago EQ "X">
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDEF.CFformato#">,
									 <cfelseif rsFPago.Tipo_Pago EQ "N">
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDDV.CFformato#">,
									 <cfelseif rsFPago.Tipo_Pago EQ "M">
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDDV.CFformato#">,
									 <cfelseif rsFPago.Tipo_Pago EQ "P">
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDDV.CFformato#">,
									 <cfelseif rsFPago.Tipo_Pago EQ "C">
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDBC.CFformato#">,
									 </cfif>
								 </cfif>
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMonedaPag#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
								 <cfif rsFPago.Especial EQ 1>
									 20
								 <cfelse>	
									 <cfif rsFPago.Tipo_Pago EQ "E">
										3
									 <cfelseif rsFPago.Tipo_Pago EQ "T">
										4
									 <cfelseif rsFPago.Tipo_Pago EQ "V">
										5
									 <cfelseif rsFPago.Tipo_Pago EQ "H">
										6
									 <cfelseif rsFPago.Tipo_Pago EQ "X">
										7
									 <cfelseif rsFPago.Tipo_Pago EQ "N">
										8
									 <cfelseif rsFPago.Tipo_Pago EQ "M">
										9
									 <cfelseif rsFPago.Tipo_Pago EQ "P">
										10
									 <cfelseif rsFPago.Tipo_Pago EQ "C">
										11
									 </cfif>
								 </cfif>)        
							</cfquery>
							<cfset IDlinea = IDlinea + 1>
						
							<cfif rsFPago.Comision_Porcentaje GT 0>
								<!--- Insercion de Comision Bancaria "LDCB" (Comisiones Bancarias) --->
								<cfquery name="rsInsertaFact_TPago" datasource="sifinterfaces">
									insert into #TmpID18#
										(
										 ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
										 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
										 Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
										 Oficodigo, Miso4217, CFcodigo, TipoOperacion)
									values 
									(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#IDLinea#">,
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">,
									 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, 'short')#">,
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">, 
									 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="Comision Bancaria">,  
									 ' ', ' ', 'D', 0, 0, 0, 0,
									 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(Comision,'9.99')#">),
									 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(Comision * rsFPago.Tipo_Cambio,'9.99')#">),
									 <cfqueryparam cfsqltype="cf_sql_float" value="#rsFPago.Tipo_Cambio#">, 
									 0, getdate(), 0, 
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDCB.CFformato#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMonedaPag#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
									 19)        
								</cfquery>
								<cfset IDlinea = IDlinea + 1>
							</cfif>
				   
						</cfloop> <!---Formas de Pago--->
						</cfif>
					</cfif> <!--- Parametro Prorrateo--->

					<!--- Inserta Movimientos de Poliza que son por detalle --->

					<!--- Insercion del Ingreso "LDIV" (Ingresos Ventas) --->
    	            <cfquery datasource="sifinterfaces">
        	        	insert into #TmpID18# 
							(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
                	         Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
                    	     Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
                        	 Oficodigo, Miso4217, CFcodigo,TipoOperacion)
	                    values 
						(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
	    	             <cfqueryparam cfsqltype="cf_sql_integer" value="#IDLinea#">,
    	    	         <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">,
        	    	     <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, 'short')#">,
            	    	 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">, 
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
    	                 <cfqueryparam cfsqltype="cf_sql_varchar" value="Ingresos de Ventas">, 
        	             ' ', ' ', 'C', 0, 0, 0, 0,
            	         abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Subtotal,'9.99')#">),
						 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Subtotal * rsEVentas.Tipo_Cambio,'9.99')#">),
						 <cfqueryparam cfsqltype="cf_sql_float" value="#rsEVentas.Tipo_Cambio#">,
						 0, getdate(), 0, 
    	                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDIV.CFformato#">,
        	             <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
            	         <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
                	     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
						 1)
	                </cfquery>  
					<cfset IDlinea = IDlinea + 1>
				</cfif> <!--- Ventas no Devolucion --->
				
				<cfif rsEVentas.Tipo_Venta EQ "D">	
					<!--- Insercion detalle "LDVD" (Ventas Devolucion) --->
 					<cfquery datasource="sifinterfaces">
                    	insert into #TmpID18#
							(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
                         	 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
                         	 Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
                         	 Oficodigo, Miso4217, CFcodigo, TipoOperacion)
                        values 
						(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
	    	             <cfqueryparam cfsqltype="cf_sql_integer" value="#IDLinea#">,
    	    	         <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">,
        	    	     <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, 'short')#">,
            	    	 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">, 
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="Devolucion de Ventas">, 
                         ' ', ' ', 'D', 0, 0, 0, 0,
                         abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Subtotal,'9.99')#">),
                         abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Subtotal,'9.99')#">),
                         1, 0, getdate(), 0, 
                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDVD.CFformato#">,
                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
            	         <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
                	     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
						 16)
                	</cfquery>
					<cfset IDlinea = IDlinea + 1>
					               
                	<!--- Insercion detalle "LDEF" (Efectivo en Caja) --->
                	<cfquery name="rsInsertaID18" datasource="sifinterfaces">
                    	insert into #TmpID18#
							(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
                             Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
                             Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
                             Oficodigo, Miso4217, CFcodigo, TipoOperacion)
                        values 
						(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
	    	             <cfqueryparam cfsqltype="cf_sql_integer" value="#IDLinea#">,
    	    	         <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">,
        	    	     <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, 'short')#">,
            	    	 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">, 
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">, 
                         <cfqueryparam cfsqltype="cf_sql_varchar" value="Efectivo en Caja">, 
                         ' ', ' ', 'C', 0, 0, 0, 0,
                         abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Subtotal,'9.99')#">),
                         abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Subtotal,'9.99')#">),
                         1, 0, getdate(), 0, 
                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDEF.CFformato#">,
                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
            	         <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
                	     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
						 17)
                	</cfquery>
					<cfset IDlinea = IDlinea + 1>                
				</cfif> <!--- Devoluciones no Ventas --->
				
				<cfif rsEVentas.Tipo_Venta EQ "C">	
					<!--- Insercion detalle "LDPF" (Pendientes de Facturar) --->
					<cfquery datasource="sifinterfaces">
						insert into #TmpID18#
							(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
        	            	 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
            	        	 Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
                	    	 Oficodigo, Miso4217, CFcodigo, TipoOperacion)
	                 	values 
						(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
	    		         <cfqueryparam cfsqltype="cf_sql_integer" value="#IDLinea#">,
    	    		     <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">,
        	    		 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, 'short')#">,
            	  		 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">, 
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
    	                 <cfqueryparam cfsqltype="cf_sql_varchar" value="Clientes Pendientes Facturar">, 
        	             ' ', ' ', 
						 'D', 0, 0, 0, 0,
                	     abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Subtotal,'9.99')#">),
						 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Subtotal * rsEVentas.Tipo_Cambio,'9.99')#">),
						 <cfqueryparam cfsqltype="cf_sql_float" value="#rsEVentas.Tipo_Cambio#">,
						 0, getdate(), 0, 
        	             <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDPF.CFformato#">,
            	         <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
            	         <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
                	     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
						 21)
	               	</cfquery>
        	        <cfset IDlinea = IDlinea + 1>
				</cfif> <!--- Ventas de Credito --->
				
				<!--- COSTO DE VENTAS VS ALMACEN --->
				<!--- Insercion del detalle "LDAV" (Contable Almacen Ventas) --->
 				<cfquery datasource="sifinterfaces">
                	insert into #TmpID18#
						(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
                    	 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
                    	 Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
                    	 Oficodigo, Miso4217, CFcodigo, TipoOperacion)
                 	values 
					(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
	    	         <cfqueryparam cfsqltype="cf_sql_integer" value="#IDLinea#">,
    	    	     <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">,
        	    	 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, 'short')#">,
            	  	 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">, 
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="Almacen Ventas">, 
                     ' ', ' ', 
					 <!--- Naturaleza del movimiento depende si es venta o devolucion --->
					 <cfif rsEVentas.Tipo_Venta NEQ "D">
						'C', 
					 <cfelse>
					 	'D',
					 </cfif>
					 0, 0, 0, 0,
                     abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Costo_Venta,'9.99')#">),
					 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Costo_Venta,'9.99')#">),
                     1, 0, getdate(), 0, 
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDAV.CFformato#">,
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
            	     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
                	 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
					 12)
                </cfquery>
                <cfset IDlinea = IDlinea + 1>
				
                <!--- Insercion del detalle en la ID18 con Origen Contable "LDCV" (Costo Ventas) --->
                <cfquery datasource="sifinterfaces">
                	insert into #TmpID18#
						(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
                    	 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
                    	 Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
                    	 Oficodigo, Miso4217, CFcodigo, TipoOperacion)
                 	values 
					(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
	    	         <cfqueryparam cfsqltype="cf_sql_integer" value="#IDLinea#">,
    	    	     <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">,
        	    	 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, 'short')#">,
            	  	 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">, 
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="Costo de Ventas">, 
                     ' ', ' ', 
					 <!--- Naturaleza del movimiento depende si es venta o devolucion --->
					 <cfif rsEVentas.Tipo_Venta NEQ "D">
						'D', 
					 <cfelse>
					 	'C',
					 </cfif>
					 0, 0, 0, 0,
                     abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Costo_Venta,'9.99')#">),
					 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Costo_Venta,'9.99')#">),
                     1, 0, getdate(), 0, 
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDCV.CFformato#">,
                      <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
           	         <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
               	     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
					 13)
                </cfquery>
				<cfset IDlinea = IDlinea + 1>

				<!--- LINEA PARA LOS IMPUESTOS --->
				<!--- Las Ventas de Credito no se toman para los Impuestos --->
				<cfif rsDVentas.Impuesto GT 0 and rsEVentas.Tipo_Venta NEQ "C">  
       	    		<!--- Busca equivalencia de IMPUESTO en SIF 
					<cfset Equiv = ConversionEquivalencia (rsEVentas.Origen, 'IMPUESTO', rsEVentas.Ecodigo, rsDVentas.Cod_Impuesto, 'Cod_Impuesto')>
					<cfset varImpuesto = Equiv.EQUcodigoSIF> --->
				
					<!--- Insercion del detalle de Impuesto "LDIP" (IVA Acreditable Pagado) --->
            	   	<cfquery name="rsInsertaID18" datasource="sifinterfaces">
						insert into #TmpID18# 
							(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
							Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
							Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
							Oficodigo, Miso4217, CFcodigo, TipoOperacion)
						values 
						(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#IDLinea#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, 'short')#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">, 
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="IVA Acreditable Pagado">, 
						 ' ', ' ', 
						 <!--- Naturaleza del movimiento depende si es venta o devolucion --->
					 	 <cfif rsEVentas.Tipo_Venta NEQ "D">
					  		'C', 
					 	 <cfelse>
					 		'D',
					 	 </cfif> 
						 0, 0, 0, 0,
						 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Impuesto,'9.99')#">),
						 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Impuesto * rsEVentas.Tipo_Cambio,'9.99')#">),
						 <cfqueryparam cfsqltype="cf_sql_float" value="#rsEVentas.Tipo_Cambio#">,
						 0, getdate(), 0, 
						 <cfif ParImp>
						 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#varCuentaImp#">,
						 <cfelse>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDIP.CFformato#">,
						 </cfif>
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
                    	 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMonedaPag#">,
	                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
						 2)
					</cfquery>
					<cfset IDlinea = IDlinea + 1>
				</cfif> <!--- Impuestos--->
				
				<!--- Descuento en Ventas --->
				<!--- Los descuentos solo aplican a ventas de contado --->
				<cfif rsDVentas.Descuento GT 0 and rsEVentas.Tipo_Venta NEQ "C" and rsEVentas.Tipo_Venta NEQ "D">
					<!--- DESCUENTOS SOBRE VENTAS  --->
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="LDVT"
						Ecodigo="#varEcodigo#"  
						Conexion="#session.dsn#"
						LDOperacion="DES"
						LDDepartamento="#rsDVentas.Tipo_Item#"
						LDClasificacion="#rsDVentas.Clas_Item#"
						LDFabricante="#rsDVentas.Cod_Fabricante#"
						LDTipoVenta="#rsEVentas.Tipo_Venta#"
						SNegocios="#varCte.sncodigo#"
						Impuestos="#varImpuesto#"
						Oficinas="#varOficina#"		
						LDConceptoRetiroCaja="NOUSAR"
						Almacen="NOUSAR"
						Bancos="#varBanco#"
						LDCuentaBanco="#varCuentaB#"
						LDMovimientoInventario="NOUSAR"
						LDAlmacen="NOUSAR"
						LDTipoRetiroCaja="NOUSAR"
					>
					</cfinvoke>	
					<cfset CuentaLDDE = Cuenta>
					
					<!--- Insercion del detalle de Impuesto "LDDE" (Descuentos Linea) --->
            	   	<cfquery name="rsInsertaID18" datasource="sifinterfaces">
						insert into #TmpID18# 
							(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
							Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
							Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
							Oficodigo, Miso4217, CFcodigo, TipoOperacion)
						values 
						(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#IDLinea#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, 'short')#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">, 
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="Descuento Linea">, 
						 ' ', ' ', 
					 	 'C', 0, 0, 0, 0,
						 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Descuento,'9.99')#">),
						 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Descuento * rsEVentas.Tipo_Cambio,'9.99')#">),
						 <cfqueryparam cfsqltype="cf_sql_float" value="#rsEVentas.Tipo_Cambio#">,
						 0, getdate(), 0, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDDE.CFformato#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
                    	 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMonedaPag#">,
	                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
						 2)
					</cfquery>
					<cfset IDlinea = IDlinea + 1>	
				</cfif>
				<!--- RUTINA IETU--->
				
			</cfloop> <!--- Detalle de Ventas --->
			</cfif>
			
			<!--- Si no se Prorratean las formas de pago --->
			<cfif ParPrrat EQ false>
				<!--- SELECCION DE REGISTROS DE DETALLE de Tipo de Pago--->
				<cfquery name="rsFPago" datasource="sifinterfaces" timeout="3600">
					select  Ecodigo, ID_DocumentoV, Id_Linea_Pago, Tipo_Pago, 
					isnull(Importe,0) as Importe, Moneda, Tipo_Cambio, Especial, 
					SocioDocumento, Comision_Porcentaje
					from SIFLD_Facturas_Tipo_Pago
					where Id_DocumentoV = <cfqueryparam cfsqltype="cf_sql_integer" value="#DocumentoFact#">
				</cfquery>
				<cfif isdefined("rsFPago") and rsFPago.recordcount GT 0>
				<cfloop query="rsFPago">
					<!--- MONEDA --->
					<cfset Equiv = ConversionEquivalencia (rsEVentas.Origen, 'MONEDA', rsEVentas.Ecodigo, rsFPago.Moneda, 'Moneda')>
					<cfset varMonedaPag = Equiv.EQUcodigoSIF>
					
					<!--- Manejo Casos Especiales --->
					<cfif rsFPago.Especial EQ 1>
						<!--- Obtiene cliente --->
						<cfset VarCteEsp = ExtraeCliente(rsFPago.SocioDocumento, varEcodigo)>
						<!--- La cuenta Deudores Diversos solo se usa para los Casos especiales de Forma de Pago--->
						<!--- Cta. Deudores Diversos  --->
						<!--- DEUDORES DIVERSOS --->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="LDVT"
							Ecodigo="#varEcodigo#"  
							Conexion="#session.dsn#"
							LDOperacion="DDV"
							LDDepartamento="#rsDVentas.Tipo_Item#"
							LDClasificacion="#rsDVentas.Clas_Item#"
							LDFabricante="#rsDVentas.Cod_Fabricante#"
							LDTipoVenta="#rsEVentas.Tipo_Venta#"
							SNegocios="#varCteEsp.SNcodigo#"
							Impuestos="#varImpuesto#"
							Oficinas="#varOficina#"		
							LDConceptoRetiroCaja="NOUSAR"
							Almacen="NOUSAR"
							Bancos="#varBanco#"
							LDCuentaBanco="#varCuentaB#"
							LDMovimientoInventario="NOUSAR"
							LDAlmacen="NOUSAR"
							LDTipoRetiroCaja="NOUSAR"
							>
						</cfinvoke>	       			
						<cfset CuentaLDDD = Cuenta>	
						
						<cfset RsMaximo = ExtraeMaximo("IE10","ID")> 
						<cfif isdefined("RsMaximo.Maximo") And RsMaximo.Maximo GT 0>
							<cfset MaximusEsp = RsMaximo.Maximo>
						<cfelse>
							<cfset MaximusEsp = 1>
						</cfif>
					
						<!--- Arma Numero Documento --->
						<cfset NumDocEsp = "ESP-#numberformat(MaximusEsp,"000000000")#">
					
						<!--- Se Debe Insertar un Documento en la Interfaz 10 para el socio indicado y el monto pagado --->
						<cfquery datasource="sifinterfaces">
							insert into IE10 
								(ID, EcodigoSDC, NumeroSocio, Modulo, CodigoTransacion, 
								 Documento, Estado, CodigoMoneda, FechaDocumento, FechaVencimiento,
								 DiasVencimiento, Facturado, Origen, VoucherNo, CodigoRetencion, 
								 CodigoOficina, CuentaFinanciera, CodigoConceptoServicio, 
								 CodigoDireccionEnvio, CodigoDireccionFact, BMUsucodigo, 
								 ConceptoCobroPago, StatusProceso, Dtipocambio)
							values (
								  <cfqueryparam cfsqltype ="cf_sql_numeric" value="#MaximusEsp#">,
								  <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo#">,
								  <cfqueryparam cfsqltype="cf_sql_varchar" value="#VarCteEsp.SNcodigo#">,
								  'CC',
								  'FC',
								  <cfqueryparam cfsqltype="cf_sql_varchar" value="#NumDocEsp#">, 
								  null, 
								  <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMonedaPag#">,
								  <cfqueryparam cfsqltype="cf_sql_date" value="#rsEVentas.Fecha_Venta#">, 
								  <cfqueryparam cfsqltype="cf_sql_date" value="#rsEVentas.Fecha_Venta#">, 
								  0,
								  'S', 
								  'LDCC', 
								  0, 
								  null,
								  <cfqueryparam cfsqltype="cf_sql_char" value="#VarOficina#">,
								  null, null, null, null, 1<!---VERIFICAR ABG--->,
								  null <!---VERIFICAR--->,
								  10, 
								  <cfqueryparam cfsqltype="cf_sql_float" value="#numberformat(rsFPago.Tipo_Cambio,'9.9999')#">)
						</cfquery> 

						<cfquery datasource="sifinterfaces">
							insert into ID10 
								(ID, Consecutivo, TipoItem, CodigoItem, NombreBarco, FechaHoraCarga, FechaHoraSalida,
								 PrecioUnitario, CodigoUnidadMedida, CantidadTotal, CantidadNeta, CodEmbarque, 
								 NumeroBOL, FechaBOL, TripNo, ContractNo, CodigoImpuesto, ImporteImpuesto, 
								 ImporteDescuento, CodigoAlmacen, CodigoDepartamento, CentroFuncional, 
								 CuentaFinancieraDet, BMUsucodigo, PrecioTotal)
							values 
							(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#MaximusEsp#">,
							  1, 
							  'S',  
							  'VENTAS',
							  ' ', getdate(), getdate(), 
							  <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsFPago.Importe,"9.99")#">,
							  ' ', 
							  1,
							  1, 
							  ' ', ' ', getdate(), ' ', ' ', 
							  null, 
							  null, 
							  null,
							  ' ',
							  ' ', 
							  <cfqueryparam cfsqltype="cf_sql_char" value="#varCF#">, 
							  <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDDD.CFformato#">,
							  1, 
							  <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsFPago.Importe,"9.99")#">)
						</cfquery>
					
						<!--- Introduce registro en la Cola de Procesos de la interfaz  --->             
						<cfquery datasource="sifinterfaces">
							insert #rsColaP# (ID,Ecodigo,Interfaz)
							values 
							(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#MaximusEsp#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo#">,
							 10)
						</cfquery>
					</cfif> <!---Casos Especiales--->
				
					<!--- Si el Documento tiene IVA, calcula el IVA correspondiente a Este Tipo de Pago --->
					<!---<cfif rsEVentas.Impuesto GT 0>
						<cfset PImpuesto = (rsFPago.Importe/rsEVentas.Total) * rsEVentas.Impuesto>
						<cfset Ingreso = rsFPago.Importe - PImpuesto>
					<cfelse> --->
						<cfset Ingreso = rsFPago.Importe>	
					<!---</cfif>--->
					<!--- Calcula y Quita el porcentaje de Comision al Ingreso --->
					<cfset Comision = rsFPago.Importe * rsFPago.Comision_Porcentaje>
					<cfset Ingreso = Ingreso - Comision>
					<!---Descripcion de la Poliza --->
					<cfif rsFPago.Tipo_Pago EQ "E">
						<cfset DescPol = "Efectivo">
					<cfelseif rsFPago.Tipo_Pago EQ "T">
						<cfset DescPol = "Tarjeta">
					<cfelseif rsFPago.Tipo_Pago EQ "V">
						<cfset DescPol = "Vales">
					<cfelseif rsFPago.Tipo_Pago EQ "H">
						<cfset DescPol = "Cheque">
					<cfelseif rsFPago.Tipo_Pago EQ "X">
						<cfset DescPol = "Moneda Extranjera">
					<cfelseif rsFPago.Tipo_Pago EQ "N">
						<cfset DescPol = "Nota de Credito">
					<cfelseif rsFPago.Tipo_Pago EQ "M">
						<cfset DescPol = "Monedero">
					<cfelseif rsFPago.Tipo_Pago EQ "P">
						<cfset DescPol = "Puntos">
					<cfelseif rsFPago.Tipo_Pago EQ "C">
						<cfset DescPol = "Co-Pago">
					</cfif>
					<cfif rsFPago.Especial EQ 1>
						<cfset DescPol = "Forma Pago Especial #DescPol#">
					</cfif>
					<!--- Cuentas Por tipo de Pago --->
					<cfif rsFPago.Tipo_Pago EQ "T" OR rsFPago.Tipo_Pago EQ "V" OR rsFPago.Tipo_Pago EQ "C">
						<!--- CUENTA BANCARIA  --->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="LDVT"
							Ecodigo="#varEcodigo#"  
							Conexion="#session.dsn#"
							LDOperacion="CBN"
							LDDepartamento="#rsDVentas.Tipo_Item#"
							LDClasificacion="#rsDVentas.Clas_Item#"
							LDFabricante="#rsDVentas.Cod_Fabricante#"
							LDTipoVenta="#rsEVentas.Tipo_Venta#"
							SNegocios="#varCte.sncodigo#"
							Impuestos="#varImpuesto#"
							Oficinas="#varOficina#"		
							LDConceptoRetiroCaja="NOUSAR"
							Almacen="NOUSAR"
							Bancos="#varBanco#"
							LDCuentaBanco="#varCuentaB#"
							LDMovimientoInventario="NOUSAR"
							LDAlmacen="NOUSAR"
							LDTipoRetiroCaja="NOUSAR"
						>
						</cfinvoke>
						<cfset CuentaLDBC = Cuenta>
						
						<!--- COMISIONES BANCARIAS  --->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="LDVT"
							Ecodigo="#varEcodigo#"  
							Conexion="#session.dsn#"
							LDOperacion="CMB"
							LDDepartamento="#rsDVentas.Tipo_Item#"
							LDClasificacion="#rsDVentas.Clas_Item#"
							LDFabricante="#rsDVentas.Cod_Fabricante#"
							LDTipoVenta="#rsEVentas.Tipo_Venta#"
							SNegocios="#varCte.sncodigo#"
							Impuestos="#varImpuesto#"
							Oficinas="#varOficina#"		
							LDConceptoRetiroCaja="NOUSAR"
							Almacen="NOUSAR"
							Bancos="#varBanco#"
							LDCuentaBanco="#varCuentaB#"
							LDMovimientoInventario="NOUSAR"
							LDAlmacen="NOUSAR"
							LDTipoRetiroCaja="NOUSAR"
						>
						</cfinvoke>
						<cfset CuentaLDCB = Cuenta>
					</cfif>
					
					<cfif rsFPago.Tipo_Pago EQ "N" OR rsFPago.Tipo_Pago EQ "M" OR rsFPago.Tipo_Pago EQ "P">
						<!--- DESCUENTOS SOBRE VENTAS  --->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="LDVT"
							Ecodigo="#varEcodigo#"  
							Conexion="#session.dsn#"
							LDOperacion="DSV"
							LDDepartamento="#rsDVentas.Tipo_Item#"
							LDClasificacion="#rsDVentas.Clas_Item#"
							LDFabricante="#rsDVentas.Cod_Fabricante#"
							LDTipoVenta="#rsEVentas.Tipo_Venta#"
							SNegocios="#varCte.sncodigo#"
							Impuestos="#varImpuesto#"
							Oficinas="#varOficina#"		
							LDConceptoRetiroCaja="NOUSAR"
							Almacen="NOUSAR"
							Bancos="#varBanco#"
							LDCuentaBanco="#varCuentaB#"
							LDMovimientoInventario="NOUSAR"
							LDAlmacen="NOUSAR"
							LDTipoRetiroCaja="NOUSAR"
						>
						</cfinvoke>	
						<cfset CuentaLDDV = Cuenta>
					</cfif>
					
					<!---Inserta el detalle a la poliza Para la Forma de Pago--->
					<cfquery datasource="sifinterfaces">
						insert into #TmpID18# (
							ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
							Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
							Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
							Oficodigo, Miso4217, CFcodigo,TipoOperacion)
						values 
						(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#IDLinea#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, 'short')#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">, 
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="Pago en #DescPol#">, 
						 ' ', ' ', 'D', 0, 0, 0, 0,
						 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(PIngreso,'9.99')#">),
						 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(PIngreso * rsFPago.Tipo_Cambio,'9.99')#">),
						 <cfqueryparam cfsqltype="cf_sql_float" value="#rsFPago.Tipo_Cambio#">,
						 0, getdate(), 0, 
						 <cfif rsFPago.Especial EQ 1>
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDDD.CFformato#">,
						 <cfelse>	
							 <cfif rsFPago.Tipo_Pago EQ "E">
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDEF.CFformato#">,
							 <cfelseif rsFPago.Tipo_Pago EQ "T">
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDBC.CFformato#">,
							 <cfelseif rsFPago.Tipo_Pago EQ "V">
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDBC.CFformato#">,
							 <cfelseif rsFPago.Tipo_Pago EQ "H">
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDEF.CFformato#">,
							 <cfelseif rsFPago.Tipo_Pago EQ "X">
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDEF.CFformato#">,
							 <cfelseif rsFPago.Tipo_Pago EQ "N">
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDDV.CFformato#">,
							 <cfelseif rsFPago.Tipo_Pago EQ "M">
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDDV.CFformato#">,
							 <cfelseif rsFPago.Tipo_Pago EQ "P">
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDDV.CFformato#">,
							 <cfelseif rsFPago.Tipo_Pago EQ "C">
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDBC.CFformato#">,
							 </cfif>
						 </cfif>
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMonedaPag#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
						 <cfif rsFPago.Especial EQ 1>
							 20
						 <cfelse>	
							 <cfif rsFPago.Tipo_Pago EQ "E">
								3
							 <cfelseif rsFPago.Tipo_Pago EQ "T">
								4
							 <cfelseif rsFPago.Tipo_Pago EQ "V">
								5
							 <cfelseif rsFPago.Tipo_Pago EQ "H">
								6
							 <cfelseif rsFPago.Tipo_Pago EQ "X">
								7
							 <cfelseif rsFPago.Tipo_Pago EQ "N">
								8
							 <cfelseif rsFPago.Tipo_Pago EQ "M">
								9
							 <cfelseif rsFPago.Tipo_Pago EQ "P">
								10
							 <cfelseif rsFPago.Tipo_Pago EQ "C">
								11
							 </cfif>
						 </cfif>)        
					</cfquery>
					<cfset IDlinea = IDlinea + 1>
				
					<cfif rsFPago.Comision_Porcentaje GT 0>
						<!--- Insercion de Comision Bancaria "LDCB" (Comisiones Bancarias) --->
						<cfquery name="rsInsertaFact_TPago" datasource="sifinterfaces">
							insert into #TmpID18#
								(
								 ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
								 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
								 Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
								 Oficodigo, Miso4217, CFcodigo, TipoOperacion)
							values 
							(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#IDLinea#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, 'short')#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">, 
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Comision Bancaria">,  
							 ' ', ' ', 'D', 0, 0, 0, 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(Comision,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(Comision * rsFPago.Tipo_Cambio,'9.99')#">),
							 <cfqueryparam cfsqltype="cf_sql_float" value="#rsFPago.Tipo_Cambio#">, 
							 0, getdate(), 0, 
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDCB.CFformato#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMonedaPag#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
							 19)        
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
					</cfif>
		   
				</cfloop> <!---Formas de Pago--->
				</cfif>
			</cfif> <!--- Parametro Prorrateo--->
			
			<!--- Manejo de los cambios de Factura --->
			<!--- Si el campo factura cambio es mayor de 0 y no existe la forma de pago efectivo, se realiza una salida 
			de efectivo en caja, reflejando el cambio dado--->
			<cfif rsEVentas.Factura_Cambio GT 0>
				<cfquery name="rsVerificaEfe" datasource="sifinterfaces">
					select count(1) as Efectivo
					from SIFLD_Facturas_Tipo_Pago
					where ID_DocumentoV = #DocumentoFact# 
					and Tipo_Pago like 'E'
				</cfquery>
				<cfif rsVerificaEfe.Efectivo LTE 0>
					<!--- CAMBIO EN EFECTIVO  --->
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="LDVT"
						Ecodigo="#varEcodigo#"  
						Conexion="#session.dsn#"
						LDOperacion="CEF"
						LDDepartamento="NOUSAR"
						LDClasificacion="NOUSAR"
						LDFabricante="NOUSAR"
						LDTipoVenta="#rsEVentas.Tipo_Venta#"
						SNegocios="#varCte.sncodigo#"
						Impuestos="NOUASR"
						Oficinas="#varOficina#"		
						LDConceptoRetiroCaja="NOUSAR"
						Almacen="NOUSAR"
						Bancos="#varBanco#"
						LDCuentaBanco="#varCuentaB#"
						LDMovimientoInventario="NOUSAR"
						LDAlmacen="NOUSAR"
						LDTipoRetiroCaja="NOUSAR"
					>
					</cfinvoke>	
					<cfset CuentaLDCE = Cuenta> 
					<cfquery name="rsInsertaID18" datasource="sifinterfaces">
						insert into #TmpID18# 
							(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
							Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
							Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
							Oficodigo, Miso4217, CFcodigo, TipoOperacion)
						values 
						(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#IDLinea#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta, 'short')#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">, 
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="Cambio en Efectivo">, 
						 ' ', ' ', 	'C', 0, 0, 0, 0,
						 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsEVentas.Factura_Cambio,'9.99')#">),
						 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsEVentas.Factura_Cambio,'9.99')#">),
						 1, 0, getdate(), 0, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDCE.CFformato#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
						 22)
					</cfquery>
				</cfif>
			</cfif>
			<!--- Marca o Borra las Tablas Origen Registro Procesado --->
			<!--- BORRADO DE TABLAS ORIGEN --->  
        	<cfquery name="rsBorraDet_FactVen" datasource="sifinterfaces"> 
        		<cfif Parborrado>
					delete 	DSIFLD_Facturas_Venta where Id_DocumentoV = #DocumentoFact# 
	           		delete 	SIFLD_Facturas_Tipo_Pago where Id_DocumentoV = #DocumentoFact# 
    	        	delete	ESIFLD_Facturas_Venta where Id_DocumentoV = #DocumentoFact#     
				<cfelse>
					update ESIFLD_Facturas_Venta 
					set Estatus = 
					case
						when Tipo_Venta = 'C' and Estatus = 1 then 5
						when Tipo_Venta = 'D' AND Tipo_CEDI = 'S' AND Estatus = 1 then 5
					else 2 end 
					where Id_DocumentoV = #DocumentoFact#
				</cfif>
        	</cfquery>    
 			
			<!--- Preceso de Carga Cola Interfaz SIF --->   
			<!---
			<cfquery name="rsInsertIE10" datasource="sifinterfaces">
				select * 
				from #rsColaP#
			</cfquery>        
			<cfif isdefined("rsInsertIE10") and rsInsertIE10.recordcount GT 0>
			<cfloop query="rsInsertIE10">
				<cfset disparaInterfaz(#rsInsertIE10.Interfaz#, #rsInsertIE10.ID#, #varEcodigo#,0)>
			</cfloop>	
			</cfif> --->
			
		<cfcatch type="any"> <!---Error en Ventas --->
        	<cfoutput>
				<table>
				<tr>
				<td>
				Error: #cfcatch.message#
				</td>
				</tr>
				<cfif isdefined("cfcatch.detail") AND len(cfcatch.detail) NEQ 0>
					<tr>
					<td>
					Detalles: #cfcatch.detail#
					</td>
					</tr>
				</cfif>
				<cfif isdefined("cfcatch.sql") AND len(cfcatch.sql) NEQ 0>
					<tr>
					<td>
					SQL: #cfcatch.sql#
					</td>
					</tr>
				</cfif>
				<cfif isdefined("cfcatch.queryError") AND len(cfcatch.queryError) NEQ 0>
					<tr>
					<td>
					QUERY ERROR: #cfcatch.queryError#
					</td>
					</tr>
				</cfif>
				<cfif isdefined("cfcatch.where") AND len(cfcatch.where) NEQ 0>
					<tr>
					<td>
					Parametros: #cfcatch.where#
					</td>
					</tr>
				</cfif>
				</table>
			</cfoutput>
			<!--- Marca El registro con Error--->
			<cfquery datasource="sifinterfaces">
				update ESIFLD_Facturas_Venta 
				set Estatus = 3
				where Id_DocumentoV = #DocumentoFact#
			</cfquery>
			
			<!--- Elimina Registros Insertados. Verifica si se grabo algo en las tablas --->
			<cfif isdefined("Maximus")>
				<cfquery datasource="sifinterfaces">
					delete #TmpID18#
					where 
					<cfif isdefined("IDstart")>
						DCIconsecutivo > <cfqueryparam cfsqltype ="cf_sql_numeric" value="#IDstart#">
					<cfelse>
						ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
					</cfif>
				</cfquery>
				<cfif not isdefined("IDstart")>
					<cfquery datasource="sifinterfaces">
						delete #TmpIE18#
						where 
						ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
					</cfquery>
					<cfquery datasource="sifinterfaces">
						update IdProceso
						set Consecutivo = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#"> - 1
					</cfquery>
				</cfif>
			</cfif>
			<cfquery name="rsInsertIE10" datasource="sifinterfaces">
				select * 
				from #rsColaP#
			</cfquery>        
			<cfif isdefined("rsInsertIE10") and rsInsertIE10.recordcount GT 0>
				<cfquery datasource="sifinterfaces">
					update IdProceso
					set Consecutivo = Consecutivo - #rsInsertIE10.recordcount#
				</cfquery>
				<cfloop query="rsInsertIE10">
					<cfquery datasource="sifinterfaces">
						delete ID10
						where ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#rsInsertIE10.ID#">
					</cfquery>
					<cfquery datasource="sifinterfaces">
						delete IE10
						where ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#rsInsertIE10.ID#">
					</cfquery>
				</cfloop>	
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
            
			<cfquery datasource="sifinterfaces">
				insert into SIFLD_Errores 
				(Interfaz, Tabla, ID_Documento, MsgError, MsgErrorDet, MsgErrorSQL, MsgErrorParam)
				values 
				('CG_Ventas', 
				 'ESIFLD_Facturas_Venta',
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#DocumentoFact#">, 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">)
			</cfquery>
		</cfcatch>
		</cftry>
		</cfloop> <!--- Encabezados Ventas --->
		</cfif>
		<!--- Limite --->
		<cfquery name="rsLimiteE" datasource="sifinterfaces">
			select isnull(max(ID),0) as MaxID
			from #TmpIE18#
		</cfquery>
		<cfif rsLimiteE.MaxID GT 0>
			<!--- Inserta En las Interfaces --->
			<cfquery name="rsIE18V" datasource="sifinterfaces">
				insert into IE18 
					(ID, Ecodigo, Cconcepto, Eperiodo, Emes, Efecha,
					 Edescripcion, Edocbase, Ereferencia, Falta, Usuario)
				select 
					ID, Ecodigo, Cconcepto, Eperiodo, Emes, Efecha,
					Edescripcion, Edocbase, Ereferencia, Falta, Usuario
				from #TmpIE18#
			</cfquery>
			<cfif ParAgrupa>
				<cf_dbtemp name="ID18Datos" returnvariable="ID18Datos" datasource="sifinterfaces">
					<cf_dbtempcol name="ID" type="numeric">
					<cf_dbtempcol name="DCIconsecutivo" type="int">
					<cf_dbtempcol name="Ecodigo" type="int">
					<cf_dbtempcol name="DCIEfecha" type="datetime">
					<cf_dbtempcol name="Eperiodo" type="int">
					<cf_dbtempcol name="Emes" type="int">
					<cf_dbtempcol name="Ddescripcion" type="varchar(100)">
					<cf_dbtempcol name="Ddocumento" type="varchar(20)">
					<cf_dbtempcol name="Dreferencia" type="varchar(25)">
					<cf_dbtempcol name="Dmovimiento" type="char(1)">
					<cf_dbtempcol name="Ccuenta" type="numeric">
					<cf_dbtempcol name="CFcuenta" type="numeric">
					<cf_dbtempcol name="Ocodigo" type="int">
					<cf_dbtempcol name="Mcodigo" type="numeric">
					<cf_dbtempcol name="Doriginal" type="money">
					<cf_dbtempcol name="Dlocal" type="money">
					<cf_dbtempcol name="Dtipocambio" type="float">
					<cf_dbtempcol name="Cconcepto" type="int">
					<cf_dbtempcol name="BMfalta" type="datetime">
					<cf_dbtempcol name="EcodigoRef" type="int">
					<cf_dbtempcol name="CFformato" type="varchar(100)">
					<cf_dbtempcol name="Oficodigo" type="char(10)">
					<cf_dbtempcol name="Miso4217" type="char(3)">
					<cf_dbtempcol name="Referencia1" type="char(20)">
					<cf_dbtempcol name="Referencia2" type="char(20)">
					<cf_dbtempcol name="Referencia3" type="char(20)">
					<cf_dbtempcol name="CFcodigo" type="char(20)">
				</cf_dbtemp>
				<cfquery datasource="sifinterfaces">
					insert into #ID18Datos#
						(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
						 Ddescripcion, Ddocumento, Dreferencia, Dmovimiento, Ccuenta,
						 CFcuenta, Ocodigo, Mcodigo, Doriginal, Dlocal, Dtipocambio,
						 Cconcepto, BMfalta, EcodigoRef, CFformato, Oficodigo, Miso4217,
						 Referencia1, Referencia2, Referencia3, CFcodigo)
					select a.ID, 0 as Consecutivo, b.Ecodigo, getdate(), b.Eperiodo, b.Emes,
						a.Ddescripcion, '','', a.Dmovimiento, null,
						null, null, null, a.Monto, a.Local, a.Dtipocambio, 
						0, getdate(), b.EcodigoRef, a.CFformato, b.Oficodigo, a.Miso4217,
						null, null, null, b.CFcodigo
					from 
						(select 
							ID, Ddescripcion, sum(Doriginal) as Monto , sum(Dlocal) as Local, Dtipocambio,
							Dmovimiento,CFformato, Miso4217, TipoOperacion
						from #TmpID18#
						group by ID, TipoOperacion, Dmovimiento, Ddescripcion, CFformato, Miso4217, Dtipocambio) a
					inner join 
						(select distinct
							ID, Ecodigo, getdate() as DCIEfecha, Eperiodo, Emes,
							Ddescripcion, Dmovimiento, Ccuenta,
							Cconcepto, EcodigoRef, CFformato, Oficodigo, 
							Miso4217, Dtipocambio, CFcodigo, TipoOperacion
						from #TmpID18#) b
					on a.ID = b.ID 
					and a.TipoOperacion = b.TipoOperacion
					and a.Dmovimiento = b.Dmovimiento
					and a.Ddescripcion = b.Ddescripcion
					and a.CFformato = b.CFformato
					and a.Miso4217 = b.Miso4217
					and a.Dtipocambio = b.Dtipocambio
				</cfquery>
				<!--- Actualiza fecha y tipo cambio --->
				<cfloop from="1" to="#rsLimiteE.MaxID#" index="ID">
					<cfquery datasource="sifinterfaces">
						declare @IDlinea as int
						select @IDlinea = 0
						update #ID18Datos#
						set @IDlinea = @IDlinea + 1,
						DCIconsecutivo = @IDlinea, DCIEfecha = e.Efecha
						from #ID18Datos# d, #TmpIE18# e
						where d.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ID#">
						and d.ID = e.ID
					</cfquery>
				</cfloop>
				<cfquery name="rsID18V" datasource="sifinterfaces">
					insert into ID18 
						(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
						 Ddescripcion, Ddocumento, Dreferencia, Dmovimiento, Ccuenta,
						 CFcuenta, Ocodigo, Mcodigo, Doriginal, Dlocal, Dtipocambio,
						 Cconcepto, BMfalta, EcodigoRef, CFformato, Oficodigo, Miso4217,
						 Referencia1, Referencia2, Referencia3, CFcodigo)
					select 
						ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
						Ddescripcion, Ddocumento, Dreferencia, Dmovimiento, Ccuenta,
						CFcuenta, Ocodigo, Mcodigo, Doriginal, Dlocal, Dtipocambio,
						Cconcepto, BMfalta, EcodigoRef, CFformato, Oficodigo, Miso4217,
						Referencia1, Referencia2, Referencia3, CFcodigo
					from #ID18Datos#
				</cfquery>
			<cfelse>
				<cfquery name="rsID18V" datasource="sifinterfaces">
					insert into ID18 
						(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
						 Ddescripcion, Ddocumento, Dreferencia, Dmovimiento, Ccuenta,
						 CFcuenta, Ocodigo, Mcodigo, Doriginal, Dlocal, Dtipocambio,
						 Cconcepto, BMfalta, EcodigoRef, CFformato, Oficodigo, Miso4217,
						 Referencia1, Referencia2, Referencia3, CFcodigo)
					select 
						ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
						Ddescripcion, Ddocumento, Dreferencia, Dmovimiento, Ccuenta,
						CFcuenta, Ocodigo, Mcodigo, Doriginal, Dlocal, Dtipocambio,
						Cconcepto, BMfalta, EcodigoRef, CFformato, Oficodigo, Miso4217,
						Referencia1, Referencia2, Referencia3, CFcodigo
					from #TmpID18#
				</cfquery>
			</cfif>
			<!--- Dispara Interfaz --->
			<!---
			<!--- Limites --->
			<cfquery name="rsLimite" datasource="sifinterfaces">
				select min(ID) as ID, max(ID) as ID2
				from #TmpIE18#
			</cfquery>
			<cfset disparaInterfaz(18, #rsLimite.ID#, varEcodigo,1,#rsLimite.ID2#)> --->
		</cfif>
		<cfoutput>
			Hora Fin: #now()#
		</cfoutput>
	</cffunction>
</cfcomponent>