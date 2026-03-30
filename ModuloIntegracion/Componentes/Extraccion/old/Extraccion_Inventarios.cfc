<!--- ABG: Extraccion de Inventario Interfaz LD-SIF Ver. 1.0 --->
<!--- La Interfaz LD-SIF solo funciona con versiones de Coldfusion 8.0 en adelante --->
<cfcomponent extends="ModuloIntegracion.Componentes.Interfaz_base" output="no">
<cffunction name="Ejecuta" access="public" returntype="string" output="no">
	
    <!---Invocar al GC para liberar memoria---> <!---ABG--->
	<cfset javaRT = createobject("java","java.lang.Runtime").getRuntime()>
    <cfset javaRT.gc()><!--- invoca el GC --->
    
	<cfset LvarLinkServ = false>
	<!--- Cambiar esta variable a true si se desea que se haga una poliza por cada movimiento de Inventario 
	Poner en false si se desea una sola poliza por sucursal, Operacion ID agrupando todos los retiros--->
	<cfset varDetallado = false>
	<!--- variables datasource --->
	<!--- Rutina para obtener el nombre del server del datasource ldcom --->
	<cfset Varfactory = CreateObject("java", "coldfusion.server.ServiceFactory")>
	<cfset Vards_service = Varfactory.datasourceservice>
	<cfset Vardatasources = Vards_service.getDatasources()>
	<cfloop collection="#Vardatasources#" item="i">
    <cfsilent>
		<cfset Varthisdatasource = Vardatasources[i]>
		<cfif Varthisdatasource.name EQ 'ldcom'>
			 <cfset Lvarserverldcom = trim(Varthisdatasource.urlmap.database)>
			 <cfset Lvarbdldcom = trim(Varthisdatasource.urlmap.database)>
		</cfif>
	</cfsilent>
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
    
    <cf_dbtemp name="CadEmp" returnvariable="CadEmp" datasource="sifinterfaces">
	    <cf_dbtempcol name="Cadena_Id" type="numeric">
        <cf_dbtempcol name="Ecodigo" type="numeric">
        <cf_dbtempcol name="cache" type="varchar(20)">
    </cf_dbtemp>
    
    <cf_dbtemp name="CadEmpLD" returnvariable="CadEmpLD" datasource="ldcom">
	    <cf_dbtempcol name="Cadena_Id" type="numeric">
        <cf_dbtempcol name="mes_Auxiliar" type="int">
    </cf_dbtemp>
    
	<!--- Obtiene las cadenas de LDCOM y empresas de SIF y el cache--->
    <cfquery name="rsCadena" datasource="ldcom">
    	select Cadena_Id from Cadena with(NOLOCK)
    </cfquery>
    
    <cfloop query="rsCadena">
    <cfsilent>
    	<cfquery datasource="sifinterfaces">
        	insert into #CadEmp# (Cadena_Id,Ecodigo,cache)
            select <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCadena.Cadena_Id#">,
            	EQUidSIF, c.Ccache 
            from SIFLD_Equivalencia a 
				inner join asp..Empresa b on b.Ereferencia = a.EQUidSIF
				inner join asp..Caches c on b.Cid = c.Cid
            where EQUempOrigen = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCadena.Cadena_Id#">
            and CATcodigo like 'CADENA' 
            and SIScodigo like 'LD'
        </cfquery>
    </cfsilent>
    </cfloop>
    
    <!--- Obtiene el mes de auxiliares --->
    <cfquery name="rsCadEmp" datasource="sifinterfaces">
    	select * from #CadEmp#
    </cfquery>
    <cfloop query="rsCadEmp">
    <cfsilent>
    	<cfquery name="rsAux" datasource="#rsCadEmp.cache#">
			select Pvalor 
            from Parametros
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCadEmp.Ecodigo#">
            and Pcodigo = 60
        </cfquery>
        <cfif rsAux.recordcount GT 0>
            <cfquery datasource="ldcom">
                insert into #CadEmpLD# (Cadena_Id, mes_Auxiliar)
                values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCadEmp.Cadena_Id#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAux.Pvalor#">)
            </cfquery>
        </cfif>
    </cfsilent>
    </cfloop>
    	
	<!--- Obtiene los parametros de Fecha Extraccion --->	
    <cfif not isdefined("fechaini") and not isdefined("fechafin")>
    <cftry>
        <cfset FecIni = Parametros(Ecodigo=2,Pcodigo=16,Parametro="Fecha Inicio Extraccion",ExtBusqueda=false, Sistema = 'LD')>
        <cfset FecFin = Parametros(Ecodigo=2,Pcodigo=17,Parametro="Fecha Fin Extraccion",ExtBusqueda=false, Sistema = 'LD')>
        <cfset fechaini = createdate(right(FecIni,4),mid(FecIni,4,2),left(FecIni,2))>
		<cfset fechafin = createdate(right(FecFin,4),mid(FecFin,4,2),left(FecFin,2))>
    <cfcatch>
    </cfcatch>
    </cftry>
    </cfif>

	<!--- Inserta Operacion ID a Bitacora para Inventarios --->
    <!--- Obtiene los cierres de Sucursal del Dia en que se procesa la Rutina --->
    <cfquery datasource="ldcom">
        insert into SIFLD_Bitacora_Proceso 
            (Sistema, Emp_Id, Cadena_Id, Suc_Id, Operacion_Id, Proceso, Fecha_Proceso, 
             Operacion_Fecha_Apertura, Operacion_Fecha_Cierre, Estatus)
		select 'LD', o.Emp_Id, s.Cadena_Id, o.Suc_Id,o.Operacion_Id, 'INVENTARIOS',
        	getdate(), o.Operacion_Fecha_Apertura, o.Operacion_Fecha_Cierre, 1
		from Sucursal_Operacion o with(NOLOCK)
			inner join Sucursal s with(NOLOCK)
			on o.Emp_Id = s.Emp_Id and o.Suc_Id = s.Suc_Id and s.Zona_Id = 2
            inner join #CadEmpLD# z
            on s.Cadena_Id = z.Cadena_Id and month(o.Operacion_Fecha_Apertura) = isnull(z.mes_Auxiliar,0)
		where Operacion_Estado like 'CERR'
        and Operacion_Sincronizada = 1 <!--- Se agrega validacion nueva de Sincronizacion --->
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
						from SIFLD_Bitacora_Proceso bp with(NOLOCK)
						where o.Emp_Id = bp.Emp_Id 
						and o.Suc_Id = bp.Suc_Id
						and o.Operacion_Id = bp.Operacion_Id
                        and o.Operacion_Fecha_Apertura = bp.Operacion_Fecha_Apertura
                        and o.Operacion_Fecha_Cierre = bp.Operacion_Fecha_Cierre
						and bp.Proceso like 'INVENTARIOS')
	</cfquery>
	
    <cfquery datasource="ldcom" result="Rupdate">
    	update top (50) SIFLD_Bitacora_Proceso
        set Estatus = 10
        where Proceso like 'INVENTARIOS'
        and Estatus = 1
        and not exists (select 1 
						from SIFLD_Bitacora_Proceso with(NOLOCK)
						where Proceso like 'INVENTARIOS'
                        and Estatus = 10)
    </cfquery>
    
    <!--- Obtiene los cierres de Sucursal del Dia en que se procesa la Rutina --->
	<cfquery datasource="ldcom" name="rsOperacionID">
		select Emp_Id, Cadena_Id, Suc_Id, Operacion_Id, 
        Operacion_Fecha_Apertura, Operacion_Fecha_Cierre
		from SIFLD_Bitacora_Proceso with(NOLOCK)
		where Estatus = 10
        and Proceso like 'INVENTARIOS'
        <cfif Rupdate.recordcount EQ 0>
            and 1 = 2
        </cfif>
	</cfquery>	
	
	<cfif isdefined("rsOperacionID") and rsOperacionID.recordcount GT 0>
		<cfloop query="rsOperacionID">
        <cfsilent>
		<cftry>
			<!--- Obtiene la Moneda Local --->
			<cfquery name="rsMoneda" datasource="ldcom">
				select Moneda_Id 
				from Moneda with(NOLOCK)
				where Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Emp_Id#">
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
				from Mov_Inventario_Encabezado m with(NOLOCK)
					inner join Tipo_Mov_Inventario t with(NOLOCK)
					on  m.Tipo_Id = t.Tipo_Id and t.Emp_Id = m.Emp_Id
					and t.Tipo_Tipo_Movimiento <> 2 <!--- Todos los Ajustes de Inventario --->
				where m.Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Emp_Id#">
				and m.Suc_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Suc_Id#">
				and m.Mov_Fecha_Aplicado between
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Apertura#">
						and
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Cierre#">
				and Mov_Estado like 'AP'
				UNION
				<!--- MOVIMIENTOS INTERALMACEN --->
				select Suc_Id, Mov_Id, 'TR' as Tipo_Mov, Mov_Fecha_Aplicado as Fecha_Movimiento, 
					Mov_Comentario, Bodega_Id, Bodega_Destino, 'S' as Tipo_Ajuste, Suc_Destino, 'IA' as Movimiento
				from Mov_Inventario_Encabezado m with(NOLOCK)
					inner join Tipo_Mov_Inventario t with(NOLOCK)
					on  m.Tipo_Id = t.Tipo_Id and t.Emp_id = m.Emp_id
					and t.Tipo_Tipo_Movimiento = 2 <!--- Movimiento Inter-Almacen Despacho --->
				where m.Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Emp_Id#">
				and m.Suc_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Suc_Id#">
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
				from Mov_Inventario_Encabezado m with(NOLOCK)
					inner join Tipo_Mov_Inventario t with(NOLOCK)
					on  m.Tipo_Id = t.Tipo_Id and t.Emp_Id = m.Emp_Id
					   and t.Tipo_Tipo_Movimiento = 2 <!--- Movimiento Inter-Almacen Recepción --->
				where m.Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Emp_Id#">
					and m.Suc_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Suc_Id#">
					and Mov_Fecha_Recibido between
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Apertura#">
							and
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Cierre#">
					and Mov_Estado like 'RE'
			
				UNION
				<!--- DESPACHO CEDI	--->
				<!--- Los Despachos de CEDI se obitenen por el cierre del CEDI, el Despacho contiene,
				la sucursal destino --->
				select CEDI_Id as Suc_Id, Pedido_Id as Mov_Id,'DC' as Tipo_Mov, 
                Desp_Fecha_Aplicado as Fecha_Movimiento,
				Desp_Comentario as Mov_Comentario, Bodega_Id,0 as Bodega_Destino, 'S' as Tipo_Ajuste,
				Suc_Id as Suc_Destino, 'DC' as Movimiento		
				from Inv_Despacho_Encabezado with(NOLOCK)
				where Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Emp_Id#">
					and CEDI_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Suc_Id#">
					and Desp_Fecha_Aplicado between
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Apertura#">
							and
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Cierre#">
					and desp_estado = 'RE'
				
				UNION
				<!--- RECEPCION CEDI --->
                <!--- La Recepcion de CEDI se obitenen por el cierre de la Sucursal, la recepcion contiene,
				el CEDI origen --->
				select CEDI_Id as Suc_Id, Boleta_Id as Mov_Id, 'RC' Tipo_Mov, Boleta_Fecha_Aplica as Fecha_Movimiento,
				'Recepcion CEDI' as Mov_Comentario, 0 as Bodega_Origen, Bodega_Id as Bodega_Destino, 
                'E' as Tipo_Ajuste, 
				Suc_Id as Suc_Destino, 'RC' as Movimiento
				from Boleta_Cedi_Encabezado_Hist with(NOLOCK)
				where Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Emp_Id#">
					and Suc_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Suc_Id#">
					and Boleta_Fecha_Aplica between
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Apertura#">
							and
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Cierre#">
					and Boleta_Estado = 'AP'
			</cfquery>
			<!--- Recorremos los encabezados Insertandolos y extrayendo sus detalles de Pago y detalles de Venta --->
			<cfif isdefined("rsEInventario") AND rsEInventario.recordcount GT 0>
			<cfloop query="rsEInventario">
            <cfsilent>
				<!--- ID para la tabla de Encabezados --->
				<cfquery name="rsMaxIDE" datasource="sifinterfaces">
					select isnull(max(ID_Movimiento),0) + 1 as MaxID
					from ESIFLD_Movimientos_Inventario
				</cfquery> 
	
				<!--- Crea el numero de Documento --->
				<cfif varDetallado>
					<cfset Num_Doc = rsEInventario.Movimiento & numberformat(rsOperacionID.Emp_Id,"00") & "-" & numberformat(rsOperacionID.Suc_Id,"0000") & numberformat(rsEInventario.Bodega_Id,"00") & "-" & numberformat(rsEInventario.Mov_Id,"00000000")>
                    <cfset Desc_Doc = rsEInventario.Mov_Comentario>
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
                            <cfset Desc_Doc = "Despacho CEDI">
                        </cfcase>
                        <cfcase value="RC">
                            <cfset Desc_Doc = "Recepción CEDI">
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
							(Ecodigo, Origen,Sucursal_Origen, ID_Movimiento, Tipo_Movimiento, Fecha_Movimiento,Documento,
							 Descripcion, Almacen_Origen, Almacen_Destino, tipo_ajuste, Sucursal_Destino, Estatus)
						Values 
						( 
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_id#">,
						 'LD',
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOperacionID.Suc_Id#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventario.Tipo_Mov#">,
						 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEInventario.Fecha_Movimiento,"short")#"> ,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Num_Doc#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Desc_Doc#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventario.Bodega_Id#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventario.Bodega_Destino#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventario.Tipo_Ajuste#">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventario.Suc_Destino#">,
						 15)
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
						from Mov_Inventario_Detalle d with(NOLOCK)
							inner join Articulo a with(NOLOCK)
							on d.Articulo_Id = a.Articulo_Id and a.Emp_id = d.Emp_Id
						where d.Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Emp_Id#">
							and d.Suc_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Suc_Id#">
							and d.Bodega_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEInventario.Bodega_Id#"> 
							and d.Mov_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEInventario.Mov_Id#"> 
						group by d.Emp_Id,d.Suc_Id,d.Bodega_Id,d.Mov_Id, a.Depto_Id
					<!--- DESPACHO CEDI --->
					<cfelseif rsEInventario.Movimiento EQ "DC">
						select Pedido_Id as Mov_Id, a.Depto_Id,0 as Tipo_Articulo_Id,0 as Casa_Id, 1  as Cantidad,
							sum(Detalle_Cantidad_Pedida * Detalle_Costo_Neto_Ped) as Costo
						from Inv_Despacho_Detalle d with(NOLOCK)
							inner join Articulo a with(NOLOCK)
							on d.Articulo_Id = a.Articulo_Id and a.Emp_Id = d.Emp_Id
						where d.Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Emp_Id#">
							and d.CEDI_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEInventario.Suc_Id#"> 
                            and d.Suc_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEInventario.Suc_Destino#">
							and d.Bodega_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEInventario.Bodega_Id#"> 
							and d.Pedido_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEInventario.Mov_Id#">
						group by d.Emp_Id, d.Suc_Id, d.Bodega_Id, Pedido_Id, a.Depto_Id
					<!--- RECEPCION CEDI --->
					<cfelseif rsEInventario.Movimiento EQ "RC">
						select Boleta_Id as Mov_Id, a.Depto_Id,0 as Tipo_Articulo_Id,0 as Casa_Id, 1 as Cantidad,
							sum(Detalle_Cantidad * Detalle_Costo_Neto) as Costo
						from Boleta_CEDI_Detalle_Hist d with(NOLOCK)
							inner join Articulo a with(NOLOCK)
							on d.Articulo_Id = a.Articulo_Id and a.Emp_Id = d.Emp_Id
						where d.Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Emp_Id#">
							and d.Suc_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEInventario.Suc_Destino#">
							and d.Bodega_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEInventario.Bodega_Destino#"> 
							and Boleta_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEInventario.Mov_Id#">
						group by d.Emp_Id, d.Suc_Id, d.Bodega_Id, Boleta_Id, a.Depto_Id
					</cfif>
				</cfquery>
				<cfset IDlinea = 1>
				<cfif isdefined("rsDInventario") and rsDInventario.recordcount GT 0>
				<cfloop query="rsDInventario">
                <cfsilent>
					<cftransaction action="begin">
					<cftry>
						<cfquery datasource="sifinterfaces">
							insert into DSIFLD_Movimientos_Inventario 
								(Ecodigo, ID_Movimiento, Id_Linea, Tipo_Item, Clas_Item,
								 Cod_Fabricante,Cod_Item, Cantidad, Costo)
							Values 
							(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_id#">, 
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">, 
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDlinea#">, 
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
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_id#">
								and ID_Movimiento =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">
							delete DSIFLD_Movimientos_Inventario
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_id#">
								and ID_Movimiento =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">
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
                </cfsilent>
				</cfloop> <!---Detalles Inventario--->
				</cfif>
                <cfset rsDInventario = javacast("null","")>
                <cfset javaRT.gc()><!--- invoca el GC --->
			</cfsilent>
            </cfloop> <!--- Encabezados Inventario--->
			</cfif> 
            
            <cfquery datasource="sifinterfaces">
                update ESIFLD_Movimientos_Inventario
                set Estatus = 1 
                where Estatus = 15
            </cfquery>
            
			<cfquery datasource="ldcom">
                update SIFLD_Bitacora_Proceso
                set Estatus = 2,
                Fecha_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                where Proceso like 'INVENTARIOS'
                and Estatus = 10
                and Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Emp_id#">
                and Cadena_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_id#">
                and Suc_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Suc_id#">
                and Operacion_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Operacion_id#">
                and Operacion_Fecha_Apertura = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Apertura#">
                and Operacion_Fecha_Cierre = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Cierre#">
            </cfquery>
            
            <cfset varProc = true>
            
            <cfset rsMoneda = javacast("null","")>
            <cfset rsMaxIDE = javacast("null","")>
            <cfset rsEInventario = javacast("null","")>
            <cfset javaRT.gc()><!--- invoca el GC --->
        <cfcatch type="any">
        	<cfquery datasource="sifinterfaces">
                delete DSIFLD_Movimientos_Inventario
                where ID_Movimiento in 
                	(select ID_Movimiento
                    from ESIFLD_Movimientos_Inventario
                	where Estatus = 15)
            </cfquery>
            <cfquery datasource="sifinterfaces">
                delete ESIFLD_Movimientos_Inventario
                where Estatus = 15
            </cfquery>
        	<cfquery datasource="ldcom">
                update SIFLD_Bitacora_Proceso
                set Estatus = 3,
                Fecha_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                where Proceso like 'INVENTARIOS'
                and Estatus = 10
                and Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Emp_id#">
                and Cadena_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_id#">
                and Suc_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Suc_id#">
                and Operacion_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Operacion_id#">
                and Operacion_Fecha_Apertura = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Apertura#">
                and Operacion_Fecha_Cierre = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Cierre#">
            </cfquery>
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
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Emp_Id#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOperacionID.Suc_Id#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Operacion_Id#">,
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
            <cfset varProc = false>
		</cfcatch>
		</cftry>
        </cfsilent>
		</cfloop> <!--- Operacion ID --->
	<cfelse>
		<!--- Se Elimina este error ya que ahora no se ejecuta la tarea una vez al dia --->
		<!--- Inserta Log de Error --->
        <!---
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
		</cfquery> --->
        <cfset varProc = false>
	</cfif>
    <cfif varProc>
    	<cfreturn 1>
    <cfelse>
    	<cfreturn 0>
    </cfif>
</cffunction>
</cfcomponent>