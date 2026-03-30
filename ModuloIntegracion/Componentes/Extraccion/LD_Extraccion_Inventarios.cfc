<!----
	Author: 	   Rodrigo Ivan Rivera Meneses
	Name: 		   LD_Extraccion_Compras.cfc
	Version: 	   1.0
	Date Created:  19-NOV-2015
	Date Modified: 19-NOV-2015
	Base Document: Extraccion_Inventarios.cfc
	Hint:		   This Process is heavy on the memory, if you get the java overhead limit exceeded error,
				   avoid calling the GC directly and instead increase the java heap size in the coldfusion administrator
--->
<cfcomponent output="false">
<cffunction name="Ejecuta" access="public" returntype="string" output="no">
	<!--- Variables --->
	<cfset DataSource = 'ldcom'>
	<cfset ErrCaja 	  = "">
	<cfset ErrBodega  = "">
	<cfset ErrFactura = "">
	<cfset fechaini   = "">
	<cfset fechafin   = "">
	<!--- Cambiar esta variable a true si se desea que se haga una poliza por cada movimiento de Inventario
	Poner en false si se desea una sola poliza por sucursal, Operacion ID agrupando todos los retiros--->
	<cfset varDetallado = true>
	<!--- Asigna las variables de fechas --->
	<cfif isdefined("form.fechaIni") and isdefined("form.fechaFin")>
		<cfset fechaini = createdate(right(form.fechaini,4),mid(form.fechaini,4,2),left(form.fechaini,2))>
		<cfset fechafin = createdatetime(right(form.fechafin,4),mid(form.fechafin,4,2),left(form.fechafin,2),23,59,59)>
	<cfelse>
		<cfset fechaini = 0>
		<cfset fechafin = 0>
	</cfif>

	<!--- SE OBTIENE LA SUCURSAL --->
	<cfset Suc_Id = -1>
	<cfif isdefined("form.cbo_Sucursal_Ext")>
		<cfset Suc_Id = #form.cbo_Sucursal_Ext#>
	</cfif>

	<!--- Obtiene operaciones no procesadas a realizar --->
	<cfinvoke component = "ModuloIntegracion.Componentes.Operaciones" method="init" returnvariable="O" />
	<!--- inicializa variable de Argumentos --->
	<cfset varArguments = {DataSource = "#DataSource#",Estado = "CERR", FechaIni = "#fechaini#", FechaFin = "#fechafin#", Proceso = "INVENTARIOS", Sucursal   = "#Suc_Id#"}>
	<cfset rsOperacionID = O.getOperacionesLD(argumentCollection = varArguments)>
	<!--- Proceso --->
	<cfif isdefined("rsOperacionID") and rsOperacionID.recordcount GT 0>
		<cfloop query="rsOperacionID">
			<cftry>
				<!--- Obtiene la Moneda Local --->
				<cfset rsMoneda = O.getMonedaLD(DataSource,Emp_Id)>
				<cfif rsMoneda.recordcount EQ 0>
					<cfthrow message="Error al extraer la moneda Local">
				</cfif>
				<!--- Extrae los encabezados para los Movimientos de Inventario que pertenecen a las operaciones Cerradas al momento de la ejecucion --->
				<cfset rsEInventario = getEncabezado(DataSource,Emp_Id,Suc_Id,rsOperacionID.Operacion_Fecha_Apertura,rsOperacionID.Operacion_Fecha_Cierre)>
			<!--- <cfthrow message="Salgo de rsEInventario linea 53">	--->
				<!--- Recorremos los encabezados Insertandolos --->
				<cfif isdefined("rsEInventario") AND rsEInventario.recordcount GT 0>
					<cfloop query="rsEInventario">
						<!--- ID para la tabla de Encabezados --->
						<cfquery name="rsMaxIDE" datasource="sifinterfaces">
							SELECT isnull(max(ID_Movimiento),0) + 1 as MaxID
							  FROM ESIFLD_Movimientos_Inventario
						</cfquery>
						<!--- Crea el numero de Documento --->
						<cfif varDetallado>
							<cfset Num_Doc = rsEInventario.Movimiento & numberformat(rsOperacionID.Emp_Id,"00") & "-" & numberformat(rsOperacionID.Suc_Id,"0000") & numberformat(rsEInventario.Bodega_Id,"00") & "-" & numberformat(rsEInventario.Mov_Id,"00000000")>
							<cfset Desc_Doc = "Despacho Inventario">
						<cfelse>
							<cfset Num_Doc = rsEInventario.Movimiento & numberformat(rsOperacionID.Emp_Id,"00") & "-" & numberformat(rsOperacionID.Suc_Id,"0000") & numberformat(rsOperacionID.Operacion_Id,"0000")>
							<cfswitch expression="#rsEInventario.Movimiento#">
								<cfcase value="AJ">
									<cfset Desc_Doc = "Ajuste de Inventario">
								</cfcase>
								<cfcase value="IA">
									<cfset Desc_Doc = "Traslado entre almacenes">
								</cfcase>
								<cfcase value="DC">
									<cfset Desc_Doc = "Despacho Inventario">
								</cfcase>
								<cfcase value="RC">
									<cfset Desc_Doc = "Recepci&oacute;n Inventario">
								</cfcase>
								<cfdefaultcase>
									<cfset Desc_Doc = "Movimientos de Inventario">
								</cfdefaultcase>
							</cfswitch>
						</cfif>
						<cftransaction action="begin">
							<cftry>
								<!--- Inserta los encabezados --->
								<cfquery datasource="sifinterfaces">
									insert into ESIFLD_Movimientos_Inventario
										(Ecodigo, Origen,Sucursal_Origen, ID_Movimiento, Tipo_Movimiento, Fecha_Movimiento, Documento,
										 Descripcion, Almacen_Origen, Almacen_Destino, Tipo_Ajuste, Sucursal_Destino, Estatus,Fecha_Inclusion)
									Values
										(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_Id#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="LD">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventario.Suc_Id#">,
										 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventario.Tipo_Mov#">,
										 <cfqueryparam cfsqltype="cf_sql_date" 	  value="#dateformat(rsEInventario.Fecha_Movimiento,"short")#"> ,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Num_Doc#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Desc_Doc#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventario.Bodega_Id#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventario.Bodega_Destino#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventario.Tipo_Ajuste#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventario.Suc_Destino#">,
										 <cfqueryparam cfsqltype="cf_sql_numeric" value="15">,
										 '#DateFormat(now(),'yyyy-mm-dd HH:mm:ss')#')
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
						<cfset varArgumentsD = {DataSource="#DataSource#",Movimiento="#rsEInventario.Movimiento#",Emp_Id="#rsEInventario.Emp_Id#",Suc_Id="#rsEInventario.Suc_Id#",Suc_Destino="#rsEInventario.Suc_Destino#",Bodega_Id="#rsEInventario.Bodega_Id#",
												Bodega_Destino="#rsEInventario.Bodega_Destino#",Mov_Id="#rsEInventario.Mov_Id#",SubPedido_Id="#rsEInventario.SubPedido_Id#"}>
						<cfset rsDInventario = getDetalle(argumentCollection = varArgumentsD)>
						<cfset IDlinea = 1>
						<cfif isdefined("rsDInventario") and rsDInventario.recordcount GT 0>
							<cfloop query="rsDInventario">
								<cftransaction action="begin">
								<cftry>
									<cfquery datasource="sifinterfaces">
										insert into DSIFLD_Movimientos_Inventario
											(Ecodigo, ID_Movimiento, ID_linea, Tipo_Item, Clas_Item,
											 Cod_Fabricante, Cod_Item, Cantidad, Costo, Impuesto_Id)
										Values
											(<cfqueryparam cfsqltype="cf_sql_numeric"   value="#rsOperacionID.Emp_Id#">,
											 <cfqueryparam cfsqltype="cf_sql_numeric"   value="#rsMaxIDE.MaxID#">,
											 <cfqueryparam cfsqltype="cf_sql_numeric"   value="#IDlinea#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar"   value="#rsDInventario.Depto_Id#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar"   value="#rsDInventario.Tipo_Articulo_Id#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar"   value="#rsDInventario.Casa_Id#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar"   value="INVENTARIO">,
											 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDInventario.Cantidad,9.99)#">),
											 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDInventario.Costo,9.99)#">),
											 <cfqueryparam cfsqltype="cf_sql_numeric"   value="#Impuesto_Id#">)
									</cfquery>
									<cfset IDlinea = IDlinea + 1>
									<cftransaction action="commit" />
								<cfcatch type="any">
									<cftransaction action="rollback" />
									<!--- Borra los registros para el Encabezado que se habia Insertado--->
									<cfquery name="deleteMovInvDet" datasource="sifinterfaces">
										DELETE 	DSIFLD_Movimientos_Inventario
										 WHERE 	Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Emp_Id#">
										   AND 	ID_Movimiento =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">
									</cfquery>
									<cfquery name="deleteMovInvEnc" datasource="sifinterfaces">
										DELETE 	ESIFLD_Movimientos_Inventario
										 WHERE 	Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Emp_Id#">
										   AND 	ID_Movimiento =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">
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
							</cfloop> <!--- Detalles Inventario --->
						</cfif>
						<cfset rsDInventario = javacast("null","")>
					</cfloop> <!--- Encabezados Inventario --->
				</cfif>
				<cfquery datasource="sifinterfaces">
					update 	ESIFLD_Movimientos_Inventario
					set 	Estatus = 1
					where 	Estatus = 15
				</cfquery>
				<cfset varProc = true>
			<cfcatch type="any">
				<cfquery name="rsGetMov" datasource="sifinterfaces">
					SELECT ID_Movimiento
					FROM ESIFLD_Movimientos_Inventario
					WHERE Estatus = 15
				</cfquery>

				<cfif rsGetMov.recordcount GT 0>
					<cfloop query="rsGetMov">
						<!--- Elimina detalle --->
						<cfquery name="deleteD" datasource="sifinterfaces">
							DELETE 	DSIFLD_Movimientos_Inventario
							 WHERE 	ID_Movimiento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGetMov.ID_Movimiento#">
						</cfquery>

						<!--- Elimina Encabezado --->
						<cfquery name="deleteE" datasource="sifinterfaces">
							DELETE ESIFLD_Movimientos_Inventario
							 WHERE ID_Movimiento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGetMov.ID_Movimiento#">
						</cfquery>
					</cfloop>
				</cfif>
				<!--- <cfquery name="deleteD" datasource="sifinterfaces">
					DELETE 	DSIFLD_Movimientos_Inventario
					 WHERE 	ID_Movimiento IN
						(SELECT ID_Movimiento
						   FROM ESIFLD_Movimientos_Inventario
						  WHERE Estatus = 15)
				</cfquery> --->
				<!--- <cfquery name="deleteE" datasource="sifinterfaces">
					DELETE ESIFLD_Movimientos_Inventario
					 WHERE Estatus = 15
				</cfquery> --->
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
				<cfset varArgumentsLE = {Sistema    = "LD",
										 Empresa    = "#rsOperacionID.Emp_Id#",
										 Sucursal   = "#rsOperacionID.Suc_Id#",
										 Operacion  = "#rsOperacionID.Operacion_Id#",
										 ErrCaja    = "#ErrCaja#",
										 ErrBodega  = "#ErrBodega#",
										 ErrFactura = "#ErrFactura#",
										 MsgError   = "#cfcatch.Message#",
										 Error_Comp = "#cfcatch.Message# #cfcatch.Detail# #ErrSQL# #ErrPAR#",
										 Proceso    = "INVENTARIOS"}>
				<cfset LogErrores = O.setLogErrores(argumentCollection=varArgumentsLE)>
				<cfset varProc = false>
			</cfcatch>
			</cftry>
			<cfif varProc>
				<!--- Inserta Operacion ID a Bitacora --->
				<cfset varArgumentsBP = {Sistema   = "LD",
										 Empresa   = "#rsOperacionID.Emp_Id#",
										 Sucursal  = "#rsOperacionID.Suc_Id#",
										 Operacion = "#rsOperacionID.Operacion_Id#",
										 Proceso   = "INVENTARIOS"}>
				<cfset BitacoraProcesos = O.setBitacoraProcesos(argumentCollection=varArgumentsBP)>
				<cfset rsMoneda = javacast("null","")>
				<cfset rsMaxIDE = javacast("null","")>
				<cfset rsEInventario = javacast("null","")>
			</cfif>
		</cfloop> <!--- Operacion ID --->
	<cfelse>
		<cfset varProc = false>
	</cfif>
	<cfif varProc>
		<cfreturn 1>
	<cfelse>
		<cfreturn 0>
	</cfif>
</cffunction>
<cffunction name="getEncabezado" access="private" output="false">
	<cfargument name="DataSource" type="string" required="True"  default="" />
	<cfargument name="Emp_Id" 	  type="string" required="true"  default=""/>
	<cfargument name="Suc_Id"     type="string" required="false" default=0 />
	<cfargument name="FechaIni"   type="date" 	required="false" default=0 />
	<cfargument name="FechaFin"   type="date" 	required="false" default=0 />
	<cfquery name="rsEncabezado" datasource="#Arguments.DataSource#">
				<!--- AJUSTES DE INVENTARIO --->
				SELECT	s.Cadena_Id, m.Suc_Id, m.Emp_Id, Mov_Id, convert(varchar(2),m.Tipo_Id) as Tipo_Mov, Mov_Fecha_Aplicado as Fecha_Movimiento,
						Mov_Comentario, Bodega_Id, Bodega_Id as Bodega_Destino,
						case t.Tipo_Tipo_Movimiento
							when 0 then 'E'
							when 1 then 'S'
							else 'E'
						end  as Tipo_Ajuste,
						m.Suc_Id as Suc_Destino, 'AJ' as Movimiento,
						0 SubPedido_Id
				FROM	Mov_Inventario_Encabezado m with(NOLOCK)
					INNER JOIN Tipo_Mov_Inventario t with(NOLOCK)
					ON  m.Tipo_Id = t.Tipo_Id AND t.Emp_Id = m.Emp_Id
					AND t.Tipo_Tipo_Movimiento <> 2  <!--- Todos los Ajustes de Inventario --->
					INNER JOIN Sucursal s
						ON m.Emp_Id = s.Emp_Id AND m.Suc_Id = s.Suc_Id
				WHERE m.Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Emp_Id#">
					AND m.Suc_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Suc_Id#">
					AND m.Mov_Fecha_Aplicado between
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaIni#">
						AND
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaFin + 1#">
					AND Mov_Estado LIKE 'AP'
				UNION
				<!--- MOVIMIENTOS INTERALMACEN --->
				SELECT	s.Cadena_Id, m.Suc_Id, m.Emp_Id, Mov_Id, 'TR' as Tipo_Mov, Mov_Fecha_Aplicado as Fecha_Movimiento,
						Mov_Comentario, Bodega_Id, Bodega_Destino, 'S' as Tipo_Ajuste, Suc_Destino, 'IA' as Movimiento,
						0 SubPedido_Id
				FROM	Mov_Inventario_Encabezado m WITH(NOLOCK)
						INNER JOIN Tipo_Mov_Inventario t WITH(NOLOCK)
						ON  m.Tipo_Id = t.Tipo_Id AND t.Emp_id = m.Emp_id
						AND t.Tipo_Tipo_Movimiento = 2 <!--- Movimiento Inter-Almacen Despacho --->
						INNER JOIN Sucursal s
						ON m.Emp_Id = s.Emp_Id AND m.Suc_Id = s.Suc_Id
				WHERE m.Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Emp_Id#">
					AND m.Suc_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Suc_Id#">
					AND mov_fecha_aplicado between
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaIni#">
						AND
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaFin + 1#">
					AND Mov_Estado like 'AP'
				UNION
				SELECT	s.Cadena_Id, m.Suc_Id, m.Emp_Id, Mov_Id, 'TR' as Tipo_Mov, Mov_Fecha_Recibido as Fecha_Movimiento,
						Mov_Comentario, Bodega_Id, Bodega_Destino,
						CASE
							WHEN convert(varchar(10),m.mov_fecha_aplicado,101) = convert(varchar(10),mov_fecha_recibido,101) THEN 'ES'
							ELSE 'E'
						END  as tipo_ajuste, Suc_Destino, 'IA' as Movimiento,
						0 SubPedido_Id
				FROM	Mov_Inventario_Encabezado m with(NOLOCK)
						INNER JOIN Tipo_Mov_Inventario t with(NOLOCK)
						ON m.Tipo_Id = t.Tipo_Id AND t.Emp_Id = m.Emp_Id
						AND t.Tipo_Tipo_Movimiento = 2 <!--- Movimiento Inter-Almacen Recepción --->
						INNER JOIN Sucursal s
						ON m.Emp_Id = s.Emp_Id AND m.Suc_Id = s.Suc_Id
				WHERE m.Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Emp_Id#">
					AND m.Suc_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Suc_Id#">
					AND Mov_Fecha_Recibido between
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaIni#">
							AND
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaFin + 1#">
					AND Mov_Estado LIKE 'RE'
				UNION
				<!--- DESPACHO CEDI	--->
				<!--- Los Despachos de CEDI se obitenen por el cierre del CEDI, el Despacho contiene,
				la sucursal destino --->
				SELECT	s.Cadena_Id, CEDI_Id as Suc_Id, m.Emp_Id, Pedido_Id as Mov_Id,'DC' as Tipo_Mov,
						Desp_Fecha_Aplicado as Fecha_Movimiento,
						Desp_Comentario as Mov_Comentario, 0 as Bodega_Id, 0 as Bodega_Destino, 'S' as Tipo_Ajuste,
						m.Suc_Id as Suc_Destino, 'DC' as Movimiento,
						m.SubPedido_Id
				FROM	Inv_Despacho_Encabezado m with(NOLOCK)
						INNER JOIN Sucursal s
						ON m.Emp_Id = s.Emp_Id AND m.Suc_Id = s.Suc_Id
				WHERE 	m.Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Emp_Id#">
					AND CEDI_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Suc_Id#">
					AND Desp_Fecha_Recibido between
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaIni#">
							AND
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaFin + 1#">
					<!--- AND desp_estado = 'RE' --->
				UNION
				<!--- RECEPCION DE ENVIO DESDE CEDI --->
				<!--- La Recepcion de CEDI se obitenen por el cierre de la Sucursal, la recepcion contiene,
				el CEDI origen --->
				SELECT 	s.Cadena_Id, CEDI_Id as Suc_Id, m.Emp_Id, Boleta_Id as Mov_Id, 'RC' Tipo_Mov, Boleta_Fecha_Aplica as Fecha_Movimiento,
						'Recepcion CEDI' as Mov_Comentario, 0 as Bodega_Origen, Bodega_Id as Bodega_Destino,
						'E' as Tipo_Ajuste,
						m.Suc_Id as Suc_Destino, 'RC' as Movimiento,
						0 SubPedido_Id
				FROM 	Boleta_Cedi_Encabezado_Hist m with(NOLOCK)
						INNER JOIN Sucursal s
						ON m.Emp_Id = s.Emp_Id AND m.Suc_Id = s.Suc_Id
				WHERE 	m.Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Emp_Id#">
					AND m.Suc_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Suc_Id#">
					AND Boleta_Fecha_Aplica between
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaIni#">
							AND
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaFin + 1#">
					<!--- AND Boleta_Estado = 'AP' --->
			</cfquery>
	<cfreturn rsEncabezado>
</cffunction>
<cffunction name="getDetalle" access="private" output="false">
	<cfargument name="DataSource"  	  type="string"  required="True"  default="" />
	<cfargument name="Movimiento"  	  type="string"  required="true"  default="" />
	<cfargument name="Emp_Id" 	   	  type="string"  required="true"  default="CERR" hint="CERR, ABIE, etc. (case sensitive)"/>
	<cfargument name="Suc_Id"      	  type="string"  required="false" default=0 />
	<cfargument name="Suc_Destino" 	  type="string"  required="false" default=0 />
	<cfargument name="Bodega_Id"   	  type="numeric" required="false" default=0 />
	<cfargument name="Bodega_Destino" type="numeric" required="false" default=0 />
	<cfargument name="Mov_Id" 	      type="numeric" required="false" default=0 />
	<cfargument name="SubPedido_Id" 	      type="numeric" required="false" default=0 />
		<cfquery name="rsDetalle" datasource="#DataSource#">
			<!--- AJUSTES DE INVENTARIO --->
			<cfif Arguments.Movimiento EQ "AJ" OR Arguments.Movimiento EQ "IA">
				SELECT 	Mov_Id, a.Depto_Id,0 as Tipo_Articulo_Id,0 as Casa_Id, 1 as Cantidad,
						sum(Detalle_Cantidad * Detalle_Costo_Unitario) as Costo, isnull(i.Impuesto_Id,0) as Impuesto_Id
				FROM 	Mov_Inventario_Detalle d with(NOLOCK)
					INNER JOIN Articulo a with(NOLOCK)
					ON 	d.Articulo_Id = a.Articulo_Id AND a.Emp_id = d.Emp_Id
					LEFT JOIN Impuesto_Articulo i with(NOLOCK)
					ON d.Articulo_Id = i.Articulo_Id AND i.Emp_id = d.Emp_Id and i.Impuesto_Id < 3
				WHERE 	d.Emp_Id 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Emp_Id#">
					AND d.Suc_Id 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Suc_Id#">
					AND d.Bodega_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Bodega_Id#">
					AND d.Mov_id    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mov_Id#">
				GROUP BY d.Emp_Id,d.Suc_Id,d.Bodega_Id,d.Mov_Id, a.Depto_Id, i.Impuesto_Id
			<!--- DESPACHO CEDI --->
			<cfelseif Arguments.Movimiento EQ "DC">
				SELECT d.Pedido_Id AS Mov_Id,
				       a.Depto_Id,
				       0 AS Tipo_Articulo_Id,
				       0 AS Casa_Id,
				       1 AS Cantidad,
				       SUM(Detalle_Cantidad_Auditada * Detalle_Costo_Neto_Desp) AS Costo,
				       ISNULL(i.Impuesto_Id, 0) AS Impuesto_Id
				FROM Inv_Despacho_Detalle d
				INNER JOIN Inv_Despacho_Encabezado e ON d.Suc_id = e.Suc_id
				AND d.Pedido_id = e.Pedido_Id
				AND d.SubPedido_Id = e.SubPedido_Id
				AND e.Desp_Estado = 'RE'
				INNER JOIN Articulo a ON d.Articulo_Id = a.Articulo_Id
				AND a.Emp_Id = d.Emp_Id
				LEFT JOIN Impuesto_Articulo i ON d.Articulo_Id = i.Articulo_Id
				AND i.Emp_id = d.Emp_Id
				AND i.Impuesto_Id < 3
				WHERE d.Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Emp_Id#">
				  AND d.CEDI_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Suc_Id#">
				  AND d.Suc_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Suc_Destino#">
				  AND d.Pedido_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mov_Id#">
				  AND d.SubPedido_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SubPedido_Id#">
				GROUP BY d.Emp_Id,
				         d.Suc_Id,
				         d.Pedido_Id,
				         a.Depto_Id,
				         i.Impuesto_Id
			<!--- RECEPCION CEDI --->
			<cfelseif Arguments.Movimiento EQ "RC">
				SELECT 	Boleta_Id as Mov_Id, a.Depto_Id,0 as Tipo_Articulo_Id,0 as Casa_Id, 1 as Cantidad,
						sum(Detalle_Cantidad * Detalle_Costo_Neto) as Costo, isnull(i.Impuesto_Id,0) as Impuesto_Id
				FROM 	Boleta_CEDI_Detalle_Hist d with(NOLOCK)
					INNER JOIN Articulo a with(NOLOCK)
					ON 	d.Articulo_Id = a.Articulo_Id AND a.Emp_Id = d.Emp_Id
					LEFT JOIN Impuesto_Articulo i with(NOLOCK)
					ON d.Articulo_Id = i.Articulo_Id AND i.Emp_id = d.Emp_Id and i.Impuesto_Id < 3
				WHERE 	d.Emp_Id    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Emp_Id#">
					AND d.Suc_Id    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Suc_Destino#">
					AND d.Bodega_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Bodega_Destino#">
					AND Boleta_id   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mov_Id#">
				GROUP BY d.Emp_Id, d.Suc_Id, d.Bodega_Id, Boleta_Id, a.Depto_Id, i.Impuesto_Id
			</cfif>
		</cfquery>
	<cfreturn rsDetalle>
</cffunction>
</cfcomponent>