<cfquery name="rsLista" datasource="#session.DSN#">
	select 	/*ojo si se modifica el orden de las columnas, modifcar el order by*/
			{fn concat({fn concat({fn concat({fn concat(b.DEapellido1 , ' ' )}, b.DEapellido2 )},  ' ' )}, b.DEnombre)} as Empleado, 
			a.CAMfdesde, a.CAMfhasta, a.CAMid,a.CAMpermiso,
			case when a.RHJid is not null then 
				c.RHJdescripcion
			else
				'#LB_Feriado#'
			end as Jornada,
			coalesce(round(<cf_dbfunction name="to_float" args="coalesce(a.CAMtotminutos,1)">/60.00, 2),0) as HT,
			coalesce(round(<cf_dbfunction name="to_float" args="coalesce(a.CAMociominutos,1)">/60.00, 2),0) as HO,
			coalesce(round(<cf_dbfunction name="to_float" args="coalesce(a.CAMtotminlab,1)">/60.00, 2),0) as HL,
			coalesce(a.CAMsuphorasreb,0) as HR,
			coalesce(a.CAMsuphorasjornada,0) as HN,
			coalesce(a.CAMsuphorasextA,0) as HEA,
			coalesce(a.CAMsuphorasextB,0) as HEB,
			coalesce(a.CAMsupmontoferiado,0) as MFeriado,
			case a.CAMpermiso
			when 1 then a.CAMid
			else null end as inactivecol,
			case a.CAMpermiso
			when 1 then '<img src=/cfmx/rh/imagenes/checked.gif>'
			else '<img src=/cfmx/rh/imagenes/unchecked.gif>' end as permiso,
            case when (	select count(1) 
                    from RHCMCalculoAcumMarcas x 
                    where x.DEid = a.DEid
                      and x.CAMfdesde = a.CAMfdesde
                      and x.CAMid <> a.CAMid
                      and x.CAMpermiso <> a.CAMpermiso
                      and x.CAMgeneradoporferiado = 0
					  and x.CAMgeneradoporferiado = a.CAMgeneradoporferiado
                      ) > 0 then 1
            else 0 end as inconsistencia,
			case when (	select count(1) 
			from RHCMCalculoAcumMarcas x 
			inner join RHControlMarcas z
				on x.DEid = z.DEid
				and x.CAMfdesde = z.fechahoramarca
			where x.DEid = a.DEid
			  and x.CAMfdesde = a.CAMfdesde
			  and x.CAMid <> a.CAMid
			  and x.CAMpermiso = a.CAMpermiso
			  and x.CAMgeneradoporferiado = a.CAMgeneradoporferiado) > 0 then CAMid
			else 0 end marcaIgual
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
	order by 1, 2, 3
</cfquery>
