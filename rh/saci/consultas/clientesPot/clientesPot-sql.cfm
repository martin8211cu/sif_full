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

	<!--- Calcula la cantidad de registros dependiendo de los filtros de la consulta --->		
	<cfquery name="rsReporteTAM" datasource="#session.DSN#">
		Select count(1) as cantReg
		from ISBagente a
			inner join ISBpersona p
				on p.Pquien=a.Pquien
		
			inner join ISBprospectos pro
				on pro.AGid=a.AGid
					and pro.Ecodigo=a.Ecodigo
					and pro.Pprospectacion in ('A','D','F')
		
			<cfif url.rbModo NEQ 1>	<!--- Por Prospecto detallado  --->
				inner join Localidad lo
					on lo.LCid=pro.LCid
			</cfif>		
		
		where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.Habilitado = 1
			<cfif isdefined('url.AGIDP') and url.AGIDP NEQ ''>
				and a.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AGIDP#">
			</cfif>		
	
	</cfquery>	

	<cfif isdefined('rsReporteTAM') and rsReporteTAM.cantReg LTE 3000>
		<cfquery name="rsReporte" datasource="#session.DSN#">
			Select a.AGid
				, (p.Pnombre || ' ' || p.Papellido || '' || p.Papellido2) as nombreAgente
				<cfif url.rbModo NEQ 1>	<!--- Por Prospecto detallado  --->
					, (pro.Pnombre || ' ' || pro.Papellido || ' ' || pro.Papellido2) as nombreProsp
					, pro.Ptelefono1
					, lo.LCnombre		
					, case pro.Pprospectacion when 'A' then 'X' else ' ' end AsignadosX
					, case pro.Pprospectacion when 'D' then 'X' else ' ' end DescartadosX
					, case pro.Pprospectacion when 'F' then 'X' else ' ' end FormalizadosX					
				</cfif>	
				, (select count(1)
					from ISBprospectos m
					where m.Ecodigo = a.Ecodigo
						and m.AGid=a.AGid
						and m.Pprospectacion = 'A') as Asignados
				, (select count(1)
					from ISBprospectos m
					where m.Ecodigo = a.Ecodigo
						and m.AGid=a.AGid
						and m.Pprospectacion = 'D') as Descartados
				, (select count(1)
					from ISBprospectos m
					where m.Ecodigo = a.Ecodigo
						and m.AGid=a.AGid
						and m.Pprospectacion = 'F') as Formalizados
					
			from ISBagente a
				inner join ISBpersona p
					on p.Pquien=a.Pquien
			
				inner join ISBprospectos pro
					on pro.AGid=a.AGid
						and pro.Ecodigo=a.Ecodigo
						and pro.Pprospectacion in ('A','D','F')
						
				<cfif url.rbModo NEQ 1>	<!--- Por Prospecto detallado  --->
					inner join Localidad lo
						on lo.LCid=pro.LCid
				</cfif>		
			
			where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.Habilitado = 1
				<cfif isdefined('url.AGIDP') and url.AGIDP NEQ ''>
					and a.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AGIDP#">
				</cfif>
			order by nombreAgente<cfif url.rbModo NEQ 1>, nombreProsp, LCnombre</cfif>
		</cfquery>			

		<cfif url.rbModo EQ 1>				<!--- Por Agente --->
			<cfset nombreReporte = "clientesPotO1.cfr">
		<cfelse>							<!--- Con el detalle de prospectos --->
			<cfset nombreReporte = "clientesPotO2.cfr">
		</cfif>	

		<cfif formato NEQ '' and nombreReporte NEQ '' and isdefined('rsReporte')>	
			<cfreport format="#formato#" template= "#nombreReporte#" query="rsReporte">
				<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
				<cfreportparam name="Edesc" value="#session.Enombre#">
			</cfreport>
		<cfelse>
			<cflocation url="clientesPot.cfm">
		</cfif>	
	<cfelse>
		<cfthrow message="La consulta regresa mas de 3000 registros, debe utilizar mas filtros.">
		<cfabort>
	</cfif>
