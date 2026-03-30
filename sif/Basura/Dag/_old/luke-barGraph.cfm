<cffunction name="get_val" access="public" returntype="query">
	<cfargument name="valor" type="numeric" required="true" default="">
	<cfquery datasource="#Session.DSN#" name="rsget_val">
		select ltrim(rtrim(Pvalor)) as Pvalor from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#valor#">
	</cfquery>
	<cfreturn #rsget_val#>
</cffunction>
<cfset venc1 = Trim(get_val(310).Pvalor)>
<cfset venc2 = Trim(get_val(320).Pvalor)>
<cfset venc3 = Trim(get_val(330).Pvalor)>
<cfset venc4 = Trim(get_val(340).Pvalor)>
<cfset rsGrafico = QueryNew("Monto, Venc")>
<cfquery name="rs" datasource="#session.dsn#">
	select   isnull( 
					round( 
							sum(( 
									case b.CCTtipo  
											when 'D' then 1  
											when 'C' then -1  
									else 0 end) 
									*(PPprincipal + PPinteres)*Dtcultrev) 
					,2) 
				,0.00 ) as Monto
	from Documentos a 
	, CCTransacciones b 
	, PlanPagos c 
	where a.Ecodigo = 1
	and (PPprincipal + PPinteres) > 0 
	and (datediff(dd, PPfecha_vence, getdate())) <= 0 
	and SNcodigo in ( 
		select SNcodigo 
		from SNegocios 
		where Ecodigo = 1
		and SNtiposocio in ('A', 'C') 
	) 
	and Ocodigo in ( 
		select Ocodigo 
		from Oficinas 
		where Ecodigo = 1
	) 
	and a.Ecodigo = b.Ecodigo 
	and a.CCTcodigo = b.CCTcodigo 
	and a.Ddocumento = c.Ddocumento 
	and b.Ecodigo = c.Ecodigo 
	and b.CCTcodigo = c.CCTcodigo 
	and PPfecha_pago is null 
</cfquery>
<cfset QueryAddRow(rsGrafico,1)>
<cfset QuerySetCell(rsGrafico,'Monto',rs.Monto,rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Venc','Sin Vencer',rsGrafico.RECORDCOUNT)>
<cfquery name="rs" datasource="#session.dsn#">
	select  isnull( 
				round( 
							sum( 
									(case b.CCTtipo when 'D' then 1 when 'C' then -1 else 0 end) 
										*(PPprincipal + PPinteres)*Dtcultrev 
							) 
				,2) 
				,0.00)  as Monto
	from Documentos  a 
	, CCTransacciones  b 
	, PlanPagos  c 
	where a.Ecodigo = 1 
	and (PPprincipal + PPinteres) > 0 
	and (datediff(dd, PPfecha_vence, getdate())) between 1 and  30
	and SNcodigo in ( 
		select SNcodigo 
		from SNegocios 
		where Ecodigo = 1
		and SNtiposocio in ('A', 'C') 
	) 
	and Ocodigo in ( 
		select Ocodigo 
		from Oficinas 
		where Ecodigo = 1
	) 
	and a.Ecodigo = b.Ecodigo 
	and a.CCTcodigo = b.CCTcodigo 
	and a.Ddocumento = c.Ddocumento 
	and b.Ecodigo = c.Ecodigo 
	and b.CCTcodigo = c.CCTcodigo 
	and PPfecha_pago is null 
</cfquery>
<cfset QueryAddRow(rsGrafico,1)>
<cfset QuerySetCell(rsGrafico,'Monto',rs.Monto,rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Venc','1 - 30',rsGrafico.RECORDCOUNT)>
<cfquery name="rs" datasource="#session.dsn#">
	select   isnull( 
				round( 
							sum( 
									(case b.CCTtipo when 'D' then 1 when 'C' then -1 else 0 end) 
										*(PPprincipal + PPinteres)*Dtcultrev 
							) 
				,2) 
				,0.00) as Monto
	from Documentos  a 
	, CCTransacciones  b 
	, PlanPagos  c 
	where a.Ecodigo = 1
	and (PPprincipal + PPinteres) > 0 
	and (datediff(dd, PPfecha_vence, getdate())) between (30+1) and (60) 
	and SNcodigo in ( 
		select SNcodigo 
		from SNegocios 
		where Ecodigo = 1
		and SNtiposocio in ('A', 'C') 
	) 
	and Ocodigo in ( 
		select Ocodigo 
		from Oficinas 
		where Ecodigo = 1
	) 
	and a.Ecodigo = b.Ecodigo 
	and a.CCTcodigo = b.CCTcodigo 
	and a.Ddocumento = c.Ddocumento 
	and b.Ecodigo = c.Ecodigo 
	and b.CCTcodigo = c.CCTcodigo 
	and PPfecha_pago is null 
</cfquery>
<cfset QueryAddRow(rsGrafico,1)>
<cfset QuerySetCell(rsGrafico,'Monto',rs.Monto,rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Venc','31 - 60',rsGrafico.RECORDCOUNT)>
<cfquery name="rs" datasource="#session.dsn#">
	select  isnull( 
				round( 
							sum( 
									(case b.CCTtipo when 'D' then 1 when 'C' then -1 else 0 end) 
										*(PPprincipal + PPinteres)*Dtcultrev 
							) 
				,2) 
				,0.00) as Monto
	from Documentos  a 
	, CCTransacciones  b 
	, PlanPagos  c 
	where a.Ecodigo = 1
	and (PPprincipal + PPinteres) > 0 
	and (datediff(dd, PPfecha_vence, getdate())) between (60+1) and (90) 
	and SNcodigo in ( 
		select SNcodigo 
		from SNegocios 
		where Ecodigo = 1
		and SNtiposocio in ('A', 'C') 
	) 
	and Ocodigo in ( 
		select Ocodigo 
		from Oficinas 
		where Ecodigo = 1
	) 
	and a.Ecodigo = b.Ecodigo 
	and a.CCTcodigo = b.CCTcodigo 
	and a.Ddocumento = c.Ddocumento 
	and b.Ecodigo = c.Ecodigo 
	and b.CCTcodigo = c.CCTcodigo 
	and PPfecha_pago is null 
</cfquery>
<cfset QueryAddRow(rsGrafico,1)>
<cfset QuerySetCell(rsGrafico,'Monto',rs.Monto,rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Venc','61 - 90',rsGrafico.RECORDCOUNT)>
<cfquery name="rs" datasource="#session.dsn#">
	select  isnull( 
				round( 
							sum( 
									(case b.CCTtipo when 'D' then 1 when 'C' then -1 else 0 end) 
										*(PPprincipal + PPinteres)*Dtcultrev 
							) 
				,2) 
				,0.00) as Monto
	from Documentos  a 
	, CCTransacciones  b 
	, PlanPagos  c 
	where a.Ecodigo = 1
	and (PPprincipal + PPinteres) > 0 
	and (datediff(dd, PPfecha_vence, getdate())) between (90+1) and (120) 
	and SNcodigo in ( 
		select SNcodigo 
		from SNegocios 
		where Ecodigo = 1
		and SNtiposocio in ('A', 'C') 
	) 
	and Ocodigo in ( 
		select Ocodigo 
		from Oficinas 
		where Ecodigo = 1
	) 
	and a.Ecodigo = b.Ecodigo 
	and a.CCTcodigo = b.CCTcodigo 
	and a.Ddocumento = c.Ddocumento 
	and b.Ecodigo = c.Ecodigo 
	and b.CCTcodigo = c.CCTcodigo 
	and PPfecha_pago is null 
</cfquery>
<cfset QueryAddRow(rsGrafico,1)>
<cfset QuerySetCell(rsGrafico,'Monto',rs.Monto,rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Venc','91 - 120',rsGrafico.RECORDCOUNT)>
<cfquery name="rs" datasource="#session.dsn#">
	select  isnull( 
				round( 
							sum( 
									(case b.CCTtipo when 'D' then 1 when 'C' then -1 else 0 end) 
										*(PPprincipal + PPinteres)*Dtcultrev 
							) 
				,2) 
				,0.00) as Monto
	from Documentos  a 
	, CCTransacciones  b 
	, PlanPagos  c 
	where a.Ecodigo = 1
	and (PPprincipal + PPinteres) > 0 
	and (datediff(dd, PPfecha_vence, getdate())) > 120
	and SNcodigo in ( 
		select SNcodigo 
		from SNegocios 
		where Ecodigo = 1
		and SNtiposocio in ('A', 'C') 
	) 
	and Ocodigo in ( 
		select Ocodigo 
		from Oficinas 
		where Ecodigo = 1
	) 
	and a.Ecodigo = b.Ecodigo 
	and a.CCTcodigo = b.CCTcodigo 
	and a.Ddocumento = c.Ddocumento 
	and b.Ecodigo = c.Ecodigo 
	and b.CCTcodigo = c.CCTcodigo 
	and PPfecha_pago is null
</cfquery>
<cfset QueryAddRow(rsGrafico,1)>
<cfset QuerySetCell(rsGrafico,'Monto',rs.Monto,rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Venc','Mas de 120',rsGrafico.RECORDCOUNT)>
<cfquery name="rsValores" dbtype="query">
  select min(monto) as minimo, max(monto) as maximo from rsGrafico 
</cfquery>
<cfset minimo = 0>
<cfset maximo = #rsValores.maximo#>
<cfchart gridlines="5"
	 xaxistitle="Vencimiento en días" 
	 yaxistitle="Total por Vencimiento" 
	 scalefrom="#minimo#" 
	 scaleto="#maximo#" 
	 show3d="yes" 
	 showborder="no" 
	 showlegend="yes"
	 chartwidth="450"
	 url="/cfmx/sif/admin/Consultas/AntigSaldosDetCxC.cfm?venc=$ITEMLABEL$"> 
<cfchartseries 
	type="bar" 
	query="rsGrafico" 
	valuecolumn="monto" 
	serieslabel="" 
	itemcolumn="venc">
</cfchart>