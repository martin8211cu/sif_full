<cfsavecontent variable="myQuery">
	<cfoutput>
 		select 
			Aplaca as Placa, 
			Adescripcion as Activo, 
			(cat.ACcodigodesc) as Categoria, 
			(select clas.ACcodigodesc
			from AClasificacion clas
			where clas.ACcodigo=act.ACcodigo
			and clas.Ecodigo=act.Ecodigo
			and clas.ACid = act.ACid
			) as Clase, 
			
			({fn concat(cf1.CFcodigo, {fn concat('-', cf1.CFdescripcion)})}) as CFuncionalOrigen,
			
			(select {fn concat(cf2.CFcodigo, {fn concat('-', cf2.CFdescripcion)})} 
				from CFuncional cf2 
				where cf2.CFid = ta.CFiddest
			) as CFuncionalDestino, 
			
			TAfecha as Fecha, 
			TAvaladq + TAvalmej + TAvalrev as ValorTotal,
			TAdepacumadq + TAdepacummej + TAdepacumrev as DeprecicionAcumTotal,
			
			TAvaladq + TAvalmej + TAvalrev - 
			TAdepacumadq - TAdepacummej - TAdepacumrev as ValorLibros
			
		from TransaccionesActivos ta
			inner join Activos act
				on act.Ecodigo = ta.Ecodigo
				and act.Aid = ta.Aid
			inner join CFuncional cf1 
				on cf1.CFid = ta.CFid 
				and cf1.CFcodigo between '#url.CFcodigoinicio#' and '#url.CFcodigofinal#'
			inner join ACategoria cat
				on cat.ACcodigo=act.ACcodigo
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
		where ta.Ecodigo = #session.ecodigo#
			and ta.IDtrans = #url.IDtrans#
			and (TAperiodo > #url.PeriodoInicial#
				or  (TAperiodo = #url.PeriodoInicial#
				and TAmes >= #url.MesInicial#))
			and (TAperiodo < #url.PeriodoFinal# 
				or  (TAperiodo = #url.PeriodoFinal# 
				and TAmes <= #url.MesFinal#))
		order by CFuncionalOrigen, Aplaca
	</cfoutput>
</cfsavecontent>

<cftry>
	<cfflush interval="16000">
	<cf_jdbcquery_open name="data" datasource="#session.DSN#">
	<cfoutput>#myquery#</cfoutput>
	</cf_jdbcquery_open>
	
	<cfif isdefined("url.exportar")>
		<cf_exportQueryToFile query="#data#" separador="#chr(9)#" filename="Mov_Transferencia_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.txt" jdbc="true">
	</cfif>
	
	<cfset registros = 0 >

	<!--- totales generales --->
	<cfset GTAvaltot = 0 >
	<cfset GTAdepacumtot = 0 >
	<cfset GTAvallibros = 0 >
	
<table width="100%" border="0" cellpadding="2" cellspacing="0">
	 <tr style="padding:10px;">
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap">Placa</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap">Descripci&oacute;n</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap">Categor&iacute;a</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap">Clase</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap">Centro Funcional Origen</td>		
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap">Centro Funcional Destino</td>		
		
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap">Fecha</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap" align="right">Valor</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap" align="right">Dep. Acumulada</td>
		<td style="padding:3px;font-size:9px" bgcolor="#CCCCCC" nowrap="nowrap" align="right">Valor Libros</td>
	</tr>

	<cfoutput query="data" group="CFuncionalOrigen">
		<cfset registros = registros + 1 >
		<cfif registros neq 1 >
			<tr>
				<td colspan="7"><strong>Total Centro Funcional #trim(vCFuncionalOrigen)#</strong></td>
				<td align="right"><strong>#LSNumberFormat(CFTAvaltot, ',9.00')#</td>
				<td align="right"><strong>#LSNumberFormat(CFTAdepacumtot, ',9.00')#</td>
				<td align="right"><strong>#LSNumberFormat(CFTAvallibros, ',9.00')#</td>
			</tr>
			<tr><td>&nbsp;</td></tr>	
		</cfif>

		<cfset vCFuncionalOrigen = CFuncionalOrigen>
		<cfset CFTAvaltot = 0 >
		<cfset CFTAdepacumtot = 0 >
		<cfset CFTAvallibros = 0 >
		
		<tr><td class="tituloListas" colspan="10">#trim(CFuncionalOrigen)#</td></tr>
		<cfoutput>
			<tr>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#Placa#</td>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#Activo#</td>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#Categoria#</td>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#Clase#</td>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#CFuncionalOrigen#</td>
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#CFuncionalDestino#</td>
				
				<td nowrap="nowrap" style="padding:3px;font-size:9px">#LSDateFormat(Fecha)#</td>
				<td align="right" style="padding:3px;font-size:9px">#LSNumberFormat(ValorTotal, ',9.00')#</td>
				<td align="right" style="padding:3px;font-size:9px">#LSNumberFormat(DeprecicionAcumTotal, ',9.00')#</td>
				<td align="right" style="padding:3px;font-size:9px">#LSNumberFormat(ValorLibros, ',9.00')#</td>
			</tr>
			<cfset CFTAvaltot = CFTAvaltot + ValorTotal>
			<cfset CFTAdepacumtot = CFTAdepacumtot + DeprecicionAcumTotal>
			<cfset CFTAvallibros = CFTAvallibros + ValorLibros>
			
			<cfset GTAvaltot = GTAvaltot + ValorTotal>
			<cfset GTAdepacumtot = GTAdepacumtot + DeprecicionAcumTotal>
			<cfset GTAvallibros = GTAvallibros + ValorLibros>
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
			<td colspan="7"><strong>Total Centro Funcional #trim(vCFuncionalOrigen)#</strong></td>
			<td align="right"><strong>#LSNumberFormat(CFTAvaltot, ',9.00')#</td>
			<td align="right"><strong>#LSNumberFormat(CFTAdepacumtot, ',9.00')#</td>
			<td align="right"><strong>#LSNumberFormat(CFTAvallibros, ',9.00')#</td>
		</tr>
		<tr><td>&nbsp;</td></tr>	
	
		<tr>
			<td colspan="7"><strong>Total General</strong></td>
			<td align="right"><strong>#LSNumberFormat(GTAvaltot, ',9.00')#</td>
			<td align="right"><strong>#LSNumberFormat(GTAdepacumtot, ',9.00')#</td>
			<td align="right"><strong>#LSNumberFormat(GTAvallibros, ',9.00')#</td>
		</tr>
		</cfoutput>
	<cfelse>
		<tr><td colspan="10" align="center">--- No se encontraron registros ---</td></tr>
	</cfif>

	<tr><td>&nbsp;</td></tr>
	<tr><td colspan="10" align="center">--- Fin del Reporte ---</td></tr>
	<tr><td>&nbsp;</td></tr>	

</table>	

