<cfcomponent extends="Interfaz_Base">
<cffunction name="Ejecuta" access="public" returntype="string" output="yes">
  <cfquery name="rsCab_Movs_Inventario" datasource="sifinterfaces">
                       select Ecodigo, Origen, ID_Movimiento, Tipo_Movimiento, Fecha_Movimiento, Documento, Descripcion, Almacen_Origen, Almacen_Destino, Sucursal, Tipo_Ajuste
                       				,Sucursal_Destino			
                       from ESIFLD_Movimientos_Inventario
                       where ((StatusError <> 1) or (StatusError is null))
  </cfquery>
  <cfloop query="rsCab_Movs_Inventario">
    <cfset Movimiento = '0'>
    <cfset CampoError = ''>
    <cfset NoLinea = 0>
    
    <cfset TipoAjuste = trim(rsCab_Movs_Inventario.Tipo_Ajuste)>
    
    <cfif TipoAjuste EQ "E">
    	<cfset Almacen = rsCab_Movs_Inventario.Almacen_Destino>
        <cfset DescAjuste = "Entrada">
    <cfelseif TipoAjuste EQ "S">
    	<cfset Almacen = rsCab_Movs_Inventario.Almacen_Origen>
        <cfset DescAjuste = "Salida">
	<cfelseif TipoAjuste EQ "ES">
		<cfset AlmacenES_O = rsCab_Movs_Inventario.Almacen_Origen>
		<cfset AlmacenES_D = rsCab_Movs_Inventario.Almacen_Destino>
        <cfset DescAjuste = "Entrada/Salida">
	</cfif>    
      
    <cftry>
     
        <cfset Movimiento = rsCab_Movs_Inventario.Id_Movimiento>
        <cfset TipoMov = rsCab_Movs_Inventario.Tipo_Movimiento>        
        
        <cfset sifSUC = ConversionEquivalencia (rsCab_Movs_Inventario.Origen, 'SUCURSAL', rsCab_Movs_Inventario.Ecodigo, rsCab_Movs_Inventario.Sucursal, 'Sucursal')> 
        <cfset EcodigoSDC  = sifSUC.EQUempSIF>
       	<cfset sifCFN = ConversionEquivalencia (rsCab_Movs_Inventario.Origen, 'CENTRO_FUN', rsCab_Movs_Inventario.Ecodigo, rsCab_Movs_Inventario.Sucursal, 'Centro_Funcional')> 
        <cfset Fecha = rsCab_Movs_Inventario.Fecha_Movimiento>
  <!---      <cfset Periodo = year(rsCab_Movs_Inventario.Fecha_Movimiento)>
        <cfset Mes = month(rsCab_Movs_Inventario.Fecha_Movimiento)>   --->
        <cfset NumeroDoc = rsCab_Movs_Inventario.Documento>
        
        <cfset RsMaximo = ExtraeMaximo("IE18","ID")>
        
        <cfif isdefined(#RsMaximo.Maximo#) or #RsMaximo.Maximo# gt 0>
        	<cfset Maximus = #RsMaximo.Maximo#>
		<cfelse>
        	<cfset Maximus = 1>
		</cfif>
        
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
        
  			      <cfquery name="rsInsertaIE18" datasource="sifinterfaces">
                        insert into IE18 (ID, Ecodigo, Cconcepto, Eperiodo, Emes, Efecha, Edescripcion, Edocbase, Ereferencia, Falta, Usuario)
                  		values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
                                <cfqueryparam cfsqltype ="cf_sql_integer" value="#getEcodigo(EcodigoSDC)#">, 0,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
                                <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de Movs. Inventario #DescAjuste# #rsCab_Movs_Inventario.Descripcion#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#NumeroDoc#">,
                                '', getdate(), 1)
                  </cfquery>  
   
        <cfquery name="rsDet_Movs_Inventario" datasource="sifinterfaces">
            select  Ecodigo, ID_movimiento, Id_Linea, Clas_Item, Cod_Item, Cantidad, Costo, Cod_Fabricante, Tipo_Item
            from DSIFLD_Movimientos_Inventario
            where Id_Movimiento = #Movimiento#
        </cfquery>
       
        <cfset CuentaLDAV_RC = ArrayNew(1)>
        <cfset CuentaLDIT_RC = ArrayNew(1)>
        
        <cfset CuentaLDAV_DC = ArrayNew(1)>
        <cfset CuentaLDIT_DC = ArrayNew(1)>
        
        <cfset CuentaLDIT_3_S = ArrayNew(1)>
        <cfset CuentaLDCA_3_S = ArrayNew(1)>
        
        <cfset CuentaLDIT_3_E = ArrayNew(1)>
        <cfset CuentaLDCA_3_E = ArrayNew(1)>        
        
        <cfset CuentaLDCA_3_ES_D = ArrayNew(1)>   
        <cfset CuentaLDCA_3_ES_C = ArrayNew(1)>
        <cfset CuentaLDIT_3_ES   = ArrayNew(1)>
        
        <cfset CuentaLDAI_X_E = ArrayNew(1)>     
		<cfset CuentaLDCA_X_E = ArrayNew(1)>           
        
        <cfset CuentaLDAI_X_S = ArrayNew(1)>     
		<cfset CuentaLDCA_X_S = ArrayNew(1)>           
        
        <cfset session.dsn = getConexion(EcodigoSDC)>
 
        <cfloop query = "rsDet_Movs_Inventario">       
            <cfif TipoMov EQ "RC">  <!--- (Recepcion Cedis) --->
             
             		<!--- Llamado cta. contable con Origen Contable Almacen de Venta --->
                    <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                        Oorigen="LDAV"
                        Ecodigo="#getEcodigo(EcodigoSDC)#"
                        Conexion="#getConexion(EcodigoSDC)#" 
                        LDDepartamento="#NumberFormat( rsDet_Movs_Inventario.Tipo_Item, '00')#"
                        LDClasificacion="#NumberFormat( rsDet_Movs_Inventario.Clas_Item, '00')#"
                        LDFabricante="#NumberFormat( rsDet_Movs_Inventario.Cod_Fabricante, '00')#"
                        >
                    </cfinvoke> 
                    <cfset ArrayAppend(CuentaLDAV_RC, Cuenta)> 
                    
                    <!--- Llamado cta. contable con Origen Contable Inventario en Transito --->
                   	<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                        Oorigen="LDIT"
                        Ecodigo="#getEcodigo(EcodigoSDC)#"
                        Conexion="#getConexion(EcodigoSDC)#"
                        LDDepartamento="#NumberFormat( rsDet_Movs_Inventario.Tipo_Item, '00')#"
                        LDClasificacion="#NumberFormat( rsDet_Movs_Inventario.Clas_Item, '00')#"
                        LDFabricante="#NumberFormat( rsDet_Movs_Inventario.Cod_Fabricante, '00')#"
                        >
                	</cfinvoke> 
                	<cfset ArrayAppend(CuentaLDIT_RC, Cuenta)> 
                
            <cfelseif TipoMov EQ "DC"> <!--- (Despacho Cedis) --->    	

				   <!--- Llamado cta. contable con Origen Contable Almacen de Venta --->
                   <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                        Oorigen="LDAV"
                        Ecodigo="#getEcodigo(EcodigoSDC)#"
                        Conexion="#getConexion(EcodigoSDC)#" 
                        LDDepartamento="#NumberFormat( rsDet_Movs_Inventario.Tipo_Item, '00')#"
                        LDClasificacion="#NumberFormat( rsDet_Movs_Inventario.Clas_Item, '00')#"
                        LDFabricante="#NumberFormat( rsDet_Movs_Inventario.Cod_Fabricante, '00')#"
                        >
                    </cfinvoke> 
                    <cfset ArrayAppend(CuentaLDAV_DC, Cuenta)> 
                    
                    <!--- Llamado cta. contable con Origen Contable Inventario en Transito --->
                   	<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                        Oorigen="LDIT"
                        Ecodigo="#getEcodigo(EcodigoSDC)#"
                        Conexion="#getConexion(EcodigoSDC)#"
                        LDDepartamento="#NumberFormat( rsDet_Movs_Inventario.Tipo_Item, '00')#"
                        LDClasificacion="#NumberFormat( rsDet_Movs_Inventario.Clas_Item, '00')#"
                        LDFabricante="#NumberFormat( rsDet_Movs_Inventario.Cod_Fabricante, '00')#"
                        >
                	</cfinvoke> 
					<cfset ArrayAppend(CuentaLDIT_DC, Cuenta)>
                     
            <cfelseif TipoMov EQ "3"> 	<!--- (Movimientos InterAlmacen) ---> 
            
					<cfif TipoAjuste EQ "S">  <!--- Salidas --->
                    
                       <!--- Llamado cta. contable con Origen Contable Inventario en Transito --->	
                       <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                                Oorigen="LDIT"
                                Ecodigo="#getEcodigo(EcodigoSDC)#"
                                Conexion="#getConexion(EcodigoSDC)#"
                                LDDepartamento="#NumberFormat( rsDet_Movs_Inventario.Tipo_Item, '00')#"
                                LDClasificacion="#NumberFormat( rsDet_Movs_Inventario.Clas_Item, '00')#"
                                LDFabricante="#NumberFormat( rsDet_Movs_Inventario.Cod_Fabricante, '00')#"
                                >
                        </cfinvoke> 
                        <cfset ArrayAppend(CuentaLDIT_3_S, Cuenta)>                
    
                        <!--- Llamado cta. contable con Origen Contable Almacen Entradas/Salidas --->
                        <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                                Oorigen="LDCA"
                                Ecodigo="#getEcodigo(EcodigoSDC)#"
                                Conexion="#getConexion(EcodigoSDC)#" 
                                LDAlmacen="#NumberFormat( Almacen, '00')#"
                                LDDepartamento="#NumberFormat( rsDet_Movs_Inventario.Tipo_Item, '00')#"
                                LDClasificacion="#NumberFormat( rsDet_Movs_Inventario.Clas_Item, '00')#"
                                LDFabricante="#NumberFormat( rsDet_Movs_Inventario.Cod_Fabricante, '00')#"
                           >
                        </cfinvoke>
                        <cfset ArrayAppend(CuentaLDCA_3_S, Cuenta)>
                    </cfif>

					<cfif TipoAjuste EQ "E">	<!--- Entradas --->
                    
                       <!--- Llamado cta. contable con Origen Contable Inventario en Transito --->
                       <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                                Oorigen="LDIT"
                                Ecodigo="#getEcodigo(EcodigoSDC)#"
                                Conexion="#getConexion(EcodigoSDC)#"
                                LDDepartamento="#NumberFormat( rsDet_Movs_Inventario.Tipo_Item, '00')#"
                                LDClasificacion="#NumberFormat( rsDet_Movs_Inventario.Clas_Item, '00')#"
                                LDFabricante="#NumberFormat( rsDet_Movs_Inventario.Cod_Fabricante, '00')#"
                                >
                        </cfinvoke> 
                        <cfset ArrayAppend(CuentaLDIT_3_E, Cuenta)>                
    
                        <!--- Llamado cta. contable con Origen Contable Almacen Entradas/Salidas --->
                        <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                                Oorigen="LDCA"
                                Ecodigo="#getEcodigo(EcodigoSDC)#"
                                Conexion="#getConexion(EcodigoSDC)#" 
                                LDAlmacen="#NumberFormat( Almacen, '00')#"
                                LDDepartamento="#NumberFormat( rsDet_Movs_Inventario.Tipo_Item, '00')#"
                                LDClasificacion="#NumberFormat( rsDet_Movs_Inventario.Clas_Item, '00')#"
                                LDFabricante="#NumberFormat( rsDet_Movs_Inventario.Cod_Fabricante, '00')#"
                           >
                        </cfinvoke>
                        <cfset ArrayAppend(CuentaLDCA_3_E, Cuenta)>
                    </cfif>

					<cfif TipoAjuste EQ "ES">	<!--- Entradas / Salidas --->
                    
                        <!--- Llamado cta. contable con Origen Contable Almacen Entradas/Salidas --->
                        <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                                Oorigen="LDCA"
                                Ecodigo="#getEcodigo(EcodigoSDC)#"
                                Conexion="#getConexion(EcodigoSDC)#" 
                                LDAlmacen="#NumberFormat( AlmacenES_O, '00')#"
                                LDDepartamento="#NumberFormat( rsDet_Movs_Inventario.Tipo_Item, '00')#"
                                LDClasificacion="#NumberFormat( rsDet_Movs_Inventario.Clas_Item, '00')#"
                                LDFabricante="#NumberFormat( rsDet_Movs_Inventario.Cod_Fabricante, '00')#"
                           >
                        </cfinvoke>
                        <cfset ArrayAppend(CuentaLDCA_3_ES_D, Cuenta)>                                 
    
                        <!--- Llamado cta. contable con Origen Contable Almacen Entradas/Salidas --->
                        <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                                Oorigen="LDCA"
                                Ecodigo="#getEcodigo(EcodigoSDC)#"
                                Conexion="#getConexion(EcodigoSDC)#" 
                                LDAlmacen="#NumberFormat( AlmacenES_D, '00')#"
                                LDDepartamento="#NumberFormat( rsDet_Movs_Inventario.Tipo_Item, '00')#"
                                LDClasificacion="#NumberFormat( rsDet_Movs_Inventario.Clas_Item, '00')#"
                                LDFabricante="#NumberFormat( rsDet_Movs_Inventario.Cod_Fabricante, '00')#"
                           >
                        </cfinvoke>
                        <cfset ArrayAppend(CuentaLDCA_3_ES_C, Cuenta)>
                        
						<cfif rsCab_Movs_Inventario.Sucursal neq rsCab_Movs_Inventario.Sucursal_Destino>

								   <!--- Llamado cta. contable con Origen Contable Inventario en Transito --->
                                   <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                                            Oorigen="LDIT"
                                            Ecodigo="#getEcodigo(EcodigoSDC)#"
                                            Conexion="#getConexion(EcodigoSDC)#"
                                            LDDepartamento="#NumberFormat( rsDet_Movs_Inventario.Tipo_Item, '00')#"
                                            LDClasificacion="#NumberFormat( rsDet_Movs_Inventario.Clas_Item, '00')#"
                                            LDFabricante="#NumberFormat( rsDet_Movs_Inventario.Cod_Fabricante, '00')#"
                                            >
                                    </cfinvoke> 
                                    <cfset ArrayAppend(CuentaLDIT_3_ES, Cuenta)>  
                        </cfif>  
                        
                    </cfif>

            <cfelse> 	<!--- (Otros Movimientos) ---> 
            
		<!---			<cfset sifTMovto = ConversionEquivalencia (rsCab_Movs_Inventario.Origen, 'MOVTO_INV', 
                            rsCab_Movs_Inventario.Ecodigo, rsCab_Movs_Inventario.Tipo_Movimiento,'Tipo_Movimiento')>  --->
                            
                    <cfif TipoAjuste EQ "E">	<!--- Entradas --->
                  <!---  <cfabort showerror="Origen: #rsCab_Movs_Inventario.Tipo_Movimiento# Equivalencia:#sifTMovto.EQUcodigoSIF#">--->
          					<!--- Llamado cta. contable con Origen Contable Ajuste de Inventario --->
                            <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                                Oorigen="LDAI"
                                Ecodigo="#getEcodigo(EcodigoSDC)#"
                                Conexion="#getConexion(EcodigoSDC)#"
                                LDMovimientoInventario="#NumberFormat(rsCab_Movs_Inventario.Tipo_Movimiento, '00')#"  
                                LDDepartamento="#NumberFormat(rsDet_Movs_Inventario.Tipo_Item, '00')#"
                                LDClasificacion="#NumberFormat(rsDet_Movs_Inventario.Clas_Item, '00')#"
                                LDFabricante="#NumberFormat(rsDet_Movs_Inventario.Cod_Fabricante, '00')#"
                                Impuestos="'No se ocupa'"
                                Oficinas="'No se ocupa'"
                                LDConceptoRetiroCaja="'No se ocupa'"
                                LDAlmacen="'No se ocupa'"
                                SNegocios="#NumberFormat(9999,'0000')#"
                                >
                            </cfinvoke>
                            <cfset ArrayAppend(CuentaLDAI_X_E, Cuenta)> 
                            
                            <!---"#sifTMovto.EQUcodigoSIF#"--->                   

							<!--- Llamado cta. contable con Origen Contable Almacen Entradas/Salidas --->
                            <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                                Oorigen="LDCA"
                                Ecodigo="#getEcodigo(EcodigoSDC)#"
                                Conexion="#getConexion(EcodigoSDC)#" 
                                LDAlmacen="#NumberFormat( Almacen, '00')#"
                                LDDepartamento="#NumberFormat( rsDet_Movs_Inventario.Tipo_Item, '00')#"
                                LDClasificacion="#NumberFormat( rsDet_Movs_Inventario.Clas_Item, '00')#"
                                LDFabricante="#NumberFormat( rsDet_Movs_Inventario.Cod_Fabricante, '00')#"
                               >
                            </cfinvoke>
                            <cfset ArrayAppend(CuentaLDCA_X_E, Cuenta)>
                    </cfif>
                    
                    <cfif TipoAjuste EQ "S">	<!--- Salidas --->
                    
							<!--- Llamado cta. contable con Origen Contable Ajuste de Inventario --->                                      
                            <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                                Oorigen="LDAI"
                                Ecodigo="#getEcodigo(EcodigoSDC)#"
                                Conexion="#getConexion(EcodigoSDC)#"
                                LDMovimientoInventario="#NumberFormat(rsCab_Movs_Inventario.Tipo_Movimiento, '00')#"
                                LDDepartamento="#NumberFormat(rsDet_Movs_Inventario.Tipo_Item, '00')#"
                                LDClasificacion="#NumberFormat(rsDet_Movs_Inventario.Clas_Item, '00')#"
                                LDFabricante="#NumberFormat(rsDet_Movs_Inventario.Cod_Fabricante, '00')#"
                                Impuestos="'No se ocupa'"
                                Oficinas="'No se ocupa'"
                                LDConceptoRetiroCaja="'No se ocupa'"
                                LDAlmacen="'No se ocupa'"
                                SNegocios="#NumberFormat(9999,'0000')#"
                                >
                            </cfinvoke>
                            <cfset ArrayAppend(CuentaLDAI_X_S, Cuenta)> 
                            
                            <!---"#sifTMovto.EQUcodigoSIF#"--->                   
                            
           					<!--- Llamado cta. contable con Origen Contable Almacen Entradas/Salidas --->
                            <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                                Oorigen="LDCA"
                                Ecodigo="#getEcodigo(EcodigoSDC)#"
                                Conexion="#getConexion(EcodigoSDC)#" 
                                LDAlmacen="#NumberFormat(Almacen, '00')#"
                                LDDepartamento="#NumberFormat( rsDet_Movs_Inventario.Tipo_Item, '00')#"
                                LDClasificacion="#NumberFormat( rsDet_Movs_Inventario.Clas_Item, '00')#"
                                LDFabricante="#NumberFormat( rsDet_Movs_Inventario.Cod_Fabricante, '00')#"
                               >
                            </cfinvoke>
                            <cfset ArrayAppend(CuentaLDCA_X_S, Cuenta)>
					</cfif>

            </cfif>
      </cfloop>                 
        
<!--- *********************** Insercion de Detalles de los Movimientos ****************************  --->
    <cftransaction>
      <cfloop query = "rsDet_Movs_Inventario">
        <cfset MontoLin = rsDet_Movs_Inventario.Cantidad * rsDet_Movs_Inventario.Costo>

            <cfif TipoMov EQ "RC">  <!--- (Recepcion Cedis) --->
             
             		<!--- Llamado cta. contable con Origen Contable Almacen de Venta --->
					<cfset NoLinea = NoLinea + 1>
					  <cfquery name="rsInsertaID18" datasource="sifinterfaces">
							insert into ID18 (
										ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
										Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
										Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
										Oficodigo, Miso4217,CFcodigo)
							values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#NoLinea#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#getEcodigo(EcodigoSDC)#">,
									<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(Fecha, 'dd/mm/yyyy')#">,
									#Periodo#, #Mes#, 
									<cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de Almacen de Venta (Recepcion CEDIS)">, 
									' ', ' ', 'D',
									0, 0, 0, 0,
									<cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
									<cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
									1, 0, getdate(), 0, 
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDAV_RC [rsDet_Movs_Inventario.CurrentRow].CFformato#">, 
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">,
									'MXP',
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCFN.EQUcodigoSIF#">)  
					  </cfquery>					
                    
                   <!--- Llamado cta. contable con Origen Contable Inventario en Transito --->
				   <cfset NoLinea = NoLinea + 1>
					 <cfquery name="rsInsertaID18" datasource="sifinterfaces">
						  insert into ID18 (
									  ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
									  Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
									  Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
									  Oficodigo, Miso4217,CFcodigo)
						  values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
								  <cfqueryparam cfsqltype="cf_sql_integer" value="#NoLinea#">,
								  <cfqueryparam cfsqltype="cf_sql_integer" value="#getEcodigo(EcodigoSDC)#">,
								  <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(Fecha, 'dd/mm/yyyy')#">,
								  #Periodo#, #Mes#, 
								  <cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de Inventario Transito (Recepcion CEDIS)">, 
								  ' ', ' ', 'C',
								  0, 0, 0, 0,
								  <cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
								  <cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
								  1, 0, getdate(), 0,
								  <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDIT_RC [rsDet_Movs_Inventario.CurrentRow].CFformato#">,  
								  <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">,
								  'MXP',
								  <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCFN.EQUcodigoSIF#">)  
				 </cfquery>
                
            <cfelseif TipoMov EQ "DC"> <!--- (Despacho Cedis) --->    	

				   <!--- Llamado cta. contable con Origen Contable Almacen de Venta --->
				      <cfset NoLinea = NoLinea + 1>
					  <cfquery name="rsInsertaID18" datasource="sifinterfaces">
						  insert into ID18 (
									  ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
									  Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
									  Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
									  Oficodigo, Miso4217,CFcodigo)
						  values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
								  <cfqueryparam cfsqltype="cf_sql_integer" value="#NoLinea#">,
								  <cfqueryparam cfsqltype="cf_sql_integer" value="#getEcodigo(EcodigoSDC)#">,
								  <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(Fecha, 'dd/mm/yyyy')#">,
								  #Periodo#, #Mes#, 
								  <cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de Almacen de Venta (Despacho CEDIS)">, 
								  ' ', ' ', 'C',
								  0, 0, 0, 0,
								  <cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
								  <cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
								  1, 0, getdate(), 0, 
								  <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDAV_DC [rsDet_Movs_Inventario.CurrentRow].CFformato#">, 
								  <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">,
								  'MXP',
								  <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCFN.EQUcodigoSIF#">)  
					  </cfquery>
                    
                   <!--- Llamado cta. contable con Origen Contable Inventario en Transito --->
					   <cfset NoLinea = NoLinea + 1>
                         <cfquery name="rsInsertaID18" datasource="sifinterfaces">
                              insert into ID18 (
                                          ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
                                          Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
                                          Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
                                          Oficodigo, Miso4217,CFcodigo)
                              values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
                                      <cfqueryparam cfsqltype="cf_sql_integer" value="#NoLinea#">,
                                      <cfqueryparam cfsqltype="cf_sql_integer" value="#getEcodigo(EcodigoSDC)#">,
                                      <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(Fecha, 'dd/mm/yyyy')#">,
                                      #Periodo#, #Mes#, 
                                      <cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de Inventario Transito (Despacho CEDIS)">, 
                                      ' ', ' ', 'D',
                                      0, 0, 0, 0,
                                      <cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
                                      <cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
                                      1, 0, getdate(), 0,
                                      <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDIT_DC [rsDet_Movs_Inventario.CurrentRow].CFformato#">,  
                                      <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">,
                                      'MXP',
                                      <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCFN.EQUcodigoSIF#">)  
                     </cfquery>  
                         
            <cfelseif TipoMov EQ "3"> 	<!--- (Movimientos InterAlmacen) ---> 
            <cfdump var= "'entre a TipoMov = 3'">
            <cfdump var= "'entre a TipoAjuste = S'">
            <cfdump var = "#Maximus#">
            
					<cfif TipoAjuste EQ "S">  <!--- Salidas --->
                    
						 <!--- Llamado cta. contable con Origen Contable Inventario en Transito --->
						 <cfset NoLinea = NoLinea + 1>
						   <cfquery name="rsInsertaID18" datasource="sifinterfaces">
								insert into ID18 (
											ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
											Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
											Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
											Oficodigo, Miso4217,CFcodigo)
								values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#NoLinea#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#getEcodigo(EcodigoSDC)#">,
										<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(Fecha, 'dd/mm/yyyy')#">,
										#Periodo#, #Mes#, 
										<cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de Inventario Transito Movs.InterAlmacen(Salidas)">, 
										' ', ' ', 'D',
										0, 0, 0, 0,
										<cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
										<cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
										1, 0, getdate(), 0,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDIT_3_S [rsDet_Movs_Inventario.CurrentRow].CFformato#">,  
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">,
										'MXP',
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCFN.EQUcodigoSIF#">)  
					   </cfquery>
						  
	  
						 <!--- Llamado cta. contable con Origen Contable Almacen Entradas/Salidas --->
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
										  <cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de Cuenta Almacen Movs.InterAlmacen(Salidas)">, 
										  ' ', ' ', 'C',
										  0, 0, 0, 0,
										  <cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
										  <cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
										  1, 0, getdate(), 0, 
										  <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDCA_3_S [rsDet_Movs_Inventario.CurrentRow].CFformato#">, 
										  <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">,
										  'MXP',
										  <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCFN.EQUcodigoSIF#">)  
							</cfquery>
						 
                    </cfif>

					<cfif TipoAjuste EQ "E">	<!--- Entradas --->

            <cfdump var= "'entre a TipoAjuste = E'">
            <cfdump var = "#Maximus#">
                    
						 <!--- Llamado cta. contable con Origen Contable Inventario en Transito --->
						 <cfset NoLinea = NoLinea + 1>
						   <cfquery name="rsInsertaID18" datasource="sifinterfaces">
								insert into ID18 (
											ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
											Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
											Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
											Oficodigo, Miso4217,CFcodigo)
								values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#NoLinea#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#getEcodigo(EcodigoSDC)#">,
										<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(Fecha, 'dd/mm/yyyy')#">,
										#Periodo#, #Mes#, 
										<cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de Inventario Transito gab1 Movs.InterAlmacen(Entradas)">, 
										' ', ' ', 'C',
										0, 0, 0, 0,
										<cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
										<cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
										1, 0, getdate(), 0,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDIT_3_E [rsDet_Movs_Inventario.CurrentRow].CFformato#">,  
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">,
										'MXP',
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCFN.EQUcodigoSIF#">)  
					   </cfquery>

                       <!--- Llamado cta. contable con Origen Contable Almacen Entradas/Salidas --->
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
										<cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de Cuenta Almacen Movs.InterAlmacen(Entradas)">, 
										' ', ' ', 'D',
										0, 0, 0, 0,
										<cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
										<cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
										1, 0, getdate(), 0, 
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDCA_3_E [rsDet_Movs_Inventario.CurrentRow].CFformato#">, 
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">,
										'MXP',
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCFN.EQUcodigoSIF#">)  
						  </cfquery>					   
					   
                    </cfif>

					<cfif TipoAjuste EQ "ES">	<!--- Entradas / Salidas --->
                    
            <cfdump var= "'entre a TipoAjuste = ES'">
            <cfdump var = "#Maximus#">
                    
						 <!--- Llamado cta. contable con Origen Contable Inventario en Transito --->
						 <cfset NoLinea = NoLinea + 1>
						   <cfquery name="rsInsertaID18" datasource="sifinterfaces">
								insert into ID18 (
											ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
											Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
											Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
											Oficodigo, Miso4217,CFcodigo)
								values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#NoLinea#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#getEcodigo(EcodigoSDC)#">,
										<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(Fecha, 'dd/mm/yyyy')#">,
										#Periodo#, #Mes#, 
										<cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de Cuenta Almacen Movs.InterAlmacen(Entradas/Salidas)">, 
										' ', ' ', 'D',
										0, 0, 0, 0,
										<cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
										<cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
										1, 0, getdate(), 0,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDCA_3_ES_D [rsDet_Movs_Inventario.CurrentRow].CFformato#">,  
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">,
										'MXP',
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCFN.EQUcodigoSIF#">)  
					   		</cfquery>					   
    
                       <!--- Llamado cta. contable con Origen Contable Almacen Entradas/Salidas --->
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
										<cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de Cuenta Almacen Movs.InterAlmacen(Entradas/Salidas)">, 
										' ', ' ', 'C',
										0, 0, 0, 0,
										<cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
										<cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
										1, 0, getdate(), 0, 
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDCA_3_ES_C [rsDet_Movs_Inventario.CurrentRow].CFformato#">, 
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">,
										'MXP',
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCFN.EQUcodigoSIF#">)  
						  </cfquery>
                          
						  <cfif rsCab_Movs_Inventario.Sucursal neq rsCab_Movs_Inventario.Sucursal_Destino>
                        
								 <!--- Llamado cta. contable con Origen Contable Inventario en Transito --->
                                 <cfset NoLinea = NoLinea + 1>
                                   <cfquery name="rsInsertaID18" datasource="sifinterfaces">
                                        insert into ID18 (
                                                    ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
                                                    Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
                                                    Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
                                                    Oficodigo, Miso4217,CFcodigo)
                                        values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
                                                <cfqueryparam cfsqltype="cf_sql_integer" value="#NoLinea#">,
                                                <cfqueryparam cfsqltype="cf_sql_integer" value="#getEcodigo(EcodigoSDC)#">,
                                                <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(Fecha, 'dd/mm/yyyy')#">,
                                                #Periodo#, #Mes#, 
                                                <cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de Inventario gab 2 Transito Movs.InterAlmacen(Entradas/Salidas)">, 
                                                ' ', ' ', 'C',
                                                0, 0, 0, 0,
                                                <cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
                                                <cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
                                                1, 0, getdate(), 0,
                                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDIT_3_ES [rsDet_Movs_Inventario.CurrentRow].CFformato#">,  
                                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">,
                                                'MXP',
                                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCFN.EQUcodigoSIF#">)  
                               </cfquery>
                               
                                 <!--- Llamado cta. contable con Origen Contable Inventario en Transito --->
                                 <cfset NoLinea = NoLinea + 1>
                                   <cfquery name="rsInsertaID18" datasource="sifinterfaces">
                                        insert into ID18 (
                                                    ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
                                                    Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
                                                    Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
                                                    Oficodigo, Miso4217,CFcodigo)
                                        values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
                                                <cfqueryparam cfsqltype="cf_sql_integer" value="#NoLinea#">,
                                                <cfqueryparam cfsqltype="cf_sql_integer" value="#getEcodigo(EcodigoSDC)#">,
                                                <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(Fecha, 'dd/mm/yyyy')#">,
                                                #Periodo#, #Mes#, 
                                                <cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de Inventario gab3 Transito Movs.InterAlmacen(Entradas/Salidas)">, 
                                                ' ', ' ', 'D',
                                                0, 0, 0, 0,
                                                <cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
                                                <cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
                                                1, 0, getdate(), 0,
                                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDIT_3_ES [rsDet_Movs_Inventario.CurrentRow].CFformato#">,  
                                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">,
                                                'MXP',
                                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCFN.EQUcodigoSIF#">)  
                               </cfquery>
                        </cfif>                          
                    </cfif>
                
            <cfelse> 	<!--- (Otros Movimientos) ---> 
            
                    <cfif TipoAjuste EQ "E">	<!--- Entradas --->
                    
                                <cfdump var= "'entre a TipoMov = 3'">
            <cfdump var= "'entre a TipoAjuste = E'">
            <cfdump var = "#Maximus#">
                    
          				    <!--- Llamado cta. contable con Origen Contable Ajuste de Inventario --->
							<cfset NoLinea = NoLinea + 1>
							
							<cfquery name="rsInsertaID18" datasource="sifinterfaces">
								  insert into ID18 (
											  ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
											  Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
											  Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
											  Oficodigo, Miso4217,CFcodigo)
								  values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
										  <cfqueryparam cfsqltype="cf_sql_integer" value="#NoLinea#">,
										  <cfqueryparam cfsqltype="cf_sql_integer" value="#getEcodigo(EcodigoSDC)#">,
										  <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(Fecha, 'dd/mm/yyyy')#">,
										  #Periodo#, #Mes#, 
										  <cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de Ajuste de Inventario (Entradas)">, 
										  ' ', ' ', 'C',
										  0, 0, 0, 0,
										  <cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
										  <cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
										  1, 0, getdate(), 0,
										  <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDAI_X_E [rsDet_Movs_Inventario.CurrentRow].CFformato#">,  
										  <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">,
										  'MXP',
										  <cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCFN.EQUcodigoSIF#">)  
							</cfquery>

						   <!--- Llamado cta. contable con Origen Contable Almacen Entradas/Salidas --->
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
											<cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de Cuenta Almacen (Entradas)">, 
											' ', ' ', 'D',
											0, 0, 0, 0,
											<cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
											<cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
											1, 0, getdate(), 0, 
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDCA_X_E [rsDet_Movs_Inventario.CurrentRow].CFformato#">, 
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">,
											'MXP',
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCFN.EQUcodigoSIF#">)  
							  </cfquery>
                    </cfif>							
						
                    <cfif TipoAjuste EQ "S">	<!--- Salidas --->
                    
						  <!--- Llamado cta. contable con Origen Contable Ajuste de Inventario --->
						  <cfset NoLinea = NoLinea + 1>
						  
						  <cfquery name="rsInsertaID18" datasource="sifinterfaces">
								insert into ID18 (
											ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
											Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
											Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
											Oficodigo, Miso4217,CFcodigo)
								values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#NoLinea#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#getEcodigo(EcodigoSDC)#">,
										<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(Fecha, 'dd/mm/yyyy')#">,
										#Periodo#, #Mes#, 
										<cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de Ajuste de Inventario (Salidas)">, 
										' ', ' ', 'D',
										0, 0, 0, 0,
										<cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
										<cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
										1, 0, getdate(), 0,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDAI_X_S [rsDet_Movs_Inventario.CurrentRow].CFformato#">,  
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">,
										'MXP',
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCFN.EQUcodigoSIF#">)  
						  </cfquery>						                                         
                            
           				   <!--- Llamado cta. contable con Origen Contable Almacen Entradas/Salidas --->
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
											<cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de Cuenta Almacen (Salidas)">, 
											' ', ' ', 'C',
											0, 0, 0, 0,
											<cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
											<cfqueryparam cfsqltype="cf_sql_money" value="#MontoLin#" null="#Len(Trim(MontoLin)) EQ 0#">,
											1, 0, getdate(), 0, 
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDCA_X_S [rsDet_Movs_Inventario.CurrentRow].CFformato#">, 
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#sifSUC.EQUcodigoSIF#">,
											'MXP',
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCFN.EQUcodigoSIF#">)  
							  </cfquery>							
					</cfif>

            </cfif>
        
			<!---  Por si se llega a ocupar el Centro Funcional
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#sifCF.EQUcodigoSIF#">) --->
        </cfloop>
        
    <!---         <cfquery name="rsBorra_Invent" datasource="sifinterfaces"> 
               delete 	DSIFLD_Movimientos_Inventario where Id_Movimiento = #Movimiento# 
                delete	ESIFLD_Movimientos_Inventario where Id_Movimiento = #Movimiento#  
            </cfquery>       --->   
             
	        <cfset disparaInterfaz(18, #Maximus#, EcodigoSDC)>  
        
      </cftransaction>
      <cfcatch type="anyx">
        <cfset InsertaError('CG_Inventario', Movimiento, 'ESIFLD_Movimientos_Inventario', 'Id_Movimiento')>
            <cfquery name="rsBorraCab_CGInventario" datasource="sifinterfaces"> 
                    delete from IE18 where ID = #Maximus#
            </cfquery>  
      </cfcatch>
    </cftry>
  </cfloop>
 </cffunction>
</cfcomponent>
