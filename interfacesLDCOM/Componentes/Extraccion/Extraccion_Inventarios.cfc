<!--- ABG: Extraccion de Inventario Interfaz LD-SIF Ver. 1.0 --->
<!--- La Interfaz LD-SIF solo funciona con versiones de Coldfusion 8.0 en adelante --->
<cfcomponent>
<cffunction name="Ejecuta" access="public" returntype="string" output="yes">
	<cfset LvarLinkServ = false>
	<!--- Cambiar esta variable a true si se desea que se haga una poliza por cada cierre 
	Poner en false si se desea una sola poliza por sucursal, Operacion ID agrupando todos los retiros--->
	<cfset varDetallado = true>
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
						and bp.Proceso like 'INVENTARIOS')
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
			<!--- Extrae los encabezados para los Movimientos de Inventario que pertenecen a las operaciones Cerradas al momento de la ejecucion --->
			<cfquery name="rsEInventario" datasource="ldcom">
				<!--- AJUSTES DE INVENTARIO --->
				select Suc_Id, Mov_Id, convert(varchar(2),m.Tipo_Id) as Tipo_Mov, Mov_Fecha_Aplicado as Fecha_Movimiento, 
					Mov_Comentario, Bodega_Id, Bodega_Id as Bodega_Destino, 
					case t.Tipo_Tipo_Movimiento 
					when 0 then 'E' 
					when 1 then 'S' 
					else 'E' end  as Tipo_Ajuste, 
					Suc_Id as Suc_Destino, 'AJ' as Movimiento
				from Mov_Inventario_Encabezado m 
					inner join Tipo_Mov_Inventario t
					on  m.Tipo_Id = t.Tipo_Id and t.Emp_Id = m.Emp_Id
					and t.Tipo_Tipo_Movimiento <> 2 <!--- Todos los Ajustes de Inventario --->
				where m.Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#">
				and m.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_Id#">
				and m.Mov_Fecha_Aplicado between
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Apertura#">
						and
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Cierre#">
				and Mov_Estado like 'AP'
				UNION
				<!--- MOVIMIENTOS INTERALMACEN --->
				select Suc_Id, Mov_Id, 'TR' as Tipo_Mov, Mov_Fecha_Aplicado as Fecha_Movimiento, 
					Mov_Comentario, Bodega_Id, Bodega_Destino, 'S' as Tipo_Ajuste, Suc_Destino, 'IA' as Movimiento
				from Mov_Inventario_Encabezado m 
					inner join Tipo_Mov_Inventario t 
					on  m.Tipo_Id = t.Tipo_Id and t.Emp_id = m.Emp_id
					and t.Tipo_Tipo_Movimiento = 2 <!--- Movimiento Inter-Almacen Despacho --->
				where m.Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#">
				and m.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_Id#">
				and mov_fecha_aplicado between
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Apertura#">
						and
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Cierre#">
				and Mov_Estado like 'AP'
				UNION
				select Suc_Id, Mov_Id, 'TR' as Tipo_Mov, Mov_Fecha_Recibido as Fecha_Movimiento, 
					Mov_Comentario, Bodega_Id, Bodega_Destino,
					case  
					when convert(varchar(10),m.mov_fecha_aplicado,101) = convert(varchar(10),mov_fecha_recibido,101) then 'ES'
					else 'E' end  as tipo_ajuste, Suc_Destino, 'IA' as Movimiento
				from Mov_Inventario_Encabezado m
					inner join Tipo_Mov_Inventario t 
					on  m.Tipo_Id = t.Tipo_Id and t.Emp_Id = m.Emp_Id
					   and t.tipo_tipo_movimiento = 2 <!--- Movimiento Inter-Almacen Recepción --->
				where m.Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#">
					and m.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_Id#">
					and Mov_Fecha_Recibido between
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Apertura#">
							and
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Cierre#">
					and Mov_Estado like 'RE'
			
				UNION
				<!--- DESPACHO CEDI	--->
				<!--- Los Despachos de CEDI se obitenen por el cierre de la sucursal, el Despacho contiene,
				la sucursal destino, cuando esta cierra y el despacho se encuentra dentro de las fechas de 
				operacion del cierre, se captura el despacho --->
				select CEDI_Id as Suc_Id, Pedido_Id as Mov_Id,'DC' as Tipo_Mov, Desp_Fecha_Aplicado as Fecha_Movimiento,
				Desp_Comentario as Mov_Comentario, Bodega_Id,0 as Bodega_Destino, 'S' as Tipo_Ajuste,
				Suc_Id as Suc_Destino, 'DC' as Movimiento		
				from Inv_Despacho_Encabezado 
				where Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#">
					and CEDI_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_Id#">
					and Desp_Fecha_Aplicado between
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Apertura#">
							and
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Cierre#">
					and desp_estado = 'RE'
				
				UNION
				<!--- RECEPCION CEDI --->
				select CEDI_Id as Suc_Id, Boleta_Id as Mov_Id, 'RC' Tipo_Mov, Boleta_Fecha_Aplica as Fecha_Movimiento,
				'Recepcion CEDI' as Mov_Comentario, 0 as Bodega_Origen, Bodega_Id as Bodega_Destino, 'E' as Tipo_Ajuste, 
				Suc_Id as Suc_Destino, 'RC' as Movimiento
				from Boleta_Cedi_Encabezado_Hist 
				where Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#">
					and Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_Id#">
					and Boleta_Fecha_Aplica between
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Apertura#">
							and
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Cierre#">
					and Boleta_Estado = 'AP'
			</cfquery>
			<!--- Recorremos los encabezados Insertandolos y extrayendo sus detalles de Pago y detalles de Venta --->
			<cfif isdefined("rsEInventario") AND rsEInventario.recordcount GT 0>
			<cfloop query="rsEInventario">
				<!--- ID para la tabla de Encabezados --->
				<cfquery name="rsMaxIDE" datasource="sifinterfaces">
					select isnull(max(ID_Movimiento),0) + 1 as MaxID
					from ESIFLD_Movimientos_Inventario
				</cfquery> 
	
				<!--- Crea el numero de Documento --->
				<cfif varDetallado>
					<cfset Num_Doc = rsEInventario.Movimiento & numberformat(rsOperacionID.Emp_Id,"00") & "-" & numberformat(rsOperacionID.Suc_Id,"0000") & numberformat(rsEInventario.Bodega_Id,"00") & "-" & numberformat(rsEInventario.Mov_Id,"00000000")>
				<cfelse>
					<cfset Num_Doc = numberformat(rsOperacionID.Emp_Id,"00") & "-" & numberformat(rsOperacionID.Suc_Id,"0000") & numberformat(rsOperacionID.Operacion_Id,"0000")>
				</cfif>
				
				<cftransaction action="begin">
				<cftry>
					<!--- Inserta los encabezados ---> 
					<cfquery datasource="sifinterfaces">
						insert into ESIFLD_Movimientos_Inventario 
							(Ecodigo, Origen,Sucursal_Origen, ID_Movimiento, Tipo_Movimiento, Fecha_Movimiento,Documento,
							 Descripcion, Almacen_Origen, Almacen_Destino, tipo_ajuste, Sucursal_Destino, Estatus)
						Values 
						( 
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_id#">,
						 'LD',
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOperacionID.Suc_Id#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventario.Tipo_Mov#">,
						 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEInventario.Fecha_Movimiento,"short")#"> ,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Num_Doc#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventario.Mov_Comentario#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventario.Bodega_Id#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventario.Bodega_Destino#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventario.Tipo_Ajuste#">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventario.Suc_Destino#">,
						 1)
					</cfquery>
					<cftransaction action="commit" />
				<cfcatch type="any">
					<cftransaction action="rollback" />
					<!--- Variables de Error --->
					<cfset ErrBodega = rsEInventario.Bodega_Id>
					<cfset ErrFactura = rsEInventario.Mov_Id>
					<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
					<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
					<cfthrow message="Error al Insertar el Encabezado: #cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
				</cfcatch>
				</cftry>
				</cftransaction>
				<!--- Busca e Inserta los Detalles del Encabezado ---> 
				<cfquery name="rsDInventario" datasource="ldcom">
					<!--- AJUSTES DE INVENTARIO --->
					<cfif rsEInventario.Movimiento EQ "AJ" OR rsEInventario.Movimiento EQ "IA">
						select Mov_Id, a.Depto_Id,0 as Tipo_Articulo_Id,0 as Casa_Id, 1 as Cantidad, 
							sum(Detalle_Cantidad * Detalle_Costo_Unitario) as Costo
						from Mov_Inventario_Detalle d  
							inner join Articulo a 
							on d.Articulo_Id = a.Articulo_Id and a.Emp_id = d.Emp_Id
						where d.Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#">
							and d.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_Id#">
							and d.Bodega_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEInventario.Bodega_Id#"> 
							and d.Mov_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEInventario.Mov_Id#"> 
						group by d.Emp_Id,d.Suc_Id,d.Bodega_Id,d.Mov_Id, a.Depto_Id
					<!--- DESPACHO CEDI --->
					<cfelseif rsEInventario.Movimiento EQ "DC">
						select Pedido_Id as Mov_Id, a.Depto_Id,0 as Tipo_Articulo_Id,0 as Casa_Id, 1  as Cantidad,
							sum(Detalle_Cantidad_Pedida * Detalle_Costo_Neto_Ped) as Costo
						from Inv_Despacho_Detalle d 
							inner join Articulo a 
							on d.Articulo_Id = a.Articulo_Id and a.Emp_Id = d.Emp_Id
						where d.Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#">
							and d.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_Id#">
							and d.Bodega_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEInventario.Bodega_Id#"> 
							and d.Pedido_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEInventario.Mov_Id#">
						group by d.Emp_Id, d.Suc_Id, d.Bodega_Id, Pedido_Id, a.Depto_Id
					<!--- RECEPCION CEDI --->
					<cfelseif rsEInventario.Movimiento EQ "RC">
						select Boleta_Id as Mov_Id, a.Depto_Id,0 as Tipo_Articulo_Id,0 as Casa_Id, 1 as Cantidad,
							sum(Detalle_Cantidad * Detalle_Costo_Neto) as Costo
						from Boleta_CEDI_Detalle_Hist d
							inner join Articulo a 
							on d.Articulo_Id = a.Articulo_Id and a.Emp_Id = d.Emp_Id
						where d.Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#">
							and d.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_Id#">
							and d.Bodega_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEInventario.Bodega_Destino#"> 
							and Boleta_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEInventario.Mov_Id#">
						group by d.Emp_Id, d.Suc_Id, d.Bodega_Id, Boleta_Id, a.Depto_Id
					</cfif>
				</cfquery>
				<cfset IDlinea = 1>
				<cfif isdefined("rsDInventario") and rsDInventario.recordcount GT 0>
				<cfloop query="rsDInventario">
					<cftransaction action="begin">
					<cftry>
						<cfquery datasource="sifinterfaces">
							insert into DSIFLD_Movimientos_Inventario 
								(Ecodigo, ID_Movimiento, Id_Linea, Tipo_Item, Clas_Item,
								 Cod_Fabricante,Cod_Item, Cantidad, Costo)
							Values 
							(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_id#">, 
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">, 
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDInventario.Depto_Id#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDInventario.Tipo_Articulo_Id#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDInventario.Casa_Id#">,
							 'INVENTARIO',  
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDInventario.Cantidad,9.99)#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDInventario.Costo,9.99)#">)) 
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
						<cftransaction action="commit" />
					<cfcatch type="any">
						<cftransaction action="rollback" />
						<!--- Borra los registros para el Encabezado que se habia Insertado--->
						<cfquery datasource="sifinterfaces">
							delete ESIFLD_Movimientos_Inventario
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_id#">
								and ID_Movimiento =	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">
							delete DSIFLD_Movimientos_Inventario
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_id#">
								and ID_Movimiento =	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">
						</cfquery>
						<!--- Variables de Error --->
						<cfset ErrBodega = rsEInventario.Bodega_Id>
						<cfset ErrFactura = rsEInventario.Mov_Id>
						<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
						<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
						<cfthrow message="Error Insertando Detalle de Movimiento: #cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
					</cfcatch>
					</cftry>
					</cftransaction>
				</cfloop> <!---Detalles Inventario--->
				</cfif>
			</cfloop> <!--- Encabezados Inventario--->
			</cfif> 
			<!--- Inserta Operacion ID a Bitacora para Inventarios --->
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
						'INVENTARIOS',
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
					'INVENTARIOS',
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
				'No hay Cierres de Sucursal para el Dia de Hoy', 'INVENTARIOS', getdate())
		</cfquery>
	</cfif>
</cffunction>
</cfcomponent>