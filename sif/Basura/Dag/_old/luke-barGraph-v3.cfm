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
<cfquery name="rsGraficoBar" datasource="#session.dsn#">
	select d.Mcodigo, m.Mnombre, 
		 sum(case when datediff(dd, d.Dvencimiento, getdate()) < 0
			  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then $1.00 else -$1.00  end * d.Dtcultrev
			) as SinVencer,
		 sum(case when
			  datediff(dd, d.Dvencimiento, getdate()) between 0 and 30
			  and datepart(mm, d.Dvencimiento) = datepart (mm, getdate())
			  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then $1.00 else -$1.00 end * d.Dtcultrev
			) as Corriente,
		 sum(case when
			  datediff(dd, d.Dvencimiento, getdate()) between 0 and 30
			  and datepart(mm, d.Dvencimiento) <> datepart (mm, getdate())
			  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then $1.00 else -$1.00 end * d.Dtcultrev
			) as P1,
		 sum(case when
			  datediff(dd, d.Dvencimiento, getdate()) between 31 and 60
			  and datepart(mm, d.Dvencimiento) <> datepart (mm, getdate())
			  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then $1.00 else -$1.00 end * d.Dtcultrev
			) as P2,
		 sum(case when
			  datediff(dd, d.Dvencimiento, getdate()) between 61 and 90
			  and datepart(mm, d.Dvencimiento) <> datepart (mm, getdate())
			  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then $1.00 else -$1.00 end * d.Dtcultrev
			) as P3,
		 sum(case when
			  datediff(dd, d.Dvencimiento, getdate()) between 91 and 120
			  and datepart(mm, d.Dvencimiento) <> datepart (mm, getdate())
			  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then $1.00 else -$1.00 end * d.Dtcultrev
			) as P4,
		 sum(case when
			  datediff(dd, d.Dvencimiento, getdate()) > 120
			  and datepart(mm, d.Dvencimiento) <> datepart (mm, getdate())
			  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then $1.00 else -$1.00 end * d.Dtcultrev
			) as P5,
		 sum(case when
			  datediff(dd, d.Dvencimiento, getdate()) >= 0
			  and datepart(mm, d.Dvencimiento) <> datepart (mm, getdate())
			  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then $1.00 else -$1.00 end * d.Dtcultrev
			) as Morosidad
	from
		 Documentos d,
		 CCTransacciones t,
		 Monedas m
	where d.Ecodigo = 1
		  and d.Dsaldo <> 0.00
		  ---and d.Ocodigo = 4
		  and t.CCTcodigo = d.CCTcodigo
		  and t.Ecodigo = d.Ecodigo
		  and m.Mcodigo = d.Mcodigo
		  and m.Ecodigo = d.Ecodigo
	Group By d.Mcodigo, m.Mnombre
</cfquery>
<cfset montos_str = ''>
<cfoutput query="rsGraficoBar" group="Mcodigo">
	<cfset montos_str = montos_str & iif(len(montos_str),DE(', '),DE('')) & 'Monto#currentrow#'>
</cfoutput>
<cfset rsGrafico = QueryNew("#montos_str#, Venc")>
<cfset QueryAddRow(rsGrafico,7)>
<cfset QuerySetCell(rsGrafico,'Venc','Sin Vencer',1)>
<cfset QuerySetCell(rsGrafico,'Venc','Corriente',2)>
<cfset QuerySetCell(rsGrafico,'Venc','1 - #Venc1#',3)>
<cfset QuerySetCell(rsGrafico,'Venc','#Venc1+1# - #Venc2#',4)>
<cfset QuerySetCell(rsGrafico,'Venc','#Venc2+1# - #Venc3#',5)>
<cfset QuerySetCell(rsGrafico,'Venc','#Venc3+1# - #Venc4#',6)>
<cfset QuerySetCell(rsGrafico,'Venc','Mas de #Venc4#',7)>
<cfoutput query="rsGraficoBar" group="Mcodigo">
	<cfset QuerySetCell(rsGrafico,'Monto#currentrow#',rsGraficoBar.SinVencer,rsGraficoBar.currentrow)>
	<cfset QuerySetCell(rsGrafico,'Monto#currentrow#',rsGraficoBar.Corriente,rsGraficoBar.currentrow)>
	<cfset QuerySetCell(rsGrafico,'Monto#currentrow#',rsGraficoBar.P1,rsGraficoBar.currentrow)>
	<cfset QuerySetCell(rsGrafico,'Monto#currentrow#',rsGraficoBar.P2,rsGraficoBar.currentrow)>
	<cfset QuerySetCell(rsGrafico,'Monto#currentrow#',rsGraficoBar.P3,rsGraficoBar.currentrow)>
	<cfset QuerySetCell(rsGrafico,'Monto#currentrow#',rsGraficoBar.P4,rsGraficoBar.currentrow)>
	<cfset QuerySetCell(rsGrafico,'Monto#currentrow#',rsGraficoBar.P5,rsGraficoBar.currentrow)>
</cfoutput>
<cfquery name="rsValores" dbtype="query">
  select min(monto1) as minimo, max(monto1) as maximo from rsGrafico 
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
<cfoutput query="rsGraficoBar" group="Mcodigo">
	<cfchartseries 
		type="bar" 
		query="rsGrafico" 
		valuecolumn="monto#currentrow#" 
		serieslabel="#Mnombre#" 
		itemcolumn="venc">
	</cfoutput>
</cfchart>