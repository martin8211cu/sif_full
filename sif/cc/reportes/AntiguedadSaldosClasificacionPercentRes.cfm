<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Cartera = t.Translate('LB_Cartera','Cartera de Clientes Al')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo')>
<cfset LB_Clas = t.Translate('LB_Clas','Clasificación')>

<!--- <cfdump var="#url#">
<cf_dump var="#form#"> --->

<cfif isdefined("url.DEidCobrador") and not isdefined("form.DEidCobrador")>
	<cfset form.DEidCobrador = url.DEidCobrador>
</cfif>
<cfif isdefined("url.SNCEid") and not isdefined("form.SNCEid")>
	<cfset form.SNCEid = url.SNCEid>
</cfif>
<cfif isdefined("url.SNnumerob2") and not isdefined("form.SNnumerob2")>
	<cfset form.SNnumerob2 = url.SNnumerob2>
</cfif>
<cfif isdefined("url.SNnumero") and not isdefined("form.SNnumero")>
	<cfset form.SNnumero = url.SNnumero>
</cfif>
<cfif isdefined("url.Oficodigo2") and not isdefined("form.Oficodigo2")>
	<cfset form.Oficodigo2 = url.Oficodigo2>
</cfif>
<cfif isdefined("url.Oficodigo") and not isdefined("form.Oficodigo")>
	<cfset form.Oficodigo = url.Oficodigo>
</cfif>

<cfif isdefined("form.SNCEid") and len(form.SNCEid)  gt 0>
	<cfquery name="rsSNCEid" datasource="#session.DSN#" >
		select SNCEdescripcion
		from SNClasificacionE
		where SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCEid#"> 
	</cfquery>
</cfif>

<cfquery name="rsReporte" datasource="#session.DSN#" >
select distinct
	r.SNid,
	r.SNnombre Socio,
	r.Saldo,	PorcentajeSaldo = ((r.Saldo * 100)/total.TSaldo),
	r.P1 as PrimerVencimiento,
	PorcentajePrimerVencimiento = case when total.TSaldo = 0 then 0 else ((r.P1 * 100) / total.TSaldo) end,
	r.P2 as SegundoVencimiento,
	PorcentajeSegundoVencimiento = case when total.TSaldo = 0 then 0 else ((r.P2 * 100) / total.TSaldo) end,
	r.P3 as TerceroVencimiento,
	PorcentajeTerceroVencimiento = case when total.TSaldo = 0 then 0 else ((r.P3 * 100) / total.TSaldo) end,
	r.P4 as CuartoVencimiento,
	PorcentajeCuartoVencimiento = case when total.TSaldo = 0 then 0 else ((r.P4 * 100) / total.TSaldo) end,
	r.P5 as QuintoVencimiento,
	PorcentajeQuintoVencimiento = case when total.TSaldo = 0 then 0 else ((r.P5 * 100) / total.TSaldo) end,
	r.Mnombre Moneda,
	r.Mcodigo,
	r.Morosidad Vencido,
   
	PorcentajeVencido = (r.Morosidad*100/TMorosidad)
from (
	select 
		 s.Ecodigo Ecodigo,
		 s.SNid,
  		 min(ec.SNCEid) as SNCEid,
		 min(ec.SNCEcodigo) as SNCEcodigo,
		 min(ec.SNCEdescripcion) as SNCEdescripcion,
		 m.Mnombre,min(d.Mcodigo) as Mcodigo,
		 min(dc.SNCDvalor) as SNCDvalor,
		 min(dc.SNCDid) as SNCDid,
		 min(dc.SNCDdescripcion) as SNCDdescripcion,
		 min(s.SNnombre) as SNnombre,
		 min(s.SNnumero) as SNnumero,
		 sum(d.Dtotal * case when t.CCTtipo = 'D' then  1.00 else -  1.00 end) as Total,
		 sum(d.Dsaldo * case when t.CCTtipo = 'D' then  1.00 else -  1.00 end) as Saldo,
		 sum(CASE
				   WHEN d.Dvencimiento >= getdate()
						AND datepart(mm, d.Dfecha) = datepart(mm, convert(datetime, getdate(), 111)) THEN Dsaldo
				   ELSE 0.00
			   END * CASE
					   WHEN t.CCTtipo = 'D' THEN 1.00
					   ELSE - 1.00
				   END) AS Corriente,

		 sum(CASE
				   WHEN d.Dvencimiento >= getdate()
						AND datepart(mm, d.Dfecha) <> datepart(mm, convert(datetime, getdate(), 111)) THEN Dsaldo
				   ELSE 0.00
			   END * CASE
					   WHEN t.CCTtipo = 'D' THEN 1.00
					   ELSE - 1.00
				   END) AS SinVencer,
		 sum(case when
		  		datediff(dd, d.Dfecha, convert(datetime, getdate(), 111))
				between 0 and 14 + 1 /*1er Vencimiento*/
			  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then  1.00 else - 1.00 end)
			  as P1,
		 sum(case when
			  datediff(dd, d.Dfecha, convert(datetime, getdate(), 111))
				between 15 + 1 /*1er Vencimiento*/ and 30/*2do Vencimiento*/
			  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then  1.00 else - 1.00 end)
			  as P2,
		 sum(case when
			   datediff(dd, d.Dfecha, convert(datetime, getdate(), 111))
				between 30 + 1 /*2do Vencimiento*/ and 60 + 1 /*3er Vencimiento*/
			  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then  1.00 else - 1.00 end)
			  as P3,
		 sum(case when
			 datediff(dd, d.Dfecha, convert(datetime, getdate(), 111))
		  		between 60 + 1 /*3er Vencimiento*/ and 90 + 1 /*4to Vencimiento*/
			  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then  1.00 else - 1.00 end)
			  as P4,
		 sum(case 
			  WHEN datediff(dd, d.Dfecha, convert(datetime, getdate(), 111)) >= 90 + 1 /*4to Vencimiento*/
			  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then  1.00 else - 1.00 end)
			  as P5, 
		 sum(case when
				dateadd(day, isnull(s.SNvenventas,0) ,d.Dfecha) <  getdate()
			  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then  1.00 else - 1.00 end)
			  as Morosidad
	from SNClasificacionE ec
	inner join SNClasificacionD dc
	inner join SNClasificacionSN cs
	inner join SNegocios s
	inner join Documentos d on d.Ecodigo = s.Ecodigo
		AND d.SNcodigo = s.SNcodigo ON cs.SNid = s.SNid ON cs.SNCDid = dc.SNCDid ON dc.SNCEid = ec.SNCEid
	inner join Monedas m on m.Mcodigo = d.Mcodigo and m.Ecodigo = d.Ecodigo
	inner join CCTransacciones t on t.CCTcodigo = d.CCTcodigo
		and t.Ecodigo = d.Ecodigo
	inner join Oficinas o on o.Ecodigo= d.Ecodigo
		and o.Ocodigo = d.Ocodigo
	 where ec.Ecodigo IS NULL
 		and s.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
 		<cfif isdefined("form.DEidCobrador") and len(trim(form.DEidCobrador))>
		  and s.DEidCobrador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEidCobrador#">
		</cfif>
		<!--- Clasificacion --->
		<cfif isdefined("form.SNCEid") and len(form.SNCEid)  gt 0>
		and ec.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCEid#">
		</cfif>
		<!--- Socio de negocios --->
		<cfif isdefined("form.SNnumero") and len(trim(form.SNnumero)) and isdefined("form.SNnumerob2") and len(trim(form.SNnumerob2))>
			<cfif form.SNnumero gt form.SNnumerob2><!--- si el primero es mayor que el segundo. --->
					and s.SNnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumerob2#">
										and <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumero#">
			<cfelse>
					and s.SNnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumero#">
										and <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumerob2#">
			</cfif>
		<cfelseif isdefined("form.SNnumero") and len(trim(form.SNnumero))>
			and s.SNnumero >= <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumero#">
		<cfelseif isdefined("form.SNnumerob2") and len(trim(form.SNnumerob2))>
			and s.SNnumero <= <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumerob2#">
		</cfif>
		<!--- Oficina --->
		<cfif isdefined("form.Oficodigo") and len(trim(form.Oficodigo)) and isdefined("form.Oficodigo2") and len(trim(form.Oficodigo2))>
			<cfif form.Oficodigo gt form.Oficodigo2>
				and o.Oficodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#form.Oficodigo2#">
								  and <cfqueryparam cfsqltype="cf_sql_char" value="#form.Oficodigo#">
			<cfelse>
				and o.Oficodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#form.Oficodigo#">
								  and <cfqueryparam cfsqltype="cf_sql_char" value="#form.Oficodigo2#">
			</cfif>
		<cfelseif isdefined("form.Oficodigo") and len(trim(form.Oficodigo))>
			and o.Oficodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#form.Oficodigo#">
		<cfelseif isdefined("form.Oficodigo2") and len(trim(form.Oficodigo2))>
			and o.Oficodigo <=  <cfqueryparam cfsqltype="cf_sql_char" value="#form.Oficodigo2#">
		</cfif>
		and d.Dsaldo <> 0.00
		group by  s.Ecodigo, s.SNid, m.Mnombre, ec.SNCEid, dc.SNCDid, s.SNcodigo
) r
inner join (
	select 
		Ecodigo, 
		sum(Total) TTotal, sum(Saldo) TSaldo, sum(Corriente) TCorriente, sum(SinVencer) TSinVencer,
		sum(P1) TP1, sum(P2) TP2, sum(P3) TP3, sum(P4) TP4, sum(P5) TP5, sum(Morosidad) TMorosidad
	from (
		select
			 s.Ecodigo,
  			 min(ec.SNCEid) as SNCEid,
			 min(ec.SNCEcodigo) as SNCEcodigo,
			 min(ec.SNCEdescripcion) as SNCEdescripcion,
			 m.Mnombre,min(d.Mcodigo) as Mcodigo,
			 min(dc.SNCDvalor) as SNCDvalor,
			 min(dc.SNCDid) as SNCDid,
			 min(dc.SNCDdescripcion) as SNCDdescripcion,
			 min(s.SNnombre) as SNnombre,
			 min(s.SNnumero) as SNnumero,
			 sum(d.Dtotal * case when t.CCTtipo = 'D' then  1.00 else -  1.00 end) as Total,
			 sum(d.Dsaldo * case when t.CCTtipo = 'D' then  1.00 else -  1.00 end) as Saldo,
			 sum(CASE
					   WHEN d.Dvencimiento >= getdate()
							AND datepart(mm, d.Dfecha) = datepart(mm, convert(datetime, getdate(), 111)) THEN Dsaldo
					   ELSE 0.00
				   END * CASE
						   WHEN t.CCTtipo = 'D' THEN 1.00
						   ELSE - 1.00
					   END) AS Corriente,

			 sum(CASE
					   WHEN d.Dvencimiento >= getdate()
							AND datepart(mm, d.Dfecha) <> datepart(mm, convert(datetime, getdate(), 111)) THEN Dsaldo
					   ELSE 0.00
				   END * CASE
						   WHEN t.CCTtipo = 'D' THEN 1.00
						   ELSE - 1.00
					   END) AS SinVencer,
			 		 sum(case when
		  		datediff(dd, d.Dfecha, convert(datetime, getdate(), 111))
				between 0 and 14 + 1 /*1er Vencimiento*/
			  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then  1.00 else - 1.00 end)
			  as P1,
		 sum(case when
			  datediff(dd, d.Dfecha, convert(datetime, getdate(), 111))
				between 15 + 1 /*1er Vencimiento*/ and 30/*2do Vencimiento*/
			  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then  1.00 else - 1.00 end)
			  as P2,
		 sum(case when
			   datediff(dd, d.Dfecha, convert(datetime, getdate(), 111))
				between 30 + 1 /*2do Vencimiento*/ and 60 + 1 /*3er Vencimiento*/
			  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then  1.00 else - 1.00 end)
			  as P3,
		 sum(case when
			 datediff(dd, d.Dfecha, convert(datetime, getdate(), 111))
		  		between 60 + 1 /*3er Vencimiento*/ and 90 + 1 /*4to Vencimiento*/
			  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then  1.00 else - 1.00 end)
			  as P4,
		 sum(case 
			  WHEN datediff(dd, d.Dfecha, convert(datetime, getdate(), 111)) >= 90 + 1 /*4to Vencimiento*/
			  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then  1.00 else - 1.00 end)
			  as P5, 
		 sum(case when
				dateadd(day, isnull(s.SNvenventas,0) ,d.Dfecha) <  getdate()
			  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then  1.00 else - 1.00 end)
			  as Morosidad
		from SNClasificacionE ec
		inner join SNClasificacionD dc
		inner join SNClasificacionSN cs
		inner join SNegocios s
		inner join Documentos d on d.Ecodigo = s.Ecodigo
			AND d.SNcodigo = s.SNcodigo ON cs.SNid = s.SNid ON cs.SNCDid = dc.SNCDid ON dc.SNCEid = ec.SNCEid
		inner join Monedas m on m.Mcodigo = d.Mcodigo and m.Ecodigo = d.Ecodigo
		inner join CCTransacciones t on t.CCTcodigo = d.CCTcodigo
			and t.Ecodigo = d.Ecodigo
		inner join Oficinas o on o.Ecodigo= d.Ecodigo
			and o.Ocodigo = d.Ocodigo
		 where ec.Ecodigo IS NULL
 			and s.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and d.Dsaldo <> 0.00
			<cfif isdefined("form.DEidCobrador") and len(trim(form.DEidCobrador))>
		  		and s.DEidCobrador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEidCobrador#">
			</cfif>
			<!--- Clasificacion --->
			<cfif isdefined("form.SNCEid") and len(form.SNCEid)  gt 0>
			and ec.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCEid#">
			</cfif>
			<!--- Socio de negocios --->
			<cfif isdefined("form.SNnumero") and len(trim(form.SNnumero)) and isdefined("form.SNnumerob2") and len(trim(form.SNnumerob2))>
				<cfif form.SNnumero gt form.SNnumerob2><!--- si el primero es mayor que el segundo. --->
						and s.SNnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumerob2#">
											and <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumero#">
				<cfelse>
						and s.SNnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumero#">
											and <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumerob2#">
				</cfif>
			<cfelseif isdefined("form.SNnumero") and len(trim(form.SNnumero))>
				and s.SNnumero >= <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumero#">
			<cfelseif isdefined("form.SNnumerob2") and len(trim(form.SNnumerob2))>
				and s.SNnumero <= <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumerob2#">
			</cfif>
			<!--- Oficina --->
			<cfif isdefined("form.Oficodigo") and len(trim(form.Oficodigo)) and isdefined("form.Oficodigo2") and len(trim(form.Oficodigo2))>
				<cfif form.Oficodigo gt form.Oficodigo2>
					and o.Oficodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#form.Oficodigo2#">
									  and <cfqueryparam cfsqltype="cf_sql_char" value="#form.Oficodigo#">
				<cfelse>
					and o.Oficodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#form.Oficodigo#">
									  and <cfqueryparam cfsqltype="cf_sql_char" value="#form.Oficodigo2#">
				</cfif>
			<cfelseif isdefined("form.Oficodigo") and len(trim(form.Oficodigo))>
				and o.Oficodigo >= <cfqueryparam cfsqltype="cf_sql_char" value="#form.Oficodigo#">
			<cfelseif isdefined("form.Oficodigo2") and len(trim(form.Oficodigo2))>
				and o.Oficodigo <=  <cfqueryparam cfsqltype="cf_sql_char" value="#form.Oficodigo2#">
			</cfif>
			group by  s.Ecodigo, m.Mnombre, ec.SNCEid, dc.SNCDid, s.SNcodigo
	) t
	group by Ecodigo
) total on r.Ecodigo = total.Ecodigo
order by r.SNnombre
</cfquery>


	<cfquery dbtype="query" name="rsReporteH">
	SELECT Sum(Saldo) as Tsaldo,
		   Sum(PrimerVencimiento) as Tsaldo1,
		   (Sum(PrimerVencimiento)*100)/Sum(Saldo)  as Psaldo1,
		   Sum(SegundoVencimiento) as Tsaldo2,
		   (Sum(SegundoVencimiento)*100)/Sum(Saldo) as Psaldo2,
		   Sum(TerceroVencimiento) as Tsaldo3,
		   (Sum(TerceroVencimiento)*100)/Sum(Saldo)as Psaldo3,
		   Sum(CuartoVencimiento) as Tsaldo4,
		   (Sum(CuartoVencimiento)*100)/Sum(Saldo) as Psaldo4,
		   Sum(QuintoVencimiento) as Tsaldo5,
		   (Sum(QuintoVencimiento)*100)/Sum(Saldo) as Psaldo5,
		   Sum(Vencido) as TsaldoV,
		   (Sum(Vencido)*100)/Sum(Saldo) as PsaldoV
		FROM rsReporte
	</cfquery>


<cfinclude template="Anti_Saldos_css.cfm">

<cf_htmlReportsHeaders
	title="RepAntSaldosCC"
	filename="RepAntSaldosCC.xls"
	irA="AntiguedadSaldosClasificacionPercent.cfm"
	download="yes"
	preview="no">


<cfif isdefined("rsReporte") and rsReporte.Recordcount  eq 0>
<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
	<cfoutput>
	<thead>
		<tr>
			<th colspan="10" align="center">
				<span class="style3">#Session.Enombre#</span><br>
				#LB_Cartera#<br>
				#dateformat(Now(),'dd/mm/yyyy')#<br>
				<cfif isdefined("form.SNCEid") and len(form.SNCEid) gt 0>#LB_Clas# : #rsSNCEid.SNCEdescripcion#</cfif>
			</th>
		</tr>
		<tr>
			<th colspan="10" align="center">
			<br><br><br>
				La consulta no ha generado Registros.
			</th>
		</tr>
	</thead>
	</cfoutput>
</table>
<cfabort>
</cfif>

<div class="datagrid">
<table border="0" cellspacing="0" cellpadding="0" width="90%" align="center">
	<cfoutput>
	<thead>
		<tr>
			<th colspan="10" align="center">
				<span class="style3">#Session.Enombre#</span><br>
				#LB_Cartera#<br>
				#dateformat(Now(),'dd/mm/yyyy')#<br>
				<cfif isdefined("form.SNCEid") and len(form.SNCEid) gt 0>#LB_Clas# : #rsSNCEid.SNCEdescripcion#</cfif>
			</th>
		</tr>
		<tr class="alt">
			<th nowrap="nowrap" align="center" ></th>
			<th nowrap="nowrap" align="center" ></th>
			<th nowrap="nowrap" align="right" ></th>
			<th nowrap="nowrap" align="center" ></th>
			<!----<cf_dump var="#rsReporteH.Tsaldo#---#rsReporteH.TsaldoV#">--->
			<th nowrap="nowrap" align="center" >#lsNumberFormat(((rsReporteH.Tsaldo-rsReporteH.TsaldoV)*100)/rsReporteH.Tsaldo,',9.00')#%</th>
			<th nowrap="nowrap" align="center" >#lsNumberFormat((rsReporteH.TsaldoV*100)/rsReporteH.Tsaldo,',9.00')#%</th>
			<th nowrap="nowrap" align="center" ></th>
			<th nowrap="nowrap" align="center" ></th>
			<th nowrap="nowrap" align="center" ></th>
			<th nowrap="nowrap" align="center" ></th>
		</tr>
		<tr class="alt">
			<th nowrap="nowrap" align="center" ></th>
			<th nowrap="nowrap" align="center" ></th>
			<th nowrap="nowrap" align="right" ></th>
			<th nowrap="nowrap" align="center" ></th>
			<th nowrap="nowrap" align="center" >#lsNumberFormat(rsReporteH.Tsaldo-rsReporteH.TsaldoV,',9.00')#</th>
			<th nowrap="nowrap" align="center" >#lsNumberFormat(rsReporteH.TsaldoV,',9.00')#</th>
			<th nowrap="nowrap" align="center" ></th>
			<th nowrap="nowrap" align="center" ></th>
			<th nowrap="nowrap" align="center" ></th>
			<th nowrap="nowrap" align="center" ></th>
		</tr>
		<tr class="alt">
			<th nowrap="nowrap" align="center" ></th>
			<th nowrap="nowrap" align="center" >100%</th>
			<th nowrap="nowrap" align="right" ></th>
			<th nowrap="nowrap" align="center" >#lsNumberFormat(rsReporteH.Psaldo1,',9.00')#%</th>
			<th nowrap="nowrap" align="center" >#lsNumberFormat(rsReporteH.Psaldo2,',9.00')#%</th>
			<th nowrap="nowrap" align="center" >#lsNumberFormat(rsReporteH.Psaldo3,',9.00')#%</th>
			<th nowrap="nowrap" align="center" >#lsNumberFormat(rsReporteH.Psaldo4,',9.00')#%</th>
			<th nowrap="nowrap" align="center" >#lsNumberFormat(rsReporteH.Psaldo5,',9.00')#%</th>
			<th nowrap="nowrap" align="center" ></th>
			<th nowrap="nowrap" align="center" ></th>
		</tr>
		<tr>
			<th nowrap="nowrap" align="left" ></th>
			<th nowrap="nowrap" align="right" >#lsNumberFormat(rsReporteH.Tsaldo,',9.00')#</th>
			<th nowrap="nowrap" align="center" >100%</th>
			<th nowrap="nowrap" align="right" >#lsNumberFormat(rsReporteH.Tsaldo1,',9.00')#</th>
			<th nowrap="nowrap" align="right" >#lsNumberFormat(rsReporteH.Tsaldo2,',9.00')#</th>
			<th nowrap="nowrap" align="right" >#lsNumberFormat(rsReporteH.Tsaldo3,',9.00')#</th>
			<th nowrap="nowrap" align="right" >#lsNumberFormat(rsReporteH.Tsaldo4,',9.00')#</th>
			<th nowrap="nowrap" align="right" >#lsNumberFormat(rsReporteH.Tsaldo5,',9.00')#</th>
			<th nowrap="nowrap" align="right" >#lsNumberFormat(rsReporteH.TsaldoV,',9.00')#</th>
			<th nowrap="nowrap" align="center">100%</th>
		</tr>
		<tr class="alt" >
			<th nowrap="nowrap" align="center" >2020</th>
			<th nowrap="nowrap" align="center" >#LB_Saldo#</th>
			<th nowrap="nowrap" align="center" >%</th>
			<th nowrap="nowrap" align="center" >0 a 15 Días</th>
			<th nowrap="nowrap" align="center" >16 a 30 Días</th>
			<th nowrap="nowrap" align="center" >31 a 60 Días</th>
			<th nowrap="nowrap" align="center" >61 a 90 Días</th>
			<th nowrap="nowrap" align="center" >mas de 90 Días</th>
			<th nowrap="nowrap" align="center" >Vencido</th>
			<th nowrap="nowrap" align="center" >%Vencido</th>
		</tr>

	</thead>
	<!--- Detalle --->
	<tbody>
	<cfset i=1>

	<!--- <cfset n = JavaCast("double", 1.0) />
	<cfset x = CreateObject("java", "java.text.DecimalFormat").init() />
	<cfset x.applyPattern("####.######") /> --->
	<cfloop query="rsReporte">
	<tr class="#(i MOD 2 ? '':'alt')#">
		<td nowrap="nowrap" align="left">#rsReporte.Socio#</td>
		<td nowrap="nowrap" align="right">#lsNumberFormat(rsReporte.Saldo,',9.00')#</td>
		<td nowrap="nowrap" align="center">#lsNumberFormat(((rsReporte.Saldo*100)/rsReporteH.Tsaldo),',9.00')#%</td>
		<td nowrap="nowrap" align="right">#lsNumberFormat(rsReporte.PrimerVencimiento,',9.00')#</td>
		<td nowrap="nowrap" align="right">#lsNumberFormat(rsReporte.SegundoVencimiento,',9.00')#</td>
		<td nowrap="nowrap" align="right">#lsNumberFormat(rsReporte.TerceroVencimiento,',9.00')#</td>
		<td nowrap="nowrap" align="right">#lsNumberFormat(rsReporte.CuartoVencimiento,',9.00')#</td>
		<td nowrap="nowrap" align="right">#lsNumberFormat(rsReporte.QuintoVencimiento,',9.00')#</td>
		<td nowrap="nowrap" align="right">#lsNumberFormat(rsReporte.Vencido,',9.00')#</td>
		<td nowrap="nowrap" align="center">#lsNumberFormat(((rsReporte.Vencido*100)/rsReporteH.TsaldoV),',9.00')#%</td>
	</tr>
	<cfset i+=1>
	</cfloop>
 	</tbody>
 	</cfoutput>
</table>

</div>