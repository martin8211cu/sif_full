<cffunction name="procesaValores" access="public" output="true" returntype="numeric">
	<cfinclude template="../../../Utiles/sifConcat.cfm">
	<cfquery name="rsOfiFecha" datasource="#Session.DSN#">
		Select min(Oficodigo) as Oficodigo
			, min(FechaSalida) as FechaSalida
		from #table_name#
	</cfquery>

	<cfif isdefined('rsOfiFecha') and rsOfiFecha.Oficodigo NEQ '' and rsOfiFecha.FechaSalida NEQ ''>
		<cfquery name="rsllave" datasource="#Session.DSN#">
			Select min(a.ID_salprod) as ID_salprod
			from ESalidaProd a
				inner join Oficinas o
					on o.Ecodigo=a.Ecodigo
						and o.Oficodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#rsOfiFecha.Oficodigo#">
						
			where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and a.SPfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOfiFecha.FechaSalida#">
		</cfquery>
		<cfif isdefined('rsllave') and rsllave.ID_salprod NEQ ''>
			<cfquery datasource="#Session.DSN#">
				insert into TotDebitosCreditos 
					(ID_salprod, Ecodigo, TDCformato, TDCtotal, TDCtipo, TDCdesc, BMUsucodigo, BMfechaalta)
				Select <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsllave.ID_salprod#">
						, <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						, Codigo_pista, Ingreso, TipoMovimiento, 'Monto De Debito Importado por la Estación ' #_Cat# o.Odescripcion
						, <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
						, FechaSalida
				from #table_name# t
					inner join Oficinas o
						on o.Oficodigo=t.Oficodigo
							and o.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				where Codigo_turno = '*'
					and TipoRegistro <> 'V'
			</cfquery> 		
		</cfif>
	</cfif>

	<cfreturn 1>
</cffunction>

<cffunction name="procesaVentas" access="public" output="true" returntype="numeric">
	<!--- Todos los datos correctos, inicio de la insercion de informacion a las tablas de trabajo antes de la afectacion del inventario --->	
	<cfquery name="rsProcesaVentas" datasource="#Session.DSN#">
			select distinct 
				  o.Ecodigo as Ecodigo
				, o.Ocodigo as Ocodigo
				, p.Pista_id as Pista_id
				, t.Turno_id as Turno_id
				, a.FechaSalida as FechaSalida
				, 'Importacion de archivo (Ventas en Estacion de Servicio)' as Observaciones
				, 0 as SPestado
				, #session.Usucodigo# as BMUsucodigo
				, a.Codigo_pista as Codigo_pista
				, a.Codigo_turno as Codigo_turno
			from #table_name# a
				inner join Oficinas o
					on o.Oficodigo=a.Oficodigo
					and o.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				inner join Pistas p
					on p.Codigo_pista = a.Codigo_pista
					and p.Ecodigo=o.Ecodigo
					and p.Ocodigo=o.Ocodigo
					and p.Pestado = 1
				inner join Turnos t
					on t.Ecodigo=p.Ecodigo
					and t.Codigo_turno=a.Codigo_turno
			where TipoRegistro = 'V'
	</cfquery>

	<cfloop query="rsProcesaVentas">
			<!--- INSERCION DEL ENCABEZADO --->			
			<cfquery name="rsEncSalidas" datasource="#Session.dsn#">
				insert into ESalidaProd (Ecodigo, Ocodigo, Pista_id, Turno_id, SPfecha, Observaciones, SPestado, BMUsucodigo)
				values (
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsProcesaVentas.Ecodigo#">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsProcesaVentas.Ocodigo#">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsProcesaVentas.Pista_id#">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsProcesaVentas.Turno_id#">
					, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsProcesaVentas.FechaSalida#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsProcesaVentas.Observaciones#">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsProcesaVentas.SPestado#">
					, <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
					)
				<cf_dbidentity1 verificar_transaccion="no" datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" verificar_transaccion="no" name="rsEncSalidas">

			<cfset IdEncVentas = rsEncSalidas.identity>
		
			<!--- INSERCION DEL DETALLE de la venta por cada grupo de registros del archivo de entrada --->
			<cfquery name="cargaDatos" datasource="#Session.dsn#">
				insert into DSalidaProd (
					Ecodigo, 
					ID_salprod, 
					Alm_ai, 
					Aid, 
					Lectura_control, 
					Unidades_vendidas, 
					Unidades_despachadas, 
					Unidades_calibracion, 
					Precio, 
					DSPimpuesto, 
					Ingreso, 
					Descuento, 
					BMUsucodigo)
				select 
					  #Session.Ecodigo#
					, #IdEncVentas#
					, g.Aid
					, h.Aid
					, d.Lectura_control
					, d.Unidades_vendidas
					, d.Unidades_despachadas
					, 0
					, d.Precio
					, (((coalesce(d.Unidades_vendidas,0) + coalesce(d.Unidades_despachadas,0)) * coalesce(imp.Iporcentaje,0))  / 100) as Monto_Porcentaje
					, d.Ingreso
					, 0
					, <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric"> as BMUsucodigo
				from #table_name# d
					inner join Pistas e
						on e.Pista_id = #rsProcesaVentas.Pista_id#
						and e.Codigo_pista = d.Codigo_pista
					inner join Articulos h
						on h.Ecodigo = e.Ecodigo
						and h.Acodigo = d.Acodigo	
					inner join Artxpista axp
						on axp.Ecodigo=e.Ecodigo
							and axp.Aid=h.Aid
							and axp.Pista_id=e.Pista_id
							and axp.Estado=1
					inner join Almacen g
						on g.Aid=axp.Alm_Aid
							and g.Ecodigo=axp.Ecodigo						
							and g.Almcodigo=d.Codigo_Almacen
					left outer join Impuestos imp
						on imp.Ecodigo = h.Ecodigo
						and imp.Icodigo=h.Icodigo
				where d.TipoRegistro = 'V'
				  and d.Codigo_pista = '#rsProcesaVentas.Codigo_pista#'
				  and d.Codigo_turno = '#rsProcesaVentas.Codigo_turno#'
				  and d.FechaSalida  = '#rsProcesaVentas.FechaSalida#'
				  and (
				  		coalesce(d.Unidades_vendidas,0) + coalesce(d.Unidades_despachadas,0)
					) > 0
			</cfquery>

			<cfquery name="cargaDatos" datasource="#Session.dsn#">
				<!--- Insercion de las ventas de los articulos del vendedor 1 --->
				insert into DDSalidaProd (Ecodigo, Aid, ID_dsalprod, ESVid, DDScantidad, BMUsucodigo, BMfechaalta)
				Select 
					  #Session.Ecodigo#
				  	, h.Aid
					, ds.ID_dsalprod
					, n.ESVid
					, d.DDScantidad1
					, <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric"> as BMUsucodigo
					, <cf_dbfunction name="now">
				from #table_name# d
					inner join Pistas e
						on e.Pista_id = #rsProcesaVentas.Pista_id#
						and e.Codigo_pista = d.Codigo_pista
					inner join Articulos h
						on h.Ecodigo = e.Ecodigo
						and h.Acodigo = d.Acodigo
					inner join Artxpista axp
						on axp.Ecodigo=e.Ecodigo
							and axp.Aid=h.Aid
							and axp.Pista_id=e.Pista_id
							and axp.Estado=1
					inner join Almacen g
						on g.Aid=axp.Alm_Aid
							and g.Ecodigo=axp.Ecodigo
							and g.Almcodigo=d.Codigo_Almacen							
					inner join ESVendedores n
						 on n.Ecodigo=g.Ecodigo
						and n.Ocodigo=g.Ocodigo
						and n.ESVcodigo=d.ESVcodigo1
					inner join DSalidaProd ds
						on ds.ID_salprod = #IdEncVentas#
						and ds.Aid = h.Aid
						and ds.Alm_ai = g.Aid
				where d.TipoRegistro = 'V'
				  and d.Codigo_pista = '#rsProcesaVentas.Codigo_pista#'
				  and d.Codigo_turno = '#rsProcesaVentas.Codigo_turno#'
				  and d.FechaSalida  = '#rsProcesaVentas.FechaSalida#'
				  and d.DDScantidad1 <> 0
			</cfquery>

			<cfquery name="cargaDatos" datasource="#Session.dsn#">
				<!--- Insercion de las ventas de los articulos del vendedor 2 --->
				insert into DDSalidaProd (Ecodigo, Aid, ID_dsalprod, ESVid, DDScantidad, BMUsucodigo, BMfechaalta)
				Select 
					  #Session.Ecodigo#
				  	, h.Aid
					, ds.ID_dsalprod
					, n.ESVid
					, d.DDScantidad2
					, <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric"> as BMUsucodigo
					, <cf_dbfunction name="now">
				from #table_name# d
					inner join Pistas e
						on e.Pista_id = #rsProcesaVentas.Pista_id#
						and e.Codigo_pista = d.Codigo_pista
					inner join Articulos h
						on h.Ecodigo = e.Ecodigo
						and h.Acodigo = d.Acodigo
					inner join Artxpista axp
						on axp.Ecodigo=e.Ecodigo
							and axp.Aid=h.Aid
							and axp.Pista_id=e.Pista_id
							and axp.Estado=1
					inner join Almacen g
						on g.Aid=axp.Alm_Aid
							and g.Ecodigo=axp.Ecodigo		
							and g.Almcodigo=d.Codigo_Almacen	
					inner join ESVendedores n
						 on n.Ecodigo=g.Ecodigo
						and n.Ocodigo=g.Ocodigo
						and n.ESVcodigo=d.ESVcodigo2
					inner join DSalidaProd ds
						on ds.ID_salprod = #IdEncVentas#
						and ds.Aid = h.Aid
						and ds.Alm_ai = g.Aid
				where d.TipoRegistro = 'V'
				  and d.Codigo_pista = '#rsProcesaVentas.Codigo_pista#'
				  and d.Codigo_turno = '#rsProcesaVentas.Codigo_turno#'
				  and d.FechaSalida  = '#rsProcesaVentas.FechaSalida#'
				  and d.DDScantidad2 <> 0
			</cfquery>

			<cfquery name="cargaDatos" datasource="#Session.dsn#">
				<!--- Insercion de las ventas de los articulos del vendedor 3 --->
				insert into DDSalidaProd (Ecodigo, Aid, ID_dsalprod, ESVid, DDScantidad, BMUsucodigo, BMfechaalta)
				Select 
					  #Session.Ecodigo#
					, h.Aid
					, ds.ID_dsalprod					
					, n.ESVid
					, d.DDScantidad3
					, <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric"> as BMUsucodigo
					, <cf_dbfunction name="now">
				from #table_name# d
					inner join Pistas e
						on e.Pista_id = #rsProcesaVentas.Pista_id#
						and e.Codigo_pista = d.Codigo_pista
					inner join Articulos h
						on h.Ecodigo = e.Ecodigo
						and h.Acodigo = d.Acodigo
					inner join Artxpista axp
						on axp.Ecodigo=e.Ecodigo
							and axp.Aid=h.Aid
							and axp.Pista_id=e.Pista_id
							and axp.Estado=1
					inner join Almacen g
						on g.Aid=axp.Alm_Aid
							and g.Ecodigo=axp.Ecodigo	
							and g.Almcodigo=d.Codigo_Almacen
					inner join ESVendedores n
						 on n.Ecodigo=g.Ecodigo
						and n.Ocodigo=g.Ocodigo
						and n.ESVcodigo=d.ESVcodigo3
					inner join DSalidaProd ds
						on ds.ID_salprod = #IdEncVentas#
						and ds.Aid = h.Aid
						and ds.Alm_ai = g.Aid
				where d.TipoRegistro = 'V'
				  and d.Codigo_pista = '#rsProcesaVentas.Codigo_pista#'
				  and d.Codigo_turno = '#rsProcesaVentas.Codigo_turno#'
				  and d.FechaSalida  = '#rsProcesaVentas.FechaSalida#'
				  and d.DDScantidad3 <> 0
			</cfquery>

			<cfquery name="cargaDatos" datasource="#Session.dsn#">
				<!--- Insercion de las ventas de los articulos del vendedor 4 --->
				insert into DDSalidaProd (Ecodigo, Aid, ID_dsalprod, ESVid, DDScantidad, BMUsucodigo, BMfechaalta)
				Select 
					  #Session.Ecodigo#
					, h.Aid
					, ds.ID_dsalprod
					, n.ESVid
					, d.DDScantidad4
					, <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric"> as BMUsucodigo
					, <cf_dbfunction name="now">
				from #table_name# d
					inner join Pistas e
						on e.Pista_id = #rsProcesaVentas.Pista_id#
						and e.Codigo_pista = d.Codigo_pista
					inner join Articulos h
						on h.Ecodigo = e.Ecodigo
						and h.Acodigo = d.Acodigo
					inner join Artxpista axp
						on axp.Ecodigo=e.Ecodigo
							and axp.Aid=h.Aid
							and axp.Pista_id=e.Pista_id
							and axp.Estado=1
					inner join Almacen g												
						on g.Aid=axp.Alm_Aid
							and g.Ecodigo=axp.Ecodigo
							and g.Almcodigo=d.Codigo_Almacen														
					inner join ESVendedores n
						 on n.Ecodigo=g.Ecodigo
						and n.Ocodigo=g.Ocodigo
						and n.ESVcodigo=d.ESVcodigo4
					inner join DSalidaProd ds
						on ds.ID_salprod = #IdEncVentas#
						and ds.Aid = h.Aid
						and ds.Alm_ai = g.Aid
				where d.TipoRegistro = 'V'
				  and d.Codigo_pista = '#rsProcesaVentas.Codigo_pista#'
				  and d.Codigo_turno = '#rsProcesaVentas.Codigo_turno#'
				  and d.FechaSalida  = '#rsProcesaVentas.FechaSalida#'
				  and d.DDScantidad4 <> 0
			</cfquery>			
	</cfloop>
	<cfreturn 1>
</cffunction>

<!--- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*--*-*-*-*--*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*- --->
<!--- INICIO DEL PROCESAMIENTO DE LOS DATOS --->
<!--- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*--*-*-*-*--*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*- --->

<cf_dbtemp name="TablaErrores" returnvariable="TablaErrores" datasource="#session.DSN#">
	<cf_dbtempcol name="DescripcionError" type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="ColumnaDescripcion" type="varchar(255)" mandatory="yes">
</cf_dbtemp>
<cfinclude template="../../../Utiles/sifConcat.cfm">

<cfset resVentas = true>
<cfset LbanderaError = false>

<cfquery name="rsCheck0" datasource="#Session.DSN#">
	select count(1) as check0 from #table_name#
</cfquery>

<cfif rsCheck0.Recordcount eq 0>
	<cfset LbanderaError = True>
	<cfquery datasource="#session.DSN#">
		insert into #TablaErrores# (DescripcionError, ColumnaDescripcion)
		select 'No se cargaron datos para importar!' , ' ' 
	</cfquery>
</cfif>

<!--- Verificar que no existan datos para la estacion para la fecha de insercion --->
<cfquery name="rsVerifica" datasource="#session.DSN#">
	select count(1) as Cantidad
	from #table_name# t
	where t.TipoRegistro = 'V'
	  and exists(
		select 1
		from ESalidaProd a
			inner join Oficinas o
				on o.Ecodigo=a.Ecodigo
					and o.Ocodigo=a.Ocodigo
					and o.Oficodigo=t.Oficodigo
		where a.Ecodigo = #Session.Ecodigo#
		  and a.SPfecha = t.FechaSalida)
</cfquery>

<cfif rsVerifica.Cantidad NEQ 0>
	<cfset LbanderaError = True>
	<cfquery datasource="#session.DSN#">
		insert into #TablaErrores# (DescripcionError, ColumnaDescripcion)
		select distinct 'Ya existen datos registrados de ventas para la estacion: ' #_Cat# t.Oficodigo #_Cat# ' para la fecha: ' #_Cat# <cf_dbfunction name="to_char" args="t.FechaSalida">, 'Importaci&oacute;n no permitida'
		from #table_name# t
		where t.TipoRegistro = 'V'
		  and exists(
			select 1
			from ESalidaProd a
				inner join Oficinas o
					on o.Ecodigo=a.Ecodigo
						and o.Ocodigo=a.Ocodigo
						and o.Oficodigo=t.Oficodigo
			where a.Ecodigo = #Session.Ecodigo#
			  and a.SPfecha = t.FechaSalida)
	</cfquery>
</cfif>

<!--- Verificar que los montos sean correctos en Debitos y Creditos --->
<cfquery name="rsVerifica" datasource="#session.DSN#">
	select 
		sum(case when TipoMovimiento = 'D' then Ingreso else 0.00 end) as Debitos,
		sum(case when TipoMovimiento = 'C' then Ingreso else 0.00 end) as Creditos
	from #table_name#
</cfquery>

<cfif rsVerifica.Debitos NEQ rsVerifica.Creditos>
	<cfset LbanderaError = True>
	<cfquery datasource="#session.DSN#">
		insert into #TablaErrores# (DescripcionError, ColumnaDescripcion)
		values (
			'Los Debitos no concuerdan con los Creditos en el archivo'
			, 'Debitos #LSCurrencyFormat(rsVerifica.Debitos, 'none')# Creditos: #LSCurrencyFormat(rsVerifica.Creditos, 'none')#')
	</cfquery>
</cfif>

<!--- Verificar que exista la Oficina Y TODOS LOS Registros tengan la misma oficina --->
<cfquery name="rsVerifica" datasource="#session.DSN#">
	select min(Oficodigo) as Oficina
	from #table_name#
</cfquery>

<cfset LvarOficodigo = rsVerifica.Oficina>

<cfquery name="rsVerifica" datasource="#session.DSN#">
	select Oficodigo
	from #table_name#
	where Oficodigo <> '#LvarOficodigo#'
</cfquery>

<cfif rsVerifica.recordcount NEQ 0>
	<cfset LbanderaError = True>
	<cfquery datasource="#session.DSN#">
		insert into #TablaErrores# (DescripcionError, ColumnaDescripcion)
		select distinct 'La Oficina ' #_Cat# Oficodigo #_Cat# ' que se indica en el archivo no puede ser diferente a #LvarOficodigo#', 'Valor no permitido'
		from #table_name#
		where Oficodigo <> '#LvarOficodigo#'
	</cfquery>
</cfif>

<!--- Verificar que exista el articulo --->
<cfquery name="rsVerifica" datasource="#session.DSN#">
	select count(1) as Cantidad
	from #table_name# t
	where t.TipoRegistro = 'V'
	  and not exists(
		select 1
		from Articulos a
		where a.Ecodigo = #Session.Ecodigo#
		  and a.Acodigo = t.Acodigo)
</cfquery>

<cfif rsVerifica.Cantidad NEQ 0>
	<cfset LbanderaError = True>
	<cfquery datasource="#session.DSN#">
		insert into #TablaErrores# (DescripcionError, ColumnaDescripcion)
		select distinct 'El Articulo ' #_Cat# t.Acodigo #_Cat# ' que se indica en el archivo no existe en el Catalogo', 'Valor no permitido'
		from #table_name# t
		where t.TipoRegistro = 'V'
		  and not exists(
			select 1
			from Articulos a
			where a.Ecodigo = #Session.Ecodigo#
			  and a.Acodigo = t.Acodigo)
	</cfquery>
</cfif>

<!--- Verificar que exista la pista para la oficina indicada para todos los registros tipo Venta --->
<cfquery name="rsVerifica" datasource="#session.DSN#">
	select count(1) as Cantidad
	from #table_name# t
	where t.TipoRegistro = 'V'
	  and not exists(
		select 1
		from Pistas c
			inner join Oficinas o
				on o.Ecodigo = c.Ecodigo
				and o.Ocodigo = c.Ocodigo
				and o.Oficodigo = t.Oficodigo
				
		where c.Codigo_pista = t.Codigo_pista
		  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  )
</cfquery>

<cfif rsVerifica.Cantidad NEQ 0>
	<cfset LbanderaError = True>
	<cfquery datasource="#session.DSN#">
		insert into #TablaErrores# (DescripcionError, ColumnaDescripcion)
		select distinct 'La Pista ' #_Cat# t.Codigo_pista #_Cat# ' que se indica en el archivo no existe en el Catalogo o no es de la Estacion', 'Valor no permitido'
		from #table_name# t
		where t.TipoRegistro = 'V'
		  and not exists(
			select 1
			from Pistas c
				inner join Oficinas o
					on o.Ecodigo = c.Ecodigo
					and o.Ocodigo = c.Ocodigo
			where c.Codigo_pista = a.Codigo_pista
			  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			  and o.Oficodigo = t.Oficodigo
			  )
	</cfquery>
</cfif>


<!--- Verificar que la pista tenga el articulo asignado para todos los registros tipo venta --->
<cfquery name="rsVerifica" datasource="#session.DSN#">
	select count(1) as Cantidad
	from #table_name# t
	where t.TipoRegistro = 'V'
	  and not exists(
			select 1
			from Pistas p
				inner join Articulos a
					on a.Ecodigo=p.Ecodigo	
						and a.Acodigo = t.Acodigo
				inner join Almacen b
					on b.Ecodigo = p.Ecodigo
						and b.Almcodigo=t.Codigo_Almacen
				inner join Artxpista ap
					on ap.Ecodigo = a.Ecodigo
						and ap.Aid = a.Aid
						and ap.Pista_id = p.Pista_id
						and ap.Alm_Aid  = b.Aid
						and ap.Estado  <> 0
			where p.Ecodigo = #Session.Ecodigo#
			  and p.Codigo_pista = t.Codigo_pista
		)
</cfquery>

<cfif rsVerifica.Cantidad NEQ 0>
	<cfset LbanderaError = True>
	<cfquery datasource="#session.DSN#">
		insert into #TablaErrores# (DescripcionError, ColumnaDescripcion)
		select distinct 'El Articulo ' #_Cat# t.Acodigo #_Cat# ' NO esta definido en la pista ' #_Cat# t.Codigo_pista #_Cat# ' para el almacén ' #_Cat# t.Codigo_Almacen, 'Valor no permitido'
		from #table_name# t
		where t.TipoRegistro = 'V'
		  and not exists(
					select 1
					from Pistas p
						inner join Articulos a
							on a.Ecodigo=p.Ecodigo	
								and a.Acodigo = t.Acodigo
						inner join Almacen b
							on b.Ecodigo = p.Ecodigo
								and b.Almcodigo=t.Codigo_Almacen
						inner join Artxpista ap
							on ap.Ecodigo = a.Ecodigo
								and ap.Aid = a.Aid
								and ap.Pista_id = p.Pista_id
								and ap.Alm_Aid  = b.Aid
								and ap.Estado  <> 0
					where p.Ecodigo = #Session.Ecodigo#
					  and p.Codigo_pista = t.Codigo_pista
			  )
	</cfquery>
</cfif>

<!--- Verificar que exista el almacen --->
<cfquery name="rsVerifica" datasource="#session.DSN#">
	select count(1) as Cantidad
	from #table_name# t
	where t.TipoRegistro = 'V'
	  and not exists(
		select 1
		from Almacen a
		where a.Ecodigo = #Session.Ecodigo#
		  and a.Almcodigo = t.Codigo_Almacen)
</cfquery>

<cfif rsVerifica.Cantidad NEQ 0>
	<cfset LbanderaError = True>
	<cfquery datasource="#session.DSN#">
		insert into #TablaErrores# (DescripcionError, ColumnaDescripcion)
		select distinct 'El Almacen ' #_Cat# t.Codigo_Almacen #_Cat# ' que se indica en el archivo no existe en el Catalogo', 'Valor no permitido'
		from #table_name# t
		where t.TipoRegistro = 'V'
		  and not exists(
			select 1
			from Almacen a
			where a.Ecodigo = #Session.Ecodigo#
			  and a.Almcodigo = t.Codigo_Almacen)
	</cfquery>
</cfif>

<!--- Verificar que el almacen se encuentre asignado a la estacion --->
<cfquery name="rsVerifica" datasource="#session.DSN#">
	select count(1) as Cantidad
	from #table_name# t
	where t.TipoRegistro = 'V'
	  and not exists(
			select 1
			from Almacen a
				inner join Oficinas o
					on o.Ecodigo=a.Ecodigo
						and o.Ocodigo=a.Ocodigo
						and o.Oficodigo=t.Oficodigo
			where a.Ecodigo=#Session.Ecodigo#
				and a.Almcodigo=t.Codigo_Almacen)
</cfquery>


<cfif rsVerifica.Cantidad NEQ 0>
	<cfset LbanderaError = True>
	<cfquery datasource="#session.DSN#">
		insert into #TablaErrores# (DescripcionError, ColumnaDescripcion)
		select distinct 'El Almacen ' #_Cat# t.Codigo_Almacen #_Cat# ' que se indica en el archivo no esta asociado a la estacion ' #_Cat# t.Oficodigo, 'Valor no permitido'
		from #table_name# t
		where t.TipoRegistro = 'V'
		  and not exists(
				select 1
				from Almacen a
					inner join Oficinas o
						on o.Ecodigo=a.Ecodigo
							and o.Ocodigo=a.Ocodigo
							and o.Oficodigo=t.Oficodigo
				where a.Ecodigo=#Session.Ecodigo#
					and a.Almcodigo=t.Codigo_Almacen)
	</cfquery>
</cfif>

<!--- Verificar que el vendedor 1 exista y se encuentre asignado a la estacion --->
<cfquery name="rsVerifica" datasource="#session.DSN#">
	select count(1) as Cantidad
	from #table_name# t
	where t.TipoRegistro = 'V'
	  and t.DDScantidad1 <> 0
	  and not exists(
			select 1
			from Oficinas o
				inner join ESVendedores v
						on v.Ecodigo = o.Ecodigo
						and v.Ocodigo = o.Ocodigo
						and v.ESVcodigo = t.ESVcodigo1
			where o.Ecodigo = #Session.Ecodigo#
			  and o.Oficodigo = t.Oficodigo
		)
</cfquery>

<cfif rsVerifica.Cantidad GT 0>
	<cfset LbanderaError = True>
	<cfquery datasource="#session.DSN#">
		insert into #TablaErrores# (DescripcionError, ColumnaDescripcion)
		select distinct 'El Vendedor ' #_Cat# t.ESVcodigo1 #_Cat# ' NO esta definido o no esta asignado a la pista ' #_Cat# t.Codigo_pista, 'Valor no permitido'
		from #table_name# t
		where t.TipoRegistro = 'V'
		  and t.DDScantidad1 <> 0
		  and not exists(
				select 1
				from Oficinas o
					inner join ESVendedores v
							on v.Ecodigo = o.Ecodigo
							and v.Ocodigo = o.Ocodigo
							and v.ESVcodigo = t.ESVcodigo1
				where o.Ecodigo = #Session.Ecodigo#
				  and o.Oficodigo = t.Oficodigo
			)
	</cfquery>
</cfif>

<!--- Verificar que el vendedor 2 exista y se encuentre asignado a la estacion --->
<cfquery name="rsVerifica" datasource="#session.DSN#">
	select count(1) as Cantidad
	from #table_name# t
	where t.TipoRegistro = 'V'
	  and t.DDScantidad2 <> 0
	  and not exists(
			select 1
			from Oficinas o
				inner join ESVendedores v
						on v.Ecodigo = o.Ecodigo
						and v.Ocodigo = o.Ocodigo
						and v.ESVcodigo = t.ESVcodigo2
			where o.Ecodigo = #Session.Ecodigo#
			  and o.Oficodigo = t.Oficodigo
		)
</cfquery>

<cfif rsVerifica.Cantidad GT 0>
	<cfset LbanderaError = True>
	<cfquery datasource="#session.DSN#">
		insert into #TablaErrores# (DescripcionError, ColumnaDescripcion)
		select distinct 'El Vendedor ' #_Cat# t.ESVcodigo2 #_Cat# ' NO esta definido o no esta asignado a la pista ' #_Cat# t.Codigo_pista, 'Valor no permitido'
		from #table_name# t
		where t.TipoRegistro = 'V'
		  and t.DDScantidad2 <> 0
		  and not exists(
				select 1
				from Oficinas o
					inner join ESVendedores v
							on v.Ecodigo = o.Ecodigo
							and v.Ocodigo = o.Ocodigo
							and v.ESVcodigo = t.ESVcodigo2
				where o.Ecodigo = #Session.Ecodigo#
				  and o.Oficodigo = t.Oficodigo
			)
	</cfquery>
</cfif>

<!--- Verificar que el vendedor 3 exista y se encuentre asignado a la estacion --->
<cfquery name="rsVerifica" datasource="#session.DSN#">
	select count(1) as Cantidad
	from #table_name# t
	where t.TipoRegistro = 'V'
	  and t.DDScantidad3 <> 0
	  and not exists(
			select 1
			from Oficinas o
				inner join ESVendedores v
						on v.Ecodigo = o.Ecodigo
						and v.Ocodigo = o.Ocodigo
						and v.ESVcodigo = t.ESVcodigo3
			where o.Ecodigo = #Session.Ecodigo#
			  and o.Oficodigo = t.Oficodigo
		)
</cfquery>

<cfif rsVerifica.Cantidad GT 0>
	<cfset LbanderaError = True>
	<cfquery datasource="#session.DSN#">
		insert into #TablaErrores# (DescripcionError, ColumnaDescripcion) 
		select distinct 'El Vendedor ' #_Cat# t.ESVcodigo3 #_Cat# ' NO esta definido o no esta asignado a la pista ' #_Cat# t.Codigo_pista, 'Valor no permitido'	
		from #table_name# t
		where t.TipoRegistro = 'V'
		  and t.DDScantidad3 <> 0
		  and not exists(
				select 1
				from Oficinas o
					inner join ESVendedores v
							on v.Ecodigo = o.Ecodigo
							and v.Ocodigo = o.Ocodigo
							and v.ESVcodigo = t.ESVcodigo3
				where o.Ecodigo = #Session.Ecodigo#
				  and o.Oficodigo = t.Oficodigo
			)		  
	</cfquery>
</cfif>

<!--- Verificar que el vendedor 4 exista y se encuentre asignado a la estacion --->
<cfquery name="rsVerifica" datasource="#session.DSN#">
	select count(1) as Cantidad
	from #table_name# t
	where t.TipoRegistro = 'V'
	  and t.DDScantidad4 <> 0
	  and not exists(
			select 1
			from Oficinas o
				inner join ESVendedores v
						on v.Ecodigo = o.Ecodigo
						and v.Ocodigo = o.Ocodigo
						and v.ESVcodigo = t.ESVcodigo4
			where o.Ecodigo = #Session.Ecodigo#
			  and o.Oficodigo = t.Oficodigo
		)
</cfquery>

<cfif rsVerifica.Cantidad GT 0>
	<cfset LbanderaError = True>
	<cfquery datasource="#session.DSN#">
		insert into #TablaErrores# (DescripcionError, ColumnaDescripcion)
		select distinct 'El Vendedor ' #_Cat# t.ESVcodigo4 #_Cat# ' NO esta definido o no esta asignado a la pista ' #_Cat# t.Codigo_pista, 'Valor no permitido'
		from #table_name# t
		where t.TipoRegistro = 'V'
		  and t.DDScantidad4 <> 0
		  and not exists(
				select 1
				from Oficinas o
					inner join ESVendedores v
							on v.Ecodigo = o.Ecodigo
							and v.Ocodigo = o.Ocodigo
							and v.ESVcodigo = t.ESVcodigo4
				where o.Ecodigo = #Session.Ecodigo#
				  and o.Oficodigo = t.Oficodigo
			)
	</cfquery>
</cfif>

<!--- Verificar que se hayan asociado los almacenes en el tab de existencias para el articulo en la pista y almacen indicados --->
<cfquery name="rsVerifica" datasource="#session.DSN#">
	select count(1) as Cantidad
	from #table_name# t
		inner join Oficinas o
			on o.Ecodigo=#Session.Ecodigo#
				and o.Oficodigo = t.Oficodigo
		inner join Pistas p
			on p.Ecodigo=o.Ecodigo
				and p.Ocodigo=o.Ocodigo
				and p.Codigo_pista=t.Codigo_pista
		inner join Turnos tu
			on tu.Ecodigo=p.Ecodigo
				and tu.Codigo_turno=t.Codigo_turno
		inner join Articulos ar
			on ar.Ecodigo=tu.Ecodigo
				and ar.Acodigo=t.Acodigo
		inner join Artxpista axp
			on axp.Ecodigo=ar.Ecodigo
				and axp.Aid=ar.Aid
				and axp.Pista_id=p.Pista_id
				and axp.Estado=1				
	where t.TipoRegistro = 'V'
	  and not exists(
			select 1
			from Existencias ex
			where ex.Ecodigo=o.Ecodigo
				and ex.Aid=ar.Aid
				and ex.Alm_Aid=axp.Alm_Aid)
</cfquery>

<cfif rsVerifica.Cantidad NEQ 0>
	<cfset LbanderaError = True>
	<cfquery datasource="#session.DSN#">
		insert into #TablaErrores# (DescripcionError, ColumnaDescripcion)
		select distinct 'El Articulo ' #_Cat# t.Acodigo #_Cat# ' que se indica en el archivo para la pista: ' #_Cat# t.Codigo_pista #_Cat# ' no se le ha asociado el almacen: ' #_Cat# al.Bdescripcion #_Cat# ' en el tab de Existencias en el catalogo de articulos', 'Articulo sin existencias'
		from #table_name# t
			inner join Oficinas o
				on o.Ecodigo=#Session.Ecodigo#
					and o.Oficodigo = t.Oficodigo
			inner join Pistas p
				on p.Ecodigo=o.Ecodigo
					and p.Ocodigo=o.Ocodigo
					and p.Codigo_pista=t.Codigo_pista
			inner join Turnos tu
				on tu.Ecodigo=p.Ecodigo
					and tu.Codigo_turno=t.Codigo_turno
			inner join Articulos ar
				on ar.Ecodigo=tu.Ecodigo
					and ar.Acodigo=t.Acodigo
			inner join Artxpista axp
				on axp.Ecodigo=ar.Ecodigo
					and axp.Aid=ar.Aid
					and axp.Pista_id=p.Pista_id
					and axp.Estado=1				
			inner join Almacen al
				on al.Ecodigo=axp.Ecodigo
					and al.Aid=axp.Alm_Aid
		where t.TipoRegistro = 'V'
		  and not exists(
				select 1
				from Existencias ex
				where ex.Ecodigo=o.Ecodigo
					and ex.Aid=ar.Aid
					and ex.Alm_Aid=axp.Alm_Aid)
	</cfquery>
</cfif>

<!--- Verificar que existan existencias para el articulo en la pista y almacen indicados --->
<cfquery name="rsVerifica" datasource="#session.DSN#">
	select count(1) as Cantidad
	from #table_name# t
		inner join Oficinas o
			on o.Ecodigo=#Session.Ecodigo#
				and o.Oficodigo = t.Oficodigo
		inner join Pistas p
			on p.Ecodigo=o.Ecodigo
				and p.Ocodigo=o.Ocodigo
				and p.Codigo_pista=t.Codigo_pista
		inner join Turnos tu
			on tu.Ecodigo=p.Ecodigo
				and tu.Codigo_turno=t.Codigo_turno
		inner join Articulos ar
			on ar.Ecodigo=tu.Ecodigo
				and ar.Acodigo=t.Acodigo
		inner join Artxpista axp
			on axp.Ecodigo=ar.Ecodigo
				and axp.Aid=ar.Aid
				and axp.Pista_id=p.Pista_id
				and axp.Estado=1				
		inner join Almacen al
			on al.Ecodigo=axp.Ecodigo
				and al.Aid=axp.Alm_Aid		
				and al.Almcodigo=t.Codigo_Almacen		
	where t.TipoRegistro = 'V'
	  and exists(
			select 1
			from Existencias ex
			where ex.Ecodigo=o.Ecodigo
				and ex.Aid=ar.Aid
				and ex.Alm_Aid=axp.Alm_Aid			
				and ex.Eexistencia < (coalesce(t.Unidades_vendidas, 0) + coalesce(t.Unidades_despachadas, 0))
			)
</cfquery>

<cfif rsVerifica.Cantidad NEQ 0>
	<cfset LbanderaError = True>
	<cfquery datasource="#session.DSN#">
		insert into #TablaErrores# (DescripcionError, ColumnaDescripcion)
		select distinct 'El Articulo ' #_Cat# t.Acodigo #_Cat# ' que se indica en el archivo para la pista: ' #_Cat# t.Codigo_pista #_Cat# ' no contiene existencias en el almacen: ' #_Cat# al.Bdescripcion, 'Articulo sin existencias'
		from #table_name# t
			inner join Oficinas o
				on o.Ecodigo=#Session.Ecodigo#
					and o.Oficodigo = t.Oficodigo
			inner join Pistas p
				on p.Ecodigo=o.Ecodigo
					and p.Ocodigo=o.Ocodigo
					and p.Codigo_pista=t.Codigo_pista
			inner join Turnos tu
				on tu.Ecodigo=p.Ecodigo
					and tu.Codigo_turno=t.Codigo_turno
			inner join Articulos ar
				on ar.Ecodigo=tu.Ecodigo
					and ar.Acodigo=t.Acodigo
			inner join Artxpista axp
				on axp.Ecodigo=ar.Ecodigo
					and axp.Aid=ar.Aid
					and axp.Pista_id=p.Pista_id
					and axp.Estado=1				
			inner join Almacen al
				on al.Ecodigo=axp.Ecodigo
					and al.Aid=axp.Alm_Aid
					and al.Almcodigo=t.Codigo_Almacen	
		where t.TipoRegistro = 'V'
		  and exists(
				select 1
				from Existencias ex
				where ex.Ecodigo=o.Ecodigo
					and ex.Aid=ar.Aid
					and ex.Alm_Aid=axp.Alm_Aid			
					and ex.Eexistencia < (coalesce(t.Unidades_vendidas, 0) + coalesce(t.Unidades_despachadas, 0))
			)					
	</cfquery>
</cfif>

<!--- Verificar que la suma de las unidades despachadas mas las vendidas 
	sea igual a la suma de las unidades vendidas por los vendedores --->
<cfquery datasource="#session.DSN#">
		insert into #TablaErrores# (DescripcionError, ColumnaDescripcion)
		select 'La Cantidad reportada de Ventas no concuerda con la venta por Vendedor', 'Articulo ' #_Cat# t.Acodigo
		from #table_name# t
		where t.TipoRegistro = 'V'
		  and (Unidades_vendidas + Unidades_despachadas) <> (DDScantidad1 + DDScantidad2 + DDScantidad3 + DDScantidad4)
</cfquery>

<cfquery datasource="#session.DSN#">
		insert into #TablaErrores# (DescripcionError, ColumnaDescripcion)
		select 'La Venta reportada no concuerda las unidades por el precio', 'Articulo ' #_Cat# t.Acodigo
		from #table_name# t
		where t.TipoRegistro = 'V'
		  and (Unidades_vendidas * Precio) <> (Ingreso)
</cfquery>

<cfquery datasource="#session.DSN#">
		insert into #TablaErrores# (DescripcionError, ColumnaDescripcion)
		select 'La Cuenta digitada no existe en el catalogo de Cuentas ', t.Codigo_pista
		from #table_name# t
		where t.TipoRegistro <> 'V'
			and t.TipoMovimiento = 'D'
		  and not exists(
		  	select 1
			from CFinanciera cf
			where cf.CFformato = t.Codigo_pista
			  and cf.Ecodigo = #Session.Ecodigo#
		  )
</cfquery>

<cfquery datasource="#session.DSN#">
		insert into #TablaErrores# (DescripcionError, ColumnaDescripcion)
		select 'El valor registrado: ' #_Cat# t.TipoMovimiento #_Cat# ' en el registro tipo ' #_Cat# t.TipoRegistro #_Cat# ' ' #_Cat# t.Codigo_pista #_Cat# ' No es Correcto', 'Valor Incorrecto'
		from #table_name# t
		where TipoMovimiento not in ('D', 'C')
</cfquery>

<cfquery datasource="#session.DSN#">
		insert into #TablaErrores# (DescripcionError, ColumnaDescripcion)
		select 'El codigo de turno registrado: ' #_Cat# t.Codigo_turno #_Cat# ' en el registro tipo ' #_Cat# t.TipoRegistro #_Cat# ' ' #_Cat# t.Codigo_pista #_Cat# ' No es Correcto', 'Valor Incorrecto'
		from #table_name# t
		where t.TipoRegistro = 'V'
		  and not exists(
			select 1
			from Turnos tu
			where tu.Ecodigo = #Session.Ecodigo#
			  and tu.Codigo_turno = t.Codigo_turno
		)
</cfquery>

<cfquery datasource="#session.DSN#">
		insert into #TablaErrores# (DescripcionError, ColumnaDescripcion)
		select 'El codigo de turno registrado: ' #_Cat# t.Codigo_turno #_Cat# ' no se permite en la oficina ' #_Cat# t.Oficodigo , 'Valor Incorrecto'
		from #table_name# t
		where t.TipoRegistro = 'V'
		  and not exists(
			select 1
			from Turnos tu, Oficinas o, Turnoxofi tof
			where tu.Ecodigo = #Session.Ecodigo#
			  and tu.Codigo_turno = t.Codigo_turno
			  and o.Ecodigo = tu.Ecodigo
			  and o.Oficodigo = t.Oficodigo
			  and tof.Ecodigo = o.Ecodigo
			  and tof.Ocodigo = o.Ocodigo
			  and tof.Turno_id = tu.Turno_id
			  and tof.Testado = 1
		)
</cfquery>

<cfquery datasource="#session.DSN#">
		insert into #TablaErrores# (DescripcionError, ColumnaDescripcion)
		select 'La venta registrada para el producto: ' #_Cat# t.Acodigo #_Cat# ' es MAYOR que el inventario de control ', 'Valor Incorrecto'
		from #table_name# t
		where t.TipoRegistro = 'V'
		  and (Unidades_despachadas + Unidades_vendidas) > Lectura_control
</cfquery>

<!--- Verificar que exista la fecha Y TODOS LOS Registros tengan la misma fecha --->
<cfquery name="rsVerifica" datasource="#session.DSN#">
	select min(FechaSalida) as fecha
	from #table_name#
</cfquery>

<cfset LvarFecha = rsVerifica.fecha>

 <cfquery name="rsVerifica" datasource="#session.DSN#">
	select FechaSalida
	from #table_name#
	where FechaSalida <> '#LvarFecha#'
</cfquery>

<cfif rsVerifica.recordcount NEQ 0>
	<cfset LbanderaError = True>
	<cfquery datasource="#session.DSN#">
		insert into #TablaErrores# (DescripcionError, ColumnaDescripcion)
		select distinct 'Existen varias fechas distintas en el archivo. Solo se permite una sola', 'Valor no permitido'
		from #table_name#
		where FechaSalida <> '#LvarFecha#'
	</cfquery>
</cfif>

<cfquery name="ERR" datasource="#session.DSN#">
	select DescripcionError as MSG, ColumnaDescripcion
	from #TablaErrores#
</cfquery>

<cfif ERR.recordcount GT 0>
	<cfset LbanderaError = true>
</cfif>

<cfif not LbanderaError>
	<!--- Procesamiento de los datos de las ventas --->
	<cftransaction>
		 <cfset resVentas = procesaVentas()> 
  		<cfset resDeb    = procesaValores()>
	</cftransaction>
</cfif>
<!--- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*--*-*-*-*--*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*- --->
<!--- FIN DEL PROCESAMIENTO DE LOS DATOS --->
<!--- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*--*-*-*-*--*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*- --->
		
