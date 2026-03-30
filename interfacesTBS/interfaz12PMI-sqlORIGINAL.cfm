<cfsetting enablecfoutputonly="yes">
<cfsetting requesttimeout="900">

<cfset vFechaI = createdate(right(form.FechaI,4),mid(form.FechaI,4,2),left(form.FechaI,2))>
<cfset vFechaF = createdatetime(right(form.FechaF,4),mid(form.FechaF,4,2),left(form.FechaF,2),23,59,59)>

<cfsetting enablecfoutputonly="yes">
<cfparam name="FechaI" default="">
<cfparam name="FechaF" default="">

<cfquery name="rsEmpresaSeleccionada" datasource="sifinterfaces">
	select 	Ecodigo,CodICTS,EcodigoSDCSoin
	from int_ICTS_SOIN
	where Ecodigo = #session.Ecodigo#
</cfquery>

<cf_htmlreportsheaders
	title="Importacion de Neteos" 
	filename="ImportaNeteos-#Session.Usucodigo#.xls" 
	ira="ConsIE12.cfm">
<cf_templatecss>

<cfoutput>

<cfset LvarSocioN = ''>
<cfif isdefined("form.SocioN") and len(trim(form.SocioN)) >
	<cfset LvarSocioN = form.SocioN >
<cfelse>
	<cfset LvarSocioN = 'nada' >
</cfif>



<cfset LvarDocumentoOrigen = "">
<table width="100%" border="1">
	<tr><td colspan="1" align="center"><strong>Reporte de Proceso</strong></td>
	<tr><td colspan="1" align="center"><strong>Proceso de Carga de Neteos</strong></td>
	<tr><td colspan="1" align="center"><strong>Fechas:  #LsDateFormat(vFechaI,'dd/mm/yyyy')# - #LsDateFormat(vFechaF,'dd/mm/yyyy')#</strong></td>
	<tr><td colspan="1">&nbsp;</td></tr>
</cfoutput>
<cfflush interval="40">


<!--- 1.Seleccionar los registros a procesar. Tienen codigo de Empresa Anterior y deben generar encabezado / Detalle --->

	<cfquery name="rsRegistrosProcesar" datasource="sifinterfaces">
			select  EcodigoSDC,ModuloOrigen,CodigoMonedaOrigen,NumeroSocioDocOrigen,CodigoTransacionOrig,DocumentoOrigen,
			sum(MontoOrigen) as MontoOrigen,ModuloDestino,CodigoMonedaDestino,NumeroSocioDocDestino,CodigoTransacionDest,
			TipoCambio,FechaAplicacion
			from IE12
			where EcodigoSDC=#rsEmpresaSeleccionada.CodICTS#
			and Procesado='N'
		  <cfif isdefined("LvarSocioN") and LvarSocioN NEQ 'nada'>
		  and NumeroSocioDocDestino = '#LvarSocioN#'
	 	  </cfif>
				<cfif isdefined("form.Moneda") and len(trim(form.Moneda)) gt 0>
				  and CodigoMonedaDestino = '#form.Moneda#'
			    </cfif>
			and FechaAplicacion between #vFechaI# and #vFechaF#
			group by  EcodigoSDC,ModuloOrigen,CodigoMonedaOrigen,NumeroSocioDocOrigen,CodigoTransacionOrig,DocumentoOrigen,
			ModuloDestino,CodigoMonedaDestino,NumeroSocioDocDestino,CodigoTransacionDest,TipoCambio,FechaAplicacion
	</cfquery>
<cftransaction>
<cfoutput>
<cfloop query="rsRegistrosProcesar">
	<tr><td colspan="1" align="left">Procesando Documento: #rsRegistrosProcesar.EcodigoSDC# / #rsRegistrosProcesar.DocumentoOrigen# Fecha: #LsDateFormat(rsRegistrosProcesar.FechaAplicacion,'dd/mm/yyyy')# </td>

		<cfset LvarId = 0 >
			<cfif LvarDocumentoOrigen NEQ rsRegistrosProcesar.DocumentoOrigen >
				<cfquery datasource="sifinterfaces">
					update IdProceso
					set Consecutivo = Consecutivo + 1			
				</cfquery>
				<cfquery name="rsObtieneSigId" datasource="sifinterfaces">
					select Consecutivo
					from IdProceso
				</cfquery>
				<cfset LvarID = rsObtieneSigId.consecutivo>
				<cfset LvarConsecutivoID10 = 0>
								
<!--- Ciclo de Procesamiento de los Registros --->

	
		<cfquery datasource="sifinterfaces">
			insert into IE12(
			 ID,EcodigoSDC,ModuloOrigen,CodigoMonedaOrigen,NumeroSocioDocOrigen,CodigoTransacionOrig,DocumentoOrigen,MontoOrigen,
			 ModuloDestino,CodigoMonedaDestino,NumeroSocioDocDestino,CodigoTransacionDest,TipoCambio,FechaAplicacion,DocumentoDestino,MontoDestino,TransaccionOrigen
			)
			values (
				 #LvarID#,
				 #rsEmpresaSeleccionada.EcodigoSDCSoin#,
				'#rsRegistrosProcesar.ModuloOrigen#',
				'#rsRegistrosProcesar.CodigoMonedaOrigen#',  
				'#rsRegistrosProcesar.NumerosocioDocOrigen#', 
				'#rsRegistrosProcesar.CodigoTransacionOrig#', 
				'#rsRegistrosProcesar.DocumentoOrigen#', 
				#rsRegistrosProcesar.MontoOrigen#, 
				'#rsRegistrosProcesar.Modulodestino#', 
				'#rsRegistrosProcesar.CodigoMonedaDestino#', 
				'#rsRegistrosProcesar.NumeroSocioDocDestino#', 
				'#rsRegistrosProcesar.CodigoTransacionDest#', 
				#rsRegistrosProcesar.TipoCambio#, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#rsRegistrosProcesar.FechaAplicacion#">,
				'-1',-1,'#LvarID#'
				)
		</cfquery>
		
		
		
		<cfquery datasource="sifinterfaces">
				insert into ID12 (ID,NumeroSocioDoc,Modulo,CodigoTransaccion,Documento,Monto) 
			values (
				 #LvarID#,
				'#rsRegistrosProcesar.NumerosocioDocOrigen#', 
				'#rsRegistrosProcesar.ModuloOrigen#',
				'#rsRegistrosProcesar.CodigoTransacionOrig#', 
				'#rsRegistrosProcesar.DocumentoOrigen#', 
				#rsRegistrosProcesar.MontoOrigen#
				)
		</cfquery>

		<!--- 2. Insertar en IE12 con EcodigoSDC = rsEmpresaSeleccionada.EcodigoSDC --->
		<!--- Copiar los detalles de IE12 a ID12 con el ID nuevo encontrado --->
		<cfset LvarDocumentoOrigen = rsRegistrosProcesar.DocumentoOrigen >
	<cfif LvarID GT 0>
		<cfquery datasource="sifinterfaces">
			insert into ID12 (ID,NumeroSocioDoc,Modulo,CodigoTransaccion,Documento,Monto) 
			select #LvarID#,NumeroSocioDocOrigen,ModuloDestino,CodigoTransacionDest,DocumentoDestino,sum(MontoDestino) as MontoDestino
			from IE12
			where EcodigoSDC= #rsEmpresaSeleccionada.CodICTS#
			and Procesado='N'
			and DocumentoOrigen='#rsRegistrosProcesar.DocumentoOrigen#'
				<cfif isdefined("LvarSocioN") and LvarSocioN NEQ 'nada'>
				  and NumeroSocioDocDestino = '#LvarSocioN#'
		 	    </cfif>
				<cfif isdefined("form.Moneda") and len(trim(form.Moneda)) gt 0>
				  and CodigoMonedaDestino = '#form.Moneda#'
			    </cfif>
	  			and FechaAplicacion between #vFechaI# and #vFechaF#
			group by  NumeroSocioDocOrigen,ModuloDestino,CodigoTransacionDest,DocumentoDestino

		</cfquery>

	</cfif>
	</cfif>
</cfloop>


<!--- Inclusión de movimiento en cola de proceso --->

		<cfquery name="rsIE12" datasource="sifinterfaces">
				select ID, EcodigoSDC,DocumentoOrigen
				from IE12
				where EcodigoSDC= #rsEmpresaSeleccionada.EcodigoSDCSoin#
				and ID not in (select IdProceso from InterfazBitacoraProcesos where EcodigoSDC= #rsEmpresaSeleccionada.EcodigoSDCSoin# and NumeroInterfaz=12) 
			  	and ID not in(select IdProceso from InterfazColaProcesos where EcodigoSDC= #rsEmpresaSeleccionada.EcodigoSDCSoin# and NumeroInterfaz=12)
				and Procesado='N'
		</cfquery>
<cfloop query="rsIE12"> 
		<cfquery datasource="sifinterfaces">
			insert InterfazColaProcesos
			(CEcodigo, NumeroInterfaz, IdProceso, SecReproceso, EcodigoSDC, OrigenInterfaz,
			 TipoProcesamiento,StatusProceso, FechaInclusion, UsucodigoInclusion, Cancelar)
			values (
			  <cfqueryparam cfsqltype="cf_sql_numeric" value=2>,
			  <cfqueryparam cfsqltype="cf_sql_integer" value=12>,
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIE12.ID#">,
			  <cfqueryparam cfsqltype="cf_sql_integer" value=0>,
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIE12.EcodigoSDC#">,
			  <cfqueryparam cfsqltype="cf_sql_char" value="E">,
			  <cfqueryparam cfsqltype="cf_sql_char" value="A">,
			  <cfqueryparam cfsqltype="cf_sql_integer" value=1>,
			  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
			  <cfqueryparam cfsqltype="cf_sql_bit" value=0>)
		</cfquery>
		<!--- Marcar los Registros como procesados --->
		<cfquery datasource="sifinterfaces">
			update IE12
			set Procesado='S'
			where EcodigoSDC     = #rsEmpresaSeleccionada.CodICTS#
			and DocumentoOrigen  = '#trim(rsIE12.DocumentoOrigen)#'
		</cfquery>
		<cfquery datasource="sifinterfaces">
			update IE12
			set Procesado='S'
			where EcodigoSDC       =  #rsRegistrosProcesar.EcodigoSDC#
			and ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIE12.ID#">
		</cfquery>
			
</cfloop>
		<cfquery datasource="sifinterfaces">
			update IE12
			set Procesado='S'
			where EcodigoSDC       =  #rsEmpresaSeleccionada.EcodigoSDCSoin#
			and Procesado='N'
		</cfquery>
		</cfoutput>
 </cftransaction>	
	<cfoutput>
		<tr><td colspan="9">&nbsp;</td></tr>
		<tr><td colspan="9" align="center"><strong>Fin.</strong></td>
	</cfoutput>
	</table>
	<cfabort>

