<cfobject name="session.objInterfazSoin" component="interfacesSoin.Componentes.interfaces">
<cfset session.objInterfazSoin.sbReportarActividad(GvarNI, GvarID)>

<!---<cftransaction isolation="read_uncommitted">--->
<!---Verificar que vengan datos de detalle, debe ir dentro de una transaccion--->
<cfquery name="rsInputED" datasource="sifinterfaces">
	select 	ie.ID , 				ie.CANTIDAD_DOCUMENTOS, 	ie.IMPORTE_TOTAL, 
			id.DOCUMENTO, 			id.DESCRIPCION, 			id.FECHA, 				
			id.MONEDA,				id.TIPO_DE_CAMBIO, 			id.TIPO_MOVIMIENTO,
			id.TOTAL,				
			<cf_dbfunction name="date_part" args="YYYY,id.FECHA"> as ano,
			<cf_dbfunction name="date_part" args="MM,id.FECHA"> as mes,
			<cf_dbfunction name="now"> as fechaActual,
			case when id.TIPO_MOVIMIENTO = 'Bancos' then 'CC' else 'AA' end as TIPO_MOV
	  from IE303 ie
		inner join ID303 id
			on id.ID = ie.ID
	 where ie.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
</cfquery>
<cfif rsInputED.recordCount EQ 0>
	<cfthrow message= "No hay datos de Entrada ID='#GvarID#' Interfaz 303:PAGO EMPLEADOS COMPROMISO">  			
</cfif>	
<!---</cftransaction>--->

<!--- valida que la cantidad de documentos del encabezado sea igual a las lineas de detalle--->
<cfquery name="readCantED" datasource="sifinterfaces">
	select a.CANTIDAD_DOCUMENTOS as cantidadE, 
	(select count(1) from ID303	b where b.ID = a.ID) as cantidaD
	from IE303 a	
	where a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
</cfquery>
<!--- Valida que vengan datos --->
<cfif readCantED.cantidadE NEQ readCantED.cantidaD>
	<cfthrow message="Error en Interfaz 303. La cantidad de documentos no coincide con la cantidad especificada en el encabezado. Proceso Cancelado!.">
</cfif>	

	
<!---valida que la cantidad del importe del Encb sea igual a la suma de lineas de detalle--->
<cfquery name="readTotImportED" datasource="sifinterfaces">
	select a.IMPORTE_TOTAL as importeE,
	(select sum(TOTAL) from ID303 b where b.ID = a.ID) as importeD
	from IE303 a	
	where a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
</cfquery>

<cfif readTotImportED.importeE NEQ readTotImportED.importeD>
	<cfthrow message="Error en Interfaz 303. La cantidad del importe del encabezado no coincide con la suma de importes de los documentos. Proceso Cancelado!.">
</cfif>

<!---valida que la cantidad del importe del Encb sea igual a la suma de lineas de detalle--->
<cfquery name="readTotImportDS" datasource="sifinterfaces">
	select a.TOTAL as importeD,
	(select sum(IMPORTE) from IS303 b where b.ID = a.ID and b.DOCUMENTO = a.DOCUMENTO) as importeS
	from ID303 a	
	where a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
</cfquery>

<cfif readTotImportDS.importeD NEQ readTotImportDS.importeS>
	<cfthrow message="Error en Interfaz 303. La cantidad del importe de las lineas no coincide con la suma de importe del documentos. Proceso Cancelado!.">
</cfif>
	
<!--- Verifica que ningun documento exista el algun otro ID de formulacion
	<cfquery name="readExistDocumt" datasource="sifinterfaces">
		select a.DOCUMENTO
		from ID303 as a
		where a.DOCUMENTO in (select DOCUMENTO from interfaz303Docum)
		and a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#"> 
	</cfquery>
	
	<cfif readExistDocumt.recordCount NEQ 0>
	   	<cfthrow message="El documento ya existe en una formulación">
	</cfif>	--->
	
 <!---Verifica que ningun documento exista el algun otro ID de formulacion--->
	<cfquery name="readExistConceptoGasto" datasource="sifinterfaces">
		select a.CONCEPTO_GASTO
		from IS303 as a
		where a.CONCEPTO_GASTO not in (select FPCcodigo from <cf_dbdatabase table="FPConcepto" datasource="minisif">)
		and a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#"> 
	</cfquery>
	<cfif readExistConceptoGasto.recordCount NEQ 0>
	   	<cfthrow message="El concepto de gasto no existe">
	</cfif>

<!--- Verifica que los CF de las lineas existan--->
	<cfquery name="readExistCF" datasource="sifinterfaces">
		select CENTRO_FUNCIONAL 
		from IS303 as a
		where CENTRO_FUNCIONAL not in (select CFcodigo from <cf_dbdatabase table="CFuncional" datasource="minisif"> where Ecodigo = #session.Ecodigo#)
		and a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#"> 
	</cfquery>
	
	<cfif readExistCF.recordCount NEQ 0>
	   	<cfthrow message="El Centro Funcional no existe">
	</cfif>	
	
	<!---Leer cada uno de los dedalles de cada documento--->
	

<cfquery name="rsInputEDS" datasource="sifinterfaces">
	select 	IS303.ID, IS303.DOCUMENTO,	IS303.LINEA,
		IS303.CENTRO_FUNCIONAL,	IS303.CONCEPTO_GASTO, IS303.IMPORTE,
		pcgdplanCompra.PCGcuenta,	CPcuenta,	catConcepto.FPCCid, 
		pcgcuentas.CFformato, 	cFuncional.Ocodigo as ocodigo  
	from IE303  
		inner join ID303 
			on ID303.ID = IE303.ID 
		inner join IS303 
			on IS303.ID = ID303.ID 
			  and IS303.DOCUMENTO = ID303.DOCUMENTO
		inner join <cf_dbdatabase table="FPConcepto" datasource="minisif"> as fpconcepto 
			on fpconcepto.FPCcodigo = IS303.CONCEPTO_GASTO
		inner join <cf_dbdatabase table="FPCatConcepto" datasource="minisif"> as catConcepto 
			on catConcepto.FPCCid = fpconcepto.FPCCid 
		inner join <cf_dbdatabase table="CPresupuestoPeriodo" datasource="minisif"> as cpresper 
			on ID303.FECHA between cpresper.CPPfechaDesde and cpresper.CPPfechaHasta 
			  and cpresper.Ecodigo = #Session.Ecodigo#
		inner join <cf_dbdatabase table="PCGplanCompras" datasource="minisif"> as pcgplancompras 
			on  pcgplancompras.CPPid = cpresper.CPPid 
		inner join <cf_dbdatabase table="CFuncional" datasource="minisif"> as cFuncional 
			on cFuncional.CFcodigo = IS303.CENTRO_FUNCIONAL
		inner join <cf_dbdatabase table="PCGDplanCompras" datasource="minisif"> as pcgdplanCompra 
			on pcgplancompras.PCGEid = pcgdplanCompra.PCGEid 
			  and pcgdplanCompra.CFid = cFuncional.CFid 
			  and  pcgdplanCompra.FPCid = fpconcepto.FPCid	
		inner join <cf_dbdatabase table="PCGcuentas" datasource="minisif"> as pcgcuentas 
			on pcgcuentas.PCGcuenta = pcgdplanCompra.PCGcuenta 
			  and pcgcuentas.Ecodigo = #Session.Ecodigo# 
	 where IE303.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
</cfquery>
	<cfif rsInputEDS.recordCount EQ 0>
		<cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 303=PAGO EMPLEADOS COMPROMISO. EDS">
	</cfif>

<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
<cfset LobjControl.CreaTablaIntPresupuesto()>

<cftransaction>
	<cfset a="">
	<cfloop query="rsInputED">
		<cfset session.objInterfazSoin.sbReportarActividad(GvarNI, GvarID)>
		
		<cfloop query="rsInputEDS"><!---Iterar por Detalle(IE-ID-IS de un documento especifico)--->
			<cfif rsInputED.ID EQ rsInputEDS.ID and rsInputED.DOCUMENTO EQ rsInputEDS.DOCUMENTO><!---Detalles X Documento--->							
				<cfset a &= " * ">
				<cfquery datasource="#session.DSN#">
					insert into #request.intPresupuesto# 
					(
						ModuloOrigen,NumeroDocumento,NumeroReferencia,FechaDocumento,AnoDocumento, 
						MesDocumento,CuentaFinanciera,Ocodigo,TipoMovimiento,CodigoMoneda,    				
						MontoOrigen,TipoCambio,Monto,NumeroLinea, CENTRO_FUNCIONAL, CONCEPTO_GASTO
					)
					values
					(
						'PLCN'<!---def en Origenes de mod Exter--->
						,'#rsInputEDS.DOCUMENTO#'
						,'#rsInputED.TIPO_MOVIMIENTO#'
						,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsInputED.FECHA#">
						,#rsInputED.ano#
						,#rsInputED.mes#
						,'#rsInputEDS.CFformato#'
						,#rsInputEDS.ocodigo#
						,'#rsInputED.TIPO_MOV#'
						,'#rsInputED.MONEDA#'
						,#rsInputEDS.IMPORTE#
						,#rsInputED.TIPO_DE_CAMBIO#
						,#rsInputEDS.IMPORTE#*#rsInputED.TIPO_DE_CAMBIO#
						,#rsInputEDS.LINEA# 
						,'#rsInputEDS.CENTRO_FUNCIONAL#' 
						,'#rsInputEDS.CONCEPTO_GASTO#'
					)
				</cfquery>
			</cfif>
		</cfloop>
		
		<cfif rsInputED.TIPO_MOVIMIENTO EQ 'Bancos'><!---Tipo_movimiento es Banco--->	
			<cfset session.objInterfazSoin.sbReportarActividad(GvarNI, GvarID)>
			<!---Solicitar Presupuesto por documento, en este caso por la iteracion <cfloop query="rsInputED">--->
			<cfset LvarNAP = LobjControl.ControlPresupuestario('PLCN',rsInputED.DOCUMENTO,"Bancos",rsInputED.FECHA,rsInputED.ano,rsInputED.mes,session.DSN,session.Ecodigo)>		
			<cfquery name="rsOutput" dbtype="query"><!---Recorrer request.rsIntPresupuesto--->
				select	NumeroLinea,CPCano as AnoPresupuesto,CPCmes as MesPresupuesto,CPcuenta, CuentaPresupuesto,CodigoOficina, TipoControl,CalculoControl,TipoMovimiento,SignoMovimiento,Monto,DisponibleAnterior,DisponibleGenerado,ExcesoGenerado,ExcesoConRechazo as ProvocoRechazo,NumeroDocumento,CuentaFinanciera,ExcesoNeto, CENTRO_FUNCIONAL, CONCEPTO_GASTO				
				from 	request.rsIntPresupuesto
				where 	CPcuenta is not null
			</cfquery>
		
			<!---Insertar Documento RHPlanillaComprometida invocando componente--->
			<cfset tipoM = 1>
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
			<cfinvoke component= "sif.Componentes.CompromisoPlanillaSIF" method="ALTA"
				RHPCdocumento="#rsInputED.DOCUMENTO#"
				RHPCdescripcion="#rsInputED.DESCRIPCION#"
				RHPCfecha="#rsInputED.FECHA#"
				Mcodigo="#rsMoneda.Mcodigo#"
				RHPCtipocambio="#rsInputED.TIPO_DE_CAMBIO#"
				RHPCtipo="#tipoM#"
				RHPCtotal="#rsInputED.TOTAL#"		
				RHPCfecha_aplica="#rsInputED.fechaActual#"		
				NAP="#NAP#"
				NRP="#NRP#"
				IDinterfaz="#GvarID#"
				returnvariable="LvarRHPCid"
			/>
			<!---Inserta las lineas de detalle de lo que dio presupuesto--->
			<cfloop query="rsOutput">
				<cfquery name="rsCF" datasource="#session.dsn#">
					select CFid 
					from CFuncional
					where CFcodigo = '#rsOutput.CENTRO_FUNCIONAL#' 
						and Ecodigo = #session.Ecodigo#
				</cfquery>
				<cfinvoke component="sif.Componentes.CompromisoPlanillaSIF"
					method="ALTAD"
					RHPCid="#LvarRHPCid#"
					RHPCDlinea="#rsOutput.NumeroLinea#"
					CFid="#iif(len(trim(rsCF.CFid)),rsCF.CFid, -1)#"
					RHPCDmonto="#rsOutput.Monto#"
					CPcuenta="#rsOutput.CPcuenta#"
					CPNRPDexcesoNeto="#rsOutput.ExcesoNeto#"
					IDinterfaz="#GvarID#"		
				/>
			</cfloop>
		</cfif> <!---Fin cfif rsInputEDS.TIPO_MOVIMIENTO NEQ 'CANCELACION'--->
			
		<cfif rsInputED.TIPO_MOVIMIENTO NEQ 'Bancos'><!---Tipo_movimiento es Banco--->
			<cfset tipoM = 2>
			<cfquery name="NAPActual" datasource="minisif">
				select NAP from RHPlanillaComprometida where RHPCdocumento = '#rsInputED.DOCUMENTO#'
			</cfquery>
			<!---Descompromiso--->
			<cfset LvarNAP = LobjControl.fnReversarNAPcompleto
			('PLCN',rsInputED.DOCUMENTO,'CANCELACION', rsInputED.fechaActual,rsInputED.ano,rsInputED.mes,NAPActual.NAP,rsInputED.DOCUMENTO,session.DSN, session.Ecodigo)>
			
			<cfquery name="rsOutput" dbtype="query"><!---Recorrer request.rsIntPresupuesto--->
				select	NumeroLinea,CPCano as AnoPresupuesto,CPCmes as MesPresupuesto, CuentaPresupuesto,CodigoOficina, TipoControl,CalculoControl,TipoMovimiento,SignoMovimiento,Monto,
DisponibleAnterior,DisponibleGenerado,ExcesoGenerado,ExcesoConRechazo as
						ProvocoRechazo,NumeroDocumento,CuentaFinanciera					
				from 	request.rsIntPresupuesto
				where 	CPcuenta is not null
			</cfquery>
		
		<!---Insertar Documento RHPlanillaComprometida invocando componete--->			
			
			<cfquery name="rsMoneda" datasource="#session.dsn#">
				select Mcodigo
				from Monedas
				where Miso4217 = '#rsInputED.MONEDA#' 
				and Ecodigo = #session.Ecodigo#
			</cfquery>
			<cfinvoke component = "sif.Componentes.CompromisoPlanillaSIF"
				method="CAMBIO"
				RHPCdocumento="#rsInputED.DOCUMENTO#"
				RHPCdescripcion="#rsInputED.DESCRIPCION#"
				RHPCfecha="#rsInputED.FECHA#"
				Mcodigo="#rsMoneda.Mcodigo#"
				RHPCtipocambio="#rsInputED.TIPO_DE_CAMBIO#"
				RHPCtipo="#tipoM#"
				RHPCtotal="#rsInputED.TOTAL#"			
				NAP="#LvarNAP#"
				NRP="0"	
				IDinterfaz="#GvarID#"
				returnvariable="LvarRHPCid"
			/>
			
			<!---Inserta las lineas de detalle de lo que dio presupuesto--->
			<cfloop query="rsOutput">
				<cfquery name="rsCF" datasource="#session.dsn#">
					select CFid 
					from CFuncional
					where CFcodigo = '#rsOutput.CENTRO_FUNCIONAL#' 
						and Ecodigo = #session.Ecodigo#
				</cfquery>
				<cfinvoke component="sif.Componentes.CompromisoPlanillaSIF" method="ALTAD"
					RHPCid="#LvarRHPCid#"
					RHPCDlinea="#rsOutput.NumeroLinea#"
					CFid="#rsCF.CFid#"
					RHPCDmonto="#rsOutput.Monto#"
					CPcuenta="#rsOutput.CuentaPresupuesto#"
					CPNRPDexcesoNeto="#rsOutput.ExcesoNeto#"
					IDinterfaz="#GvarID#"		
				/>
			</cfloop>
		</cfif>
		<cfset session.objInterfazSoin.sbReportarActividad(GvarNI, GvarID)>
		<cfloop query="rsOutput">
			<cfset session.objInterfazSoin.sbReportarActividad(GvarNI, GvarID)>
			<cfquery datasource="#session.dsn#">
				insert into <cf_dbdatabase table="OE303" datasource="sifinterfaces">
					(ID , NAP, NRP
				<cfif rsOutput.CuentaPresupuesto NEQ "">
					,DOCUMENTO, LINEA, CENTRO_FUNCIONAL, CONCEPTO_GASTO, CUENTA_FINANCIERA,
						IMPORTE_PENDIENTES, IMPORTE_ANTERIOR, IMPORTE_SOLICITADO, IMPORTE_DISPONIBLE, IMPORTE_FALTANTE
				</cfif>
					)
				values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">,
						<cfif LvarNAP GTE 0>
							#LvarNAP#, 0
						<cfelse>
							-1, #-LvarNAP#
						</cfif>
				<cfif rsOutput.CuentaPresupuesto NEQ "">
						,'#rsOutput.NumeroDocumento#'
						,#rsOutput.NumeroLinea#
						,'#rsOutput.CENTRO_FUNCIONAL#'
						,'#rsOutput.CONCEPTO_GASTO#'
						,'#rsOutput.CuentaFinanciera#'
						,#rsOutput.DisponibleGenerado# - #rsOutput.Monto#
						,#rsOutput.DisponibleAnterior#
						,#rsOutput.Monto#
						,#rsOutput.DisponibleGenerado#,
						<cfif rsOutput.ProvocoRechazo EQ 1>
							#rsOutput.ExcesoNeto#
						<cfelse>
							0
						</cfif>					
				</cfif>
					)
			</cfquery>		
		</cfloop>
		<cfquery datasource="#session.DSN#">
			delete from #request.intPresupuesto# 
		</cfquery>
	</cfloop>
</cftransaction>
