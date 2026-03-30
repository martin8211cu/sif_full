<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">	
<cfquery name="rsDatos" datasource="#session.DSN#">
	select distinct so.RHSPid, es.RHEid, so.CFid,
		( select max(a.BMfecha) from RHMovPlaza a inner join RHFormulacion b on b.RHFid=a.RHFid and b.RHEid=es.RHEid  ) as FechaAprobacion,
		es.RHEdescripcion,
		so.RHSPconsecutivo,
		ltrim(rtrim(dp.Pnombre))#LvarCNCT#' '#LvarCNCT#ltrim(rtrim(dp.Papellido1))#LvarCNCT#' '#LvarCNCT#ltrim(rtrim(dp.Papellido2)) as Solicitante,
		ltrim(rtrim(cf.CFcodigo)) #LvarCNCT#' '#LvarCNCT# ltrim(rtrim(cf.CFdescripcion)) as Cfuncional
		
	from RHSolicitudPlaza so		
		inner join CFuncional cf
			on so.CFid = cf.CFid
			
		inner join Usuario us
			on us.Usucodigo=so.BMUsucodigo
		
			left outer join DatosPersonales dp
				on dp.datos_personales = us.datos_personales	
		
		inner join RHSituacionActual st
			on so.RHSPid = st.RHSPid
			
			inner join RHEscenarios es
				on st.RHEid = es.RHEid
				<!---Filtro de escenario---->	
				<cfif isdefined("form.RHEid") and len(trim(form.RHEid))>
					and es.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
				</cfif>

	where so.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and so.RHSPestado = 40
		<!---Filtro de centro funcional---->				
		<cfif isdefined("form.CFid") and len(trim(form.CFid))>
			and so.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
		</cfif>
		<!---Filtro de Solicitante---->
		<cfif isdefined ("form.Usucodigo") and len(trim(form.Usucodigo))>
			and so.BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
		</cfif>
		<!----Filtro de no.solicitud---->
		<cfif isdefined("form.RHSPconsecutivo_desde") and len(trim(form.RHSPconsecutivo_desde)) and (isdefined("form.RHSPconsecutivo_hasta") and len(trim(form.RHSPconsecutivo_hasta))) >
			<cfif form.RHSPconsecutivo_desde  GT form.RHSPconsecutivo_hasta>
				and so.RHSPconsecutivo between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPconsecutivo_hasta#">
				and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPconsecutivo_desde#">
			<cfelseif form.RHSPconsecutivo_desde EQ form.RHSPconsecutivo_hasta>
				and so.RHSPconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPconsecutivo_desde#">
			<cfelse>
				and so.RHSPconsecutivo between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPconsecutivo_desde#">
				and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPconsecutivo_hasta#">
			</cfif>
		<cfelseif isdefined("form.RHSPconsecutivo_desde") and len(trim(form.RHSPconsecutivo_desde)) and (not isdefined("form.RHSPconsecutivo_hasta") or len(trim(form.RHSPconsecutivo_hasta)) EQ 0) >
			and so.RHSPconsecutivo >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPconsecutivo_desde#">
		<cfelseif isdefined("form.RHSPconsecutivo_hasta") and len(trim(form.RHSPconsecutivo_hasta)) and (not isdefined("form.RHSPconsecutivo_desde") or len(trim(form.RHSPconsecutivo_desde)) EQ 0) >
			and so.RHSPconsecutivo <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHSPconsecutivo_hasta#">
		</cfif>		
	order by so.CFid,so.RHSPconsecutivo, es.RHEdescripcion
</cfquery>

<cfreport format="#form.formato#" template= "SolicitudPlazasTerminadas.cfr" query="rsDatos">
	<cfreportparam name="Edescripcion" value="#session.enombre#">
</cfreport>
