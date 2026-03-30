<!--- Archivo    :  futuros-abiertos/aplicar.cfm --->

<cfset ws_Eperiodo = Year(session.FechaFolio)>
<cfset ws_EMes = Month(session.FechaFolio)>


<cfquery name="rsFuturos" datasource="sifinterfaces">
	select *
	from futurosabiertosPMI a
	where sessionid=#session.monitoreo.sessionid#
	  and mensajeerror is null
	  <!--- no subir del todo la póliza si hay cualquier error --->
	  and not exists (select 1 from futurosabiertosPMI b 
	  					where a.Documento = b.Documento and a.sessionid = b.sessionid
						and b.mensajeerror is not null)
    order by broker_num, port_num, trade_num
</cfquery>
<cftransaction>
<cfoutput query="rsFuturos" group="broker_num">
	<!--- genera una póliza por cada broker --->
	
	<cfset ws_Consecutivo = 0>
	<!--- Graba en tabla EContablesImportacion  --->
	<cfquery datasource="#session.dsn#" name="insert_query">
		insert into EContablesImportacion (Ecodigo,
			Cconcepto, Eperiodo, Emes, Efecha,
			Edescripcion, Edocbase, Ereferencia,
			BMfalta, BMUsucodigo, ECIreversible)
		values(#session.Ecodigo#, 0, #ws_Eperiodo#, #ws_EMes#, 
			<cfqueryparam cfsqltype="cf_sql_date" value="#session.FechaFolio#">, 
			'Futuros Abiertos #DateFormat(session.FechaFolio, "dd-MM-yyyy")# #broker_name#', '#rsFuturos.Documento#', null,
			<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="1">)
		select @@identity as ECIid
	</cfquery>
	<cfset vECIid = insert_query.ECIid>
	
	<cfoutput group="port_num">
		<!--- reparte el monto por portafolio --->
		
		<!--- contar cantidad de registros para este portafolio --->
		<cfset ws_registros = 0>
		<cfoutput><cfset ws_registros = ws_registros + 1></cfoutput>
		
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
		
		<cfset ws_Consecutivo = ws_Consecutivo + 1>
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
			
		<cfoutput><!--- detalle del portafolio --->
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
				<cfif Lvarp_s_ind is 'S'>
					<!--- Ganancia / Utilidad --->
					<cfset ws_CuentaOrdenComercial = "4300-016-002-SSS-SSS-006">
				<cfelse>
					<!--- Pérdida --->
					<cfset ws_CuentaOrdenComercial = "5300-016-002-SSS-SSS">
				</cfif>
				<!--- complemento financiera de socio de negocio    --->	
				<cfquery name="socio" datasource="#session.dsn#">
					select cuentac from SNegocios
					where Ecodigo = #session.ecodigo#
					  and SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFuturos.SNid#">
				</cfquery>
				<cfif socio.recordcount is 0 or Len(Trim(socio.cuentac)) is 0>
					<cfthrow message="Complemento no definido para el socio">
				</cfif>
				<cfset ws_CuentaOrdenComercial = Replace(ws_CuentaOrdenComercial, 'SSS-SSS', Mid(socio.cuentac,1,3) & '-' & Mid(socio.cuentac,4,3))>
			<cfelse>
				<!--- Flujo de efectivo, venta no realizada --->
				<!--- Cuenta contable según PMI y documento de diseño de interfaz --->
				<cfif Lvarp_s_ind is 'S'>
					<!--- Ganancia / Utilidad --->
					<cfset ws_CuentaOrdenComercial = "3502-002-002">
				<cfelse>
					<!--- Pérdida --->
					<cfset ws_CuentaOrdenComercial = "3502-004-002">
				</cfif>
			</cfif>

			<cfset ws_Consecutivo = ws_Consecutivo + 1>
			<!--- Graba en tabla DContablesImportacion un registro por cada trade_num/orden comercial --->
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
					'Orden #rsFuturos.acct_ref_num# Portf #rsFuturos.port_num# #rsFuturos.port_short_name#',
						'#rsFuturos.acct_ref_num#', null, <cfif rsFuturos.mtm_pl GT 0>'C'<cfelse>'D'</cfif>,
					'#ws_CuentaOrdenComercial#', null, null, 0, #rsFuturos.Mcodigo#,
					#ws_Doriginal#, #ws_Dlocal#, #ws_Dtipocambio#, 0,
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
						#session.usucodigo#, #session.Ecodigo#, null,
					null, null, 0, null)
			</cfquery>
		</cfoutput>
		
	</cfoutput><!--- fin de ciclo por port_num --->

</cfoutput><!--- fin de ciclo por broker_num --->

<!---<cfthrow message="Terminado">--->

</cftransaction>

<cflocation url="index.cfm?botonsel=btnTerminado">
