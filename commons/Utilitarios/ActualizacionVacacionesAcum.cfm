<!---respaldar tablas---->
<cfset tablaEmpleado = 'DVacacionesEmpleado_Work_20130514'>
<cfset tablaAcum = 'DVacacionesAcum_Work_20130514'>
<!--- año de la aplicacion---->
<cfset anno=2013>


<cf_dump vaR="abortado">
<cfquery datasource="#session.dsn#" name="rsEmpleado">
select de.DEid,EVfecha, DEidentificacion
from DatosEmpleado de
	inner join EVacacionesEmpleado e
		on de.DEid = e.DEid
where EVfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#createdate(anno,1,1)#"> and <cf_dbfunction name="today">
</cfquery>

<!---<cf_dump var="#rsEmpleado#">--->
<!---<cfflush interval="1">--->


<cftransaction>

<!--- 					<cf_dump select="
	                            	select   dva.DVAperiodo
                                        ,sum(dva.DVAdiasPotenciales) as DiasRegimen
                                        ,sum(case when dva.DVAsaldodias > 0 and dva.DVAmanual = 0 then  dva.DVAsaldodias else 0 end) as DiasRegimenAsignados
                                        ,abs(coalesce(sum(case when dva.DVAsaldodias < 0 and dva.DVAmanual = 0 then dva.DVAsaldodias else 0 end ),0))
                                        as DiasDisfrutadosPorAccion
                                        ,sum(case when dva.DVAmanual = 1 then dva.DVAsaldodias else 0 end) as AjustesManuales
                                        ,sum(dva.DVASalarioProm) as DVASalarioProm
                                 from DVacacionesAcum dva
                                where dva.DEid = 10
                                    and dva.Ecodigo = #session.Ecodigo#
                                group by dva.DEid, dva.DVAperiodo
                                order by dva.DEid, dva.DVAperiodo
							" abort=false>	--->	 
														
	<cfquery datasource="#session.dsn#" >
		delete from DVacacionesAcum
	</cfquery>	
	<cfquery datasource="#session.dsn#" >
		delete from DVacacionesEmpleado
	</cfquery>
		
	
	<cfquery datasource="#session.dsn#" >
		update #tablaEmpleado# 
		set DVEperiodo =DVEperiodo-1
		where upper(DVEdescripcion) like '%SALDO PERIODO%' and Ecodigo is null
	</cfquery>

	<cfquery datasource="#session.dsn#" name="rsSaldos2011">
		select * from #tablaEmpleado# 
		where upper(DVEdescripcion) like '%SALDO PERIODO%' and Ecodigo is null
	</cfquery><!---<cf_dump vaR="#rsSaldos2011#">--->

	<!---- asignados y potenciales de las personas que cumplieron el presente año---->
	<cfloop query="rsSaldos2011">
			<cfquery datasource="#session.dsn#" name="nuevoSaldo">
					insert into DVacacionesEmpleado (DEid,Ecodigo,DVEfecha,DVEreferencia,DVEdescripcion, DVEdisfrutados,DVEcompensados,DVEenfermedad,
					DVEadicionales,DVEmonto , Usucodigo, Ulocalizacion, DVEfalta, DVEperiodo, BMUsucodigo, DVErefLinea, DVEmanual )
					values(
					#rsSaldos2011.DEid#,
					#session.Ecodigo#,
					<cfqueryparam cfsqltype="cf_sql_date" value="#rsSaldos2011.DVEfecha#">,
					null,
					'#rsSaldos2011.DVEdescripcion#',
					#rsSaldos2011.DVEdisfrutados#,
					#rsSaldos2011.DVEcompensados#,
					#rsSaldos2011.DVEenfermedad#,
					#rsSaldos2011.DVEadicionales#,
					#rsSaldos2011.DVEmonto#,
					20130430,
					#rsSaldos2011.Ulocalizacion#,
					null,
					#rsSaldos2011.DVEperiodo#,
					20130430,
					null,
					#rsSaldos2011.DVEmanual#
					)
				<cf_dbidentity1 verificar_transaccion="no" datasource="#session.dsn#">
			</cfquery>
			<cf_dbidentity2 name="nuevoSaldo" verificar_transaccion="no" datasource="#session.dsn#">
			
			<cfquery datasource="#session.dsn#" >
					insert into DVacacionesAcum (DEid,Ecodigo,BMUsucodigo,DVAperiodo,DVAsaldodias,DVASalarioProm,DVASalarioPdiario,DVAfecha,
														DVAdiasPotenciales,DVElinea,DVAmanual)
					values(
					
					#rsSaldos2011.DEid#
					,#session.Ecodigo#
					,20130430
					,#rsSaldos2011.DVEperiodo#
					,#rsSaldos2011.DVEdisfrutados#
					,0
					,0
					,<cfqueryparam cfsqltype="cf_sql_date" value="#rsSaldos2011.DVEfecha#">
					,0
					,#nuevoSaldo.identity#
					,#rsSaldos2011.DVEmanual#
					)
			</cfquery>
			
			<cfquery datasource="#session.dsn#" >
					insert into DVacacionesAcum (DEid,Ecodigo,BMUsucodigo,DVAperiodo,DVAsaldodias,DVASalarioProm,DVASalarioPdiario,DVAfecha,
														DVAdiasPotenciales,DVElinea,DVAmanual)
					values(
					
					#rsSaldos2011.DEid#
					,#session.Ecodigo#
					,20130430
					,#rsSaldos2011.DVEperiodo#
					,0
					,0
					,0
					,<cfqueryparam cfsqltype="cf_sql_date" value="#rsSaldos2011.DVEfecha#">
					,#rsSaldos2011.DVEdisfrutados#<!----- potenciales---->
					,null
					,#rsSaldos2011.DVEmanual#
					)
			</cfquery>
	</cfloop>
	
	
	<cfquery datasource="#session.dsn#" name="rsSaldosAnnosLaborados">
		select * from #tablaEmpleado# 
		where DVEdescripcion like '%Vacaciones por a#chr(241)#os Laborados%'
	</cfquery> 
	
	<!---<cfoutput>previo acum=</cfoutput><cf_dump select="select * from DVacacionesAcum where DEid=3 order by DEid" abort=true>--->
	
	<!---- asignados y potenciales de las personas que cumplieron el presente año---->
	<cfloop query="rsSaldosAnnosLaborados">
	
			<cfquery datasource="#session.dsn#" name="nuevoSaldo">
					insert into DVacacionesEmpleado (DEid,Ecodigo,DVEfecha,DVEreferencia,DVEdescripcion, DVEdisfrutados,DVEcompensados,DVEenfermedad,
					DVEadicionales,DVEmonto , Usucodigo, Ulocalizacion, DVEfalta, DVEperiodo, BMUsucodigo, DVErefLinea, DVEmanual )
					values(
					#rsSaldosAnnosLaborados.DEid#,
					#session.Ecodigo#,
					<cfqueryparam cfsqltype="cf_sql_date" value="#rsSaldosAnnosLaborados.DVEfecha#">,
					null,
					'#rsSaldosAnnosLaborados.DVEdescripcion#',
					#rsSaldosAnnosLaborados.DVEdisfrutados#,
					#rsSaldosAnnosLaborados.DVEcompensados#,
					#rsSaldosAnnosLaborados.DVEenfermedad#,
					#rsSaldosAnnosLaborados.DVEadicionales#,
					#rsSaldosAnnosLaborados.DVEmonto#,
					20130430,
					#rsSaldosAnnosLaborados.Ulocalizacion#,
					null,
					#rsSaldosAnnosLaborados.DVEperiodo#,
					20130430,
					null,
					#rsSaldosAnnosLaborados.DVEmanual#
					)
				<cf_dbidentity1 verificar_transaccion="no" datasource="#session.dsn#">
			</cfquery>
			<cf_dbidentity2 name="nuevoSaldo" verificar_transaccion="no" datasource="#session.dsn#">
			
			
			
			<cfquery datasource="#session.dsn#" >
					insert into DVacacionesAcum (DEid,Ecodigo,BMUsucodigo,DVAperiodo,DVAsaldodias,DVASalarioProm,DVASalarioPdiario,DVAfecha,
														DVAdiasPotenciales,DVElinea,DVAmanual)
					values(
					
					#rsSaldosAnnosLaborados.DEid#
					,#session.Ecodigo#
					,20130430
					,#rsSaldosAnnosLaborados.DVEperiodo#
					,#rsSaldosAnnosLaborados.DVEdisfrutados#
					,0
					,0
					,<cfqueryparam cfsqltype="cf_sql_date" value="#rsSaldosAnnosLaborados.DVEfecha#">
					,0
					,#nuevoSaldo.identity#
					,#rsSaldosAnnosLaborados.DVEmanual#
					)
			</cfquery>
			
			<cfquery datasource="#session.dsn#" >
					insert into DVacacionesAcum (DEid,Ecodigo,BMUsucodigo,DVAperiodo,DVAsaldodias,DVASalarioProm,DVASalarioPdiario,DVAfecha,
														DVAdiasPotenciales,DVElinea,DVAmanual)
					values(
					
					#rsSaldosAnnosLaborados.DEid#
					,#session.Ecodigo#
					,20130430
					,#rsSaldosAnnosLaborados.DVEperiodo#
					,0
					,0
					,0
					,<cfqueryparam cfsqltype="cf_sql_date" value="#rsSaldosAnnosLaborados.DVEfecha#">
					,#rsSaldosAnnosLaborados.DVEdisfrutados#<!----- potenciales---->
					,null
					,#rsSaldosAnnosLaborados.DVEmanual#
					)
			</cfquery>
	</cfloop>
	<!------>
		<!---
	<cf_dump select="select * from DVacacionesEmpleado where DEid=6 order by DEid" abort=false>
		<cf_dump select="select * from DVacacionesAcum where DEid=6 order by DEid" abort=false>--->
	<!------>

	<cfquery datasource="#session.dsn#" name="rsPendientes2012">
		select (EVmes *100 + EVdia) as a, # (month(now()) * 100)  + day(now())#  as b, * from EVacacionesEmpleado
		where (EVmes *100 + EVdia) < # (month(now()) * 100)  + day(now())# 
		and DEid not in ( select DEid 
							from 	DVacacionesEmpleado
							where DVEperiodo = 2012
							)
		and DEid in (select DEid from LineaTiempo where <cf_dbfunction name="today"> between LTdesde and LThasta)	
		and year(EVfantig) < #anno#
	</cfquery>
	
	<cfif rsPendientes2012.recordcount gt 0>
		<cfoutput>No se puede continuar</cfoutput>
		<cf_dump var="#rsPendientes2012#">
	</cfif>
	

	
	<!---- se insertan los registro que no son por vacaciones ni por carga incial----->
	<cfquery datasource="#session.dsn#" name="rsNuevos">
		select * from #tablaEmpleado# 
		where not (  (DVEdescripcion like '%Vacaciones por a#chr(241)#os Laborados%')
						or
					(upper(DVEdescripcion) like '%SALDO PERIODO%' and Ecodigo is null)
					)
		and DVEdisfrutados <> 0 
		order by DEid, DVEfecha	
	</cfquery>
							
	<cfset DEidActual=-1>
	
	<cfloop query="rsNuevos">
		
			<cfset lvarVacSolicitadas = rsNuevos.DVEdisfrutados>

			<cfif DEidActual neq rsNuevos.DEid>
				<cfoutput> #rsNuevos.DEid#,</cfoutput>
				<cfset AgregoNuevoSaldoDisponible=false>
			</cfif>
			
			<cfset DEidActual=rsNuevos.DEid>
			
			<cfloop condition="lvarVacSolicitadas neq 0">
			<!---<cfoutput>$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$<br /></cfoutput>--->
				<cfquery datasource="#session.dsn#" name="rsDisponible" maxrows="1">
					select DVAperiodo, coalesce(sum(DVAsaldodias),0) as valor
					from DVacacionesAcum
					where DEid = #rsNuevos.DEid# 
					group by DVAperiodo					
					having sum(DVAsaldodias) > 0      
					order by DVAperiodo
				</cfquery><!---<cfdump vaR="#rsDisponible#">--->
				<!---- si existe disponible se asignan las variables, si no existen disponibles se crean----->
				<cfif rsDisponible.recordcount eq 0>
				<!---<cfoutput>No disponible</cfoutput> --->
						<cfquery datasource="#session.dsn#" name="proximoPeriodo">
						select max(DVAperiodo) + 1 as valor
						from DVacacionesAcum 
						where DEid = #rsNuevos.DEid#
						and DVAsaldodias > 0
						</cfquery>
						<cfif proximoPeriodo.recordcount gt 0 and len(trim(proximoPeriodo.valor)) gt 0>
							<cfset lvar_periodo = proximoPeriodo.valor>
						<cfelse>
							<cfif  len(trim(rsNuevos.DVEperiodo)) gt 0>
								<cfset lvar_periodo = rsNuevos.DVEperiodo>
							<cfelse>
								<cfset lvar_periodo = year(now())>
							</cfif>
						</cfif>
						
						
						<cfif not AgregoNuevoSaldoDisponible><!--- solo se agrega el potencial una vez---->
							<!---- obtener el monto potencial del empleado---->
							<cfquery datasource="#session.dsn#" name="rsValidaActivo">
								select 1 from LineaTiempo
								where <cfqueryparam cfsqltype="cf_sql_date" value="#rsNuevos.DVEfecha#"> between  LTdesde and  LThasta
								and DEid = #rsNuevos.DEid#
							</cfquery>
						
							<cfquery datasource="#session.dsn#" name="diasPorRegimen">
									select 	( select rv.DRVdias
												 from DRegimenVacaciones rv 
												 where rv.RVid = c.RVid 
												   and rv.DRVcant = ( select max(DRVcant) 
																	  from DRegimenVacaciones rv2 
																		where rv2.RVid = c.RVid 
																		and rv2.DRVcant <= 
																		case when <cf_dbfunction name="datediff" args="a.EVfantig, #LSParseDateTime(rsNuevos.DVEfecha)# ,yy"> < 1 
																				then 1
																		else <cf_dbfunction name="datediff" args="a.EVfantig, #LSParseDateTime(rsNuevos.DVEfecha)# ,yy">
																		end 		)
											   ) as valor
										from EVacacionesEmpleado a
											inner join DatosEmpleado b
												on b.DEid = a.DEid
											inner join LineaTiempo c
												on c.DEid = b.DEid
										where c.Ecodigo = #session.Ecodigo#
										<cfif rsValidaActivo.recordcount gt 0>
										  and <cfqueryparam cfsqltype="cf_sql_date" value="#rsNuevos.DVEfecha#"> between c.LTdesde and c.LThasta
										<cfelse>
										  and LTdesde = (select max(LTdesde) from LineaTiempo where DEid=#rsNuevos.DEid#)
										 </cfif> 
										 
										  
										  and c.DEid = #rsNuevos.DEid#
							</cfquery>
	
							<cfif diasPorRegimen.recordcount gt 0 and len(trim(diasPorRegimen.valor)) gt 0>
								<cfset cantDiasRegimen = diasPorRegimen.valor>
							<cfelse>
									<cf_dump var="no se genero dias por regimen, revisa!">
							</cfif>
						
							<cfquery datasource="#session.dsn#" >
									insert into DVacacionesAcum (DEid,Ecodigo,BMUsucodigo,DVAperiodo,DVAsaldodias,DVASalarioProm,DVASalarioPdiario,DVAfecha,
																		DVAdiasPotenciales,DVElinea,DVAmanual)
									values(
									
									#rsNuevos.DEid#
									,#session.Ecodigo#
									,20130430
									,#lvar_periodo#
									,0
									,0
									,0
									,<cfqueryparam cfsqltype="cf_sql_date" value="#rsNuevos.DVEfecha#">
									,#cantDiasRegimen#
									,null
									,0
									)
							</cfquery>
							<cfset AgregoNuevoSaldoDisponible = true>
						</cfif>
						
					<cfset lvar_Disponible = 99999999 ><!--- el ultimo periodo solo se asigna una vez y tiene siempre dias disponibles, dado que ahi se agregan todos los demás saldos---->

				<cfelse>
						<cfset lvar_periodo = rsDisponible.DVAperiodo>
						<cfset lvar_Disponible =  rsDisponible.valor>
				</cfif>

				
				<cfset diasIngresar = 0 >
				
				<cfif lvarVacSolicitadas gt 0>
					<cfset diasIngresar = lvarVacSolicitadas>
				<cfelse>				
					<cfif abs(lvarVacSolicitadas) lte lvar_Disponible>
						<cfset diasIngresar = abs(lvarVacSolicitadas)>
					<cfelse>
						<cfset diasIngresar = lvar_Disponible >
					</cfif>
				</cfif><!---<cfoutput>  diasIngresar = <cfif lvarVacSolicitadas lt 0>-</cfif>#diasIngresar#</cfoutput>--->
				
				<cfquery datasource="#session.dsn#" name="nuevoSaldo">
						insert into DVacacionesEmpleado (DEid,Ecodigo,DVEfecha,DVEreferencia,DVEdescripcion, DVEdisfrutados,DVEcompensados,DVEenfermedad,
						DVEadicionales,DVEmonto , Usucodigo, Ulocalizacion, DVEfalta, DVEperiodo, BMUsucodigo, DVErefLinea, DVEmanual )
						values(
						#rsNuevos.DEid#,
						#session.Ecodigo#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#rsNuevos.DVEfecha#">,
						null,
						'#rsNuevos.DVEdescripcion#',
						<cfif lvarVacSolicitadas lt 0>-</cfif>#diasIngresar#,
						#rsNuevos.DVEcompensados#,
						#rsNuevos.DVEenfermedad#,
						#rsNuevos.DVEadicionales#,
						#rsNuevos.DVEmonto#,
						20130430,
						#rsNuevos.Ulocalizacion#,
						null,
						#lvar_periodo#,
						20130430,
						null,
						#rsNuevos.DVEmanual#
						)
					<cf_dbidentity1 verificar_transaccion="no" datasource="#session.dsn#">
				</cfquery>
				<cf_dbidentity2 name="nuevoSaldo" verificar_transaccion="no" datasource="#session.dsn#">
				
				<cfquery datasource="#session.dsn#" >
						insert into DVacacionesAcum (DEid,Ecodigo,BMUsucodigo,DVAperiodo,DVAsaldodias,DVASalarioProm,DVASalarioPdiario,DVAfecha,
															DVAdiasPotenciales,DVElinea,DVAmanual)
						values(
						
						#rsNuevos.DEid#
						,#session.Ecodigo#
						,20130430
						,#lvar_periodo#
						,<cfif lvarVacSolicitadas lt 0>-</cfif>#diasIngresar#
						,0
						,0
						,<cfqueryparam cfsqltype="cf_sql_date" value="#rsNuevos.DVEfecha#">
						,0
						,#nuevoSaldo.identity#
						,#rsNuevos.DVEmanual#
						)
				</cfquery>
				<!---<cf_dump select="select * from DVacacionesAcum where DEid=2 order by DVAperiodo" abort=false>--->
				
				<cfif lvarVacSolicitadas gt 0><!---- si el monto es negativo se restan los dias y se conserva el signo--->
					<cfset lvarVacSolicitadas = lvarVacSolicitadas - diasIngresar>				
				<cfelse>
					<cfset lvarVacSolicitadas = (abs(lvarVacSolicitadas) - diasIngresar) * -1 >
				</cfif>
				
				<cfquery datasource="#session.dsn#" name="rsDisponible" maxrows="1">
					select DVAperiodo, coalesce(sum(DVAsaldodias),0) as valor
					from DVacacionesAcum
					where DEid = #rsNuevos.DEid# 
					group by DVAperiodo					
					having sum(DVAsaldodias) > 0      
					order by DVAperiodo
				</cfquery><!---<cfdump vaR="#rsDisponible#">--->
				
			</cfloop>
			
	</cfloop><!---<cf_dump select="select * from DVacacionesAcum where DEid= 2 order by DEid" abort=false>--->
	
	
		<!---- el nombramiento por defecto crear un potencial, sin embargo, hay empleados que no han disfrutado vacaciones, pero deben tener al menos el potencial.
		como el potencial ingreso en el ciclo anterior segun dias disfrutados, algunos empleados podrian no tener potencial asignado---->
		<cfquery datasource="#session.dsn#" name="rsNombradoSinPotencial">
		select de.DEid, EVfantig
		from DatosEmpleado de
			inner join EVacacionesEmpleado e
				on de.DEid = e.DEid
		where de.DEid in (select DEid from LineaTiempo where <cf_dbfunction name="today"> between LTdesde and LThasta)<!---- empleados activos--->
		and de.DEid Not in (select DEid from DVacacionesAcum)
		</cfquery>
		
		<cfloop query="rsNombradoSinPotencial">

			<cfquery datasource="#session.dsn#" name="diasPorRegimen">
					select 	( select rv.DRVdias
								 from DRegimenVacaciones rv 
								 where rv.RVid = c.RVid 
								   and rv.DRVcant = ( select max(DRVcant) 
													  from DRegimenVacaciones rv2 
														where rv2.RVid = c.RVid 
														and rv2.DRVcant <= 
														case when <cf_dbfunction name="datediff" args="a.EVfantig, #LSParseDateTime(rsNombradoSinPotencial.EVfantig)# ,yy"> < 1 
																then 1
														else <cf_dbfunction name="datediff" args="a.EVfantig, #LSParseDateTime(rsNombradoSinPotencial.EVfantig)# ,yy">
														end 		)
							   ) as valor
						from EVacacionesEmpleado a
							inner join DatosEmpleado b
								on b.DEid = a.DEid
							inner join LineaTiempo c
								on c.DEid = b.DEid
						where c.Ecodigo = #session.Ecodigo#
						  and LTdesde = (select max(LTdesde) from LineaTiempo where DEid=#rsNombradoSinPotencial.DEid#)
						  and c.DEid = #rsNombradoSinPotencial.DEid#
			</cfquery>

			<cfif diasPorRegimen.recordcount gt 0 and len(trim(diasPorRegimen.valor)) gt 0>
				<cfset cantDiasRegimen = diasPorRegimen.valor>
			<cfelse>
					<cf_dump var="no se genero dias por regimen, revisa!">
			</cfif>
		
			<cfquery datasource="#session.dsn#" >
					insert into DVacacionesAcum (DEid,Ecodigo,BMUsucodigo,DVAperiodo,DVAsaldodias,DVASalarioProm,DVASalarioPdiario,DVAfecha,
														DVAdiasPotenciales,DVElinea,DVAmanual)
					values(
					
					#rsNombradoSinPotencial.DEid#
					,#session.Ecodigo#
					,20130430
					,#year(now())#
					,0
					,0
					,0
					,<cfqueryparam cfsqltype="cf_sql_date" value="#rsNuevos.DVEfecha#">
					,#cantDiasRegimen#
					,null
					,0
					)
			</cfquery>
							
		</cfloop>	
		
			
	<cfquery datasource="#session.dsn#" >
		update DVacacionesEmpleado
		set DVEmanual = 1
		where DVElinea in (select b.DVElinea
						from #tablaAcum# a 
							inner join DVacacionesEmpleado b
								on a.DEid=b.DEid
								and a.DVAsaldodias = b.DVEdisfrutados
								and a.DVAfecha = b.DVEfecha
						 where a.DVAmanual=1 and b.DVEmanual=0
						 )
		and DVEmanual = 0					
	</cfquery>
	
	<cfquery datasource="#session.dsn#" >
		update DVacacionesAcum
		set DVAmanual = 1
		where DVAid in (select a.DVAid
						from DVacacionesAcum a 
							inner join DVacacionesEmpleado b
								on a.DEid=b.DEid
								and a.DVAsaldodias = b.DVEdisfrutados
								and a.DVAfecha = b.DVEfecha
						 where a.DVAmanual=0 and b.DVEmanual=1
						 )
		and DVAmanual = 0					
	</cfquery>

	
<!---		<cf_dump select="
			select  *
		 from DVacacionesAcum dva
		 where DEid=10
		order by dva.DVAperiodo
	" abort=false>		


		<cf_dump select="
			select   dva.DVAperiodo
				,sum(dva.DVAdiasPotenciales) as DiasRegimen
				,sum(case when dva.DVAsaldodias > 0 and dva.DVAmanual = 0  then  dva.DVAsaldodias else 0 end) as DiasRegimenAsignados
				,abs(coalesce(sum(case when dva.DVAsaldodias < 0 and dva.DVAmanual = 0 then dva.DVAsaldodias else 0 end ),0))
				as DiasDisfrutadosPorAccion
				,sum(case when dva.DVAmanual = 1 then dva.DVAsaldodias else 0 end) as AjustesManuales
				,sum(dva.DVASalarioProm) as DVASalarioProm
		 from DVacacionesAcum dva
		where dva.DEid = 10
			and dva.Ecodigo = #session.Ecodigo#
		group by dva.DEid, dva.DVAperiodo
		order by dva.DEid, dva.DVAperiodo
	" abort=true>	
--->
	
<cftransaction action="rollback">
</cftransaction>
<cfoutput><br />Listo</cfoutput>
