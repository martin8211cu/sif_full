<cfcomponent>
	<cffunction name="CreaTransformacion" access="public" output="false" returntype="string">
		<cfargument name='Conexion' type='string' required='false'>
		<cfif (not isdefined("arguments.Conexion"))>
			<cfset arguments.Conexion = session.dsn>
		</cfif>
		<cf_dbtemp name="IN_Transformacion_V1" returnvariable="IN_Transformacion_TRANSFORMACION_NAME" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="identificacion"		type="numeric"		identity="yes">
			<cf_dbtempcol name="Acodigo"			type="char(15)"		mandatory="yes">
			<cf_dbtempcol name="idarticulo"   		type="numeric"      mandatory="no">
			<cf_dbtempcol name="invinicial"   		type="float"     	mandatory="yes">
			<cf_dbtempcol name="recepcion"   		type="float"     	mandatory="yes">
			<cf_dbtempcol name="prodcons"   		type="float"     	mandatory="yes">
			<cf_dbtempcol name="embarques"   		type="float"     	mandatory="yes">
			<cf_dbtempcol name="consumopropio"   	type="float"     	mandatory="yes">
			<cf_dbtempcol name="perdidaganancia"   	type="float"     	mandatory="yes">
			<cf_dbtempcol name="invfinal"   		type="float"        mandatory="yes">
			<cf_dbtempcol name="calcinvinicial"   	type="float"        mandatory="yes">
			<cf_dbtempcol name="calcrecepcion"  	type="float"        mandatory="yes">
			<cf_dbtempcol name="calcembarques"      type="float"        mandatory="yes">
			
			<cf_dbtempkey cols="identificacion">
		</cf_dbtemp>
		<cfset Request.transformacion = IN_Transformacion_TRANSFORMACION_NAME>
		<cfreturn IN_Transformacion_TRANSFORMACION_NAME>
	</cffunction>
	
	<cffunction name="IN_TransformacionProducto" access="public" returntype="query">
		<!--- Parámetros requeridos del método --->
		<cfargument hint="Id de Transformación" name="ETid" required="true" type="numeric">
		<!--- Parámetros no requeridos del método --->
		<cfargument hint="Datasource" name="Conexion" required="false" type="string">
		<cfargument hint="Empresa" name="Ecodigo" required="false" type="numeric">
		<cfargument hint="Usuario" name="Usucodigo" required="false" type="numeric">
		<cfargument default="A" hint="	E = Ejecuta, 	
										R = Reporte de información, 
										V = Reporte de Verificación de Conciliación (solo diferencias), 
										C = Reporte de Diferencias superiores a 1 barril" 
					name="Modo" required="false" type="string">
		<cfargument default="false" hint="Debug" name="Debug" required="false" type="boolean">
		<cfargument default="false" hint="RollBack" name="RollBack" required="false" type="boolean">
		<!--- TipoLinea en Tabla TransformacionProducto:
			10  Diferencias por Inventario Inicial    
			20 Consumo propio / producción
			30 Costo de la Producion
			40 Consumo Propio
			50 Perdida / Ganancia
			60 Entrada por Devolución
			70 Salida de Inventario por Venta
		--->
		<!--- Variables privadas del método --->
		<!--- Variables públicas creadas en el método --->
		<!--- Defaults para parámetros. No se pusieron en el cfargument porque cuando vienen porque no hay session, siempre ejecuta la sentencia del default y se cae. --->
		<cfif (not isdefined("Arguments.Conexion"))>
			<cfset Arguments.Conexion = Session.Dsn>
		</cfif>
		<cfif (not isdefined("Arguments.Ecodigo"))>
			<cfset Arguments.Ecodigo = Session.Ecodigo>
		</cfif>
		<cfif (not isdefined("Arguments.Usucodigo"))>
			<cfset Arguments.Usucodigo = Session.Usucodigo>
		</cfif>
		
		<!--- Crea tablas temporales requeridas --->
		<cfinvoke method="CreaTransformacion"  returnvariable="TRANSFORMACION"/>

		<!--- Inicio *** --->
			
			<!--- 1 Validaciones Iniciales --->
			<!--- 1.1 Validación de integridad de la Transformación --->
			<cfquery name="rs" datasource="#Arguments.Conexion#">
				select 1 
				from ETransformacion 
				where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#"> 
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			</cfquery>
			<cfif rs.recordcount eq 0>
				<cf_errorCode	code = "51228" msg = "Error en IN_TransformacionProducto. No existe la Transformación. Proceso Cancelado!">
			</cfif>
			
			<!--- 2. Definiciones --->
			<!--- 2.0 Encabezado de la transformacion --->
			<cfquery name="rsETransformacion" datasource="#Arguments.Conexion#">
				select ETid, ETdocumento, Ecodigo, Usucodigo, Ulocalizacion, ETfecha, ETfechaProc, ETcostoProd, ETobservacion
				from ETransformacion
				where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
			</cfquery>
			<cfset lvarfechadoc = rsETransformacion.ETfecha>

			<cfif (len(lvarfechadoc) EQ 0)>
				<cfset QuerySetCell(rsETransformacion,"ETfecha",CreateDate(Year(Now()),Month(Now()),Day(Now())))>					
				<cfset lvarfechadoc = rsETransformacion.ETfecha>
			</cfif>
			<!--- 2.1 Departamento para inserción en TransformacionProducto --->
			<cfquery name="rsDepartamento" datasource="#Arguments.Conexion#">
				select min(Dcodigo) as departamento
				from Departamentos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			</cfquery>
			<!--- 2.2 Oficina para inserción en TransformacionProducto --->
			<cfquery name="rsOficina" datasource="#Arguments.Conexion#">
				select min(Ocodigo) as oficina
				from Oficinas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			</cfquery>
			<!--- 2.3 Almacen para inserción en TransformacionProducto --->
			<cfquery name="rsAlmacen" datasource="#Arguments.Conexion#">
				select min(Aid) as almacen
				from Almacen
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			</cfquery>
			<!--- 2.4 Periodo de Auxiliares --->
			<cfquery name="rsPeriodo" datasource="#Arguments.Conexion#">
				select Pvalor as periodo from Parametros where Pcodigo = 50
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			</cfquery>
			<cfif rs.recordcount eq 0>
				<cf_errorCode	code = "51179" msg = "Error en IN_AjusteInventario. No se ha definido el Periodo de Auxiliares. Proceso Cancelado!">
			</cfif>
			<!--- 2.5 Mes de Auxiliares --->
			<cfquery name="rsMes" datasource="#Arguments.Conexion#">
				select Pvalor as mes from Parametros where Pcodigo = 60
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			</cfquery>
			<cfif rs.recordcount eq 0>
				<cf_errorCode	code = "51180" msg = "Error en IN_AjusteInventario. No se ha definido el Mes de Auxiliares. Proceso Cancelado!">
			</cfif>
			<!--- 2.6 Moneda Local --->
			<cfquery name="rsMonLoc" datasource="#Arguments.Conexion#">
				select Mcodigo as monloc from Empresas where 
				Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			</cfquery>
			
			<!--- 3. Operaciones --->
			<cftransaction>
				
				<!--- 
							******************************************************
										Inicio de la Transformación
							******************************************************
				--->
				
				<cfquery datasource="#Arguments.Conexion#">
					insert into #TRANSFORMACION# 
						(Acodigo, idarticulo, invinicial, recepcion, prodcons, embarques, consumopropio, perdidaganancia, invfinal, calcinvinicial, calcrecepcion, calcembarques)
					select 
						a.Acodigo, a.Aid, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00
					from Articulos a
						inner join DTransformacion b
						on b.Acodigo = a.Acodigo
						and b.ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
					group by a.Acodigo, a.Aid
					order by a.Acodigo
				</cfquery>
				
				<cfquery datasource="#Arguments.Conexion#">
					update #TRANSFORMACION# 
					set 
						invinicial = coalesce((select sum(DTinvinicial) from DTransformacion where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#"> and Acodigo = #TRANSFORMACION#.Acodigo), 0.00),
						recepcion = coalesce((select sum(DTrecepcion) from DTransformacion where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#"> and Acodigo = #TRANSFORMACION#.Acodigo), 0.00), 
						prodcons = coalesce((select sum(DTprodcons) from DTransformacion where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#"> and Acodigo = #TRANSFORMACION#.Acodigo), 0.00), 
						embarques = coalesce((select sum(DTembarques) from DTransformacion where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#"> and Acodigo = #TRANSFORMACION#.Acodigo), 0.00), 
						consumopropio = coalesce((select sum(DTconsumopropio) from DTransformacion where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#"> and Acodigo = #TRANSFORMACION#.Acodigo), 0.00), 
						perdidaganancia = coalesce((select sum(DTperdidaganancia) from DTransformacion where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#"> and Acodigo = #TRANSFORMACION#.Acodigo), 0.00), 
						invfinal = coalesce((select sum(DTinvfinal) from DTransformacion where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#"> and Acodigo = #TRANSFORMACION#.Acodigo), 0.00)
				</cfquery>
				
				<cfquery datasource="#Arguments.Conexion#">
					update #TRANSFORMACION# 
					set calcinvinicial = coalesce((
						select sum(EIexistencia)
						from ExistenciaInicial b
						where b.Aid = #TRANSFORMACION#.idarticulo
						   and b.EIperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPeriodo.periodo#">
						   and b.EIMes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMes.mes#">), 0)
				</cfquery>
				
				<cfquery datasource="#Arguments.Conexion#">
					update #TRANSFORMACION# 
					set calcrecepcion = coalesce((
						select sum(Kunidades)
						from Kardex a
						where a.Aid = #TRANSFORMACION#.idarticulo
						   and a.Kperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPeriodo.periodo#">
						   and a.Kmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMes.mes#">
						   and a.Ktipo = 'E'), 0)
				</cfquery>
				
				<cfquery datasource="#Arguments.Conexion#">
					update #TRANSFORMACION# 
					set calcembarques = 
						coalesce(
							(
								select sum(a.CCVPcantidad * case when t.CCTtipo = 'D' then 1.00 else -1.00 end)
								from CCVProducto a, CCTransacciones t
								where a.Aid = #TRANSFORMACION#.idarticulo
								  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
								  and t.CCTcodigo = a.CCTcodigo
								  and t.Ecodigo = a.Ecodigo
								  and a.CCVPestado = 0
								  and a.DDtipo 	   = 'A'
							), 0)
				</cfquery>
				
				<!--- 
							******************************************************
										  Reporte de información
							******************************************************
				--->
				<cfif Arguments.Modo EQ "R">
					<cfquery name="rsreturn" datasource="#Arguments.Conexion#">
						select 
							a.Acodigo as CodArticulo, 
							b.Adescripcion as Articulo,
							invinicial as  IncialProduccion, 
							calcinvinicial as InicialPropio, 
							(invinicial - calcinvinicial) as DiferenciaInicial,
							recepcion as RecepProduccion, 
							calcrecepcion  as RecepPropio, 
							(recepcion - calcrecepcion) as DiferenciaRecepcion,
							embarques as EmbarqueProduccion, 
							calcembarques as EmbarquePropio,
							(embarques - calcembarques) as DiferenciaEmbarque,
							prodcons as ProduccionConsumo, 
							consumopropio as ConsumoPropio, 
							perdidaganancia as PerdidaGanancia, 
							invfinal as InventarioFinal,
							idarticulo as IdArticulo 
						from #TRANSFORMACION# a inner join Articulos b on a.idarticulo = b.Aid
						order by a.Acodigo
					</cfquery>
					<cfreturn rsreturn>
				</cfif>
				<!--- 
							******************************************************
										Fin Reporte de información
							******************************************************
				--->
				
				<!--- 
							******************************************************
										 Reporte de Verificación
							******************************************************
				--->
				<cfif Arguments.Modo EQ "V">
					<cfquery name="rsreturn" datasource="#Arguments.Conexion#">
						select 
							a.Acodigo as CodArticulo, 
							b.Adescripcion as Articulo,
							invinicial as  IncialProduccion, 
							calcinvinicial as InicialPropio, 
							(invinicial - calcinvinicial) as DiferenciaInicial,
							recepcion as RecepProduccion, 
							calcrecepcion  as RecepPropio, 
							(recepcion - calcrecepcion) as DiferenciaRecepcion,
							embarques as EmbarqueProduccion, 
							calcembarques as EmbarquePropio,
							(embarques - calcembarques) as DiferenciaEmbarque,
							prodcons as ProduccionConsumo, 
							consumopropio as ConsumoPropio, 
							perdidaganancia as PerdidaGanancia, 
							invfinal as InventarioFinal,
							idarticulo as IdArticulo 
						from #TRANSFORMACION# a inner join Articulos b on a.idarticulo = b.Aid
						where (
						round(calcinvinicial,2) != round(invinicial,2) 
						or 
						round(calcrecepcion,2) != round(recepcion,2) 
						or 
						round(calcembarques,2) != round(embarques,2)
						)
						order by a.Acodigo
					</cfquery>
					<cfreturn rsreturn>
				</cfif>
				<!--- 
							******************************************************
										Fin Reporte de Verificación
							******************************************************
				--->
				
				<!--- 
							******************************************************
										  Reporte de diferecias
							******************************************************
				--->
				<cfif Arguments.Modo EQ "C">
					<cfquery name="rsreturn" datasource="#Arguments.Conexion#">
						select 
							a.Acodigo as CodArticulo, 
							b.Adescripcion as Articulo,
							invinicial as  IncialProduccion, 
							calcinvinicial as InicialPropio, 
							(invinicial - calcinvinicial) as DiferenciaInicial,
							recepcion as RecepProduccion, 
							calcrecepcion  as RecepPropio, 
							(recepcion - calcrecepcion) as DiferenciaRecepcion,
							embarques as EmbarqueProduccion, 
							calcembarques as EmbarquePropio,
							(embarques - calcembarques) as DiferenciaEmbarque,
							prodcons as ProduccionConsumo, 
							consumopropio as ConsumoPropio, 
							perdidaganancia as PerdidaGanancia, 
							invfinal as InventarioFinal,
							idarticulo as IdArticulo 
						from #TRANSFORMACION# a inner join Articulos b on a.idarticulo = b.Aid
						where (
						abs(round(calcinvinicial,2) - round(invinicial,2)) > 1
						or 
						abs(round(calcrecepcion,2) - round(recepcion,2)) > 1
						or 
						abs(round(calcembarques,2) - round(embarques,2)) > 1
						)
						order by a.Acodigo
					</cfquery>
					<cfreturn rsreturn>
				</cfif>
				<!--- 
							******************************************************
										Fin de Reporte de diferecias

							******************************************************
				--->
				
				<!--- Validaciones Pervias a la Transformación --->
				<!--- V1 Valida que no existan códigos de artículos inválidos --->
				<cfquery name="rsVal1" datasource="#Arguments.Conexion#">
					select 1 from #TRANSFORMACION# where idarticulo < 1
				</cfquery>
				<cfif rsVal1.recordcount GT 0>
					<cf_errorCode	code = "51229" msg = "Error en IN_TransformacionProducto. Existen Códigos de Artículos Incorrectos. Proceso Cancelado!">
				</cfif>
				<!--- V2 Valida que existan artídulos --->
				<cfquery name="rsVal1" datasource="#Arguments.Conexion#">
					select 1 from #TRANSFORMACION#
				</cfquery>
				<cfif rsVal1.recordcount EQ 0>
					<cf_errorCode	code = "51230" msg = "Error en IN_TransformacionProducto. No Existen Artículos. Proceso Cancelado!">
				</cfif>
				
				<!--- Inicio de las Operaciones --->
				<cfquery datasource="#Arguments.Conexion#">
					update DTransformacion
					set Aid = (select b.idarticulo
						from #TRANSFORMACION# b
						where b.Acodigo = DTransformacion.Acodigo)
					where DTransformacion.ETid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
				</cfquery>
				
				<!---  Eliminar registros sin postear de tabla de TransformacionProducto --->
    				<cfquery datasource="#Arguments.Conexion#">
					delete from TransformacionProducto 
					where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
					  and TPestado = 0
				</cfquery>
				
				<!--- Procesar las diferencias en el inventario inicial --->
				
				<!---  No se procesan las diferencias de inventario para garantizar que se realicen conciliaciones.  M.Esquivel 12/4/2005
				
				<cfquery name="rsTransformacion" datasource="#Arguments.Conexion#">
					select idarticulo, invinicial, calcinvinicial, Acodigo, calcinvinicial - invinicial as diferencia, null as costolin
					from #TRANSFORMACION#
					where invinicial != calcinvinicial
				</cfquery>
				<cfloop query="rsTransformacion">
					<cfquery datasource="#Arguments.Conexion#">
						insert into TransformacionProducto (
						Ecodigo, ETid, Aid, Alm_Aid, TPestado, 
						Tipmov, descripcion, cant, costolin, costou, 
						costototal, TipoES, Dcodigo, Ocodigo, CFid, 
						TC, TipoDoc, documento, fechadoc, referencia, BMUsucodigo, fechalta, invinicial, calcinvinicial, TipoLinea, Acodigo)
						values 
						(<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTransformacion.idarticulo#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAlmacen.almacen#">, 
						0, 'A', 'Diferencias en Inventario Inicial', 
						<cfqueryparam cfsqltype="cf_sql_money" value="#abs(rsTransformacion.diferencia)#">, 
						null, null, null, 
						<cfif rsTransformacion.diferencia gt 0.00>
						'E' 
						<cfelse>
						'S'
						</cfif>,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDepartamento.departamento#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOficina.oficina#">, 
						null, 1.00, null, 
						<cfqueryparam cfsqltype="cf_sql_char" value="#rsETransformacion.ETdocumento#">, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(lvarfechadoc)#">, 
						'IN', 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(now())#">, 
						<cfqueryparam cfsqltype="cf_sql_money" value="#invinicial#">, 
						<cfqueryparam cfsqltype="cf_sql_money" value="#calcinvinicial#">, 
						10, 
						<cfqueryparam cfsqltype="cf_sql_char" value="#rsTransformacion.Acodigo#">)
					</cfquery>
				</cfloop>
				
				--->
				
				<cfquery name="rsTransformacion" datasource="#Arguments.Conexion#">
					select idarticulo,  invinicial, recepcion, prodcons, embarques, consumopropio, perdidaganancia, invfinal, null as costolin
					from #TRANSFORMACION#
					where prodcons != 0 or consumopropio != 0 or perdidaganancia != 0
				</cfquery>
				
				<cfloop query="rsTransformacion">
					<cfquery name="rsArticulo" datasource="#Arguments.Conexion#">
						select coalesce(b.CTDcosto,a.Acosto,1) as costo_estandar, coalesce(Aconsumo,0) as Aconsumo, Acodigo
						from Articulos a 
							left outer join CostoProduccionSTD b 
							  on a.Aid = b.Aid 
							  and a.Ecodigo = b.Ecodigo
							  and b.CTDperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPeriodo.periodo#">
							  and b.CTDmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMes.mes#">
						where a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTransformacion.idarticulo#">
						  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
					</cfquery>

					<!--- a. Procesar consumo / produccion --->
					<cfif rsTransformacion.prodcons NEQ 0>
						<cfif rsTransformacion.prodcons LT 0>
							<!--- Consumo propio. Se contabiliza al costo promedio --->
							<cfquery datasource="#Arguments.Conexion#">
								insert into TransformacionProducto (
								Ecodigo, ETid, Aid, Alm_Aid, TPestado, 
								Tipmov, descripcion, cant, costolin, costou, 
								costototal, TipoES, Dcodigo, Ocodigo, CFid, 
								TC, TipoDoc, documento, fechadoc, referencia, BMUsucodigo, fechalta, TipoLinea, Acodigo)
								values 
								(<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTransformacion.idarticulo#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAlmacen.almacen#">, 
								0, 'P', 'Consumo propio', 
								<cfqueryparam cfsqltype="cf_sql_money" value="#abs(rsTransformacion.prodcons)#">, 
								null, null, null, 'S', 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDepartamento.departamento#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOficina.oficina#">, 
								null, 1.00, null, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#rsETransformacion.ETdocumento#">, 
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(lvarfechadoc)#">, 
								'IN', 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Now())#">, 
								20, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#rsArticulo.Acodigo#">)
							</cfquery>
						<cfelse>
							<!--- Definir el costo de la produccion --->
							<cfQuery name="rsCCVProducto" datasource="#Arguments.Conexion#">
								select coalesce(sum(a.CCVPpreciouloc * case when t.CCTtipo = 'D' then 1.00 else -1.00 end),0.00) as costolin
								from CCVProducto a, CCTransacciones t
								where a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTransformacion.idarticulo#">
								  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
								  and a.CCVPestado	= 0
								  and a.DDtipo 		= 'A'
								  and t.Ecodigo = a.Ecodigo
								  and t.CCTcodigo = a.CCTcodigo
							</cfQuery>
							<cfset QuerySetCell(rsTransformacion, 'costolin', rsCCVProducto.costolin, CurrentRow)>
							<cfquery name="rsKardex" datasource="#Arguments.Conexion#">
								select coalesce(sum(Kcosto),0.00) as costo
								from Kardex 
								where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTransformacion.idarticulo#">
									and Ktipo = 'E'
									and Kperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPeriodo.periodo#">
									and Kmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMes.mes#">
							</cfquery>
							<cfset querysetcell(rsTransformacion,'costolin',costolin-rsKardex.costo+(rsTransformacion.invfinal-rsTransformacion.invinicial)*rsArticulo.costo_estandar,CurrentRow)>
							<cfquery datasource="#Arguments.Conexion#">
								insert into TransformacionProducto (
								Ecodigo, ETid, Aid, Alm_Aid, TPestado, 
								Tipmov, descripcion, cant, costolin, costou, 
								costototal, TipoES, Dcodigo, Ocodigo, CFid, 
								TC, TipoDoc, documento, fechadoc, referencia, BMUsucodigo, fechalta, TipoLinea, Acodigo)
								values 
								(<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTransformacion.idarticulo#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAlmacen.almacen#">, 
								0, 'P', 'Costo de la producción', 
								<cfqueryparam cfsqltype="cf_sql_money" value="#rsTransformacion.prodcons#">, 
								<cfif len(trim(rsTransformacion.costolin)) GT 0 and rsTransformacion.costolin GT 0>
									<cfqueryparam cfsqltype="cf_sql_money" value="#rsTransformacion.costolin#">, 
								<cfelse>
									null,
								</cfif>
								null, null, 'E', 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDepartamento.departamento#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOficina.oficina#">, 
								null, 1.00, null, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#rsETransformacion.ETdocumento#">, 
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(lvarfechadoc)#">, 
								'IN', 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(now())#">, 
								30, 
								<cfqueryparam cfsqltype="cf_sql_char" value="#rsArticulo.Acodigo#">)
							</cfquery>
						</cfif>
					</cfif>
					
					<!--- b. Procesar consumo propio --->
					<cfif rsTransformacion.consumopropio NEQ 0>
						<cfset QuerySetCell(rsTransformacion, 'costolin', 0.00, CurrentRow)>
						<cfquery datasource="#Arguments.Conexion#">
							insert into TransformacionProducto (
							Ecodigo, ETid, Aid, Alm_Aid, TPestado, 
							Tipmov, descripcion, cant, costolin, costou, 
							costototal, TipoES, Dcodigo, Ocodigo, CFid, 
							TC, TipoDoc, documento, fechadoc, referencia, BMUsucodigo, fechalta, TipoLinea, Acodigo)
							values 
							(<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTransformacion.idarticulo#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAlmacen.almacen#">, 
							0, 'R', 'Consumo Propio', 
							<cfqueryparam cfsqltype="cf_sql_money" value="#abs(rsTransformacion.consumopropio)#">, 
							null, null, null, 
							<cfif rsTransformacion.consumopropio gt 0>
								'S'
							<cfelse>
								'E'
							</cfif>,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDepartamento.departamento#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOficina.oficina#">, 
							null, 1.00, null, 
							<cfqueryparam cfsqltype="cf_sql_char" value="#rsETransformacion.ETdocumento#">, 
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(lvarfechadoc)#">, 
							'IN', 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Now())#">, 
							40, 
							<cfqueryparam cfsqltype="cf_sql_char" value="#rsArticulo.Acodigo#">)
						</cfquery>
					</cfif>
					
					<!--- c. Procesar Perdida / Ganancia --->
					<cfif rsTransformacion.perdidaganancia NEQ 0>
						<cfset QuerySetCell(rsTransformacion, 'costolin', 0.00, CurrentRow)>
						<cfquery datasource="#Arguments.Conexion#">
							insert into TransformacionProducto (
							Ecodigo, ETid, Aid, Alm_Aid, TPestado, 
							Tipmov, descripcion, cant, costolin, costou, 
							costototal, TipoES, Dcodigo, Ocodigo, CFid, 
							TC, TipoDoc, documento, fechadoc, referencia, BMUsucodigo, fechalta, TipoLinea, Acodigo)
							values 
							(<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTransformacion.idarticulo#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAlmacen.almacen#">, 
							0, 'A', 'Perdida / Ganancia', 
							<cfqueryparam cfsqltype="cf_sql_money" value="#abs(rsTransformacion.perdidaganancia)#">, 
							null, null, null, 
							<cfif rsTransformacion.perdidaganancia GT 0>
								 'S', 
							<cfelse>
								 'E', 
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDepartamento.departamento#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOficina.oficina#">, 
							null, 1.00, null, 
							<cfqueryparam cfsqltype="cf_sql_char" value="#rsETransformacion.ETdocumento#">, 
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(lvarfechadoc)#">, 
							'IN', 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Now())#">, 
							50, 
							<cfqueryparam cfsqltype="cf_sql_char" value="#rsArticulo.Acodigo#">)
						</cfquery>
					</cfif>
					
				</cfloop><!--- rsTransformacion --->
				
				<!--- Procesar la tabla CCVProducto DDtipo=Articulos de Inventario --->
				<cfquery name="rsCCVProducto" datasource="#Arguments.Conexion#">
					select CCVPid,  CCVP.CCTcodigo,  CCVP.Ddocumento, 
						CCVP.SNcodigo, CCVP.Dfecha , CCVP.CCVPusuario, 
						CCVP.CCVPfecha,  CCVP.Aid,  CCVP.Alm_Aid,  CCVP.Ocodigo, 
						CCVP.Dcodigo, CCVP.CCVPcantidad, CCVP.CCVPpreciouloc,  
						CCVP.CCVPpreciouori, CCVP.CCVPestado, b.CCTtipo, null as costolin
					from CCVProducto CCVP inner join CCTransacciones b 
						on CCVP.Ecodigo = b.Ecodigo
						and CCVP.CCTcodigo = b.CCTcodigo
					where CCVP.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
						and CCVP.CCVPestado = 0
						and CCVP.DDtipo = 'A'		<!--- PARA EXCLUIR DDtipo=Ordenes Comerciales en Transito --->
						<!---
						and CCVP.CCVPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPeriodo.periodo#">
						and CCVP.CCVPmes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMes.mes#">

						and <cf_dbfunction name="date_part" args="yy,CCVP.Dfecha" datasource="#Arguments.Conexion#"> = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPeriodo.periodo#">
						and <cf_dbfunction name="date_part" args="mm,CCVP.Dfecha" datasource="#Arguments.Conexion#"> = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMes.mes#">
						--->
				</cfquery>
				<cfif rsCCVProducto.recordcount and (len(rsCCVProducto.CCVPfecha) EQ 0)><cfset QuerySetCell(rsCCVProducto,"CCVPfecha",CreateDate(Year(Now()),Month(Now()),Day(Now())))></cfif>
				<cfloop query="rsCCVProducto">
					<cfquery name="rsArticulo" datasource="#Arguments.Conexion#">
						select Acodigo
						from Articulos
						where Aid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsCCVProducto.Aid#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					</cfquery>
					<cfif rsCCVProducto.CCTtipo EQ "D">
						<!--- Salida de Inventario por Venta --->
						<cfquery datasource="#Arguments.Conexion#">
							insert into TransformacionProducto (
							Ecodigo, ETid, Aid, Alm_Aid, TPestado, 
							Tipmov, descripcion, cant, costolin, costou, 
							costototal, TipoES, Dcodigo, Ocodigo, CFid, 
							TC, TipoDoc, documento, fechadoc, referencia, BMUsucodigo, fechalta, TipoLinea, Acodigo)
							values 
							(<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCCVProducto.Aid#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCCVProducto.Alm_Aid#">, 
							0, 'S', 'Salida de Inventario por Venta', 
							<cfqueryparam cfsqltype="cf_sql_money" value="#rsCCVProducto.CCVPcantidad#">, 
							null, null, null, 
							'S', 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCCVProducto.Dcodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCCVProducto.Ocodigo#">, 
							null, 1.00, 
							<cfqueryparam cfsqltype="cf_sql_char" value="#rsCCVProducto.CCTcodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_char" value="#rsCCVProducto.Ddocumento#">, 
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(lvarfechadoc)#">, 
							'IN', 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Now())#">, 
							70, 
							<cfqueryparam cfsqltype="cf_sql_char" value="#rsArticulo.Acodigo#">)
						</cfquery>
					<cfelse>
						<!--- Entrada de Inventario por Devolución (NC) --->
						<cfquery datasource="#Arguments.Conexion#">
							insert into TransformacionProducto (
							Ecodigo, ETid, Aid, Alm_Aid, TPestado, 
							Tipmov, descripcion, 
							cant, 
							costolin, costou, costototal, 
							TipoES, Dcodigo, Ocodigo, CFid, 
							TC, TipoDoc, documento, fechadoc, referencia, BMUsucodigo, fechalta, TipoLinea, Acodigo)
							values 
							(<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCCVProducto.Aid#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCCVProducto.Alm_Aid#">, 
							0, 'S', 'Entrada a Inventario por Devolución (NC)', 
							<cfqueryparam cfsqltype="cf_sql_money" value="#rsCCVProducto.CCVPcantidad#">, 
							null, null, null, 
							'E', 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCCVProducto.Dcodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCCVProducto.Ocodigo#">, 
							null, 1.00, 
							<cfqueryparam cfsqltype="cf_sql_char" value="#rsCCVProducto.CCTcodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_char" value="#rsCCVProducto.Ddocumento#">, 
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(lvarfechadoc)#">, 
							'IN', 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Now())#">, 
							60, 
							<cfqueryparam cfsqltype="cf_sql_char" value="#rsArticulo.Acodigo#">)
						</cfquery>
					</cfif>
				</cfloop>
				
				<cfquery datasource="#Arguments.Conexion#">
					update TransformacionProducto 
					   set costou = round(costolin / cant, 4)
					 where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
					   and Tipmov = 'P'
					   and costolin is not null
					   and cant != 0
				</cfquery>
				
				<cfquery datasource="#Arguments.Conexion#">
					update TransformacionProducto 
					   set costototal = costolin 
					 where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#"> 
					   and costou is not null
				</cfquery>
								
				<!--- 
							******************************************************
										  Fin de la Transformación
							******************************************************
				--->
				
				<!--- Debug: Después de las operaciones --->
				<cfif Arguments.Debug>
					<cfquery name="rsDebug" datasource="#Arguments.Conexion#">
							select * from #TRANSFORMACION#
					</cfquery>
					<cfdump var="#rsDebug#" label="TRANSFORMACION">
					<cfquery name="rsDebug" datasource="#Arguments.Conexion#">
							select * from TransformacionProducto
							where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					</cfquery>
					<cfdump var="#rsDebug#" label="TransformacionProducto">
					<cfquery name="rsDebug" datasource="#Arguments.Conexion#">
						select * 
						from ETransformacion 
						where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					</cfquery>
					<cfdump var="#rsDebug#" label="ETransformacion">
					<cfquery name="rsDebug" datasource="#Arguments.Conexion#">
						select * 
						from DTransformacion 
						where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
					</cfquery>
					<cfdump var="#rsDebug#" label="DTransformacion">
				</cfif>
	
				<!--- RollBack: Deshace todos los cambios --->
				<cfif Arguments.RollBack>
					<cftransaction action="rollback"/>
				</cfif>
			</cftransaction>
			
			
			<cfquery name="rsreturn" datasource="#Arguments.Conexion#">
				select 'OK' as result from dual
			</cfquery>
		<!--- Fin    *** --->
		<!--- Retorno de Resultados --->
		<cfreturn rsreturn>
	</cffunction>
</cfcomponent>

