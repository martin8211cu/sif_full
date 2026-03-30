<cfcomponent extends="Interfaz_Base">		
	<cffunction name="Ejecuta" access="public" returntype="string" output="yes">
    	<cfdump var="Entre a Component">
        	<cfquery name="rsCab_FactVen" datasource="sifinterfaces">		<!--- Selecciona la Cabecera de las Ventas --->
					select Ecodigo, Origen, Id_DocumentoV, Cliente, Tipo_Documento, Numero_Documento, Moneda, Fecha_Venta, Dias_Credito, Retencion, Sucursal, Tipo_Cedi,
                    		Tipo_Cambio, Descuento, Vendedor, Direccion_Facturacion
					from ESIFLD_Facturas_Venta
                    where Tipo_Venta = 'C' and Tipo_Cedi = 0
            </cfquery>
            
 <!---           <cfdump var="#rsCab_FactVen#">  --->
        <cfloop query="rsCab_FactVen">
            <cfdump var="'Entre a LoopCabecera'">
            <cfset DocumentoFact = '0'>		
            
            <cftry>
				<cfset DocumentoFact = rsCab_FactVen.Id_DocumentoV>
				<cfset RsMaximo = ExtraeMaximo("IE19","ID")> 
     
                <cfdump var= "Maximo ----->">
                <cfdump var="#RsMaximo.Maximo#">
                
                <cfset sifSUC = ConversionEquivalencia (rsCab_FactVen.Origen, 'SUCURSAL', rsCab_FactVen.Ecodigo, rsCab_FactVen.Sucursal, 'Sucursal')>
                <cfset EcodigoSDC  = sifSUC.EQUempSIF>  
                <cfset sifCFN = ConversionEquivalencia (rsCab_FactVen.Origen, 'CFUNCIONAL', rsCab_FactVen.Ecodigo, rsCab_FactVen.Sucursal, 'Centro_Funcional')>
                <cfdump var="#sifCFN#">
                
                <!--- , 'CLIENTE', 'ECODIGO' --->
                <cfset CamposCte = ExtraeCliente(rsCab_FactVen.Cliente, #EcodigoSDC#)>                              
                
                <!--- Obtiene FechaVencimiento y DiasVencimiento si hay dias_credito --->        
                <cfif rsCab_FactVen.Dias_Credito LT 1>
                    <cfset FechaVenc = rsCab_FactVen.Fecha_Venta>
                    <cfset DiasVenc = 0> 
                <cfelse>
                    <cfset FechaVenc = DateAdd('d',rsCab_FactVen.Dias_Credito,rsCab_FactVen.Fecha_Venta)>
                    <cfset DiasVenc = rsCab_FactVen.Dias_Credito>
                </cfif>
                      
 <!---              <cfdump var="#TCedi#">
                    <cfdump var= "Sifsuc">
                    <cfdump var="#sifSUC#">
                    <cfdump var="#sifSUC.EQUcodigoSIF#">   --->
                    
                
                        <cfquery name="rsInsertaIE19" datasource="sifinterfaces">
                            insert into IE19 (ID, Ecodigo, NumeroSocio, CodigoTransacion, 
                                                Documento, CodigoMoneda, FechaTipoCambio, TipoCambio, Descuento, Vendedor, FechaDocumento, 
                                                DiasVigencia, FechaVencimiento, CodigoOficina, CodigoDireccionFacturacion, NumeroOrdenCompra, StatusProceso, 			                                                Observaciones, Origen, BMUsucodigo)
                            values (
                                  <cfqueryparam cfsqltype ="cf_sql_numeric" value="#RsMaximo.Maximo#">,
                                  <cfqueryparam cfsqltype ="cf_sql_integer" value="#EcodigoSDC#">, 
                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCab_FactVen.Cliente#">,
                                  <cfqueryparam cfsqltype="cf_sql_char" value="#rsCab_FactVen.Tipo_Documento#">,
                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCab_FactVen.Numero_Documento#">,
                                  'MXP',
								  getdate(),
                                  <cfqueryparam cfsqltype="cf_sql_float" value="#rsCab_FactVen.Tipo_Cambio#" null="#Len(Trim(rsCab_FactVen.Tipo_Cambio)) EQ 0#">,
                                  <cfqueryparam cfsqltype="cf_sql_money" value="#rsCab_FactVen.Descuento#" null="#Len(Trim(rsCab_FactVen.Descuento)) EQ 0#">, 
                                  <cfqueryparam cfsqltype="cf_sql_char" value="#rsCab_FactVen.Vendedor#">,
                                  <cfqueryparam cfsqltype="cf_sql_date" value="#rsCab_FactVen.Fecha_Venta#">,
                                  isnull(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCab_FactVen.Dias_Credito#">,0),
                                  <cfqueryparam cfsqltype="cf_sql_date" value="#FechaVenc#">,
                                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">, 
                                  <cfqueryparam cfsqltype="cf_sql_char" value="#rsCab_FactVen.Direccion_Facturacion#">,
                                  ' ', 
                                  '10',
                                  ' ',
                                  <cfqueryparam cfsqltype="cf_sql_char" value="#rsCab_FactVen.Origen#">,
                                  1)
                           </cfquery> 

                
                    <cfquery name="rsDet_FactVen" datasource="sifinterfaces">
                        select  ECodigo, Id_Linea, isnull(Precio_Unitario, 0) as Precio_Unitario, Cantidad, 
                        		Cod_Impuesto, Impuesto_Lin, Descuento_Lin, Tipo_Item, Total_Lin, Clas_Item, Cod_Fabricante, Tipo_Lin, cod_item, Subtotal_Lin
                            from DSIFLD_Facturas_Venta
                                where Id_DocumentoV = #DocumentoFact#
                    </cfquery>
 <!---                   <cfdump var="#rsDet_FactVen#">    --->
                      <cfset miConsecutivo = 0>
                      <cfset TipoVta = "01">
     
     	<cfset CuentaLDIV = ArrayNew(1)>
        <cfset session.dsn = getConexion(EcodigoSDC)>
        
       <cfloop query = "rsDet_FactVen">
			<cfset sifIMP = ConversionEquivalencia (rsCab_FactVen.Origen, 'IMPUESTO', rsCab_FactVen.Ecodigo, rsDet_FactVen.Cod_Impuesto, 'Cod_Impuesto')>
     
           <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
				  Oorigen="LDIV"
				  Ecodigo="#getEcodigo(EcodigoSDC)#"  
				  Conexion="#getConexion(EcodigoSDC)#"
				  LDTipoVenta="#TipoVta#"					
				  LDDepartamento="#NumberFormat(rsDet_FactVen.Tipo_Item, '00')#"
				  LDClasificacion="#NumberFormat(rsDet_FactVen.Clas_Item, '00')#"
				  LDFabricante="#NumberFormat( rsDet_FactVen.Cod_Fabricante, '00')#"
				  LDTipoCliente="#CamposCte.TipoCte#"
				  SNegocios="#CamposCte.sncodigo#"
				  Impuestos="#numberformat(sifIMP.EQUcodigoSIF, '00')#"
				  >
			</cfinvoke>          			
			<cfset ArrayAppend(CuentaLDIV, Cuenta)>
         </cfloop>             
                       
    <cftransaction>                
       <cfloop query = "rsDet_FactVen">

       			<cfdump var="'Entre a LoopDetalle'">
                <cfdump var="'TIPO_ARTICULO'">
                <cfdump var="#rsCab_FactVen.Origen#">
                <cfdump var="#rsCab_FactVen.Ecodigo#">
                <cfdump var="#rsDet_FactVen.Tipo_Item#">
                <cfdump var="'Tipo_Item'">
                
			    <cfset sifART = ConversionEquivalencia (rsCab_FactVen.Origen, 'TIPO_ARTICULO', rsCab_FactVen.Ecodigo, rsDet_FactVen.Tipo_Item,    'Tipo_Item')>
  			    <cfset sifIMP = ConversionEquivalencia (rsCab_FactVen.Origen, 'IMPUESTO'     , rsCab_FactVen.Ecodigo, rsDet_FactVen.Cod_Impuesto, 'Cod_Impuesto')>
                
 <!---               <cfif rsDet_FactVen.Tipo_Lin EQ "">  --->
                
                <cfset miConsecutivo = miConsecutivo + 1>                  
                    <cfquery name="rsInsertaID19" datasource="sifinterfaces">
                        insert into ID19 (ID, Consecutivo, TipoItem, CodigoItem, PrecioUnitario, CantidadTotal, CodigoImpuesto, ImporteDescuento, CodigoAlmacen,
                        					CentroFuncional, CuentaFinancieraDet, PrecioTotal, Descripcion, Descripcion_Alt, BMUsucodigo)
                        values (
                        	<cfqueryparam cfsqltype ="cf_sql_numeric" value="#RsMaximo.Maximo#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#miConsecutivo#">, 
                            <cfqueryparam cfsqltype="cf_sql_char" value="#rsDet_FactVen.Tipo_Lin#">,  
                            <cfqueryparam cfsqltype="cf_sql_char" value="#rsDet_FactVen.Cod_item#">,
                            <cfqueryparam cfsqltype="cf_sql_money" value="#rsDet_FactVen.Precio_Unitario#" null="#Len(Trim(rsDet_FactVen.Precio_Unitario)) EQ 0#">, 
                            <cfqueryparam cfsqltype="cf_sql_float" value="#rsDet_FactVen.Cantidad#" null="#Len(Trim(rsDet_FactVen.Cantidad)) EQ 0#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifIMP.EQUcodigoSIF#">,
                            <cfqueryparam cfsqltype="cf_sql_money" value="#rsDet_FactVen.Descuento_Lin#" null="#Len(Trim(rsDet_FactVen.Descuento_Lin)) EQ 0#">,
                            ' ',
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCFN.EQUcodigoSIF#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDIV[rsDet_FactVen.CurrentRow].CFformato#">,
                            <cfqueryparam cfsqltype="cf_sql_money" value="#rsDet_FactVen.Subtotal_Lin#" null="#Len(Trim(rsDet_FactVen.Subtotal_Lin)) EQ 0#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de Prefacturacion del #dateformat(rsCab_FactVen.Fecha_Venta, 'dd/mm/yyyy')#">,
                            ' ',1)
                     </cfquery>
                
                <cfdump var="'Sali de INsert detalle'"> 
     <!---           <cfdump var="#DocumentoFact#">    --->
       </cfloop>
       
       <cfdump var="'Sali de LoopDetalle'">
            <!---            	<cfquery name="rsBorraDet_FactVen" datasource="sifinterfaces"> 
         				    	delete 	from DSIFLD_Facturas_Venta where Id_DocumentoV = #DocumentoFact#
                                delete  from SIFLD_Facturas_Tipo_Pago where Id_DocumentoV = #DocumentoFact# 
                                delete	from ESIFLD_Facturas_Venta where Id_DocumentoV = #DocumentoFact#
			            	</cfquery>  --->
                            
     <cfset disparaInterfaz(19, RsMaximo.Maximo, EcodigoSDC)>    

  </cftransaction>
         

------------------------------------------------------------------------------------------------------------------------------------
          
          <cfcatch type="anyx">ERROR 
		       	<cfset InsertaError('FACTURACION', DocumentoFact)>
          </cfcatch>
          </cftry>
 
 <!---        
          Abortando misión...
<cfabort>
    
      <cfquery name="rsBorraCab_FactVen" datasource="sifinterfaces"> 
             delete	ESIFLD_Facturas_Venta where Id_DocumentoV = #DocumentoFact#
      </cfquery> --->
   </cfloop>
   
   	<cfquery name = "RSPrueba" datasource="sifinterfaces">
    	select * from IE19, ID19
        where IE19.ID = ID19.ID
    </cfquery>
    
    <cfdump var="'RSPrueba   '">
    <cf_dump var="#RSPrueba#">
   
   <cfdump var="'SALI YA DEL PROCESO'">
 </cffunction>

-----------------------------------------------------------------------------------------------------------------------------------------
</cfcomponent>