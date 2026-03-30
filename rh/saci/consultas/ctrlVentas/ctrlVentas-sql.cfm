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


<cfif url.rbModo EQ 1>	<!--- Por Mes --->
	<cfset vFechaIni = url.anoIniMes & url.mesIni & '01'>
	<cfset vFechaFin = url.anoFinMes & url.mesFin & '01'>
	<cfset vFechaIniFormat =  '01/' & url.mesIni & '/' & url.anoIniDia>
	<cfset vFechaFinFormat =  '01/' & url.mesFin & '/' &  url.anoFinDia>	
<cfelse>	<!--- Por Dia --->
	<cfif len(url.diaIni) EQ 1>
		<cfset url.diaIni = "0" & url.diaIni>
	</cfif>
	<cfif len(url.diaFin) EQ 1>
		<cfset url.diaFin = "0" & url.diaFin>
	</cfif>
	
	<cfset vFechaIniFormat = url.diaIni & '/01/' & url.anoIniDia>
	<cfset vFechaFinFormat = url.diaFin & '/01/' & url.anoFinDia>
	<cfset vFechaIni = url.anoIniDia & '01' & url.diaIni>
	<cfset vFechaFin = url.anoFinDia & '01' & url.diaFin>
</cfif>

<!--- Revision de la cantidad de registros que devuelve la consulta, para no permitir que sean mas de 3000 --->
<cfif isdefined('url.rbNivel')>
	<cfif url.rbNivel EQ 1 or url.rbNivel EQ 2 or url.rbNivel EQ 3>		<!--- Por Agente o Por Paquete o por Contrato  --->
		<cf_dbtemp name="tablaTMP_1" returnvariable="tablaTMP_1" datasource="#session.DSN#">
			<cf_dbtempcol name="PQcodigo" type="varchar(25)" mandatory="yes">
			<cf_dbtempcol name="Vid" type="numeric" mandatory="yes">
			<cf_dbtempcol name="AGid" type="numeric" mandatory="yes">			
			<cf_dbtempcol name="Pendientes" type="numeric" mandatory="yes">			
			<cf_dbtempcol name="Aprobados" type="numeric" mandatory="yes">
			<cf_dbtempcol name="Rechazados" type="numeric" mandatory="yes">
		</cf_dbtemp>	
	
		<cf_dbtemp name="tablaTMP_2" returnvariable="tablaTMP_2" datasource="#session.DSN#">
			<cf_dbtempcol name="PQcodigo" type="varchar(25)" mandatory="yes">
			<cf_dbtempcol name="PQnombre" type="varchar(80)" mandatory="yes">			
			<cf_dbtempcol name="AGid" type="numeric" mandatory="yes">
			<cf_dbtempcol name="nombreAgente" type="varchar(140)" mandatory="yes">
			<cf_dbtempcol name="Pendientes" type="numeric" mandatory="yes">			
			<cf_dbtempcol name="Aprobados" type="numeric" mandatory="yes">
			<cf_dbtempcol name="Rechazados" type="numeric" mandatory="yes">
		</cf_dbtemp>

  		<cf_dbtemp name="tablaTMP_3" returnvariable="tablaTMP_3" datasource="#session.DSN#">
			<cf_dbtempcol name="PQcodigo" type="varchar(25)" mandatory="yes">
			<cf_dbtempcol name="PQnombre" type="varchar(80)" mandatory="yes">			
			<cf_dbtempcol name="AGid" type="numeric" mandatory="yes">
			<cf_dbtempcol name="nombreAgente" type="varchar(140)" mandatory="yes">			
			<cf_dbtempcol name="LGlogin" type="varchar(30)" mandatory="yes">
			<cf_dbtempcol name="Contratoid" type="numeric" mandatory="yes">
			<cf_dbtempcol name="CNapertura" type="date" mandatory="no">			
			<cf_dbtempcol name="Pendientes" type="varchar(2)" mandatory="no">			
			<cf_dbtempcol name="Aprobados" type="varchar(2)" mandatory="no">
			<cf_dbtempcol name="Rechazados" type="varchar(2)" mandatory="no">
			<cf_dbtempcol name="CNfechaAprobacion" type="date" mandatory="no">
			<cf_dbtempcol name="CNfechaContrato" type="date" mandatory="no">				
		</cf_dbtemp>

		<cfquery datasource="#session.DSN#">
			insert #tablaTMP_1# (PQcodigo, Vid, AGid, Pendientes, Aprobados, Rechazados)
			Select distinct pr.PQcodigo
				, pr.Vid
				, a.AGid
				, (select count(1)
					from ISBproducto m
					where m.PQcodigo = pr.PQcodigo
						and m.Vid=pr.Vid
						and m.CTcondicion = '0') as Pendientes
				, (select count(1)
					from ISBproducto m
					where m.PQcodigo = pr.PQcodigo
						and m.Vid=pr.Vid
						and m.CTcondicion = '1') as Aprobados
				, (select count(1)
					from ISBproducto m
					where m.PQcodigo = pr.PQcodigo
						and m.Vid=pr.Vid
						and m.CTcondicion = 'X') as Rechazados
			
			from ISBagente a
				inner join ISBpersona p
					on p.Ecodigo=a.Ecodigo
						and p.Pquien=a.Pquien
			
				inner join 	ISBvendedor v
					on v.AGid=a.AGid
						and v.Habilitado = 1
			
				inner join ISBproducto pr
					on pr.Vid=v.Vid
						and pr.CTcondicion in ('0','1','X')
						<cfif isdefined('vFechaIni') and vFechaIni NEQ ''>
							and pr.CNapertura >= '#vFechaIni#'						
						</cfif>
						<cfif isdefined('vFechaFin') and vFechaFin NEQ ''>
							and pr.CNapertura <= '#vFechaFin#'						
						</cfif>
			
				inner join ISBpaquete pa
					on pa.Ecodigo=p.Ecodigo
						and pa.PQcodigo=pr.PQcodigo
			
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.Habilitado = 1
				<cfif isdefined('url.AGIDP') and url.AGIDP NEQ ''>
					and a.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AGIDP#">
				</cfif>
			order by AGid, PQcodigo, Vid	
		</cfquery>			

		<cfquery datasource="#session.DSN#">
			insert #tablaTMP_2# (PQcodigo, PQnombre, AGid, nombreAgente, Pendientes, Aprobados, Rechazados)
			Select distinct pr.PQcodigo
				, pa.PQnombre
				, a.AGid
				, (p.Pnombre || ' ' || Papellido || ' ' || Papellido2) as nombreAgente
				, 0 as Pendientes
				, 0 as Aprobados
				, 0 as Rechazados
			
			from ISBagente a
				inner join ISBpersona p
					on p.Ecodigo=a.Ecodigo
						and p.Pquien=a.Pquien
			
				inner join 	ISBvendedor v
					on v.AGid=a.AGid
						and v.Habilitado = 1
			
				inner join ISBproducto pr
					on pr.Vid=v.Vid
						and pr.CTcondicion in ('0','1','X')
						<cfif isdefined('vFechaIni') and vFechaIni NEQ ''>
							and pr.CNapertura >= '#vFechaIni#'						
						</cfif>
						<cfif isdefined('vFechaFin') and vFechaFin NEQ ''>
							and pr.CNapertura <= '#vFechaFin#'						
						</cfif>
			
				inner join ISBpaquete pa
					on pa.Ecodigo=p.Ecodigo
						and pa.PQcodigo=pr.PQcodigo
			
				inner join ISBlogin lo
					on lo.Contratoid=pr.Contratoid		
			
			where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.Habilitado = 1
				<cfif isdefined('url.AGIDP') and url.AGIDP NEQ ''>
					and a.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AGIDP#">
				</cfif>			
			order by nombreAgente,pr.PQcodigo
		</cfquery>	

 		<cfquery datasource="#session.DSN#">
			insert #tablaTMP_3# (PQcodigo, PQnombre, AGid, Pendientes, Aprobados, Rechazados, LGlogin, nombreAgente, Contratoid, CNapertura,CNfechaAprobacion,CNfechaContrato)
			Select distinct pr.PQcodigo
				, pa.PQnombre
				, a.AGid
				, case pr.CTcondicion when '0' then 'X' else ' ' end Pendientes
				, case pr.CTcondicion when '1' then 'X' else ' ' end Aprobados
				, case pr.CTcondicion when 'X' then 'X' else ' ' end Rechazados
				, lo.LGlogin
				, (p.Pnombre || ' ' || Papellido || ' ' || Papellido2) as nombreAgente
				, pr.Contratoid 
				, pr.CNapertura
				, pr.CNfechaAprobacion
				, pr.CNfechaContrato
			
			from ISBagente a
				inner join ISBpersona p
					on p.Ecodigo=a.Ecodigo
						and p.Pquien=a.Pquien
			
				inner join 	ISBvendedor v
					on v.AGid=a.AGid
						and v.Habilitado = 1
			
				inner join ISBproducto pr
					on pr.Vid=v.Vid
						and pr.CTcondicion in ('0','1','X')
						<cfif isdefined('vFechaIni') and vFechaIni NEQ ''>
							and pr.CNapertura >= '#vFechaIni#'						
						</cfif>
						<cfif isdefined('vFechaFin') and vFechaFin NEQ ''>
							and pr.CNapertura <= '#vFechaFin#'						
						</cfif>
			
				inner join ISBpaquete pa
					on pa.Ecodigo=p.Ecodigo
						and pa.PQcodigo=pr.PQcodigo
			
				inner join ISBlogin lo
					on lo.Contratoid=pr.Contratoid		
			
			where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.Habilitado = 1
				<cfif isdefined('url.AGIDP') and url.AGIDP NEQ ''>
					and a.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AGIDP#">
				</cfif>			
			order by nombreAgente,pr.PQcodigo, pr.Contratoid, lo.LGlogin
		</cfquery>	

		<!--- Calcula la cantidad de registros dependiendo del nivel de la consulta --->		
		<cfif url.rbNivel EQ 1>
			<cfquery name="rsReporteN1" datasource="#session.DSN#">
				select distinct AGid
				from #tablaTMP_1#
			</cfquery>
			<cfquery name="rsReporteTAM" dbtype="query">
				select count(1) as cantReg
				from rsReporteN1
			</cfquery>			
		<cfelseif url.rbNivel EQ 2>		
			<cfquery name="rsReporteN2" datasource="#session.DSN#">
				select distinct AGid, PQcodigo
				from #tablaTMP_1#
			</cfquery>					
			<cfquery name="rsReporteTAM" dbtype="query">
				select count(1) as cantReg
				from rsReporteN2
			</cfquery>			
		<cfelseif url.rbNivel EQ 3>		
			<cfquery name="rsReporteTAM" datasource="#session.DSN#">
				select count(*) as cantReg
				from #tablaTMP_3#
			</cfquery>				
		</cfif>
	</cfif>

	<cfif isdefined('rsReporteTAM') and rsReporteTAM.cantReg LTE 3000>
		<!--- Calculo y actualizacion de las 3 columnas de Pendientes-Aprobados-Rechazados --->
		<cfquery datasource="#session.DSN#">
			update #tablaTMP_2# set
					Pendientes = (	select sum(m.Pendientes)
								from #tablaTMP_1# m
								where m.PQcodigo = #tablaTMP_2#.PQcodigo
									and m.AGid=#tablaTMP_2#.AGid)		
		</cfquery>
		<cfquery datasource="#session.DSN#">
			update #tablaTMP_2# set
				Aprobados = (	select sum(m.Aprobados)
								from #tablaTMP_1# m
								where m.PQcodigo = #tablaTMP_2#.PQcodigo
									and m.AGid=#tablaTMP_2#.AGid)	
		</cfquery>
		<cfquery datasource="#session.DSN#">
			update #tablaTMP_2# set
				Rechazados = (	select sum(m.Rechazados)
							from #tablaTMP_1# m
							where m.PQcodigo = #tablaTMP_2#.PQcodigo
								and m.AGid=#tablaTMP_2#.AGid)		
		</cfquery>		
	
		<cfset nombreReporte = "">
		<!--- INVOCA EL REPORTE 	--->
		<cfif isdefined('url.rbNivel')>
			<cfif url.rbNivel EQ 1 or url.rbNivel EQ 2 or url.rbNivel EQ 3>		<!--- Por Agente  o por Paquete o por Contrato --->
				<cfif url.rbNivel EQ 1>
					<cfquery name="rsReporte" datasource="#session.DSN#">
						select distinct AGid,nombreAgente,Aprobados,Pendientes,Rechazados
						from #tablaTMP_2#
						order by nombreAgente
					</cfquery>		
				<cfelseif url.rbNivel EQ 2>
					<cfquery name="rsReporte" datasource="#session.DSN#">
						select distinct AGid
							, nombreAgente
							, PQcodigo
							, PQnombre
							, Pendientes
							, Aprobados
							, Rechazados						
						from #tablaTMP_2#
						order by nombreAgente,PQcodigo
					</cfquery>			
				<cfelseif url.rbNivel EQ 3>		
					<cfquery name="rsReporte" datasource="#session.DSN#">
						select distinct AGid
							, nombreAgente
							, PQcodigo
							, PQnombre
							, Pendientes
							, Aprobados
							, Rechazados
							, LGlogin
							, <cf_dbfunction name="to_char" datasource="#session.DSN#" args="Contratoid"> as contrato
							, CNapertura
							, CNfechaAprobacion
							, CNfechaContrato
						from #tablaTMP_3#
						order by nombreAgente,PQcodigo,contrato,LGlogin
					</cfquery>			
				</cfif>			

				<cfif url.rbNivel EQ 1>			<!--- Por Agente --->
					<cfset nombreReporte = "ctrlVentasN1.cfr">
				<cfelseif url.rbNivel EQ 2>		<!--- Por Paquete --->
					<cfset nombreReporte = "ctrlVentasN2.cfr">
				<cfelseif url.rbNivel EQ 3>		<!--- Por Contrato --->
					<cfset nombreReporte = "ctrlVentasN3.cfr">					
				</cfif>	
			</cfif>
		</cfif>	

		<cfif formato NEQ '' and nombreReporte NEQ '' and isdefined('rsReporte')>	
			<cfreport format="#formato#" template= "#nombreReporte#" query="rsReporte">
				<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
				<cfreportparam name="Edesc" value="#session.Enombre#">
				<cfreportparam name="fechaIni" value="#vFechaIniFormat#">				
				<cfreportparam name="fechaFin" value="#vFechaFinFormat#">				
			</cfreport>
		<cfelse>
			<cflocation url="ctrlVentas.cfm">
		</cfif>	
	<cfelse>
		<cfthrow message="La consulta regresa mas de 3000 registros, debe utilizar mas filtros.">
		<cfabort>
	</cfif>
</cfif>