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
			and ta.IDtrans = 4
	</cfquery>	
	<cfset n = 3000>
	<cfif rsxyzcant.Total gt n>
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
				act.Aplaca as Placa, 
				act.Adescripcion as Activo, 
				act.Aserie as Serie,
				ta.TAvaladq as Adquisicion, 
				ta.TAvalmej as Mejoras, 
				ta.TAvalrev as Revaluacion, 
				ta.TAdepacumadq as DepAcumAdquisicionAnterior, 
				ta.TAdepacummej as DepAcumMejorasAnterior, 
				ta.TAdepacumrev as DepAcumRevaluacionAnterior, 
				ta.TAvaladq + ta.TAvalmej + ta.TAvalrev -
					ta.TAdepacumadq - ta.TAdepacummej - ta.TAdepacumrev as ValorLibrosAnterior,
				ta.TAmontolocadq as DepreciacionAdquisicion, 
				ta.TAmontolocmej as DepreciacionMejoras, 
				ta.TAmontolocrev as DepreciacionRevaluacion, 
				ta.TAvaladq + ta.TAvalmej + ta.TAvalrev -
					ta.TAdepacumadq - ta.TAdepacummej - ta.TAdepacumrev -
					ta.TAmontolocadq - ta.TAmontolocmej - ta.TAmontolocrev as ValorLibrosDespues,
				ta.TAmeses as Meses, '' as espacio, 
				
				(Select cc.Cformato 
				 from CContables cc
				 where cc.Ccuenta = ta.Ccuenta
				   and cc.Ecodigo = ta.Ecodigo ) as CtaGastoDep
				
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
				and ta.IDtrans = 4
			order by 1, 2, 3, 8
	</cfoutput>
</cfsavecontent>

