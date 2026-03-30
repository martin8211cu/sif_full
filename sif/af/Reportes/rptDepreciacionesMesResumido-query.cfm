<cfparam name="url.Periodo">
<cfparam name="url.Mes">
<cfif not isdefined("url.Archivo")>
	<cfset n = 3000>
	<cfquery name="rsxyzcant" datasource="#session.dsn#" maxrows="#n+1#">
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
				inner join ACategoria cat 
				on cat.Ecodigo = act.Ecodigo 
				and cat.ACcodigo = act.ACcodigo
				inner join AClasificacion clas 
				on clas.Ecodigo = act.Ecodigo 
				and clas.ACcodigo = act.ACcodigo 
				and clas.ACid = act.ACid
				inner join CFuncional cf 
				on cf.CFid = ta.CFid
			where ta.Ecodigo = #session.ecodigo#
				and ta.TAperiodo = #url.Periodo#
				and ta.TAmes = #url.Mes#
				and ta.IDtrans = 4
			group by ({fn concat({fn concat(cf.CFcodigo,' - ')},cf.CFdescripcion)}),	
				({fn concat({fn concat(cat.ACcodigodesc,' - ')},cat.ACdescripcion)}),
				({fn concat({fn concat(clas.ACcodigodesc,' - ')},clas.ACdescripcion)}),
				ta.TAperiodo,
				ta.TAmes
	</cfquery>	
	<cfif rsxyzcant.recordcount gt n>
		<cf_errorCode	code = "50111"
						msg  = "La cantidad de registros a desplegar supera los @errorDat_1@ registros. Limite con los filtros su consulta, o bajelo a un Archivo. Proceso Cancelado!"
						errorDat_1="#n#"
		>
	</cfif>
</cfif>
<cfsavecontent variable="consulta_reporte">
	<cfoutput>
		select 
				({fn concat({fn concat(cf.CFcodigo,' - ')},cf.CFdescripcion)}) as CFuncional,	
				({fn concat({fn concat(cat.ACcodigodesc,' - ')},cat.ACdescripcion)}) as Categoria,
				({fn concat({fn concat(clas.ACcodigodesc,' - ')},clas.ACdescripcion)}) as Clase,
				({fn concat({fn concat(ofi.Oficodigo,' - ')},ofi.Odescripcion)}) as Oficina,								
				ta.TAperiodo as Periodo, 
				ta.TAmes as Mes,
				<!--- Resumido
				act.Aplaca as Placa, 
				act.Adescripcion as Activo, 
				act.Aserie as Serie, --->
				sum(ta.TAvaladq) as Adquisicion, 
				sum(ta.TAvalmej) as Mejoras, 
				sum(ta.TAvalrev) as Revaluacion, 
				sum(ta.TAdepacumadq) as DepAcumAdquisicionAnterior, 
				sum(ta.TAdepacummej) as DepAcumMejorasAnterior, 
				sum(ta.TAdepacumrev) as DepAcumRevaluacionAnterior, 
				sum(ta.TAvaladq + ta.TAvalmej + ta.TAvalrev -
					ta.TAdepacumadq - ta.TAdepacummej - ta.TAdepacumrev) as ValorLibrosAnterior,
				sum(ta.TAmontolocadq) as DepreciacionAdquisicion, 
				sum(ta.TAmontolocmej) as DepreciacionMejoras, 
				sum(ta.TAmontolocrev) as DepreciacionRevaluacion, 
				sum(ta.TAvaladq + ta.TAvalmej + ta.TAvalrev -
					ta.TAdepacumadq - ta.TAdepacummej - ta.TAdepacumrev -
					ta.TAmontolocadq - ta.TAmontolocmej - ta.TAmontolocrev) as ValorLibrosDespues,
					cc.Cformato as CtaGastoDep,
					'' as espacio
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
				inner join ACategoria cat 
					on cat.Ecodigo = act.Ecodigo 
					and cat.ACcodigo = act.ACcodigo
					
				inner join AClasificacion clas 
					on clas.Ecodigo = act.Ecodigo 
					and clas.ACcodigo = act.ACcodigo 
					and clas.ACid = act.ACid
					
				inner join CFuncional cf 
					on cf.CFid = ta.CFid
					
				inner join Oficinas ofi 
					on ofi.Ocodigo = cf.Ocodigo
				   and ofi.Ecodigo = cf.Ecodigo
				   
				left join CContables cc
					on cc.Ccuenta = ta.Ccuenta
					  and cc.Ecodigo = ta.Ecodigo 				   
				   
			where ta.Ecodigo = #session.ecodigo#
				and ta.TAperiodo = #url.Periodo#
				and ta.TAmes = #url.Mes#
				and ta.IDtrans = 4
			group by ({fn concat({fn concat(cf.CFcodigo,' - ')},cf.CFdescripcion)}),	
				({fn concat({fn concat(cat.ACcodigodesc,' - ')},cat.ACdescripcion)}),
				({fn concat({fn concat(clas.ACcodigodesc,' - ')},clas.ACdescripcion)}),
				({fn concat({fn concat(ofi.Oficodigo,' - ')},ofi.Odescripcion)}),
				ta.TAperiodo,
				ta.TAmes,
				cc.Cformato
	</cfoutput>
</cfsavecontent>

