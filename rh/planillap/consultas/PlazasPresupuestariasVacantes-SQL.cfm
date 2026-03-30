<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfif isdefined("form.Estado") and form.Estado EQ 'C'>
	<cfquery name="rsDatos" datasource="#session.DSN#">		
		select  	ltrim(rtrim(pp.RHPPcodigo)) as RHPPcodigo,
					ltrim(rtrim(pp.RHPPdescripcion)) as RHPPdescripcion,
					case ltp.RHMPestadoplaza  	when 'A' then 'Activa'
												when 'C' then 'Congelada'
												when 'I' then 'Inactiva'
					end as Estado,
					ltrim(rtrim(cf.CFcodigo)) #LvarCNCT#' - '#LvarCNCT# ltrim(rtrim(cf.CFdescripcion)) as CFuncional,
					ltp.CFidautorizado
				
		from RHPlazaPresupuestaria pp
			inner join RHLineaTiempoPlaza ltp
				on ltp.RHPPid = pp.RHPPid
			inner join CFuncional cf
				on ltp.CFidautorizado = cf.CFid
		where pp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif isdefined("form.fechaCorte") and len(trim(form.fechaCorte))>
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fechaCorte)#"> between ltp.RHLTPfdesde and ltp.RHLTPfhasta
			</cfif>	
			and RHMPestadoplaza = 'C'
			
			<!----========================================----->
			<cfif isdefined("form.CFid") and len(trim(form.CFid))>
				and ltp.CFidautorizado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
			</cfif>
			<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))>
				and cf.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">
			</cfif>	
			<cfif isdefined("form.Dcodigo") and len(trim(form.Dcodigo))>
				and cf.Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Dcodigo#">
			</cfif>	
			<!----========================================----->

		order by ltp.CFidautorizado, ltrim(rtrim(cf.CFcodigo)) #LvarCNCT#' - '#LvarCNCT# ltrim(rtrim(cf.CFdescripcion)), ltrim(rtrim(pp.RHPPcodigo)), ltrim(rtrim(pp.RHPPdescripcion))
	</cfquery>		
<cfelseif isdefined("form.Estado") and form.Estado EQ 'A'>
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select 	ltrim(rtrim(pp.RHPPcodigo)) as RHPPcodigo,
				ltrim(rtrim(pp.RHPPdescripcion)) as RHPPdescripcion,
				case ltp.RHMPestadoplaza  	when 'A' then 'Activa'
											when 'C' then 'Congelada'
											when 'I' then 'Inactiva'
				end as Estado,
				ltrim(rtrim(cf.CFcodigo)) #LvarCNCT#' - '#LvarCNCT# ltrim(rtrim(cf.CFdescripcion)) as CFuncional,
				ltp.CFidautorizado
					
		from RHPlazaPresupuestaria pp
			inner join RHLineaTiempoPlaza ltp
				on ltp.RHPPid = pp.RHPPid
			inner join CFuncional cf
				on ltp.CFidautorizado = cf.CFid
		where pp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and getdate() between ltp.RHLTPfdesde and ltp.RHLTPfhasta
			and ltp.RHMPestadoplaza = 'A'
			and not exists(select 1 
							from RHPlazas pr
								inner join LineaTiempo lt
									on lt.RHPid = pr.RHPid
							where pr.RHPPid = ltp.RHPPid
							<cfif isdefined("form.fechaCorte") and len(trim(form.fechaCorte))>
								and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fechaCorte)#"> between lt.LTdesde and lt.LThasta
							</cfif>	
							)
							
			<!----========================================----->
			<cfif isdefined("form.CFid") and len(trim(form.CFid))>
				and ltp.CFidautorizado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
			</cfif>
			<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))>
				and cf.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">
			</cfif>	
			<cfif isdefined("form.Dcodigo") and len(trim(form.Dcodigo))>
				and cf.Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Dcodigo#">
			</cfif>	
			<!----========================================----->
			
		order by ltp.CFidautorizado, ltrim(rtrim(cf.CFcodigo)) #LvarCNCT#' - '#LvarCNCT#ltrim(rtrim(cf.CFdescripcion)), ltrim(rtrim(pp.RHPPcodigo)), ltrim(rtrim(pp.RHPPdescripcion))
	</cfquery>
<cfelseif isdefined("form.Estado") and form.Estado EQ 'B'>
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select  	ltrim(rtrim(pp.RHPPcodigo)) as RHPPcodigo,
					ltrim(rtrim(pp.RHPPdescripcion)) as RHPPdescripcion,
					case ltp.RHMPestadoplaza  	when 'A' then 'Activa'
												when 'C' then 'Congelada'
												when 'I' then 'Inactiva'
					end as Estado,
					ltrim(rtrim(cf.CFcodigo)) #LvarCNCT#' - '#LvarCNCT# ltrim(rtrim(cf.CFdescripcion)) as CFuncional,
					ltp.CFidautorizado
					
		from RHPlazaPresupuestaria pp
			inner join RHLineaTiempoPlaza ltp
				on ltp.RHPPid = pp.RHPPid
			inner join CFuncional cf
				on ltp.CFidautorizado = cf.CFid
		where pp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif isdefined("form.fechaCorte") and len(trim(form.fechaCorte))>
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fechaCorte)#"> between ltp.RHLTPfdesde and ltp.RHLTPfhasta
			</cfif>		
			and RHMPestadoplaza = 'C'
			
			<!----========================================----->
			<cfif isdefined("form.CFid") and len(trim(form.CFid))>
				and ltp.CFidautorizado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
			</cfif>
			<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))>
				and cf.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">
			</cfif>	
			<cfif isdefined("form.Dcodigo") and len(trim(form.Dcodigo))>
				and cf.Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Dcodigo#">
			</cfif>	
			<!----========================================----->
		
		union
		
		select 	ltrim(rtrim(pp.RHPPcodigo)),
				ltrim(rtrim(pp.RHPPdescripcion)),
				case ltp.RHMPestadoplaza  when 'A' then 'Activa'
										when 'C' then 'Congelada'
										when 'I' then 'Inactiva'
				end as Estado,
				ltrim(rtrim(cf.CFcodigo)) #LvarCNCT#' - '#LvarCNCT# ltrim(rtrim(cf.CFdescripcion)) as CFuncional,
				ltp.CFidautorizado
				
		from RHPlazaPresupuestaria pp
			inner join RHLineaTiempoPlaza ltp
				on ltp.RHPPid = pp.RHPPid
			inner join CFuncional cf
				on ltp.CFidautorizado = cf.CFid
		where pp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and getdate() between ltp.RHLTPfdesde and ltp.RHLTPfhasta
			and ltp.RHMPestadoplaza = 'A'
			and not exists(select 1 
							from RHPlazas pr
								inner join LineaTiempo lt
									on lt.RHPid = pr.RHPid
							where pr.RHPPid = ltp.RHPPid
								<cfif isdefined("form.fechaCorte") and len(trim(form.fechaCorte))>
									and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fechaCorte)#"> between lt.LTdesde and lt.LThasta
								</cfif>	
							)		
							
			<!----========================================----->
			<cfif isdefined("form.CFid") and len(trim(form.CFid))>
				and ltp.CFidautorizado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
			</cfif>
			<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))>
				and cf.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">
			</cfif>	
			<cfif isdefined("form.Dcodigo") and len(trim(form.Dcodigo))>
				and cf.Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Dcodigo#">
			</cfif>	
			<!----========================================----->
			
		order by ltp.CFidautorizado, ltrim(rtrim(cf.CFcodigo)) #LvarCNCT#' - '#LvarCNCT# ltrim(rtrim(cf.CFdescripcion)), ltrim(rtrim(pp.RHPPcodigo)), ltrim(rtrim(pp.RHPPdescripcion))
	</cfquery>	
</cfif>
	
<cfif isdefined("rsDatos")>
	<cfreport format="#form.formato#" template= "PlazasPresupuestariasVacantes.cfr" query="rsDatos">
		<cfreportparam name="Edescripcion" value="#session.enombre#">
	</cfreport>
</cfif>
