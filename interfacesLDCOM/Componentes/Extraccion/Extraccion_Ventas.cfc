<!--- ABG: Extraccion de Ventas Interfaz LD-SIF Ver. 1.0 --->
<!--- La Interfaz LD-SIF solo funciona con versiones de Coldfusion 8.0 en adelante --->
<cfcomponent>
<cffunction name="Ejecuta" access="public" returntype="string" output="yes">
	<cfsetting requesttimeout="600">
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
		select o.Emp_Id, s.Cadena_Id, o.Suc_Id,o.Operacion_Id,o.Operacion_Fecha_Cierre
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
						and bp.Proceso like 'VENTAS')
	</cfquery>
	
	<cfif isdefined("rsOperacionID") and rsOperacionID.recordcount GT 0>
		<cfloop query="rsOperacionID">
		<cftry>
			<!--- Tipos de Documento
			1	Factura Contado
			2	Apartado
			3	Devolucion
			4	Factura Credito
			5	Devolucion Cedi
			--->
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
			<!--- Extrae los encabezados para las Ventas que pertenecen a las operaciones Cerradas al momento de la ejecucion --->
			<cfquery name="rsEVentas" datasource="ldcom">
				SELECT fe.Suc_Id, fe.Factura_Id, fe.Caja_Id, fe.TipoDoc_Id,
				case 
					when fe.Tipodoc_Id in (1) then 'P' /*contado*/
					when fe.Tipodoc_Id in (4) then 'C' /*credito*/
					when fe.Tipodoc_Id in (3) then
						case when isnull(fd.TipoDoc_Factura,0) = 4 then 'E' /*Devolucion Credito Sucursal*/
						else 'D' end
					when fe.Tipodoc_Id in (5) then 'D' /*devolucion*/
					when fe.Factura_Origen = 'EX' then 'S' /*Servicio a Domicilio*/
				end as Tipo_Venta, 
				Factura_Fecha, convert(varchar(15),fe.Cliente_Id) as Cliente_Id,
				round(Factura_Subtotal,2) as Factura_Subtotal,
				round(Factura_Descuento,2) as Factura_Descuento, 
				round(Factura_Impuesto,2) as Factura_Impuesto,
				round(Factura_Total,2) as Factura_Total,
				Vendedor_Id, c.Cliente_Plazo as Dias_Credito,
				round(Factura_FP_Efectivo,2) as Factura_FP_Efectivo, /*Monto en Efectivo*/
				round(Factura_FP_Tarjeta,2) as Factura_FP_Tarjeta, /*Monto en Tarjeta*/
				round(Factura_FP_Cheque, 2) as Factura_FP_Cheque, /*Monto en Cheque*/
				round(Factura_FP_Monedero,2) as Factura_FP_Monedero , /*Monto en Monedero*/
				round(Factura_FP_NotaCredito,2) as Factura_FP_NotaCredito, /*Monto en Nota de Credito*/
				round(Factura_FP_Cupon,2) as Factura_FP_Cupon, /*Monto en Vales*/
				round(Factura_FP_Puntos, 2) as Factura_FP_Puntos, /*Monto en Puntos*/
				round( Factura_FP_Copago,2) as Factura_FP_Copago, /*Monto CoPago*/
				s.suc_cedi as Tipo_CEDI, /*sucursal CEDI (1) normal (0)*/
				case 
					when fe.contacto_id <= 0 then null 
					else fe.contacto_id end Subcliente_Id,
				fe.Factura_Cambio_Efectivo <!--- Este Valor es para el manejo de los cambios en tipos de pago <> efectivo --->
				<!---INTO ##Temp_Datos--->
				FROM Factura_Encabezado fe
					INNER JOIN sucursal s 
					ON fe.suc_id = s.suc_id  and s.emp_id = fe.emp_id
					LEFT JOIN  cliente  c 
					ON fe.cliente_id = c.cliente_id and fe.emp_id = c.emp_id
					LEFT JOIN Factura_Devolucion fd
					ON fe.Emp_Id = fd.Emp_Id and fe.Suc_Id = fd.Suc_Id and fe.Caja_Id = fd.Caja_Id and fe.Factura_Id = fd.Devolucion_Id
				WHERE fe.emp_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_id#">
					and fe.suc_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_id#">
					and fe.operacion_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Operacion_id#">
					and fe.tipodoc_id <> 2
			</cfquery>
			<!--- Recorremos los encabezados Insertandolos y extrayendo sus detalles de Pago y detalles de Venta --->
			<cfif isdefined("rsEVentas") AND rsEVentas.recordcount GT 0>
			<cfloop query="rsEVentas">
				<!--- ID para la tabla de Encabezados --->
				<cfquery name="rsMaxIDE" datasource="sifinterfaces">
					select isnull(max(id_documentoV),0) + 1 as MaxID
					from ESIFLD_Facturas_Venta
				</cfquery> 
	
				<!--- Crea el numero de Documento --->
				<cfif rsEVentas.Tipo_Venta EQ "C" and rsEVentas.Tipo_CEDI EQ 0>
					<cfset Num_Doc = "V-" & numberformat(rsOperacionID.Emp_Id,"00") & numberformat(rsOperacionID.Suc_Id,"0000") &  numberformat(rsEVentas.Caja_Id,"00") & "-" & numberformat(rsEVentas.Factura_Id,"000000000")>
				<cfelseif rsEVentas.Tipo_Venta EQ "C" and rsEVentas.Tipo_CEDI EQ 1>
					<cfset Num_Doc = rsEVentas.Factura_Id>
				<cfelse>
					<cfset Num_Doc = "V-" & numberformat(rsOperacionID.Emp_Id,"00") & numberformat(rsOperacionID.Suc_Id,"0000") & "-" & numberformat(rsOperacionID.Operacion_Id,"000000000")>
				</cfif>
				
				<cftransaction action="begin">
				<cftry>
					<!--- Inserta los encabezados ---> 
					<cfquery datasource="sifinterfaces">
						insert into ESIFLD_Facturas_Venta 
						(Ecodigo, Origen, ID_DocumentoV, Tipo_Documento, Tipo_Venta, Fecha_Venta, Fecha_Operacion,
							Numero_Documento, Cliente, IETU_Clas, Subtotal, Descuento, Impuesto, Total,
							Vendedor, Sucursal, Dias_Credito, Moneda, Tipo_cambio, Direccion_Facturacion, 
							Retencion, Observaciones,Tipo_CEDI,Estatus, Factura_Cambio)
						 values 
						 (<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_id#">,
						 'LD',
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">, 
						 case 
							when <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEVentas.TipoDoc_id#"> in (1,4) then 'FC' 
							when <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEVentas.TipoDoc_id#"> in (3,5) then 'NC' 
						 end , 
						 <cfqueryparam cfsqltype="cf_sql_char" value="#rsEVentas.Tipo_Venta#">, 
						 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Factura_Fecha,'short')#">, 
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Cierre#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Num_Doc#">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEVentas.cliente_id#">,
						 null,
						 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsEVentas.factura_subtotal,'9.99')#">), 
						 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsEVentas.factura_descuento,'9.99')#">), 
						 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsEVentas.factura_impuesto,'9.99')#">), 
						 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsEVentas.factura_total,'9.99')#">),
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEVentas.vendedor_id#">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEVentas.Suc_Id#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEVentas.dias_credito#">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMoneda.Moneda_Id#">,
						 1, 
						 <cfif rsEVentas.subcliente_id NEQ "">
							abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsEVentas.factura_descuento,'9.99')#">),
						 <cfelse>
							null,
						 </cfif>
						 '',
						 '', 
						 <cfif rsEVentas.Tipo_CEDI EQ 1>
							'S',
						 <cfelse>
							'N',
						 </cfif>
						 0,
						 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsEVentas.Factura_Cambio_Efectivo,'9.99')#">))
					</cfquery>
					<cftransaction action="commit" />
				<cfcatch type="any">
					<cftransaction action="rollback" />
					<!--- Variables de Error --->
					<cfset ErrCaja = rsEVentas.Caja_Id>
					<cfset ErrFactura = rsEVentas.Factura_Id>
					<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
					<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
					<cfthrow message="Error al Insertar el Encabezado: #cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
				</cfcatch>
				</cftry>
				</cftransaction>
				<!--- Busca e inserta las Formas de Pago para el Encabezado --->
				<!---
					Efectivo = 1			E
					Tarjeta = 2				T
					Cupones = 3				V
					Cheuqes = 4				H
					MonedaExtranjera = 5	X
					NotadeCredito = 6		N
					Monedero = 7			M
					Puntos = 8				P
					Copago = 10				C
				--->
				<cfquery name="rsFormaPago" datasource="ldcom">
					select f.Tipo_Id, f.Moneda_Id, f.Tarjeta_Id, f.Pago_Total, f.Cupon_Id, 
					Pago_Total_Tipo_Cambio, 0 as Tarjeta_Porcentaje
					from Factura_Forma_Pago f
						<!---left join Tarjeta t
						on f.Emp_Id = t.Emp_Id and f.Tarjeta_Id = t.Tarjeta_Id--->
					where Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_id#">
					and Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_id#">
					and Caja_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEVentas.Caja_Id#">
					and Factura_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEVentas.Factura_Id#">
				</cfquery>
				<cfset IDlinea = 1>
				<cfif isdefined("rsFormaPago") and rsFormaPago.recordcount GT 0>
				<cfloop query="rsFormaPago">
					<!--- Busca Socio para los casos especiales --->
					<cfif (rsFormaPago.Tipo_Id EQ 2 AND rsFormaPago.Tarjeta_Id EQ 3)>
						<cfset varSocioDoc = "AMEX">
					<cfelseif rsFormaPago.Tipo_Id EQ 3>
						<cfquery name="rsCupon" datasource="ldcom">
							select Cupon_Nombre
							from Cupon
							where  Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_id#">
							 and Cupon_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsFormaPago.Cupon_Id#">	
						</cfquery>
						<cfset varSocioDoc = rsCupon.Cupon_Nombre>
					<cfelse>
						<cfset varSocioDoc = "SOCIONULO">
					</cfif>
					<cftransaction action="begin">
					<cftry>
						<cfquery datasource="sifinterfaces">
							insert SIFLD_Facturas_Tipo_Pago
							(Ecodigo, ID_DocumentoV, ID_linea_Pago, Tipo_Pago, Importe, 
							Moneda, Tipo_Cambio, Especial, SocioDocumento, ID_Forma_Pago, Comision_Porcentaje)
							values (
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_id#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">,
							<cfif rsFormaPago.Tipo_Id EQ 1>
								'E',
							<cfelseif rsFormaPago.Tipo_Id EQ 2>
								'T',
							<cfelseif rsFormaPago.Tipo_Id EQ 3>
								'V',
							<cfelseif rsFormaPago.Tipo_Id EQ 4>
								'H',
							<cfelseif rsFormaPago.Tipo_Id EQ 5>
								'X',
							<cfelseif rsFormaPago.Tipo_Id EQ 6>
								'N',
							<cfelseif rsFormaPago.Tipo_Id EQ 7>
								'M',
							<cfelseif rsFormaPago.Tipo_Id EQ 8>
								'P',
							<cfelseif rsFormaPago.Tipo_Id EQ 10>
								'C',
							</cfif>
							abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsFormaPago.Pago_Total,'9.99')#">),
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMoneda.Moneda_Id#">,
							1,
							<!---<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsFormaPago.Moneda_Id#">,--->
							<cfif (rsFormaPago.Tipo_Id EQ 2 AND rsFormaPago.Tarjeta_Id EQ 3) OR rsFormaPago.Tipo_Id EQ 3>
								1,
							<cfelse>
								0,
							</cfif>
							<cfif varSocioDoc NEQ "SOCIONULO">
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#varSocioDoc#">,
							<cfelse>
								null,
							</cfif>
							<cfif rsFormaPago.Tipo_Id eq 2>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsFormaPago.Tarjeta_Id#">,
							<cfelseif rsFormaPago.Tipo_Id eq 3>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsFormaPago.Cupon_Id#">,
							<cfelse>
								null,
							</cfif>
							abs(isnull(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsFormaPago.Tarjeta_Porcentaje,'9.99')#">,0))
							)
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
						<cftransaction action="commit" />
					<cfcatch type="any">
						<cftransaction action="rollback" />
						<!--- Borra los registros para el Encabezado que se habia Insertado--->
						<cfquery datasource="sifinterfaces">
							delete SIFLD_Facturas_Tipo_Pago
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_id#">
								and ID_DocumentoV =	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">
							delete DSIFLD_Facturas_Venta
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_id#">
								and ID_DocumentoV =	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">
							delete ESIFLD_Facturas_Venta
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_id#">
								and ID_DocumentoV =	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">
						</cfquery>
						<!--- Variables de Error --->
						<cfset ErrCaja = rsEVentas.Caja_Id>
						<cfset ErrFactura = rsEVentas.Factura_Id>
						<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
						<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
						<cfthrow message="Error Insertando Forma de Pago: #cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
					</cfcatch>
					</cftry>
					</cftransaction>
					<!--- Inserta un movimiento Bancario para las Formas de Pago Tarjeta de Credito --->
					<cfif rsFormaPago.Tipo_Id EQ 2 AND rsFormaPago.Tarjeta_Id NEQ 3>
						<cftransaction action="begin">
						<cftry>
							<!--- Arma documento para movimiento bancario --->
							<cfset Num_Doc = numberformat(rsOperacionID.Emp_Id,"00") & "-" & numberformat(rsOperacionID.Suc_Id,"0000") & "-" &  >
							<cfquery datasource="sifinterfaces">
								insert SIFLD_Movimientos_Bancarios
									(Ecodigo, Origen, ID_MovimientoB, Tipo_Operacion, Tipo_Movimiento, 
									 Fecha_Movimiento,Documento, Referencia, Banco_Origen, Cuenta_Origen, 
									 Banco_Destino, Cuenta_Destino, Importe_Movimiento, Sucursal, Estatus)
								values (
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_id#">,
								 'LD',
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">,
								 'PTB',
								 'P',
								 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Factura_Fecha,'short')#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#NumDoc#">,
								 null,
								 null,
								 null,
								 null,
								 null,
								 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsFormaPago.Pago_Total,'9.99')#">),
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_id#">,
								 1)
							</cfquery>
							<cftransaction action="commit" />
						<cfcatch type="any">
							<cftransaction action="rollback" />
							<!--- Borra los registros para el Encabezado que se habia Insertado--->
							<cfquery datasource="sifinterfaces">
								delete SIFLD_Movimientos_Bancarios
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_id#">
									and Documento like <cfqueryparam cfsqltype="cf_sql_varchar" value="#NumDoc#">
								delete SIFLD_Facturas_Tipo_Pago
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_id#">
									and ID_DocumentoV =	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">
								delete DSIFLD_Facturas_Venta
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_id#">
									and ID_DocumentoV =	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">
								delete ESIFLD_Facturas_Venta
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_id#">
									and ID_DocumentoV =	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">
							</cfquery>
							<!--- Variables de Error --->
							<cfset ErrCaja = rsEVentas.Caja_Id>
							<cfset ErrFactura = rsEVentas.Factura_Id>
							<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
							<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
							<cfthrow message="Error Insertando Deposito Bancario: #cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
						</cfcatch>
						</cftry>
						</cftransaction>	
					</cfif>
				</cfloop> <!---FormaPago--->
				</cfif>
				<!--- Busca e Inserta los Detalles del Encabezado ---> 
				<cfquery name="rsDVentas" datasource="ldcom">
					select distinct fd.Factura_Id,0 as Tipo_Articulo_Id,
						  a.Depto_Id, 0 as Casa_Id, 1 as Cantidad, 
						   round(isnull(sum(Detalle_Cantidad * Detalle_Impuesto_Monto),0),2) as Impuesto, 
						   round(isnull(sum(Detalle_Total * Detalle_Cantidad),0),2) as Total,
						   isnull(i.Impuesto_id,0) as Impuesto_Id, 
						   round(isnull(sum(Detalle_Precio_Unitario * Detalle_Cantidad),0),2) as Precio_Unitario, 
						   round(isnull(sum(Detalle_Descuento_Monto * Detalle_Cantidad),0),2) as Descuento,
						   round(isnull(sum(Detalle_Costo_Unitario * Detalle_Cantidad),0),2) as Costo_Unitario
					from Factura_Detalle fd
						inner join Articulo a 
						on fd.Articulo_Id = a.Articulo_Id and a.Emp_Id = fd.Emp_Id
						left join Factura_Detalle_Impuestos i 
						on i.Emp_Id = fd.Emp_Id and i.Suc_Id = fd.Suc_Id and i.Caja_Id = fd.Caja_Id
							and fd.Factura_Id = i.Factura_Id and fd.Tipodoc_Id = i.Tipodoc_Id 
							and fd.Articulo_Id = i.Articulo_Id
					where fd.Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_id#"> 
						and fd.Factura_Id  = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEVentas.Factura_Id#">
						and fd.Tipodoc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEVentas.TipoDoc_Id#"> 
						and fd.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEVentas.Suc_Id#">
						and fd.Caja_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEVentas.Caja_Id#">  
					group by fd.Emp_Id, fd.Suc_Id, fd.Caja_Id,fd.Factura_Id,a.Depto_Id,i.Impuesto_Id
				</cfquery>
				<cfset IDlinea = 1>
				<cfif isdefined("rsDVentas") and rsDVentas.recordcount GT 0>
				<cfloop query="rsDVentas">
					<cftransaction>
					<cftry>
						<cfquery datasource="sifinterfaces">
							insert into DSIFLD_Facturas_Venta 
								(Ecodigo, ID_DocumentoV, Id_linea, tipo_lin, tipo_item, clas_item,
								  cod_impuesto, cantidad,total_lin,precio_unitario, descuento_lin,
								  descuento_fact,subtotal_lin, impuesto_lin, costo_venta, cod_fabricante, cod_item) 
							values 
							(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_id#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">, 
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
							 'S',
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDVentas.Depto_Id#">, 
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDVentas.Tipo_Articulo_Id#">, 
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDVentas.Impuesto_Id#">, 
							 <cfqueryparam cfsqltype="cf_sql_float" value="#rsDVentas.Cantidad#">, 
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Total,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Precio_Unitario,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Descuento,'9.99')#">),
							 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.total - rsDVentas.impuesto,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.impuesto,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.costo_unitario,'9.99')#">),
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDVentas.casa_Id#">,
							 'VENTA')
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
						<cftransaction action="commit" />
					<cfcatch type="any">
						<cftransaction action="rollback" />
						<!--- Borra los registros para el Encabezado que se habia Insertado--->
						<cfquery datasource="sifinterfaces">
							delete SIFLD_Facturas_Tipo_Pago
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_id#">
								and ID_DocumentoV =	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">
							delete DSIFLD_Facturas_Venta
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_id#">
								and ID_DocumentoV =	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">
							delete ESIFLD_Facturas_Venta
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_id#">
								and ID_DocumentoV =	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">
						</cfquery>
						<!--- Variables de Error --->
						<cfset ErrCaja = rsEVentas.Caja_Id>
						<cfset ErrFactura = rsEVentas.Factura_Id>
						<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
						<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
						<cfthrow message="Error Insertando Detalle de Venta: #cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
					</cfcatch>
					</cftry>
					</cftransaction>
				</cfloop> <!---Detalles Venta--->
				</cfif>
				<cfquery datasource="sifinterfaces">
					update ESIFLD_Facturas_Venta
					set Estatus = 1 
					where ID_DocumentoV = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">
				</cfquery>
			</cfloop> <!--- Encabezados Venta--->
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
						'VENTAS',
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
			</cfquery>
		<cfcatch type="any">
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
						'VENTAS',
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">)
			</cfquery>
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
				'No hay Cierres de Sucursal para el Dia de Hoy', 'VENTAS', getdate())
		</cfquery>
	</cfif>
</cffunction>
</cfcomponent>

