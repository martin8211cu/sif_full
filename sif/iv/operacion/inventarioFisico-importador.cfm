<cfquery name="data" datasource="#session.DSN#">
	select a.id, a.estante, a.casilla, a.codigo, coalesce(a.cantidad, '0') as cantidad
	from #table_name# a
	where a.id > 3
</cfquery>

<cf_dbtemp name="ERR_IFI_1" returnvariable="errores" datasource="#session.DSN#">
	<cf_dbtempcol name="codigo"	type="char(15)"  mandatory="no">
	<cf_dbtempcol name="error"	type="char(100)" mandatory="no">
</cf_dbtemp>
<cfset vAlmacen = 0 >
<cfset vEFid = 0 >
<cfset vFecha = LSdateFormat(now(),'dd/mm/yyyy') >
<cfoutput query="data">
	<!--- procesa lineas --->
	<cfif trim(data.estante) neq 'Ubicacion' and trim(data.estante) neq 'Estante' and trim(data.estante) neq 'Clasificacion' >
		<!--- INSERTAR ENCABEZADO DE INVENTARIO --->
		<cfif trim(data.estante) eq 'Almacen' >
			<cfset vAlmacen = 0 >
			<cfset vEFid = 0 >
			<cfif len(trim(data.casilla))>
				<cfset vAlmcodigo = trim(mid( trim(data.casilla), 5, len(trim(data.casilla)))) >		<!--- ver como se hace para que quede como string en el csv, de momento le puse Cod:XXX--->
				<cfquery name="rsCodigoAlm" datasource="#session.DSN#">
					select Aid
					from Almacen
					where Ecodigo =  #session.Ecodigo# 
					  and Almcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vAlmcodigo#">
				</cfquery>
				<cfif len(trim(rsCodigoAlm.Aid))   >
					<cfset vAlmacen = rsCodigoAlm.Aid >
					<cftransaction>
					<cfquery name="insertado" datasource="#session.DSN#">
						insert into EFisico( Aid, Ecodigo, EFdescripcion, EFfecha, EFestado, BMUsucodigo, BMfechaalta )
						values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#vAlmacen#">,
								  #session.Ecodigo# ,
								 'Inventario Físico: Alm.:#vAlmcodigo# #vFecha#',
								 <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
								 0,
								  #session.Usucodigo# ,
								 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
						<cf_dbidentity1 datasource="#session.dsn#">
					</cfquery>
					<cf_dbidentity2 name="insertado" datasource="#session.dsn#">
					<cfset vEFid = insertado.identity >
					</cftransaction>				
				<cfelse>
					<cfquery datasource="#session.DSN#">
						insert into #errores#(codigo, error)
						values( '#vAlmcodigo#', 'Almacén #vAlmcodigo# no existe' )
					</cfquery>
				</cfif>
			
			</cfif>

		<!--- INSERTAR DETALLES DE INVENTARIO --->
		<cfelse>
			<!--- si estos valores estan en cero, significa que no se pudo recuperar el almacen ni se inserto un encabezado de IF --->
			<cfif vAlmacen neq 0 and vEFid neq 0 >
				<cfset vArticuloCod = trim(mid( trim(data.codigo), 5, len(data.codigo)))>
				<cfset vCantidad = trim(data.cantidad)>
				<cfif not isnumeric(vCantidad)>
					<cfset vCantidad = 0 >
				</cfif>
				
				<cfquery name="rsCodigoArt" datasource="#session.DSN#">
					select Aid
					from Articulos
					where Ecodigo =  #session.Ecodigo# 
					  and Acodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vArticuloCod#">
				</cfquery>
				<cfif len(trim(rsCodigoArt.Aid)) >
					<cfquery datasource="#session.DSN#">
						insert into DFisico( EFid, Aid, Ecodigo, DFcantidad, DFactual, DFdiferencia, DFcostoactual, DFtotal, BMUsucodigo, BMfechaalta )
						select #vEFid#, 
							   #rsCodigoArt.Aid#, 
							   #session.Ecodigo#, 
							   #vCantidad#, 
							   a.Eexistencia, 
							   #vCantidad#-a.Eexistencia, 
							   Ecostou, 
							   ((#vCantidad#-a.Eexistencia)*Ecostou), 
							   #session.Usucodigo#, 
							   <cf_dbfunction name="now">
						from Existencias a
						where a.Ecodigo= #session.Ecodigo# 
						and a.Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vAlmacen#">
						and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCodigoArt.Aid#">
					</cfquery>
				<cfelse>
					<cfquery datasource="#session.DSN#">
						insert into #errores#(codigo, error)
						values( '#vArticuloCod#', 'Artículo #vArticuloCod# no existe' )
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
	</cfif>
</cfoutput>

<cfquery name="rsErrores" datasource="#session.DSN#">
	select count(1) as cantidad
	from #errores#
</cfquery>
<cfif rsErrores.cantidad gt 0>
</cfif>
	<cfquery name="ERR" datasource="#session.DSN#">
		select codigo, error
		from #errores#
	</cfquery>
