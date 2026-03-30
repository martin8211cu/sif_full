<cfcomponent extends="Interfaz_Base">
	<cffunction name="Ejecuta" access="public" returntype="string" output="yes">
    		<!--- toma registros cabecera de las Ventas --->
            <cfquery name="rsCab_FactVen" datasource="sifinterfaces">
                      select Ecodigo, Origen, Id_DocumentoV, Tipo_Documento, Tipo_Venta, Fecha_Venta, Numero_Documento, Cliente, IETU_Clas, Subtotal, Descuento, Impuesto,                                      Total, Vendedor,Sucursal, Dias_Credito, Moneda, Tipo_Cambio, Direccion_Facturacion, Retencion, Observaciones, Tipo_Cedi
                      from ESIFLD_Facturas_Venta
                      where ((StatusError <> 1) or (StatusError is null))
            </cfquery>

        <cfloop query="rsCab_FactVen">
            <cfset DocumentoFact = '0'>
            <cfset StrCat = ''>
            <cfset CampoError = ''>
            <cfset NoLinea = 0>
            
            <cfset ConexionBase = getConexion(#rsCab_FactVen.Ecodigo#)>

            <cftry>
                    <cfset DocumentoFact = rsCab_FactVen.Id_DocumentoV>
					<cfset Fecha = rsCab_FactVen.Fecha_Venta>
           <!---         <cfset Periodo = year(rsCab_FactVen.Fecha_Venta)>
                    <cfset Mes = month(rsCab_FactVen.Fecha_Venta)>  --->
                    <cfset NumeroDoc = rsCab_FactVen.Numero_Documento>
                    
                    <!--- Busca equivalencia de Sucursal en SIF --->
					<cfset sifSUC = ConversionEquivalencia (rsCab_FactVen.Origen, 'SUCURSAL', rsCab_FactVen.Ecodigo, rsCab_FactVen.Sucursal, 'Sucursal')>
                    <cfset EcodigoSDC  = sifSUC.EQUempSIF>
                  
                  	<!--- Busca equivalencia de Centro Funcional en SIF --->
					<cfset sifCF = ConversionEquivalencia (rsCab_FactVen.Origen, 'CENTRO_FUN', rsCab_FactVen.Ecodigo, rsCab_FactVen.Sucursal, 'Centro_Funcional')>
                    
					<!--- , 'CLIENTE', 'ECODIGO' --->
	                <cfset CamposCte = ExtraeCliente(rsCab_FactVen.Cliente, #EcodigoSDC#)>
                    
                    
                     <!--- Busca Periodo en Minisif --->
                    <cfquery name="BuscaPeriodo" datasource="#getConexion(EcodigoSDC)#">
                    	SELECT Pvalor FROM Parametros WHERE Ecodigo = #EcodigoSDC# AND Pcodigo = 50
                    </cfquery>
                    <cfset Periodo = #BuscaPeriodo.Pvalor#>
					
                    <!--- Busca Mes en Minisif --->
					<cfquery name="BuscaMes" datasource="#getConexion(EcodigoSDC)#">
                    	SELECT Pvalor FROM Parametros WHERE Ecodigo = #EcodigoSDC# AND Pcodigo = 60
                    </cfquery>
                    <cfset Mes = #BuscaMes.Pvalor#>
                    
        <!---            <cfdump var="'*******************************************'">
                    <cfdump var="#getEcodigo(EcodigoSDC)#">
                    <cfdump var="#Periodo#">
                    <cfdump var="#Mes#">  --->
                    
                  	<!---  1 = Credito,   2 = Poliza de Contado,  3 = Devolucion  --->
                  	<cfif rsCab_FactVen.Tipo_Venta EQ "C">   
	                  	<cfset TipoVta = "01">
                        <cfset DescPoliza = "Credito">
                        <cfif rsCab_FactVen.cliente EQ "AMEX" or mid(rsCab_FactVen.cliente,1,4) EQ "VALE" or mid(rsCab_FactVen.cliente,1,4) EQ "COPA">
                        	<cfset DescPoliza = "Contado">
                        </cfif>
					<cfelseif rsCab_FactVen.Tipo_Venta EQ "P">
                    	<cfset TipoVta = "02">
                        <cfset DescPoliza = "Contado">
                    <cfelseif rsCab_FactVen.Tipo_Venta EQ "D">
                    	<cfset TipoVta = "03">
                        <cfset DescPoliza = "Devolucion">  
  					<cfelseif rsCab_FactVen.Tipo_Venta EQ "S">
                    	<cfset TipoVta = "04">
                        <cfset DescPoliza = "Contado-Domicilio">                          
                    </cfif>

					<!--- Extrae Maximo+1 de tabla IE18 para insertar nuevo reg, en IE18 ---> 
                    <cfset RsMaximo = ExtraeMaximo("IE18","ID")> 
                    
                    <cfif isdefined(#RsMaximo.Maximo#) or #RsMaximo.Maximo# gt 0>
							<cfset Maximus = #RsMaximo.Maximo#>
                	<cfelse>
                    		<cfset Maximus = 1>
                	</cfif>
                    
                    <!--- Nombre Cliente --->
                    <cfset ClienteX = mid(#rsCab_FactVen.Cliente#,1,4)>

                    <cfif ClienteX eq "VALE">
                        <cfset Cte = "VALE">
                    <cfelseif ClienteX eq "COPA">
                        <cfset Cte = "COPA">
                    <cfelseif ClienteX eq "AMEX">
                        <cfset Cte = "AMEX">
                    <cfelse>
                    	<cfset Cte = "INGRE">
                    </cfif>
                     
                         <!--- Insercion de cabecera en IE18 --->
                         <!---ABG: Para tener todos los detalles de la Poliza de Ventas Juntos busca si ya existe el encabezado para la
						 poliza si no existe lo inserta --->
                         <cfquery name="rsVerificaEnc" datasource="sifinterfaces">
                         	select ID 
                            from IE18 
                            where Ecodigo = <cfqueryparam cfsqltype ="cf_sql_integer" value="#getEcodigo(EcodigoSDC)#">
                            and Cconcepto = 0
                            and Eperiodo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Periodo#">
                            and Emes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mes#">
                            and Fecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha#">
                            and Edocbase = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Cte# - #NumeroDoc#">
                         </cfquery>
                         <cfif isdefined("rsVerificaEnc.ID") AND rsVerificaEnc.recordcount = 1 AND rsVerificaEnc.ID NEQ "" and rsVerificaEnc.ID NEQ 0>
							<cfset VerificaEnc = true>
                         	<cfset Maximus = rsVerificaEnc.ID>
                            <!---Busca el numero de Linea para el ID --->
                            <cfquery name="rsVerificaLinea" datasource="sifinterfaces">
                            	select MAX(DCIconsecutivo) as Linea
                                from ID18 
                                where ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Maximus#">
                            </cfquery>
                            <cfif isdefined("rsVerificaLinea.Linea") AND rsVerificaLinea.recordcount = 1 AND rsVerificaLinea.Linea NEQ "" and rsVerificaLinea.Linea NEQ 0>
                            	<cfset NoLinea = rsVerificaLinea.Linea>
                            </cfif>
						 <cfelse>
                         	<cfquery name="rsInsertaIE18" datasource="sifinterfaces">
                            	insert into IE18 (ID, Ecodigo, Cconcepto, Eperiodo, Emes, Efecha, Edescripcion, Edocbase, Ereferencia, Falta, Usuario)
	                            values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
    	                                <cfqueryparam cfsqltype ="cf_sql_integer" value="#getEcodigo(EcodigoSDC)#">, 0,
        	                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Periodo#">,
            	                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mes#">,
                	                    <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha#">,
                    	                <cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de Venta #DescPoliza# #rsCab_FactVen.Cliente#">,
                        	            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Cte# - #NumeroDoc#">,
                            	        ' ', getdate(), '0')
	                        </cfquery>  
                        </cfif>
                     
                    <!--- SELECCION DE REGISTROS DE DETALLE --->        
                    <cfquery name="rsDet_FactVen" datasource="sifinterfaces">
                        select
                        	Ecodigo, ID_DocumentoV, Id_Linea, Tipo_Lin, Tipo_Item,
                        	isnull(Subtotal_Lin,0) as Subtotal, isnull(Impuesto_Lin, 0) as Impuesto, Cod_Impuesto, Clas_Item, Cod_Fabricante, Costo_Venta
                        	from DSIFLD_Facturas_Venta
                        where Id_DocumentoV = #DocumentoFact#
                    </cfquery>
                    
		<!--- DECLARA ARREGLO DE CUENTA CONTABLE --->
		<cfset CuentaLDIV = ArrayNew(1)>	<!--- Cta. Ventas doc. Contable						(Haber)		--->
  		<cfset CuentaLDIP = ArrayNew(1)>	<!--- Cta. IVA Acreditable							(Haber)		--->
  		<cfset CuentaLDAV = ArrayNew(1)>  	<!--- Cta. Inventario doc. Contable Costo Ventas	(Haber)		--->
  		<cfset CuentaLDCV = ArrayNew(1)> 	<!--- Cta. Ventas doc. Contable						(Debe)		--->
  		<cfset CuentaLDDD = ArrayNew(1)>	<!--- Cta. Deudores Diversos						(Debe)		--->
  		<cfset CuentaLDCB = ArrayNew(1)>    <!--- Cta. Para Gastos Financieros comis.banc.		(Debe)      --->
        <cfset CuentaLDCF = ArrayNew(1)>	<!--- Cta. Ctes. pendientes por facturar			(Haber)		--->
        <cfset CuentaLDVD = ArrayNew(1)>	<!--- Cta. Ventas Devolucion 						(Haber)		--->
        <cfset CuentaLDEF = ArrayNew(1)>	<!--- Cta. Efectivo en Caja							(Haber)		--->
        
        <!--- DECLARA ARREGLO DE CUENTA CONTABLE PARA PAGOS --->
        
        <cfset CuentaLDEF = ArrayNew(1)>		<!--- Cta. Efectivo en Caja Doctos Contables		(Debe)		--->
        <cfset CuentaLDBC = ArrayNew(1)>		<!--- Cta. Bancos Cuentas							(Debe)		--->
        <cfset CuentaLDDV = ArrayNew(1)>		<!--- Cta. Descuento sobre Ventas					(Debe)		--->
        <cfset CuentaLDCB_Pago = ArrayNew(1)>	<!--- Cta. Para Gastos Financieros comis.banc.		(Debe)		--->
        <cfset CuentaLDDD_Pago = ArrayNew(1)>	<!--- Cta. Deudores Diversos						(Debe)		--->
        
        <cfset session.dsn = getConexion(EcodigoSDC)>

		<!--- POR CADA REGISTRO DE DETALLE BUSCARA EL ORIGEN CONTABLE --->
       <cfloop query = "rsDet_FactVen">
       		<!--- Busca equivalencia de IMPUESTO en SIF --->
			<cfset sifIMP = ConversionEquivalencia (rsCab_FactVen.Origen, 'IMPUESTO', rsCab_FactVen.Ecodigo, rsDet_FactVen.Cod_Impuesto, 'Cod_Impuesto')>
            
            <!--- BUSCA EQUIVALENCIA DE CUENTA BANCARIA PARA LA SUCURSAL EN CASO DE QUE NO EXISTA IRA POR LA 
					EQUIVALENCIA DE CUENTA BANCARIA POR EMPRESA  --->
            
            <!--- ABG: la funcion ConversionEquivalencia busca la equivalencia en caso de que falle regresa un CFthrow lo que hace
			que falle el try principal, en este punto si falla no va y busca la cuenta de BacoEmpresa sino que falla el registro y lo marcaria 
			como error.
			Se realiza un cftry para que en el catch busque la cuenta de BancoEmpresa --->
            <cftry>
				<cfset sifCTASUC = ConversionEquivalencia (rsCab_FactVen.Origen, 'CTA_BANSUC', rsCab_FactVen.Ecodigo, rsCab_FactVen.Sucursal, 'Cuenta_Banco_Sucursal')>
                <cfset ctaTipo = 'Cuenta_Banco_Sucursal'>
            <cfcatch>
            	<cfset sifCTAEMP = ConversionEquivalencia (rsCab_FactVen.Origen, 'CTA_BANEMP', rsCab_FactVen.Ecodigo, rsCab_FactVen.Ecodigo, 'Cuenta_Banco_Empresa')>
                <cfset ctaTipo = 'Cuenta_Banco_Empresa'>	
            </cfcatch>
            </cftry>
            <cfquery name="rsCta_BancoS" datasource="#ConexionBase#">
            	select CBid, Bid from CuentasBancos
                	where CBid = #sifCTASUC.EQUcodigoSIF#
            </cfquery>
            
            <!---ABG: Valida que la cuenta Bancaria indicada en la equivalencia Exista Realmente --->
            <cfif rsCta_BancoS.recordcount EQ 0>
            	<cfthrow message="La cuenta parametrizada en la Equivalencia #ctaTipo# NO existe"> 
            </cfif>
                        
            <cfset CuentaB = rsCta_BancoS.CBid>
            <cfset Banco = rsCta_BancoS.Bid>
            
            
     <!---       <cfdump var="#CuentaB#">
            <cfdump var="#Banco#">  --->
            
            <!--- ------ ------ ------ -------- --------- ------- ----->
            
            <!--- Cta. IVA Acreditable	--->
                <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                        Oorigen="LDIP"
                        Ecodigo="#getEcodigo(EcodigoSDC)#"  
                        Conexion="#getConexion(EcodigoSDC)#"
                        Impuestos="#numberformat(rsDet_FactVen.Cod_Impuesto, '00')#"
                        >
                </cfinvoke>     				
                 <cfset ArrayAppend(CuentaLDIP, Cuenta)>
            
            
		   <!--- Cta. Ingreso de Ventas  --->
                <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                      Oorigen="LDIV"
                      Ecodigo="#getEcodigo(EcodigoSDC)#"  
                      Conexion="#getConexion(EcodigoSDC)#"
                      LDTipoVenta="#TipoVta#"					
                      LDDepartamento="#NumberFormat(rsDet_FactVen.Tipo_Item, '00')#"
                      SNegocios="#CamposCte.sncodigo#"
                      Impuestos="#numberformat(rsDet_FactVen.Cod_Impuesto, '00')#"
                      LDClasificacion="#NumberFormat(rsDet_FactVen.Clas_Item, '00')#"
                      LDFabricante="#NumberFormat( rsDet_FactVen.Cod_Fabricante, '00')#"
                      LDTipoCliente="#CamposCte.TipoCte#"
                      >
                </cfinvoke>          			
                <cfset ArrayAppend(CuentaLDIV, Cuenta)> 
            
       
       		<cfif rsCab_FactVen.Tipo_Venta EQ "P" or rsCab_FactVen.Tipo_Venta EQ "D" or rsCab_FactVen.Tipo_Venta EQ "S" or
								(rsCab_FactVen.Tipo_Venta EQ "C" and (rsCab_FactVen.cliente EQ "AMEX" or mid(rsCab_FactVen.cliente,1,4) EQ "VALE" 
								or mid(rsCab_FactVen.cliente,1,4) EQ "COPA"))>  
                
                <cfif #TipoVta# eq '01'>
                	<cfset #TipoVta# = '02'>
                </cfif>
                    
                <!--- Cta. Almacen de Ventas --->
                <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                      Oorigen="LDAV"
                      Ecodigo="#getEcodigo(EcodigoSDC)#"  
                      Conexion="#getConexion(EcodigoSDC)#"
                      LDDepartamento="#NumberFormat(rsDet_FactVen.Tipo_Item, '00')#"
                      LDClasificacion="#NumberFormat(rsDet_FactVen.Clas_Item, '00')#"
                      LDFabricante="#NumberFormat( rsDet_FactVen.Cod_Fabricante, '00')#"
                      >
                </cfinvoke>          			
                <cfset ArrayAppend(CuentaLDAV, Cuenta)>
                
                <!--- Cta. Costo de Ventas --->
                <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                      Oorigen="LDCV"
                      Ecodigo="#getEcodigo(EcodigoSDC)#"  
                      Conexion="#getConexion(EcodigoSDC)#"
                      LDTipoVenta="#TipoVta#"
                      LDDepartamento="#NumberFormat(rsDet_FactVen.Tipo_Item, '00')#"
                      SNegocios="#CamposCte.sncodigo#"
                      LDClasificacion="#NumberFormat(rsDet_FactVen.Clas_Item, '00')#"
                      LDFabricante="#NumberFormat( rsDet_FactVen.Cod_Fabricante, '00')#"
                      LDTipoCliente="#CamposCte.TipoCte#"
                      >
                </cfinvoke>          			
                <cfset ArrayAppend(CuentaLDCV, Cuenta)> 
                
				<cfif rsCab_FactVen.Tipo_Venta EQ "D">     
						  <!--- Cta. Ventas Devolucion  --->
                          <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                                Oorigen="LDVD"
                                Ecodigo="#getEcodigo(EcodigoSDC)#"  
                                Conexion="#getConexion(EcodigoSDC)#"
                                LDTipoVenta="#TipoVta#"					
                                LDDepartamento="#NumberFormat(rsDet_FactVen.Tipo_Item, '00')#"
                                SNegocios="#CamposCte.sncodigo#"
                                Impuestos="#numberformat(rsDet_FactVen.Cod_Impuesto, '00')#"
                                >
                          </cfinvoke>          			
                          <cfset ArrayAppend(CuentaLDVD, Cuenta)> 
                          
                          <!--- Cta. Efectivo en Caja --->
                          <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                                Oorigen="LDEF"
                                Ecodigo="#getEcodigo(EcodigoSDC)#"  
                                Conexion="#getConexion(EcodigoSDC)#"
                                >
                          </cfinvoke>          			
                          <cfset ArrayAppend(CuentaLDEF, Cuenta)>         
                </cfif>                
                
            </cfif>
            
            <cfif rsCab_FactVen.Tipo_Venta EQ "C">
            
            	<!--- Si tipo Cliente es "AMEX" o "VALE" o "COPAGO" --->
                <cfif rsCab_FactVen.cliente EQ "AMEX" or mid(rsCab_FactVen.cliente,1,4) EQ "VALE" or mid(rsCab_FactVen.cliente,1,4) EQ "COPA"> 
                
                	<!--- Cta. Deudores Diversos  --->
                    <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                          Oorigen="LDDD"
                          Ecodigo="#getEcodigo(EcodigoSDC)#"  
                          Conexion="#getConexion(EcodigoSDC)#"
                          SNegocios="#CamposCte.sncodigo#"
                          >
                    </cfinvoke>          			
                    <cfset ArrayAppend(CuentaLDDD, Cuenta)> 
                    
                    <cfif rsCab_FactVen.cliente EQ "AMEX">
						  <!--- Cta. Comisiones Bancarias  --->
                          <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                                Oorigen="LDCB"
                                Ecodigo="#getEcodigo(EcodigoSDC)#"  
                                Conexion="#getConexion(EcodigoSDC)#"
                                >
                          </cfinvoke>          			
                          <cfset ArrayAppend(CuentaLDCB, Cuenta)>
                    </cfif> 
            	</cfif>                 
         	</cfif>  
         </cfloop>

		 <!--- SELECCION DE REGISTROS DE DETALLE de Tipo de Pago--->
         <cfquery name="rsFact_TPago" datasource="sifinterfaces" timeout="3600">
                        select  Ecodigo, ID_DocumentoV, Id_Linea_Pago, Tipo_Pago, isnull(Importe,0) as Importe
                        	from SIFLD_Facturas_Tipo_Pago
                        where Id_DocumentoV = #DocumentoFact#
         </cfquery>
         
         <cfloop query = "rsFact_TPago">
			 <!--- Cta. Efectivo en Caja Doctos Contables --->
             <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                      Oorigen="LDEF"
                      Ecodigo="#getEcodigo(EcodigoSDC)#"  
                      Conexion="#getConexion(EcodigoSDC)#"
                      >
             </cfinvoke> 	
             <cfset ArrayAppend(CuentaLDEF, Cuenta)> 	
             
             <!--- Cta. Bancos Cuentas --->
             <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                      Oorigen="LDBC"
                      Ecodigo="#getEcodigo(EcodigoSDC)#"  
                      Conexion="#getConexion(EcodigoSDC)#"
                      Bancos="#NumberFormat(Banco, '0')#"
                      CuentasBancos="#NumberFormat(CuentaB, '0')#"
                      >
             </cfinvoke> 	
             <cfset ArrayAppend(CuentaLDBC, Cuenta)> 
             
             <!--- Cta. Descuento sobre Ventas --->
             <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                      Oorigen="LDDV"
                      Ecodigo="#getEcodigo(EcodigoSDC)#"  
                      Conexion="#getConexion(EcodigoSDC)#"
                      LDTipoVenta="#TipoVta#"
                      LDDepartamento="#NumberFormat(rsDet_FactVen.Tipo_Item, '00')#"
                      SNegocios="#CamposCte.sncodigo#"
                      Impuestos="#numberformat(rsDet_FactVen.Cod_Impuesto, '00')#"
                      >
             </cfinvoke> 	
             <cfset ArrayAppend(CuentaLDDV, Cuenta)> 
             	 
             <!--- Cta.  Comisiones Bancarias --->
             <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                      Oorigen="LDCB"
                      Ecodigo="#getEcodigo(EcodigoSDC)#"  
                      Conexion="#getConexion(EcodigoSDC)#"
                      >
             </cfinvoke> 	
             <cfset ArrayAppend(CuentaLDCB_Pago, Cuenta)> 
             
             <!--- Cta. Deudores Diversos --->
             <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                      Oorigen="LDDD"
                      Ecodigo="#getEcodigo(EcodigoSDC)#"  
                      Conexion="#getConexion(EcodigoSDC)#"
                      SNegocios="#CamposCte.sncodigo#"
                      >
             </cfinvoke> 	
             <cfset ArrayAppend(CuentaLDDD_Pago, Cuenta)>     
                 
         </cfloop>
             
        <!--- Inicia Insercion de Detalles --->
	<cftransaction>
       <cfloop query = "rsDet_FactVen"> 
       
       		<!--- Busca equivalencia de IMPUESTO en SIF --->
            <!---ABG: Importante dar de alta una equivalencia para impuesto codigo 0, relacionado a un codigo con porcentaje 0 de impuesto
			para los casos donde en origen la venta no tiene Impuesto Asignado --->
			<cfset sifIMP = ConversionEquivalencia (rsCab_FactVen.Origen, 'IMPUESTO', rsCab_FactVen.Ecodigo, rsDet_FactVen.Cod_Impuesto, 'Cod_Impuesto')>
            <!--- Busca equivalencia de Centro Funcional en SIF --->
<!---          	<cfset sifCF = ConversionEquivalencia (rsCab_FactVen.Origen, 'CENTRO_FUN', rsCab_FactVen.Ecodigo, rsCab_FactVen.Sucursal, 'Centro_Funcional')>  --->
            <!--- Busca equivalencia de Moneda en SIF --->
            <cfset sifMONED = ConversionEquivalencia (rsCab_FactVen.Origen, 'MONEDA', rsCab_FactVen.Ecodigo, rsCab_FactVen.Moneda, 'Moneda')> 
            
            	<cfif rsDet_FactVen.Impuesto gt 0>  
            
						<!--- Insercion del detalle en la ID18 con Origen Contable "LDIP" (IVA Acreditable Pagado) --->
                        <cfset NoLinea = NoLinea + 1>
                        <cfquery name="rsInsertaID18" datasource="sifinterfaces">
                                        insert into ID18 (
                                                    ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
                                                    Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
                                                    Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
                                                    Oficodigo, Miso4217, CFcodigo)
                                        values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
                                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#NoLinea#">,
                                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#getEcodigo(EcodigoSDC)#">,
                                                    <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(Fecha, 'dd/mm/yyyy')#">,
                                                    #Periodo#, #Mes#, 
                                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de IVA Acreditable Pagado #dateformat(Fecha, 'dd/mm/yyyy')#">, 
                                                    ' ', ' ', 'C', 0, 0, 0, 0,
                                                    <cfqueryparam cfsqltype="cf_sql_money" value="#rsDet_FactVen.Impuesto#" null="#Len(Trim(rsDet_FactVen.Impuesto)) EQ 0#">,
                                                    <cfqueryparam cfsqltype="cf_sql_money" value="#rsDet_FactVen.Impuesto#" null="#Len(Trim(rsDet_FactVen.Impuesto)) EQ 0#">,
                                                    1, 0, getdate(), 0, 
                                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDIP[rsDet_FactVen.CurrentRow].CFformato#">,
                                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">,
                                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifMONED.EQUcodigoSIF#">,
                                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCF.EQUcodigoSIF#">)
                        </cfquery>
                </cfif>  
                
                <!--- pOR SI SE LLEGARA A OCUPAR OTRA VEZ EL cENTRO fUNCIONAL --->
                <!--- <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCF.EQUcodigoSIF#">) --->            
            

				<cfset NoLinea = NoLinea + 1>
            	<!--- Insercion del detalle en la ID18 con Origen Contable "LDIV" (Ingresos Ventas) --->
                <cfquery name="rsInsertaID18" datasource="sifinterfaces">
                                insert into ID18 (
                                            ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
                                            Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
                                            Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
                                            Oficodigo, Miso4217, CFcodigo)
                                values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
                                            <cfqueryparam cfsqltype="cf_sql_integer" value="#NoLinea#">,
                                            <cfqueryparam cfsqltype="cf_sql_integer" value="#getEcodigo(EcodigoSDC)#" >,
                                            <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(Fecha, 'dd/mm/yyyy')#">,
                                            #Periodo#, #Mes#, 
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de Ingresos Ventas #dateformat(Fecha, 'dd/mm/yyyy')#">, 
                                            ' ', ' ', 'C', 0, 0, 0, 0,
                                            <cfqueryparam cfsqltype="cf_sql_money" value="#rsDet_FactVen.Subtotal#" null="#Len(Trim(rsDet_FactVen.Subtotal)) EQ 0#">,
                                            <cfqueryparam cfsqltype="cf_sql_money" value="#rsDet_FactVen.Subtotal#" null="#Len(Trim(rsDet_FactVen.Subtotal)) EQ 0#">,
                                            1, 0, getdate(), 0, 
                          					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDIV[rsDet_FactVen.CurrentRow].CFformato#">,
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">,
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifMONED.EQUcodigoSIF#">,
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCF.EQUcodigoSIF#">)
                </cfquery>                              
             
            
			  <cfif rsCab_FactVen.Tipo_Venta EQ "P" or rsCab_FactVen.Tipo_Venta EQ "D" or rsCab_FactVen.Tipo_Venta EQ "S" or
                                  (rsCab_FactVen.Tipo_Venta EQ "C" and (rsCab_FactVen.cliente EQ "AMEX" or mid(rsCab_FactVen.cliente,1,4) EQ "VALE" 
                                  or mid(rsCab_FactVen.cliente,1,4) EQ "COPA"))>             
              
               <!--- Insercion del detalle en la ID18 con Origen Contable "LDAV" (Contable Almacen Ventas) --->
 				<cfset NoLinea = NoLinea + 1>
                <cfquery name="rsInsertaID18" datasource="sifinterfaces">
                                insert into ID18 (
                                            ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
                                            Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
                                            Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
                                            Oficodigo, Miso4217, CFcodigo)
                                values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
                                            <cfqueryparam cfsqltype="cf_sql_integer" value="#NoLinea#">,
                                            <cfqueryparam cfsqltype="cf_sql_integer" value="#getEcodigo(EcodigoSDC)#">,
                                            <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(Fecha, 'dd/mm/yyyy')#">,
                                            #Periodo#, #Mes#, 
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de Almacen Ventas #dateformat(Fecha, 'dd/mm/yyyy')#">, 
                                            ' ', ' ', 'C', 0, 0, 0, 0,
                                            <cfqueryparam cfsqltype="cf_sql_money" value="#rsDet_FactVen.Costo_Venta#" null="#Len(Trim(rsDet_FactVen.Costo_Venta)) EQ 0#">,
                                            <cfqueryparam cfsqltype="cf_sql_money" value="#rsDet_FactVen.Costo_Venta#" null="#Len(Trim(rsDet_FactVen.Costo_Venta)) EQ 0#">,
                                            1, 0, getdate(), 0, 
                          					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDAV[rsDet_FactVen.CurrentRow].CFformato#">,
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">,
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifMONED.EQUcodigoSIF#">,
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCF.EQUcodigoSIF#">)
                </cfquery>
                
                <!--- Insercion del detalle en la ID18 con Origen Contable "LDCV" (Costo Ventas) --->
                <cfset NoLinea = NoLinea + 1>
                <cfquery name="rsInsertaID18" datasource="sifinterfaces">
                                insert into ID18 (
                                            ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
                                            Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
                                            Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
                                            Oficodigo, Miso4217, CFcodigo)
                                values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
                                            <cfqueryparam cfsqltype="cf_sql_integer" value="#NoLinea#">,
                                            <cfqueryparam cfsqltype="cf_sql_integer" value="#getEcodigo(EcodigoSDC)#">,
                                            <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(Fecha, 'dd/mm/yyyy')#">,
                                            #Periodo#, #Mes#, 
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de Costo Ventas #dateformat(Fecha, 'dd/mm/yyyy')#">, 
                                            ' ', ' ', 'D', 0, 0, 0, 0,
                                            <cfqueryparam cfsqltype="cf_sql_money" value="#rsDet_FactVen.Costo_Venta#" null="#Len(Trim(rsDet_FactVen.Costo_Venta)) EQ 0#">,
                                            <cfqueryparam cfsqltype="cf_sql_money" value="#rsDet_FactVen.Costo_Venta#" null="#Len(Trim(rsDet_FactVen.Costo_Venta)) EQ 0#">,
                                            1, 0, getdate(), 0, 
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDCV[rsDet_FactVen.CurrentRow].CFformato#">,
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">,
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifMONED.EQUcodigoSIF#">,
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCF.EQUcodigoSIF#">)
                </cfquery>
             </cfif>
            
            <cfif rsCab_FactVen.Tipo_Venta EQ "D">    
                
                <!--- Insercion del detalle en la ID18 con Origen Contable "LDVD" (Ventas Devolucion) --->
 				<cfset NoLinea = NoLinea + 1>
                <cfquery name="rsInsertaID18" datasource="sifinterfaces">
                                insert into ID18 (
                                            ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
                                            Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
                                            Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
                                            Oficodigo, Miso4217, CFcodigo)
                                values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
                                            <cfqueryparam cfsqltype="cf_sql_integer" value="#NoLinea#">,
                                            <cfqueryparam cfsqltype="cf_sql_integer" value="#getEcodigo(EcodigoSDC)#">,
                                            <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(Fecha, 'dd/mm/yyyy')#">,
                                            #Periodo#, #Mes#, 
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza Devolucion de Ventas #dateformat(Fecha, 'dd/mm/yyyy')#">, 
                                            ' ', ' ', 'D', 0, 0, 0, 0,
                                            <cfqueryparam cfsqltype="cf_sql_money" value="#rsDet_FactVen.Subtotal#" null="#Len(Trim(rsDet_FactVen.Subtotal)) EQ 0#">,
                                            <cfqueryparam cfsqltype="cf_sql_money" value="#rsDet_FactVen.Subtotal#" null="#Len(Trim(rsDet_FactVen.Subtotal)) EQ 0#">,
                                            1, 0, getdate(), 0, 
                          					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDVD[rsDet_FactVen.CurrentRow].CFformato#">,
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">,
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifMONED.EQUcodigoSIF#">,
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCF.EQUcodigoSIF#">)
                </cfquery>
                
                <!--- Insercion del detalle en la ID18 con Origen Contable "LDEF" (Efectivo en Caja) --->
                <cfset NoLinea = NoLinea + 1>
                <cfquery name="rsInsertaID18" datasource="sifinterfaces">
                                insert into ID18 (
                                            ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
                                            Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
                                            Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
                                            Oficodigo, Miso4217, CFcodigo)
                                values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
                                            <cfqueryparam cfsqltype="cf_sql_integer" value="#NoLinea#">,
                                            <cfqueryparam cfsqltype="cf_sql_integer" value="#getEcodigo(EcodigoSDC)#">,
                                            <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(Fecha, 'dd/mm/yyyy')#">,
                                            #Periodo#, #Mes#, 
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza Efectivo en Caja #dateformat(Fecha, 'dd/mm/yyyy')#">, 
                                            ' ', ' ', 'C', 0, 0, 0, 0,
                                            <cfqueryparam cfsqltype="cf_sql_money" value="#rsDet_FactVen.Subtotal#" null="#Len(Trim(rsDet_FactVen.Subtotal)) EQ 0#">,
                                            <cfqueryparam cfsqltype="cf_sql_money" value="#rsDet_FactVen.Subtotal#" null="#Len(Trim(rsDet_FactVen.Subtotal)) EQ 0#">,
                                            1, 0, getdate(), 0, 
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDEF[rsDet_FactVen.CurrentRow].CFformato#">,
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">,
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifMONED.EQUcodigoSIF#">,
                                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCF.EQUcodigoSIF#">)
                </cfquery>                
            </cfif>
            
            <cfif rsCab_FactVen.Tipo_Venta EQ "C">
                
                	  <!--- Si el Tipo de Cliente es "AMEX" o "VALE"  o "COPAGO" --->
					  <cfif rsCab_FactVen.cliente EQ "AMEX" or mid(rsCab_FactVen.cliente,1,4) EQ "VALE" or mid(rsCab_FactVen.cliente,1,4) EQ "COPA"> 
                      
                      	  <!--- Insercion del detalle en la ID18 con Origen Contable "LDDD" (Deudores Diversos) --->
                          <cfset NoLinea = NoLinea + 1>
                          <cfquery name="rsInsertaID18" datasource="sifinterfaces">
                                          insert into ID18 (
                                                      ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
                                                      Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
                                                      Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
                                                      Oficodigo, Miso4217, CFcodigo)
                                          values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
                                                      <cfqueryparam cfsqltype="cf_sql_integer" value="#NoLinea#">,
                                                      <cfqueryparam cfsqltype="cf_sql_integer" value="#getEcodigo(EcodigoSDC)#">,
                                                      <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(Fecha, 'dd/mm/yyyy')#">,
                                                      #Periodo#, #Mes#, 
                                                      <cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza Deudores Diversos #dateformat(Fecha, 'dd/mm/yyyy')#">, 
                                                      ' ', ' ', 'D', 0, 0, 0, 0,
                                                      <cfqueryparam cfsqltype="cf_sql_money" value="#rsDet_FactVen.Subtotal#" null="#Len(Trim(rsDet_FactVen.Subtotal)) EQ 0#">,
                                                      <cfqueryparam cfsqltype="cf_sql_money" value="#rsDet_FactVen.Subtotal#" null="#Len(Trim(rsDet_FactVen.Subtotal)) EQ 0#">,
                                                      1, 0, getdate(), 0, 
                                                      <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDDD[rsDet_FactVen.CurrentRow].CFformato#">,
                                                      <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">,
                                                      <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifMONED.EQUcodigoSIF#">,
                                                      <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCF.EQUcodigoSIF#">)
                          </cfquery>
                          
                          <cfif rsCab_FactVen.cliente EQ "AMEX">
								<!--- Insercion del detalle en la ID18 con Origen Contable "LDCB" (Comisiones Bancarias) --->
                                <cfset NoLinea = NoLinea + 1>
                                <cfquery name="rsInsertaID18" datasource="sifinterfaces">
                                        insert into ID18 (
                                                    ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
                                                    Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
                                                    Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
                                                    Oficodigo, Miso4217, CFcodigo)
                                        values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
                                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#NoLinea#">,
                                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#getEcodigo(EcodigoSDC)#">,
                                                    <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(Fecha, 'dd/mm/yyyy')#">,
                                                    #Periodo#, #Mes#, 
                                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza Comisiones Bancarias #dateformat(Fecha, 'dd/mm/yyyy')#">, 
                                                    ' ', ' ', 'D', 0, 0, 0, 0,
                                                    <cfqueryparam cfsqltype="cf_sql_money" value="#rsDet_FactVen.Subtotal#" null="#Len(Trim(rsDet_FactVen.Subtotal)) EQ 0#">,
                                                    <cfqueryparam cfsqltype="cf_sql_money" value="#rsDet_FactVen.Subtotal#" null="#Len(Trim(rsDet_FactVen.Subtotal)) EQ 0#">,
                                                    1, 0, getdate(), 0, 
                                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDCB[rsDet_FactVen.CurrentRow].CFformato#">,
                                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">,
                                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifMONED.EQUcodigoSIF#">,
                                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCF.EQUcodigoSIF#">)
                                </cfquery>
                          </cfif>                    
                     </cfif>
               </cfif>
         </cfloop>
            
 <!---                     Seleccion de los Detalles del Tipo e Pago                    --->
            <cfquery name="rsFact_TPago" datasource="sifinterfaces">
                        select  Ecodigo, ID_DocumentoV, Id_Linea_Pago, Tipo_Pago, isnull(Importe,0) as Importe
                        	from SIFLD_Facturas_Tipo_Pago
                        where Id_DocumentoV = #DocumentoFact#
            </cfquery>
         
         	 <!--- Insercion de los Detalles del Tpo de Pago en la ID18 --->
             <cfloop query = "rsFact_TPago">
             	<!--- Busca equivalencia de Tipo de Pago en SIF --->
                <cfset sifPAG = ConversionEquivalencia (rsCab_FactVen.Origen, 'TIPO_PAGO', rsCab_FactVen.Ecodigo, rsFact_TPago.Tipo_Pago, 'Tipo_Pago')>
                <!--- Busca equivalencia de Centro Funcional en SIF --->
<!---             	<cfset sifCF = ConversionEquivalencia (rsCab_FactVen.Origen, 'CFUNCIONAL', rsCab_FactVen.Ecodigo, rsCab_FactVen.Sucursal, 'Centro_Funcional')>  --->
                
                <cfset TIPO_PAGO = #rsFact_TPago.Tipo_Pago#>     
                
                <cfif #TIPO_PAGO# eq "E">
					  <!--- Insercion del detalle en la ID18 con Origen Contable "LDEF" (Efectivo en Caja Doctos Contables) --->
                      <cfset NoLinea = NoLinea + 1>
                      <cfquery name="rsInsertaFact_TPago" datasource="sifinterfaces">
                      
                                      insert into ID18 (
                                                  ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
                                                  Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
                                                  Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
                                                  Oficodigo, Miso4217, CFcodigo)
                                      values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
                                                  <cfqueryparam cfsqltype="cf_sql_integer" value="#NoLinea#">,
                                                  <cfqueryparam cfsqltype="cf_sql_integer" value="#getEcodigo(EcodigoSDC)#">,
                                                  <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(Fecha, 'dd/mm/yyyy')#">,
                                                  #Periodo#, #Mes#, 
                                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de Pago en #sifPag.EQUcodigoSIF#">, 
                                                  ' ', ' ', 'D', 0, 0, 0, 0,
                                                  <cfqueryparam cfsqltype="cf_sql_money" value="#rsFact_TPago.Importe#" null="#Len(Trim(rsFact_TPago.Importe)) EQ 0#">,
                                                  <cfqueryparam cfsqltype="cf_sql_money" value="#rsFact_TPago.Importe#" null="#Len(Trim(rsFact_TPago.Importe)) EQ 0#">,
                                                  1, 0, getdate(), 0, 
                                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDEF[rsFact_TPago.CurrentRow].CFformato#">,
                                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">,
                                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifMONED.EQUcodigoSIF#">,
                                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCF.EQUcodigoSIF#">)        
                      </cfquery>
                </cfif>
                
<!---                #sifPag#">,   --->
                
                <cfif #TIPO_PAGO# eq "T">
					  <!--- Insercion del detalle en la ID18 con Origen Contable "LDBC" (Bancos Cuentas) --->
                      <cfset NoLinea = NoLinea + 1>
                      <cfquery name="rsInsertaFact_TPago" datasource="sifinterfaces">
                      
                                      insert into ID18 (
                                                  ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
                                                  Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
                                                  Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
                                                  Oficodigo, Miso4217, CFcodigo)
                                      values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
                                                  <cfqueryparam cfsqltype="cf_sql_integer" value="#NoLinea#">,
                                                  <cfqueryparam cfsqltype="cf_sql_integer" value="#getEcodigo(EcodigoSDC)#">,
                                                  <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(Fecha, 'dd/mm/yyyy')#">,
                                                  #Periodo#, #Mes#, 
                                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de Pago en #sifPag.EQUcodigoSIF#">,  
                                                  ' ', ' ', 'D', 0, 0, 0, 0,
                                                  <cfqueryparam cfsqltype="cf_sql_money" value="#rsFact_TPago.Importe#" null="#Len(Trim(rsFact_TPago.Importe)) EQ 0#">,
                                                  <cfqueryparam cfsqltype="cf_sql_money" value="#rsFact_TPago.Importe#" null="#Len(Trim(rsFact_TPago.Importe)) EQ 0#">,
                                                  1, 0, getdate(), 0, 
                                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDBC[rsFact_TPago.CurrentRow].CFformato#">,
                                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">,
                                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifMONED.EQUcodigoSIF#">,
                                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCF.EQUcodigoSIF#">)        
                      </cfquery>
               
					  <!--- Insercion del detalle en la ID18 con Origen Contable "LDCB" (Comisiones Bancarias) --->
                      <cfset NoLinea = NoLinea + 1>
                      <cfquery name="rsInsertaFact_TPago" datasource="sifinterfaces">
                      
                                      insert into ID18 (
                                                  ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
                                                  Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
                                                  Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
                                                  Oficodigo, Miso4217, CFcodigo)
                                      values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
                                                  <cfqueryparam cfsqltype="cf_sql_integer" value="#NoLinea#">,
                                                  <cfqueryparam cfsqltype="cf_sql_integer" value="#getEcodigo(EcodigoSDC)#">,
                                                  <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(Fecha, 'dd/mm/yyyy')#">,
                                                  #Periodo#, #Mes#, 
                                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de Pago en #sifPag.EQUcodigoSIF#">,  
                                                  ' ', ' ', 'D', 0, 0, 0, 0,
                                                  <cfqueryparam cfsqltype="cf_sql_money" value="#rsFact_TPago.Importe#" null="#Len(Trim(rsFact_TPago.Importe)) EQ 0#">,
                                                  <cfqueryparam cfsqltype="cf_sql_money" value="#rsFact_TPago.Importe#" null="#Len(Trim(rsFact_TPago.Importe)) EQ 0#">,
                                                  1, 0, getdate(), 0, 
                                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDCB_Pago[rsFact_TPago.CurrentRow].CFformato#">,
                                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">,
                                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifMONED.EQUcodigoSIF#">,
                                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCF.EQUcodigoSIF#">)        
                      </cfquery>
                </cfif>
                
                <cfif #TIPO_PAGO# eq "M" or #TIPO_PAGO# eq "P" or #TIPO_PAGO# eq "N">
					  <!--- Insercion del detalle en la ID18 con Origen Contable "LDDV" (Descuento sobre Ventas) --->
                      <cfset NoLinea = NoLinea + 1>
                      <cfquery name="rsInsertaFact_TPago" datasource="sifinterfaces">
                      
                                      insert into ID18 (
                                                  ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
                                                  Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
                                                  Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
                                                  Oficodigo, Miso4217, CFcodigo)
                                      values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
                                                  <cfqueryparam cfsqltype="cf_sql_integer" value="#NoLinea#">,
                                                  <cfqueryparam cfsqltype="cf_sql_integer" value="#getEcodigo(EcodigoSDC)#">,
                                                  <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(Fecha, 'dd/mm/yyyy')#">,
                                                  #Periodo#, #Mes#, 
                                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de Pago en #sifPag.EQUcodigoSIF#">, 
                                                  ' ', ' ', 'D', 0, 0, 0, 0,
                                                  <cfqueryparam cfsqltype="cf_sql_money" value="#rsFact_TPago.Importe#" null="#Len(Trim(rsFact_TPago.Importe)) EQ 0#">,
                                                  <cfqueryparam cfsqltype="cf_sql_money" value="#rsFact_TPago.Importe#" null="#Len(Trim(rsFact_TPago.Importe)) EQ 0#">,
                                                  1, 0, getdate(), 0, 
                                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDDV[rsFact_TPago.CurrentRow].CFformato#">,
                                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">,
                                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifMONED.EQUcodigoSIF#">,
                                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCF.EQUcodigoSIF#">)        
                      </cfquery>
                </cfif>

                <cfif #TIPO_PAGO# eq "CP">
					  <!--- Insercion del detalle en la ID18 con Origen Contable "LDDD" (Deudores Diversos) --->
                      <cfset NoLinea = NoLinea + 1>
                      <cfquery name="rsInsertaFact_TPago" datasource="sifinterfaces">
                      
                                      insert into ID18 (
                                                  ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
                                                  Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
                                                  Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
                                                  Oficodigo, Miso4217, CFcodigo)
                                      values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
                                                  <cfqueryparam cfsqltype="cf_sql_integer" value="#NoLinea#">,
                                                  <cfqueryparam cfsqltype="cf_sql_integer" value="#getEcodigo(EcodigoSDC)#">,
                                                  <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(Fecha, 'dd/mm/yyyy')#">,
                                                  #Periodo#, #Mes#, 
                                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de Pago en #sifPag.EQUcodigoSIF#">, 
                                                  ' ', ' ', 'D', 0, 0, 0, 0,
                                                  <cfqueryparam cfsqltype="cf_sql_money" value="#rsFact_TPago.Importe#" null="#Len(Trim(rsFact_TPago.Importe)) EQ 0#">,
                                                  <cfqueryparam cfsqltype="cf_sql_money" value="#rsFact_TPago.Importe#" null="#Len(Trim(rsFact_TPago.Importe)) EQ 0#">,
                                                  1, 0, getdate(), 0, 
                                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDDD_Pago[rsFact_TPago.CurrentRow].CFformato#">,
                                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">,
                                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifMONED.EQUcodigoSIF#">,
                                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCF.EQUcodigoSIF#">)        
                      </cfquery>
                </cfif>
            </cfloop> 

		<!--- BORRADO DE TABLAS ORIGEN --->  
        <!---<cfquery name="rsBorraDet_FactVen" datasource="sifinterfaces"> 
                delete 	DSIFLD_Facturas_Venta where Id_DocumentoV = #DocumentoFact# 
                delete 	SIFLD_Facturas_Tipo_Pago where Id_DocumentoV = #DocumentoFact# 
                delete	ESIFLD_Facturas_Venta where Id_DocumentoV = #DocumentoFact#   
        </cfquery>    --->
 
       <!--- Preceso de Dispara Interfaz, el cual seleciona registros de tablas IE18,ID18 para ser validados 
	  		por LDSIF para ser insertados al final en Tablas del LDSIF  --->             
       <cfset disparaInterfaz(18, #Maximus#, EcodigoSDC)>    
             
       </cftransaction>
       
            <cfcatch type="any">
            	  <!--- Insercion de Error en caso de que no exista alguna Equivalencia --->
                  <cfset InsertaError('CG_Ventas', DocumentoFact, 'ESIFLD_Facturas_Venta', 'Id_DocumentoV')>
                    <!--- Borrado de Cabecera en IE18 en caso de Error --->
                    <cfquery name="rsBorraCab_CGFactVentas" datasource="sifinterfaces"> 
                    		delete from IE18 where ID = #Maximus#
            		</cfquery>  
            </cfcatch>
          </cftry>
          
   </cfloop>
 </cffunction>
</cfcomponent>