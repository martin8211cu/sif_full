<!--- ABG: Extraccion de Compras Interfaz LD-SIF Ver. 1.0 --->
<!--- La Interfaz LD-SIF solo funciona con versiones de Coldfusion 8.0 en adelante --->
<cfcomponent>
<cffunction name="Ejecuta" access="public" returntype="string" output="yes">
	<cfset LvarLinkServ = false>
	<!--- variables datasource --->
	<!--- Rutina para obtener el nombre del server del datasource ldcom --->
	<cfset Varfactory = CreateObject("java", "coldfusion.server.ServiceFactory")>
	<cfset Vards_service = Varfactory.datasourceservice>
	<cfset Vardatasources = Vards_service.getDatasources()>
	<cfloop collection="#Vardatasources#" item="i">
		<cfset Varthisdatasource = Vardatasources[i]>
		<cfif Varthisdatasource.name EQ 'ldcom'>
			 <cfset Lvarserverldcom = trim(Varthisdatasource.urlmap.database)>
			 <cfset Lvarbdldcom = trim(Varthisdatasource.urlmap.database)>
		</cfif>
	</cfloop>
	<cfif NOT isdefined("Lvarserverldcom") OR Len(Lvarserverldcom) LTE 0>
		<cfthrow message="Error al obtener nombre de server para Sistema Comercial, datasource ldcom">
	</cfif>
	<cfif NOT isdefined("Lvarbdldcom") OR Len(Lvarbdldcom) LTE 0>
		<cfthrow message="Error al obtener nombre de la Base de Datos para Sistema Comercial, datasource ldcom">
	</cfif>
	
	<cfset ldcomsrv       	= Lvarserverldcom>
	<cfset ldcomdb       	= Lvarbdldcom>
	<cfif LvarLinkServ>
		<cfset ldcoma = '#ldcomsrv#.#ldcomdb#'>
	<cfelse>
		<cfset ldcoma = '#ldcomdb#'>
	</cfif>
	<cfset sifinterfacesdb 	= "sif_interfaces">
	<cfif isdefined("form.fechaIni") and isdefined("form.fechaFin")>
		<cfset fechaini = createdate(right(form.fechaini,4),mid(form.fechaini,4,2),left(form.fechaini,2))>
		<cfset fechafin = createdate(right(form.fechafin,4),mid(form.fechafin,4,2),left(form.fechafin,2))>
	</cfif>
	
	<!--- Obtiene los cierres de Sucursal del Dia en que se procesa la Rutina --->
	<cfquery datasource="ldcom" name="rsOperacionID">
		select o.Emp_Id, s.Cadena_Id, o.Suc_Id, o.Operacion_Id, o.Operacion_Fecha_Apertura, o.Operacion_Fecha_Cierre
		from Sucursal_Operacion o
			inner join Sucursal s
			on o.Emp_Id = s.Emp_Id and o.Suc_Id = s.Suc_Id
		where Operacion_Estado like 'CERR'
		and CONVERT(CHAR(8), o.Operacion_Fecha_Cierre, 112) 
		<cfif isdefined("fechaini") and isdefined("fechafin")>
			between 
				CONVERT(CHAR(8), <cfqueryparam cfsqltype="cf_sql_timestamp" value='#fechaini#'>, 112)
			and 
				CONVERT(CHAR(8), <cfqueryparam cfsqltype="cf_sql_timestamp" value='#fechafin#'>, 112)
		<cfelse>
			= CONVERT(CHAR(8), <cfqueryparam cfsqltype="cf_sql_timestamp" value='#now()#'>, 112)
		</cfif>
		and not exists (select 1 
						from SIFLD_Bitacora_Proceso bp 
						where o.Emp_Id = bp.Emp_Id 
						and o.Suc_Id = bp.Suc_Id
						and o.Operacion_Id = bp.Operacion_Id
						and bp.Proceso like 'COMPRAS')
	</cfquery>
	
	<cfif isdefined("rsOperacionID") and rsOperacionID.recordcount GT 0>
		<cfloop query="rsOperacionID">
		<cftry>
			<!--- Obtiene la Moneda Local --->
			<cfquery name="rsMoneda" datasource="ldcom">
				select Moneda_Id 
				from Moneda 
				where Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#">
				and Moneda_Local = 1
			</cfquery>
			<cfif rsMoneda.recordcount EQ 0>
				<cfthrow message="Error al extraer la moneda Local">
			</cfif>
			<!--- Extrae los encabezados para las Compras y Devoluciones que pertenecen a las operaciones Cerradas al momento de la ejecucion --->
			<cfquery name="rsECompras" datasource="ldcom">
				<!--- FACTURAS ---> 
				SELECT Suc_Id, convert(varchar,Factura_Id) as Factura_Id, Bodega_Id, Boleta_Id, 'FC' as Tipo_Doc,
					'C' as Tipo_Compra,  Factura_Fecha as Fecha_Compra, 
					Factura_Fecha_Vencimiento as Fecha_Arribo, Prov_Id, 
					round(Factura_Subtotal, 2) as Factura_Subtotal, 
					round(Factura_Descuento,2) as Factura_Descuento,
					round(Factura_Impuesto,2) as Factura_impuesto, 
					round(Factura_Total,2) as Factura_Total 
				FROM Boleta_Local_Fact_Enc f
				WHERE Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#">
					  and Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_Id#"> 
					  and Factura_Fecha between
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Apertura#">
						and
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Cierre#">
				UNION
				<!---DEVOLUCIONES DE PROVEEDOR --->
				SELECT Suc_Id, convert(varchar,Devolucion_Id) as Factura_Id, Bodega_Id, Boleta_Id, 'NC' as Tipo_Doc, 
					'D' as Tipo_Compra, Devolucion_Fecha, Devolucion_Fecha_Aplica as Fecha_Arribo, Proveedor_Id as Prov_Id,
					round((Devolucion_Subtotal_Exento + Devolucion_Subtotal_Gravado),2) as Factura_Subtotal, 
					round((Devolucion_Desc_Exento + Devolucion_Desc_Gravado),2) as Factura_Descuento, 
					round(Devolucion_Impuesto,2) as Factura_Impuesto, 
					round(Devolucion_Total,2) as Factura_Total
				FROM Inv_Dev_Proveedor_Encabezado
				WHERE  Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#">
					  and Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_Id#"> 
					  and Devolucion_Fecha_Aplica between
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Apertura#">
						and
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Cierre#">
					  and Devolucion_Estado = 'AP'
				UNION
				<!--- Notas de Credito Automaticas --->
				Select d.Suc_Id, d.Factura_Numero as Factura_Id, d.Bodega_Id, d.Boleta_Id, 
					'NC' as Tipo_Doc,'A' as Tipo_Compra, f.Factura_Fecha as Fecha_Compra, 
					f.Factura_Fecha_Vencimiento as Fecha_Arribo, d.Prov_Id, 
					abs(round(sum((d.Detalle_Nota * d.Factura_Costo_Neto) +  d.Detalle_Dif_Costo),2)) as Factura_Subtotal,
					0 as Factura_Descuento,
					0 as Factura_Impuesto,
					abs(round(sum((d.Detalle_Nota * d.Factura_Costo_Neto) +  d.Detalle_Dif_Costo),2)) as Factura_Total
				from  INV_Entrada_Diferencia_Hist d
					inner join Boleta_Local_Fact_Enc f
					on d.Emp_Id = f.Emp_Id and d.Suc_Id = f.Suc_Id and d.Bodega_Id = f.Bodega_Id 
					and d.Boleta_Id = f.Boleta_Id and d.Prov_Id = f.Prov_Id 
					and d.Factura_Numero = f.Factura_Id
				where d.Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#">
				and d.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_Id#"> 
				and f.Factura_Fecha between
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Apertura#">
						and
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Cierre#">
				and (d.Detalle_Nota > 0 or d.Detalle_Dif_Costo > 0)
				group by d.Emp_Id,d.Suc_Id, d.Bodega_Id, d.Boleta_Id, d.Prov_Id, d.Factura_Numero, 
					f.Factura_Fecha, f.Factura_Fecha_Vencimiento
			</cfquery>
			<!--- Recorremos los encabezados Insertandolos y extrayendo sus detalles de Pago y detalles de Venta --->
			<cfif isdefined("rsECompras") AND rsECompras.recordcount GT 0>
			<cfloop query="rsECompras">
				<!--- ID para la tabla de Encabezados --->
				<cfquery name="rsMaxIDE" datasource="sifinterfaces">
					select isnull(max(id_documentoC),0) + 1 as MaxID
					from ESIFLD_Facturas_Compra
				</cfquery> 
	
				<!--- Crea el numero de Documento --->
				<cfif rsECompras.Tipo_Compra EQ "C">
					<cfset Num_Doc = rsECompras.Factura_Id>
				<cfelseif rsECompras.Tipo_Compra EQ "D">
					<cfset Num_Doc = numberformat(rsOperacionID.Emp_Id,"00") & "-" & numberformat(rsOperacionID.Suc_Id,"0000") & numberformat(rsECompras.Bodega_Id,"000") & "-" & numberformat(rsECompras.Factura_Id,"000000000")>
				</cfif>
				
				<cftransaction action="begin">
				<cftry>
					<!--- Inserta los encabezados ---> 
					<cfquery datasource="sifinterfaces">
						insert into ESIFLD_Facturas_Compra 
						(Ecodigo, Origen, ID_DocumentoC, Tipo_Documento, Tipo_Compra, Fecha_Compra,Fecha_Arribo, 
							Numero_Documento, Proveedor, IETU_Clas, Subtotal, Descuento, Impuesto, Total,
							Vendedor, Sucursal, Moneda, Tipo_Cambio, Retencion, Observaciones, 
							Almacen, Estatus)
						values 
						(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_id#">,
						'LD',
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Tipo_Doc#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Tipo_Compra#">, 
						<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsECompras.Fecha_Compra,"short")#">,  
						<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsECompras.Fecha_Arribo,"short")#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Num_Doc#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Prov_Id#">,
						null,
						<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsECompras.Factura_Subtotal,"9.99")#">, 
						<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsECompras.Factura_Descuento,"9.99")#">, 
						<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsECompras.Factura_Impuesto,"9.99")#">, 
						<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsECompras.Factura_Total,"9.99")#">,
						0, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOperacionID.Suc_Id#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMoneda.Moneda_Id#">,
						1,
						'',
						'', 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Bodega_Id#">,
						1)
					</cfquery>
					<cftransaction action="commit" />
				<cfcatch type="any">
					<cftransaction action="rollback" />
					<!--- Variables de Error --->
					<cfset ErrBodega = rsECompras.Bodega_Id>
					<cfset ErrFactura = rsECompras.Factura_Id>
					<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
					<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
					<cfthrow message="Error al Insertar el Encabezado: #cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
				</cfcatch>
				</cftry>
				</cftransaction>	
				<!--- Busca e Inserta los Detalles del Encabezado ---> 
				<cfquery name="rsDCompras" datasource="ldcom">
					<!---Para Compras --->
					<cfif rsECompras.Tipo_Compra EQ "C">
						select fd.Factura_Id, a.Depto_Id,0 as Tipo_Articulo_Id,0 as Casa_Id, 1 as Cantidad, 
							isnull(round(sum(Detalle_Cantidad * Detalle_Descuento),2),0) as Descuento,
							isnull(round(sum(Detalle_Cantidad * isnull(i.Detalle_Impuesto_Monto,0)),2),0) as Impuesto, 
							round(isnull(sum(Detalle_Total),0),2) as Total,
							isnull(Impuesto_Id,0) as Cod_Impuesto,
							round(isnull(sum(Detalle_Cantidad * Detalle_Costo_Neto),0),2) as Precio_Unitario, 
							round(isnull(sum(Detalle_Subtotal_Neto),0),2) as Subtotal
						from Boleta_Local_Fact_Det fd
							inner join Articulo a 
							on fd.Articulo_Id = a.Articulo_Id and fd.Emp_Id = a.Emp_Id
							left join Boleta_Local_Fact_Det_Imp i 
							on i.Emp_Id = fd.Emp_Id and i.Suc_Id = fd.Suc_Id and i.Bodega_Id = fd.Bodega_Id 
							and fd.Boleta_Id = i.Boleta_Id and fd.Factura_Id = i.Factura_Id and fd.Detalle_Id = i.Detalle_Id
						where fd.Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#">
							and fd.suc_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_Id#"> 
							and fd.factura_Id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Factura_Id#">  
							and fd.bodega_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsECompras.Bodega_Id#"> 
							and fd.boleta_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsECompras.Boleta_Id#">
						group by fd.factura_id, a.depto_id, isnull(impuesto_id,0)
					<!---Para Devoluciones--->
					<cfelseif rsECompras.Tipo_Compra EQ "D">
						select fd.Devolucion_Id as Factura_Id, a.Depto_Id,0 as Tipo_Articulo_Id,0 as Casa_Id, 1 as Cantidad,
							round(isnull(sum(fd.Detalle_Cantidad * Detalle_Descuento),0),2)  as Descuento,
							isnull( round(sum(fd.Detalle_Cantidad * isnull(i.Detalle_Impuesto_Monto,0)),2),0) as Impuesto, 
							round(sum(Detalle_Total),2) as Total, 
							isnull(Impuesto_Id,0) as Cod_Impuesto,
							round(isnull(sum(fd.Detalle_Cantidad * Detalle_Costo_Neto),0),2) as Precio_Unitario, 
							round(isnull(sum(fd.Detalle_Subtotal ),0),2) Subtotal
						from Inv_Dev_Proveedor_Detalle fd
							inner join Articulo a 
							on fd.Articulo_Id = a.Articulo_Id
							left join inv_dev_proveedor_detalle_imp i 
							on fd.Emp_Id = i.Emp_Id and fd.Suc_Id = i.Suc_Id and fd.Bodega_Id = i.Bodega_Id
							and fd.Devolucion_Id = i.Devolucion_Id 
						where fd.emp_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#"> 
							and fd.suc_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_Id#">
							and fd.bodega_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsECompras.Bodega_Id#">
							and fd.Devolucion_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsECompras.Factura_Id#"> 
						group by fd.Devolucion_id, a.depto_id, isnull(impuesto_id,0)
						<!--- Para Notas Automaticas --->
					<cfelseif rsECompras.Tipo_Compra EQ "A">
						Select d.Factura_Numero as Factura_Id, a.Depto_Id as Tipo_Articulo, 0 as Casa_Id,
							1 as Cantidad, 0 as Descuento, 0 as Impuesto, 
							abs(round(sum((d.Detalle_Nota * d.Factura_Costo_Neto) +  d.Detalle_Dif_Costo),2)) as Total, 
							'' as Cod_Impuesto,
							abs(round(sum((d.Detalle_Nota * d.Factura_Costo_Neto) +  d.Detalle_Dif_Costo),2)) as Precio_Unitario, 	
							abs(round(sum((d.Detalle_Nota * d.Factura_Costo_Neto) +  d.Detalle_Dif_Costo),2)) as Subtotal
						from  INV_Entrada_Diferencia_Hist d
							inner join Articulo a
							on d.Articulo_Id = a.Articulo_Id and d.Emp_Id = a.Emp_Id
						where d.Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#"> 
							and d.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_Id#">
							and d.Bodega_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsECompras.Bodega_Id#">
							and d.Factura_Numero = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsECompras.Factura_Id#"> 
							and d.Boleta_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsECompras.Boleta_Id#">
							and(d.Detalle_Nota > 0 or d.Detalle_Dif_Costo > 0)
						group by d.Factura_Numero, a.Depto_Id	
					</cfif>
				</cfquery>
				<cfset IDlinea = 1>
				<cfif isdefined("rsDCompras") and rsDCompras.recordcount GT 0>
				<cfloop query="rsDCompras">
					<cftransaction action="begin">
					<cftry>
						<cfquery datasource="sifinterfaces">
							insert into DSIFLD_Facturas_Compra 
								(Ecodigo, ID_DocumentoC,Id_linea, tipo_lin, tipo_item, clas_item, cantidad,
								 total_lin,cod_item,cod_fabricante, cod_impuesto, precio_unitario, descuento_lin, 
								 descuento_fact, subtotal_lin, impuesto_lin) 
							values 
							(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_id#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">, 
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
							 'S',
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDCompras.Depto_Id#">, 
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDCompras.Tipo_Articulo_Id#">,
							 <cfqueryparam cfsqltype="cf_sql_float" value="#rsDCompras.Cantidad#">,
							 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDCompras.Total,"9.99")#">,
							 'COMPRA',
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDCompras.Casa_Id#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDCompras.Cod_Impuesto#">,
							 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDCompras.Precio_Unitario,"9.99")#">,
							 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDCompras.Descuento,"9.99")#">,
							 0,
							 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDCompras.Subtotal,"9.99")#">,
							 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDCompras.Impuesto,"9.99")#">)
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
						<cftransaction action="commit" />
					<cfcatch type="any">
						<cftransaction action="rollback" />
						<!--- Borra los registros para el Encabezado que se habia Insertado--->
						<cfquery datasource="sifinterfaces">
							delete DSIFLD_Facturas_Compra
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_id#">
								and ID_DocumentoC =	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">
							delete ESIFLD_Facturas_Compra
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_id#">
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
			<!--- Inserta Operacion ID a Bitacora para Ventas --->
			<cfquery datasource="ldcom">
				declare @ID int
				select @ID = isnull(max(Proceso_Id) ,0) + 1
				from SIFLD_Bitacora_Proceso 
				insert SIFLD_Bitacora_Proceso 
					(Proceso_Id, Sistema, Emp_Id, Suc_Id, Operacion_Id, Proceso, Fecha_Proceso)
				values (@ID, 'LD',
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_Id#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Operacion_Id#">,
						'COMPRAS',
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
			</cfquery>			
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
			<cfquery datasource="sifinterfaces">
				declare @ID int
				select @ID = isnull(max(Error_Id),0) + 1
				from SIFLD_Log_Errores
				insert SIFLD_Log_Errores
					(Error_Id, Sistema, Empresa, Sucursal, Operacion, Caja, Bodega,
					Factura, MsgError, Error_Comp, Proceso, Fecha_Proceso)
				values (@ID, 'LD',
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOperacionID.Suc_Id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Operacion_Id#">,
					<cfif isdefined("ErrCaja")>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#ErrCaja#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined("ErrBodega")>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#ErrBodega#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined("ErrFactura")>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#ErrFactura#">,
					<cfelse>
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cfcatch.Message#">,
					'#cfcatch.Message# #cfcatch.Detail# #ErrSQL# #ErrPAR#',
					'COMPRAS',
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">)
			</cfquery>
		</cfcatch>
		</cftry>
		</cfloop> <!--- Operacion ID --->
	<cfelse>
		<!--- Inserta Log de Error --->
		<cfquery datasource="sifinterfaces">
			declare @ID int
			select @ID = isnull(max(Error_Id),0) + 1
			from SIFLD_Log_Errores
			insert SIFLD_Log_Errores
				(Error_Id, Sistema, Empresa, Sucursal, Operacion, Caja, Bodega,
				Factura, MsgError, Error_Comp, Proceso, Fecha_Proceso)
			values 
				(@ID, 'LD', null, null, null, null, null,
				null, 'No hay Cierres de Sucursal para el Dia de Hoy',
				'No hay Cierres de Sucursal para el Dia de Hoy', 'COMPRAS', getdate())
		</cfquery>
	</cfif>
</cffunction>	
</cfcomponent>