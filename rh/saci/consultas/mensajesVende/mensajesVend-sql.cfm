<cfif isdefined('form.btnRevisado')>
	<cfif isDefined("form.CHK")>
		<cftransaction>
			<cfset arreglo = listtoarray(form.CHK,",")>
			<cfloop from="1" to ="#arraylen(arreglo)#" index="i">
				<cfinvoke component="saci.comp.ISBmensajesCliente"
					method="CambioRevAgente">
					<cfinvokeargument name="MSid" value="#arreglo[i]#">
					<cfinvokeargument name="MSrevAgente" value="L">				
				</cfinvoke>			
			</cfloop>
		</cftransaction>
	</cfif>
	<cfset params = "">
	<cfif isdefined('form.AGIDP_F') and form.AGIDP_F NEQ ''>
		<cfset params = params & "&AGidP=#form.AGIDP_F#">
	</cfif>			
	<cfif isdefined('form.PQUIEN_F') and form.PQUIEN_F NEQ ''>
		<cfset params = params & "&Pquien=#form.PQUIEN_F#">
	</cfif>	
	<cfif isdefined('form.LGlogin_F') and form.LGlogin_F NEQ ''>
		<cfset params = params & "&LGlogin=#form.LGLOGIN_F#">
	</cfif>		
	<cfif isdefined('form.fechaIni_F') and form.fechaIni_F NEQ ''>
		<cfset params = params & "&fechaIni=#form.FECHAINI_F#">			
	</cfif>		
	<cfif isdefined('form.fechaFin_F') and form.fechaFin_F NEQ ''>
		<cfset params = params & "&fechaFin=#form.FECHAFIN_F#">						
	</cfif>	
	<cfif isdefined('form.MSoperacion_F') and form.MSoperacion_F NEQ '-1'>
		<cfset params = params & "&MSoperacion=#form.MSOPERACION_F#">									
	</cfif>	
	<cfif isdefined('form.MSrevAgente_F') and form.MSrevAgente_F NEQ '-1'>
		<cfset params = params & "&MSrevAgente=#form.MSREVAGENTE_F#">												
	</cfif>	
	
	<cflocation url="mensajesVend.cfm?consulta=1#params#">	
<cfelse>		<!--- Reporte --->
	<cfquery name="rsReporteXXX" datasource="#session.DSN#">
		select count(1) as cantReg
		from ISBmensajesCliente mc
			inner join ISBlogin lo
				on lo.LGnumero=mc.LGnumero
		
			inner join ISBproducto p
				on p.Contratoid=lo.Contratoid
		
			inner join ISBcuenta c
				on c.CTid=p.CTid
		
			inner join ISBpersona per
				on per.Pquien=c.Pquien
		where 1=1
			<cfif isdefined('url.AGIDP') and url.AGIDP NEQ ''>
				and mc.AGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AGIDP#">
			</cfif>			
			<cfif isdefined('url.LGlogin') and url.LGlogin NEQ ''>
				and upper(lo.LGlogin) like upper('%#url.LGlogin#%')
			</cfif>				
			<cfif isdefined('url.fechaIni') and url.fechaIni NEQ ''>
				and mc.MSfechaCompleto >= '#LSDateFormat(url.fechaIni, "yyyymmdd")#'
			</cfif>				
			<cfif isdefined('url.fechaFin') and url.fechaFin NEQ ''>
				and mc.MSfechaCompleto <= '#LSDateFormat(url.fechaFin, "yyyymmdd")#'
			</cfif>				
			<cfif isdefined('url.MSoperacion') and url.MSoperacion NEQ '-1'>
				and MSoperacion = '#url.MSoperacion#'
			</cfif>	
			<cfif isdefined('url.MSrevAgente') and url.MSrevAgente NEQ '-1'>
				and MSrevAgente = '#url.MSrevAgente#'
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
					lo.LGlogin
					, mc.AGid
					, (perAG.Pnombre || ' ' || perAG.Papellido || ' ' || perAG.Papellido2) as nombreAG				
					, mc.MSid
					, c.CUECUE
					, lo.Contratoid
					, case mc.MSrevAgente
						when 'N' then 'Sin Revisar'
						when 'L' then 'Revisada'
						when 'B' then 'Anulada'
					  end MSrevAgente					
					, case mc.MSoperacion
						when 'L' then 'Bloquear'
						when 'D' then 'Desbloquear'
						when 'B' then 'Borrar'
						when 'P' then 'Programar (activar)'
						when 'O' then 'Moroso'
						when 'I' then 'Informativo'
					  end MSoperacion
					, mc.MSfechaCompleto
					, mot.MBdescripcion
					, mc.MSmotivo
					, mc.MSsaldo
					, lo.LGserids
					, p.CNsuscriptor
					, p.PQcodigo
					, (per.Pnombre || ' ' || per.Papellido || ' ' || per.Papellido2 || ' ' || per.PrazonSocial) as nombreCuenta			
			from ISBmensajesCliente mc
				inner join ISBlogin lo
					on lo.LGnumero=mc.LGnumero
					
				left join ISBmotivoBloqueo mot
					on mc.MSmotivo = mot.MBmotivo
			
				inner join ISBproducto p
					on p.Contratoid=lo.Contratoid
			
				inner join ISBcuenta c
					on c.CTid=p.CTid
			
				inner join ISBpersona per
					on per.Pquien=c.Pquien
					
				inner join ISBagente ag
					on ag.AGid=mc.AGid
						and ag.Ecodigo=per.Ecodigo
			
				inner join ISBpersona perAG
					on perAG.Pquien=ag.Pquien					
			where 1=1
				<cfif isdefined('url.AGIDP') and url.AGIDP NEQ ''>
					and mc.AGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AGIDP#">
				</cfif>			
				<cfif isdefined('url.LGlogin') and url.LGlogin NEQ ''>
					and upper(lo.LGlogin) like upper('%#url.LGlogin#%')
				</cfif>				
				<cfif isdefined('url.fechaIni') and url.fechaIni NEQ ''>
					and mc.MSfechaCompleto >= '#LSDateFormat(url.fechaIni, "yyyymmdd")#'
				</cfif>				
				<cfif isdefined('url.fechaFin') and url.fechaFin NEQ ''>
					and mc.MSfechaCompleto <= '#LSDateFormat(url.fechaFin, "yyyymmdd")#'
				</cfif>				
				<cfif isdefined('url.MSoperacion') and url.MSoperacion NEQ '-1'>
					and MSoperacion = '#url.MSoperacion#'
				</cfif>	
				<cfif isdefined('url.MSrevAgente') and url.MSrevAgente NEQ '-1'>
					and MSrevAgente = '#url.MSrevAgente#'
				</cfif>	
			order by nombreAG,LGlogin,CUECUE
		</cfquery>		

		<cfif formato NEQ '' and isdefined('rsReporte')>	
			<cfset vFechaIni = "">
			<cfset vFechaFin = "">		
			<cfset vEstado = "">			
			<cfif isdefined('url.fechaIni') and url.fechaIni NEQ ''>
				<cfset vFechaIni = url.fechaIni>
			</cfif>				
			<cfif isdefined('url.fechaFin') and url.fechaFin NEQ ''>
				<cfset vFechaFin = url.fechaFin>
			</cfif>		
			<cfif isdefined('url.MSrevAgente') and url.MSrevAgente NEQ ''>
				<cfif url.MSrevAgente EQ '-1'>
					<cfset vEstado = "-- Todos --">
				<cfelseif url.MSrevAgente EQ 'L'>
					<cfset vEstado = "Revisadas">
				<cfelseif url.MSrevAgente EQ 'N'>
					<cfset vEstado = "Sin Revisar">				
				<cfelseif url.MSrevAgente EQ 'B'>				
					<cfset vEstado = "Anulados">
				</cfif>
			</cfif>							
 			<cfreport  format="#formato#" template= "mensajesVend.cfr" query="rsReporte">
				<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
				<cfreportparam name="Edesc" value="#session.Enombre#">
				<cfreportparam name="fechaIni" value="#vFechaIni#">
				<cfreportparam name="fechaFin" value="#vFechaFin#">
				<cfreportparam name="estado" value="#vEstado#">
			</cfreport>
		<cfelse>
			<cflocation url="mensajesVend.cfm">
		</cfif>		
	<cfelse>
		<cfthrow message="La consulta regresa mas de 3000 registros, debe utilizar mas filtros.">
		<cfabort>
	</cfif>
</cfif>