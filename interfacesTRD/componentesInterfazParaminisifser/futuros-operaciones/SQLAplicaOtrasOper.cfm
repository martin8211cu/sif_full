<!--- Archivo    :  SQLAplicaSeguros.cfm --->
<cfquery name="rsOtrasOperEnc" datasource="sifinterfaces">
	select distinct Documento
	from OtrOperaPMI
	where sessionid=#session.monitoreo.sessionid#
	and MensajeError is null
</cfquery>
<cfif rsOtrasOperEnc.recordcount GT 0>
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
	<cfloop query="rsOtrasOperEnc"> 
		<cfset ws_GeneraEnc = true>
		<cfset ws_Consecutivo = 0>
		<cfset ws_EDocbase = rsOtrasOperEnc.Documento>
		<cfquery name="rsOtrasOper" datasource="sifinterfaces">
			select *
			from OtrOperaPMI
			where sessionid=#session.monitoreo.sessionid#
			and Documento like <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOtrasOperEnc.Documento#"> 
			and MensajeError is null
		</cfquery>
	  	<cfif rsOtrasOper.recordcount GT 0>	
			<cfloop query="rsOtrasOper">
				<cfset OPvarDescrip = rsOtrasOper.broker & " " & ws_Emes & "-" & ws_Eperiodo>
				<cftransaction>
				<cfif ws_GeneraEnc>
					<!--- Graba en tabla EContablesImportacion  --->
					<cfquery datasource="#session.dsn#">
						insert into EContablesImportacion (Ecodigo,
							Cconcepto, Eperiodo, Emes, Efecha,
							Edescripcion, Edocbase, Ereferencia,
							BMfalta, BMUsucodigo, ECIreversible)
						values(#session.Ecodigo#,0,#ws_Eperiodo#, #ws_EMes#, 
							<cfqueryparam cfsqltype="cf_sql_date" value="#rsOtrasOper.FechaDoc#">, 
							'#rsOtrasOper.Documento#','#rsOtrasOper.Documento#',null,
							<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value=0>)
					</cfquery>
					<cfquery name="rsVerifica" datasource="#session.dsn#">
						select MAX(ECIid) as valorID
						from EContablesImportacion
						where Edocbase = '#rsOtrasOper.Documento#'
					</cfquery>
					<cfif rsVerifica.recordcount EQ 1>
						<cfset vECIid = rsVerifica.valorID>
					<cfelse>
						<cfabort showerror="No se pudo Obtener el ID de la Poliza Generada">
					</cfif>
				</cfif>
					<cfset ws_GeneraEnc = false>
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
				<cfset ws_fechacreacion = rsOtrasOper.FechaDoc>
			<!--- Obtiene el codigo de Moneda para la Moneda del Movimiento --->
				<cfquery name="rsVerifica" datasource="#session.dsn#">
					select max(Mcodigo) as Mcodigo from Monedas 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
					and Miso4217 like '#rsOtrasOper.Moneda#'
				</cfquery>
			<cfset ws_Mcodigo = rsVerifica.Mcodigo>
			<cfset ws_Doriginal = rsOtrasOper.MontoCalculado>
			<cfset ws_DLocal = rsOtrasOper.MontoCalculado * rsOtrasOper.Tcambio>
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
					#ws_Eperiodo#, #ws_Emes#, '#rsOtrasOper.Concepto#', null, null, '#rsOtrasOper.TipoCD#',
					'#rsOtrasOper.Ccontable#', null, null, #ws_coffice#, #ws_Mcodigo#,
					round(#ws_Doriginal#,2), round(#ws_Dlocal#,2), round(#rsOtrasOper.Tcambio#,4), null,
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
					#session.usucodigo#, #session.Ecodigo#, null,
					null, null, 0, null)
				</cfquery>
		</cftransaction>	
	</cfloop> <!--- Cierra loop rsOtrasOper --->
  </cfif>
</cfloop> <!--- Cierra lopp rsOtrasOperEnc --->
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