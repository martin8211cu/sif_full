<!--- Archivo    :  SQLAplicaSeguros.cfm --->
<cfset ArregloProductos = ArrayNew(1)>

<cfquery name="rsSegurosP" datasource="sifinterfaces">
	select *
	from #session.Dsource#segurosPolizasPMI
	where sessionid=#session.monitoreo.sessionid#
	order by encabezado_id
</cfquery>
<cfif rsSegurosP.recordcount GT 0>
	<cfquery name="EperiodoC" datasource="#session.dsn#">
		select Pvalor from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
			and Pcodigo = 50
	</cfquery>
	<cfquery name="EmesC" datasource="#session.dsn#">
		select Pvalor from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
			and Pcodigo = 60
	</cfquery>
	<cfif EperiodoC.recordcount EQ 1>
		<cfset ws_Eperiodo = EperiodoC.Pvalor>
	<cfelse>
		<cfabort showerror="Error en Parámetro del sistema Pcodigo 50">
	</cfif>
	<cfif EmesC.recordcount EQ 1>
		<cfset ws_Emes = EmesC.Pvalor>
	<cfelse>
		<cfabort showerror="Error en Parámetro del sistema Pcodigo 60">
	</cfif>
<cfloop query="rsSegurosP"> 
	<cfset ws_GeneraEnc = true>
	<cfset ws_Consecutivo = 0>
	<cfset ws_tiposeguro = rsSegurosP.tipo_poliza>
	<cfset ws_fechacrea = rsSegurosP.fecha_creacion>
	<cfset ws_EDocbase = rsSegurosP.EDocbase>
	<cfquery name="rsSeguros" datasource="sifinterfaces">
		select *
		from #session.Dsource#segurosPMI
		where sessionid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSegurosP.sessionid#">
		  and sessionid=#session.monitoreo.sessionid#
		  and mensajeerror is null
		  and encabezado_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSegurosP.encabezado_id#">
    	order by trade_num
	</cfquery>
  <cfif rsSeguros.recordcount GT 0>	
	<cfloop query="rsSeguros">
		<cfset ws_compra = rsSeguros.orden>
		<cfset ws_cuentaSocio = "">
		<!--- validar cuenta financiera de seguros    --->	
		<cfif trim(rsSeguros.tipo_poliza) EQ 'CHL'>
			<cfset ws_CuentaFinancieraSeg = "1115-007">
		<cfelse>
			<cfset ws_CuentaFinancieraSeg = "1115-008">
		</cfif>			
		<!--- buscar ordenes de venta entre las cuales distribuir el monto del seguro --->
		<cfif rsSeguros.ExisteOrden EQ 'S'>
			<cfif rsSeguros.OCtipoOD EQ 'O'>       <!-- la orden es una compra  -->
				<cfset ws_OCTid = rsSeguros.OCTid>
				<cfset ws_SNcodigoext = rsSeguros.SNcodigoext>
				<cfset ws_SNid = rsSeguros.SNid>
				<cfset ws_OCcontrato = rsSeguros.OCcontrato>
				<cfset ws_OCVid = rsSeguros.OCVid>
				<cfset ws_OCtipoIC = rsSeguros.OCtipoIC>
				<cfquery name="rsVentas" datasource="#session.dsn#">
					select * from #session.Dsource#segurosVentasPMI
			    		where sessionid=#session.monitoreo.sessionid#
						and OCidCompra = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSeguros.OCid#">
				</cfquery>
				<cfif rsVentas.recordcount GT 0>
					<cfloop query="rsVentas">
						<cfset ws_OCtipoIC = rsVentas.OCtipoIC>
						<cfset ws_OCidCompra = rsVentas.OCidCompra>
						<cfset ws_OCidVenta = rsVentas.OCidVenta>
						<cfset ws_OCcontrato = rsVentas.OCcontrato>
						<cfset ws_OCVid = rsVentas.OCVid>
						<cfset ws_SNid = rsVentas.SNid>
						<cfset ws_CFmascaraIngreso = rsVentas.CFmascaraIngreso>
						<cfset ws_CFmascaraCostoVenta = rsVentas.CFmascaraCostoVenta>
						<cfquery name="rsArticulos" datasource="sifinterfaces">
							select distinct OCid, Aid, Acodalterno, Cformato from segurosArticulosPMI 
							where OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ws_OCidVenta#">
							  and sessionid = #session.monitoreo.sessionid#
						</cfquery>		
						<cfif rsArticulos.recordcount GT 0> 
							<cfloop query="rsArticulos">
								<cfif ws_OCtipoIC EQ 'I'> <!-- Es orden de Almacen -->
									<cfset ProdStruct = StructNew()>
									<cfset ProdStruct.Producto = 'ALMACEN'>
									<cfset ProdStruct.Aid = rsArticulos.Aid>
									<cfset ProdStruct.Cformato = rsArticulos.Cformato>
									<cfset ProdStruct.SNid = ws_SNid>
									<cfset ProdStruct.OCVid = 0>
									<cfset ProdStruct.Orden = ws_compra>
									<cfset ProdStruct.OrdenVenta = ws_OCcontrato>
									<cfset ProdStruct.MascaraIngreso = ws_CFmascaraIngreso>
									<cfset ProdStruct.MascaraCostoVenta = ws_CFmascaraCostoVenta>
									<cfset ProdStruct.CuentaFinanciera = "">
									<cfset ArrayAppend(ArregloProductos,ProdStruct)>
								<cfelse>
									<!--- Existencia del Articulo Orden Distribución  --->
									<cfif len(rsArticulos.Acodalterno) GT 0>
										<cfset ws_Articulo = rsArticulos.Aid>
										<cfset ws_Producto = rsArticulos.Acodalterno>
									</cfif>
							
									<!--- Existencia del Socio de Orden Comercial Distribución  --->
									<cfif len(ws_SNcodigoext) GT 0>
										<cfset ws_Socio = ws_SNid>
									</cfif>
									
									<cfif len(ws_Articulo) GT 0 and len(ws_Socio) GT 0>
										<cfset ProdStruct = StructNew()>
										<cfset ProdStruct.Producto = ws_Producto>
										<cfset ProdStruct.Aid = ws_Articulo>
										<cfset ProdStruct.Cformato = rsArticulos.Cformato>
										<cfset ProdStruct.SNid = ws_Socio>
										<cfset ProdStruct.OCVid = ws_OCVid>
										<cfset ProdStruct.Orden = ws_compra>
										<cfset ProdStruct.OrdenVenta = ws_OCcontrato>
										<cfset ProdStruct.MascaraIngreso = ws_CFmascaraIngreso>
										<cfset ProdStruct.MascaraCostoVenta = ws_CFmascaraCostoVenta>
										<cfset ProdStruct.CuentaFinanciera = "">
										<cfset ArrayAppend(ArregloProductos,ProdStruct)>
									</cfif>
								</cfif>
							</cfloop>
						</cfif>
					</cfloop>
				</cfif>
			<cfelse>      <!-- la orden es una venta  -->
				<cfset ws_SNid = rsSeguros.SNid>
				<cfset ws_OCcontrato = rsSeguros.OCcontrato>
				<cfset ws_OCVid = rsSeguros.OCVid>
				<cfset ws_CFmascaraIngreso = rsSeguros.CFmascaraIngreso>
				<cfset ws_CFmascaraCostoVenta = rsSeguros.CFmascaraCostoVenta>
				<cfset ws_SNcodigoext = rsSeguros.SNcodigoext>
				<cfquery name="rsArticulos" datasource="sifinterfaces">
					select distinct OCid, Aid, Acodalterno, Cformato from segurosArticulosPMI 
					where OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSeguros.OCid#">
					  and sessionid = #session.monitoreo.sessionid#
				</cfquery>		
				<cfif rsArticulos.recordcount GT 0>
					<cfloop query="rsArticulos">
						<cfset ws_Articulo = rsArticulos.Aid>
						<cfset ws_Cformato = rsArticulos.Cformato>
						<cfset ws_Acodalterno = rsArticulos.Acodalterno>
						<cfif rsSeguros.OCtipoIC EQ 'I'>
							<cfset ProdStruct = StructNew()>
							<cfset ProdStruct.Producto = 'ALMACEN'>
							<cfset ProdStruct.Aid = ws_Articulo>
							<cfset ProdStruct.Cformato = ws_Cformato>
							<cfset ProdStruct.SNid = ws_SNid>
							<cfset ProdStruct.OCVid = 0>
							<cfset ProdStruct.Orden = ws_compra>
							<cfset ProdStruct.OrdenVenta = ws_OCcontrato>
							<cfset ProdStruct.MascaraIngreso = ws_CFmascaraIngreso>
							<cfset ProdStruct.MascaraCostoVenta = ws_CFmascaraCostoVenta>
							<cfset ProdStruct.CuentaFinanciera = "">
							<cfset ArrayAppend(ArregloProductos,ProdStruct)>
						<cfelse>
							<!--- Existencia del Articulo Orden Distribución  --->
							<cfif len(rsArticulos.Acodalterno) GT 0>
									<cfset ws_Articulo = rsArticulos.Aid>
									<cfset ws_Producto = rsArticulos.Acodalterno>
							</cfif>
							
							<!--- Existencia del Socio de Orden Comercial Distribución  --->
							<cfif len(ws_SNcodigoext) GT 0>
									<cfset ws_Socio = ws_SNid>
							</cfif>
			
							<cfif len(ws_Articulo) GT 0 and len(ws_Socio) GT 0>
								<cfset ProdStruct = StructNew()>
								<cfset ProdStruct.Producto = ws_Producto>
								<cfset ProdStruct.Aid = ws_Articulo>
								<cfset ProdStruct.Cformato = ws_Cformato>
								<cfset ProdStruct.SNid = ws_Socio>
								<cfset ProdStruct.OCVid = ws_OCVid>
								<cfset ProdStruct.Orden = ws_compra>
								<cfset ProdStruct.OrdenVenta = ws_OCcontrato>
								<cfset ProdStruct.MascaraIngreso = ws_CFmascaraIngreso>
								<cfset ProdStruct.MascaraCostoVenta = ws_CFmascaraCostoVenta>
								<cfset ProdStruct.CuentaFinanciera = "">
								<cfset ArrayAppend(ArregloProductos,ProdStruct)>
							</cfif>
						</cfif>	
					</cfloop>
				</cfif>
			</cfif>
		</cfif>
		<cfloop from="1" to="#ArrayLen(ArregloProductos)#" index="i">
			<!--- Verifica que el producto tenga su complemento contable --->
			<cfset LvarAid = ArregloProductos[i].Aid>
			<cfquery name="OCcompArt" datasource="#session.dsn#">
				select Aid,CFcomplementoCostoVenta
				from OCcomplementoArticulo
				where Aid = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarAid#">
			</cfquery>
					<cfset ws_ComplementoArticulo = 
					Left("#OCcompArt.CFcomplementoCostoVenta#",3) & '-' & Right("#OCcompArt.CFcomplementoCostoVenta#",3)>
					<cfset ArregloProductos[i].CuentaFinanciera = 
					replace(ArregloProductos[i].MascaraCostoVenta,'AAA-AAA',"#ws_ComplementoArticulo#")>
			<cfset ArregloProductos[i].CuentaFinanciera = replace(ArregloProductos[i].CuentaFinanciera,'CCC','009')>
			<cfset ArregloProductos[i].CuentaFinanciera = replace(ArregloProductos[i].CuentaFinanciera,'SSS-SSS','002-001')>
			<!--- Arma la cuenta contable --->
			<cfset ws_CuentaFinancieraDet = ArregloProductos[i].Cformato>
			<cfset LvarAid = ArregloProductos[i].Aid>
		</cfloop>
		
		<cfset ws_registros = ArrayLen(ArregloProductos)>
		<cfif ws_registros GT 1>
			<cfset ws_monto = abs(round(rsSeguros.prima_cargo / ws_registros))>
		<cfelse>
			<cfset ws_monto = abs(rsSeguros.prima_cargo)>
		</cfif>
		<!--- obtiene la diferencia de los detalles con el monto total, para posteriormente sumarlo --->
		<!--- al primer detalle de la tabla DContablesImportacion --->
		<cfif ws_registros GT 1>
			<cfset ws_diferencia = abs(rsSeguros.prima_cargo) - (ws_monto * ws_registros)>
		<cfelse>
			<cfset ws_diferencia = 0>
		</cfif>	

		<cfset ws_Descripcion = 'Seguros-#ws_tiposeguro#'>
	<!--- cfdump var = "#ws_registros#">
	<cf_dump var="#ArregloProductos#" label = "Salida2"> --->
		
		<cftransaction>
		<cfif ws_GeneraEnc>
			<!--- Graba en tabla EContablesImportacion  --->
			<cfquery datasource="#session.dsn#">
				insert into EContablesImportacion (Ecodigo,
					Cconcepto, Eperiodo, Emes, Efecha,
					Edescripcion, Edocbase, Ereferencia,
					BMfalta, BMUsucodigo, ECIreversible)
				values(#session.Ecodigo#,0,#ws_Eperiodo#, #ws_EMes#, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#ws_fechacrea#">, 
					'#ws_Descripcion#','#ws_EDocbase#',null,
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value=1>)
			</cfquery>
			<cfquery name="rsVerifica" datasource="#session.dsn#">
				select MAX(ECIid) as valorID
				from EContablesImportacion
			</cfquery>
			<cfset vECIid = rsVerifica.valorID>
		</cfif>
		<cfset ws_PrimeraVez = true>
		<cfset ws_GeneraEnc = false>
	<!--- graba el detalle de la cuenta seguro por adelantado --->
		<cfset ws_movimiento = 'C'>
		<cfset ws_Dtipocambio = rsSeguros.TCventa>
		<cfset ws_Consecutivo = ws_Consecutivo + 1>
		<cfset ws_Doriginal = abs(rsSeguros.prima_cargo)>
		<cfset ws_Dlocal = ws_Doriginal * ws_Dtipocambio>
		<cfset ws_detalle = "Seguros por Adelantado - #ws_compra#">
	<!--- Obtiene la Oficina --->
		<cfquery name="rsOffice" datasource="#session.dsn#">
			select min(Ocodigo) as Ocodigo from Oficinas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		<cfif rsOffice.recordcount GT 0>
			<cfset ws_coffice = "#rsOffice.Ocodigo#">
		<cfelse>
			<cfabort showerror="No existe Oficina parametrizada para esta Empresa">
		</cfif> 
		<cfset ws_fechacreacion = rsSeguros.fecha_creacion>
		<cfset ws_Mcodigo = rsSeguros.Mcodigo>
	<!--- Graba en tabla DContablesImportacion  --->
		<cfquery datasource="#session.dsn#">
			insert DContablesImportacion (ECIid,
			DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
			Ddescripcion, Ddocumento, Dreferencia, Dmovimiento,
			CFformato, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
			Doriginal, Dlocal, Dtipocambio, Cconcepto,
			BMfalta, BMUsucodigo, EcodigoRef, Referencia1,
			Referencia2, Referencia3, Resultado, MSG)
			values(#vECIid#, #ws_Consecutivo#, #session.Ecodigo#, 
			<cfqueryparam cfsqltype="cf_sql_date" value="#ws_fechacreacion#">, 
			#ws_Eperiodo#, #ws_Emes#, '#ws_detalle#', null, null, '#ws_movimiento#',
			'#ws_CuentaFinancieraSeg#', null, null, #ws_coffice#, #ws_Mcodigo#,
			#ws_Doriginal#, #ws_Dlocal#, #ws_Dtipocambio#, null,
			<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
			#session.usucodigo#, #session.Ecodigo#, null,
			null, null, 0, null)
		</cfquery>
		
		<cfloop from="1" to="#ArrayLen(ArregloProductos)#" index="i">
			<cfset ws_CuentaFinanciera = ArregloProductos[i].CuentaFinanciera>
			<cfset ws_CodigoItem = ArregloProductos[i].Producto>
			<cfset ws_OCcontrato = ArregloProductos[i].Orden>
			<cfset ws_Cantidad = 0>
			<cfset ws_detalle = "Detalle de Orden:#ArregloProductos[i].Orden# Venta:#ArregloProductos[i].OrdenVenta#">
			<cfif ws_PrimeraVez>
				<cfset ws_PrimeraVez = false>
				<cfset ws_Doriginal = ws_monto + ws_diferencia>
			<cfelse>
				<cfset ws_Doriginal = ws_monto>
			</cfif>
		
			<cfset ws_Dlocal = ws_Doriginal * ws_Dtipocambio>
			
			<cfset ws_movimiento = 'D'>
			<cfset ws_Consecutivo = ws_Consecutivo + 1>
			<!--- Graba en tabla DContablesImportacion  --->
			<cfquery datasource="#session.dsn#">
				insert DContablesImportacion (ECIid,
				DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
				Ddescripcion, Ddocumento, Dreferencia, Dmovimiento,
				CFformato, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
				Doriginal, Dlocal, Dtipocambio, Cconcepto,
				BMfalta, BMUsucodigo, EcodigoRef, Referencia1,
				Referencia2, Referencia3, Resultado, MSG)
				values(#vECIid#, #ws_Consecutivo#, #session.Ecodigo#, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#ws_fechacreacion#">, 
				#ws_Eperiodo#, #ws_Emes#, '#ws_detalle#', null, null, '#ws_movimiento#',
				'#ws_CuentaFinanciera#', null, null, #ws_coffice#, #ws_Mcodigo#,
				#ws_Doriginal#, #ws_Dlocal#, #ws_Dtipocambio#, 0,
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				#session.usucodigo#, #session.Ecodigo#, null,
				null, null, 0, null)
			</cfquery>
		</cfloop>
<!---		<cfthrow message="Listo">--->
		</cftransaction>	
	<cfset Tempc = ArrayClear(ArregloProductos)>	
	</cfloop> <!-- Cierra lopp rsSeguros -->
  </cfif>
</cfloop> <!-- Cierra lopp rsSegurosP -->
</cfif>

<!---
<cfquery name="DebugE" datasource="#session.dsn#">
	select * from EContablesImportacion where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>
<cfquery name="DebugD" datasource="#session.dsn#">
	select * from DContablesImportacion where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>
<cfquery name="Debug" datasource="sifinterfaces">
	select * from #session.Dsource#segurosPMI a where ExisteOrden is null and sessionid = #session.monitoreo.sessionid# 
</cfquery>
<cfquery name="Debug2" datasource="sifinterfaces">
	select count(distinct OCidCompra) as cuenta,* from #session.Dsource#segurosVentasPMI where sessionid = #session.monitoreo.sessionid# group by sessionid
</cfquery>
<cfquery name="Debug3" datasource="sifinterfaces">
	select * from #session.Dsource#segurosArticulosPMI where sessionid = #session.monitoreo.sessionid#
</cfquery>
<cfdump var="#session.FechaFolio#" label = "Salida">
<cfdump var="#DebugE#" label = "Salida">
<cfdump var="#DebugD#" label = "Salida">
<cfdump var="#Debug#" label = "Salida">
<cfdump var="#Debug2#" label = "Salida">
<cf_dump var="#Debug3#" label = "Salida2">
--->