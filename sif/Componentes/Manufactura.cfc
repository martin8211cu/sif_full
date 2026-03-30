<!---
	Eduardo Gonzalez
	Componente para las funciones del modulo de Manufactura.
 --->
<cfcomponent>

	<cfset Conexion = "minisif">
	<cfset ecodigo = 1>

	<cffunction  name="init">
		<cfargument name="Ecodigo" type="numeric" required="false" default="#session.Ecodigo#" hint="Codigo de la empresa">
		<cfargument name="Conexion" type="string" default="#session.dsn#" required="false" hint="Conexion del Data Source">

		<cfset this.Conexion = arguments.Conexion>
		<cfset this.ecodigo = arguments.ecodigo>

		<cfreturn this>
	</cffunction>
<!--- Obtiene Bill of Materials BOM --->
	<cffunction name="getRecipe" output="true" access="public" returntype="query">
		<cfargument name="Aid" type="numeric" required="true" hint="ID del articulo">
		<cfargument name="cantidad" type="numeric" required="false" hint="Cantidad a producir" default=1>
		<cfargument name="Ecodigo" type="numeric" required="false" default="#this.Ecodigo#" hint="Codigo de la empresa">
		<cfargument name="Conexion" type="string" default="#this.Conexion#" required="false" hint="Conexion del Data Source">
    <cfargument name="tipoCalculo" type="numeric" required="false" hint="Tipo de calculo" default=0><!--- 0 = sin existencia, 1 = con existencia--->

		<cfquery name="rsGetBom" datasource="#Arguments.Conexion#">
			WITH aCTE (Aid, RAid, Adescripcion, cantidad, nivel) AS
			  (SELECT a.Aid,
			          CAST(NULL AS VARCHAR(MAX)) AS RAid,
			          a.Adescripcion,
					  CAST(NULL AS VARCHAR(MAX)) AS cantidad,
			          0 AS nivel
			   FROM Articulos a
			   WHERE a.Aid = <cfqueryparam value="#arguments.Aid#" cfsqltype="cf_sql_numeric">
			     AND a.Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_numeric">
			   UNION ALL SELECT a.Aid,
			                    CAST(r.Aid AS VARCHAR(MAX))AS RAid,
			                    a.Adescripcion,
								CAST(r.RCantidad AS VARCHAR(MAX))AS cantidad,
			                    acte.nivel + 1
			   FROM Receta r
			   INNER JOIN Articulos a ON r.RAid = a.Aid  AND a.Ecodigo = r.Ecodigo
			   INNER JOIN aCTE acte ON r.Aid = acte.Aid
			   WHERE a.Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_numeric">)

			<!--- Statement that executes the CTE --->

			SELECT DISTINCT aCTE.Aid,
			                aCTE.RAid,
			                a.Adescripcion,
			                nivel,
			                ct.CTNombre,
			                ct.CTid,
							COALESCE(e.Eexistencia,0) AS Eexistencia,
							COALESCE(aCTE.cantidad,0) AS cantidad,
							COALESCE(aCTE.cantidad * #arguments.cantidad#,0) as Requerido,
							CASE
								WHEN ((aCTE.cantidad * #arguments.cantidad#) -  Eexistencia) < 0 THEN 0
								ELSE ((aCTE.cantidad * #arguments.cantidad#) -  Eexistencia)
							END Faltante,
			                a.Anaturaleza producir,
			                isnull(a.FactorTiempoEntrega,'m') FactorTiempoEntrega,
			                isnull(a.FactorTiempoProduccion,'m') FactorTiempoProduccion,
			                TiempoEntrega = case when FactorTiempoEntrega = 'd' then
												60 * 24 when FactorTiempoEntrega = 'h' then 60 else 1 end *
											  (case when 0 = #arguments.tipoCalculo# then
													isnull(a.TiempoEntrega,0) <!--- * aCTE.cantidad * #arguments.cantidad# --->
												   when 1 = #arguments.tipocalculo# then
												    CASE
															WHEN ((aCTE.cantidad * #arguments.cantidad#) -  Eexistencia) < 0 THEN 0
															ELSE (isnull(a.TiempoEntrega,0)<!---  * aCTE.cantidad * #arguments.cantidad# --->)
														END
											end),
			                TiempoProduccion = case
												when FactorTiempoEntrega = 'd' then 60 * 24
												when FactorTiempoEntrega = 'h' then 60
												else 1
											end * isnull(a.TiempoProduccion,0) * aCTE.cantidad * #arguments.cantidad#,
			                isnull(a.CostoEstandar,0)  * aCTE.cantidad * #arguments.cantidad# as CostoEstandar,
			                isnull(a.CostoFabricacion,0)  * aCTE.cantidad * #arguments.cantidad# CostoFabricacion,
			                isnull(a.CostoManoObra,0)  * aCTE.cantidad * #arguments.cantidad# CostoManoObra,
			                isnull(a.CostoOtros,0)  * aCTE.cantidad * #arguments.cantidad# CostoOtros,
			                isnull(a.CostoPromedio,0)  * aCTE.cantidad * #arguments.cantidad# CostoPromedio
			FROM aCTE
			INNER JOIN Receta AS dp ON aCTE.Aid = dp.RAid
			INNER JOIN Articulos a ON acte.Aid = a.Aid
			LEFT JOIN
			  (SELECT SUM(Eexistencia - COALESCE(EApartadoManufac,0)) AS Eexistencia,
			          Ecodigo,
			          Aid
			   FROM Existencias
			   GROUP BY Ecodigo,
			            Aid) AS e ON a.Aid = e.Aid
			AND e.Ecodigo = a.Ecodigo
			LEFT JOIN
			  (SELECT *
			   FROM CentroTrabajo_Articulos
			   WHERE CTDefault = 1) act ON a.Aid = act.Aid
			AND act.Ecodigo = a.Ecodigo
			LEFT JOIN CentroTrabajo ct ON ct.CTId = act.CTid
			AND ct.Ecodigo = act.Ecodigo
			WHERE a.Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_numeric">
			ORDER BY nivel
		</cfquery>
		<cfreturn rsGetBom>
	</cffunction>

	<cffunction  name="getBom" access="public" returntype="query">
		<cfargument name="Aid" type="numeric" required="true" hint="ID del articulo">
		<cfargument name="cantidad" type="numeric" required="false" hint="Cantidad a producir" default=1>
		<cfargument name="producir" type="boolean" required="false" hint="Define si se devuelven lo materiales o los articulos a producir" default=0>
		<cfargument name="Ecodigo" type="numeric" required="false" default="#this.Ecodigo#" hint="Codigo de la empresa">
		<cfargument name="Conexion" type="string" default="#this.Conexion#" required="false" hint="Conexion del Data Source">

		<cfset recipe = this.getRecipe(Aid = arguments.Aid,
									   cantidad=arguments.cantidad,
									   Ecodigo = arguments.Ecodigo,
									   Conexion = arguments.Conexion)>
		<cfquery dbtype="query" name="rsBOM">
			SELECT *
			FROM recipe
			WHERE Nivel > 0
			<!--- PRODUCIR 3 = TODOS --->
			<cfif isDefined("arguments.producir") AND arguments.producir NEQ 3>
				AND producir = #arguments.producir#
			</cfif>
		</cfquery>
		<cfquery dbtype="query" name="interno">
			SELECT *
			FROM rsBOM
			WHERE producir = '1' or RAid = #arguments.Aid#
			ORDER BY producir
		</cfquery>

		<cfset rsBOMNew = queryNew("Aid,RAid,Adescripcion,nivel,CTNombre,CTid,Eexistencia,cantidad,Requerido,Faltante,producir,FactorTiempoEntrega,FactorTiempoProduccion,TiempoEntrega,TiempoProduccion,CostoEstandar,CostoFabricacion,CostoManoObra,CostoOtros,CostoPromedio,Tipo",
									"varchar,varchar,varchar,integer,varchar,varchar,integer,integer,integer,integer,integer,varchar,varchar,double,double,double,double,double,double,double,varchar")>
	    <cfset queryAddRow(rsBOMNew)>

		<cfloop query="interno">
			<cfset querySetCell(rsBOMNew, "Aid", interno.Aid)>
			<cfset querySetCell(rsBOMNew, "RAid", interno.RAid)>
			<cfset querySetCell(rsBOMNew, "Adescripcion", interno.Adescripcion)>
			<cfset querySetCell(rsBOMNew, "nivel", interno.nivel)>
			<cfset querySetCell(rsBOMNew, "CTNombre", interno.CTNombre)>
			<cfset querySetCell(rsBOMNew, "CTid", interno.CTid)>
			<cfset querySetCell(rsBOMNew, "Eexistencia", interno.Eexistencia)>
			<cfset querySetCell(rsBOMNew, "cantidad", interno.cantidad)>
			<cfset querySetCell(rsBOMNew, "Requerido", interno.Requerido)>
			<cfset querySetCell(rsBOMNew, "Faltante", interno.Faltante)>
			<cfset querySetCell(rsBOMNew, "producir", interno.producir)>
			<cfset querySetCell(rsBOMNew, "FactorTiempoEntrega", interno.FactorTiempoEntrega)>
			<cfset querySetCell(rsBOMNew, "FactorTiempoProduccion", interno.FactorTiempoProduccion)>
			<cfset querySetCell(rsBOMNew, "TiempoEntrega", interno.TiempoEntrega)>
			<cfset querySetCell(rsBOMNew, "TiempoProduccion", interno.TiempoProduccion)>
			<cfset querySetCell(rsBOMNew, "CostoEstandar", interno.CostoEstandar)>
			<cfset querySetCell(rsBOMNew, "CostoFabricacion", interno.CostoFabricacion)>
			<cfset querySetCell(rsBOMNew, "CostoManoObra", interno.CostoManoObra)>
			<cfset querySetCell(rsBOMNew, "CostoOtros", interno.CostoOtros)>
			<cfset querySetCell(rsBOMNew, "CostoPromedio", interno.CostoPromedio)>
			<cfset querySetCell(rsBOMNew, "Tipo", "F")>
			<cfset queryAddRow(rsBOMNew)>
			<!--- Detalle --->
			<cfquery dbtype="query" name="externo">
				SELECT *
				FROM rsBOM
				WHERE rsBOM.RAid = #interno.Aid# AND rsBOM.producir = '0'
			</cfquery>
			<cfloop query="externo">
				<cfset querySetCell(rsBOMNew, "Aid", externo.Aid)>
				<cfset querySetCell(rsBOMNew, "RAid", externo.RAid)>
				<cfset querySetCell(rsBOMNew, "Adescripcion", externo.Adescripcion)>
				<cfset querySetCell(rsBOMNew, "nivel", externo.nivel)>
				<cfset querySetCell(rsBOMNew, "CTNombre", externo.CTNombre)>
				<cfset querySetCell(rsBOMNew, "CTid", externo.CTid)>
				<cfset querySetCell(rsBOMNew, "Eexistencia", externo.Eexistencia)>
				<cfset querySetCell(rsBOMNew, "cantidad", externo.cantidad)>
				<cfset querySetCell(rsBOMNew, "Requerido", externo.Requerido)>
				<cfset querySetCell(rsBOMNew, "Faltante", externo.Faltante)>
				<cfset querySetCell(rsBOMNew, "producir", externo.producir)>
				<cfset querySetCell(rsBOMNew, "FactorTiempoEntrega", externo.FactorTiempoEntrega)>
				<cfset querySetCell(rsBOMNew, "FactorTiempoProduccion", externo.FactorTiempoProduccion)>
				<cfset querySetCell(rsBOMNew, "TiempoEntrega", externo.TiempoEntrega)>
				<cfset querySetCell(rsBOMNew, "TiempoProduccion", externo.TiempoProduccion)>
				<cfset querySetCell(rsBOMNew, "CostoEstandar", externo.CostoEstandar)>
				<cfset querySetCell(rsBOMNew, "CostoFabricacion", externo.CostoFabricacion)>
				<cfset querySetCell(rsBOMNew, "CostoManoObra", externo.CostoManoObra)>
				<cfset querySetCell(rsBOMNew, "CostoOtros", externo.CostoOtros)>
				<cfset querySetCell(rsBOMNew, "CostoPromedio", externo.CostoPromedio)>
				<cfset querySetCell(rsBOMNew, "Tipo", "S")>
				<cfset queryAddRow(rsBOMNew)>
			</cfloop>
		</cfloop>
		<cfquery dbtype="query" name="rsBOMNew">
			SELECT *
			FROM rsBOMNew
			WHERE rsBOMNew.Aid > 0
		</cfquery>
		<cfreturn rsBOMNew>
	</cffunction>

	<!--- 17-03-2018 Eduardo Gonzalez --->
	<!--- Valida Existencias para Aprobar OT --->
	<cffunction name="fnValidaExistencia" output="true" access="public" returntype="String">
		<cfargument name="OTid" type="numeric" required="true" hint="ID de la Orden de Trabajo">
		<cfargument name="Ecodigo" type="numeric" required="true" hint="Codigo de la empresa">
		<cfargument name="Conexion" type="string" required="true" hint="Conexion del Data Source">

		<cfset lVarNumOrden = ''>

		<!--- Consulta los datos de la ORDEN DE TRABAJO --->
		<cfquery name="rsGetInfoOT" datasource="#Arguments.Conexion#">
			SELECT a.Aid,
			       COALESCE(Tbl.Eexistencia,0) - d.Cantidad AS Cantidad, <!--- Unicamente lo faltante --->
			       ABS(Tbl.Eexistencia - d.Cantidad) AS CantidadInt,
			       e.OTNumero
			FROM OrdenTrabajoEnc e
			INNER JOIN OrdenTrabajoDet d ON e.OTid = d.OTid
			AND e.Ecodigo = d.Ecodigo
			INNER JOIN Articulos a ON a.Aid = d.Aid
			AND a.Ecodigo = d.Ecodigo
			INNER JOIN
			  (SELECT sum(Eexistencia - COALESCE(EApartadoManufac,0)) AS Eexistencia,
			          Ecodigo,
			          Aid
			   FROM Existencias
			   GROUP BY Ecodigo,
			            Aid)Tbl ON Tbl.Aid = a.Aid
			AND Tbl.Ecodigo = a.Ecodigo
			WHERE e.OTEstatus = 2 <!--- CERRADA --->
			  AND a.Anaturaleza = 1 <!--- PRODUCCION EXTERNA --->
			  AND e.OTid = <cfqueryparam value="#arguments.OTid#" cfsqltype="cf_sql_numeric">
			  AND e.Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_numeric">
		</cfquery>

		<!--- Var Retorno --->
		<cfset lVarReturn = "">

		<cfloop query="rsGetInfoOT">
			<cfif rsGetInfoOT.Cantidad LT 0>
			<!--- Si es menor a 0, es un valor negativo, por lo tanto falta material --->
				<!--- Consulta listado completo de materiales --->
				<cfset recipe = this.getRecipe(Aid = rsGetInfoOT.Aid,
									   cantidad=rsGetInfoOT.CantidadInt,
									   Ecodigo = arguments.Ecodigo,
									   Conexion = arguments.Conexion)>
				<cfquery dbtype="query" name="recipe">
					SELECT SUM(Eexistencia) AS Eexistencia, SUM(Requerido) AS Requerido, Adescripcion
					FROM recipe
					WHERE producir = 0
					GROUP BY Adescripcion
				</cfquery>

				<cfset lVarCount = 0>
				<cfloop query="recipe">
					<cfif recipe.Requerido GT recipe.Eexistencia>
						<cfif lVarCount EQ 0>
							<cfset lVarReturn = "Orden: [" & #rsGetInfoOT.OTNumero# & " - Articulos: " & #recipe.Adescripcion#>
						<cfelseif lVarCount GT 0>
							<cfset lVarReturn = lVarReturn & ", " & #recipe.Adescripcion#>
						</cfif>
						<cfset lVarCount = lVarCount + 1>
					</cfif>
				</cfloop>
			</cfif>
			<cfif lVarReturn NEQ ''>
				<cfset lVarReturn = lVarReturn & "] ">
			</cfif>
		</cfloop>
		<cfreturn lVarReturn>
	</cffunction>

	<!--- 01-04-2018 Eduardo Gonzalez --->
	<!--- Estimacion de pedido --->
	<cffunction name="fnEstimacionPedido" output="true" access="public" returntype="string">
		<cfargument name="Pid" type="numeric" required="true" hint="ID del pedido">
		<cfargument name="Ecodigo" type="numeric" required="true" hint="Codigo de la empresa">
		<cfargument name="Conexion" type="string" required="true" hint="Conexion del Data Source">
		<cfargument name="tipoCalculo" type="numeric" required="false" hint="Tipo de calculo"><!--- 0 = sin existencia, 1 = con existencia--->

		<cfquery name="rsInfoPedido" datasource="#Arguments.Conexion#">
			SELECT e.PNumero,
			       e.PFechaCreacion,
			       a.Aid,
			       a.Adescripcion,
			       d.PDCantidad,
						 a.Anaturaleza producir,
						 cta.CTid,
						 a.FactorTiempoProduccion as FactorTiempoProduccion,
			       TiempoProduccion =
				       case when FactorTiempoEntrega = 'd' then 60 * 24
					   when FactorTiempoEntrega = 'h' then 60 else 1 end *
                       isnull(a.TiempoProduccion,0) * d.PDCantidad,
						 CASE
			          WHEN FactorTiempoEntrega = 'd' then 60 * 24
			          WHEN FactorTiempoEntrega = 'h' then 60
			          else 1
			       END * COALESCE(a.TiempoEntrega,0) AS TiempoEntrega,
			       COALESCE(a.CostoFabricacion,0) * COALESCE(d.PDCantidad,0) AS CostoFabricacion,
			       COALESCE(a.CostoEstandar,0) * COALESCE(d.PDCantidad,0) AS CostoEstandar
			FROM PedidoEnc e
			INNER JOIN PedidoDet d ON e.Pid = d.Pid
			AND e.Ecodigo = d.Ecodigo
			INNER JOIN Articulos a ON a.Aid = d.Aid
			AND a.Ecodigo = d.Ecodigo
			LEFT JOIN CentroTrabajo_Articulos cta
			ON cta.Aid = a.Aid
			and cta.CTDefault = 1
			WHERE e.Pid = <cfqueryparam value="#arguments.Pid#" cfsqltype="cf_sql_numeric">
			  AND e.Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_numeric">
		</cfquery>

		<cfset lVarColorTotalPedido = "##AFEEEE">
		<cfset lVarColorTotalArticulo = "##E0FFFF">
		<cfset lVarBorderDetail = "border-bottom:1pt dotted black;">
		<cfset lVarBorderDetail2 = "border-bottom:1pt solid black;">
		<cfset lVarFuente112 = "font-size: 95%;">
		<cfset lVarFuente95 = "font-size: 90%;">
		<cfset lVarFuenteNormal = "font-size: 88%;">
		<cfset lVarColorTotales = "##000842">
		<cfset lVarColorTotalesP = "##06009f">

		<cfif rsInfoPedido.RecordCount GT 0>
			<cfoutput>
				<table width="95%"  border="0" cellpadding="1px" cellspacing="0" align="center" style="font-size: 110%;">
					<tr><td colspan="3">&nbsp;</td></tr>
					<tr style="font-size: 115%;">
						<td align="center" rowspan="2"  width="60%"><strong>Estimaci&oacute;n de Pedido</strong></td>
						<td align="right"><strong>Pedido:&nbsp;</strong></td>
						<td nowrap="true">#rsInfoPedido.PNumero#</td>
					</tr>
					<tr style="font-size: 115%;">
						<td align="right"><strong>Creado:&nbsp;</strong></td>
						<td nowrap="true">#DateFormat(rsInfoPedido.PFechaCreacion, 'dd/mm/yyyy')#</td>
						<cfset fechaCreacionDePedido = rsInfoPedido.PFechaCreacion>
					</tr>
					<cfif arguments.tipoCalculo EQ 1>
						<tr style="#lVarFuente95#">
						    <td align="center" rowspan="2"  width="60%"><strong>Calculado con existencia</strong></td>
						</tr>
					</cfif>
					<tr><td colspan="3">&nbsp;</td></tr>
					<!--- DETALLE --->
					<tr>
						<td colspan="3">&nbsp;
							<table width="100%"  border="0" cellpadding="0px" cellspacing="0px" align="center" style="font-size: 100%;">
								<tr class="tituloListas" style="#lVarFuente112#">
									<td aling="center" rowspan="2"><strong>&nbsp;Art&iacute;culo</strong></td>
									<cfif arguments.tipoCalculo EQ 0>
									    <td align="center" rowspan="2"><strong>Cantidad</strong></td>
									<cfelseif arguments.tipoCalculo EQ 1>
									    <td align="center" rowspan="2"><strong>Cant. Requerida</strong>&nbsp;</td>
											<td align="center" rowspan="2"><strong>Cant. Faltante</strong></td>
									</cfif>
									<td align="center" colspan="2"><strong>Tipo Producci&oacute;n</strong></td>
									<td align="center" colspan="3"><strong>Tiempo Recepci&oacute;n</strong></td>
									<td align="center" colspan="3"><strong>Tiempo Producci&oacute;n</strong></td>
									<td align="center" colspan="2"><strong>Costo</strong></td>
								</tr>
								<tr class="tituloListas" style="#lVarFuente112#">
									<td align="center"><strong>Interna</strong></td>
									<td align="center"><strong>Externa</strong></td>
									<td align="center" colspan = "3"><strong>D&iacute;as</strong></td>
									<td align="center" colspan = "3"><strong>D&iacute;as Habiles</strong></td>
									<td align="center"><strong>Compra</strong></td>
									<td align="center"><strong>Fabricaci&oacute;n</strong></td>
								</tr>

								<!--- VARIABLES TOTALES GLOBALES --->
								<cfset lVarTotalCostoCompraPedido = 0>
								<cfset lVarTotalCostoFabricacionPedido = 0>
								<cfset lVarTotalTiempoMayorEntrega = 0>
								<cfset lVarMaxTiempoProduccion = 0>
								<cfset lVarMaxDiasRecepcion = 0>

								<cfloop query="rsInfoPedido">
									<cfset recipe = this.getRecipe(Aid = rsInfoPedido.Aid,
																   cantidad = rsInfoPedido.PDCantidad,
																   Ecodigo = arguments.Ecodigo,
																   Conexion = arguments.Conexion,
																	 tipoCalculo = tipoCalculo)>
									<cfset lVarMaxDiasRecepcion = this.getMaxDiasRecepcion(
										recipe = recipe, Ecodigo = arguments.Ecodigo,
																  Conexion = arguments.Conexion)>
									<cfset diasFeriadosRecepcion = this.getDiasFeriados(dias = lVarMaxDiasRecepcion,
									  fechaCreacion = rsInfoPedido.PFechaCreacion, Ecodigo = arguments.Ecodigo,
																  Conexion = arguments.Conexion)>
									<cfset lVarMaxDiasRecepcion = lVarMaxDiasRecepcion + diasFeriadosRecepcion>

									<cfquery dbtype="query" name="recipe">
										SELECT Adescripcion,
										       SUM(Requerido) AS Requerido,
										       SUM(Faltante) AS Faltante,
										       Producir,
										       <!--- Nivel, --->
										       TiempoEntrega,
										       SUM(CostoEstandar) AS CostoEstandar,
										       SUM(CostoFabricacion) AS CostoFabricacion,
										       FactorTiempoProduccion,
										       SUM(TiempoProduccion) AS TiempoProduccion,
										       CTid
										FROM recipe
										WHERE Nivel > 0
										GROUP BY Adescripcion,
										         Producir,
										         <!--- Nivel, --->
										         TiempoEntrega,
										         FactorTiempoProduccion,
										         CTid
										ORDER BY Producir DESC
									</cfquery>

									<!--- LLENADO DE VARIABLES --->
									<cfset lVarTiempoMayorEntrega = Ceiling(numberFormat(rsInfoPedido.TiempoEntrega/60/24,'0.00'))>
									<cfset lVarTiempoProduccion = 0>
									<cfset lVarCostoCompra = #rsInfoPedido.CostoEstandar#>
									<cfset lVarCostoFabricacion = #rsInfoPedido.CostoFabricacion#>
									<cfloop query="recipe">
										<cfif Ceiling(numberFormat(recipe.TiempoEntrega/60/24,'0.00')) GT lVarTiempoMayorEntrega>
											<cfset lVarTiempoMayorEntrega = #Ceiling(numberFormat(recipe.TiempoEntrega/60/24,'0.00'))# + diasFeriadosRecepcion>
										</cfif>
										<cfif recipe.CostoEstandar NEQ ''>
											<cfset lVarCostoCompra = lVarCostoCompra + recipe.CostoEstandar>
										</cfif>
										<cfif recipe.CostoFabricacion NEQ ''>
											<cfset lVarCostoFabricacion = lVarCostoFabricacion + recipe.CostoFabricacion>
										</cfif>
									</cfloop>

									<!--- Alimentacion Variables Globales --->
									<cfset lVarTotalCostoCompraPedido = lVarTotalCostoCompraPedido + lVarCostoCompra>
									<cfset lVarTotalCostoFabricacionPedido = lVarTotalCostoFabricacionPedido + lVarCostoFabricacion>

									<cfif lVarTiempoMayorEntrega GT lVarTotalTiempoMayorEntrega>
										<cfset lVarTotalTiempoMayorEntrega = lVarTiempoMayorEntrega>
									</cfif>

									<cfif recipe.RecordCount GT 0>
									  <cfscript>
                          contadorDiasJornada = this.getHorasJornadas(rsInfoPedido, lVarMaxDiasRecepcion,
													rsInfoPedido.PFechaCreacion, arguments.Ecodigo, arguments.Conexion);
											</cfscript>
										<!--- Se agrega el Articulo Padre --->
										<tr style="#lVarBorderDetail##lVarFuente95#">
											<!--- Descripcion de acuerdo al Nivel --->
											<td><strong>#rsInfoPedido.Adescripcion#</strong></td>
											<!--- Cantidad --->
											<td align="center"><strong>#rsInfoPedido.PDCantidad#</strong></td>
											<cfif arguments.tipoCalculo EQ 1>
											    <td align="center"><strong>#0#</strong></td>
											</cfif>
											<!--- Tipo Produccion --->
											<!--- Interna --->
											<td align="center"><strong>&##8226;</strong></td>
											<!--- Externa --->
											<td align="center">&nbsp;</td>
											<!--- TIEMPO ENTREGA --->
											<!--- Dias --->
											<td align="center" colspan = "3"><strong>#ceiling(numberFormat(rsInfoPedido.TiempoEntrega/60/24,'0.00'))#</strong></td>
											<!--- TIEMPO PRODUCCION --->
                      <!--- Dias --->
											<td align="center" colspan = "3"><strong>#numberFormat(contadorDiasJornada,'0')#</strong></td>
											<td align="right"><strong>#LSCurrencyFormat(rsInfoPedido.CostoEstandar,'none')#</strong></td>
											<td align="right"><strong>#LSCurrencyFormat(rsInfoPedido.CostoFabricacion,'none')#</strong></td>
										</tr>
										<cfscript>
										  lVarTiempoProduccion = lVarTiempoProduccion + contadorDiasJornada;
											lVarMaxDiasProduccion = this.getMaxDiasProduccion(rsInfoPedido, lVarMaxDiasRecepcion, true,
											    rsInfoPedido.PFechaCreacion, arguments.Ecodigo, arguments.Conexion);
											lVarMaxDiasProduccion = lVarMaxDiasProduccion + this.getMaxDiasProduccion(recipe, lVarMaxDiasRecepcion,
											    false, rsInfoPedido.PFechaCreacion, arguments.Ecodigo, arguments.Conexion);
										  fechaInicialProduccion = rsInfoPedido.PFechaCreacion + 1 + lVarMaxDiasRecepcion;
										</cfscript>
										<cfset diasFeriadosProduccion = this.getDiasFeriados(dias = lVarMaxDiasProduccion,
									      fechaCreacion = fechaInicialProduccion, Ecodigo = arguments.Ecodigo,
																  Conexion = arguments.Conexion)>
										<!--- COMPONENTES DEL ARTICULO PRINCIPAL--->
										<cfloop query="recipe">
											<tr style="#lVarFuenteNormal#">
												<!--- Descripcion de acuerdo al Nivel --->
												<td>
													<cfif recipe.Producir EQ 0>
														&nbsp;
													</cfif>
													#recipe.Adescripcion#
												</td>
												<!--- Cantidad --->
												<td align="center">#recipe.Requerido#</td>
												<!--- Cantidad faltante --->
												<cfif arguments.tipoCalculo EQ 1>
												    <td align="center">#recipe.Faltante#</td>
												</cfif>
												<!--- Tipo Produccion --->
												<!--- Interna --->
												<td align="center">
													<cfif #recipe.Producir# EQ 1>
														&##8226;
													</cfif>
												</td>
												<!--- Externa --->
												<td align="center">
													<cfif #recipe.Producir# EQ 0>
														&##8226;
													</cfif>
												</td>
												<!--- TIEMPO ENTREGA --->
												<!--- Dias --->
												<td align="center" colspan = "3">
													<cfif recipe.TiempoEntrega NEQ ''>
														#Ceiling(numberFormat((recipe.TiempoEntrega/60/24),'0.00'))#
													<cfelse>
														0.00
													</cfif>
												</td>
												<!--- TIEMPO PRODUCCION --->
												<cfscript>
                            contadorDiasJornada = getHorasJornadas(recipe, lVarMaxDiasRecepcion,
														rsInfoPedido.PFechaCreacion, arguments.Ecodigo, arguments.Conexion);
														if(recipe.Producir EQ 1){
														    lVarTiempoProduccion = lVarTiempoProduccion + contadorDiasJornada;
														}
												</cfscript>
												<!--- Dias --->
												<td align="center" colspan = "3">
													<cfif recipe.TiempoProduccion NEQ ''>
														#numberFormat(contadorDiasJornada,'0')#
													<cfelse>
														&nbsp;
													</cfif>
												</td>
												<td align="right">#LSCurrencyFormat(recipe.CostoEstandar,'none')#</td>
												<td align="right">#LSCurrencyFormat(recipe.CostoFabricacion,'none')#</td>
											</tr>
										</cfloop>

										<tr bgcolor="#lVarColorTotalArticulo#" style="#lVarFuente95#">
											<!--- Dias Entrega/Produccion --->
											<cfset sizeCol = 4 />
											<cfif arguments.tipoCalculo EQ 1>
											    <cfset sizeCol = 5 />
											</cfif>
											<td colspan="<cfoutput>#sizeCol#</cfoutput>" valign="bottom" align="right" rowspan="4" style="#lVarFuente95#"><strong>D&iacute;as:&nbsp;</strong></td>
											<cfif lVarTiempoMayorEntrega - diasFeriadosRecepcion GTE 0>
											    <td align="center" valign="bottom" colspan = "3" rowspan="4"><strong>#lVarTiempoMayorEntrega - diasFeriadosRecepcion#</strong></td>
											<cfelse>
											    <td align="center" valign="bottom" colspan = "3" rowspan="4"><strong>#0#</strong></td>
											</cfif>
											<td align="center" valign="bottom" colspan = "3" rowspan="4"><strong>#numberFormat(lVarTiempoProduccion,'0')#</strong></td>

											<td align="center" colspan="2" style="#lVarBorderDetail2#"><strong>Costo por Art&iacute;culo</strong></td>
										</tr>
										<tr bgcolor="#lVarColorTotalArticulo#" style="#lVarFuente95#">
											<td align="right"><strong>Compra:&nbsp;</strong></td>
											<td align="right"><strong>#LSCurrencyFormat(lVarCostoCompra,'none')#:&nbsp;</strong></td>
										</tr>
										<tr bgcolor="#lVarColorTotalArticulo#" style="#lVarFuente95#">
											<td align="right"><strong>Fabricaci&oacute;n:&nbsp;</strong></td>
											<td align="right" style="#lVarBorderDetail2#"><strong>#LSCurrencyFormat(lVarCostoFabricacion,'none')#:&nbsp;</strong></td>
										</tr>
										<tr bgcolor="#lVarColorTotalArticulo#" style="#lVarFuente95#">
											<td align="right"><strong>Compra + <br>Fabricaci&oacute;n:&nbsp;</strong></td>
											<td align="right" style="color:#lVarColorTotales#"><strong>#LSCurrencyFormat(lVarCostoCompra + lVarCostoFabricacion,'none')#:&nbsp;</strong></td>
										</tr>
										<!--- Dias feriados --->
										<tr bgcolor="#lVarColorTotalArticulo#" style="#lVarFuente95#">
											<td colspan="<cfoutput>#sizeCol#</cfoutput>" align="right"><strong>D&iacute;as feriados:&nbsp;</strong></td>
											<td colspan = "3" align="center" style="#lVarBorderDetail2#"><strong>#diasFeriadosRecepcion#</strong></td>
											<td colspan = "3" align="center" style="#lVarBorderDetail2#"><strong>#diasFeriadosProduccion#</strong></td>
											<td colspan = "3" align="center"></td>
										</tr>
										<!--- Dias entrega/produccion + habiles--->
										<tr bgcolor="#lVarColorTotalArticulo#" style="#lVarFuente95#">
											<td colspan="<cfoutput>#sizeCol#</cfoutput>" align="right"><strong>Tiempo Total:&nbsp;</strong></td>
											<td colspan = "3" align="center" style="color:#lVarColorTotales#"><strong>#lVarTiempoMayorEntrega#</strong></td>
											<td colspan = "3" align="center" style="color:#lVarColorTotales#"><strong>#numberFormat(lVarTiempoProduccion + diasFeriadosProduccion,'0')#</strong></td>
											<td colspan = "3" align="center"></td>
										</tr>
									</cfif>
									<!--- CALCULAR TIEMPOS MAXIMOS [produccion en paralelo] --->
									<cfif (lVarTiempoProduccion + diasFeriadosProduccion) GT lVarMaxTiempoProduccion>
									    <cfset lVarMaxTiempoProduccion = lVarTiempoProduccion + diasFeriadosProduccion>
									</cfif>
								</cfloop>
								<!--- TOTALES DEL PEDIDO --->
								<tr style="#lVarFuente112#" align="center"><td colspan="12"><strong>Total por Pedido</strong></td></tr>
								<tr bgcolor="#lVarColorTotalArticulo#" style="#lVarFuente112#">
									<td colspan="<cfoutput>#sizeCol#</cfoutput>" align="right" rowspan="4"><strong>Tiempo:&nbsp;</strong></td>
									<!--- TIEMPO ENTREGA --->
									<!--- Dias --->
									<td align="center" rowspan="4" colspan="3" style="color:#lVarColorTotalesP#"><strong>#lVarTotalTiempoMayorEntrega#</strong></td>
									<!--- TIEMPO PRODUCCION --->
									<!--- Dias --->
									<td align="center" rowspan="4" colspan="3" style="color:#lVarColorTotalesP#"><strong>#numberFormat(lVarMaxTiempoProduccion,'0')#</strong></td>
									<td align="center" colspan="2" style="#lVarBorderDetail2#"><strong>Costos</strong></td>
								</tr>
								<tr bgcolor="#lVarColorTotalArticulo#" style="#lVarFuente112#">
									<td align="right"><strong>Compra:&nbsp;</strong></td>
									<td align="right"><strong>#LSCurrencyFormat(lVarTotalCostoCompraPedido,'none')#&nbsp;</strong></td>
								</tr>
								<tr bgcolor="#lVarColorTotalArticulo#" style="#lVarFuente112#">
									<td align="right" style="#lVarBorderDetail2#"><strong>Fabricaci&oacute;n:&nbsp;</strong></td>
									<td align="right" style="#lVarBorderDetail2#"><strong>#LSCurrencyFormat(lVarTotalCostoFabricacionPedido,'none')#&nbsp;</strong></td>
								</tr>
								<tr bgcolor="#lVarColorTotalArticulo#" style="#lVarFuente112#">
									<td align="right"><strong>Compra + <br>Fabricaci&oacute;n:&nbsp;</strong></td>
									<td align="right" style="color:#lVarColorTotalesP#"><strong>#LSCurrencyFormat(lVarTotalCostoCompraPedido + lVarTotalCostoFabricacionPedido,'none')#&nbsp;</strong></td>
								</tr>
								<tr bgcolor="d7dce0" style="#lVarFuente112#">
								    <td colspan="<cfoutput>#sizeCol#</cfoutput>" align="right">
										    <strong>
												Tiempo Recepci&oacute;n + <br>Producci&oacute;n:&nbsp;
												</strong>
										</td>
										<td colspan = "3" align="center"></td>
										<td colspan = "3" align="left" style="color:#lVarColorTotalesP#"><strong>#lVarTotalTiempoMayorEntrega + lVarMaxTiempoProduccion#</strong></td>
										<td colspan = "3" align="center"></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr height="20px"><td colspan="3">&nbsp;</td></tr>
				</table>
				<!--- Fecha final de estimacion --->
        <cfset fechaFinEst = this.fnGetEndDate(FechaInicio = fechaCreacionDePedido,
				    NumDias = (lVarTotalTiempoMayorEntrega + lVarMaxTiempoProduccion),
						Tipo = 1, Ecodigo = arguments.Ecodigo,
					  Conexion = arguments.Conexion)/>
			  <cfset fechaFinEst = DateFormat(fechaFinEst, 'yyyy-mm-dd')/>
				<cfset currentDateOT = this.getCurrentDate(Ecodigo = arguments.Ecodigo,
					  Conexion = arguments.Conexion)/>
			  <cfset fechaFinEstCD = this.fnGetEndDate(FechaInicio = currentDateOT,
				    NumDias = (lVarTotalTiempoMayorEntrega + lVarMaxTiempoProduccion),
						Tipo = 1, Ecodigo = arguments.Ecodigo,
					  Conexion = arguments.Conexion)/>
			  <cfset fechaFinEstCD = DateFormat(fechaFinEstCD, 'yyyy-mm-dd')/>
				<input type = "hidden" name = "finFechaEstimacionH" id = "finFechaEstimacionH"
				    value = "<cfoutput>#fechaFinEst#</cfoutput>"/>
				<input type = "hidden" name = "finFechaEstimacionCDH" id = "finFechaEstimacionCDH"
				    value = "<cfoutput>#fechaFinEstCD#</cfoutput>"/>
			</cfoutput>
		</cfif>
	</cffunction>

  <cffunction  name="getHorasJornadas" output="true" access="public" returntype="numeric">
	    <cfargument name="recipe" type="query" required="true" hint="query articulo">
			<cfargument name="diasRecepcion" type="date" required="true" hint="dia maximo de recepcion de articulos">
			<cfargument name="fechaCreacion" type="date" required="true" hint="fecha de pedido">
			<cfargument name="Ecodigo" type="numeric" required="true"  hint="Codigo de la empresa">
			<cfargument name="Conexion" type="string" required="true" hint="Conexion del Data Source">
			<cfscript>
			    tiempoRealProduccion = 0;
					if (arguments.recipe.FACTORTIEMPOPRODUCCION EQ 'd'){
						tiempoRealProduccion = arguments.recipe.TiempoProduccion;
					}
					else if(arguments.recipe.FACTORTIEMPOPRODUCCION EQ 'h'){
						tiempoRealProduccion = arguments.recipe.TiempoProduccion/24;
					}
					else if(arguments.recipe.FACTORTIEMPOPRODUCCION EQ 'm'){
						tiempoRealProduccion = arguments.recipe.TiempoProduccion/60/24;
					}
					maxJornada = 0;
					contadorDiasJornada = 0;
					fechaInicio = DateFormat(arguments.fechaCreacion + 1 + diasRecepcion, 'yyyy-mm-dd');
					diaSemana = this.getDiaSemana(fechaInicio, arguments.Ecodigo, arguments.Conexion);
					horasJornadaProduccion = 0;
					if(arguments.recipe.producir EQ 1){
						  maxJornada = this.getJornadaMaxima(arguments.recipe.CTid,  arguments.Ecodigo, arguments.Conexion);
					}
					horasJornadaProduccion = tiempoRealProduccion * maxJornada;
					while (horasJornadaProduccion > 0) {
						  horasJornada = getHorasPorJornada(arguments.recipe.CTid,  diaSemana, arguments.Ecodigo, arguments.Conexion);
							if(diaSemana != 1 || horasJornada > 0){
									contadorDiasJornada += 1;
							}
							horasJornadaProduccion = horasJornadaProduccion - horasJornada;
							diaSemana += 1;
							if(diaSemana > 7){
								diaSemana = 1;
							}
					}
			</cfscript>
			<cfreturn contadorDiasJornada>
	</cffunction>

	<cffunction name = "getDiasFeriados">
	  <cfargument name="dias" type="date" required="true" hint="dia maximo de recepcion de articulos">
		<cfargument name="fechaCreacion" type="date" required="true" hint="fecha de pedido">
		<cfargument name="Ecodigo" type="numeric" required="true"  hint="Codigo de la empresa">
		<cfargument name="Conexion" type="string" required="true" hint="Conexion del Data Source">
		    <cfscript>
				    fechaInicial = DateFormat(arguments.fechaCreacion + 1, 'yyyy-mm-dd');
						fechaFinal = DateFormat(arguments.fechaCreacion + 1 + dias, 'yyyy-mm-dd');
				</cfscript>
				<cfquery name="rsDiasFeriados" datasource="#Arguments.Conexion#">
				    select count(*) as diasF from RHFeriados where RHFfecha between
            '#fechaInicial#' and '#fechaFinal#'
				</cfquery>
		<cfreturn rsDiasFeriados.diasF>
	</cffunction>

  <cffunction  name = "getMaxDiasRecepcion">
	  <cfargument name="recipe" type="query" required="true" hint="query articulo">
		<cfargument name="Ecodigo" type="numeric" required="true"  hint="Codigo de la empresa">
		<cfargument name="Conexion" type="string" required="true" hint="Conexion del Data Source">
		<cfscript>
		    maxDias = 0;
		    if(arguments.recipe.RecordCount GT 0){
					for(row in arguments.recipe) {
						if(row.TiempoEntrega != ""){
							max = Ceiling(numberFormat((row.TiempoEntrega/60/24),'0.00'));
							if(max > maxDias){
								maxDias = max;
							}
						}
					}
				}
		</cfscript>
		<cfreturn maxDias>
	</cffunction>

	<cffunction  name = "getMaxDiasProduccion">
	  <cfargument name="recipes" type="query" required="true" hint="query articulo">
		<cfargument name="diasRecepcion" type="date" required="true" hint="dia maximo de recepcion de articulos">
		<cfargument name="isRoot" type="boolean" required="true" hint="root">
		<cfargument name="fechaCreacion" type="date" required="true" hint="fecha de pedido">
		<cfargument name="Ecodigo" type="numeric" required="true"  hint="Codigo de la empresa">
		<cfargument name="Conexion" type="string" required="true" hint="Conexion del Data Source">
		<cfset maxDias = 0>
		<cfif arguments.isRoot EQ true>
		    <cfset max = getHorasJornadas(arguments.recipes, arguments.diasRecepcion,
													arguments.fechaCreacion, arguments.Ecodigo, arguments.Conexion)>
				<cfif arguments.recipes.TiempoProduccion GT 0>
				    <cfset maxDias = maxDias + max>
				</cfif>
		<cfelseif arguments.isRoot EQ false>
		    <cfloop query="#arguments.recipes#">
					<cfset max = getHorasJornadas(arguments.recipes, arguments.diasRecepcion,
														arguments.fechaCreacion, arguments.Ecodigo, arguments.Conexion)>
					<cfif arguments.recipes.TiempoProduccion GT 0>
							<cfset maxDias = maxDias + max>
					</cfif>
		    </cfloop>
		</cfif>
		<cfreturn maxDias>
	</cffunction>

	<cffunction name="getJornadaMaxima" output="true" access="public" returntype="numeric">
		<cfargument name="CTid" type="numeric" required="true" hint="ID de centro de trabajo">
		<cfargument name="Ecodigo" type="numeric" required="true"  hint="Codigo de la empresa">
		<cfargument name="Conexion" type="string" required="true" hint="Conexion del Data Source">
		<cfset lVarJM = 0>
    	<cfquery name="rsMaxHoraJornada" datasource="#Arguments.Conexion#">
			select isnull(max(Jornada), 0) as horasMaximas from CTJornada where
			CTid = <cfqueryparam value="#arguments.CTid#" cfsqltype="cf_sql_numeric">
			and Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfif rsMaxHoraJornada.RecordCount GT 0>
			<cfset lVarJM = rsMaxHoraJornada.horasMaximas>
		</cfif>
		<cfreturn lVarJM>
	</cffunction>

	<cffunction name="getHorasPorJornada" output="true" access="public" returntype="numeric">
		<cfargument name="CTid" type="numeric" required="true" hint="ID centro trabajo">
		<cfargument name="Dia" type="numeric" required="true" hint="dia de la semana">
		<cfargument name="Ecodigo" type="numeric" required="true"  hint="Codigo de la empresa">
		<cfargument name="Conexion" type="string" required="true" hint="Conexion del Data Source">
    <cfquery name="rsHoraJornada" datasource="#Arguments.Conexion#">
			select Jornada from CTJornada where
			CTid = <cfqueryparam value="#arguments.CTid#" cfsqltype="cf_sql_numeric">
			and Dia = <cfqueryparam value="#arguments.Dia#" cfsqltype="cf_sql_numeric">
			and Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfreturn rsHoraJornada.Jornada>
	</cffunction>

	<cffunction name="getDiaSemana" output="true" access="public" returntype="numeric">
		<cfargument name="fecha" type="string" required="true" hint="fecha">
		<cfargument name="Ecodigo" type="numeric" required="true"  hint="Codigo de la empresa">
		<cfargument name="Conexion" type="string" required="true" hint="Conexion del Data Source">
    	<cfquery name="rsDiaSemana" datasource="#Arguments.Conexion#">
			select DATEPART(weekday, '#arguments.fecha#') as diaSemana
		</cfquery>
		<cfreturn rsDiaSemana.diaSemana>
	</cffunction>

	<!--- Calcula la Fecha Final, basandose en los dias laborales por CT --->
	<cffunction name="fnGetEndDate" output="true" access="public" returntype="date">
		<cfargument name="FechaInicio" type="date" required="true" hint="Fecha Inicio a calcular">
		<cfargument name="NumDias" type="numeric" required="true"  hint="Numero de dias naturales a agregar">
		<cfargument name="CTid" type="numeric" required="false" default="-1"  hint="Id del Centro de trabajo">
		<cfargument name="Tipo" type="numeric" required="true" default="1"  hint="1, Fecha Positiva - -1 Fecha Negativa">
		<cfargument name="Ecodigo" type="numeric" required="true"  hint="Codigo de la empresa">
		<cfargument name="Conexion" type="string" required="true" hint="Conexion del Data Source">

		<cfset lVarCount = 0>
		<cfset lVarDia = 0>
		<!--- Fecha default --->
		<cfset lVarFechaFinLaborable = DateAdd("d", NumDias ,#arguments.FechaInicio#)>

		<cfloop condition = "lVarCount LESS THAN NumDias">
			<cfif arguments.Tipo EQ 1>
				<cfset lVarDia = lVarDia + 1>
			<cfelse>
				<cfset lVarDia = lVarDia - 1>
			</cfif>

			<cfset lVarDate = DateAdd("d",lVarDia,#arguments.FechaInicio#)>
			<cfset lVarAplica = this.fnDayExist(NumDeDia = DayOfWeek(lVarDate),
									            CTid = arguments.CTid,
									            Ecodigo = arguments.Ecodigo,
									            Conexion = arguments.Conexion)>
			<cfif lVarAplica EQ true>
				<cfset lVarEsFeriado = this.fnEsDiaFeriado(Fecha = lVarDate,
											               Ecodigo = arguments.Ecodigo,
											               Conexion = arguments.Conexion)>
				<cfif lVarEsFeriado EQ false>
					<cfset lVarCount = lVarCount + 1>
					<cfset lVarFechaFinLaborable = lVarDate>
				</cfif>
			</cfif>

		</cfloop>
		<cfreturn lVarFechaFinLaborable>
	</cffunction>

	<!--- Valida si existe un dia en la jornada laboral del CT --->
	<cffunction name="fnDayExist" output="true" access="public" returntype="boolean">
		<cfargument name="NumDeDia" type="numeric" required="true"  hint="Numero de dia en la semana">
		<cfargument name="CTid" type="numeric" required="true"  hint="Id del Centro de trabajo">
		<cfargument name="Ecodigo" type="numeric" required="true"  hint="Codigo de la empresa">
		<cfargument name="Conexion" type="string" required="true" hint="Conexion del Data Source">
		<cfset lVarExist = false>
		<cfquery name="rsValidaDia" datasource="#Arguments.Conexion#">
			SELECT COUNT(*) AS Exist
			FROM CTJornada
			WHERE Dia = <cfqueryparam value="#arguments.NumDeDia#" cfsqltype="cf_sql_numeric">
			  AND Jornada > 0
			  AND Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_numeric">
			  <cfif isdefined("arguments.CTid") AND arguments.CTid NEQ -1>
				  AND CTid = <cfqueryparam value="#arguments.CTid#" cfsqltype="cf_sql_numeric">
			  <cfelse>
			  	  AND CTid IS NULL
			  </cfif>
		</cfquery>
		<cfif rsValidaDia.RecordCount GT 0 AND rsValidaDia.Exist GT 0>
			<cfset lVarExist = true>
		</cfif>
		<cfreturn lVarExist>
	</cffunction>

	<!--- Valida si la fecha es un dia feriado o no. --->
	<cffunction name="fnEsDiaFeriado" output="true" access="public" returntype="boolean">
		<cfargument name="Fecha" type="date" required="true"  hint="Fecha Inicial">
		<cfargument name="Ecodigo" type="numeric" required="true"  hint="Codigo de la empresa">
		<cfargument name="Conexion" type="string" required="true" hint="Conexion del Data Source">
		<cfset lVarIsDiaF = false>

		<cfquery name="rsValidaDiaF" datasource="#Arguments.Conexion#">
			SELECT COUNT(*) TotalDF
			FROM RHFeriados
			WHERE CONVERT(varchar, RHFfecha, 23) = '#DateFormat(Arguments.Fecha,'yyyy-mm-dd')#'
			  AND Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfif rsValidaDiaF.RecordCount GT 0 AND rsValidaDiaF.TotalDF GT 0>
			<cfset lVarIsDiaF = true>
		</cfif>
		<cfreturn lVarIsDiaF>
	</cffunction>

	<cffunction name="getCurrentDate" output="true" access="public" returntype="date">
		<cfargument name="Ecodigo" type="numeric" required="true"  hint="Codigo de la empresa">
		<cfargument name="Conexion" type="string" required="true" hint="Conexion del Data Source">
    	<cfquery name="rsCurrentDate" datasource="#Arguments.Conexion#">
			select GETDATE() as currentDate
		</cfquery>
		<cfreturn rsCurrentDate.currentDate>
	</cffunction>

</cfcomponent>