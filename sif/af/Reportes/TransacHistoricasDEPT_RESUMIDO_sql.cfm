<!--- 
	Creado por Gustavo Fonseca H / DorianA.
		Motivo: Nueva consulta para exportación a Excel del módulo de Activos Fijos.
		Fecha:16-5-2006.
 --->

<!--- Centros Funcionales --->
<cfif not isdefined("url.CFcodigoInicio")>
	<cfset centroini = false>
<cfelse>	
	<cfif url.CFcodigoInicio eq "">
		<cfset centroini = false>
	<cfelse>
		<cfset centroini = true>			
	</cfif>
</cfif>
<cfif not isdefined("url.CFcodigofinal")>
	<cfset centrofin = false>
<cfelse>	
	<cfif url.CFcodigoInicio eq "">
		<cfset centrofin = false>
	<cfelse>
		<cfset centrofin = true>			
	</cfif>
</cfif>			

<!--- Oficinas --->
<cfif not isdefined("url.OficinaIni")>
	<cfset oficinaini = false>
<cfelse>	
	<cfif url.OficinaIni eq "">
		<cfset oficinaini = false>
	<cfelse>
		<cfset oficinaini = true>			
	</cfif>
</cfif>
<cfif not isdefined("url.OficinaFin")>
	<cfset oficinafin = false>
<cfelse>	
	<cfif url.OficinaFin eq "">
		<cfset oficinafin = false>
	<cfelse>
		<cfset oficinafin = true>			
	</cfif>
</cfif>	

<cfsavecontent variable="myQuery">
	<cfoutput>
	<!--- Activos Depreciados Totalmente en un rango de meses --->
	select 
		{fn concat( {fn concat (c.ACcodigodesc, ' - ')} , c.ACdescripcion)} as Categoria, 
		{fn concat( {fn concat (d.CFcodigo , ' - ')}, min(d.CFdescripcion) )} as CentroF, 
		sum(coalesce(e.AFSvaladq + e.AFSvalmej + e.AFSvalrev,0.00)) as Valor, 
		sum(coalesce(e.AFSdepacumadq + e.AFSdepacummej + e.AFSdepacumrev,0.00)) as DepreciacionAcum
	from TransaccionesActivos a
		inner join Activos b
			inner join ACategoria c
			on c.Ecodigo = b.Ecodigo
			and c.ACcodigo = b.ACcodigo
			and c.ACcodigo between #url.codigodesde# and #url.codigohasta#
			inner join AClasificacion cl
				 on cl.Ecodigo = b.Ecodigo
				and cl.ACcodigo = b.ACcodigo
				and cl.ACid = b.ACid
		on b.Ecodigo = a.Ecodigo
		and b.Aid = a.Aid
		inner join CFuncional d
			on d.CFid = a.CFid
			<cfif centroini and not centrofin > 
				and d.CFcodigo >= '#url.CFcodigoInicio#'
			<cfelseif not centroini and centrofin >
				and d.CFcodigo <= '#url.CFcodigofinal#'				
			<cfelseif centroini and centrofin >
				and d.CFcodigo between '#url.CFcodigoInicio#'  and '#url.CFcodigofinal#'
			</cfif>
						
			<cfif oficinaini and not oficinafin > 
				and d.Ocodigo >= #url.OficinaIni#
			<cfelseif not oficinaini and oficinafin >
				and d.Ocodigo <= #url.OficinaFin#
			<cfelseif oficinaini and oficinafin >
				and d.Ocodigo between #url.OficinaIni#  and #url.OficinaFin#
			</cfif>				
		
		inner join AFSaldos e
		on e.Ecodigo = a.Ecodigo
		and e.AFSperiodo = a.TAperiodo
		and e.AFSmes = a.TAmes
		and e.Aid = a.Aid
		and e.AFSvaladq - b.Avalrescate - e.AFSdepacumadq = 0.00
		and e.AFSvalmej - e.AFSdepacummej = 0.00
		and e.AFSvalrev - e.AFSdepacumrev = 0.00
	where a.IDtrans = 4  
	and a.Ecodigo = #session.Ecodigo#
	and a.TAperiodo = <cf_dbfunction name="to_number" args="#url.periodoInicial#"> 
	and a.TAmes	between <cf_dbfunction name="to_number" args="#url.mesInicial#">
	and <cf_dbfunction name="to_number" args="#url.mesfinal#">
	group by c.ACcodigodesc ,c.ACdescripcion, d.CFcodigo, d.CFdescripcion
 	order by 1
	</cfoutput>
</cfsavecontent>

<cftry>
	<cfflush interval="128">
	<cf_jdbcquery_open name="data" datasource="#session.DSN#">
	<cfoutput>#myquery#</cfoutput>
	</cf_jdbcquery_open>

	<cfif isdefined("url.Formato") and url.Formato eq 2>
		<cf_exportQueryToFile query="#data#" filename="Depreciacion_Tot_Res_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls" jdbc="true">
	<cfelseif isdefined("url.Formato") and url.Formato eq 3>
		<cf_exportQueryToFile query="#data#" separador="#chr(9)#" filename="Depreciacion_Tot_Res_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.txt" jdbc="true">
	</cfif>

<table width="70%" cellpadding="2" cellspacing="0" border="0" align="center">
	<cfoutput query="data" group="Categoria">
	<cfset totalValorCat = 0>
	<cfset totalDepCat = 0>
	<cfset totalDepCF = 0>
		<tr>
			<td><strong>Categor&iacute;a:&nbsp;</strong>#Categoria#</td>
		</tr>	
			<tr style="padding:10px;">
				<td style="padding:3px;" bgcolor="CCCCCC" nowrap="nowrap"><strong>Centro&nbsp;Funcional</strong></td>
				<td style="padding:3px;" bgcolor="CCCCCC" nowrap="nowrap"><strong>Valor</strong></td>
				<td style="padding:3px;" bgcolor="CCCCCC" nowrap="nowrap"><strong>Depreciación Acumulada</strong></td>
			</tr>
			<cfoutput>
				<tr>
					<td>#CentroF#</td>
					<td>#NumberFormat(Valor, ",_.__")#</td>
					<td>#NumberFormat(DepreciacionAcum, ",_.__")#</td>
					<cfset totalValorCat = totalValorCat + Valor>
					<cfset totalDepCat = totalDepCat + DepreciacionAcum>
				</tr>
			</cfoutput>
				<tr>
					<td align="right"><strong>Total Categor&iacute;a #Categoria#:&nbsp;</strong></td>
					<td>#NumberFormat(totalValorCat, ",_.__")#</td>
					<td>#NumberFormat(totalDepCat, ",_.__")#</td>
				</tr>
		</cfoutput>
<cfcatch type="any">
	<cf_jdbcquery_close>
	<cfrethrow>
</cfcatch>
</cftry>
	<cf_jdbcquery_close>
</table>	

