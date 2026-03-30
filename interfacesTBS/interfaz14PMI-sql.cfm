<cfsetting enablecfoutputonly="yes">
<cfsetting requesttimeout="900">

<cfset vFechaI = createdate(right(form.FechaI,4),mid(form.FechaI,4,2),left(form.FechaI,2))>
<cfset vFechaF = createdatetime(right(form.FechaF,4),mid(form.FechaF,4,2),left(form.FechaF,2),23,59,59)>

<cfsetting enablecfoutputonly="yes">
<cfparam name="FechaI" default="">
<cfparam name="FechaF" default="">


<cfquery name="rsCodICTS" datasource="sifinterfaces">
	select EQUempOrigen as CodICTS, EQUempSIF as Ecodigo, EQUcodigoSIF as EcodigoSDC, EQUdescripcion as Edescripcion
	from SIFLD_Equivalencia
	where EQUcodigoSIF = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
	and CATcodigo = 'CADENA'
</cfquery>

<cfif isdefined("url.CodICTS") and not isdefined("form.CodICTS")>
	<cfset form.CodICTS = url.CodICTS>
	<cfset varCodICTS = form.CodICTS>
<cfelseif isdefined("form.CodICTS")>
	<cfset varCodICTS = form.CodICTS>
</cfif>	

<cfif isdefined("url.EcodigoSDC") and not isdefined ("form.EcodigoSDC")>
	<cfset form.EcodigoSDC = url.EcodigoSDC>
	<cfset varEcodigoSDC = form.EcodigoSDC>
<cfelseif isdefined ("form.EcodigoSDC")>	
	<cfset varEcodigoSDC = form.EcodigoSDC>
</cfif>

<cf_htmlreportsheaders
	title="Importacion de Transferencias entre Cuentas" 
	filename="ImportaTransferencias-#Session.Usucodigo#.xls" 
	ira="ConsIE14.cfm">
<cf_templatecss>

<cfoutput>

<table width="100%" border="1">
	<tr><td colspan="1" align="center"><strong>Reporte de Proceso</strong></td>
	<tr><td colspan="1" align="center"><strong>Proceso de Registro de Transferencias entre Cuentas</strong></td>
	<tr><td colspan="1" align="center"><strong>Fechas:  #LsDateFormat(vFechaI,'dd/mm/yyyy')# - #LsDateFormat(vFechaF,'dd/mm/yyyy')#</strong></td>
	<tr><td colspan="1">&nbsp;</td></tr>
</cfoutput>
<cfflush interval="40">


<!--- 1.Seleccionar los registros a procesar. Tienen codigo de Empresa Anterior y deben generar encabezado  --->
<cfquery name="rsRegistrosProcesar" datasource="sifinterfaces" result = "resultadoRsRegistrosProcesar"> <!---sifinterfacessybase--->
		SELECT  EcodigoSDC, CodigoBancoOrigen, CuentaBancariaOrigen, TipoMovimientoOrigen, CodigoMonedaOrigen, 
    	MontoOrigen, MontoComision, CodigoBancoDestino, CuentaBancariaDestino, TipoMovimientoDestino, CodigoMonedaDestino,
		MontoDestino, FechaValor, Observacion, FechaAplicacion, ConceptoComision, IndMovConta, BMUsucodigo, 
		Estimacion, NumeroDocumento, TipoCambio, ImpRetencion, CodRentencion, Procesado 
		FROM  IE14
		where EcodigoSDC = convert(int,#varEcodigoSDC#)
		and Procesado='N'
        <cfif isdefined("form.Moneda") and len(trim(form.Moneda)) NEQ ''>
			and CodigoMonedaDestino = '#form.Moneda#'
	    </cfif>
		and FechaAplicacion between #vFechaI# and #vFechaF#		
</cfquery>

<cfoutput>
<cfif rsRegistrosProcesar.RecordCount EQ 0 >
	<tr><td colspan="1" align="center"><strong>No  hay  Registros... </td>
</cfif>
<cfloop query="rsRegistrosProcesar">
<tr><td colspan="1" align="left">Procesando Documento: #rsRegistrosProcesar.EcodigoSDC#  Fecha: #LsDateFormat(rsRegistrosProcesar.FechaAplicacion,'dd/mm/yyyy')# </td>

	<cfset LvarId = 0 >
	
		<cfquery datasource="sifinterfaces">
			update IdProceso
			set Consecutivo = Consecutivo + 1			
		</cfquery>
		
		<cfquery name="rsObtieneSigId" datasource="sifinterfaces">
			select Consecutivo
			from IdProceso
		</cfquery>
		
		<cfset LvarID = rsObtieneSigId.consecutivo>
		
								
	<cftransaction action="begin">
	<cftry>

<!--- Ciclo de Procesamiento de los Registros --->
		<cfquery datasource="sifinterfaces">
			insert into IE14(ID,
							EcodigoSDC,
							CodigoBancoOrigen,
							CuentaBancariaOrigen,
							TipoMovimientoOrigen,
							CodigoMonedaOrigen,
							MontoOrigen,
							MontoComision,
							CodigoBancoDestino,
							CuentaBancariaDestino,
							TipoMovimientoDestino,
							CodigoMonedaDestino,
							MontoDestino,
							FechaValor,
							Observacion,
							FechaAplicacion,
							ConceptoComision,
							IndMovConta,
							Estimacion,
							NumeroDocumento,
							TipoCambio,
							ImpRetencion,
							CodRentencion,
							Procesado)
					values (#LvarID#,
						 	#rsCodICTS.EcodigoSDC#,
							'#rsRegistrosProcesar.CodigoBancoOrigen#',
							'#rsRegistrosProcesar.CuentaBancariaOrigen#',  
							'#rsRegistrosProcesar.TipoMovimientoOrigen#', 
							'#rsRegistrosProcesar.CodigoMonedaOrigen#', 
							#rsRegistrosProcesar.MontoOrigen#, 
							#rsRegistrosProcesar.MontoComision#, 
							'#rsRegistrosProcesar.CodigoBancoDestino#', 
							'#rsRegistrosProcesar.CuentaBancariaDestino#', 
							'#rsRegistrosProcesar.TipoMovimientoDestino#', 
							'#rsRegistrosProcesar.CodigoMonedaDestino#', 
							#rsRegistrosProcesar.MontoDestino#, 
							'#rsRegistrosProcesar.FechaValor#',
							'#rsRegistrosProcesar.Observacion#',
							'#rsRegistrosProcesar.FechaAplicacion#',
							'#rsRegistrosProcesar.ConceptoComision#',
							'#rsRegistrosProcesar.IndMovConta#',
							#rsRegistrosProcesar.Estimacion#,
							'#rsRegistrosProcesar.NumeroDocumento#',
							<cfif #rsRegistrosProcesar.TipoCambio# EQ ''>
									null,
							<cfelse>
								#rsRegistrosProcesar.TipoCambio#,
							</cfif>														
							#rsRegistrosProcesar.ImpRetencion#,
							'#rsRegistrosProcesar.CodRentencion#',
							'#rsRegistrosProcesar.Procesado#')
		</cfquery>
	 <cfcatch>
		<cftransaction action="rollback"/>
		<cfthrow message="Error al insertar el registro #cfcatch.Message#" detail="#cfcatch.Detail#">
	 </cfcatch>
	 </cftry>					
	<cftransaction action="commit"/>
	</cftransaction>
	 
</cfloop>


<!--- Inclusión de movimiento en cola de proceso --->
		<cftry>
			<cfquery name="rsIE14" datasource="sifinterfaces">
				select ID, EcodigoSDC
				from IE14
				where EcodigoSDC= #rsCodICTS.EcodigoSDC#
				and ID not in (select IdProceso from InterfazBitacoraProcesos where EcodigoSDC= #rsCodICTS.EcodigoSDC# and 
				NumeroInterfaz=14) 
			  	and ID not in(select IdProceso from InterfazColaProcesos where EcodigoSDC= #rsCodICTS.EcodigoSDC# and NumeroInterfaz=14)
				and Procesado='N'
			</cfquery>
			
			<cfloop query="rsIE14"> 
				<cfquery datasource="sifinterfaces">
					insert InterfazColaProcesos
					(CEcodigo, NumeroInterfaz, IdProceso, SecReproceso, EcodigoSDC, OrigenInterfaz,
					 TipoProcesamiento,StatusProceso, FechaInclusion, UsucodigoInclusion,UsuarioBdInclusion, Cancelar)
					values (
					  <cfqueryparam cfsqltype="cf_sql_numeric" value=2>,
					  <cfqueryparam cfsqltype="cf_sql_integer" value=14>,
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIE14.ID#">,
					  <cfqueryparam cfsqltype="cf_sql_integer" value=0>,
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIE14.EcodigoSDC#">,
					  <cfqueryparam cfsqltype="cf_sql_char" value="E">,
					  <cfqueryparam cfsqltype="cf_sql_char" value="A">,
					  <cfqueryparam cfsqltype="cf_sql_integer" value=1>,
					  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
					  <cfqueryparam cfsqltype="cf_sql_char" value="#session.usuario#">,
					  <cfqueryparam cfsqltype="cf_sql_bit" value=0>)
				</cfquery>
				
				<cfquery datasource="sifinterfaces">
					update IE14
					set Procesado='S'
					where EcodigoSDC       =  <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigoSDC#">
					and ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIE14.ID#">
				</cfquery>	
			</cfloop>
				
			<cfloop query="rsRegistrosProcesar">
				<cfquery datasource="sifinterfaces"> <!---sifinterfacessybase--->
					update IE14
					set Procesado='S'
					where EcodigoSDC     = <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigoSDC#">
					and CodigoBancoOrigen = '#rsRegistrosProcesar.CodigoBancoOrigen#'
					and CuentaBancariaOrigen = '#rsRegistrosProcesar.CuentaBancariaOrigen#'
					and TipoMovimientoOrigen = '#rsRegistrosProcesar.TipoMovimientoOrigen#' 
					and CodigoMonedaOrigen = '#rsRegistrosProcesar.CodigoMonedaOrigen#'
					and MontoOrigen = #rsRegistrosProcesar.MontoOrigen#
					and CodigoBancoDestino = '#rsRegistrosProcesar.CodigoBancoDestino#'
					and CuentaBancariaDestino = '#rsRegistrosProcesar.CuentaBancariaDestino#'
					and TipoMovimientoDestino = '#rsRegistrosProcesar.TipoMovimientoDestino#'
					and CodigoMonedaDestino = '#rsRegistrosProcesar.CodigoMonedaDestino#'
					and NumeroDocumento = '#rsRegistrosProcesar.NumeroDocumento#'
					and Procesado =  'N'
				</cfquery>
			</cfloop>
			
			<cfquery datasource="sifinterfaces">
				update IE14
				set Procesado='S'
				where EcodigoSDC       =  #rsCodICTS.EcodigoSDC#
				and Procesado='N'
			</cfquery>
			
		<cfcatch>			
			<cfquery datasource="sifinterfaces">
				delete IE14 where ID = #LvarID#
			</cfquery>
			<cfquery datasource="sifinterfaces">
				delete InterfazColaProcesos where IdProceso = #LvarID# and NumeroInterfaz = 14
			</cfquery>
			<cfthrow message="Error al actualizar la tabla intermedia #cfcatch.Message#" detail="#cfcatch.Detail#">
		</cfcatch>
		</cftry>	
</cfoutput>
 				
	<cfoutput>
		<tr><td colspan="9">&nbsp;</td></tr>
		<tr><td colspan="9" align="center"><strong>Fin.</strong></td>
	</cfoutput>
	</table>
	<cfabort>

