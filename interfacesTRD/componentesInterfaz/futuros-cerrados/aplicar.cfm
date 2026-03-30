<!--- Archivo    :  futuros-cerrados/aplicar.cfm --->

<cfset ws_Eperiodo = Year(session.FechaFolio)>
<cfset ws_EMes = Month(session.FechaFolio)>


<cfquery name="rsFuturos" datasource="sifinterfaces">
	select *
	from futurosCerradosPMI a
	where sessionid=#session.monitoreo.sessionid#
	  and mensajeerror is null
	  <!--- no subir del todo la póliza si hay cualquier error --->
	  and not exists (select 1 from futurosCerradosPMI b where a.Documento = b.Documento and b.mensajeerror is not null)
    order by broker_num, port_num, acct_ref_num
</cfquery>
<cftransaction>
<cfoutput query="rsFuturos" group="Documento">
	<!--- genera una póliza por cada Documento (broker/market_day) --->
	
	<cfset ws_Consecutivo = 0>
	<!--- Graba en tabla EContablesImportacion  --->
	<cfquery datasource="#session.dsn#" name="insert_query">
		insert into EContablesImportacion (Ecodigo,
			Cconcepto, Eperiodo, Emes, Efecha,
			Edescripcion, Edocbase, Ereferencia,
			BMfalta, BMUsucodigo, ECIreversible)
		values(#session.Ecodigo#, 0, #ws_Eperiodo#, #ws_EMes#, 
			<cfqueryparam cfsqltype="cf_sql_date" value="#session.FechaFolio#">, 
			'Futuros Cerrados #DateFormat(session.FechaFolio, "dd-MM-yyyy")# #broker_name#', '#rsFuturos.Documento#', null,
			<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="1">)
		select @@identity as ECIid
	</cfquery>
	<cfset vECIid = insert_query.ECIid>
	
	<cfoutput group="port_num">
		<!--- reparte el monto por portafolio --->
		
		<!--- contar cantidad de órdenes para este portafolio --->
		<cfset ws_registros = 0>
		<cfoutput group="acct_ref_num"><cfset ws_registros = ws_registros + 1></cfoutput>
		
		<!--- validar Tipo de cambio  --->
		<cfquery name="rsTipoCambio" datasource="#session.dsn#">
			select TCventa from Empresas emp
				inner join Htipocambio tca
				on tca.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsFuturos.Mcodigo#">
				and tca.Ecodigo = emp.Ecodigo
				and tca.Hfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#session.FechaFolio#"> 
			where emp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		
		<cfif rsTipoCambio.recordcount GT 0>
			<cfset LvarTCventa = rsTipoCambio.TCventa>
		</cfif>
	
		<cfif rsFuturos.mtm_pl GT 0>
			<cfset ws_tipo_modulo = "Ganancia">
			<cfset Lvarp_s_ind = 'S'>
		<cfelse>	
			<cfset ws_tipo_modulo = "Pérdida">
			<cfset Lvarp_s_ind = 'P'>
		</cfif>
		
		<cfset ws_tipo_transaccion = "FC">
		
		<cfif ws_registros GT 1>
			<cfset ws_monto       = Abs(Round(              rsFuturos.mtm_pl / ws_registros * 100) / 100)>
			<cfset ws_monto_local = Abs(Round(LvarTCventa * rsFuturos.mtm_pl / ws_registros * 100) / 100)>
		<cfelse>
			<cfset ws_monto       = Abs  (rsFuturos.mtm_pl)>
			<cfset ws_monto_local = Round( ws_monto * LvarTCventa * 100) / 100>
		</cfif>
		<!--- obtiene la diferencia de los detalles con el monto total, para posteriormente sumarlo --->
		<!--- al primer detalle de la tabla DContablesImportacion --->
		<cfset ws_PrimeraVez = true>
		<cfif ws_registros GT 1>
			<cfset ws_diferencia       = Abs(rsFuturos.mtm_pl) - (ws_monto * ws_registros)>
			<cfset ws_diferencia_local = Round( Abs( rsFuturos.mtm_pl * LvarTCventa  * 100)) / 100 - (ws_monto_local * ws_registros)>
		<cfelse>
			<cfset ws_diferencia       = 0>
			<cfset ws_diferencia_local = 0>
		</cfif>	
	
		<!--- graba el detalle de la cuenta por cobrar o cuenta por pagar --->
		
		<cfset ws_Doriginal = abs(rsFuturos.mtm_pl)>
		<cfset ws_Dlocal = Round( ( ws_Doriginal * LvarTCventa ) * 100) / 100>
		<cfset ws_Dtipocambio = LvarTCventa>
		
		<cfquery datasource="#session.dsn#" name="broker_acct">
			select b.Ccuenta, b.Cformato
			from SNegocios a 
				join CContables b
				<cfif Lvarp_s_ind is 'S'><!--- ganancia => cta de cxc --->
					on a.SNcuentacxc = b.Ccuenta
				<cfelse> <!--- pérdida => cuenta de cxp --->
					on a.SNcuentacxp = b.Ccuenta
				</cfif>
			where SNcodigoext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsFuturos.broker_num#">
		</cfquery>
		<cfif Len(broker_acct.Cformato) is 0>
			<cfthrow message="No ha definido la cuenta de #ws_tipo_modulo# para el broker #rsFuturos.broker_num# #rsFuturos.broker_name#">
		</cfif>
		
		<!--- Graba en tabla DContablesImportacion una linea para el portafolio --->
		<cfset ws_Consecutivo = ws_Consecutivo + 1>
		<cfquery datasource="#session.dsn#">
			insert DContablesImportacion (ECIid,
				DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
				Ddescripcion, Ddocumento, Dreferencia, Dmovimiento,
				CFformato, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
				Doriginal, Dlocal, Dtipocambio, Cconcepto,
				BMfalta, BMUsucodigo, EcodigoRef, Referencia1,
				Referencia2, Referencia3, Resultado, MSG)
			values(
				#vECIid#, #ws_Consecutivo#, #session.Ecodigo#, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#session.FechaFolio#">, 
				#ws_Eperiodo#, #ws_Emes#, 'Portafolio #rsFuturos.port_num# #rsFuturos.port_short_name#',<!--- short_name == Estrategia --->
				'Socio:#rsFuturos.SNid#', null, <cfif rsFuturos.mtm_pl GT 0>'D'<cfelse>'C'</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#broker_acct.Cformato#">,
					null, null, 0, #rsFuturos.Mcodigo#,
				#ws_Doriginal#, #ws_Dlocal#, #ws_Dtipocambio#, 0,
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				#session.usucodigo#, #session.Ecodigo#, null,
				null, null, 0, null)
		</cfquery>
			
		<cfoutput group="acct_ref_num"><!--- detalle del portafolio: órdenes --->
			<cfif ws_PrimeraVez><!--- el primer registro incluye el ajuste de centavos --->
				<cfset ws_PrimeraVez = false>
				<cfset ws_Doriginal = ws_monto + ws_diferencia>
				<cfset ws_Dlocal    = ws_monto_local + ws_diferencia_local>
			<cfelse>
				<cfset ws_Doriginal = ws_monto>
				<cfset ws_Dlocal    = ws_monto_local>
			</cfif>
			
			<cfset ws_Dtipocambio = LvarTCventa>
			
			<!--- Generar cuenta según definición por parte de PMI. danim, 8-oct-2007 --->
			<cfif (rsFuturos.cobertura_VR_FE is 'VR') OR (rsFuturos.venta_realizada)>
				<!--- Tanto valor razonable como venta realizada, va según el socio --->
				<!--- Cuenta contable según PMI y documento de diseño de interfaz --->
				<!--- Nota: la cuenta se toma de OCtipoVenta, pero son las mismas que en el
						documento de diseño, excepto por el quinto nivel, que debe ser '016',
						y así se sustituye una vez obtenido
				--->

				<cfquery datasource="#session.dsn#" name="tipovta">
					select
						tv.OCVid, tv.OCVdescripcion,
						tv.CFmascaraIngreso, tv.CFmascaraCostoVenta
					from OCordenComercial oc
						left join OCtipoVenta tv
							on oc.OCVid = tv.OCVid
					where oc.Ecodigo = #session.ecodigo#
					  and oc.OCcontrato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsFuturos.acct_ref_num#">
				</cfquery>
				<cfif tipovta.RecordCount is 0>
					<cfthrow message="No se encontró la orden comercial #rsFuturos.acct_ref_num#">
				<cfelseif Len(tipovta.OCVid) is 0>
					<cfthrow message="No se define el tipo de la orden comercial #rsFuturos.acct_ref_num# del socio #rsFuturos.acct_num#">
				<cfelseif Lvarp_s_ind is 'S'>
					<!--- Ganancia / Utilidad --->
					<cfset ws_CuentaOrdenComercial = tipovta.CFmascaraIngreso>
					<cfif Len(ws_CuentaOrdenComercial) is 0>
						<cfthrow message="No se ha definido la máscara de ingreso para las órdenes de #tipovta.OCVdescripcion#">
					</cfif>
				<cfelse>
					<!--- Pérdida --->
					<cfset ws_CuentaOrdenComercial = tipovta.CFmascaraCostoVenta>
					<cfif Len(ws_CuentaOrdenComercial) is 0>
						<cfthrow message="No se ha definido la máscara de costo de venta para las órdenes de #tipovta.OCVdescripcion#">
					</cfif>
				</cfif>
				
				<!--- complemento financiero de socio de negocio    --->	
				<cfquery name="socio" datasource="#session.dsn#">
					select cuentac from SNegocios
					where Ecodigo = #session.ecodigo#
					  and SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFuturos.SNid#">
				</cfquery>
				<cfif socio.recordcount is 0 or Len(Trim(socio.cuentac)) is 0>
					<cfthrow message="Complemento no definido para el socio">
				</cfif>
				
				<!--- complemento financiero de artículo --->	
				<cfquery name="articulo_comp" datasource="#session.dsn#">
					select CFcomplementoCostoVenta, CFcomplementoIngreso
					from OCcomplementoArticulo
					where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFuturos.Aid#">
				</cfquery>
				<cfif Lvarp_s_ind is 'S'>
					<!--- Ganancia / Utilidad --->
					<cfset ws_ComplementoArticulo = articulo_comp.CFcomplementoIngreso>
					<cfif Len(ws_ComplementoArticulo) is 0>
						<cfthrow message="No se ha definido el complemento de ingreso para el artículo #rsFuturos.cmdty_code#">
					</cfif>
				<cfelse>
					<!--- Pérdida --->
					<cfset ws_ComplementoArticulo = articulo_comp.CFcomplementoCostoVenta>
					<cfif Len(ws_ComplementoArticulo) is 0>
						<cfthrow message="No se ha definido el complemento de costo de venta para el artículo #rsFuturos.cmdty_code#">
					</cfif>
				</cfif>
				
				<!--- sustituir el 5to nivel con el valor '016' según especificación --->
				<cfset ws_CuentaOrdenComercial = Mid(ws_CuentaOrdenComercial, 1, 17) & '016' & Mid(ws_CuentaOrdenComercial, 21, 8)>
<!---				<cfset busqueda = find("016",ws_CuentaOrdenComercial)>
				<cfif busqueda EQ 1>--->
					<cfdump var = "#rsFuturos.SNid#">
					<cfdump var="#ws_CuentaOrdenComercial#">
					<cf_dump var = "#socio#"> 
<!---				</cfif>--->
				<!--- Reemplazar el complemento del socio --->
				<cfset ws_CuentaOrdenComercial = Replace(ws_CuentaOrdenComercial, 'SSS-SSS', Mid(socio.cuentac,1,3) & '-' & Mid(socio.cuentac,4,3))>
				<cfset ws_CuentaOrdenComercial = Replace(ws_CuentaOrdenComercial, 'AAA-AAA', Mid(ws_ComplementoArticulo,1,3) & '-' & Mid(ws_ComplementoArticulo,4,3))>
			<cfelse>
				<!--- VNR venta no realizada --->
				<!--- Cuenta contable según PMI y documento de diseño de interfaz --->
				<cfif Lvarp_s_ind is 'S'>
					<!--- Ganancia / Utilidad --->
					<cfset ws_CuentaOrdenComercial = "3502-001-002">
				<cfelse>
					<!--- Pérdida --->
					<cfset ws_CuentaOrdenComercial = "3502-003-002">
				</cfif>
			</cfif>
			<!--- contar cantidad de productos para esta orden --->
			<cfset ws_registros_prod = 0>
			<cfoutput><cfset ws_registros_prod = ws_registros_prod + 1></cfoutput>
			
			<cfif ws_registros_prod GT 1>
				<cfset ws_monto_prod       = Round(ws_Doriginal / ws_registros * 100) / 100>
				<cfset ws_monto_prod_local = Round(ws_Dlocal    / ws_registros * 100) / 100>
			<cfelse>
				<cfset ws_monto_prod       = ws_Doriginal>
				<cfset ws_monto_prod_local = ws_Dlocal   >
			</cfif>
			<!--- obtiene la diferencia de los detalles con el monto total, para posteriormente sumarlo --->
			<!--- al primer detalle de la tabla DContablesImportacion --->
			<cfset ws_PrimeraVez_prod = true>
			<cfif ws_registros_prod GT 1>
				<cfset ws_diferencia_prod       = Abs(ws_Doriginal) - (ws_monto_prod      * ws_registros_prod)>
				<cfset ws_diferencia_prod_local = Abs(ws_Dlocal   ) - (ws_monto_prod_local* ws_registros_prod)>
			<cfelse>
				<cfset ws_diferencia_prod       = 0>
				<cfset ws_diferencia_prod_local = 0>
			</cfif>
		
			<cfoutput><!--- detalle de la orden: producto --->
					
				<cfif ws_PrimeraVez><!--- el primer registro incluye el ajuste de centavos --->
					<cfset ws_PrimeraVez = false>
					<cfset ws_Doriginal_prod = ws_monto_prod + ws_diferencia_prod>
					<cfset ws_Dlocal_prod    = ws_monto_prod_local + ws_diferencia_prod_local>
				<cfelse>
					<cfset ws_Doriginal_prod = ws_monto_prod>
					<cfset ws_Dlocal_prod    = ws_monto_prod_local>
				</cfif>
				
				<!--- Graba en tabla DContablesImportacion un registro por cada trade_num/orden comercial --->
				<cfset ws_Consecutivo = ws_Consecutivo + 1>
				<cfquery datasource="#session.dsn#">
					insert DContablesImportacion (ECIid,
						DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
						Ddescripcion, Ddocumento, Dreferencia, Dmovimiento,
						CFformato, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
						Doriginal, Dlocal, Dtipocambio, Cconcepto,
						BMfalta, BMUsucodigo, EcodigoRef, Referencia1,
						Referencia2, Referencia3, Resultado, MSG)
					values (#vECIid#,
						#ws_Consecutivo#, #session.Ecodigo#, 
							<cfqueryparam cfsqltype="cf_sql_date" value="#session.FechaFolio#">, 
							#ws_Eperiodo#, #ws_Emes#,
						'Orden #rsFuturos.acct_ref_num# Prod #rsFuturos.cmdty_code# Portf #rsFuturos.port_num# #rsFuturos.port_short_name#',
							'#rsFuturos.acct_ref_num#', null, <cfif rsFuturos.mtm_pl GT 0>'C'<cfelse>'D'</cfif>,
						'#ws_CuentaOrdenComercial#', null, null, 0, #rsFuturos.Mcodigo#,
						#ws_Doriginal_prod#, #ws_Dlocal_prod#, #ws_Dtipocambio#, 0,
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
							#session.usucodigo#, #session.Ecodigo#, null,
						null, null, 0, null)
				</cfquery>
			
			</cfoutput><!--- fin de ciclo por producto --->
		</cfoutput><!--- fin de ciclo por acct_ref_num --->
		
	</cfoutput><!--- fin de ciclo por port_num --->

</cfoutput><!--- fin de ciclo por broker_num --->

<!---<cfthrow message="Terminado">--->

</cftransaction>

<cflocation url="index.cfm?botonsel=btnTerminado">
