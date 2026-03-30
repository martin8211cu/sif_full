<!--- ABG: Extraccion de Compras Interfaz LD-SIF Ver. 1.0 --->
<!--- La Interfaz LD-SIF solo funciona con versiones de Coldfusion 8.0 en adelante --->
<cfcomponent extends="ModuloIntegracion.Componentes.Interfaz_base" output="no">
<cffunction name="Ejecuta" access="public" returntype="string" output="no">

	<!---Invocar al GC para liberar memoria---> <!---ABG--->
	<cfset javaRT = createobject("java","java.lang.Runtime").getRuntime()>
    <cfset javaRT.gc()><!--- invoca el GC --->

	<cfset LvarLinkServ = false>
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

	<!--- Inserta Operacion ID a Bitacora para Compras --->
    <!--- Obtiene los cierres de Sucursal del Dia en que se procesa la Rutina --->
    <cfquery datasource="ldcom">
        insert into SIFLD_Bitacora_Proceso 
            (Sistema, Emp_Id, Cadena_Id, Suc_Id, Operacion_Id, Proceso, Fecha_Proceso, 
             Operacion_Fecha_Apertura, Operacion_Fecha_Cierre, Estatus)
		select 'LD', o.Emp_Id, s.Cadena_Id, o.Suc_Id,o.Operacion_Id, 'COMPRAS',
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
						and bp.Proceso like 'COMPRAS')
	</cfquery>
	
    <cfquery datasource="ldcom" result="Rupdate">
    	update top (50) SIFLD_Bitacora_Proceso
        set Estatus = 10
        where Proceso like 'COMPRAS'
        and Estatus = 1
        and not exists (select 1 
						from SIFLD_Bitacora_Proceso with(NOLOCK)
						where Proceso like 'COMPRAS'
                        and Estatus = 10)
    </cfquery>
    
    <!--- Obtiene los cierres de Sucursal del Dia en que se procesa la Rutina --->
	<cfquery datasource="ldcom" name="rsOperacionID">
		select Emp_Id, Cadena_Id, Suc_Id, Operacion_Id, 
        Operacion_Fecha_Apertura, Operacion_Fecha_Cierre
		from SIFLD_Bitacora_Proceso with(NOLOCK)
		where Estatus = 10
        and Proceso like 'COMPRAS'
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
				where Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#">
				and Moneda_Local = 1
			</cfquery>
			<cfif rsMoneda.recordcount EQ 0>
				<cfthrow message="Error al extraer la moneda Local">
			</cfif>
			<!--- Extrae los encabezados para las Compras y Devoluciones que pertenecen a las operaciones Cerradas al momento de la ejecucion --->
            <!--- Se modifica la extraccion bajo las condiciones dadas por EAjoy
				Factura_Total>0
				Select * from INV_Entrada_Diferencia_Hist
				Where Factura_cantidad > 0
				[04:16:47 p.m.] Edwin Ajoy Sanchez: Select * from Inv_Dev_Proveedor_Encabezado
				Where Devolucion_Total > 0
			--->
			<cfquery name="rsECompras" datasource="ldcom">
				<!--- FACTURAS ---> 
				SELECT f.Suc_Id, convert(varchar,f.Factura_Id) as Factura_Id, f.Bodega_Id, f.Boleta_Id, 'FC' as Tipo_Doc,
					'C' as Tipo_Compra,  f.Factura_Fecha as Fecha_Compra, 
					f.Factura_Fecha_Vencimiento as Fecha_Arribo, p.Prov_CodigoExterno, pa.Agencia_CodigoDireccion,
					round(f.Factura_Subtotal - Factura_Descuento, 2) as Factura_Subtotal, 
					<!--- Descuentos en 0 --->
                    0 as Factura_Descuento,
                    <!--- round(f.Factura_Descuento,2) as Factura_Descuento, --->
					round(f.Factura_Impuesto,2) as Factura_impuesto, 
					round(f.Factura_Total,2) as Factura_Total 
				FROM Boleta_Local_Encabezado_Hist h With(Nolock)
                	inner join Boleta_Local_Fact_Enc f with(NOLOCK)
                		LEFT JOIN Proveedor p with(NOLOCK)
	                    on f.Emp_Id = p.Emp_Id and f.Prov_Id = p.Prov_Id
    	                LEFT JOIN Proveedor_Agencia pa with(NOLOCK)
        	            on f.Emp_Id = pa.Emp_Id and f.Prov_Id = pa.Prov_Id and f.Agencia_Id = pa.Agencia_Id
                    on  h.Emp_Id = f.Emp_Id and h.Suc_id = f.Suc_Id and h.Boleta_id = f.Boleta_id and h.Boleta_Estado = 'AP'
				WHERE f.Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#">
					  and f.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_Id#"> 
					  and f.Factura_Fecha between
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Apertura#">
						and
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Cierre#">
                      and (f.Factura_Total > 0 or (f.Factura_Total = 0 and f.Factura_Id != '0'))
				UNION
				<!---DEVOLUCIONES DE PROVEEDOR --->
				SELECT f.Suc_Id, convert(varchar,f.Devolucion_Id) as Factura_Id, f.Bodega_Id, f.Boleta_Id, 'NC' as Tipo_Doc, 
					'D' as Tipo_Compra, f.Devolucion_Fecha, f.Devolucion_Fecha_Aplica as Fecha_Arribo, 
                    p.Prov_CodigoExterno, null as Agencia_CodigoDireccion,
					round((f.Devolucion_Subtotal_Exento + f.Devolucion_Subtotal_Gravado),2) as Factura_Subtotal, 
					<!--- Descuentos en 0 --->
                    0 as Factura_Descuento,
                    <!--- Descuento --->
                    <!--- round((f.Devolucion_Desc_Exento + f.Devolucion_Desc_Gravado),2) as Factura_Descuento, --->
					round(f.Devolucion_Impuesto,2) as Factura_Impuesto, 
					round(f.Devolucion_Total,2) as Factura_Total
				FROM Inv_Dev_Proveedor_Encabezado f with(NOLOCK)
                	LEFT JOIN Proveedor p with(NOLOCK)
                    on f.Emp_Id = p.Emp_Id and f.Proveedor_Id = p.Prov_Id
				WHERE  f.Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#">
					  and f.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_Id#"> 
					  and f.Devolucion_Fecha_Aplica between
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Apertura#">
						and
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Cierre#">
					  and f.Devolucion_Estado = 'AP'
                      and (f.Devolucion_Total > 0 or (f.Devolucion_Total = 0 and f.Devolucion_Id != 0))
				UNION
				<!--- Notas de Credito Automaticas --->
				Select d.Suc_Id, d.Factura_Numero as Factura_Id, d.Bodega_Id, d.Boleta_Id, 
					'NC' as Tipo_Doc,'A' as Tipo_Compra, f.Factura_Fecha as Fecha_Compra, 
					f.Factura_Fecha_Vencimiento as Fecha_Arribo, p.Prov_CodigoExterno, pa.Agencia_CodigoDireccion, 
					abs(round(sum((d.Detalle_Nota * d.Factura_Costo_Neto) +  d.Detalle_Dif_Costo),2)) as Factura_Subtotal,
					0 as Factura_Descuento,
					0 as Factura_Impuesto,
					abs(round(sum((d.Detalle_Nota * d.Factura_Costo_Neto) +  d.Detalle_Dif_Costo),2)) as Factura_Total
				from  INV_Entrada_Diferencia_Hist d with(NOLOCK)
					inner join Boleta_Local_Fact_Enc f with(NOLOCK)
                    	LEFT JOIN Proveedor p with(NOLOCK)
                    	on f.Emp_Id = p.Emp_Id and f.Prov_Id = p.Prov_Id
                        LEFT JOIN Proveedor_Agencia pa with(NOLOCK)
                    	on f.Emp_Id = pa.Emp_Id and f.Prov_Id = pa.Prov_Id and f.Agencia_Id = pa.Agencia_Id
					on d.Emp_Id = f.Emp_Id and d.Suc_Id = f.Suc_Id and d.Bodega_Id = f.Bodega_Id 
					and d.Boleta_Id = f.Boleta_Id and d.Prov_Id = f.Prov_Id 
					and d.Factura_Numero = f.Factura_Id
				where d.Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#">
				and d.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_Id#"> 
				and f.Factura_Fecha between
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Apertura#">
						and
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Cierre#">
				and((d.Detalle_Nota > 0 and d.Factura_Costo_Neto > 0) or d.Detalle_Dif_Costo > 0)
                and Factura_Cantidad > 0
				group by d.Emp_Id,d.Suc_Id, d.Bodega_Id, d.Boleta_Id, d.Prov_Id, p.Prov_CodigoExterno, pa.Agencia_ID,
                	pa.Agencia_CodigoDireccion, d.Factura_Numero, f.Factura_Fecha, f.Factura_Fecha_Vencimiento
			</cfquery>
			<!--- Recorremos los encabezados Insertandolos y extrayendo sus detalles de Pago y detalles de Venta --->
			<cfif isdefined("rsECompras") AND rsECompras.recordcount GT 0>
			<cfloop query="rsECompras">
            <cfsilent>
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
							Vendedor, Sucursal, Moneda, Tipo_Cambio, Direccion_Fact, Retencion, Observaciones, 
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
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Prov_CodigoExterno#">,
                        null,
						<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsECompras.Factura_Subtotal,"9.99")#">, 
						<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsECompras.Factura_Descuento,"9.99")#">, 
						<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsECompras.Factura_Impuesto,"9.99")#">, 
						<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsECompras.Factura_Total,"9.99")#">,
						0, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOperacionID.Suc_Id#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMoneda.Moneda_Id#">,
						1,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Agencia_CodigoDireccion#">,
						'',
						'', 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Bodega_Id#">,
						15)
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
							<!--- Descuentos en 0 --->
                            0 as Descuento,
                            0 as Descuento_Det,
                            <!---isnull(round(sum(Detalle_Cantidad * Detalle_Descuento),2),0) as Descuento, --->
                            <!---isnull(sum(dsc.Detalle_Monto * Detalle_Cantidad),0) as Descuento_Det,--->
							isnull(round(sum(Detalle_Cantidad * isnull(i.Detalle_Impuesto_Monto,0)),2),0) as Impuesto, 
							round(isnull(sum(Detalle_Total),0),2) as Total,
							isnull(Impuesto_Id,0) as Cod_Impuesto,
							<!--- Descuento 0 Costo_Neto con descuento Costo_Bruto--->
                            round(isnull(sum(Detalle_Cantidad * Detalle_Costo_Neto),0),2) as Precio_Unitario, 
							round(isnull(sum(Detalle_Cantidad * Detalle_Costo_Neto),0),2) as Subtotal
						from Boleta_Local_Fact_Det fd with(NOLOCK)
							inner join Articulo a with(NOLOCK)
							on fd.Articulo_Id = a.Articulo_Id and fd.Emp_Id = a.Emp_Id
							left join Boleta_Local_Fact_Det_Imp i with(NOLOCK)
							on i.Emp_Id = fd.Emp_Id and i.Suc_Id = fd.Suc_Id and i.Bodega_Id = fd.Bodega_Id 
							and fd.Boleta_Id = i.Boleta_Id and fd.Factura_Id = i.Factura_Id and fd.Articulo_Id = i.Articulo_Id
                            <!---left join Boleta_Local_Fact_Det_Desc dsc 
                            on dsc.Emp_Id = fd.Emp_Id and dsc.Suc_Id = fd.Suc_Id and dsc.Bodega_Id = fd.Bodega_Id 
                            and fd.Boleta_Id = dsc.Boleta_Id and fd.Factura_Id = dsc.Factura_Id and fd.Detalle_Id = dsc.Detalle_Id --->
						where fd.Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#">
							and fd.suc_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_Id#"> 
							and fd.factura_Id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Factura_Id#">  
							and fd.bodega_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsECompras.Bodega_Id#"> 
							and fd.boleta_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsECompras.Boleta_Id#">
						group by fd.factura_id, a.depto_id, isnull(impuesto_id,0)
					<!---Para Devoluciones--->
					<cfelseif rsECompras.Tipo_Compra EQ "D">
						select fd.Devolucion_Id as Factura_Id, a.Depto_Id,0 as Tipo_Articulo_Id,0 as Casa_Id, 1 as Cantidad,
							<!--- Descuentos en 0 --->
                            0 as Descuento,
                            <!---round(isnull(sum(fd.Detalle_Cantidad * Detalle_Descuento),0),2)  as Descuento,--->
							isnull( round(sum(fd.Detalle_Cantidad * isnull(i.Detalle_Impuesto_Monto,0)),2),0) as Impuesto, 
							round(sum(Detalle_Total),2) as Total, 
							isnull(Impuesto_Id,0) as Cod_Impuesto,
							<!--- Descuento 0 Costo_Neto con descuento Costo_Bruto--->
                            round(isnull(sum(fd.Detalle_Cantidad * Detalle_Costo_Neto),0),2) as Precio_Unitario, 
							round(isnull(sum(fd.Detalle_Cantidad * Detalle_Costo_Neto),0),2) as Subtotal
						from Inv_Dev_Proveedor_Detalle fd with(NOLOCK)
							inner join Articulo a with(NOLOCK)
							on fd.Articulo_Id = a.Articulo_Id
							left join inv_dev_proveedor_detalle_imp i with(NOLOCK)
							on fd.Emp_Id = i.Emp_Id and fd.Suc_Id = i.Suc_Id and fd.Bodega_Id = i.Bodega_Id
							and fd.Devolucion_Id = i.Devolucion_Id and fd.Articulo_Id = i.Articulo_Id
						where fd.emp_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#"> 
							and fd.suc_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_Id#">
							and fd.bodega_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsECompras.Bodega_Id#">
							and fd.Devolucion_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Factura_Id#"> 
						group by fd.Devolucion_id, a.depto_id, isnull(impuesto_id,0)
						<!--- Para Notas Automaticas --->
					<cfelseif rsECompras.Tipo_Compra EQ "A">
						Select d.Factura_Numero as Factura_Id, isnull(a.Depto_Id,0) as Depto_Id, 
                        	0 as Tipo_Articulo_Id, 0 as Casa_Id,
							1 as Cantidad, 0 as Descuento, 0 as Impuesto, 
							abs(round(sum((d.Detalle_Nota * d.Factura_Costo_Neto) +  d.Detalle_Dif_Costo),2)) as Total, 
							'0' as Cod_Impuesto,
							abs(round(sum((d.Detalle_Nota * d.Factura_Costo_Neto) +  d.Detalle_Dif_Costo),2)) as Precio_Unitario, 	
							abs(round(sum((d.Detalle_Nota * d.Factura_Costo_Neto) +  d.Detalle_Dif_Costo),2)) as Subtotal
						from  INV_Entrada_Diferencia_Hist d with(NOLOCK)
							left join Articulo a with(NOLOCK)
							on d.Articulo_Id = a.Articulo_Id and d.Emp_Id = a.Emp_Id
						where d.Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#"> 
							and d.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_Id#">
							and d.Bodega_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsECompras.Bodega_Id#">
							and d.Factura_Numero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsECompras.Factura_Id#"> 
							and d.Boleta_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsECompras.Boleta_Id#">
							and((d.Detalle_Nota > 0 and d.Factura_Costo_Neto > 0) or d.Detalle_Dif_Costo > 0)
						group by d.Factura_Numero, a.Depto_Id	
					</cfif>
				</cfquery>
				<cfset IDlinea = 1>
				<cfif isdefined("rsDCompras") and rsDCompras.recordcount GT 0>
				<cfloop query="rsDCompras">
                <cfsilent>
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
							 <cfif rsECompras.Tipo_Compra EQ "C">
                             	<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDCompras.Descuento + rsDCompras.Descuento_Det,"9.99")#">,
                             <cfelse>
                             	<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDCompras.Descuento,"9.99")#">,
                             </cfif>
							 0,
                             <cfif rsECompras.Tipo_Compra EQ "C">
							 	abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDCompras.Total - rsDCompras.impuesto + rsDCompras.Descuento + rsDCompras.Descuento_Det,'9.99')#">),
                             <cfelse>
                             	abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDCompras.Total - rsDCompras.impuesto + rsDCompras.Descuento,'9.99')#">),
                             </cfif>
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
                </cfsilent>
				</cfloop> <!---Detalles Compra--->
				</cfif>
                <cfset rsDCompras = javacast("null","")>
                <cfset javaRT.gc()><!--- invoca el GC --->
            </cfsilent>
			</cfloop> <!--- Encabezados Compra--->
			</cfif> 
            
            <cfquery datasource="sifinterfaces">
                update ESIFLD_Facturas_Compra
                set Estatus = 1 
                where Estatus = 15
            </cfquery>
            
			<cfquery datasource="ldcom">
                update SIFLD_Bitacora_Proceso
                set Estatus = 2,
                Fecha_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                where Proceso like 'COMPRAS'
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
            <cfset rsECompras = javacast("null","")>
            <cfset javaRT.gc()><!--- invoca el GC --->
        <cfcatch type="any">
        	<cfquery datasource="sifinterfaces">
                delete DSIFLD_Facturas_Compra
                where ID_DocumentoC in 
                	(select ID_DocumentoC
                    from ESIFLD_Facturas_Compra
                	where Estatus = 15)
            </cfquery>
            <cfquery datasource="sifinterfaces">
                delete ESIFLD_Facturas_Compra
                where Estatus = 15
            </cfquery>
        	<cfquery datasource="ldcom">
                update SIFLD_Bitacora_Proceso
                set Estatus = 3,
                Fecha_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                where Proceso like 'COMPRAS'
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
				'No hay Cierres de Sucursal para el Dia de Hoy', 'COMPRAS', getdate())
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