<cfsavecontent variable="myQuery">
	<cfoutput>
	select 	cf.CFcodigo as Codigo_CentroF, 
		   	cf.CFdescripcion as Descripcion_CentroF, 
			a.Aserie as serie,
			a.Aplaca as placa,
			a.Adescripcion as activoDesc,
			a.SNcodigo as socio,
			sn.SNnombre,
			m.AFMcodigo as marca,
			m.AFMdescripcion as marcaDesc,
			mo.AFMMcodigo as modelo,
			mo.AFMMdescripcion as modeloDesc,
			adq.EAcpdoc as factura,	
			ta.TAfecha as fecha,
			case when ta.TAfechainidep is not null then 
			<cf_dbfunction name="dateadd"	args="coalesce(a.Avutil,0);ta.TAfechainidep; MM" delimiters=";">else ta.TAfechainidep end as FechaFinDep,
			coalesce(a.Avutil,0) as vidaUtil,
			ta.TAmontolocadq as monto
	
	from TransaccionesActivos ta
	
	inner join Activos a
	on a.Aid=ta.Aid
	and a.Ecodigo=ta.Ecodigo
	
	inner join CFuncional cf
	on cf.CFid=ta.CFid
	and cf.CFcodigo between '#url.CFcodigoinicio#' and '#url.CFcodigofinal#'
	
	left join SNegocios sn
	on sn.SNcodigo=a.SNcodigo
	and sn.Ecodigo=a.Ecodigo
	
	inner join AFMarcas m
	on m.AFMid=a.AFMid
	
	inner join AFMModelos mo
	on mo.AFMMid=a.AFMMid
	
	inner join ACategoria c
	on c.ACcodigo=a.ACcodigo
	and c.Ecodigo=a.Ecodigo
	and c.ACcodigo between #url.codigodesde# and #url.codigohasta#
	
	left join DSActivosAdq adq
	on adq.lin=a.Areflin
	
	where ta.IDtrans = #url.IDtrans#
	  and ta.Ecodigo = #session.Ecodigo#
	  and (TAperiodo > #url.PeriodoInicial#
				or  (TAperiodo = #url.PeriodoInicial#
				and TAmes >= #url.MesInicial#))
			and (TAperiodo < #url.PeriodoFinal# 
				or  (TAperiodo = #url.PeriodoFinal# 
				and TAmes <= #url.MesFinal#))
	order by cf.CFcodigo
	</cfoutput>
</cfsavecontent>


<cftry>
	<cfflush interval="16000">
	<cf_jdbcquery_open name="data" datasource="#session.DSN#">
	<cfoutput>#myquery#</cfoutput>
	</cf_jdbcquery_open>
	
	<cfif isdefined("url.exportar")>
		<cf_exportQueryToFile query="#data#" separador="#chr(9)#" filename="Mov_Adq_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.txt" jdbc="true">
	</cfif>

		<cfset total_general = 0 >
		<cfset total = 0 >
		<cfset registros = 0 >
		<cfset vCFcodigo = 0 >
		
<br>
<table width="100%" cellpadding="3" cellspacing="0">
	<tr style="padding:10px;">
		<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap"><strong>Placa</strong></td>
		<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap"><strong>Descripci&oacute;n</strong></td>
		<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap"><strong>Proveedor</strong></td>
		<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap"><strong>Marca</strong></td>
		<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap"><strong>Modelo</strong></td>
		<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap"><strong>Serie</strong></td>
		<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap"><strong>Factura</strong></td>
		<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap"><strong>Fecha Compra</strong></td>
		<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap"><strong>Fecha Depr.</strong></td>
		<td style="padding:3px;" bgcolor="#CCCCCC" align="right" nowrap="nowrap"><strong>Vida Util</strong></td>
		<td style="padding:3px;" bgcolor="#CCCCCC" align="right" nowrap="nowrap"><strong>Valor Original</strong></td>
	</tr>
		
		<cfoutput query="data" group="Codigo_CentroF">
			<cfset registros = registros + 1 >
			<cfif registros neq 1 >
				<tr>
					<td colspan="5"><strong>Total Centro Funcional #trim(vCFcodigo)#</strong></td>
					<td align="right" colspan="6"><strong>#LSNumberFormat(total, ',9.00')#</td>
				</tr>
				<tr><td>&nbsp;</td></tr>	
			</cfif>
			<cfset vCFcodigo = Codigo_CentroF >
			<cfset total = 0 >
			<tr><td class="tituloListas" colspan="11">#trim(Codigo_CentroF)# - #Descripcion_CentroF#</td></tr>

			<cfoutput>
				<tr>
					<td nowrap="nowrap">#placa#</td>
					<td >#activoDesc#</td>
					<td nowrap="nowrap">#trim(socio)#-#SNnombre#</td>
					<td nowrap="nowrap">#marca#</td>
					<td nowrap="nowrap">#modelo#</td>
					<td nowrap="nowrap">#serie#</td>
					<td nowrap="nowrap">#factura#</td>
					<td nowrap="nowrap">#LSDateFormat(fecha,'dd/mm/yyyy')#</td>
					<td nowrap="nowrap"><cfif len(trim(FechaFinDep))>#LSdateFormat(FechaFinDep,'dd/mm/yyyy')#</cfif></td>
					<td nowrap="nowrap" align="right">#vidaUtil#</td>
					<td nowrap="nowrap" align="right">#LSNumberFormat(monto, ',9.00')#</td>
				</tr>
				<cfset total = total + monto >
				<cfset total_general = total_general + monto >
			</cfoutput>
		</cfoutput>
		
		<!--- PINTA EL TOTAL DEL ULTIMO CENTRO FUNCIONAL --->
		<cfoutput>
		<cfif registros gt 0>
			<tr>
				<td colspan="5" ><strong>Total Centro Funcional #trim(vCFcodigo)#</strong></td>
				<td align="right" colspan="6"><strong>#LSNumberFormat(total, ',9.00')#</strong></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="5" ><strong>Total General</strong></td>
				<td align="right" colspan="6"><strong>#LSNumberFormat(total_general, ',9.00')#</strong></td>
			</tr>
		<cfelse>
			<tr><td colspan="11" align="center">--- No se encontraron registros ---</td></tr>
		</cfif>
		</cfoutput>		
<cfcatch type="any">
	<cf_jdbcquery_close>
	<cfrethrow>
</cfcatch>
</cftry>
	<cf_jdbcquery_close>
	<tr><td colspan="11" align="center">--- Fin del Reporte ---</td></tr>
</table>

