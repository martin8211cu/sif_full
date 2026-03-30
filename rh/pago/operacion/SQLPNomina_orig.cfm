<cfsetting 	requestTimeOut = "8400" >
<cfset action = "PNomina.cfm">
<cfif not isDefined("Form.ERNid")>
	<cflocation url="listaPNomina.cfm">
</cfif>
<html>
<head>
<title>SQL DE REGISTRO DE PAGO DE NÓMINA</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>

<cfparam name="form.ERNid" default="0" type="any">
<cfif (isdefined("form.chk"))>
	<cfset vchk = ListToArray(form.chk)>
</cfif>


<cfif IsDefined("form.btnpagar")>
	<cfloop from="1" index="i" to="#ArrayLen(vchk)#">
		<cfset datos = ListToArray(vchk[i],'|')>
		<cfquery datasource="#session.dsn#" name="data">
			<!--- Marca como pagados los registros marcados, vienen en el parámetro chk de la forma "ERNid|DRNlinea" separados por coma. --->
			update DRNomina
			set DRNestado = 1 <!--- Pagado --->
			where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[1]#">
			and DRNlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[2]#">
		</cfquery>
	</cfloop>

<cfelseif IsDefined("form.btnrechazar")>

	<cfloop from="1" index="i" to="#ArrayLen(vchk)#">
		<cfset datos = ListToArray(vchk[i],'|')>
		<cfquery datasource="#session.dsn#" name="data">
			<!--- Marca como rechazados los registros marcados, vienen en el parámetro chk de la forma "ERNid|DRNlinea" separados por coma. --->
			update DRNomina
			set DRNestado = 2 <!--- Rechazado --->
			where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[1]#">
			  and DRNlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[2]#">
		</cfquery>
	</cfloop>

<cfelseif IsDefined("form.btnpendiente")>

	<cfloop from="1" index="i" to="#ArrayLen(vchk)#">
		<cfset datos = ListToArray(vchk[i],'|')>
		<cfquery datasource="#session.dsn#" name="data">
			<!--- Marca como pendientes los registros marcados, vienen en el parámetro chk de la forma "ERNid|DRNlinea" separados por coma. --->
			update DRNomina
			set DRNestado = 3 <!--- Pendiente --->
			where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[1]#">
			and DRNlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[2]#">
		</cfquery>
	</cfloop>

<cfelseif IsDefined("form.btnpagarall")>
	<cfquery datasource="#session.dsn#" name="data">
		<!--- Marca como pagados los registros que se encuentren con estado pendiente --->
		update DRNomina
		set DRNestado = 1 <!--- Pagado --->
		where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
		<!--- and DRNestado = 3 --->
	</cfquery>

<cfelseif IsDefined("form.btnrechazarall")>
	<cfquery datasource="#session.dsn#" name="data">
		<!--- Marca como rechazados los registros que se encuentren con estado pendiente --->
		update DRNomina
		set DRNestado = 2 <!--- Rechazado --->
		where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
		<!--- and DRNestado = 3 --->
	</cfquery>
<!--- ►►►►►►►PROCESO DE FINALIZACION DE LA NOMINA◄◄◄◄◄ --->
<cfelseif IsDefined("form.btnFinalizar")>
	<cfif isdefined('form.ERNid') and len(trim(form.ERNid))>
		<cfset form.chk = form.ERNid >
	</cfif>
	<cfset action = "/cfmx/rh/pago/operacion/listaPNomina.cfm">

	<cfquery name="rsConceptoSer" datasource="#session.dsn#">
		select Cid,Ccodigo
		from Conceptos
		where LTrim(RTrim(Ccodigo)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="NSUEXPAG">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>

	<cfif rsConceptoSer.RecordCount eq 0>
		<cfthrow message="CONCEPTOS DE SERVICIO: " detail="El concepto con el codigo NSUEXPAG no se ha configurado.">
	</cfif>

<cftransaction>
	<cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="FinalizaNomina">
    	<cfinvokeargument name="ListERNid" value="#form.chk#">
    </cfinvoke>

	<cfquery name="rsTNom" datasource="#session.dsn#">
		select
			coalesce(tn.CalculaCargas,0) CalculaCargas
		from HERNomina er
		inner join TiposNomina tn
		on er.Tcodigo = tn.Tcodigo
		and er.Ecodigo = tn.Ecodigo
		where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
		and er.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>

	<cfif rsTNom.RecordCount gt 0 and rsTNom.CalculaCargas eq 1>

		<!--- OPARRALES 2018-09-05 Complementando Finalizar nomina para generar Solicitud de Pago en SIF --> Tesoreria. --->
		<cfquery name="rsNominaT" datasource="#session.dsn#">
			select
				coalesce((sum(hd.HDRNliquido)
				- ( select coalesce(sum(dri.HDRICmontores),0)
						from HDRNomina ddr
						inner join HDRIncidencias dri
							on ddr.DRNlinea = dri.DRNlinea
						inner join CIncidentes ci
							on ci.CIid = dri.CIid
							and ci.CIExcluyePagoLiquido = 1
						inner join DatosEmpleado de
							on de.DEid = ddr.DEid
							and de.DETipoPago = 0
						where ddr.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.chk#">
						and ddr.HDRNliquido > 0
					)),0) sumHDRNliquido
				,cb.Ccuenta
				,he.HERNdescripcion
			from
				HERNomina he
			Inner Join HDRNomina hd
				on he.ERNid = hd.ERNid
				and he.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			inner join DatosEmpleado de
				on de.DEid = hd.DEid
				and de.DETipoPago = 0
			inner join HRCalculoNomina hr
				on he.RCNid = hr.RCNid
			inner join CuentasBancos cb
				on LTRIM(RTRIM(cb.CBcc)) = LTRIM(RTRIM(hr.CBcc))
			where
				he.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.chk#">
			and hd.HDRNliquido > 0
			group by cb.Ccuenta,he.HERNdescripcion
		</cfquery>

		<!--- Obtiene el id de Beneficiario, si no existe, lo crea --->
		<cfquery name="q_beneficiario" datasource="#session.dsn#">
			select *
			from TESbeneficiario
			where TESBeneficiarioId = '9999'
		</cfquery>

		<cfif q_beneficiario.RecordCount eq 0>
			<cfthrow message="Beneficiarios: " detail="No se ha definido el Beneficiario generico.">
		</cfif>

		<cfset idBeneficiario = q_beneficiario.TESBid>

		<!--- Obtener Codigo de Moneda Local (Moneda de Empresa) --->
		<cfquery name="q_Moneda" datasource="#session.dsn#">
			select e.Mcodigo, m.Miso4217
			from empresas e
				inner join Monedas m
					on m.Mcodigo = e.Mcodigo
			where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>

		<!--- id de concepto Cid--->
		<cfset ConceptoServicioID = LSParseNumber(rsConceptoSer.Cid)>

		<cfquery name="rsCFGen" datasource="#session.dsn#">
			select CFid
			from CFuncional
			where CFcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="RAIZ">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>

		<!--- id de Centro Funcional --->
		<cfset CentroFuncionalID = rsCFGen.CFid>

		<!--- Fecha de solicitud de pago --->
		<cfset SP_Date = DateTimeFormat(Now(),'yyyy-mm-dd hh:nn:ss')>

		<!--- Se asigna la cuenta financiera--->
		<!--- <cfset LvarCFcuentaDB = rsNominaT.CCuenta> --->
		<cfset cuentaConcepto = ObtenerDato(150)>
		<cfquery name="rsCFinanciera" datasource="#session.dsn#">
			select CFcuenta 
			from CFinanciera 
			where Ccuenta = #cuentaConcepto.Pvalor#
				and Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfset LvarCFcuentaDB = rsCFinanciera.CFcuenta>

		<cfquery name="rsTES" datasource="#session.dsn#">
			Select e.TESid, t.EcodigoAdm
			from TESempresas e
			inner join Tesoreria t
				on t.TESid = e.TESid
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfset session.Tesoreria.TESid = rsTES.TESid>
	    <cfset session.Tesoreria.EcodigoAdm = rsTES.EcodigoAdm>
		<cflock type="exclusive" name="TesSolPago#session.Ecodigo#" timeout="3">
			<cfquery name="rsNewSol" datasource="#session.dsn#">
				select coalesce(max(TESSPnumero),0) + 1 as newSol
				from TESsolicitudPago
				where EcodigoOri = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<cfquery datasource="#session.dsn#" name="insert">
				insert into TESsolicitudPago (
					  TESid
					, CFid
					, EcodigoOri
					, TESSPnumero
					, TESSPtipoDocumento
					, TESSPestado
					, TESBid
					, TESSPfechaPagar
					, McodigoOri
					, TESSPtipoCambioOriManual
					, TESSPtotalPagarOri
					, TESSPfechaSolicitud
					, UsucodigoSolicitud
					, BMUsucodigo
					, PagoTercero
					)
				values (
					<!---  TESid --->						  #session.Tesoreria.TESid#
					<!---  CFid --->						, #CentroFuncionalID#
					<!--- EcodigoOri --->					, <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					<!--- TESSPnumero --->					, <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNewSol.newSol#">
					<!--- TESSPtipoDocumento --->			, 0
					<!--- TESSPestado --->					, 0
					<!--- TESBid --->						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#idBeneficiario#">
					<!--- TESSPfechaPagar --->				, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#SP_Date#">
					<!--- McodigoOri --->					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#q_Moneda.Mcodigo#">
					<!--- TESSPtipoCambioOriManual --->		, 1
					<!--- TESSPtotalPagarOri --->			, <cfqueryparam cfsqltype="cf_sql_money" value="#LSNumberFormat(rsNominaT.sumHDRNliquido,'9.0000')#">
					<!--- TESSPfechaSolicitud --->			, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#SP_Date#">
					<!--- UsucodigoSolicitud --->			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					<!--- BMUsucodigo --->					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					<!--- PagoTercero --->					, 1
				)
				<cf_dbidentity1 datasource="#session.DSN#" name="insert">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="idE_SolicitudPago">
		</cflock>

		<!--- Se obtiene el Ocodigo para el detalle del pago--->
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select cf.Ocodigo
				from CFuncional cf
				where cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CentroFuncionalID#">
		</cfquery>

		<!--- Definicion de iva y ieps (actualmente no aplica)--->
		<cfset LvarIcodigo  = ''>
		<cfset LvarIcodieps = ''>
		<!--- INSERTA DETALLE DE ORDEN DE PAGO --->
		<cfquery name="inserted"  datasource="#session.dsn#">
			insert INTO TESdetallePago (
					  TESid
					, CFid
					, OcodigoOri
					, TESDPestado
					, EcodigoOri
					, TESSPid
					, TESDPtipoDocumento
					, TESDPidDocumento
					, TESDPmoduloOri
					, TESDPdocumentoOri
					, TESDPreferenciaOri
					, TESDPfechaVencimiento
					, TESDPfechaSolicitada
					, TESDPfechaAprobada
					, Miso4217Ori
					, TESDPmontoVencimientoOri
					, TESDPmontoSolicitadoOri
					, TESDPmontoAprobadoOri
					, TESDPmontoAprobadoLocal
					, TESDPimpNCFOri
					, TESDPdescripcion
					, CFcuentaDB
					, Icodigo
					, codIEPS
					, Cid
					, CPDCid
					, TESDPespecificacuenta
					, PagoTercero
					, TESDPtipoCambioOri
				)
			values (
					<!--- TESid --->						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
															<cfif len(trim(CentroFuncionalID))>
					<!--- CFid --->								, <cfqueryparam value="#CentroFuncionalID#" cfsqltype="cf_sql_numeric">
															<cfelse>
																, null
															</cfif>
					<!--- OcodigoOri --->					, #rsSQL.Ocodigo#
					<!--- TESDPestado --->					, 0
					<!--- EcodigoOri --->					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					<!--- TESSPid --->						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#idE_SolicitudPago#">
					<!--- TESDPtipoDocumento --->			, 0
					<!--- TESDPidDocumento --->				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#idE_SolicitudPago#">
					<!--- TESDPmoduloOri --->				, 'TESP'
					<!--- TESDPdocumentoOri --->			, <cfqueryparam cfsqltype="cf_sql_varchar" value="RH-#Left(rsNominaT.HERNdescripcion,10)#-#DateFormat(Now(),'yymmdd')#">
					<!--- TESDPdreferenciaOri --->			, <cfqueryparam cfsqltype="cf_sql_varchar" value="Pago de Nomina">
					<!--- TESDPfechaVencimiento --->		, <cfqueryparam value="#SP_Date#" cfsqltype="cf_sql_timestamp">
					<!--- TESDPfechaSolicitada --->			, <cfqueryparam value="#SP_Date#" cfsqltype="cf_sql_timestamp">
					<!--- TESDPfechaAprobada --->			, <cfqueryparam value="#SP_Date#" cfsqltype="cf_sql_timestamp">
					<!--- Miso4217Ori --->					, <cfqueryparam cfsqltype="cf_sql_char" value="#q_Moneda.Miso4217#">
					<!--- TESDPmontoVencimientoOri --->		, round(#rsNominaT.sumHDRNliquido#,2)
					<!--- TESDPmontoSolicitadoOri --->		, round(#rsNominaT.sumHDRNliquido#,2)
					<!--- TESDPmontoAprobadoOri --->		, round(#rsNominaT.sumHDRNliquido#,2)
					<!--- TESDPmontoAprobadoLocal --->		, round(#rsNominaT.sumHDRNliquido#,2)
					<!--- TESDPimpNCFOri --->				, 0
					<!--- TESDPdescripcion --->				, null
					<!--- CFcuentaDB --->					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCFcuentaDB#">
															<cfif len(trim(LvarIcodigo))>
					<!--- Icodigo --->							, <cfqueryparam cfsqltype="cf_sql_char"    value="#LvarIcodigo#">
															<cfelse>
																, null
															</cfif>
															<cfif len(trim(LvarIcodieps))>
					<!--- codIEPS --->	   						, <cfqueryparam cfsqltype="cf_sql_char"    value="#LvarIcodieps#">
															<cfelse>
																, null
															</cfif>
					<!--- Cid --->							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#ConceptoServicioID#">
					<!--- CPDCid ---> 						, null
					<!--- TESDPespecificacuenta --->		, 0
					<!--- PagoTercero --->					, 1
					<!--- TESDPtipoCambioOri --->			, 1
					)
			<!--- <cf_dbidentity1 datasource="#session.DSN#" name="insertd" returnvariable="LvarTESDPid"> --->
		</cfquery>

		<!--- OPARRALES 2019-01-31 --->
		<!--- ================================================================================= --->
		<!--- ========== INICIA PROCESO DE SOLICITUD DE PAGO POR EMPLEADO (CHEQUES) =========== --->
		<!--- ================================================================================= --->

		<cfquery name="rsNominaTXEmp" datasource="#session.dsn#">
			select
				hd.HDRNliquido
				  - coalesce(( select dri.HDRICmontores
						from HDRNomina ddr
						inner join HDRIncidencias dri
							on ddr.DRNlinea = dri.DRNlinea
						inner join CIncidentes ci
							on ci.CIid = dri.CIid
							and ci.CIExcluyePagoLiquido = 1
						inner join DatosEmpleado de
							on de.DEid = ddr.DEid
							and de.DETipoPago = 1
						where ddr.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.chk#">
						and hd.DEid = ddr.DEid
						and ddr.HDRNliquido > 0
						group by dri.HDRICmontores,ddr.DEid
					),0) sumHDRNliquido
				,cb.Ccuenta
				,he.HERNdescripcion
				,hd.DEid
			from
				HERNomina he
			Inner Join HDRNomina hd
				on he.ERNid = hd.ERNid
				and he.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			inner join DatosEmpleado de
				on de.DEid = hd.DEid
				and de.DETipoPago = 1
			inner join HRCalculoNomina hr
				on he.RCNid = hr.RCNid
			inner join CuentasBancos cb
				on LTRIM(RTRIM(cb.CBcc)) = LTRIM(RTRIM(hr.CBcc))
			where he.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.chk#">
			and hd.HDRNliquido > 0
			group by cb.Ccuenta,he.HERNdescripcion,hd.HDRNliquido,hd.DEid
		</cfquery>

		<cfloop query="rsNominaTXEmp">
			<!--- Obtiene el id de Beneficiario, si no existe, lo crea --->
			<cfquery name="q_beneficiario" datasource="#session.dsn#">
				select *
				from TESbeneficiario
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNominaTXEmp.DEid#">
			</cfquery>

			<cfquery name="rsEmp" datasource="#session.dsn#">
				select
					DEidentificacion
				from DatosEmpleado
				where DEid = <cfqueryparam cfsqltype="cf_Sql_numeric" value="#rsNominaTXEmp.DEid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>

			<cfif q_beneficiario.RecordCount eq 0>
				<cfthrow message="Beneficiarios: " detail="No se ha definido el Beneficiario para el Empleado con el codigo: #rsEmp.DEidentificacion#">
			</cfif>

			<cfset idBeneficiario = q_beneficiario.TESBid>

			<!--- Obtener Codigo de Moneda Local (Moneda de Empresa) --->
			<cfquery name="q_Moneda" datasource="#session.dsn#">
				select e.Mcodigo, m.Miso4217
				from empresas e
					inner join Monedas m
						on m.Mcodigo = e.Mcodigo
				where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>

			<!--- id de concepto Cid--->
			<cfset ConceptoServicioID = LSParseNumber(rsConceptoSer.Cid)>

			<cfquery name="rsCFGen" datasource="#session.dsn#">
				select CFid
				from CFuncional
				where CFcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="RAIZ">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>

			<!--- id de Centro Funcional --->
			<cfset CentroFuncionalID = rsCFGen.CFid>

			<!--- Fecha de solicitud de pago --->
			<cfset SP_Date = DateTimeFormat(Now(),'yyyy-mm-dd hh:nn:ss')>

			<!--- Se asigna la cuenta financiera--->
			<!--- <cfset LvarCFcuentaDB = rsNominaTXEmp.CCuenta> --->
			<cfset cuentaConcepto = ObtenerDato(150)>
			<cfquery name="rsCFinanciera" datasource="#session.dsn#">
				select CFcuenta 
				from CFinanciera 
				where Ccuenta = #cuentaConcepto.Pvalor#
					and Ecodigo = #session.Ecodigo#
			</cfquery>
			<cfset LvarCFcuentaDB = rsCFinanciera.CFinanciera>

			<cfquery name="rsTES" datasource="#session.dsn#">
				Select e.TESid, t.EcodigoAdm
				from TESempresas e
				inner join Tesoreria t
					on t.TESid = e.TESid
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<cfset session.Tesoreria.TESid = rsTES.TESid>
		    <cfset session.Tesoreria.EcodigoAdm = rsTES.EcodigoAdm>
			<cflock type="exclusive" name="TesSolPago#session.Ecodigo#" timeout="3">
				<cfquery name="rsNewSol" datasource="#session.dsn#">
					select coalesce(max(TESSPnumero),0) + 1 as newSol
					from TESsolicitudPago
					where EcodigoOri = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				<cfquery datasource="#session.dsn#" name="insert">
					insert into TESsolicitudPago (
						  TESid
						, CFid
						, EcodigoOri
						, TESSPnumero
						, TESSPtipoDocumento
						, TESSPestado
						, TESBid
						, TESSPfechaPagar
						, McodigoOri
						, TESSPtipoCambioOriManual
						, TESSPtotalPagarOri
						, TESSPfechaSolicitud
						, UsucodigoSolicitud
						, BMUsucodigo
						, PagoTercero
						)
					values (
						<!---  TESid --->						  #session.Tesoreria.TESid#
						<!---  CFid --->						, #CentroFuncionalID#
						<!--- EcodigoOri --->					, <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						<!--- TESSPnumero --->					, <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNewSol.newSol#">
						<!--- TESSPtipoDocumento --->			, 0
						<!--- TESSPestado --->					, 0
						<!--- TESBid --->						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#idBeneficiario#">
						<!--- TESSPfechaPagar --->				, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#SP_Date#">
						<!--- McodigoOri --->					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#q_Moneda.Mcodigo#">
						<!--- TESSPtipoCambioOriManual --->		, 1
						<!--- TESSPtotalPagarOri --->			, <cfqueryparam cfsqltype="cf_sql_money" value="#LSNumberFormat(rsNominaTXEmp.sumHDRNliquido,'9.0000')#">
						<!--- TESSPfechaSolicitud --->			, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#SP_Date#">
						<!--- UsucodigoSolicitud --->			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
						<!--- BMUsucodigo --->					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
						<!--- PagoTercero --->					, 1
					)
					<cf_dbidentity1 datasource="#session.DSN#" name="insert">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="idE_SolicitudPago">
			</cflock>

			<!--- Se obtiene el Ocodigo para el detalle del pago--->
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select cf.Ocodigo
					from CFuncional cf
					where cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CentroFuncionalID#">
			</cfquery>

			<!--- Definicion de iva y ieps (actualmente no aplica)--->
			<cfset LvarIcodigo  = ''>
			<cfset LvarIcodieps = ''>
			<!--- INSERTA DETALLE DE ORDEN DE PAGO --->
			<cfquery name="inserted"  datasource="#session.dsn#">
				insert INTO TESdetallePago (
						  TESid
						, CFid
						, OcodigoOri
						, TESDPestado
						, EcodigoOri
						, TESSPid
						, TESDPtipoDocumento
						, TESDPidDocumento
						, TESDPmoduloOri
						, TESDPdocumentoOri
						, TESDPreferenciaOri
						, TESDPfechaVencimiento
						, TESDPfechaSolicitada
						, TESDPfechaAprobada
						, Miso4217Ori
						, TESDPmontoVencimientoOri
						, TESDPmontoSolicitadoOri
						, TESDPmontoAprobadoOri
						, TESDPmontoAprobadoLocal
						, TESDPimpNCFOri
						, TESDPdescripcion
						, CFcuentaDB
						, Icodigo
						, codIEPS
						, Cid
						, CPDCid
						, TESDPespecificacuenta
						, PagoTercero
						, TESDPtipoCambioOri
					)
				values (
						<!--- TESid --->						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
																<cfif len(trim(CentroFuncionalID))>
						<!--- CFid --->								, <cfqueryparam value="#CentroFuncionalID#" cfsqltype="cf_sql_numeric">
																<cfelse>
																	, null
																</cfif>
						<!--- OcodigoOri --->					, #rsSQL.Ocodigo#
						<!--- TESDPestado --->					, 0
						<!--- EcodigoOri --->					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						<!--- TESSPid --->						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#idE_SolicitudPago#">
						<!--- TESDPtipoDocumento --->			, 0
						<!--- TESDPidDocumento --->				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#idE_SolicitudPago#">
						<!--- TESDPmoduloOri --->				, 'TESP'
						<!--- TESDPdocumentoOri --->			, <cfqueryparam cfsqltype="cf_sql_varchar" value="RH-#Left(rsNominaTXEmp.HERNdescripcion,10)#-#DateFormat(Now(),'yymmdd')#">
						<!--- TESDPdreferenciaOri --->			, <cfqueryparam cfsqltype="cf_sql_varchar" value="Pago de Nomina">
						<!--- TESDPfechaVencimiento --->		, <cfqueryparam value="#SP_Date#" cfsqltype="cf_sql_timestamp">
						<!--- TESDPfechaSolicitada --->			, <cfqueryparam value="#SP_Date#" cfsqltype="cf_sql_timestamp">
						<!--- TESDPfechaAprobada --->			, <cfqueryparam value="#SP_Date#" cfsqltype="cf_sql_timestamp">
						<!--- Miso4217Ori --->					, <cfqueryparam cfsqltype="cf_sql_char" value="#q_Moneda.Miso4217#">
						<!--- TESDPmontoVencimientoOri --->		, round(#rsNominaTXEmp.sumHDRNliquido#,2)
						<!--- TESDPmontoSolicitadoOri --->		, round(#rsNominaTXEmp.sumHDRNliquido#,2)
						<!--- TESDPmontoAprobadoOri --->		, round(#rsNominaTXEmp.sumHDRNliquido#,2)
						<!--- TESDPmontoAprobadoLocal --->		, round(#rsNominaTXEmp.sumHDRNliquido#,2)
						<!--- TESDPimpNCFOri --->				, 0
						<!--- TESDPdescripcion --->				, null
						<!--- CFcuentaDB --->					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCFcuentaDB#">
																<cfif len(trim(LvarIcodigo))>
						<!--- Icodigo --->							, <cfqueryparam cfsqltype="cf_sql_char"    value="#LvarIcodigo#">
																<cfelse>
																	, null
																</cfif>
																<cfif len(trim(LvarIcodieps))>
						<!--- codIEPS --->	   						, <cfqueryparam cfsqltype="cf_sql_char"    value="#LvarIcodieps#">
																<cfelse>
																	, null
																</cfif>
						<!--- Cid --->							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#ConceptoServicioID#">
						<!--- CPDCid ---> 						, null
						<!--- TESDPespecificacuenta --->		, 0
						<!--- PagoTercero --->					, 1
						<!--- TESDPtipoCambioOri --->			, 1
						)
				<!--- <cf_dbidentity1 datasource="#session.DSN#" name="insertd" returnvariable="LvarTESDPid"> --->
			</cfquery>
		</cfloop>
	</cfif>


	</cftransaction>

</cfif>

<form action="<cfoutput>#action#</cfoutput>" method="post" name="SQLform">
	<input name="ERNid" type="hidden" value="<cfoutput>#Form.ERNid#</cfoutput>">
</form>

</body>
</html>
<script language="JavaScript" type="text/javascript">document.SQLform.submit();</script>

<cffunction name="ObtenerDato" returntype="query">
	<cfargument name="pcodigo" type="numeric" required="true">
	<cfquery name="rs" datasource="#session.DSN#">
		select Pvalor
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pcodigo#">
	</cfquery>
	<cfreturn #rs#>
</cffunction>