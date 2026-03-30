<!--- ABG: Extraccion de Ventas Interfaz LD-SIF Ver. 1.0 --->
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
            
	<!--- Inserta Operacion ID a Bitacora para Ventas --->
    <!--- Obtiene los cierres de Sucursal del Dia en que se procesa la Rutina --->
    <cfquery datasource="ldcom">
        insert into SIFLD_Bitacora_Proceso 
            (Sistema, Emp_Id, Cadena_Id, Suc_Id, Operacion_Id, Proceso, Fecha_Proceso, 
             Operacion_Fecha_Apertura, Operacion_Fecha_Cierre, Estatus)
		select 'LD', o.Emp_Id, s.Cadena_Id, o.Suc_Id,o.Operacion_Id, 'VENTAS',
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
		<cfelse>			= CONVERT(CHAR(8), <cfqueryparam cfsqltype="cf_sql_timestamp" value='#now()#'>, 112)
		</cfif>
		and not exists (select 1 
						from SIFLD_Bitacora_Proceso bp with(NOLOCK)
						where o.Emp_Id = bp.Emp_Id 
						and o.Suc_Id = bp.Suc_Id
						and o.Operacion_Id = bp.Operacion_Id
                        and o.Operacion_Fecha_Apertura = bp.Operacion_Fecha_Apertura
                        and o.Operacion_Fecha_Cierre = bp.Operacion_Fecha_Cierre
						and bp.Proceso like 'VENTAS')
	</cfquery>
	
    <cfquery datasource="ldcom" result="Rupdate">
    	update top (1) SIFLD_Bitacora_Proceso
        set Estatus = 10
        where Proceso like 'VENTAS'
        and Estatus = 1
        and not exists (select 1 
						from SIFLD_Bitacora_Proceso with(NOLOCK)
						where Proceso in ('VENTAS', 'BANCOS')
                        and Estatus = 10)
    </cfquery>
    
    <!--- Obtiene los cierres de Sucursal del Dia en que se procesa la Rutina --->
	<cfquery datasource="ldcom" name="rsOperacionID">
		select Emp_Id, Cadena_Id, Suc_Id, Operacion_Id, 
        Operacion_Fecha_Apertura, Operacion_Fecha_Cierre
		from SIFLD_Bitacora_Proceso with(NOLOCK)
		where Estatus = 10
        and Proceso like 'VENTAS'
        <cfif Rupdate.recordcount EQ 0>
            and 1 = 2
        </cfif>
	</cfquery>
    
	<cfif isdefined("rsOperacionID") and rsOperacionID.recordcount GT 0>
		<cfloop query="rsOperacionID">
        <cfsilent>
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
				from Moneda with(NOLOCK)
				where Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Emp_Id#">
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
				Factura_Fecha, c.Cliente_CodigoExterno,
				round(Factura_Subtotal,2) as Factura_Subtotal,
				round(Factura_Descuento,2) as Factura_Descuento, 
				round(Factura_Impuesto,2) as Factura_Impuesto,
				round(Factura_Total,2) as Factura_Total,
                round (Factura_Redondeo,2) as Factura_Redondeo,
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
					when fe.contacto_Id <= 0 then null 
					else fe.contacto_Id end Subcliente_Id,
				fe.Factura_Cambio_Efectivo <!--- Este Valor es para el manejo de los cambios en tipos de pago <> efectivo --->
				<!---INTO ##Temp_Datos--->
				FROM Factura_Encabezado fe with(NOLOCK)
					INNER JOIN sucursal s with(NOLOCK)
					ON fe.suc_Id = s.suc_Id  and s.emp_Id = fe.emp_Id
					LEFT JOIN  cliente  c with(NOLOCK)
					ON fe.cliente_Id = c.cliente_Id and fe.emp_Id = c.emp_Id
					LEFT JOIN Factura_Devolucion fd with(NOLOCK)
					ON fe.Emp_Id = fd.Emp_Id and fe.Suc_Id = fd.Suc_Id and fe.Caja_Id = fd.Caja_Id and fe.Factura_Id = fd.Devolucion_Id
				WHERE fe.Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Emp_Id#">
					and fe.Suc_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Suc_Id#">
					and fe.Operacion_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Operacion_Id#">
					and fe.Tipodoc_Id <> 2
			</cfquery>
            <cfquery name="rsEFormaPago" datasource="ldcom">
                SELECT fe.Emp_Id, fe.Suc_Id, fe.Caja_Id, fe.Factura_Id, fe.TipoDoc_Id,
                f.Tipo_Id, f.Moneda_Id, f.Tarjeta_Id, f.Pago_Total, f.Cupon_Id, 
                f.Pago_Total_Tipo_Cambio, 0 as Tarjeta_Porcentaje,
                case 
                    when f.Tipo_Id = 2 and f.Tarjeta_Id = 3 then 'AMEX'
                    when f.Tipo_Id = 3 then (select Cupon_Nombre
                                            from Cupon with(NOLOCK)
                                            where Emp_Id = f.Emp_Id
                                            and Cupon_Id = f.Cupon_Id)
                    else null end as SocioDoc
                FROM Factura_Forma_Pago f with(NOLOCK)
                INNER JOIN Factura_Encabezado fe with(NOLOCK)
                ON f.Emp_Id = fe.Emp_Id and f.Suc_Id = fe.Suc_Id and f.Caja_Id = fe.Caja_Id and f.Factura_Id = fe.Factura_Id
                WHERE fe.Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Emp_Id#">
					and fe.Suc_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Suc_Id#">
					and fe.Operacion_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Operacion_Id#">
					and fe.Tipodoc_Id <> 2
            </cfquery>
            <cfquery name="rsEDVentas" datasource="ldcom">
                select distinct fd.Emp_Id, fd.Suc_Id, fd.Caja_Id,fd.Factura_Id, 0 as Tipo_Articulo_Id,
                  a.Depto_Id, 0 as Casa_Id, 1 as Cantidad, 
                   round(isnull(sum(Detalle_Cantidad * Detalle_Impuesto_Monto),0),2) as Impuesto, 
                   round(isnull(sum(Detalle_Total * Detalle_Cantidad),0),2) as Total,
                   isnull(i.Impuesto_Id,0) as Impuesto_Id, 
                   round(isnull(sum(Detalle_Precio_Unitario * Detalle_Cantidad),0),2) as Precio_Unitario, 
                   round(isnull(sum(Detalle_Descuento_Monto * Detalle_Cantidad),0),2) as Descuento,
                   round(isnull(sum(Detalle_Costo_Unitario * Detalle_Cantidad),0),2) as Costo_Unitario
                from Factura_Detalle fd with(NOLOCK)
                INNER JOIN Factura_Encabezado fe with(NOLOCK)
                ON fd.Emp_Id = fe.Emp_Id and fd.Suc_Id = fe.Suc_Id and fd.Caja_Id = fe.Caja_Id 
                	and fd.Factura_Id = fe.Factura_Id and fd.TipoDoc_Id = fe.TipoDoc_Id
                inner join Articulo a with(NOLOCK)
                on fd.Articulo_Id = a.Articulo_Id and a.Emp_Id = fd.Emp_Id
                left join Factura_Detalle_Impuestos i with(NOLOCK)
                on i.Emp_Id = fd.Emp_Id and i.Suc_Id = fd.Suc_Id and i.Caja_Id = fd.Caja_Id
                    and fd.Factura_Id = i.Factura_Id and fd.TipoDoc_Id = i.TipoDoc_Id 
                    and fd.Articulo_Id = i.Articulo_Id
                where fe.Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Emp_Id#">
					and fe.Suc_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Suc_Id#">
					and fe.Operacion_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Operacion_Id#">
					and fe.TipoDoc_Id != 2
                group by fd.Emp_Id, fd.Suc_Id, fd.Caja_Id,fd.Factura_Id,a.Depto_Id,i.Impuesto_Id
            </cfquery>
            
			<!--- Recorremos los encabezados Insertandolos y extrayendo sus detalles de Pago y detalles de Venta --->
			<cfif isdefined("rsEVentas") AND rsEVentas.recordcount GT 0>
			<cfloop query="rsEVentas">
            <cfsilent>
				<!--- ID para la tabla de Encabezados --->
				<cfquery name="rsMaxIDE" datasource="sifinterfaces">
					select isnull(max(id_documentoV),0) + 1 as MaxID
					from ESIFLD_Facturas_Venta 
				</cfquery> 
	
				<!--- Crea el numero de Documento --->
				<cfif (rsEVentas.Tipo_Venta EQ "C" OR rsEVentas.Tipo_Venta EQ "E") and rsEVentas.Tipo_CEDI EQ 0>
					<cfset Num_Doc = "V-" & numberformat(rsOperacionID.Emp_Id,"00") & numberformat(rsOperacionID.Suc_Id,"0000") &  numberformat(rsEVentas.Caja_Id,"00") & "-" & numberformat(rsEVentas.Factura_Id,"000000000")>
				<cfelseif (rsEVentas.Tipo_Venta EQ "C" OR rsEVentas.Tipo_Venta EQ "D")  and rsEVentas.Tipo_CEDI EQ 1>
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
							Numero_Documento, Cliente, IETU_Clas, Subtotal, Descuento, Impuesto, Total, Redondeo,
							Vendedor, Sucursal, Dias_Credito, Moneda, Tipo_cambio, Direccion_Fact, 
							Retencion, Observaciones,Tipo_CEDI,Estatus, Factura_Cambio)
						 values 
						 (<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_Id#">,
						 'LD',
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">, 
						 case 
							when <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEVentas.TipoDoc_Id#"> in (1,4) then 'FC' 
							when <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEVentas.TipoDoc_Id#"> in (3,5) then 'NC' 
						 end , 
						 <cfqueryparam cfsqltype="cf_sql_char" value="#rsEVentas.Tipo_Venta#">, 
						 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Factura_Fecha,"yyyy/mm/dd")#">, 
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Cierre#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Num_Doc#">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEVentas.Cliente_CodigoExterno#">,
						 null,
						 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsEVentas.Factura_Subtotal,'9.99')#">), 
						 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsEVentas.Factura_Descuento,'9.99')#">), 
						 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsEVentas.Factura_Impuesto,'9.99')#">), 
						 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsEVentas.Factura_Total,'9.99')#">),
                         abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsEVentas.Factura_Redondeo,'9.99')#">),
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEVentas.vendedor_Id#">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEVentas.Suc_Id#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEVentas.dias_credito#">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMoneda.Moneda_Id#">,
						 1, 
						 <!---<cfif rsEVentas.subcliente_Id NEQ "">
							abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsEVentas.factura_descuento,'9.99')#">),
						 <cfelse>
							null,
						 </cfif>---> null,
						 '',
						 '', 
						 <cfif rsEVentas.Tipo_CEDI EQ 1>
							'S',
						 <cfelse>
							'N',
						 </cfif>
						 <cfif rsEVentas.Tipo_Venta EQ 'C' OR rsEVentas.Tipo_Venta EQ 'E' OR (rsEVentas.Tipo_Venta EQ 'D' AND rsEVentas.Tipo_CEDI EQ 1)>
                         	15,
                         <cfelse>
                         	16,
                         </cfif>   
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
				<cfquery dbtype="query" name="rsFormaPago">
                	select *
                    from rsEFormaPago
                    where Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Emp_Id#">
					and Suc_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Suc_Id#">
					and Caja_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEVentas.Caja_Id#">
					and Factura_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEVentas.Factura_Id#">
                </cfquery>
                
				<cfset IDlinea = 1>
				<cfif isdefined("rsFormaPago") and rsFormaPago.recordcount GT 0>
				<cfloop query="rsFormaPago">
                <cfsilent>
					<cftransaction action="begin">
					<cftry>
						<cfquery datasource="sifinterfaces">
							insert into SIFLD_Facturas_Tipo_Pago
							(Ecodigo, ID_DocumentoV, ID_linea_Pago, Tipo_Pago, Importe, 
							Moneda, Tipo_Cambio, Especial, SocioDocumento, ID_Forma_Pago, Comision_Porcentaje)
							values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_Id#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#IDlinea#">,
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
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsFormaPago.SocioDoc#">,
							<cfif rsFormaPago.Tipo_Id eq 2>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormaPago.Tarjeta_Id#">,
							<cfelseif rsFormaPago.Tipo_Id eq 3>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormaPago.Cupon_Id#">,
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
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_Id#">
								and ID_DocumentoV =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">
							delete DSIFLD_Facturas_Venta
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_Id#">
								and ID_DocumentoV =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">
							delete ESIFLD_Facturas_Venta
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_Id#">
								and ID_DocumentoV =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">
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
					<cfif (rsFormaPago.Tipo_Id EQ 2 AND rsFormaPago.Tarjeta_Id NEQ 3) OR rsFormaPago.Tipo_Id EQ 3 OR rsFormaPago.Tipo_Id EQ 10>
						<cfswitch expression="#rsFormaPago.Tipo_Id#">
                        	<cfcase value="2">
                            	<cfset varFPago = "Tarjeta">
                                <cfset varCPago = "PT">
                            </cfcase>
                            <cfcase value="3">
                            	<cfset varFPago = "Cupon">
                                <cfset varCPago = "PV">
                            </cfcase>
                            <cfcase value="4">
                            	<cfset varFPago = "Co-Pago">
                                <cfset varCPago = "PC">
                            </cfcase>
                            <cfdefaultcase>
                            	<cfset varFPago = "Desconocido">
                                <cfset varCPago = "PO">
                            </cfdefaultcase>
                        </cfswitch>
                        
                        <cftransaction action="begin">
						<cftry>
							<!--- Arma documento para movimiento bancario --->
							<cfset Num_DocB = numberformat(rsOperacionID.Emp_Id,"00") & numberformat(rsOperacionID.Suc_Id,"0000") & "-" & numberformat(rsOperacionID.Operacion_Id,"000000000")>
                            
                            <!--- ID para la tabla de Encabezados --->
                            <cfquery name="rsMaxIDEB" datasource="sifinterfaces">
                                select isnull(max(ID_MovimientoB),0) + 1 as MaxID
                                from SIFLD_Movimientos_Bancarios
                            </cfquery> 
                            
                            <cfquery datasource="sifinterfaces">
								insert into SIFLD_Movimientos_Bancarios
									(Ecodigo, Origen, ID_MovimientoB, Tipo_Operacion, Tipo_Movimiento, 
									 Fecha_Movimiento,Documento, Referencia, Banco_Origen, Cuenta_Origen, 
									 Banco_Destino, Cuenta_Destino, Importe_Movimiento, Sucursal, Estatus, Concepto)
								values (
								 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_Id#">,
								 'LD',
								 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDEB.MaxID#">,
								 'PTB',
								 'P',
								 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEVentas.Factura_Fecha,"yyyy/mm/dd")#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Num_DocB#">,
								 'Deposito por Forma de Pago #varFPago#',
								 null,
								 null,
								 null,
								 null,
								 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsFormaPago.Pago_Total,'9.99')#">),
								 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Suc_Id#">,
								 15,
                                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(varCPago)#">)
							</cfquery>
							<cftransaction action="commit" />
						<cfcatch type="any">
							<cftransaction action="rollback" />
							<!--- Borra los registros para el Encabezado que se habia Insertado--->
							<cfquery datasource="sifinterfaces">
								delete SIFLD_Movimientos_Bancarios
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_Id#">
									and Documento like <cfqueryparam cfsqltype="cf_sql_varchar" value="#Num_DocB#">
								delete SIFLD_Facturas_Tipo_Pago
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_Id#">
									and ID_DocumentoV =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">
								delete DSIFLD_Facturas_Venta
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_Id#">
									and ID_DocumentoV =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">
								delete ESIFLD_Facturas_Venta
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_Id#">
									and ID_DocumentoV =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">
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
                </cfsilent>
				</cfloop> <!---FormaPago--->
				</cfif>
				<!--- Busca e Inserta los Detalles del Encabezado ---> 
				<cfquery dbtype="query" name="rsDVentas">
                	select *
                    from rsEDVentas
                    where Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Emp_Id#"> 
                    and Factura_Id  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEVentas.Factura_Id#">
                    and Suc_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEVentas.Suc_Id#">
                    and Caja_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEVentas.Caja_Id#">  
                </cfquery>
                
				<cfset IDlinea = 1>
				<cfif isdefined("rsDVentas") and rsDVentas.recordcount GT 0>
				<cfloop query="rsDVentas">
                <cfsilent>
					<cftransaction>
					<cftry>
						<cfquery datasource="sifinterfaces">
							insert into DSIFLD_Facturas_Venta 
								(Ecodigo, ID_DocumentoV, Id_linea, tipo_lin, tipo_item, clas_item,
								  cod_impuesto, cantidad,total_lin,precio_unitario, descuento_lin,
								  descuento_fact,subtotal_lin, impuesto_lin, costo_venta, cod_fabricante, cod_item) 
							values 
							(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_Id#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">, 
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDlinea#">, 
							 'S',
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDVentas.Depto_Id#">, 
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDVentas.Tipo_Articulo_Id#">, 
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDVentas.Impuesto_Id#">, 
							 <cfqueryparam cfsqltype="cf_sql_float" value="#rsDVentas.Cantidad#">, 
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Total,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Precio_Unitario,'9.99')#">),
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.Descuento,'9.99')#">),
							 0,
							 abs(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDVentas.total - rsDVentas.impuesto + rsDVentas.Descuento,'9.99')#">),
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
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_Id#">
								and ID_DocumentoV =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">
							delete DSIFLD_Facturas_Venta
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_Id#">
								and ID_DocumentoV =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">
							delete ESIFLD_Facturas_Venta
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_Id#">
								and ID_DocumentoV =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">
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
                </cfsilent>
				</cfloop> <!---Detalles Venta--->
				</cfif>
				<cfset rsFormaPago = javacast("null","")>
                <cfset rsCupon = javacast("null","")>
                <cfset rsMaxIDEB = javacast("null","")>
                <cfset rsDVentas = javacast("null","")>
                <cfset javaRT.gc()><!--- invoca el GC --->
                </cfsilent>
            </cfloop> <!--- Encabezados Venta--->
			</cfif> 

			<cfquery datasource="sifinterfaces">
                update ESIFLD_Facturas_Venta
                set Estatus = 1 
                where Estatus = 15
            </cfquery>
            <cfquery datasource="sifinterfaces">
                update ESIFLD_Facturas_Venta
                set Estatus = 4
                where Estatus = 16
            </cfquery>
            <cfquery datasource="sifinterfaces">
                update SIFLD_Movimientos_Bancarios
                set Estatus = 1 
                where Estatus = 15
            </cfquery>
            
            <cfquery datasource="ldcom">
                update SIFLD_Bitacora_Proceso
                set Estatus = 2,
                Fecha_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                where Proceso like 'VENTAS'
                and Estatus = 10
                and Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Emp_Id#">
                and Cadena_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_Id#">
                and Suc_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Suc_Id#">
                and Operacion_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Operacion_Id#">
                and Operacion_Fecha_Apertura = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Apertura#">
                and Operacion_Fecha_Cierre = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Cierre#">
            </cfquery>

            <cfset varProc = true>

			<cfset rsMoneda = javacast("null","")>
            <cfset rsMaxIDE = javacast("null","")>
            <cfset rsEVentas = javacast("null","")>
            <cfset javaRT.gc()><!--- invoca el GC --->
		<cfcatch type="any">
        	<cfquery datasource="sifinterfaces">
                delete DSIFLD_Facturas_Venta
                where ID_DocumentoV in 
                	(select ID_DocumentoV
                    from ESIFLD_Facturas_Venta
                	where Estatus in (15,16))
            </cfquery>
            <cfquery datasource="sifinterfaces">
                delete SIFLD_Facturas_Tipo_Pago
                where ID_DocumentoV in 
                	(select ID_DocumentoV
                    from ESIFLD_Facturas_Venta
                	where Estatus in (15,16))
            </cfquery>
            <cfquery datasource="sifinterfaces">
                delete ESIFLD_Facturas_Venta
                where Estatus in (15,16)
            </cfquery>
            <cfquery datasource="sifinterfaces">
                delete SIFLD_Movimientos_Bancarios
                where Estatus = 15
            </cfquery>
            <cfquery datasource="ldcom">
                update SIFLD_Bitacora_Proceso
                set Estatus = 3,
                Fecha_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                where Proceso like 'VENTAS'
                and Estatus = 10
                and Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Emp_Id#">
                and Cadena_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_Id#">
                and Suc_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Suc_Id#">
                and Operacion_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Operacion_Id#">
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
						'VENTAS',
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
				'No hay Cierres de Sucursal para el Dia de Hoy', 'VENTAS', getdate())
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

