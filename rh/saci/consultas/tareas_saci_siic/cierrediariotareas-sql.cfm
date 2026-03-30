	<cfquery name="rsReporteXXX" datasource="#session.DSN#">
		select count(1) as cantReg
		from SACISIIC..SSXBAC mc
		where 1=1
			<cfif isdefined('url.fechaIni') and url.fechaIni NEQ ''>
				and mc.BACFEC >= '#LSDateFormat(url.fechaIni, "yyyymmdd")#'
			</cfif>				
			<cfif isdefined('url.fechaFin') and url.fechaFin NEQ ''>
				and mc.BACFEC <= '#LSDateFormat(url.fechaFin, "yyyymmdd")# 23:59:59'
			</cfif>				
			<cfif isdefined('url.TipActividad') and url.TipActividad NEQ 'T'>
				and BACDAM = '#url.TipActividad#'
			</cfif>	
			<cfif isdefined('url.opt_mayorista') and url.opt_mayorista NEQ 'T'>
				and BACCAB = '#url.opt_mayorista#'
			</cfif>	
	</cfquery>

	<cfif isdefined('rsReporteXXX') and rsReporteXXX.cantReg LTE 3000>
		<cfset nombreReporte = "">
		<cfset formato = "">
		<!--- DETERMINA EL TIPO DE FORMATO EN QUE SE RELAIZARA EL REPORTE --->
		<cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 1>
			<cfset formato = "flashpaper">
		<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 2>
			<cfset formato = "pdf">
		<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 3>
			<cfset formato = "excel">
		<cfelse>
			<cfset formato = "flashpaper">
		</cfif>	
		
		<cfquery name="rsReporte" datasource="#session.DSN#">
			select 
					BACCON
				,case mc.BACDAM
					when 'C' then 'C - Cambio Cuenta'
					when 'L' then 'L - Cambio Login'
					when 'I' then 'I - Cambio Inte'
					when 'Q' then 'Q - Cambio Paquete'
					when 'N' then 'N - Nuevo Inte'
				  end BACDAM
				, mc.CUECUE
				, coalesce (mc.SERIDS, '-') as SERIDS
				, SERCLA
				, mc.CINCAT
				, coalesce (INTPAD, '-') as INTPAD
				, CONVERT(CHAR(8),BACFEC,112) FECHA
				, CONVERT(CHAR(8),BACFEC,108) HORA
				, coalesce(CONVERT(varchar,BACCSV), '-') as BACCSV
				, BACFEC	
			from SACISIIC..SSXBAC mc 				
			where 1=1
				<cfif isdefined('url.fechaIni') and url.fechaIni NEQ ''>
					and mc.BACFEC >= '#LSDateFormat(url.fechaIni, "yyyymmdd")#'
				</cfif>				
				<cfif isdefined('url.fechaFin') and url.fechaFin NEQ ''>
					and mc.BACFEC <= '#LSDateFormat(url.fechaFin, "yyyymmdd")# 23:59:59'
				</cfif>				
				<cfif isdefined('url.TipActividad') and url.TipActividad NEQ 'T'>
					and BACDAM = '#url.TipActividad#'
				</cfif>	
				<cfif isdefined('url.opt_mayorista') and url.opt_mayorista NEQ 'T'>
					and BACCAB = '#url.opt_mayorista#'
				</cfif>	
			order by BACFEC
		</cfquery>		

		<cfif formato NEQ '' and isdefined('rsReporte')>	
			<cfset vFechaIni = "">
			<cfset vFechaFin = "">		
			<cfset vmayorista = "">
			<cfset vactividad = "">			
			<cfif isdefined('url.fechaIni') and url.fechaIni NEQ ''>
				<cfset vFechaIni = url.fechaIni>
			</cfif>	
			<cfif isdefined('url.TipActividad')>
				<cfif url.TipActividad EQ  'T'>
				  <cfset vactividad = 'Todas'>
				<cfelseif url.TipActividad EQ 'C'>
				  <cfset vactividad = 'Cambio Cuenta'>
				<cfelseif url.TipActividad EQ 'L'>
				  <cfset vactividad = 'Cambio Login'>
				<cfelseif url.TipActividad EQ 'I'>
				   <cfset vactividad = 'Cambio Inte'>
				<cfelseif url.TipActividad EQ 'Q'>
				   <cfset vactividad = 'Cambio Paquete'>
				 <cfelseif url.TipActividad EQ 'N'> 
				 	<cfset vactividad = 'Nuevo Inte'> 
				</cfif>				
			</cfif>			
			<cfif isdefined('url.fechaFin') and url.fechaFin NEQ ''>
				<cfset vFechaFin = url.fechaFin>
			</cfif>		
			<cfif isdefined('url.opt_mayorista')>
				<cfif url.opt_mayorista EQ 'T'>
					<cfset NombreMayorista.MRnombre = 'Todas'>
				<cfelse>	
					<cfquery name="NombreMayorista" datasource="#session.DSN#">	
					Select MRnombre from ISBmayoristaRed
					Where MRcodigoInterfaz = <cfqueryparam cfsqltype="cf_sql_char" value="#url.opt_mayorista#">
					</cfquery>						
				</cfif>				
			</cfif>
			<cfset vmayorista = NombreMayorista.MRnombre>
			
			<cfif Len(vmayorista) is 0>
				<cfthrow message="No se encontró mayorista de Red Asociado.">
			</cfif>
			
			
			
			<!---<cfif isdefined('url.MSrevAgente') and url.MSrevAgente NEQ ''>
				<cfif url.MSrevAgente EQ '-1'>
					<cfset vEstado = "-- Todos --">
				<cfelseif url.MSrevAgente EQ 'L'>
					<cfset vEstado = "Revisadas">
				<cfelseif url.MSrevAgente EQ 'N'>
					<cfset vEstado = "Sin Revisar">				
				<cfelseif url.MSrevAgente EQ 'B'>				
					<cfset vEstado = "Anulados">
				</cfif>
			</cfif>	--->						
 			<cfreport  format="#formato#" template= "reporteactividades.cfr" query="rsReporte">
				<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
				<cfreportparam name="Edesc" value="#session.Enombre#">
				<cfreportparam name="fechaIni" value="#vFechaIni#">
				<cfreportparam name="fechaFin" value="#vFechaFin#">
				<cfreportparam name="mayorista" value="#vmayorista#">
				<cfreportparam name="actividad" value="#vactividad#">
			</cfreport>
		<cfelse>
			<cflocation url="mensajesVend.cfm">
		</cfif>		
	<cfelse>
		<cfthrow message="La consulta regresa mas de 3000 registros, debe utilizar mas filtros.">
		<cfabort>
	</cfif>
