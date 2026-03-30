<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
	<cfquery name="rsInputED" datasource="sifinterfaces">
		select IE304.ID, IE304.CANTIDAD_DOCUMENTOS, IE304.IMPORTE_TOTAL,
		ID304.ID, ID304.DOCUMENTO , ID304.DESCRIPCION, ID304.FECHA ,ID304.TRANSACCION, 
		ID304.BANCO, ID304.CUENTA_BANCARIA,ID304.MONEDA, ID304.TIPO_DE_CAMBIO, 
		ID304.TIPO_MOVIMIENTO, ID304.REFERENCIA , ID304.TOTAL,<cf_dbfunction name="now"> as fechaActual,
		<cf_dbfunction name="date_part" args="YYYY,ID304.FECHA"> as ano,
		<cf_dbfunction name="date_part" args="MM,ID304.FECHA"> as mes
		  from IE304 
		  	inner join ID304
				on ID304.ID = IE304.ID
		 where IE304.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#"><!--- La variable GvarID fué por el Componente de Interfaces previamente a invocar este Componente --->
	</cfquery>
	<cfif rsInputED.recordCount EQ 0>
		<cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 304=PAGO EMPLEADOS COMPROMISO">
	</cfif>

	<!---Periodo Presupuestal Activo--->
	<cfquery name="rsCPPeriodo" datasource="sifinterfaces">
		select CPPid 
		  from <cf_dbdatabase table="CPresupuestoPeriodo" datasource="#session.dsn#"> 
		 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and CPPestado in (1)
	</cfquery>
	
		<cf_dbfunction name="date_part" 	args="YYYY,ID304.FECHA" 	returnVariable="LvarYY" datasource="#session.dsn#">
		<cf_dbfunction name="date_part" 		args="mm,ID304.FECHA" 	returnVariable="LvarMM" datasource="#session.dsn#">
		<cfquery name="rsInputEDS" datasource="sifinterfaces">
		select cts.CBid, IE304.ID, IE304.CANTIDAD_DOCUMENTOS, IE304.IMPORTE_TOTAL,cfu.Dcodigo,cfu.CFid,
			ID304.ID, ID304.DOCUMENTO , ID304.DESCRIPCION, ID304.FECHA ,ID304.TRANSACCION, 
			ID304.BANCO, ID304.CUENTA_BANCARIA,ID304.MONEDA, ID304.TIPO_DE_CAMBIO, ID304.TIPO_MOVIMIENTO, 
			ID304.REFERENCIA , ID304.TOTAL,IS304.ID, IS304.DOCUMENTO, IS304.LINEA, IS304.DESCRIPCION, 
			IS304.CENTRO_FUNCIONAL, IS304.CONCEPTO_GASTO, IS304.IMPORTE, ca.FPCCid, cf.CFcuenta, cf.CFformato, cfu.Ocodigo
			  from IE304 
				inner join ID304
					on ID304.ID = IE304.ID
				inner join IS304
					on IS304.ID = ID304.ID
					and IS304.DOCUMENTO = ID304.DOCUMENTO
					
				inner join <cf_dbdatabase table="FPCatConcepto" datasource="#session.dsn#"> ca 
					on ca.FPCCcodigo = IS304.CONCEPTO_GASTO
				inner join <cf_dbdatabase table="PCGDplanCompras" datasource="#session.dsn#"> co 
					on co.FPCCid = ca.FPCCid
					
				inner join <cf_dbdatabase table="PCGcuentas" datasource="#session.dsn#"> cubo 
					on cubo.PCGcuenta = co.PCGcuenta
				inner join <cf_dbdatabase table="CPVigencia" datasource="#session.dsn#"> vige
					on vige.Ecodigo = cubo.Ecodigo 
					and vige.Cmayor =  <cf_dbfunction name="sPart" args="rtrim(cubo.CFformato),1,4">
					and #LvarYY#*100+#LvarMM#  between vige.CPVdesdeAnoMes and vige.CPVhastaAnoMes

			   inner join <cf_dbdatabase table="CFinanciera" datasource="#session.dsn#"> cf
					on cf.CFformato = cubo.CFformato
					and cf.Ecodigo = cubo.Ecodigo
					and cf.Cmayor = vige.Cmayor
					and cf.CPVid = vige.CPVid						
					
				inner join <cf_dbdatabase table="CFuncional" datasource="#session.dsn#">  cfu 
					on cfu.CFid = co.CFid	
					
				inner join <cf_dbdatabase table="CuentasBancos" datasource="#session.dsn#">  cts 
					on cts.CBcodigo =  ID304.CUENTA_BANCARIA
					
				inner join <cf_dbdatabase table="CPresupuestoPeriodo " datasource="#session.dsn#"> pr 
					on pr.CPPid = #rsCPPeriodo.CPPid#
					and #LvarYY#*100+#LvarMM# between pr.CPPanoMesDesde and pr.CPPanoMesHasta

			 where IE304.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#"> <!---La variable GvarID fué por el Componente de Interfaces previamente a invocar este Componente --->
	             and cts.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">	
	union all
		
			select cts.CBid,IE304.ID, IE304.CANTIDAD_DOCUMENTOS, IE304.IMPORTE_TOTAL,cf.Dcodigo,cf.CFid,
			ID304.ID, ID304.DOCUMENTO , ID304.DESCRIPCION, ID304.FECHA ,ID304.TRANSACCION, 
			ID304.BANCO, ID304.CUENTA_BANCARIA,ID304.MONEDA, ID304.TIPO_DE_CAMBIO, ID304.TIPO_MOVIMIENTO, 
			ID304.REFERENCIA , ID304.TOTAL,IS304.ID, IS304.DOCUMENTO, IS304.LINEA, IS304.DESCRIPCION, 
			IS304.CENTRO_FUNCIONAL, IS304.CONCEPTO_GASTO, IS304.IMPORTE, ca.FPCCid, ca.CFcuenta, cu.CFformato, cf.Ocodigo
			  from IE304 
				inner join ID304
					on ID304.ID = IE304.ID
				inner join IS304
					on IS304.ID = ID304.ID
					and IS304.DOCUMENTO = ID304.DOCUMENTO
				inner join <cf_dbdatabase table="FPCatConcepto" datasource="#session.dsn#"> ca 
					on ca.FPCCcodigo = IS304.CONCEPTO_GASTO
				inner join <cf_dbdatabase table="CFinanciera" datasource="#session.dsn#"> cu 
					on cu.CFcuenta = ca.CFcuenta
				inner join <cf_dbdatabase table="CFuncional" datasource="#session.dsn#">  cf 
					on cf.CFcodigo = IS304.CENTRO_FUNCIONAL
				inner join <cf_dbdatabase table="CuentasBancos" datasource="#session.dsn#">  cts 
					on cts.CBcodigo =  ID304.CUENTA_BANCARIA
				inner join <cf_dbdatabase table="CPresupuestoPeriodo " datasource="#session.dsn#"> pr 
					on pr.CPPid = #rsCPPeriodo.CPPid#
				and #LvarYY#*100+#LvarMM# between pr.CPPanoMesDesde and pr.CPPanoMesHasta
				 where IE304.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#"> <!---La variable GvarID fué por el Componente de Interfaces previamente a invocar este Componente --->
                 and cts.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		</cfquery>	
	
		<cfif rsInputEDS.recordCount EQ 0>
			<cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 304=PAGO EMPLEADOS COMPROMISOeee">
		</cfif>
		
		
<!--- valida que la cantidad de documentos del encabezado sea igual a las lineas de detalle--->
	<cfquery name="readCantED" datasource="sifinterfaces">
		select a.CANTIDAD_DOCUMENTOS as cantidadE, 
		(select count(1) from ID304	b where b.ID = a.ID) as cantidaD
		from IE304 a	
		where a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
	</cfquery>
	<!--- Valida que vengan datos --->
	<cfif readCantED.cantidadE NEQ readCantED.cantidaD>
		<cfthrow message="Error en Interfaz 304. La cantidad de documentos no coincide con la cantidad especificada en el encabezado. Proceso Cancelado!.">
	</cfif>	
	
<!--- valida que la cantidad del importe del Encb sea igual a la suma de lineas de detalle--->
	<cfquery name="readTotImportED" datasource="sifinterfaces">
		select a.IMPORTE_TOTAL as importeE,
		(select sum(TOTAL) from ID304 b where b.ID = a.ID) as importeD
		from IE304 a	
		where a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
	</cfquery>
	
	<cfif readTotImportED.importeE NEQ readTotImportED.importeD>
		<cfthrow message="Error en Interfaz 304. La cantidad del importe del encabezado no coincide con la suma de importes de los documentos. Proceso Cancelado!.">
	</cfif>
	
<!--- valida que la cantidad del importe del Encb sea igual a la suma de lineas de detalle--->
	<cfquery name="readTotImportDS" datasource="sifinterfaces">
		select a.TOTAL as importeD,
		(select sum(IMPORTE) from IS304 b where b.ID = a.ID and b.DOCUMENTO = a.DOCUMENTO) as importeS
		from ID304 a	
		where a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
	</cfquery>
	
	<cfif readTotImportDS.importeD NEQ readTotImportDS.importeS>
		<cfthrow message="Error en Interfaz 304. La cantidad del importe de las lineas no coincide con la suma de importe del documentos. Proceso Cancelado!.">
	</cfif>
	
<!--- Verifica que ningun documento exista el algun otro ID de formulacion--->
	<cfquery name="readExistConceptoGasto" datasource="sifinterfaces">
		select a.CONCEPTO_GASTO
		from IS304 as a
		where a.CONCEPTO_GASTO not in (select FPCCcodigo from <cf_dbdatabase table="FPCatConcepto" datasource="#session.dsn#">)
		and a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#"> 
	</cfquery>
	<cfif readExistConceptoGasto.recordCount NEQ 0>
	   	<cfthrow message="El concepto de gasto no existe">
	</cfif>

<!--- Verifica que los CF de las lineas existan--->
	<cfquery name="readExistCF" datasource="sifinterfaces">
		select a.CENTRO_FUNCIONAL 
		from IS304 as a
		where CENTRO_FUNCIONAL not in (select CFcodigo from <cf_dbdatabase table="CFuncional" datasource="#session.dsn#">)
		and a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#"> 
	</cfquery>
	
	<cfif readExistCF.recordCount NEQ 0>
	   	<cfthrow message="El Centro Funcional no existe">
	</cfif>	

<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
<cfset LobjControl.CreaTablaIntPresupuesto()>

<cftransaction>
	<cfloop query="rsInputED"><!---Iterar por Documento (IE-ID)--->
		<!---Insertar documento--->
		<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
		<cfinvoke component="sif.Componentes.MovimientosBancarios"
			method="ALTA"
			fecha="#LSdateFormat(rsInputED.FECHA,'dd/mm/yyyy')#"
			tipoSocio="0" 
			descripcion="Movimiento mediante Interfaz304"
			referencia="#rsInputED.REFERENCIA#"
			documento="#rsInputED.DOCUMENTO#"
			cuentaBancaria="#rsInputEDS.CBid#"
			tipoTransaccion="22"
			tipocambio="#rsInputED.TIPO_DE_CAMBIO#"
			total="#rsInputED.TOTAL#"		
			empresa="#session.Ecodigo#"
			Ocodigo="#rsInputEDS.Ocodigo#"
			returnvariable="LvarEMid"
		/>		  
	
<!---Insertar detalles documento--->
		<cfloop query="rsInputEDS"><!---Iterar por Documento (IE-ID)--->
			<cfif rsInputED.DOCUMENTO eq rsInputEDS.DOCUMENTO>
				<cfset Lvardescripcion = 'Detalle documento: '&rsInputEDS.DOCUMENTO>
				<cfinvoke component="sif.Componentes.MovimientosBancarios"
				method="ALTAD"
				EMid ="#LvarEMid#"
				Ccuenta ="#rsInputEDS.CFcuenta#" 
				Dcodigo ="#rsInputEDS.Dcodigo#" 
				monto ="#rsInputEDS.IMPORTE#" 
				descripcion ="#Lvardescripcion#" 
				CFid ="#rsInputEDS.CFid#" 
				/>
			</cfif>
		</cfloop>
		
	<!---Posteo de Movimiento bancario--->
		<cfinvoke component="sif.Componentes.CP_MBPosteoMovimientosB" method="PosteoMovimientos">
			<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
			<cfinvokeargument name="EMid" value="#LvarEMid#"/>				
			<cfinvokeargument name="usuario" value="#session.usucodigo#"/>			
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="transaccionActiva" value="true"/>
		</cfinvoke>
	</cfloop>	
	
		<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
		<cfset LvarNAP = LobjControl.ControlPresupuestario('PLCN',rsInputED.DOCUMENTO,"Descompromiso",rsInputED.FECHA,rsInputED.ano,rsInputED.mes,#session.DSN#,#session.Ecodigo#)>		

	<cfquery name="rsOutput" dbtype="query"><!---Recorrer request.rsIntPresupuesto--->
		select NumeroLinea,CPCano as AnoPresupuesto,CPCmes as MesPresupuesto,CPcuenta, CuentaPresupuesto,CodigoOficina, TipoControl,CalculoControl,TipoMovimiento,SignoMovimiento,Monto,DisponibleAnterior,DisponibleGenerado,ExcesoGenerado,ExcesoConRechazo as ProvocoRechazo,NumeroDocumento,CuentaFinanciera,ExcesoNeto, CENTRO_FUNCIONAL, CONCEPTO_GASTO				
		from request.rsIntPresupuesto
		where CPcuenta is not null
	</cfquery>
	
	<!---Insertar Documento RHPlanillaEjecutada invocando componente--->
	<cfset tipoM = 1><!---Descompromiso --->
	<cfif LvarNAP GTE 0>
		<cfset NAP="#LvarNAP#">
		<cfset NRP="0">
	<cfelse>
		<cfset NRP="#-LvarNAP#">
		<cfset NAP="-1">
	</cfif>
	
	<cfquery name="rsMoneda" datasource="#session.dsn#">
		select Mcodigo
		 from Monedas
		where Miso4217 = '#rsInputED.MONEDA#' 
		  and Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfif rsMoneda.Recordcount EQ 0>
		<cfthrow message="La moneda #rsInputED.MONEDA# no existe.">
	</cfif>
	
	<cfinvoke component= "sif.Componentes.DesCompromisoPlanillaSIF" method="ALTA"  
		RHPDdocumento="#rsInputED.DOCUMENTO#"
		RHPDdescripcion="#rsInputED.DESCRIPCION#"
		RHPDfecha="#rsInputED.FECHA#"
		Mcodigo="#rsMoneda.Mcodigo#"
		RHPDtipocambio="#rsInputED.TIPO_DE_CAMBIO#"
		RHPDtipo="#tipoM#"
		RHPDtotal="#rsInputED.TOTAL#"		
		RHPDfecha_aplica="#rsInputED.fechaActual#"		
		NAP="#NAP#"
		NRP="#NRP#"
		IDinterfaz="#GvarID#"
		returnvariable="LvarRHPDid"
	/>
	
	<!---Inserta las lineas de detalle de lo que dio presupuesto--->
	<cfloop query="rsOutput">
		<cfquery name="rsCF" datasource="#session.dsn#">
			select CFid 
			from CFuncional
			where CFcodigo = '#rsOutput.CENTRO_FUNCIONAL#' 
				and Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfinvoke component="sif.Componentes.DesCompromisoPlanillaSIF" 
			method="ALTAD"
			RHPDid ="#LvarRHPDid#"
			RHPDlinea="#rsOutput.NumeroLinea#"
			CFid="#iif(len(trim(rsCF.CFid)),rsCF.CFid, -1)#"
			RHPDDmonto="#rsOutput.Monto#"
			CPcuenta="#rsOutput.CPcuenta#"
			CPNRPDexcesoNeto="#rsOutput.ExcesoNeto#"
			IDinterfaz="#GvarID#"		
		/><!---Falta crearlo--->
	</cfloop>
</cftransaction>
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<cftransaction>
	<cfloop query="rsOutput">
		<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
		
		<cfquery datasource="sifinterfaces">
			insert into OE304(
				ID, 
				NAP, 
				NRP
			<cfif rsOutput.CuentaPresupuesto NEQ "">
				,DOCUMENTO
				,LINEA
				,CENTRO_FUNCIONAL
				,CONCEPTO_GASTO
				,CUENTA_FINANCIERA
				,IMPORTE_ANTERIOR
				,IMPORTE_SOLICITADO
				,IMPORTE_DISPONIBLE
				,IMPORTE_FALTANTE
			</cfif>
		)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">,
			<cfif LvarNAP GTE 0>
				#LvarNAP#, 0,
			<cfelse>
				-1, #-LvarNAP#,
			</cfif>
			#rsOutput.NumeroLinea#,
			<cfif rsOutput.CuentaPresupuesto NEQ "">
				'#rsOutput.NumeroDocumento#',
				#rsOutput.NumeroLinea#,
				'#rsOutput.CENTRO_FUNCIONAL#',
				'#rsOutput.CONCEPTO_GASTO#',
				#rsOutput.CuentaFinanciera#,
				#rsOutput.DisponibleAnterior#,
				#rsOutput.Monto#,
				#rsOutput.DisponibleGenerado#,
				#rsOutput.ExcesoGenerado#
			</cfif>
		)
		</cfquery>
	</cfloop>
</cftransaction>
