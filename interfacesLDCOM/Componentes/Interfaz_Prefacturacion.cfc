<!--- ABG: Transformacion Operaciones de Credito Prefacturacion Interfaz LD-SIF Ver. 1.0 --->
<!--- La interfaz de Ventas Operaciones de Credito Prefacturacion, procesa las ventas que tengan que  --->
<!--- Operarse desde el modulo de Prefacturacion de SIF --->
<!--- La Interfaz LD-SIF solo funciona con versiones de Coldfusion 8.0 en adelante --->

<cfcomponent extends="Interfaz_Base">		
	<cffunction name="Ejecuta" access="public" returntype="string" output="yes">
		<!--- Crear un Parametro Ver 2.0 --->
		<cfset ParBorrado = false>
		
		<!--- Extrae Encabezados de Ventas --->
		<cfquery name="rsEVentas" datasource="sifinterfaces">		
			select Ecodigo, Origen, Id_DocumentoV, Cliente, Tipo_Documento, Numero_Documento, 
				Subtotal,Descuento,Total, Vendedor,
				Moneda, Fecha_Venta, Dias_Credito, Retencion, 
				Sucursal, Tipo_Cedi, Tipo_Cambio, Tipo_Venta
			from ESIFLD_Facturas_Venta
			where Tipo_Venta in ('C','E')
			and Tipo_CEDI = 'N'
			and Estatus in (1,5)
		</cfquery>
		
		<cfif isdefined("rsEVentas") and rsEVentas.recordcount GT 0>
		<cfloop query="rsEVentas">
		<cftry>
			<cfset DocumentoFact = rsEVentas.Id_DocumentoV>
			<!--- Extrae Maximo+1 de tabla IE10 para insertar nuevo reg, en IE10 --->                      
			<cfset RsMaximo = ExtraeMaximo("IE10","ID")>
			<cfif isdefined(#RsMaximo.Maximo#) or #RsMaximo.Maximo# gt 0>
				<cfset Maximus = #RsMaximo.Maximo#>
			<cfelse>
				<cfset Maximus = 1>
			</cfif>
					
			<!---BUSCA EQUIVALENCIAS--->
			<!--- EMPRESAS --->
			<cfset Equiv = ConversionEquivalencia (rsEVentas.Origen, 'CADENA', rsEVentas.Ecodigo, rsEVentas.Ecodigo, 'Cadena')>
			<cfset varEcodigo = Equiv.EQUcodigoSIF>
			<cfset session.dsn = getConexion(varEcodigo)>
			
			<!---OFICINA --->
			<cfset Equiv = ConversionEquivalencia (rsEVentas.Origen, 'SUCURSAL', rsEVentas.Ecodigo, rsEVentas.Sucursal, 'Sucursal')>
			<cfset VarOficina = Equiv.EQUcodigoSIF>
				
			<!--- CENTRO FUNCIONAL--->
			<cfset Equiv = ConversionEquivalencia (rsEVentas.Origen, 'CENTRO_FUN', rsEVentas.Ecodigo, rsEVentas.Sucursal, 'Centro_Funcional')>
			<cfset varCF = Equiv.EQUcodigoSIF>
	
			<!--- MONEDA --->
			<cfset Equiv = ConversionEquivalencia (rsEVentas.Origen, 'MONEDA', rsEVentas.Ecodigo, rsEVentas.Moneda, 'Moneda')>
			<cfset varMoneda = Equiv.EQUcodigoSIF>
				
			<!--- , 'CLIENTE', 'ECODIGO' --->
			<cfset VarCte = ExtraeCliente(rsEVentas.Cliente, varEcodigo)>                                
				
			<!--- Calcula los dias de Credito --->
			<cfif rsEVentas.Dias_Credito LT 1>
				<cfset FechaVenc = rsEVentas.Fecha_Venta>
				<cfset DiasVenc = 0> 
			<cfelse>
				<cfset FechaVenc = DateAdd('d',rsEVentas.Dias_Credito,rsEVentas.Fecha_Venta)>
				<cfset DiasVenc = rsEVentas.Dias_Credito>
			</cfif>
					  
			<!--- Insercion de cabecera en IE22 --->
			<cfquery name="rsInsertaIE22" datasource="sifinterfaces">
				insert into IE22 
					(ID, Ecodigo, NumeroSocio, CodigoTransacion, Documento, CodigoMoneda, 
					 FechaTipoCambio, TipoCambio, Descuento, Vendedor, FechaDocumento, 
					 DiasVigencia, FechaVencimiento, CodigoOficina, NumeroOrdenCompra, 
					 StatusProceso, Observaciones, Origen, BMUsucodigo)
				values 
				(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
				 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo#">, 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEVentas.Cliente#">,
				 <cfqueryparam cfsqltype="cf_sql_char" value="#rsEVentas.Tipo_Documento#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEVentas.Numero_Documento#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
				 null,
				 <cfqueryparam cfsqltype="cf_sql_float" value="#numberformat(rsEVentas.Tipo_Cambio,'9.9999')#">,
				 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsEVentas.Descuento,'9.99')#">, 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEVentas.Vendedor#">,
				 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Fecha_Venta,'short')#">,
				 isnull(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsEVentas.Dias_Credito#">,0),
				 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(FechaVenc,'short')#">, 
				 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficina#">, 
				 null,
				 '10',
				 ' ',
				 'LDCC',
				 1)
			</cfquery> 
	
			<!--- Seleccion de Detalles en base a Id_DocumentoV de la Cabecera --->
			<cfquery name="rsDVentas" datasource="sifinterfaces">
				select  ECodigo, Id_Linea, isnull(Precio_Unitario, 0) as Precio_Unitario, Cantidad, 
					Cod_Impuesto, Impuesto_Lin, Descuento_Lin, Tipo_Item, Total_Lin, Clas_Item, 
					Cod_Fabricante, Tipo_Lin, cod_item, Subtotal_Lin
				from DSIFLD_Facturas_Venta
				where Id_DocumentoV = #DocumentoFact#
			</cfquery>
			
			<cfset IDlinea = 1>
			<cfif isdefined("rsDVentas") and rsDVentas.recordcount GT 0>
			<cfloop query = "rsDVentas">
				<!--- Busca equivalencia de IMPUESTO en SIF --->
				<cfset Equiv = ConversionEquivalencia (rsEVentas.Origen, 'IMPUESTO', rsEVentas.Ecodigo, rsDVentas.Cod_Impuesto, 'Cod_Impuesto')>
				<cfset VarImpuesto = Equiv.EQUcodigoSIF>
				
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
					Bancos="NOUSAR"
					LDCuentaBanco="NOUSAR"
					LDMovimientoInventario="NOUSAR"
					LDAlmacen="NOUSAR"
					LDTipoRetiroCaja="NOUSAR"
				>
				</cfinvoke>     				
				<cfset CuentaLDIV = Cuenta> 
		
				<cfquery name="rsInsertaID22" datasource="sifinterfaces">
					insert into ID22 
						(ID, Consecutivo, TipoItem, CodigoItem, PrecioUnitario, CantidadTotal, 
						 CodigoImpuesto, ImporteDescuento, CodigoAlmacen, CentroFuncional, 
						 CuentaFinancieraDet, PrecioTotal, Descripcion, Descripcion_Alt, BMUsucodigo)
					values 
					(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
					 <cfqueryparam cfsqltype="cf_sql_char" value="#rsDVentas.Tipo_Lin#">,  
					 <cfqueryparam cfsqltype="cf_sql_char" value="#rsDVentas.Cod_item#">,
					 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Precio_Unitario,'9.99')#">,
					  <cfqueryparam cfsqltype="cf_sql_float" value="#rsDVentas.Cantidad#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varImpuesto#">,
					 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Descuento_Lin,'9.99')#">,
					 ' ',
					 <cfqueryparam cfsqltype="cf_sql_char" value="#varCF#">, 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDIV.CFformato#">,
					 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Total_Lin,'9.99')#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="Ventas">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="Venta Credito del #dateformat(rsEVentas.Fecha_Venta, 'short')#">,
					 1)
				</cfquery>
				<cfset IDlinea = IDlinea + 1>
   			</cfloop> <!---Detalle Ventas --->
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
						when Estatus = 1 then 4
					else 2 end 
					where Id_DocumentoV = #DocumentoFact#
				</cfif>
        	</cfquery>
			
			<!---<cfset disparaInterfaz(22, #Maximus#, #varEcodigo#, 0)>--->
		<cfcatch>
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
					delete ID22
					where ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
				</cfquery>
				<cfquery datasource="sifinterfaces">
					delete IE22
					where ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
				</cfquery>
				<cfquery datasource="sifinterfaces">
					update IdProceso
					set Consecutivo = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#"> - 1
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
            <cfset MensajeError= #Mensaje# & #Detalle#>
			<cfquery datasource="sifinterfaces">
				insert into SIFLD_Errores 
				(Interfaz, Tabla, ID_Documento, MsgError, MsgErrorDet, MsgErrorSQL, MsgErrorParam)
				values 
				('PF_Ventas', 
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
	</cffunction>
</cfcomponent>