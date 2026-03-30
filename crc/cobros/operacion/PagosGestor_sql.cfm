<!--- Incluir datos de la tesoreria de la empresa --->
<cfinclude template="../../../sif/tesoreria/Solicitudes/TESid_Ecodigo.cfm">

<!--- Obtiene el id de Beneficiario, si no existe, lo crea --->
<cfquery name="q_DatosEpleados" datasource="#session.dsn#">
	select DEid, DEidentificacion from DatosEmpleado where DEid = #form.BeneficiarioID# and Ecodigo = #Session.Ecodigo#
</cfquery>

<cfquery name="q_beneficiario" datasource="#session.dsn#">
	select * from TESbeneficiario where TESBeneficiarioId = '#q_DatosEpleados.DEidentificacion#'
</cfquery>

<cfif q_beneficiario.RecordCount eq 0>
	<cfquery name="q_InsertBeneficiario" datasource="#session.dsn#">
		insert into TESbeneficiario (CEcodigo,TESBeneficiarioId,TESBeneficiario,TESBtipoId,
				TESBtelefono,TESBemail,DEid,TESBactivo)
		select #session.cecodigo# as CEcodigo,DEidentificacion,concat(DEnombre,'',DEapellido1,' ',DEapellido2),
				DEsexo,DEtelefono1,DEemail,DEid,1 
		from DatosEmpleado 
		where DEid = #form.BeneficiarioID#;
		<!--- <cf_dbidentity1 datasource="#session.DSN#"> --->
	</cfquery>
	<!---
	<cf_dbidentity2 datasource="#session.DSN#" name="q_InsertBeneficiario">	
	<cfset idBeneficiario = q_InsertBeneficiario.identity>
	--->
	<cfquery name="q_beneficiario" datasource="#session.dsn#">
		select * from TESbeneficiario where DEid = #form.BeneficiarioID# and Ecodigo = #Session.Ecodigo#;
	</cfquery>
</cfif>
<cfset idBeneficiario = q_beneficiario.TESBid>

<!--- Obtener Codigo de Moneda Local (Moneda de Empresa) --->
<cfquery name="q_Moneda" datasource="#session.dsn#">
	select e.Mcodigo, m.Miso4217
	from empresas e
		inner join Monedas m
			on m.Mcodigo = e.Mcodigo
	where e.Ecodigo = #session.ecodigo#;
</cfquery>

<!--- id de concepto, crear parametro Cid--->
<cfset ConceptoServicioID = form.CID>

<!--- id de Centro Funcional --->
<cfset CentroFuncionalID = form.CBOCFID>

<!--- Fecha de solicitud de pago --->
<cfset SP_Date = DateTimeFormat(Now(),'yyyy-mm-dd hh:nn:ss')>

	<!--- Se asigna la cuenta financiera--->
	<cfset LvarCFcuentaDB = form.CCuenta>

<!--- INSERTA ENCABEZADO DE ORDEN DE PAGO --->
<cfset idE_SolicitudPago = 0>

<cfset crcParametros = createobject("component","crc.Componentes.CRCParametros")>
<cfset creaSP = crcParametros.GetParametro(codigo='30300103',conexion=session.dsn,ecodigo=session.ecodigo)>

<cfif creaSP eq 'S'>
	<cftransaction>

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
					<!--- TESSPtotalPagarOri --->			, <cfqueryparam cfsqltype="cf_sql_money" value="#form.ComisionTotal#">
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
		<cfif isdefined('form.Icodigo') and len(trim(form.Icodigo))>
			<cfset LvarIcodigo  = form.Icodigo>
			<cfset LvarIcodieps = form.Icodigo>
			<cfquery name ="rsEvaluaIeps" datasource ="#session.dsn#">
				select Icodigo
					from Impuestos
				where Ecodigo = #session.Ecodigo#
					and ieps = 1
					and Icodigo = '#form.Icodigo#'
			</cfquery>
			<cfif 	rsEvaluaIeps.recordcount gt 0 >
				<cfset LvarIcodigo = ''>
			</cfif>
			<cfif LvarIcodigo neq ''>
				<cfquery name ="rsEvaluaIva" datasource ="#session.dsn#">
					select Icodigo
						from Impuestos
					where Ecodigo = #session.Ecodigo#
						and (ieps != 1 or  ieps is null)
						and Icodigo = '#form.Icodigo#'
				</cfquery>
				<cfif 	rsEvaluaIva.recordcount gt 0 >
					<cfset LvarIcodieps = ''>
				</cfif>
			</cfif>
		</cfif>

	<!--- INSERTA DETALLE DE ORDEN DE PAGO --->

		<cfquery name="insertd"  datasource="#session.dsn#">
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
					<!--- TESid --->						  #session.Tesoreria.TESid#
															<cfif len(trim(CentroFuncionalID))>
					<!--- CFid --->								, <cfqueryparam value="#CentroFuncionalID#" cfsqltype="cf_sql_numeric">
															<cfelse>
																, <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
															</cfif>
					<!--- OcodigoOri --->					, #rsSQL.Ocodigo#
					<!--- TESDPestado --->					, 0
					<!--- EcodigoOri --->					, <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					<!--- TESSPid --->						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#idE_SolicitudPago#">
					<!--- TESDPtipoDocumento --->			, 0
					<!--- TESDPidDocumento --->				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#idE_SolicitudPago#">
					<!--- TESDPmoduloOri --->				, 'TESP'
					<!--- TESDPdocumentoOri --->			, <cfqueryparam cfsqltype="cf_sql_varchar" value="CRC-SPG-#idE_SolicitudPago#-#DateFormat(Now(),'yymmdd')#">
					<!--- TESDPdreferenciaOri --->			, <cfqueryparam cfsqltype="cf_sql_varchar" value="Pago Gestor">
					<!--- TESDPfechaVencimiento --->		, <cfqueryparam value="#SP_Date#" cfsqltype="cf_sql_timestamp">
					<!--- TESDPfechaSolicitada --->			, <cfqueryparam value="#SP_Date#" cfsqltype="cf_sql_timestamp">
					<!--- TESDPfechaAprobada --->			, <cfqueryparam value="#SP_Date#" cfsqltype="cf_sql_timestamp">
					<!--- Miso4217Ori --->					, <cfqueryparam cfsqltype="cf_sql_char" value="#q_Moneda.Miso4217#">
					<!--- TESDPmontoVencimientoOri --->		, round(#form.COMISIONTOTAL#,2)
					<!--- TESDPmontoSolicitadoOri --->		, round(#form.COMISIONTOTAL#,2)
					<!--- TESDPmontoAprobadoOri --->		, round(#form.COMISIONTOTAL#,2)
					<!--- TESDPmontoAprobadoLocal --->		, round(#form.COMISIONTOTAL#,2)
					<!--- TESDPimpNCFOri --->				, 0
					<!--- TESDPdescripcion --->				, null
					<!--- CFcuentaDB --->					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCFcuentaDB#">
															<cfif len(trim(LvarIcodigo))>
					<!--- Icodigo --->							, <cfqueryparam cfsqltype="cf_sql_char"    value="#LvarIcodigo#">
															<cfelse>
																, <CF_jdbcquery_param cfsqltype="cf_sql_char"  value="null">
															</cfif>
															<cfif len(trim(LvarIcodieps))>
					<!--- codIEPS --->	   						, <cfqueryparam cfsqltype="cf_sql_char"    value="#LvarIcodieps#">
															<cfelse>
																, <CF_jdbcquery_param cfsqltype="cf_sql_char"  value="null">
															</cfif>
					<!--- Cid --->							, <cfqueryparam value="#ConceptoServicioID#" cfsqltype="cf_sql_numeric" null="#ConceptoServicioID EQ ""#">
					<!--- CPDCid ---> 						, <CF_jdbcquery_param cfsqltype="cf_sql_numeric"  value="null">
					<!--- TESDPespecificacuenta --->		, 0
					<!--- PagoTercero --->					, (select PagoTercero from TESsolicitudPago where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idE_SolicitudPago#" null="#Len(idE_SolicitudPago) Is 0#">)
					<!--- TESDPtipoCambioOri --->			, 1
					)
			<cf_dbidentity1 datasource="#session.DSN#" name="insertd" returnvariable="LvarTESDPid">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insertd" returnvariable="LvarTESDPid">

	</cftransaction>
</cfif>

<cfif creaSP neq 'S'>
	<cfset idE_SolicitudPago = -1>
</cfif>

<cfif idE_SolicitudPago neq 0>
	<cfquery datasource="#session.dsn#">
		insert into CRCPagoGestor (ETnumero,TESSPid,MontoComision,Ecodigo,createdat,Usucrea)
		select e.ETnumero,#idE_SolicitudPago#, round(sum(d.DTpreciou*d.CRCDEidPorc/100),2),#session.ecodigo#,CURRENT_TIMESTAMP,#session.usucodigo#
			from ETransacciones e
			inner join DTransacciones d
				on d.ETnumero = e.ETnumero
			where e.ETnumero in (#form.ETnumeros#) group by e.ETnumero;
	</cfquery>
</cfif>

<script>
	window.location.replace('PagosGestor.cfm?num=<cfif creaSP eq "S"><cfoutput>#rsNewSol.newSol#</cfoutput>&ben=<cfoutput>#idBeneficiario#</cfoutput><cfelse>-1</cfif>');
</script>