<!--- ABG: Transformacion Operaciones de Compra Interfaz LD-SIF Ver. 1.0 --->
<!--- La interfaz de Operaciones de Compra, procesa todas las compras generando los documentos de CxP correspondientes --->
<!--- La Interfaz LD-SIF solo funciona con versiones de Coldfusion 8.0 en adelante --->

<cfcomponent extends="Interfaz_Base">
	<cffunction name="Ejecuta" access="public" returntype="string" output="yes">
		<!--- Rutina para Obtener Parametros a Ocupar --->
		<cfset ParImp = true>
		<!--- Crear un Parametro Ver 2.0 --->
		<cfset ParBorrado = false>
		
		<!--- toma registros cabecera de las Compras --->
		<cfquery name="rsECompras" datasource="sifinterfaces">
			select Ecodigo, Origen, Id_DocumentoC, Proveedor, Tipo_Documento, 
				Numero_Documento, Moneda, Fecha_Compra, Fecha_Arribo, Retencion, 
				Sucursal, Almacen 
			from ESIFLD_Facturas_Compra
			where Estatus = 1
		</cfquery>
		
	  	<cfif isdefined("rsECompras") AND rsECompras.recordcount GT 0>
		<cfloop query="rsECompras">
		<cftry>
			<cfset DocumentoFact = rsECompras.Id_DocumentoC>
			
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
			<cfset varEcodigo = Equiv.EQUempSIF>
			<cfset session.dsn = getConexion(varEcodigo)>
			
			<!---OFICINA --->
			<cfset Equiv = ConversionEquivalencia (rsECompras.Origen, 'SUCURSAL', rsECompras.Ecodigo, rsECompras.Sucursal, 'Sucursal')>
            <cfset VarOficina = Equiv.EQUempSIF>
			
			<!--- CENTRO FUNCIONAL--->
			<cfset Equiv = ConversionEquivalencia (rsECompras.Origen, 'CENTRO_FUN', rsECompras.Ecodigo, rsECompras.Sucursal, 'Centro_Funcional')>
			<cfset varCF = Equiv.EQUempSIF>

            <!--- MONEDA --->
            <cfset Equiv = ConversionEquivalencia (rsECompras.Origen, 'MONEDA', rsECompras.Ecodigo, rsECompras.Moneda, 'Moneda')>
			<cfset varMoneda = Equiv.EQUempSIF>
             
            <!--- IETU --->
         	<cfset Equiv = ConversionEquivalencia (rsECompras.Origen, 'IETU', rsECompras.Ecodigo, 'CM', 'Tipo Operacion')>
			<cfset varIETU = Equiv.EQUempSIF>

			<!--- , 'CLIENTE', 'ECODIGO' --->
	         <cfset VarPrv = ExtraeCliente(rsECompras.Proveedor, varEcodigo)>  
			 						
			<!--- Insercion de cabecera en IE10 --->
			<cfquery datasource="sifinterfaces">
				insert into IE10 
					(ID, EcodigoSDC, NumeroSocio, Modulo, CodigoTransacion, 
					 Documento, Estado, CodigoMoneda, FechaDocumento, FechaVencimiento,
					 DiasVencimiento, Facturado, Origen, VoucherNo, CodigoRetencion, CodigoOficina, 
					 CuentaFinanciera, CodigoConceptoServicio, CodigoDireccionEnvio, CodigoDireccionFact, 
					 BMUsucodigo, ConceptoCobroPago, StatusProceso)
				values 
				(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
				 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo#">, 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Proveedor#">,
				 'CP',
				 <cfqueryparam cfsqltype="cf_sql_char" value="#rsECompras.Tipo_Documento#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Numero_Documento#">,
				 null, 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
				 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsECompras.Fecha_Compra,'short')#">, 
				 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsECompras.Fecha_Arribo,'short')#">, 
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
				 null, null, null, null,
				 0,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varIETU#">,
				 10)
			</cfquery>
			
			<!--- Seleccion de Detalles --->
			<cfquery name="rsDCompras" datasource="sifinterfaces">
				select Ecodigo, Id_Linea,  isnull(Precio_Unitario, 0) as Precio_Unitario, Cantidad, 
					Cod_Impuesto, Impuesto_Lin, Descuento_Lin, Tipo_Item, Total_Lin, Clas_Item, 
					Cod_Fabricante, Tipo_Lin, Cod_Item
				from DSIFLD_Facturas_Compra
				where ID_DocumentoC = #DocumentoFact#
			</cfquery>
			
			<cfset IDlinea = 1>
			<cfif isdefined("rsDCompras") and rsDCompras.recordcount GT 0>
			<cfloop query = "rsDCompras">
				<!--- Busca equivalencia de Impuesto en SIF --->
				<cfset Equiv = ConversionEquivalencia (rsECompras.Origen, 'IMPUESTO', rsDCompras.Ecodigo, rsDCompras.Cod_Impuesto, 'Cod_Impuesto')>
				<cfset VarImpuesto = Equiv.EQUempSIF>
				
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
					Oficinas="#varOficina#"		
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
					insert into ID10 
						(ID,Consecutivo, TipoItem, CodigoItem, NombreBarco, FechaHoraCarga, FechaHoraSalida, 
						PrecioUnitario,	CodigoUnidadMedida,CantidadTotal,CantidadNeta, CodEmbarque, 
						NumeroBOL, FechaBOL, TripNo, ContractNo, CodigoImpuesto, ImporteImpuesto, 
						ImporteDescuento, CodigoAlmacen, CodigoDepartamento, CentroFuncional,
						CuentaFinancieraDet, BMUsucodigo, PrecioTotal)
					values 
					(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
					 <cfqueryparam cfsqltype="cf_sql_char" value="#rsDCompras.Tipo_Lin#">,  
					 <cfqueryparam cfsqltype="cf_sql_char" value="#rsDCompras.Cod_Item#"> , 
					 ' ', getdate(), getdate(), 
					 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDCompras.Precio_Unitario,'9.99')#">,                 	 ' ', 
					 <cfqueryparam cfsqltype="cf_sql_float" value="#rsDCompras.Cantidad#">,
					 <cfqueryparam cfsqltype="cf_sql_float" value="#rsDCompras.Cantidad#">,
					 ' ', ' ', getdate(), ' ', ' ', 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varImpuesto#">, 
					 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDCompras.Impuesto_Lin,'9.99')#">, 
					 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDCompras.Descuento_Lin,'9.99')#">,                 	 <cfif rsDCompras.Tipo_Lin EQ 'A'>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="rsECompras.Almacen">
					 <cfelse>
						null,
					 </cfif>
					 null,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">, 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDCA.CFformato#">, 
					 1,
					 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDCompras.Total_Lin,'9.99')#">)
				</cfquery>
				<cfset IDlinea = IDlinea + 1>
			</cfloop>
			</cfif> <!--- Detalles Ventas --->
			
			<!--- Marca o Borra las Tablas Origen Registro Procesado --->
			<!--- BORRADO DE TABLAS ORIGEN --->  
        	<cfquery name="rsBorraDet_FactVen" datasource="sifinterfaces"> 
        		<cfif Parborrado>
					delete 	DSIFLD_Facturas_Compra where Id_DocumentoC = #DocumentoFact# 
    	        	delete	ESIFLD_Facturas_Compra where Id_DocumentoC = #DocumentoFact#     
				<cfelse>
					update ESIFLD_Facturas_Compra
					set Estatus = 2
					where Id_DocumentoC = #DocumentoFact#
				</cfif>
        	</cfquery>    

			<cfset disparaInterfaz(10, #Maximus#, #varEcodigo#,0)>
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
				update ESIFLD_Facturas_Compra
				set Estatus = 3
				where Id_DocumentoC = #DocumentoFact#
			</cfquery>
			<!--- Elimina Registros Insertados. Verifica si se grabo algo en las tablas --->
			<cfif isdefined("Maximus")>
				<cfquery datasource="sifinterfaces">
					delete ID10
					where ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
				</cfquery>
				<cfquery datasource="sifinterfaces">
					delete IE10
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
            <cfset MensajeError= #Mensaje# & #Detalle#>
			<cfquery datasource="sifinterfaces">
				insert into SIFLD_Errores 
				(Interfaz, Tabla, ID_Documento, MsgError, MsgErrorDet, MsgErrorSQL, MsgErrorParam)
				values 
				('CP_Compras', 
				 'ESIFLD_Facturas_Compra',
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#DocumentoFact#">, 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">) 
			</cfquery>
		</cfcatch>
		</cftry>
		</cfloop> <!--- Encabezado de Compras --->
		</cfif>
	</cffunction>
</cfcomponent>


   
					
		
		