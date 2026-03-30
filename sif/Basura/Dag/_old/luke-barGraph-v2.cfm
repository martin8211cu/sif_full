<cfset venc1 = Trim(get_val(310).Pvalor)>
<cfset venc2 = Trim(get_val(320).Pvalor)>
<cfset venc3 = Trim(get_val(330).Pvalor)>
<cfset venc4 = Trim(get_val(340).Pvalor)>

<cfquery name="rsGraficoBar" datasource="#session.dsn#">
	select
		 coalesce(sum(case when datediff(dd, d.Dvencimiento, getdate()) < 0
			  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then $1.00 else -$1.00  end * d.Dtcultrev
			),00) as SinVencer,
		 coalesce(sum(case when
			  datediff(dd, d.Dvencimiento, getdate()) between 0 and <cfqueryparam cfsqltype="cf_sql_integer" value="#venc1#">
			  and datepart(mm, d.Dvencimiento) = datepart (mm, getdate())
			  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then $1.00 else -$1.00 end * d.Dtcultrev
			),00) as Corriente,
		 coalesce(sum(case when
			  datediff(dd, d.Dvencimiento, getdate()) between 0 and <cfqueryparam cfsqltype="cf_sql_integer" value="#venc1#">
			  and datepart(mm, d.Dvencimiento) <> datepart (mm, getdate())
			  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then $1.00 else -$1.00 end * d.Dtcultrev
			),00) as P1,
		 coalesce(sum(case when
			  datediff(dd, d.Dvencimiento, getdate()) between <cfqueryparam cfsqltype="cf_sql_integer" value="#venc1+1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#venc2#">
			  and datepart(mm, d.Dvencimiento) <> datepart (mm, getdate())
			  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then $1.00 else -$1.00 end * d.Dtcultrev
			),00) as P2,
		 coalesce(sum(case when
			  datediff(dd, d.Dvencimiento, getdate()) between <cfqueryparam cfsqltype="cf_sql_integer" value="#venc2+1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#venc3#">
			  and datepart(mm, d.Dvencimiento) <> datepart (mm, getdate())
			  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then $1.00 else -$1.00 end * d.Dtcultrev
			),00) as P3,
		 coalesce(sum(case when
			  datediff(dd, d.Dvencimiento, getdate()) between <cfqueryparam cfsqltype="cf_sql_integer" value="#venc3+1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#venc4#">
			  and datepart(mm, d.Dvencimiento) <> datepart (mm, getdate())
			  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then $1.00 else -$1.00 end * d.Dtcultrev
			),00) as P4,
		 coalesce(sum(case when
			  datediff(dd, d.Dvencimiento, getdate()) > <cfqueryparam cfsqltype="cf_sql_integer" value="#venc4#">
			  and datepart(mm, d.Dvencimiento) <> datepart (mm, getdate())
			  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then $1.00 else -$1.00 end * d.Dtcultrev
			),00) as P5,
		 coalesce(sum(case when
			  datediff(dd, d.Dvencimiento, getdate()) >= 0
			  and datepart(mm, d.Dvencimiento) <> datepart (mm, getdate())
			  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then $1.00 else -$1.00 end * d.Dtcultrev
			),00) as Morosidad
	from
		 Documentos d,
		 CCTransacciones t
	where d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and d.Dsaldo <> 0.00
		  <cfif isdefined("form.Ocodigo")>
			  and d.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
		  </cfif>
		  and t.CCTcodigo = d.CCTcodigo
		  and t.Ecodigo = d.Ecodigo
</cfquery>

<cfset rsGrafico = QueryNew("Monto, Venc")>
<cfset QueryAddRow(rsGrafico,1)>
<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar.SinVencer,rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Venc','Sin Vencer',rsGrafico.RECORDCOUNT)>
<cfset QueryAddRow(rsGrafico,1)>
<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar.Corriente,rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Venc','Corriente',rsGrafico.RECORDCOUNT)>
<cfset QueryAddRow(rsGrafico,1)>
<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar.P1,rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Venc','1 - #Venc1#',rsGrafico.RECORDCOUNT)>
<cfset QueryAddRow(rsGrafico,1)>
<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar.P2,rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Venc','#Venc1+1# - #Venc2#',rsGrafico.RECORDCOUNT)>
<cfset QueryAddRow(rsGrafico,1)>
<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar.P3,rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Venc','#Venc2+1# - #Venc3#',rsGrafico.RECORDCOUNT)>
<cfset QueryAddRow(rsGrafico,1)>
<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar.P4,rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Venc','#Venc3+1# - #Venc4#',rsGrafico.RECORDCOUNT)>
<cfset QueryAddRow(rsGrafico,1)>
<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar.P5,rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Venc','Mas de #Venc4#',rsGrafico.RECORDCOUNT)>

<cfif rsGrafico.recordcount>
	<cfquery name="rsValores" dbtype="query">
	  select min(monto) as minimo, max(monto) as maximo from rsGrafico 
	</cfquery>
	
	<cfset minimo = rsValores.minimo>
	<cfset maximo = rsValores.maximo>

<cfchart
	format = "flash"
	chartWidth = "450" 
	chartheight="250"
	scaleFrom = "0"
	scaleTo = "0"
	showXGridlines = "yes"
	showYGridlines = "yes"
	gridlines = "5"
	seriesPlacement = "stacked"
	showBorder = "no"
	font = "Arial"
	fontSize = "10"
	fontBold = "no"
	fontItalic = "no"
	labelFormat = "currency"
	xAxisTitle = "Vencimiento en Días"
	yAxisTitle = "Monto Vencimiento"
	sortXAxis = "no"
	show3D = "yes"
	rotated = "no"
	showLegend = "yes"
	tipStyle = "MouseOver"
	showMarkers = "yes"
	markerSize = "50"
	url = "/cfmx/sif/admin/Consultas/AntigSaldosDetCxC.cfm?venc=$ITEMLABEL$">

			<cfchartseries 
				type="bar" 
				query="rsGrafico" 
				valuecolumn="monto" 
				itemcolumn="venc"
				colorlist="##99CCFF,##FFCCCC,##99FFCC,##FFFFCC,##DCCCE6,##FFFF99,##CCCCFF">

	
</cfchart>
<cfelse>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="Ayuda">
	  <tr>
		<th scope="col"> *** No se encontraron datos para realizar el Gr&aacute;fico *** </th>
	  </tr>
	</table>
</cfif>

<cffunction name="get_val" access="public" returntype="query">
	<cfargument name="valor" type="numeric" required="true" default="">
		<cfquery datasource="#Session.DSN#" name="rsget_val">
			select ltrim(rtrim(Pvalor)) as Pvalor from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#valor#">
		</cfquery>
	<cfreturn #rsget_val#>
</cffunction>