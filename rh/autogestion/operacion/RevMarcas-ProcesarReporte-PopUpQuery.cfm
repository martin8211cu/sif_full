<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Usted_no_tiene_grupos_asociados_No_puede_acceder_este_proceso"
	Default="Usted no tiene grupos asociados. No puede acceder este proceso"
	returnvariable="MSG_Usted_no_tiene_grupos_asociados_No_puede_acceder_este_proceso"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_No_se_puede_mostrar_el_reporte_porque_la_cantidad_de_registros_exede_los_3000_permitidos"
	Default="No se puede mostrar el reporte porque la cantidad de registros exede los 3000 permitidos."
	returnvariable="MSG_No_se_puede_mostrar_el_reporte_porque_la_cantidad_de_registros_exede_los_3000_permitidos"/>
<cfquery name="rsGrupos" datasource="#session.DSN#">
	select  b.Gid, b.Gdescripcion
	from RHCMAutorizadoresGrupo a
		inner join RHCMGrupos b
			on a.Gid = b.Gid
			and a.Ecodigo = b.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.Usucodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
</cfquery>
<cfif rsGrupos.recordcount eq 0>
	<cf_throw message="#MSG_Usted_no_tiene_grupos_asociados_No_puede_acceder_este_proceso#" errorcode="5110">
<cfelseif rsGrupos.recordcount eq 1>
	<cfparam name="Form.FAGrupo" default="#rsGrupos.Gid#">
</cfif>
<cfquery name="rsLista" datasource="#session.DSN#" maxrows="3001">
	select 	{fn concat({fn concat({fn concat({fn concat(b.DEapellido1 , ' ' )}, b.DEapellido2 )},  ' ' )}, b.DEnombre)} as Empleado, 
			min(a.CAMfdesde) as CAMfdesde, max(a.CAMfhasta) as CAMfhasta,
			case when a.RHJid is not null then 
				c.RHJdescripcion
			else
				'#LB_Feriado#'
			end as Jornada,
			sum(coalesce(round(<cf_dbfunction name="to_float" args="coalesce(a.CAMtotminutos,1)">/60.00, 2),0)) as HT,
			sum(coalesce(round(<cf_dbfunction name="to_float" args="coalesce(a.CAMociominutos,1)">/60.00, 2),0)) as HO,
			sum(coalesce(round(<cf_dbfunction name="to_float" args="coalesce(a.CAMtotminlab,1)">/60.00, 2),0)) as HL,
			sum(coalesce(a.CAMsuphorasreb,0)) as HR,
			sum(coalesce(a.CAMsuphorasjornada,0)) as HN,
			sum(coalesce(a.CAMsuphorasextA,0)) as HEA,
			sum(coalesce(a.CAMsuphorasextB,0)) as HEB,
			sum(coalesce(a.CAMsupmontoferiado,0)) as MFeriado --->
	from RHCMCalculoAcumMarcas a
		inner join DatosEmpleado b
			on a.DEid = b.DEid
			and a.Ecodigo = b.Ecodigo
		left outer join RHJornadas c
			on a.RHJid = c.RHJid
			and a.Ecodigo = c.Ecodigo
		inner join RHCMEmpleadosGrupo d
				on a.DEid = d.DEid
				and a.Ecodigo = d.Ecodigo															
				<cfif isdefined("form.FAGrupo") and len(trim(form.FAGrupo))>
					and d.Gid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FAGrupo#">
				<cfelse>
					and d.Gid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(rsGrupos.Gid)#" list="true">)
				</cfif>
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.CAMestado = 'P'
		<cfif isdefined("form.RHJid") and len(trim(form.RHJid))>
			and a.RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHJid#">
		</cfif>
		<cfif isdefined("form.FADEid") and len(trim(form.FADEid))>
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FADEid#">
		</cfif>
		<cfif isdefined("form.FAfechaInicial") and len(trim(form.FAfechaInicial)) and isdefined("form.FAfechaFinal") and len(trim(form.FAfechaFinal))>
			<cfif form.FAfechaInicial GT form.FAfechaFinal>
				and <cf_dbfunction name="date_format" args="a.CAMfdesde,yyyymmdd"> 
					between <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(form.FAfechaFinal),'yyyymmdd')#">
					and  <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(form.FAfechaInicial),'yyyymmdd')#">
			<cfelseif form.FAfechaFinal GT form.FAfechaInicial>
				and <cf_dbfunction name="date_format" args="a.CAMfdesde,yyyymmdd"> 
					between <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(form.FAfechaInicial),'yyyymmdd')#">
					and <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(form.FAfechaFinal),'yyyymmdd')#">
			<cfelse>
				and <cf_dbfunction name="date_format" args="a.CAMfdesde,yyyymmdd"> = <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(form.FAfechaInicial),'yyyymmdd')#">
			</cfif>
		<cfelseif isdefined("form.FAfechaInicial") and len(trim(form.FAfechaInicial)) and (not isdefined("form.FAfechaFinal") or  len(trim(form.FAfechaFinal)) EQ 0)>
			and <cf_dbfunction name="date_format" args="a.CAMfdesde,yyyymmdd"> >= <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(form.FAfechaInicial),'yyyymmdd')#">
		<cfelseif isdefined("form.FAfechaFinal") and len(trim(form.FAfechaFinal)) and (not isdefined("form.FAfechaInicial") or  len(trim(form.FAfechaInicial)) EQ 0)>
			and <cf_dbfunction name="date_format" args="a.CAMfdesde,yyyymmdd"> <= <cfqueryparam cfsqltype="varchar" value="#LSDateFormat(LSParseDateTime(form.FAfechaFinal),'yyyymmdd')#">
		</cfif>	
	group by {fn concat({fn concat({fn concat({fn concat(b.DEapellido1 , ' ' )}, b.DEapellido2 )},  ' ' )}, b.DEnombre)},
		case when a.RHJid is not null then 
			c.RHJdescripcion
		else
			'#LB_Feriado#'
		end
	order by 1, 2, 3
</cfquery>
<cfif rsLista.recordcount gt 3000>
	<cf_throw  message="#MSG_No_se_puede_mostrar_el_reporte_porque_la_cantidad_de_registros_exede_los_3000_permitidos#" errorcode="5115">
</cfif>