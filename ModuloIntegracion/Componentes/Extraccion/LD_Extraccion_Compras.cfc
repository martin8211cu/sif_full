<!----
	Author: 	   Rodrigo Ivan Rivera Meneses
	Name: 		   LD_Extraccion_Compras.cfc
	Based on :     Extraccion_Compras.cfc by Alejandro Bolaños
	Version: 	   1.0
	Date Created:  19-NOV-2015
	Date Modified: 19-NOV-2015
	Hint:		   This Process is heavy on the memory, if you get the java overhead limit exceeded error,
				   avoid calling the GC directly and instead increase the java heap size in the coldfusion administrator
	NOTE:		   Highly inefficient, extracción query should be one and stored in a temp table, then mass insert operations, if error then rollback, same applies to all extractions.
	Adecuaciones Israel Rodríguez
	Se agrega Fecha de Vencimiento
	Se Agregan los códigos de Impuestos Correspondientes a las Notas de Crédito por Artículos Faltantes
--->
<cfcomponent extends="ModuloIntegracion.Componentes.Interfaz_base" output="false"> <!--- Cambiar a true para ver error en pantalla --->
<cffunction name="Ejecuta" access="public" returntype="string" output="false">
	<!--- Asigna Variables --->
	<cfset DataSource = 'ldcom'>
	<cfset ErrCaja 	  = "">
	<cfset ErrBodega  = "">
	<cfset ErrFactura = "">
	<cfset fechaini   = "">
	<cfset fechafin   = "">
	<cfset ParPorIVA  = true>
	<!--- Asigna Variables de Fechas --->
	<cfif isdefined("form.fechaIni") and isdefined("form.fechaFin")>
		<cfset fechaini = createdate(right(form.fechaini,4),mid(form.fechaini,4,2),left(form.fechaini,2))>
		<cfset fechafin = createdatetime(right(form.fechafin,4),mid(form.fechafin,4,2),left(form.fechafin,2),23,59,59)>
	<cfelse>
		<cfset fechaini = createdate(YEAR(NOW() -1), MONTH(NOW() -1), DAY(NOW() -1))>
		<cfset fechafin = createdatetime(YEAR(NOW()), MONTH(NOW()), DAY(NOW()),23,59,59)>
	</cfif>

	<cfset Suc_Id = -1>
	<cfif isdefined("form.cbo_Sucursal_Ext")>
		<cfset Suc_Id = #form.cbo_Sucursal_Ext#>
	</cfif>

	<!--- SE OBTIENE EL NOMBRE DE LA BASE DE DATOS DEL DATASOURCE SIFINTERFACES --->
	<cfset databaseNameInt = getDatabaseName("sifinterfaces")>

	<!--- Obtiene operaciones no procesadas --->
	<cfinvoke component = "ModuloIntegracion.Componentes.Operaciones" method="init" returnvariable="O" />
	<!--- <cfset varArguments = {DataSource = "#DataSource#",
						   Estado 	  = "CERR",
						   FechaIni   = "#fechaini#",
						   FechaFin   = "#fechafin#",
						   Proceso    = "COMPRAS",
						   Sucursal   = "#Suc_Id#"}>
	<cfset rsOperacionID = O.getOperacionesLD(argumentCollection = varArguments)> --->

	<cfquery name="rsCadenasEquiv" datasource="sifinterfaces">
		select  SIScodigo, CATcodigo, EQUempOrigen, EQUcodigoOrigen, EQUempSIF, EQUcodigoSIF, EQUidSIF
		from SIFLD_Equivalencia
		where SIScodigo = 'LD'
			and CATcodigo = 'CADENA'
	</cfquery>

	<!--- Proceso --->
	<cfif isdefined("rsCadenasEquiv") and rsCadenasEquiv.recordcount GT 0>
		<cfloop query="rsCadenasEquiv">
		<cfset Emp_Id = #rsCadenasEquiv.EQUempOrigen#>
		<cftry>
			<!--- Obtiene la Moneda Local --->
			<cfset rsMoneda = O.getMonedaLD(DataSource,Emp_Id)>
			<cfif rsMoneda.recordcount EQ 0>
				<cfthrow message="Error al extraer la moneda Local">
			</cfif>
			<!--- Extrae los ENCABEZADOS para las Compras y Devoluciones que pertenecen a las operaciones Cerradas al momento de la ejecucion --->
			<cfset rsECompras = getEncabezado(DataSource,Emp_Id,Suc_Id,fechaini,fechafin)>
			<!--- Recorremos los encabezados Insertandolos y extrayendo sus detalles de Pago y detalles de Venta --->
			<cfif isdefined("rsECompras") AND recordcount GT 0>
				<cfloop query="rsECompras">
					<!--- ID para la tabla de Encabezados --->
					<cfquery name="rsMaxIDE" datasource="sifinterfaces">
						SELECT 	isnull(max(ID_DocumentoC),0) + 1 as MaxID
						  FROM 	ESIFLD_Facturas_Compra
					</cfquery>
					<!--- Crea el numero de Documento --->
					<cfif Tipo_Compra EQ "C" OR Tipo_Compra EQ "E">
						<cfset Num_Doc = Factura_Id>
					<cfelseif Tipo_Compra EQ "A">
						<cfset Num_Doc = "NCF-" & Factura_Id>
					<cfelseif Tipo_Compra EQ "D">
						<cfset Num_Doc = numberformat(Emp_Id,"00") & "-" & numberformat(Suc_Id,"0000") & numberformat(Bodega_Id,"000") & "-" & numberformat(Factura_Id,"000000000")>
					</cfif>
					<cftransaction action="begin">
					<cftry>
						<!--- Inserta los encabezados --->
						<cfquery datasource="sifinterfaces">
							INSERT INTO ESIFLD_Facturas_Compra
								(Ecodigo, Origen, ID_DocumentoC, Tipo_Documento, Tipo_Compra, Fecha_Compra,Fecha_Arribo,
								Fecha_Vencimiento, Numero_Documento, Proveedor, IETU_Clas, Subtotal, Descuento, Impuesto, Total,
								Vendedor, Sucursal, Moneda, Tipo_Cambio, Retencion, Observaciones,
								Almacen, Estatus, Fecha_Inclusion, IEPS, Remision,TimbreFiscal)
							VALUES
							   (<cfqueryparam cfsqltype="cf_sql_integer" value="#rsECompras.Cadena_Id#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="LD">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Tipo_Doc#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Tipo_Compra#">,
								<cfqueryparam cfsqltype="cf_sql_date" 	 value="#dateformat(rsECompras.Fecha_Compra,"short")#">,
								<cfqueryparam cfsqltype="cf_sql_date" 	 value="#dateformat(rsECompras.Fecha_Arribo,"short")#">,
								<cfqueryparam cfsqltype="cf_sql_date" 	 value="#dateformat(rsECompras.Fecha_Vencimiento,"short")#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Num_Doc#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Prov_Id#">,
								<cfqueryparam cfsqltype="cf_sql_null" 	 value="" null="true">,
								<cfqueryparam cfsqltype="cf_sql_money"   value="#numberformat(rsECompras.Factura_Subtotal,"9.9999")#">,
								<cfqueryparam cfsqltype="cf_sql_money"   value="#numberformat(rsECompras.Factura_Descuento,"9.9999")#">,
								<cfqueryparam cfsqltype="cf_sql_money"   value="#numberformat(rsECompras.Factura_Impuesto,"9.9999")#">,
								<cfqueryparam cfsqltype="cf_sql_money"   value="#numberformat(rsECompras.Factura_Total,"9.9999")#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="0">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Suc_Id#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Moneda_Id#">,
								<cfif isDefined("rsECompras.Moneda_Id") AND #rsECompras.Moneda_Id# GT 1>
									<!--- Tipo de cambio moneda ext. --->
									<cfqueryparam cfsqltype="cf_sql_money" value="#rsECompras.Boleta_Tipo_Cambio#">,
								<cfelse>
									1, <!--- Tipo de cambio para moneda local. --->
								</cfif>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Bodega_Id#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
								'#DateFormat(now(),'yyyy-mm-dd HH:mm:ss')#',
								<cfqueryparam cfsqltype="cf_sql_money"   value="#numberformat(rsECompras.Factura_IEPS,"9.9999")#">,
								0,
								<cfif rsECompras.TimbreFiscal EQ 'Sin Timbre'>
									''
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.TimbreFiscal#">
								</cfif>
								)
						</cfquery>
						<cftransaction action="commit" />
					<cfcatch type="any">
						<cftransaction action="rollback" />
						<!--- Variables de Error --->
						<cfset ErrBodega = rsECompras.Bodega_Id>
						<cfset ErrFactura = Factura_Id>
						<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
						<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
						<cfthrow message="Error al Insertar el Encabezado: #cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
					</cfcatch>
					</cftry>
					</cftransaction>

					<!--- INICIALIZACION DE LINEA PARA FACTURA --->
					<cfset IDlinea = 1>

					<!--- INICIA VALIDACION DE FACTURAS DE GASTO EGS--->
					<!--- Se obtienen facturas asociadas a la boleta --->
					<cfset rsEComprasFactGasto = getEncabezadoFactGasto(DataSource,Emp_Id,Suc_Id,Boleta_Id, #rsECompras.Factura_Id#)>
					<cfloop query="rsEComprasFactGasto">
						<!--- INSERTA DETALLE GENERICO, PARA FACTURA DE GASTO --->
						<cftransaction action="begin">
						<cftry>
							<cfset varConcepto = #rsEComprasFactGasto.tipoFactura#>
							<cfquery datasource="sifinterfaces">
								insert into DSIFLD_Facturas_Compra
									(Ecodigo, ID_DocumentoC, ID_linea, Tipo_Lin, Tipo_Item, Clas_Item, Cantidad,
									 Total_Lin, Cod_Item, Cod_Fabricante, Cod_Impuesto, Precio_Unitario, Descuento_Lin,
									 Descuento_Fact, Subtotal_Lin, Impuesto_Lin, codIEPS, MontoIEPS, afectaIVA)
								values
								(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsEComprasFactGasto.Cadena_Id#">,
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">,
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">,<!--- LINEA INICIAL --->
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="S">,<!--- TIPO LINEA --->
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="1">,<!--- TIPO ITEM --->
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="0">,<!--- TIPO ARTICULO --->
								 <cfqueryparam cfsqltype="cf_sql_float"   value="1">,<!--- CANTIDAD --->
								 <cfqueryparam cfsqltype="cf_sql_money"   value="#numberformat(rsEComprasFactGasto.Factura_Total,"9.9999")#">, <!--- TOTAL FACTURA --->
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varConcepto#">, <!--- CODIGO ITEM --->
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="0">,<!--- COD. FABRICANTE --->
								 <!--- Como Ld no env�a codigo de impuesto, se valida,
								       si el monto del impuesto es mayor a 0, el codigo del impuesto es 1
								       de lo contrario se queda en 0
								  --->
								 <cfif #rsEComprasFactGasto.Factura_Impuesto# GT 0>
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="1">,<!--- COD. IMPUESTO --->
								 <cfelse>
								 	<cfqueryparam cfsqltype="cf_sql_varchar" value="0">,<!--- COD. IMPUESTO --->
								 </cfif>
								 <cfqueryparam cfsqltype="cf_sql_money"   value="#numberformat(rsEComprasFactGasto.Factura_Subtotal+rsEComprasFactGasto.Factura_Descuento,"9.9999")#">,
								 <cfqueryparam cfsqltype="cf_sql_money"   value="#numberformat(rsEComprasFactGasto.Factura_Descuento,"9.9999")#">,
								 <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
								 <cfqueryparam cfsqltype="cf_sql_money"   value="#numberformat(rsEComprasFactGasto.Factura_Subtotal,"9.9999")#">,
								 <cfqueryparam cfsqltype="cf_sql_money"   value="#numberformat(rsEComprasFactGasto.Factura_Impuesto,"9.9999")#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="0">,<!--- COD. IEPS --->
								 <cfqueryparam cfsqltype="cf_sql_money"   value="#numberformat(0,"9.9999")#">,<!--- MONTO IEPS --->
								 <cfqueryparam cfsqltype="cf_sql_bit" 	  value="0">)<!--- AFECT IVA --->
							</cfquery>
							<cfset IDlinea = IDlinea + 1>
							<cftransaction action="commit" />
						<cfcatch type="any">
							<cftransaction action="rollback" />
							<!--- Borra los registros para el Encabezado que se habia Insertado--->
							<cfquery datasource="sifinterfaces">
								delete DSIFLD_Facturas_Compra
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsECompras.Cadena_Id#">
									and ID_DocumentoC =	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">
								delete ESIFLD_Facturas_Compra
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsECompras.Cadena_Id#">
									and ID_DocumentoC =	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">
							</cfquery>
							<!--- Variables de Error --->
							<cfset ErrBodega = rsECompras.Bodega_Id>
							<cfset ErrFactura = rsECompras.Factura_Id>
							<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
							<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
							<cfthrow message="Error Insertando Detalle de Compra FACTURA GASTO: #cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
						</cfcatch>
						</cftry>
						</cftransaction>

					</cfloop>
					<!--- TERMINA VALIDACION DE FACTURAS DE GASTO EGS --->


					<!--- Busca e Inserta los DETALLES del Encabezado --->
					<!--- Busca equivalencias --->
					<!--- EMPRESAS --->
					<cfset Equiv 		 = ConversionEquivalencia ('LD', 'CADENA', Emp_Id, Emp_Id, 'Cadena')>
					<cfset varEcodigo 	 = Equiv.EQUidSIF>
					<cfset rsDCompras = getDetalle(DataSource,Emp_Id,Suc_Id,Factura_Id,rsECompras.Bodega_Id,Boleta_Id,varEcodigo)>
					<cfif isdefined("rsDCompras") and rsDCompras.recordcount GT 0>
					<cfloop query="rsDCompras">
						<cftransaction action="begin">
						<cftry>
							<cfif ParPorIVA>
								<cftry>
									<cfif Cod_Impuesto EQ 1>
										<cfset varConcepto = 'COMPRA16'>
									<cfelseif Cod_Impuesto GT 0 AND Cod_Impuesto NEQ 1>
										<cfset varConcepto = 'COMPRA#Cod_Impuesto#'>
									<cfelse>
										<cfset varConcepto = 'COMPRA0'>
									</cfif>
								<cfcatch>
									<cfset varConcepto = 'COMPRA'>
								</cfcatch>
								</cftry>
							<cfelse>
								<cfset varConcepto = 'COMPRA'>
							</cfif>
							<cfquery datasource="sifinterfaces">
								insert into DSIFLD_Facturas_Compra
									(Ecodigo, ID_DocumentoC, ID_linea, Tipo_Lin, Tipo_Item, Clas_Item, Cantidad,
									 Total_Lin, Cod_Item, Cod_Fabricante, Cod_Impuesto, Precio_Unitario, Descuento_Lin,
									 Descuento_Fact, Subtotal_Lin, Impuesto_Lin, codIEPS, MontoIEPS, afectaIVA)
								values
								(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsECompras.Cadena_Id#">,
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">,
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="S">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDCompras.Depto_Id#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDCompras.Tipo_Articulo_Id#">,
								 <cfqueryparam cfsqltype="cf_sql_float"   value="#rsDCompras.Cantidad#">,
								 <cfqueryparam cfsqltype="cf_sql_money"   value="#numberformat(rsDCompras.Total,"9.9999")#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varConcepto#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDCompras.Casa_Id#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDCompras.Cod_Impuesto#">,
								 <cfqueryparam cfsqltype="cf_sql_money"   value="#numberformat(rsDCompras.Precio_Unitario,"9.9999")#">,
								 <cfqueryparam cfsqltype="cf_sql_money"   value="#numberformat(rsDCompras.Descuento,"9.9999")#">,
								 <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
								 <cfqueryparam cfsqltype="cf_sql_money"   value="#numberformat(rsDCompras.Subtotal,"9.9999")#">,
								 <cfqueryparam cfsqltype="cf_sql_money"   value="#numberformat(rsDCompras.Impuesto,"9.9999")#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDCompras.codIEPS#">,
								 <cfqueryparam cfsqltype="cf_sql_money"   value="#numberformat(rsDCompras.IEPS,"9.9999")#">,
								 <cfqueryparam cfsqltype="cf_sql_bit" 	  value="#rsDCompras.afectaIVA#">)
							</cfquery>
							<cfset IDlinea = IDlinea + 1>
							<cftransaction action="commit" />
						<cfcatch type="any">
							<cftransaction action="rollback" />
							<!--- Borra los registros para el Encabezado que se habia Insertado--->
							<cfquery datasource="sifinterfaces">
								delete DSIFLD_Facturas_Compra
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsECompras.Cadena_Id#">
									and ID_DocumentoC =	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">
								delete ESIFLD_Facturas_Compra
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsECompras.Cadena_Id#">
									and ID_DocumentoC =	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">
							</cfquery>
							<!--- Variables de Error --->
							<cfset ErrBodega = rsECompras.Bodega_Id>
							<cfset ErrFactura = rsECompras.Factura_Id>
							<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
							<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
							<cfthrow message="Error Insertando Detalle de Compra: #cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
						</cfcatch>
						</cftry>
						</cftransaction>
					</cfloop> <!---Detalles Compra--->
					</cfif>
				</cfloop> <!--- Encabezados Compra--->
				</cfif>
				<!--- Inserta Operacion ID a Bitacora --->
				<cfset varArgumentsBP = {Sistema = "LD",
										 Empresa = "#Emp_Id#",
										 Sucursal = "#Suc_Id#",
										 Operacion = "#Suc_Id#",
										 Proceso = "COMPRAS"}>
				<cfset BitacoraProcesos = O.setBitacoraProcesos(argumentCollection=varArgumentsBP)>
			<cfcatch type="any">
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
				<!--- Busca Errores de SQL y Parametros --->
				<cfif isdefined("cfcatch.sql")>
					<cfset ErrSQL = cfcatch.sql>
				<cfelse>
					<cfset ErrSQL = "">
				</cfif>
				<cfif isdefined("cfcatch.where")>
					<cfset ErrPAR = cfcatch.where>
				<cfelse>
					<cfset ErrPAR = "">
				</cfif>
				<!--- Inserta Log de Error --->
				<cfset varArgumentsLE = {Sistema="LD",
										 Empresa="#Emp_Id#",
										 Sucursal="#Suc_Id#",
										 Operacion="#Suc_Id#",
										 ErrCaja="#ErrCaja#",
										 ErrBodega="#ErrBodega#",
										 ErrFactura="#ErrFactura#",
										 MsgError="#cfcatch.Message#",
										 Error_Comp="#cfcatch.Message# #cfcatch.Detail# #ErrSQL# #ErrPAR#",
										 Proceso="COMPRAS"}>
				<cfset LogErrores = O.setLogErrores(argumentCollection=varArgumentsLE)>
			</cfcatch>
			</cftry>
		</cfloop> <!--- Operacion ID --->
	<cfelse>
		<!--- Inserta Log de Error --->
		<cfset varArgumentsLE = {Sistema="LD",
								 MsgError="No hay Cierres de Sucursal para el Dia de Hoy",
								 Error_Comp="No hay Cierres de Sucursal para el Dia de Hoy",
								 Proceso="COMPRAS"}>
		<cfset LogErrores = O.setLogErrores(argumentCollection=varArgumentsLE)>
	</cfif>
</cffunction>

<!--- FACTURAS DE GASTO (NUEVO) EGS--->
<cffunction name="getEncabezadoFactGasto" access="private" output="false">
	<cfargument name="DataSource" type="string" required="True"  default="" />
	<cfargument name="Emp_Id" 	  type="string" required="true"  default="CERR" hint="CERR, ABIE, etc. (case sensitive)"/>
	<cfargument name="Suc_Id"     type="string" required="false" default=0 />
	<cfargument name="Boleta_Id"     type="string" required="false" default=0 />
	<cfargument name="Factura_Id"     type="string" required="false" default=0 />

	<cfquery name="rsEComprasGtos" datasource="#Arguments.DataSource#">
		SELECT b.Emp_id,
		       b.Suc_Id,
		       p.Cadena_Id,
		       convert(varchar,b.Factura_Id) AS Factura_Id,
		       b.Bodega_id,
		       b.Boleta_id,
		       'FC' AS Tipo_Doc,
		       'C' AS Tipo_Compra,
		       b.Factura_Fecha AS Fecha_Compra,
		       e.Factura_Fecha_Vencimiento AS Fecha_Arribo,
		       p.Prov_CodigoExterno	AS Prov_Id,
		       round(b.Factura_Subtotal_Gravado, 4) AS Factura_Subtotal,
		       round(b.Factura_Desc_Gravado,4) AS Factura_Descuento,
		       round(b.Factura_Impuesto,4) AS Factura_impuesto,
		       0 AS Factura_IEPS,
		       round((b.Factura_Subtotal_Gravado+b.Factura_Subtotal_Exento+b.Factura_Impuesto)-(b.Factura_Desc_Exento+b.Factura_Desc_Gravado+b.Factura_Retencion_IVA+b.Factura_Retencion_ISR),4) AS Factura_Total,
		       '' AS TimbreFiscal,
		       0 NotaCredito,
		       <!--- CASE
		           WHEN COALESCE(e.Boleta_Plazo_Credito,0) > COALESCE(pa.Agencia_Plazo_Credito,0) THEN e.Boleta_Fecha_Pago
				   ELSE e.Factura_Fecha + pa.Agencia_Plazo_Credito
		       END AS Fecha_Vencimiento, --->
		       e.Boleta_Fecha_Pago AS Fecha_Vencimiento,
		       CASE
		           WHEN b.Factura_Tipo_id = 1 THEN 'FLETE'
		           WHEN b.Factura_Tipo_id = 2 THEN 'DESCARGA'
		       END AS tipoFactura
		FROM Boleta_Local_Factura_Gasto b
		INNER JOIN Boleta_Local_Fact_Enc e ON e.Boleta_Id = b.Boleta_id
		AND e.Emp_Id = b.Emp_id
		AND e.Suc_Id = b.Suc_id
		LEFT JOIN Proveedor p ON b.Emp_Id = p.Emp_Id
		AND b.Prov_Id = p.Prov_Id
		WHERE b.Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Emp_Id#">
		<cfif Suc_Id NEQ -1>
		  AND b.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Suc_Id#">
		</cfif>
		  AND b.Boleta_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Boleta_Id#">
		  AND b.Factura_Id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Factura_Id#">
		GROUP BY b.Emp_id,
		         b.Suc_Id,
		         p.Cadena_Id,
		         b.Factura_Id,
		         b.Bodega_id,
		         b.Boleta_id,
		         b.Factura_Fecha,
		         e.Factura_Fecha_Vencimiento,
		         p.Prov_CodigoExterno,
		         b.Factura_Subtotal_Gravado,
		         b.Factura_Desc_Gravado,
		         b.Factura_Impuesto,
		         b.Factura_Subtotal_Exento,
		         b.Factura_Desc_Exento,
		         b.Factura_Retencion_IVA,
		         b.Factura_Retencion_ISR,
		         e.Factura_Fecha,
		         b.Factura_Tipo_id,
		         e.Boleta_Plazo_Credito,
		         e.Boleta_Fecha_Pago
	</cfquery>
	<cfreturn rsEComprasGtos>
</cffunction>

<cffunction name="getEncabezado" access="private" output="false">
	<cfargument name="DataSource" type="string" required="True"  default="" />
	<cfargument name="Emp_Id" 	  type="string" required="true"  default="CERR" hint="CERR, ABIE, etc. (case sensitive)"/>
	<cfargument name="Suc_Id"     type="string" required="false" default=0 />
	<cfargument name="FechaIni"   type="date" 	required="false" default=0 />
	<cfargument name="FechaFin"   type="date" 	required="false" default=0 />
	<cfset dateIni = CreateDateTime(YEAR(FechaIni), MONTH(FechaIni), DAY(FechaIni), 00, 00, 00)>
	<cfset dateFin = CreateDateTime(YEAR(FechaFin), MONTH(FechaFin), DAY(FechaFin), 23, 59, 59)>

	<!--- DOCUMENTOS EXISTENTES --->
	<cfquery name="rsEncComprasExist" datasource="sifinterfaces">
		SELECT DISTINCT CONCAT(RTRIM(LTRIM(COALESCE(Numero_Documento, ''))), ':',
		                       RTRIM(LTRIM(COALESCE(Proveedor, '')))) AS Numero_Documento
		FROM ESIFLD_Facturas_Compra
		WHERE Fecha_Compra BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateIni#">
								    AND
								   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateFin#">
	</cfquery>

	<cfquery name="rsECompras" datasource="#Arguments.DataSource#">
		<!--- FACTURAS --->
		SELECT f.Emp_Id,
		       f.Suc_Id,
		       p.Cadena_Id,
		       CONVERT(varchar,f.Factura_Id) AS Factura_Id,
		       f.Bodega_Id,
		       f.Boleta_Id,
		       'FC' AS Tipo_Doc,
		       'C' AS Tipo_Compra,
		       f.Factura_Fecha AS Fecha_Compra,
		       f.Factura_Fecha_Vencimiento AS Fecha_Arribo,
		       COALESCE(p.Prov_CodigoExterno, f.Prov_Id) AS Prov_Id,
		       SUM(round(Factura_Subtotal, 4)) AS Factura_Subtotal,
		       SUM(round(Factura_Descuento,4)) AS Factura_Descuento,
		       SUM(round(Factura_Impuesto,4)) AS Factura_impuesto,
		       SUM(round(Factura_IEPS,4)) AS Factura_IEPS,
		       SUM(round(Factura_Total+f.Factura_IEPS,4)) AS Factura_Total,
		       f.Factura_Folio_Fiscal AS TimbreFiscal,
		       sum(coalesce(f.Nota_Total,0)) NotaCredito,
		       CASE
		           WHEN COALESCE(f.Boleta_Plazo_Credito,0) > COALESCE(pa.Agencia_Plazo_Credito,0) THEN f.Boleta_Fecha_Pago
				   ELSE f.Factura_Fecha + pa.Agencia_Plazo_Credito
		       END AS Fecha_Vencimiento,
		       f.Moneda_Id,
		       f.Boleta_Tipo_Cambio
		FROM Boleta_Local_Fact_Enc f
		INNER JOIN Boleta_Local_Encabezado_Hist l ON l.Emp_Id = f.Emp_Id
		AND l.Suc_Id = f.Suc_Id
		AND l.Boleta_Id = f.Boleta_Id
		AND l.Prov_Id = f.Prov_Id
		LEFT JOIN Proveedor p ON f.Emp_Id = p.Emp_Id
		AND f.Prov_Id = p.Prov_Id
		INNER JOIN Proveedor_Agencia pa ON p.Emp_Id = pa.Emp_Id
		AND p.Prov_Id = pa.Prov_Id
		AND f.Agencia_Id = pa.Agencia_Id
		WHERE f.Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Emp_Id#">
		<cfif Suc_Id NEQ -1>
		  AND f.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Suc_Id#">
		</cfif>
		  AND UPPER(RTRIM(LTRIM(l.Boleta_Estado))) IN ('AP', 'DI')
		  AND ROUND(Factura_Total+f.Factura_IEPS,4) > 0
		  AND Factura_Fecha BETWEEN
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateIni#">
				AND
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateFin#">

			<cfif rsEncComprasExist.RecordCount GT 0>
			 AND CONCAT(RTRIM(LTRIM(COALESCE(CONVERT(varchar,f.Factura_Id), ''))), ':',
		                      RTRIM(LTRIM(COALESCE(p.Prov_CodigoExterno, f.Prov_Id)))) NOT IN (
				<cfloop query="rsEncComprasExist">
					<cfif rsEncComprasExist.CurrentRow NEQ rsEncComprasExist.RecordCount>
						'#rsEncComprasExist.Numero_Documento#',
					<cfelse>
						'#rsEncComprasExist.Numero_Documento#'
					</cfif>
				</cfloop>
			)
			</cfif>
	GROUP BY f.Emp_Id,
	         f.Suc_Id,
	         p.Cadena_Id,
	         f.Factura_Id,
	         f.Bodega_Id,
	         f.Boleta_Id,
	         f.Factura_Fecha,
	         f.Factura_Fecha_Vencimiento,
	         f.Prov_Id,
	         p.Prov_CodigoExterno,
	         f.Factura_Folio_Fiscal,
	         pa.Agencia_Plazo_Credito,
	         f.Moneda_Id,
	         f.Boleta_Tipo_Cambio,
	         f.Boleta_Plazo_Credito,
	         f.Boleta_Fecha_Pago
		UNION
		<!---DEVOLUCIONES DE PROVEEDOR --->
		SELECT 	f.Emp_Id, f.Suc_Id, p.Cadena_Id, convert(varchar,Devolucion_Id) as Factura_Id, Bodega_Id, Boleta_Id, 'NC' as Tipo_Doc,
				'D' as Tipo_Compra, Devolucion_Fecha, Devolucion_Fecha_Aplica as Fecha_Arribo,p.Prov_CodigoExterno AS Prov_Id,
				round((Devolucion_Subtotal_Exento + Devolucion_Subtotal_Gravado),4) as Factura_Subtotal,
				round((Devolucion_Desc_Exento + Devolucion_Desc_Gravado),4) as Factura_Descuento,
				round(Devolucion_Impuesto,4) as Factura_Impuesto,
				round(Devolucion_IEPS,4) as Factura_IEPS,
				round(Devolucion_Total,4) as Factura_Total,
				'Sin Timbre' as TimbreFiscal,
				0  NotaCredito,
				Devolucion_Fecha as Fecha_Vencimiento,
				1 AS moneda_id,
                1 AS boleta_tipo_cambio
		FROM 	Inv_Dev_Proveedor_Encabezado f
			LEFT JOIN Proveedor p
			  ON f.Emp_Id = p.Emp_Id
			  AND f.Proveedor_Id = p.Prov_Id
			INNER JOIN Sucursal s
			ON f.Emp_Id = s.Emp_Id and f.Suc_Id = s.Suc_Id
		WHERE  	f.Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Emp_Id#">
			<cfif Suc_Id NEQ -1>
			  AND f.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Suc_Id#">
			</cfif>
			AND Devolucion_Fecha_Aplica BETWEEN
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateIni#">
				AND
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateFin#">
			AND Devolucion_Estado = 'AP'
		UNION
		<!--- Notas de Credito Automaticas --->
		SELECT 	d.Emp_Id, d.Suc_Id, p.Cadena_Id, d.Factura_Numero as Factura_Id, d.Bodega_Id, d.Boleta_Id,
				'NC' as Tipo_Doc,'A' as Tipo_Compra, f.Factura_Fecha as Fecha_Compra,
				f.Factura_Fecha_Vencimiento as Fecha_Arribo, p.Prov_CodigoExterno AS Prov_Id,
				abs(round(sum((d.Detalle_Nota * d.Factura_Costo_Neto)- (d.Detalle_Nota * d.Factura_IEPS) +  d.Detalle_Dif_Costo),4))
				as Factura_Subtotal,
				0 as Factura_Descuento,
				round(sum(d.Boleta_Impuesto*d.Detalle_Nota),4) as Factura_Impuesto,
				round(sum(d.Detalle_Nota * d.Factura_IEPS),4) as Factura_IEPS,
				abs(round(sum((d.Detalle_Nota * d.Factura_Costo_Neto) + (d.Detalle_Nota * d.Boleta_Impuesto)  + d.Detalle_Dif_Costo),4))
				as Factura_Total,
				'Sin Timbre' as TimbreFiscal,
				0  NotaCredito,
				Factura_Fecha_Vencimiento as Fecha_Vencimiento,
				1 as Moneda_Id,
				1 as Boleta_Tipo_Cambio
		FROM  	INV_Entrada_Diferencia_Hist d
			INNER JOIN Boleta_Local_Fact_Enc f
				ON d.Emp_Id = f.Emp_Id AND d.Suc_Id = f.Suc_Id AND d.Bodega_Id = f.Bodega_Id
				AND d.Boleta_Id = f.Boleta_Id AND d.Prov_Id = f.Prov_Id
				AND d.Factura_Numero = f.Factura_Id
			LEFT JOIN Proveedor p
			  ON f.Emp_Id = p.Emp_Id
			  AND f.Prov_Id = p.Prov_Id
			INNER JOIN Sucursal s
			ON d.Emp_Id = s.Emp_Id and d.Suc_Id = s.Suc_Id
		WHERE 	d.Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Emp_Id#">
			<cfif Suc_Id NEQ -1>
			  AND d.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Suc_Id#">
			</cfif>
			AND f.Factura_Fecha between
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateIni#">
				AND
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateFin#">
		AND 	(d.Detalle_Nota > 0 or d.Detalle_Dif_Costo > 0)
		GROUP BY d.Emp_Id, d.Suc_Id, p.Cadena_Id, d.Factura_Numero, d.Bodega_Id, d.Boleta_Id, f.Factura_Fecha, f.Factura_Fecha_Vencimiento, p.Prov_CodigoExterno
		<!--- FACTURAS DEL EXTERIOR --->
		UNION
		SELECT e.Emp_Id,
			        e.Suc_Id,
			        p.Cadena_Id,
			        e.Calculo_Factura AS Factura_Id,
			        o.Bodega_Id,<!---  -- h.Boleta_Id, --->
			 0 AS Boleta_Id,
			 'FC' AS Tipo_Doc,
			 'E' AS Tipo_Compra,
			 e.Calculo_Fecha_Crea AS Fecha_Compra,
			 e.Calculo_Fecha_Crea AS Fecha_Arribo,
			 p.Prov_CodigoExterno AS Prov_Id,
			 SUM(CAST(e.Calculo_Costo_Total AS decimal(18, 10)) - CAST(Calculo_Otros_Nauca AS decimal(18, 10))) AS Factura_Subtotal,
			 0 AS Factura_Descuento,
			 0 AS Factura_impuesto,
			 0 AS Factura_IEPS,
			 SUM(CAST(e.Calculo_Costo_Total AS decimal(18, 10)) - CAST(Calculo_Otros_Nauca AS decimal(18, 10))) AS Factura_Total,
			 'Sin Timbre' AS TimbreFiscal,
			 SUM(e.Calculo_Nota_Credito) AS NotaCredito,
			 e.Calculo_Fecha_Crea + pa.Agencia_Plazo_Credito AS Fecha_Vencimiento,
			 o.Moneda_Id,
			 e.Calculo_TC_Actual AS Boleta_Tipo_Cambio
			FROM Calculo_Encabezado e
			INNER JOIN Orden_Exterior_Encabezado o ON o.Orden_id = e.Orden_id
			AND o.Emp_Id = e.Emp_Id
			AND o.Suc_Id = e.Suc_Id
			LEFT JOIN Proveedor p ON o.Emp_Id = p.Emp_Id
			AND o.Prov_Id = p.Prov_Id
			INNER JOIN Proveedor_Agencia pa ON p.Emp_Id = pa.Emp_Id
			AND p.Prov_Id = pa.Prov_Id
			AND o.Agencia_Id = pa.Agencia_Id
			WHERE e.Calculo_Estado = 'RE'
			  AND e.Calculo_Factura <> ''
			  AND e.Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Emp_Id#">
              <cfif Suc_Id NEQ -1>
				  AND e.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Suc_Id#">
				</cfif>
             AND e.Calculo_Fecha_Crea BETWEEN
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateIni#">
							AND
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateFin#">
			  <!--- AND e.Calculo_Factura  NOT IN (SELECT Numero_Documento FROM #databaseNameInt#..ESIFLD_Facturas_Compra) --->
			GROUP BY e.Emp_Id,
			         e.Suc_Id,
			         p.Cadena_Id,
			         e.Calculo_Factura,
			         o.Bodega_Id,
					 e.Calculo_Fecha_Crea,
					 o.Orden_Fecha_Arribo,
					 p.Prov_CodigoExterno,
					 pa.Agencia_Plazo_Credito,
					 o.Moneda_Id,
					 e.Calculo_TC_Actual
	</cfquery>
	<cfreturn rsECompras>
</cffunction>
<cffunction name="getDetalle" access="private" output="false">
	<cfargument name="DataSource" type="string"  required="True"  default="" />
	<cfargument name="Emp_Id" 	  type="string"  required="true"  default="CERR" hint="CERR, ABIE, etc. (case sensitive)"/>
	<cfargument name="Suc_Id"     type="string"  required="false" default=0 />
	<cfargument name="Factura_Id" type="String"  required="false" default=0 />
	<cfargument name="Bodega_Id"  type="numeric" required="false" default=0 />
	<cfargument name="Boleta_Id"  type="numeric" required="false" default=0 />
	<cfargument name="Ecodigo"    type="numeric" required="true" default=0 />

	<cfset lvarValidaIva8 = false>
	<!--- Valida parametro para ver si aplica validacion de IVA8 --->
	<cfquery name="rsGetParam06" datasource="sifinterfaces">
		SELECT RTRIM(LTRIM(Pvalor)) AS Pvalor
		FROM SIFLD_ParametrosAdicionales
		WHERE Pcodigo = '00006'
		AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
	</cfquery>
	<cfif rsGetParam06.RecordCount GT 0 AND LEN(rsGetParam06.Pvalor) GT 0>
		<cfset lvarValidaIva8 = true>
	</cfif>

	<cfquery name="rsDCompras" datasource="#DataSource#">
		<!---Para Compras --->
		<cfif Tipo_Compra EQ "C">
			SELECT
				  fd.Factura_Id,
				  1 AS Depto_Id,
				  0 AS Tipo_Articulo_Id,
				  0 AS Casa_Id,
				  1 AS Cantidad,
				  ISNULL(ROUND(SUM(Detalle_Cantidad * Detalle_Descuento), 4), 0) AS Descuento,
				  <cfif lvarValidaIva8>
					  CASE
					    WHEN COALESCE(Detalle_Impuesto, 0) > 0 THEN COALESCE((SELECT TOP 1
					        (fi.Detalle_Impuesto_Monto * fd.Detalle_Cantidad)
					      FROM Boleta_Local_Fact_Det_Imp fi
					      INNER JOIN Impuesto i
					        ON fi.Emp_Id = i.Emp_Id
					        AND fi.Impuesto_Id = i.Impuesto_Id
					        AND UPPER(i.Impuesto_Nombre) LIKE '%IVA%'
					        AND fi.Emp_Id = fd.Emp_Id
					        AND fd.Articulo_Id = fi.Articulo_Id
							AND fd.Factura_Id = fi.Factura_Id), 0)
					    ELSE 0
					  END AS Impuesto,
				  <cfelse>
				  	CASE
						WHEN COALESCE(Detalle_Impuesto, 0) > 0 THEN
						COALESCE(
						(SELECT TOP 1 (fd.Detalle_Cantidad * (COALESCE(fi.Impuesto_Monto, 0) / 100) * fd.Detalle_Costo_Bruto)
						FROM Impuesto_Articulo fi
						INNER JOIN Impuesto i ON fi.Emp_Id = i.Emp_Id
						AND fi.Impuesto_Id = i.Impuesto_Id
						AND UPPER(i.Impuesto_Nombre) LIKE '%IVA%'
						AND fi.Emp_Id = fd.Emp_Id
						AND fd.Articulo_Id = fi.Articulo_Id), 0)
						ELSE 0
					END AS Impuesto,
				  </cfif>
				  ROUND(ISNULL(SUM(Detalle_Total), 0), 4) AS Total,
				  <cfif lvarValidaIva8>
					  CASE
					    WHEN COALESCE(Detalle_Impuesto, 0) > 0 THEN COALESCE((SELECT TOP 1
					        CONVERT(int, COALESCE(fi.Detalle_Impuesto_Porc, 0))
					      FROM Boleta_Local_Fact_Det_Imp fi
					      INNER JOIN Impuesto i
					        ON fi.Emp_Id = i.Emp_Id
					        AND fi.Impuesto_Id = i.Impuesto_Id
					        AND UPPER(i.Impuesto_Nombre) LIKE '%IVA%'
					        AND fi.Emp_Id = fd.Emp_Id
					        AND fd.Articulo_Id = fi.Articulo_Id
							AND fd.Factura_Id = fi.Factura_Id), 0)
					    ELSE 0
					  END AS Cod_Impuesto,
				  <cfelse>
				  	CASE
						WHEN COALESCE(Detalle_Impuesto, 0) > 0 THEN
						COALESCE(
						(SELECT TOP 1 COALESCE(fi.Impuesto_Id, 0)
						FROM Impuesto_Articulo fi
						INNER JOIN Impuesto i ON fi.Emp_Id = i.Emp_Id
						AND fi.Impuesto_Id = i.Impuesto_Id
						AND UPPER(i.Impuesto_Nombre) LIKE '%IVA%'
						AND fi.Emp_Id = fd.Emp_Id
						AND fd.Articulo_Id = fi.Articulo_Id), 0)
						ELSE 0
					END AS Cod_Impuesto,
				  </cfif>
				  ROUND(ISNULL(SUM(Detalle_Cantidad * Detalle_Costo_Neto), 0), 4) AS Precio_Unitario,
				  ROUND(ISNULL(SUM(Detalle_Subtotal_Neto), 0), 4) AS Subtotal,
				  CASE
						WHEN COALESCE(Detalle_IEPS, 0) > 0 THEN
						COALESCE(
							(select TOP 1 fd.Detalle_Cantidad * ( (ISNULL(ipa.Impuesto_Porcentaje,0) /100) * fd.Detalle_Costo_Bruto) 
							FROM Impuesto_Articulo fi
								INNER JOIN Impuesto i ON fi.Emp_Id = i.Emp_Id
								AND fi.Impuesto_Id = i.Impuesto_Id
								AND UPPER(i.Impuesto_Nombre) LIKE '%IEPS%'
								AND fi.Emp_Id = fd.Emp_Id
								AND fd.Articulo_Id = fi.Articulo_Id
								INNER  JOIN Impuesto_Proveedor_Agencia ipa
								on ipa.Prov_Id= fd.Prov_Id
								AND ipa.Impuesto_Id=i.Impuesto_Id)
						, 0)
						ELSE 0
					END AS IEPS,
				  CASE
				    WHEN COALESCE(Detalle_IEPS, 0) > 0 THEN COALESCE((SELECT TOP 1
				        COALESCE(fi.Impuesto_Id, 0)
				      FROM Impuesto_Articulo fi
				      INNER JOIN Impuesto i
				        ON fi.Emp_Id = i.Emp_Id
				        AND fi.Impuesto_Id = i.Impuesto_Id
				        AND UPPER(i.Impuesto_Nombre) LIKE '%IEPS%'
				        AND fi.Emp_Id = fd.Emp_Id
				        AND fd.Articulo_Id = fi.Articulo_Id), 0)
				    ELSE 0
				  END AS codIEPS,
				  0 AS afectaIVA
				FROM Boleta_Local_Fact_Det fd
				INNER JOIN Articulo a
				  ON fd.Articulo_Id = a.Articulo_Id
				  AND fd.Emp_Id = a.Emp_Id
				WHERE fd.Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Emp_Id#">
				  <cfif Suc_Id NEQ -1>
					  AND fd.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Suc_Id#">
					</cfif>
				  AND RTRIM(LTRIM(fd.factura_Id)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(Factura_Id)#">
				  AND fd.bodega_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Bodega_Id#">
				  AND fd.boleta_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Boleta_Id#">
				GROUP BY fd.factura_id,
				         a.Depto_Id,
				         fd.Detalle_Impuesto,
				         fd.Detalle_Cantidad,
				         fd.Detalle_Costo_Bruto,
				         fd.Emp_Id,
				         fd.Suc_Id,
				         fd.Articulo_Id,
				         fd.Detalle_Id,
				         fd.Detalle_IEPS,
				         fd.Prov_Id
		<!---Para Devoluciones--->
		<cfelseif Tipo_Compra EQ "D">
			select fd.Devolucion_Id as Factura_Id, 1 as Depto_Id,0 as Tipo_Articulo_Id,0 as Casa_Id, 1 as Cantidad,
				round(isnull(sum(fd.Detalle_Cantidad * Detalle_Descuento),0),4)  as Descuento,
				isnull( round(sum(fd.Detalle_Cantidad * isnull(Detalle_Impuesto,0)),4),0) as Impuesto,
				round(sum(Detalle_Total),4) as Total,
				<cfif lvarValidaIva8>
					CONVERT(int, COALESCE(i.Detalle_Impuesto_Porc, 0)) as Cod_Impuesto,
				<cfelse>
				  	isnull(i.Impuesto_Id,0) as Cod_Impuesto,
				</cfif>
				round(isnull(sum(fd.Detalle_Cantidad * Detalle_Costo_Neto),0),4) as Precio_Unitario,
				round(isnull(sum(fd.Detalle_Subtotal-(fd.Detalle_Cantidad * Detalle_Descuento)),0),4) Subtotal,
				round(isnull(sum(fd.Detalle_IEPS),0),4) IEPS,
				ISNULL(ii.Impuesto_id,0) as codIEPS, 0 as afectaIVA
			from Inv_Dev_Proveedor_Detalle fd
				inner join Articulo a
					on fd.Articulo_Id = a.Articulo_Id
				left join inv_dev_proveedor_detalle_imp i
					inner join Impuesto iva
							on i.Emp_Id = iva.Emp_Id
							and i.Impuesto_id = iva.Impuesto_Id
					on fd.Emp_Id = i.Emp_Id and fd.Suc_Id = i.Suc_Id and fd.Bodega_Id = i.Bodega_Id
					and fd.Devolucion_Id = i.Devolucion_Id and fd.Articulo_Id = i.Articulo_Id
					and iva.Impuesto_Tipo = 'IVA'
				left join inv_dev_proveedor_detalle_imp ii
					inner join Impuesto ieps
							on ii.Emp_Id = ieps.Emp_Id
							and ii.Impuesto_id = ieps.Impuesto_Id
					on fd.Emp_Id = ii.Emp_Id and fd.Suc_Id = ii.Suc_Id and fd.Bodega_Id = ii.Bodega_Id
					and fd.Devolucion_Id = ii.Devolucion_Id and fd.Articulo_Id = ii.Articulo_Id
					and ieps.Impuesto_Tipo = 'IEPS'
			where fd.emp_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Emp_Id#">
				<cfif Suc_Id NEQ -1>
				  AND fd.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Suc_Id#">
				</cfif>
				and fd.bodega_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Bodega_Id#">
				and fd.Devolucion_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Factura_Id#">
			group by fd.Devolucion_id, a.Depto_Id,
					 <cfif lvarValidaIva8>
						i.Detalle_Impuesto_Porc,
					 <cfelse>
						i.Impuesto_id,
					 </cfif>
					 ii.Impuesto_Id
			<!--- Para Notas Automaticas --->
		<cfelseif Tipo_Compra EQ "A">
			Select d.Factura_Numero as Factura_Id, 1 as Depto_Id,0 as Tipo_Articulo_Id, 0 as Casa_Id,
				1 as Cantidad, 0 as Descuento,
				abs(round(sum(d.Detalle_Nota * d.Boleta_Impuesto) ,4))   as Impuesto,
				abs(round(sum((d.Detalle_Nota * d.Factura_Costo_Neto) +  d.Detalle_Dif_Costo),4)) as Total,
				<cfif lvarValidaIva8>
					CASE
					    WHEN ABS(ROUND(SUM(d.Detalle_Nota * d.Boleta_Impuesto), 4)) > 0 THEN (SELECT TOP 1
					        CONVERT(int, COALESCE(a.Detalle_Impuesto_Porc, 0))
					      FROM Boleta_Local_Fact_Det_Imp a
					      INNER JOIN Impuesto i
					        ON i.Emp_id = a.Emp_id
					        AND i.Impuesto_Id = a.Impuesto_Id
							AND UPPER(i.Impuesto_Nombre) LIKE '%IVA%'
					      WHERE a.Articulo_id = d.Articulo_Id
						  AND a.Factura_Id = d.Factura_Numero)
					    ELSE 0
					  END AS Cod_Impuesto,
				 <cfelse>
					case when abs(round(sum(d.Detalle_Nota * d.Boleta_Impuesto) ,4)) > 0
					then (select min(Impuesto_Id)  from Impuesto_Articulo where Articulo_id = d.Articulo_Id )
					else 0 end 	as Cod_Impuesto,
				 </cfif>
				abs(round(sum((d.Detalle_Nota * d.Factura_Costo_Neto) +  d.Detalle_Dif_Costo),4)) as Precio_Unitario,
				abs(round(sum((d.Detalle_Nota * d.Factura_Costo_Neto) +  d.Detalle_Dif_Costo),4)) as Subtotal,
				abs(round(sum(d.Detalle_Nota * d.Boleta_IEPS) ,4))    as IEPS,
				<cfif lvarValidaIva8>
					CASE
					    WHEN ABS(ROUND(SUM(d.Detalle_Nota * d.Boleta_IEPS), 4)) > 0 THEN (SELECT TOP 1
					        CONVERT(int, COALESCE(a.Detalle_Impuesto_Porc, 0))
					      FROM Boleta_Local_Fact_Det_Imp a
					      INNER JOIN Impuesto i
					        ON i.Emp_id = a.Emp_id
					        AND i.Impuesto_Id = a.Impuesto_Id
							AND UPPER(i.Impuesto_Nombre) LIKE '%IEPS%'
					      WHERE a.Articulo_id = d.Articulo_Id
						  AND a.Factura_Id = d.Factura_Numero)
					    ELSE 0
					  END AS codIEPS,
				 <cfelse>
					case when abs(round(sum(d.Detalle_Nota * d.Boleta_IEPS) ,4)) > 0
					then (select max(Impuesto_Id)  from Impuesto_Articulo where Articulo_id = d.Articulo_Id )
					else 0  end as codIEPS,
				 </cfif>
				0 as afectaIVA
			from  INV_Entrada_Diferencia_Hist d
				inner join Articulo a
					on d.Articulo_Id = a.Articulo_Id and d.Emp_Id = a.Emp_Id
			where d.Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Emp_Id#">
				<cfif Suc_Id NEQ -1>
				  AND d.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Suc_Id#">
				</cfif>
				and d.Bodega_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Bodega_Id#">
				and d.Factura_Numero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Factura_Id#">
				and d.Boleta_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Boleta_Id#">
				and(round(d.Detalle_Nota,4) > 0 or round(d.Detalle_Dif_Costo,4) > 0)
			group by d.Factura_Numero, a.Depto_Id, d.Articulo_Id
		<cfelseif Tipo_Compra EQ "E">
			<!--- PARA COMPRAS DEL EXTERIOR --->
			SELECT e.Calculo_Factura AS Factura_Id,
				       1 AS Depto_Id,
				       0 AS Tipo_Articulo_id,
				       0 AS Casa_Id,
				       1 AS Cantidad,
				       ISNULL(CAST(SUM(d.Detalle_Cantidad * d.Detalle_Descuento) AS decimal(18, 10)), 0) AS Descuento,
				       0 AS Impuesto,
				       CAST(ISNULL(SUM(d.Detalle_Costo_Total) - SUM(COALESCE(d.Detalle_Otros_Nauca,0)), 0) AS decimal(18, 10)) AS Total,
				       0 AS Cod_Impuesto,
				       CAST(ISNULL(SUM(d.Detalle_Cantidad * d.Detalle_Costo_Unitario) - SUM(COALESCE(d.Detalle_Otros_Nauca,0)), 0) AS decimal(18, 10)) AS Precio_Unitario,
				       CAST(ISNULL(SUM(d.Detalle_Cantidad * d.Detalle_Costo_Unitario) - SUM(COALESCE(d.Detalle_Otros_Nauca,0)), 0) AS decimal(18, 10)) AS Subtotal,
				       0 AS IEPS,
				       0 AS codIEPS,
				       0 AS afectaIVA
				FROM Calculo_Detalle d
				INNER JOIN Calculo_Encabezado e
                ON d.Emp_Id = e.Emp_Id
                AND d.Suc_Id = e.Suc_Id
                AND d.Calculo_Id = e.Calculo_Id
				INNER JOIN Articulo a ON a.Articulo_id = d.Articulo_id
				AND a.Emp_Id = d.Emp_Id
				WHERE e.Calculo_Factura = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Factura_Id#">
                  AND e.Calculo_Estado = 'RE'
				  AND d.Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Emp_Id#">
				  <cfif Suc_Id NEQ -1>
					  AND d.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Suc_Id#">
					</cfif>
				GROUP BY e.Calculo_Factura,
				         a.Depto_Id,
				         a.Tipo_Articulo_id,
				         a.Casa_Id
		</cfif>
	</cfquery>

	<cfif rsDCompras.RecordCount GT 0>
		<cfquery name="rsDCompras" dbtype="query">
			select Factura_Id, Depto_Id, Tipo_Articulo_Id,Casa_Id, Cantidad,sum(Descuento) as  Descuento , sum(Impuesto) as Impuesto,
			sum(Total) as Total, Cod_Impuesto, sum(Precio_Unitario) as Precio_Unitario, sum(Subtotal) as Subtotal, codIEPS, SUM(IEPS) AS IEPS, afectaIVA
			from rsDCompras
			group by Factura_Id, Depto_Id, Tipo_Articulo_Id,Casa_Id, Cantidad, Cod_Impuesto, codIEPS, afectaIVA
		</cfquery>
	</cfif>
	<cfreturn rsDCompras>
</cffunction>
</cfcomponent>