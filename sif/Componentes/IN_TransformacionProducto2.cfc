<cfcomponent>
	<cffunction name="IN_TransformacionProducto2" access="public" returntype="query">
		<!--- Parámetros requeridos del método --->
		<cfargument hint="Id de Transformación" name="ETid" required="true" type="numeric">
		<!--- Parámetros no requeridos del método --->
		<cfargument hint="Datasource" 	name="Conexion" 	required="false" type="string">
		<cfargument hint="Empresa" 		name="Ecodigo" 		required="false" type="numeric">
		<cfargument hint="Usuario" 		name="Usucodigo" 	required="false" type="numeric">
		<!--- Parámetro que indica el comportamiento del Componente --->
		<cfargument hint="	Modo = Debug del SP
							E = Ejecuta, 	
							R = Reporte de información, 
							V = Reporte de Verificación de Conciliación (solo diferencias), 
							C = Reporte de Diferencias superiores a 1 barril"
										name="Modo" 		required="false" type="string" 	default="A">
		<!--- Parámetros de Debug --->
		<cfargument hint="Debug" 		name="Debug" 		required="false" type="boolean" default="false">
		<cfargument hint="RollBack" 	name="RollBack" 	required="false" type="boolean" default="false">

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
		
		<!--- 
			Defaults para parámetros. 
			No se pusieron en el cfargument porque cuando vienen porque no hay session, 
			siempre ejecuta la sentencia del default y se cae. 
		--->
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
		<cfinvoke component="sif.Componentes.IN_TransformacionProducto" 	method="CreaTransformacion"  	returnvariable="TRANSFORMACION"/>
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" 				method="CreaIntarc" 			returnvariable="INTARC"/>
		<cfinvoke component="sif.Componentes.IN_PosteoLin" 					method="CreaIdKardex"  			returnvariable="IDKARDEX"/>
		
		<!--- Inicio --->
        <cfinclude template="../Utiles/sifConcat.cfm">
		<!--- 1. Validaciones --->
		<!--- 2. Definiciones y Validaciones --->
			<!--- 2.1 ETransfdormacion --->
			<cfquery name="rsETransformacion" datasource="#Arguments.Conexion#">
				select ETid, ETdocumento, ETfecha, ETfechaProc, ETcostoProd, ETobservacion
				from ETransformacion
				where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			</cfquery>
			<cfset lvarETfecha = rsETransformacion.ETfecha>
			<cfif rsETransformacion.recordcount eq 0>
				<cf_errorCode	code = "51231" msg = "Error en IN_TransformacionProducto2. El Código de Transformación es Incorrecto. Proceso Cancelado!">
			</cfif>
			<!--- 2.2 Periodo de Auxiliares --->
			<cfquery name="rsPeriodo" datasource="#Arguments.Conexion#">
				select Pvalor as periodo from Parametros 
				where Pcodigo = 50
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			</cfquery>
			<cfif rsPeriodo.recordcount eq 0>
				<cf_errorCode	code = "51232" msg = "Error en IN_TransformacionProducto2. No se ha definido el Periodo de Auxiliares. Proceso Cancelado!">
			</cfif>
			<!--- 2.3 Mes de Auxiliares --->
			<cfquery name="rsMes" datasource="#Arguments.Conexion#">
				select Pvalor as mes from Parametros 
				where Pcodigo = 60
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			</cfquery>
			<cfif rsMes.recordcount eq 0>
				<cf_errorCode	code = "51233" msg = "Error en IN_TransformacionProducto2. No se ha definido el Mes de Auxiliares. Proceso Cancelado!">
			</cfif>
			<!--- 2.4 Moneda Local --->
			<cfquery name="rsMonLoc" datasource="#Arguments.Conexion#">
				select Mcodigo as monloc from Empresas 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			</cfquery>
			<cfif rsMonLoc.recordcount eq 0>
				<cf_errorCode	code = "51234" msg = "Error en IN_TransformacionProducto2. No se ha La Moneda de la Empresa. Proceso Cancelado!">
			</cfif>

		<!--- 3. Operaciones --->
		<cftransaction>			
			<!--- 3.1 IN_PosteoLin --->
			<cfquery name="rsTransformacion" datasource="#Arguments.Conexion#">
				select TPid, Aid, Alm_Aid, Tipmov, descripcion, cant, costolin, costou, costototal, TipoES, Dcodigo, Ocodigo, CFid, TC, TipoDoc, documento, fechadoc, referencia, TipoLinea, invinicial, calcinvinicial
				from TransformacionProducto
				where TPestado = 0
				  and ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				  order by TipoLinea, TPid
			</cfquery>
			<cfloop query="rsTransformacion">
				<cfinvoke 
					component		= "sif.Componentes.IN_PosteoLin" 
					method			= "IN_MonedaValuacion"
					returnvariable	= "LvarCOSTOS"
	
					Conexion	="#Arguments.Conexion#"
					Ecodigo		="#Arguments.Ecodigo#"
					tcFecha		="#rsTransformacion.fechadoc#"				<!--- Fecha tipo de Cambio --->
				/>
				<cfif ListFind('10,20,40,50,60,70',rsTransformacion.TipoLinea) or len(trim(rsTransformacion.CostoLin)) EQ 0>
					<!--- TipoLinea en Tabla TransformacionProducto:
						10  Diferencias por Inventario Inicial    
						20 Consumo propio / producción
						40 Consumo Propio
						50 Perdida / Ganancia
						60 Entrada por Devolución
						70 Salida de Inventario por Venta
					--->
					<cfset LvarObtenerCosto		= true>
					<cfset LvarMcodigoValuacion	= -1>
					<cfset LvarCostoValuacion	= 0>
					<cfset LvarCostoLocal		= 0>

					<cfset QuerySetCell(rsTransformacion,'costolin',0.00,rsTransformacion.CurrentRow)>
				<cfelse>
					<!--- TipoLinea en Tabla TransformacionProducto:
						30 Costo de la Producion
					--->
					<cfset LvarObtenerCosto		= false>
					<cfset LvarMcodigoValuacion	= LvarCOSTOS.VALUACION.Mcodigo>
					<cfset LvarCostoValuacion	= rsTransformacion.CostoLin>
					<cfset LvarCostoLocal		= rsTransformacion.CostoLin * LvarCOSTOS.VALUACION.TC>
				</cfif>
				
				
				<cfinvoke 
					component="sif.Componentes.IN_PosteoLin" 
					method="IN_PosteoLin"  
					returnvariable="LvarLINEA"

					Aid="#rsTransformacion.Aid#"
					Alm_Aid="#rsTransformacion.Alm_Aid#"
					Tipo_Mov="#rsTransformacion.TipMov#"
					Cantidad="#rsTransformacion.cant#"

					ObtenerCosto	= "#LvarObtenerCosto#"
					McodigoOrigen	= "#LvarMcodigoValuacion#"
					CostoOrigen		= "#LvarCostoValuacion#"
					CostoLocal		= "#LvarCostoLocal#"

					Tipo_ES="#rsTransformacion.TipoES#"
					Dcodigo="#rsTransformacion.Dcodigo#"
					Ocodigo="#rsTransformacion.Ocodigo#"
					TipoCambio="#rsTransformacion.TC#"
					Documento="#rsTransformacion.documento#"
					FechaDoc="#rsTransformacion.fechadoc#"
					Referencia="#rsTransformacion.referencia#"
					Conexion="#Arguments.Conexion#"
					Ecodigo="#Arguments.Ecodigo#"
                    Usucodigo="#session.Usucodigo#"  
					Debug="#Arguments.Debug#"
					RollBack="#Arguments.RollBack#"
					transaccionactiva="true"
				/>
					
				<cfset QuerySetCell(rsTransformacion,'costolin',LvarLINEA.VALUACION.Costo,rsTransformacion.CurrentRow)>
				<cfif LvarMcodigoValuacion EQ -1>
					<cfquery datasource="#Arguments.Conexion#">
						update TransformacionProducto 
						set costolin = <cfqueryparam cfsqltype="cf_sql_money" value="#rsTransformacion.costolin#" null="#rsTransformacion.costolin EQ 0.00#">
						where TPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTransformacion.TPid#">
						  and ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
						  and TPestado = 0
					</cfquery>
				</cfif>
			</cfloop>
			<!--- 3.2 Contabilización --->
			<!--- 3.2.1 Contabilización de Diferencias en Inventario Inicial --->
			<cfquery datasource="#Arguments.Conexion#">
				INSERT INTO #INTARC# 
					( 	
						INTORI, INTREL, INTDOC, INTREF, 
						INTTIP, 
						INTDES, 
						INTFEC, Periodo, Mes, 
						Ccuenta, Ocodigo, 
						Mcodigo, INTMOE, INTCAM, INTMON,CFid
					)
				select 
						'IN', 0, z.documento, ' ', 
						case when z.calcinvinicial - z.invinicial > 0.00 then 'D' else 'C' end,
						'Ajuste de Inv. Inicial ' + z.Acodigo, 
						convert(varchar, z.fechadoc, 112), #rsPeriodo.periodo#, #rsMes.mes#,
						c.IACinventario, z.Ocodigo, 
	
						#LvarCOSTOS.VALUACION.Mcodigo#, 
						abs(round(coalesce(z.costolin,0.00),2)),
						#LvarCOSTOS.VALUACION.TC#, 
						abs(round(coalesce(z.costolin*#LvarCOSTOS.VALUACION.TC#,0.00),2)),z.CFid
				from TransformacionProducto z
					inner join Articulos a 
						on a.Aid = z.Aid
						and a.Ecodigo = z.Ecodigo
					inner join Existencias b
						inner join IAContables c
							on c.IACcodigo = b.IACcodigo
							and c.Ecodigo = b.Ecodigo
						on b.Aid = z.Aid
						and b.Alm_Aid = z.Alm_Aid
						and b.Ecodigo = z.Ecodigo
				where z.ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
					and z.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and z.TipoLinea = 10
					and z.TPestado = 0
			</cfquery>
			<cfquery datasource="#Arguments.Conexion#">
				INSERT INTO #INTARC# 
					( 	
						INTORI, INTREL, INTDOC, INTREF, 
						INTTIP, 
						INTDES, 
						INTFEC, Periodo, Mes, 
						Ccuenta, Ocodigo, 
						Mcodigo, INTMOE, INTCAM, INTMON,CFid
					)
				select 
						'IN', 0, z.documento, ' ', 
						case when z.calcinvinicial - z.invinicial > 0.00 then 'C' else 'D' end,
						'Ajuste de Inv. Inicial ' + z.Acodigo, 
						convert(varchar, z.fechadoc , 112), #rsPeriodo.periodo#, #rsMes.mes#,
						c.IACingajuste,	z.Ocodigo, 
	
						#LvarCOSTOS.VALUACION.Mcodigo#, 
						abs(round(coalesce(z.costolin,0.00),2)),
						#LvarCOSTOS.VALUACION.TC#, 
						abs(round(coalesce(z.costolin*#LvarCOSTOS.VALUACION.TC#,0.00),2)),z.CFid
				from TransformacionProducto z
					inner join Articulos a 
						on a.Aid = z.Aid
						and a.Ecodigo = z.Ecodigo
					inner join Existencias b
						inner join IAContables c
							on c.IACcodigo = b.IACcodigo
							and c.Ecodigo = b.Ecodigo
						on b.Aid = z.Aid
						and b.Alm_Aid = z.Alm_Aid
						and b.Ecodigo = z.Ecodigo
				where z.ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
					and z.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and z.TipoLinea = 10
					and z.TPestado = 0
			</cfquery>
			<!--- 3.2.2 Contabilización del Costo de la Producción --->
			<cfquery datasource="#Arguments.Conexion#">
				INSERT INTO #INTARC# 
					( 	
						INTORI, INTREL, INTDOC, INTREF, 
						INTTIP, 
						INTDES, 
						INTFEC, Periodo, Mes, 
						Ccuenta, Ocodigo, 
						Mcodigo, INTMOE, INTCAM, INTMON,CFid
					)
				select 
						'IN', 0, z.documento, ' ', 
						case when z.TipoES = 'E' then 'D' else 'C' end,
						case when z.TipoES = 'E' then 'Produccion ' #_Cat# z.Acodigo else 'Consumo ' #_Cat# z.Acodigo end, 
						convert(varchar, z.fechadoc, 112), #rsPeriodo.periodo#, #rsMes.mes#,
						c.IACinventario, z.Ocodigo, 
	
						#LvarCOSTOS.VALUACION.Mcodigo#, 
						abs(round(coalesce(z.costolin,0.00),2)),
						#LvarCOSTOS.VALUACION.TC#, 
						abs(round(coalesce(z.costolin*#LvarCOSTOS.VALUACION.TC#,0.00),2)),z.CFid
				from TransformacionProducto z
					inner join Articulos a 
						on a.Aid = z.Aid
						and a.Ecodigo = z.Ecodigo
					inner join Existencias b
						inner join IAContables c
							on c.IACcodigo = b.IACcodigo
							and c.Ecodigo = b.Ecodigo
						on b.Aid = z.Aid
						and b.Alm_Aid = z.Alm_Aid
						and b.Ecodigo = z.Ecodigo
				where z.ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
					and z.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and z.TipoLinea in (20, 30)
					and z.TPestado = 0
			</cfquery>
			<cfquery datasource="#Arguments.Conexion#">
				INSERT INTO #INTARC# 
					( 	
						INTORI, INTREL, INTDOC, INTREF, 
						INTTIP, 
						INTDES, 
						INTFEC, Periodo, Mes, 
						Ccuenta, Ocodigo, 
						Mcodigo, INTMOE, INTCAM, INTMON,CFid 
					)
				select 
						'IN', 0, z.documento, ' ', 
						case when z.TipoES = 'E' then 'C' else 'D' end,
						case when z.TipoES = 'E' then 'Costo Produccion ' #_Cat# z.Acodigo else 'Costo Consumo ' #_Cat# z.Acodigo end, 
						convert(varchar, z.fechadoc, 112), #rsPeriodo.periodo#, #rsMes.mes#,
						case when z.cant > 0 then c.IACingajuste else c.IACgastoajuste end, z.Ocodigo, 
	
						#LvarCOSTOS.VALUACION.Mcodigo#, 
						abs(round(coalesce(z.costolin,0.00),2)),
						#LvarCOSTOS.VALUACION.TC#, 
						abs(round(coalesce(z.costolin*#LvarCOSTOS.VALUACION.TC#,0.00),2)),z.CFid
				from TransformacionProducto z
					inner join Articulos a 
						on a.Aid = z.Aid
						and a.Ecodigo = z.Ecodigo
					inner join Existencias b
						inner join IAContables c
							on c.IACcodigo = b.IACcodigo
							and c.Ecodigo = b.Ecodigo
						on b.Aid = z.Aid
						and b.Alm_Aid = z.Alm_Aid
						and b.Ecodigo = z.Ecodigo
				where z.ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
					and z.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and z.TipoLinea in (20, 30)
					and z.TPestado = 0
			</cfquery>
			<!--- 3.2.3 Contabilización del ConsumoPropio --->
			<cfquery datasource="#Arguments.Conexion#">
				INSERT INTO #INTARC# 
					( 	
						INTORI, INTREL, INTDOC, INTREF, 
						INTTIP, 
						INTDES, 
						INTFEC, Periodo, Mes, 
						Ccuenta, Ocodigo, 
						Mcodigo, INTMOE, INTCAM, INTMON,CFid 
					)
				select 
						'IN', 0, z.documento, ' ',
						case when z.cant > 0 then 'C' else 'D' end,
						'Consumo Propio ' + z.Acodigo, 
						convert(varchar, z.fechadoc, 112), #rsPeriodo.periodo#, #rsMes.mes#,
						c.IACinventario, z.Ocodigo, 
						
						#LvarCOSTOS.VALUACION.Mcodigo#, 
						abs(round(coalesce(z.costolin,0.00),2)),
						#LvarCOSTOS.VALUACION.TC#, 
						abs(round(coalesce(z.costolin*#LvarCOSTOS.VALUACION.TC#,0.00),2)),z.CFid
				from TransformacionProducto z
					inner join Articulos a 
						on a.Aid = z.Aid
						and a.Ecodigo = z.Ecodigo
					inner join Existencias b
						inner join IAContables c
							on c.IACcodigo = b.IACcodigo
							and c.Ecodigo = b.Ecodigo
						on b.Aid = z.Aid
						and b.Alm_Aid = z.Alm_Aid
						and b.Ecodigo = z.Ecodigo
				where z.ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
					and z.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and z.TipoLinea = 40
					and z.TPestado = 0
			</cfquery>
			<cfquery datasource="#Arguments.Conexion#">
				INSERT INTO #INTARC# 
					( 	
						INTORI, INTREL, INTDOC, INTREF, 
						INTTIP, 
						INTDES, 
						INTFEC, Periodo, Mes, 
						Ccuenta, Ocodigo, 
						Mcodigo, INTMOE, INTCAM, INTMON,CFid 
					)
				select 
						'IN', 0, z.documento, ' ', 
						case when z.cant > 0 then 'D' else 'C' end,
						'Consumo Propio ' + z.Acodigo, 
						convert(varchar, z.fechadoc, 112), #rsPeriodo.periodo#, #rsMes.mes#,
						c.IACgastoajuste, z.Ocodigo, 
						
						#LvarCOSTOS.VALUACION.Mcodigo#, 
						abs(round(coalesce(z.costolin,0.00),2)),
						#LvarCOSTOS.VALUACION.TC#, 
						abs(round(coalesce(z.costolin*#LvarCOSTOS.VALUACION.TC#,0.00),2)),z.CFid
				from TransformacionProducto z
					inner join Articulos a 
						on a.Aid = z.Aid
						and a.Ecodigo = z.Ecodigo
					inner join Existencias b
						inner join IAContables c
							on c.IACcodigo = b.IACcodigo
							and c.Ecodigo = b.Ecodigo
						on b.Aid = z.Aid
						and b.Alm_Aid = z.Alm_Aid
						and b.Ecodigo = z.Ecodigo
				where z.ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
					and z.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and z.TipoLinea = 40
					and z.TPestado = 0
			</cfquery>
			<!--- 3.2.4 Contabilización de Pédida / Ganancia --->
			<cfquery datasource="#Arguments.Conexion#">
				INSERT INTO #INTARC# 
					( 	
						INTORI, INTREL, INTDOC, INTREF, 
						INTTIP, 
						INTDES, 
						INTFEC, Periodo, Mes, 
						Ccuenta, Ocodigo, 
						Mcodigo, INTMOE, INTCAM, INTMON,CFid 
					)
				select 
						'IN', 0, z.documento, ' ', 
						case when z.TipoES = 'S' then 'C' else 'D' end,
						case when z.TipoES = 'S' then 'Perdida ' + z.Acodigo else 'Ganancia ' + z.Acodigo end, 
						convert(varchar, z.fechadoc, 112), #rsPeriodo.periodo#, #rsMes.mes#,
						c.IACinventario, z.Ocodigo, 
						
						#LvarCOSTOS.VALUACION.Mcodigo#, 
						abs(round(coalesce(z.costolin,0.00),2)),
						#LvarCOSTOS.VALUACION.TC#, 
						abs(round(coalesce(z.costolin*#LvarCOSTOS.VALUACION.TC#,0.00),2)),z.CFid
				from TransformacionProducto z
					inner join Articulos a 
						on a.Aid = z.Aid
						and a.Ecodigo = z.Ecodigo
					inner join Existencias b
						inner join IAContables c
							on c.IACcodigo = b.IACcodigo
							and c.Ecodigo = b.Ecodigo
						on b.Aid = z.Aid
						and b.Alm_Aid = z.Alm_Aid
						and b.Ecodigo = z.Ecodigo
				where z.ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
					and z.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and z.TipoLinea = 50
					and z.TPestado = 0
			</cfquery>
			<cfquery datasource="#Arguments.Conexion#">
				INSERT INTO #INTARC# 
					( 	
						INTORI, INTREL, INTDOC, INTREF, 
						INTTIP, 
						INTDES, 
						INTFEC, Periodo, Mes, 
						Ccuenta, Ocodigo, 
						Mcodigo, INTMOE, INTCAM, INTMON,CFid 
					)
				select 
						'IN', 0, z.documento, ' ',
						case when z.TipoES = 'S' then 'D' else 'C' end,
						case when z.TipoES = 'S' then 'Perdida ' + z.Acodigo else 'Ganancia ' + z.Acodigo end, 
						convert(varchar, z.fechadoc, 112), #rsPeriodo.periodo#, #rsMes.mes#,
						case when z.cant > 0 then c.IACgastoajuste else c.IACingajuste end,	z.Ocodigo, 
						
						#LvarCOSTOS.VALUACION.Mcodigo#, 
						abs(round(coalesce(z.costolin,0.00),2)),
						#LvarCOSTOS.VALUACION.TC#, 
						abs(round(coalesce(z.costolin*#LvarCOSTOS.VALUACION.TC#,0.00),2)),z.CFid
				from TransformacionProducto z
					inner join Articulos a 
						on a.Aid = z.Aid
						and a.Ecodigo = z.Ecodigo
					inner join Existencias b
						inner join IAContables c
							on c.IACcodigo = b.IACcodigo
							and c.Ecodigo = b.Ecodigo
						on b.Aid = z.Aid
						and b.Alm_Aid = z.Alm_Aid
						and b.Ecodigo = z.Ecodigo
				where z.ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
					and z.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and z.TipoLinea = 50
					and z.TPestado = 0
			</cfquery>
			<!--- 3.2.5 Contabilización de Ventas / Devoluciones --->
			<cfquery datasource="#Arguments.Conexion#">
				INSERT INTO #INTARC# 
					( 	
						INTORI, INTREL, INTDOC, INTREF, 
						INTTIP, 
						INTDES, 
						INTFEC, Periodo, Mes, 
						Ccuenta, Ocodigo, 
						Mcodigo, INTMOE, INTCAM, INTMON,CFid 
					)
				select 
						'IN', 0, z.documento, ' ', 
						case when z.TipoES = 'S' then 'C' else 'D' end,
						case when z.TipoES = 'S' then 'Venta ' #_Cat# z.Acodigo else 'Devolucion ' #_Cat# z.Acodigo end, 
						convert(varchar, z.fechadoc, 112), #rsPeriodo.periodo#, #rsMes.mes#,
						c.IACinventario, z.Ocodigo, 
					
						#LvarCOSTOS.VALUACION.Mcodigo#, 
						abs(round(coalesce(z.costolin,0.00),2)),
						#LvarCOSTOS.VALUACION.TC#, 
						abs(round(coalesce(z.costolin*#LvarCOSTOS.VALUACION.TC#,0.00),2)),z.CFid
				from TransformacionProducto z
					inner join Articulos a 
						on a.Aid = z.Aid
						and a.Ecodigo = z.Ecodigo
					inner join Existencias b
						inner join IAContables c
							on c.IACcodigo = b.IACcodigo
							and c.Ecodigo = b.Ecodigo
						on b.Aid = z.Aid
						and b.Alm_Aid = z.Alm_Aid
						and b.Ecodigo = z.Ecodigo
				where z.ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
					and z.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and z.TipoLinea in (60, 70)
					and z.TPestado = 0
				order by z.TipoLinea, z.Acodigo, z.documento
			</cfquery>
			<cfquery datasource="#Arguments.Conexion#">
				INSERT INTO #INTARC# 
					( 	
						INTORI, INTREL, INTDOC, INTREF, 
						INTTIP, 
						INTDES, 
						INTFEC, Periodo, Mes, 
						Ccuenta, Ocodigo, 
						Mcodigo, INTMOE, INTCAM, INTMON,CFid 
					)
				select 
						'IN', 0, z.documento, ' ', 
						case when z.TipoES = 'S' then 'D' else 'C' end,
						case when z.TipoES = 'S' then 'Costo Ventas: Venta ' #_Cat# z.Acodigo else 'Costo Ventas: Devolucion ' #_Cat# z.Acodigo end, 
						convert(varchar, z.fechadoc, 112), #rsPeriodo.periodo#, #rsMes.mes#,
						c.IACcostoventa, z.Ocodigo, 
					
						#LvarCOSTOS.VALUACION.Mcodigo#, 
						abs(round(coalesce(z.costolin,0.00),2)),
						#LvarCOSTOS.VALUACION.TC#, 
						abs(round(coalesce(z.costolin*#LvarCOSTOS.VALUACION.TC#,0.00),2)), z.CFid
				from TransformacionProducto z
					inner join Articulos a 
						on a.Aid = z.Aid
						and a.Ecodigo = z.Ecodigo
					inner join Existencias b
						inner join IAContables c
							on c.IACcodigo = b.IACcodigo
							and c.Ecodigo = b.Ecodigo
						on b.Aid = z.Aid
						and b.Alm_Aid = z.Alm_Aid
						and b.Ecodigo = z.Ecodigo
				where z.ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
					and z.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and z.TipoLinea in (60, 70)
					and z.TPestado = 0
				order by z.TipoLinea, z.Acodigo, z.documento
			</cfquery>
			<!--- 3.2.6 Marcar como procesado --->
			<cfquery datasource="#Arguments.Conexion#">
				update CCVProducto 
				set CCVPestado = 1
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				  and CCVPestado = 0
				  and DDtipo 	 = 'A'
				  <!--- 
				  and CCVPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPeriodo.periodo#">
				  and CCVPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMes.mes#">
				  and datepart(yy,Dfecha) = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPeriodo.periodo#">
				  and datepart(mm,Dfecha) = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMes.mes#">
				   --->
			</cfquery>
			<!--- 3.2.7 Actualiza ETransformacion --->
			<cfquery datasource="#Arguments.Conexion#">
				update ETransformacion set ETfechaProc = <cf_dbfunction name="now"> where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
			</cfquery>
			<!--- <cfquery datasource="#Arguments.Conexion#" name="rsINTARC">
				select INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE 
				 from #INTARC#
			</cfquery>
			<cf_dump var="#rsINTARC#"> --->
			<!--- 3.2.8 Genera Asiento --->
			
			<cfinvoke 
				component="CG_GeneraAsiento" 
				method="GeneraAsiento"
				Ecodigo="#Arguments.Ecodigo#"
				Oorigen="INPR"
				Eperiodo="#rsPeriodo.periodo#"
				Emes="#rsMes.mes#"
				Efecha="#lvarETfecha#"
				Edescripcion="Produccion de Inventario"
				Edocbase="#rsETransformacion.ETdocumento#"
				Ereferencia="#rsETransformacion.ETdocumento#"
				Debug="#Arguments.Debug#"
				returnvariable="IDcontable"/>
			<!--- 3.2.9 Actualiza Kardex --->
			<cfif IDcontable GT 0>
				<cfquery datasource="#Arguments.Conexion#">
					update Kardex
					set IDcontable  = #IDcontable#
					where Kid in (
						select Kid from #IDKARDEX#
					)
				</cfquery>
			</cfif>
			<!--- 3.2.10 Actualiza TransformacionProducto --->
			<cfquery datasource="#Arguments.Conexion#">
				update TransformacionProducto set TPestado = 1 
				where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETid#">
				  and TPestado = 0
			</cfquery>
			
			<!--- Debug: Debug Muestra Resultados para debug --->
			<cfif Arguments.Debug or Arguments.RollBack>
				<cfquery name="rsDebug" datasource="#Arguments.Conexion#">
					select * from #INTARC#
				</cfquery>
				<cfdump var="#rsDebug#" label="INTARC">
			</cfif>
			<!--- RollBack: Deshace todos los cambios --->
			<cfif Arguments.RollBack>
				<cftransaction action="rollback"/>
			</cfif>
		<cfquery name="rsreturn" datasource="#Arguments.Conexion#">
			select 'OK' as result from dual
		</cfquery>
		</cftransaction>
		<!--- Fin --->
		
		<!--- Retorno de Resultados --->
		<cfreturn rsreturn>
	</cffunction>
</cfcomponent>

