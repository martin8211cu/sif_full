<cfparam name="url.Periodo">
<cfparam name="url.Mes">
<cfif not isdefined("url.Archivo")>
	<cfquery name="rsxyzcant" datasource="#session.dsn#">
		select count(1) as Total
		from TransaccionesActivos ta 
			inner join Activos act
			on act.Ecodigo = ta.Ecodigo
			and act.Aid = ta.Aid
			<cfif isdefined('url.ACcodigodesde') and len(trim(url.ACcodigodesde)) gt 0 and url.ACcodigodesde gt 0>
				and act.ACcodigo >= #url.ACcodigodesde#
			</cfif>
			<cfif isdefined('url.ACcodigohasta') and len(trim(url.ACcodigohasta)) gt 0 and url.ACcodigohasta gt 0>
				and act.ACcodigo <= #url.ACcodigohasta#
			</cfif>
			<cfif (isdefined('url.Ocodigodesde') and len(trim(url.Ocodigodesde)) gt 0 and url.Ocodigodesde gt 0)
			and not (isdefined('url.Ocodigohasta') and len(trim(url.Ocodigohasta)) gt 0 and url.Ocodigohasta gt 0)>
				inner join CFuncional cfx on cfx.CFid = ta.CFid 
				and cfx.Ocodigo >= #url.Ocodigodesde#
			<cfelseif not (isdefined('url.Ocodigodesde') and len(trim(url.Ocodigodesde)) gt 0 and url.Ocodigodesde gt 0)
			and (isdefined('url.Ocodigohasta') and len(trim(url.Ocodigohasta)) gt 0 and url.Ocodigohasta gt 0)>
				inner join CFuncional cfx on cfx.CFid = ta.CFid 
				and cfx.Ocodigo <= #url.Ocodigohasta#
			<cfelseif (isdefined('url.Ocodigodesde') and len(trim(url.Ocodigodesde)) gt 0 and url.Ocodigodesde gt 0)
			and (isdefined('url.Ocodigohasta') and len(trim(url.Ocodigohasta)) gt 0 and url.Ocodigohasta gt 0)>
				inner join CFuncional cfx on cfx.CFid = ta.CFid 
				and cfx.Ocodigo between #url.Ocodigodesde# and #url.Ocodigohasta#
			</cfif>
		where ta.Ecodigo = #session.ecodigo#
			and ta.TAperiodo = #url.Periodo#
			and ta.TAmes = #url.Mes#
			and ta.IDtrans = 3
	</cfquery>	
	<cfset n = 3000>
	<cfif rsxyzcant.Total*2 gt n>
		<cf_errorCode	code = "50111"
						msg  = "La cantidad de registros a desplegar supera los @errorDat_1@ registros. Limite con los filtros su consulta, o bajelo a un Archivo. Proceso Cancelado!"
						errorDat_1="#n#"
		>
	</cfif>
</cfif>
<cfsavecontent variable="consulta_reporte">
	<cfoutput>
		select 
				(select {fn concat({fn concat(cf.CFcodigo,' - ')},cf.CFdescripcion)} from CFuncional cf where cf.CFid = ta.CFid) as CFuncional,	
				(select {fn concat({fn concat(cat.ACcodigodesc,' - ')},cat.ACdescripcion)} from ACategoria cat where cat.Ecodigo = act.Ecodigo and cat.ACcodigo = act.ACcodigo) as Categoria,
				(select {fn concat({fn concat(clas.ACcodigodesc,' - ')},clas.ACdescripcion)} from AClasificacion clas where clas.Ecodigo = act.Ecodigo and clas.ACcodigo = act.ACcodigo and clas.ACid = act.ACid) as Clase,
				(select {fn concat({fn concat(ofi.Oficodigo,' - ')},ofi.Odescripcion)} from CFuncional cf inner join Oficinas ofi on ofi.Ecodigo = cf.Ecodigo and ofi.Ocodigo = cf.Ocodigo where cf.CFid = ta.CFid) as Oficina,	
				(select {fn concat({fn concat(dto.Deptocodigo,' - ')},dto.Ddescripcion)} from CFuncional cf inner join Departamentos dto on dto.Ecodigo = cf.Ecodigo and dto.Dcodigo = cf.Dcodigo where cf.CFid = ta.CFid) as Departamento,
				ta.TAperiodo as Periodo, 
				ta.TAmes as Mes,
				act.Aplaca as PlacaSinRepetir, 
				act.Aplaca as Placa, 
				act.Adescripcion as ActivoSinRepetir, 
				act.Adescripcion as Activo, 
				act.Aserie as Serie,
				'Costo' as TipoMonto,
				coalesce(ta.TAvaladq,0.00) as Adquisicion, 
				coalesce(ta.TAvalmej,0.00) as Mejoras, 
				coalesce(ta.TAvalrev,0.00) as Revaluacion, 
				coalesce(ta.TAvaladq + ta.TAvalmej + ta.TAvalrev,0.00) as MontoTotal,
				<!---coalesce(round(ta.AFIindice,8),0.00) as Indice,--->
				<cf_dbfunction name="to_float" args="coalesce(ta.AFIindice,0.00)" dec="8"> as Indice,
				coalesce(ta.TAmontolocadq + ta.TAmontolocmej + ta.TAmontolocrev,0.00) as MontoRevaluacion,'' as espacio
			from TransaccionesActivos ta 
				inner join Activos act
				on act.Ecodigo = ta.Ecodigo
				and act.Aid = ta.Aid
				<cfif isdefined('url.ACcodigodesde') and len(trim(url.ACcodigodesde)) gt 0 and url.ACcodigodesde gt 0>
					and act.ACcodigo >= #url.ACcodigodesde#
				</cfif>
				<cfif isdefined('url.ACcodigohasta') and len(trim(url.ACcodigohasta)) gt 0 and url.ACcodigohasta gt 0>
					and act.ACcodigo <= #url.ACcodigohasta#
				</cfif>
				<cfif (isdefined('url.Ocodigodesde') and len(trim(url.Ocodigodesde)) gt 0 and url.Ocodigodesde gt 0)
				and not (isdefined('url.Ocodigohasta') and len(trim(url.Ocodigohasta)) gt 0 and url.Ocodigohasta gt 0)>
					inner join CFuncional cfx on cfx.CFid = ta.CFid 
					and cfx.Ocodigo >= #url.Ocodigodesde#
				<cfelseif not (isdefined('url.Ocodigodesde') and len(trim(url.Ocodigodesde)) gt 0 and url.Ocodigodesde gt 0)
				and (isdefined('url.Ocodigohasta') and len(trim(url.Ocodigohasta)) gt 0 and url.Ocodigohasta gt 0)>
					inner join CFuncional cfx on cfx.CFid = ta.CFid 
					and cfx.Ocodigo <= #url.Ocodigohasta#
				<cfelseif (isdefined('url.Ocodigodesde') and len(trim(url.Ocodigodesde)) gt 0 and url.Ocodigodesde gt 0)
				and (isdefined('url.Ocodigohasta') and len(trim(url.Ocodigohasta)) gt 0 and url.Ocodigohasta gt 0)>
					inner join CFuncional cfx on cfx.CFid = ta.CFid 
					and cfx.Ocodigo between #url.Ocodigodesde# and #url.Ocodigohasta#
				</cfif>
			where ta.Ecodigo = #session.ecodigo#
				and ta.TAperiodo = #url.Periodo#
				and ta.TAmes = #url.Mes#
				and ta.IDtrans = 3
		union all
		select 
				(select {fn concat({fn concat(cf.CFcodigo,' - ')},cf.CFdescripcion)} from CFuncional cf where cf.CFid = ta.CFid) as CFuncional,	
				(select {fn concat({fn concat(cat.ACcodigodesc,' - ')},cat.ACdescripcion)} from ACategoria cat where cat.Ecodigo = act.Ecodigo and cat.ACcodigo = act.ACcodigo) as Categoria,
				(select {fn concat({fn concat(clas.ACcodigodesc,' - ')},clas.ACdescripcion)} from AClasificacion clas where clas.Ecodigo = act.Ecodigo and clas.ACcodigo = act.ACcodigo and clas.ACid = act.ACid) as Clase,
				(select {fn concat({fn concat(ofi.Oficodigo,' - ')},ofi.Odescripcion)} from CFuncional cf inner join Oficinas ofi on ofi.Ecodigo = cf.Ecodigo and ofi.Ocodigo = cf.Ocodigo where cf.CFid = ta.CFid) as Oficina,	
				(select {fn concat({fn concat(dto.Deptocodigo,' - ')},dto.Ddescripcion)} from CFuncional cf inner join Departamentos dto on dto.Ecodigo = cf.Ecodigo and dto.Dcodigo = cf.Dcodigo where cf.CFid = ta.CFid) as Departamento,
				ta.TAperiodo as Periodo, 
				ta.TAmes as Mes,
				'' as PlacaSinRepetir, 
				act.Aplaca as Placa, 
				'' as ActivoSinRepetir, 
				act.Adescripcion as Activo, 
				act.Aserie as Serie,
				'Depreciacion' as TipoMonto,
				coalesce(ta.TAdepacumadq,0.00) as Adquisicion, 
				coalesce(ta.TAdepacummej,0.00) as Mejoras, 
				coalesce(ta.TAdepacumrev,0.00) as Revaluacion, 
				coalesce(ta.TAdepacumadq + ta.TAdepacummej + ta.TAdepacumrev,0.00) as MontoTotal,
				<cf_dbfunction name="to_float" args="coalesce(ta.AFIindice,0.00)" dec="8"> as Indice,
				<!---coalesce(ta.AFIindice,0.00) as Indice,--->
				coalesce(ta.TAmontodepadq + ta.TAmontodepmej + ta.TAmontodeprev,0.00) as MontoRevaluacion,'' as espacio
			from TransaccionesActivos ta 
				inner join Activos act
				on act.Ecodigo = ta.Ecodigo
				and act.Aid = ta.Aid
				<cfif isdefined('url.ACcodigodesde') and len(trim(url.ACcodigodesde)) gt 0 and url.ACcodigodesde gt 0>
					and act.ACcodigo >= #url.ACcodigodesde#
				</cfif>
				<cfif isdefined('url.ACcodigohasta') and len(trim(url.ACcodigohasta)) gt 0 and url.ACcodigohasta gt 0>
					and act.ACcodigo <= #url.ACcodigohasta#
				</cfif>
				<cfif (isdefined('url.Ocodigodesde') and len(trim(url.Ocodigodesde)) gt 0 and url.Ocodigodesde gt 0)
				and not (isdefined('url.Ocodigohasta') and len(trim(url.Ocodigohasta)) gt 0 and url.Ocodigohasta gt 0)>
					inner join CFuncional cfx on cfx.CFid = ta.CFid 
					and cfx.Ocodigo >= #url.Ocodigodesde#
				<cfelseif not (isdefined('url.Ocodigodesde') and len(trim(url.Ocodigodesde)) gt 0 and url.Ocodigodesde gt 0)
				and (isdefined('url.Ocodigohasta') and len(trim(url.Ocodigohasta)) gt 0 and url.Ocodigohasta gt 0)>
					inner join CFuncional cfx on cfx.CFid = ta.CFid 
					and cfx.Ocodigo <= #url.Ocodigohasta#
				<cfelseif (isdefined('url.Ocodigodesde') and len(trim(url.Ocodigodesde)) gt 0 and url.Ocodigodesde gt 0)
				and (isdefined('url.Ocodigohasta') and len(trim(url.Ocodigohasta)) gt 0 and url.Ocodigohasta gt 0)>
					inner join CFuncional cfx on cfx.CFid = ta.CFid 
					and cfx.Ocodigo between #url.Ocodigodesde# and #url.Ocodigohasta#
				</cfif>
			where ta.Ecodigo = #session.ecodigo#
				and ta.TAperiodo = #url.Periodo#
				and ta.TAmes = #url.Mes#
				and ta.IDtrans = 3
			order by 1, 2, 3, 9, 13
	</cfoutput>
</cfsavecontent>

