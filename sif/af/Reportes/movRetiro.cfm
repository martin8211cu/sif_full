<cfsavecontent variable="myQuery">
	<cfoutput>
 		select 
			Aplaca as Placa, 
			Adescripcion as Activo, 
			(select cat.ACcodigodesc
				from ACategoria cat
				where cat.ACcodigo=act.ACcodigo
				and cat.Ecodigo=act.Ecodigo
				<cfif (isdefined("url.codigodesde") and len(trim(url.codigodesde)) gt 0)
				and not (isdefined("url.codigohasta") and len(trim(url.codigohasta)) gt 0)>
				and cat.ACcodigo > #url.codigodesde#
				<cfelseif not (isdefined("url.codigodesde") and len(trim(url.codigodesde)) gt 0)
				and (isdefined("url.codigohasta") and len(trim(url.codigohasta)) gt 0)>
				and cat.ACcodigo < #url.codigohasta#
				<cfelseif (isdefined("url.codigodesde") and len(trim(url.codigodesde)) gt 0)
				and (isdefined("url.codigohasta") and len(trim(url.codigohasta)) gt 0)>
				and cat.ACcodigo between #url.codigodesde# and #url.codigohasta#
				</cfif>
			) as Categoria, 
			
			(select clas.ACcodigodesc
			from AClasificacion clas
			where clas.ACcodigo=act.ACcodigo
			and clas.Ecodigo=act.Ecodigo
			and clas.ACid = act.ACid
			) as Clase, 
			
			({fn concat(cf1.CFcodigo, {fn concat('-', cf1.CFdescripcion)})}) as CFuncionalOrigen,
			TAfecha as Fecha, 
			coalesce(TAvaladq,0.00) + coalesce(TAvalmej,0.00) + coalesce(TAvalrev,0.00) as ValorTotal,
			
			coalesce(TAdepacumadq,0.00) + coalesce(TAdepacummej,0.00) + coalesce(TAdepacumrev,0.00) as DepreciacionAcumTotal,
			
			coalesce(TAvaladq,0.00) + coalesce(TAvalmej,0.00) + coalesce(TAvalrev,0.00) - 
			coalesce(TAdepacumadq,0.00) - coalesce(TAdepacummej,0.00) - coalesce(TAdepacumrev,0.00) as ValorLibros,

			case AFResventa when 'S' then coalesce(TAmontolocventa,0.00) else
			coalesce(TAmontolocadq,0.00) + coalesce(TAmontolocmej,0.00) + coalesce(TAmontolocrev,0.00) - 
			coalesce(TAmontodepadq,0.00) - coalesce(TAmontodepmej,0.00) - coalesce(TAmontodeprev,0.00) end as ValorRetiro,
			
			(case AFResventa when 'S' then coalesce(TAmontolocventa,0.00) else
			coalesce(TAmontolocadq,0.00) + coalesce(TAmontolocmej,0.00) + coalesce(TAmontolocrev,0.00) - 
			coalesce(TAmontodepadq,0.00) - coalesce(TAmontodepmej,0.00) - coalesce(TAmontodeprev,0.00) end)
			
			-
			
			(coalesce(TAvaladq,0.00) + coalesce(TAvalmej,0.00) + coalesce(TAvalrev,0.00) - 
			coalesce(TAdepacumadq,0.00) - coalesce(TAdepacummej,0.00) - coalesce(TAdepacumrev,0.00)) as GananciaPerdida,
			
			afr.AFRdescripcion
			
		from TransaccionesActivos ta
			inner join Activos act
				on act.Ecodigo = ta.Ecodigo
				and act.Aid = ta.Aid
			inner join CFuncional cf1 
				on cf1.CFid = ta.CFid 
				and cf1.CFcodigo between '#url.CFcodigoinicio#' and '#url.CFcodigofinal#'
			inner join AGTProceso agtp
					inner join AFRetiroCuentas afr
						on afr.Ecodigo = agtp.Ecodigo
						and afr.AFRmotivo = agtp.AFRmotivo
				on agtp.AGTPid = ta.AGTPid
			<cfif isdefined("url.AFRmotivo") and len(trim(url.AFRmotivo)) gt 0>
				and agtp.AFRmotivo = #url.AFRmotivo#
			</cfif>
		where ta.Ecodigo = #session.ecodigo#
			and ta.IDtrans = #url.IDtrans#
			and (TAperiodo > #url.PeriodoInicial#
				or  (TAperiodo = #url.PeriodoInicial#
				and TAmes >= #url.MesInicial#))
			and (TAperiodo < #url.PeriodoFinal# 
				or  (TAperiodo = #url.PeriodoFinal# 
				and TAmes <= #url.MesFinal#))

		order by CFuncionalOrigen, TAfecha
	</cfoutput>
</cfsavecontent>

<cftry>
	<cfflush interval="16000">
	<cf_jdbcquery_open name="data" datasource="#session.DSN#">
	<cfoutput>#myquery#</cfoutput>
	</cf_jdbcquery_open>
	
	<cfif isdefined("url.exportar")>
		<cf_exportQueryToFile query="#data#" separador="#chr(9)#" filename="Mov_Retiro_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.txt" jdbc="true">
	</cfif>
	
	<cfset registros = 0 >

	<!--- totales generales --->
	<cfset GTAvaltot = 0 >
	<cfset GTAdepacumtot = 0 >
	<cfset GTAvallibros = 0 >
	
	<cfset GTAvalretiro = 0 >
	<cfset GTAgananciaperdida = 0 >

<table width="100%" border="0" cellpadding="2" cellspacing="0">
	 <tr style="padding:10px;">
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap">Placa</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap">Descripci&oacute;n</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap">Categor&iacute;a</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap">Clase</td>
		
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap">Fecha</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap" align="right">Valor</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap" align="right">Dep. Acumulada</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap" align="right">V.Libros</td>
		
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap" align="right">V.Retiro</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap" align="right">Ganancia/Perdida</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap" align="right">Motivo Ret.</td>
	</tr>

	<cfoutput query="data" group="CFuncionalOrigen">
		<cfset registros = registros + 1>
		<cfif registros neq 1>
			<tr>
				<td colspan="5"><strong>Total Centro Funcional #trim(vCFuncionalOrigen)#</strong></td>
				<td align="right"><strong>#LSNumberFormat(CFTAvaltot, ',9.00')#</td>
				<td align="right"><strong>#LSNumberFormat(CFTAdepacumtot, ',9.00')#</td>
				<td align="right"><strong>#LSNumberFormat(CFTAvallibros, ',9.00')#</td>
				
				<td align="right"><strong>#LSNumberFormat(CFTAvalretiro, ',9.00')#</td>
				<td align="right"><strong>#LSNumberFormat(CFTAgananciaperdida, ',9.00')#</td>
				<td>&nbsp;</td>
			</tr>
			<tr><td>&nbsp;</td></tr>	
		</cfif>

		<cfset vCFuncionalOrigen = CFuncionalOrigen>
		<cfset CFTAvaltot = 0 >
		<cfset CFTAdepacumtot = 0 >
		<cfset CFTAvallibros = 0 >

		<cfset CFTAvalretiro = 0 >
		<cfset CFTAgananciaperdida = 0 >
	
		<tr><td class="tituloListas" colspan="11">#trim(CFuncionalOrigen)#</td></tr>
		<cfoutput>
			<tr>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#Placa#</td>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#Activo#</td>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#Categoria#</td>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#Clase#</td>
				
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#LSDateFormat(Fecha)#</td>
				<td align="right" style="padding:3px;font-size:9px">#LSNumberFormat(ValorTotal, ',9.00')#</td>
				<td align="right" style="padding:3px;font-size:9px">#LSNumberFormat(DepreciacionAcumTotal, ',9.00')#</td>
				<td align="right" style="padding:3px;font-size:9px">#LSNumberFormat(ValorLibros, ',9.00')#</td>
				
				<td align="right" style="padding:3px;font-size:9px">#LSNumberFormat(ValorRetiro, ',9.00')#</td>
				<td align="right" style="padding:3px;font-size:9px">#LSNumberFormat(GananciaPerdida, ',9.00')#</td>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#AFRdescripcion#</td>
			</tr>
			<cfset CFTAvaltot = CFTAvaltot + ValorTotal>
			<cfset CFTAdepacumtot = CFTAdepacumtot + DepreciacionAcumTotal>
			<cfset CFTAvallibros = CFTAvallibros + ValorLibros>
			
			<cfset CFTAvalretiro= CFTAvalretiro + ValorRetiro>
			<cfset CFTAgananciaperdida = CFTAgananciaperdida + GananciaPerdida>
			
			<cfset GTAvaltot = GTAvaltot + ValorTotal>
			<cfset GTAdepacumtot = GTAdepacumtot + DepreciacionAcumTotal>
			<cfset GTAvallibros = GTAvallibros + ValorLibros>
			
			<cfset GTAvalretiro= GTAvalretiro + ValorRetiro>
			<cfset GTAgananciaperdida = GTAgananciaperdida + GananciaPerdida>
		</cfoutput>
	</cfoutput>
	
<cfcatch type="any">
	<cf_jdbcquery_close>
	<cfrethrow>
</cfcatch>
</cftry>
	<cf_jdbcquery_close>
	
	<cfif registros gt 0 >
	<!--- TOTAL DE ULTIMO CENTRO FUNCIONAL --->
		<cfoutput>
		<tr>
			<td colspan="5"><strong>Total Centro Funcional #trim(vCFuncionalOrigen)#</strong></td>
			<td align="right"><strong>#LSNumberFormat(CFTAvaltot, ',9.00')#</td>
			<td align="right"><strong>#LSNumberFormat(CFTAdepacumtot, ',9.00')#</td>
			<td align="right"><strong>#LSNumberFormat(CFTAvallibros, ',9.00')#</td>

			<td align="right"><strong>#LSNumberFormat(CFTAvalretiro, ',9.00')#</td>
			<td align="right"><strong>#LSNumberFormat(CFTAgananciaperdida, ',9.00')#</td>
			<td>&nbsp;</td>
		</tr>
		<tr><td>&nbsp;</td></tr>	
	
		<tr>
			<td colspan="5"><strong>Total General</strong></td>
			<td align="right"><strong>#LSNumberFormat(GTAvaltot, ',9.00')#</td>
			<td align="right"><strong>#LSNumberFormat(GTAdepacumtot, ',9.00')#</td>
			<td align="right"><strong>#LSNumberFormat(GTAvallibros, ',9.00')#</td>

			<td align="right"><strong>#LSNumberFormat(GTAvalretiro, ',9.00')#</td>
			<td align="right"><strong>#LSNumberFormat(GTAgananciaperdida, ',9.00')#</td>
			<td>&nbsp;</td>
		</tr>
		</cfoutput>
	<cfelse>
		<tr><td colspan="11" align="center">--- No se encontraron registros ---</td></tr>
	</cfif>

	<tr><td>&nbsp;</td></tr>
	<tr><td colspan="11" align="center">--- Fin del Reporte ---</td></tr>
	<tr><td>&nbsp;</td></tr>	

</table>	

