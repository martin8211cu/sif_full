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
<cfquery name="rsRegistrosProcesar" datasource="sifinterfaces"> <!---sifinterfacessybase--->
		select  EcodigoSDC,ModuloOrigen,CodigoMonedaOrigen,NumeroSocioDocOrigen,CodigoTransacionOrig,DocumentoOrigen,
		sum(MontoOrigen) as MontoOrigen,ModuloDestino,CodigoMonedaDestino,NumeroSocioDocDestino,CodigoTransacionDest,
		TipoCambio,FechaAplicacion
		from icts_soin.IE12
		where EcodigoSDC=<cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">
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

<cfoutput>
<cftry>
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
			insert into IE12(ID,
							EcodigoSDC,
							ModuloOrigen,
							CodigoMonedaOrigen,
							NumeroSocioDocOrigen,
							CodigoTransacionOrig,
							DocumentoOrigen,
							MontoOrigen,
							ModuloDestino,							
							CodigoMonedaDestino,	
							NumeroSocioDocDestino,
							CodigoTransacionDest,
							TipoCambio,
							FechaAplicacion,
							DocumentoDestino,
							MontoDestino,
							TransaccionOrigen)
					values (#LvarID#,
						 	#rsCodICTS.EcodigoSDC#,
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
							'-1',
							-1,
							'#LvarID#')
		</cfquery>
		
		<cfquery datasource="sifinterfaces">
				insert into ID12 (ID,
								  NumeroSocioDoc,
								  Modulo,
								  CodigoTransaccion,
								  Documento,
								  Monto) 
						  values (#LvarID#,
								'#rsRegistrosProcesar.NumerosocioDocOrigen#', 
								'#rsRegistrosProcesar.ModuloOrigen#',
								'#rsRegistrosProcesar.CodigoTransacionOrig#', 
								'#rsRegistrosProcesar.DocumentoOrigen#', 
								#rsRegistrosProcesar.MontoOrigen#)
		</cfquery>
		
		<cfquery name="rsMonto" datasource="sifinterfaces"> <!---sifinterfacessybase--->
			select Monto=(select sum(MontoOrigen) 
			from icts_soin.IE12 
			where DocumentoOrigen='#rsRegistrosProcesar.DocumentoOrigen#'
			and EcodigoSDC= <cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">  and Procesado='N' group by 			        	DocumentoOrigen ) 
		</cfquery>
		
		<cfset Monto = rsMonto.Monto>
			
		<cfquery datasource="sifinterfaces">
			update ID12 set Monto= <cfqueryparam cfsqltype="cf_sql_money" value="#Monto#"> where Documento = '#rsRegistrosProcesar.DocumentoOrigen#'
		</cfquery>

		<!--- 2. Insertar en IE12 con EcodigoSDC = rsEmpresaSeleccionada.EcodigoSDC --->
		<!--- Copiar los detalles de IE12 a ID12 con el ID nuevo encontrado --->
		<cfset LvarDocumentoOrigen = rsRegistrosProcesar.DocumentoOrigen >
		<cfif LvarID GT 0>
		
		<cfquery name="rsDetalleID12" datasource="sifinterfaces"> <!---sifinterfacessybase--->
			select #LvarID# as LvarID, NumeroSocioDocOrigen, ModuloDestino, CodigoTransacionDest, DocumentoDestino, sum(MontoDestino) as MontoDestino
			from icts_soin.IE12
			where EcodigoSDC= <cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">
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
		
        <cfloop query="rsDetalleID12">	
			<cfquery datasource="sifinterfaces">
				insert into ID12 (ID,
								NumeroSocioDoc,
								Modulo,
								CodigoTransaccion,
								Documento,
								Monto) 
						values (<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDetalleID12.LvarID#">, 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDetalleID12.NumeroSocioDocOrigen#">, 			    	    	                <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDetalleID12.ModuloDestino#">, 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDetalleID12.CodigoTransacionDest#">, 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDetalleID12.DocumentoDestino#">,  			                	    	    <cfqueryparam cfsqltype="cf_sql_money" value="#rsDetalleID12.MontoDestino#">)						
			</cfquery>
		</cfloop>
	</cfif>
	</cfif>
	 
</cfloop>


<!--- Inclusión de movimiento en cola de proceso --->
				<cfquery name="rsIE12" datasource="sifinterfaces">
				select ID, EcodigoSDC,DocumentoOrigen
				from IE12
				where EcodigoSDC= #rsCodICTS.EcodigoSDC#
				and ID not in (select IdProceso from InterfazBitacoraProcesos where EcodigoSDC= #rsCodICTS.EcodigoSDC# and NumeroInterfaz=12) 
			  	and ID not in(select IdProceso from InterfazColaProcesos where EcodigoSDC= #rsCodICTS.EcodigoSDC# and NumeroInterfaz=12)
				and Procesado='N'
			</cfquery>
			<cfloop query="rsIE12"> 
				<cfquery datasource="sifinterfaces">
					insert InterfazColaProcesos
					(CEcodigo, NumeroInterfaz, IdProceso, SecReproceso, EcodigoSDC, OrigenInterfaz,
					 TipoProcesamiento,StatusProceso, FechaInclusion, UsucodigoInclusion,UsuarioBdInclusion, Cancelar)
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
					  <cfqueryparam cfsqltype="cf_sql_char" value="#session.usuario#">,
					  <cfqueryparam cfsqltype="cf_sql_bit" value=0>)
				</cfquery>
				<cfquery datasource="sifinterfaces">
					update IE12
					set Procesado='S'
					where EcodigoSDC       =  <cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">
					and ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIE12.ID#">
				</cfquery>	
			
				<cfquery datasource="sifinterfaces"> <!---sifinterfacessybase--->
					update icts_soin.IE12
					set Procesado='S'
					where EcodigoSDC     = <cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">
					and DocumentoOrigen  = '#trim(rsIE12.DocumentoOrigen)#'
				</cfquery>
					
			</cfloop>
			<cfquery datasource="sifinterfaces">
				update IE12
				set Procesado='S'
				where EcodigoSDC       =  #rsCodICTS.EcodigoSDC#
				and Procesado='N'
			</cfquery>
		<cfcatch>
			<cfquery datasource="sifinterfaces">
				delete ID12 where ID = #LvarID#
			</cfquery>
			<cfquery datasource="sifinterfaces">
				delete IE12 where ID = #LvarID#
			</cfquery>
			<cfquery datasource="sifinterfaces">
				delete InterfazColaProcesos where IdProceso = #LvarID# and NumeroInterfaz = 12
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

