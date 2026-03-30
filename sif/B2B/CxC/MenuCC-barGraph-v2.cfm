<cfset venc1 = Trim(get_val(310).Pvalor)>
<cfset venc2 = Trim(get_val(320).Pvalor)>
<cfset venc3 = Trim(get_val(330).Pvalor)>
<cfset venc4 = Trim(get_val(340).Pvalor)>


<cfset LvarFechaHoy = createdate(year(now()), month(now()), day(now()))>
<cfset LvarInicioMes = createdate(year(now()), month(now()), 1)>
<cfset LvarFinMes =  dateadd("m", 1, LvarInicioMes)>
<cfset LvarFinMes =  dateadd("d", -1, LvarFinMes)>

<cfset LvarVenc1 = dateadd('d', -venc1, LvarFechaHoy)>
<cfset LvarVenc2 = dateadd('d', -venc2, LvarFechaHoy)>
<cfset LvarVenc3 = dateadd('d', -venc3, LvarFechaHoy)>
<cfset LvarVenc4 = dateadd('d', -venc4, LvarFechaHoy)>

<!--- 
	Si viene el socio de negocios definido, se presentan los saldos para TODAS las direcciones del SOCIO de negocios indicado.
	Se modifica el query de seleccion de datos.
	Se separa el query en dos para evitar problemas de rendimiento con los queries
--->
<cfif isdefined("session.B2B.SNcodigo") and session.B2B.SNcodigo gt -1>
	<cf_dbfunction name="to_char" args="di.SNcodigo" returnvariable="LvarSNcodigo">
	<cfquery name="rsGraficoBar" datasource="#session.dsn#">
		select
			 <cfif isdefined('form.Ocodigo_F') and form.Ocodigo_F NEQ ''>
				#form.Ocodigo_F# as Ocodigo_F,
			 <cfelse>
				'-1' as Ocodigo_F,
			 </cfif>
			 #session.B2B.SNcodigo# as SNcodigo,

			 di.id_direccion as id_direccion,
 			 min(coalesce(di.SNDcodigo, '-- N/A --')) as direccion
			,
			 coalesce(sum(
			 			round(
							case when 
								d.Dvencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaHoy#">
								and d.Dfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LvarInicioMes#">
							then Dsaldo 
							else 0.00 
							end 
						* case when t.CCTtipo = 'D' then 1.00 else -1.00 end * d.Dtcultrev 
						,2 )),0.00)
				  as SinVencer
			,	
			 coalesce(sum(
			 			round(
							case when 
								d.Dvencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaHoy#">
								and d.Dfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarInicioMes#">
				  			then Dsaldo 
							else 0.00 
							end 
						* case when t.CCTtipo = 'D' then 1.00 else -1.00 end * d.Dtcultrev
				  		,2 )) ,0.00)
				  as Corriente
			,
			
			 coalesce(sum(round(case when 
  			 	  d.Dvencimiento    < <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaHoy#">
				  and d.Dvencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc1#">
				  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end * d.Dtcultrev
				  ,2)) ,0.00)
				  as P1
		  ,
			 coalesce(sum(round(case when
  			 	  d.Dvencimiento    < <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaHoy#">
				  and d.Dvencimiento < <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc1#">
				  and d.Dvencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc2#">
				  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end * d.Dtcultrev
				,2 )),0.00) as P2

			,
			 coalesce(sum(round(case when
  			 	  d.Dvencimiento    < <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaHoy#">
				  and d.Dvencimiento < <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc2#">
				  and d.Dvencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc3#">
				  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end * d.Dtcultrev
				, 2 )),0.00) as P3

			,
			 coalesce(sum(round(case when
 			 	  d.Dvencimiento    < <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaHoy#">
				  and d.Dvencimiento < <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc3#">
				  and d.Dvencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc4#">
				  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end * d.Dtcultrev
				, 2)),0.00) as P4

			,
			 coalesce(sum(round(case when
 			 	  d.Dvencimiento    < <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaHoy#">
				  and d.Dvencimiento < <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc4#">
				  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end * d.Dtcultrev
				, 2)),0.00) as P5

			,
			 coalesce(sum(case when
			 	  d.Dvencimiento    < <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaHoy#">
					  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end * d.Dtcultrev
				),00) as Morosidad

			,
			  sum(round(coalesce(d.Dsaldo * case when t.CCTtipo = 'D' then 1.00 else -1.00 end * d.Dtcultrev,0),2)) as Dsaldo
		from SNDirecciones di
				left outer join Documentos d
					inner join CCTransacciones t
					on t.CCTcodigo = d.CCTcodigo
					and t.Ecodigo = d.Ecodigo
				 on d.Ecodigo = di.Ecodigo
				and d.SNcodigo = di.SNcodigo
				and d.id_direccionFact = di.id_direccion
				<!---  condicion de oficina de la empresa seleccionada  --->
				<cfif isdefined("form.Ocodigo_F") and form.Ocodigo_F gt -1>
					  and d.Ocodigo = #form.Ocodigo_F#
				</cfif>
			where di.Ecodigo = #session.Ecodigo#
			  and di.SNcodigo = #session.B2B.SNcodigo#
			group by di.SNDcodigo, 
			di.id_direccion
			order by 3
	</cfquery>
<cfelse>
	<cfquery name="rsGraficoBar" datasource="#session.dsn#">
		select
			d.Ecodigo,
			<cfif isdefined('form.Ocodigo_F') and form.Ocodigo_F NEQ ''>
				#form.Ocodigo_F# as Ocodigo_F,
			<cfelse>
				'-1' as Ocodigo_F,
			</cfif>
			coalesce(sum(round(
			 	case when 
						d.Dvencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaHoy#">
						and d.Dfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#LvarInicioMes#">
					then Dsaldo 
					else 0.00 
				end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end * d.Dtcultrev,2 )),0.00)
			as SinVencer,

			coalesce(sum(round(
			 	case when 
						d.Dvencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaHoy#">
						and d.Dfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarInicioMes#">
					then Dsaldo 
					else 0.00 
				end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end * d.Dtcultrev,2 )),0.00)
			as Corriente,

			coalesce(sum(round(
			 	case when 
  			 	  d.Dvencimiento    < <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaHoy#">
				  and d.Dvencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc1#">
				  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end * d.Dtcultrev,2 )),0.00) 
			as P1,
	
			coalesce(sum(round(
				case when 
  			 	  d.Dvencimiento    <  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaHoy#">
				  and d.Dvencimiento <  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc1#">
				  and d.Dvencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc2#">
				then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end * d.Dtcultrev,2 )),0.00) 
			as P2,
	
			coalesce(sum(round(
				case when 
 			 	  d.Dvencimiento    <  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaHoy#">
				  and d.Dvencimiento <  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc2#">
				  and d.Dvencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc3#">
				then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end * d.Dtcultrev, 2 )),0.00) 
			as P3,
	
			coalesce(sum(round(
				case when 
 			 	  d.Dvencimiento    <  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaHoy#">
				  and d.Dvencimiento <  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc3#">
				  and d.Dvencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc4#">
				 then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end * d.Dtcultrev, 2)),0.00) 
			as P4,

			coalesce(sum(round(
				case when 
 			 	  d.Dvencimiento    <  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaHoy#">
				  and d.Dvencimiento <  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarVenc4#">
				then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end * d.Dtcultrev, 2)),0.00) 
			as P5,
	
			coalesce(sum(round(
				case when 
 			 	  d.Dvencimiento    <  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaHoy#">
				 then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end * d.Dtcultrev, 2)),00) as Morosidad,

			sum(round(coalesce(d.Dsaldo * case when t.CCTtipo = 'D' then 1.00 else -1.00 end * d.Dtcultrev,0),2)) as Dsaldo
		from Documentos d
				inner join CCTransacciones t
					on t.CCTcodigo = d.CCTcodigo
					and t.Ecodigo = d.Ecodigo
		where d.Ecodigo = #session.Ecodigo#
		  and d.Dsaldo > 0.00
		<cfif isdefined("form.Ocodigo_F") and form.Ocodigo_F gt -1>
		  and d.Ocodigo = #form.Ocodigo_F#
		</cfif>
		group by d.Ecodigo
	</cfquery>
</cfif>

<cfif isdefined("session.B2B.SNcodigo") and session.B2B.SNcodigo gt -1>
	<cf_dbfunction name="concat" args="sdi.SNnombre + ' (' + sdi.SNDcodigo + ')'" delimiters="+" returnvariable="LvarDireccion">
 	<cfquery name="rsDocumentos" datasource="#session.dsn#">
			select
				m.Mnombre,
				d.id_direccionFact as id_direccion,
				coalesce(#PreserveSingleQuotes(LvarDireccion)#, di.direccion1)  as direccion,
				d.CCTcodigo as Tipo,
				d.Ddocumento as Documento,
				d.Dfecha as Fecha,
				d.Dvencimiento as Vencimiento,
				coalesce((
					select min(HD.HDid)
					from HDocumentos HD
					where HD.Ecodigo 	= d.Ecodigo
					  and HD.CCTcodigo 	= d.CCTcodigo
					  and HD.Ddocumento = d.Ddocumento
					  and HD.SNcodigo 	= d.SNcodigo
				),-1) as HDid,
				(
					select min(ofi.Oficodigo)
					from Oficinas ofi
					where ofi.Ecodigo = d.Ecodigo
					and ofi.Ocodigo = d.Ocodigo
				) as Oficina,
				d.Dtotal as Monto,
				d.Dsaldo as Saldo,
				round(d.Dsaldo  * d.Dtcultrev * case when t.CCTtipo = 'D' then 1.00 else -1.00 end, 2) as SaldoLoc
			from Documentos d
				inner join CCTransacciones t
					on t.CCTcodigo = d.CCTcodigo
					and t.Ecodigo = d.Ecodigo
				inner join Monedas m
					on m.Mcodigo = d.Mcodigo
				inner join SNDirecciones sdi
						inner join DireccionesSIF di
						on  di.id_direccion = sdi.id_direccion
				on d.Ecodigo = sdi.Ecodigo
				and d.SNcodigo = sdi.SNcodigo
				and d.id_direccionFact = sdi.id_direccion
			where d.Ecodigo = #session.Ecodigo#
			  and d.SNcodigo = #session.B2B.SNcodigo#
			  <cfif isdefined("form.Ocodigo_F") and form.Ocodigo_F gt -1>
				  and d.Ocodigo = #form.Ocodigo_F#
			  </cfif>
			  <cfif isdefined("form.id_direccion") and form.id_direccion gt -1>
				  and d.id_direccionFact = #form.id_direccion#
			  </cfif>
			  and round(d.Dsaldo, 2) <> 0.00
			  order by m.Mnombre, d.CCTcodigo
		</cfquery>
</cfif>
<cfquery name="rsGraficoBar2" dbtype="query">
	select 
		sum(SinVencer) as SinVencer,
		sum(Corriente) as Corriente,
		sum(P1) as P1,
		sum(P2) as P2,
		sum(P3) as P3,
		sum(P4) as P4,
		sum(P5) as P5,
		sum(Morosidad) as Morosidad
	from rsGraficoBar
</cfquery>


<cfset rsGrafico = QueryNew("Monto, Venc")>
<cfset QueryAddRow(rsGrafico,1)>
<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar2.Corriente,rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Venc','Corriente',rsGrafico.RECORDCOUNT)>
<cfset QueryAddRow(rsGrafico,1)>
<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar2.SinVencer,rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Venc','Sin Vencer',rsGrafico.RECORDCOUNT)>
<cfset QueryAddRow(rsGrafico,1)>
<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar2.P1,rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Venc','1 - #Venc1#',rsGrafico.RECORDCOUNT)>
<cfset QueryAddRow(rsGrafico,1)>
<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar2.P2,rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Venc','#Venc1+1# - #Venc2#',rsGrafico.RECORDCOUNT)>
<cfset QueryAddRow(rsGrafico,1)>
<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar2.P3,rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Venc','#Venc2+1# - #Venc3#',rsGrafico.RECORDCOUNT)>
<cfset QueryAddRow(rsGrafico,1)>
<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar2.P4,rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Venc','#Venc3+1# - #Venc4#',rsGrafico.RECORDCOUNT)>
<cfset QueryAddRow(rsGrafico,1)>
<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar2.P5,rsGrafico.RECORDCOUNT)>
<cfset QuerySetCell(rsGrafico,'Venc','Mas de #Venc4#',rsGrafico.RECORDCOUNT)>

<cfif rsGrafico.recordcount>
	<cfquery name="rsValores" dbtype="query">
	  select min(monto) as minimo, max(monto) as maximo from rsGrafico
	</cfquery>
	<cfset minimo = rsValores.minimo>
	<cfset maximo = rsValores.maximo>
	<table width="100%%"  border="0" cellspacing="0" cellpadding="0"> <!--- class="table_border_gray" ---> 
	  <tr>
		<td class="smenu56" align="center"><strong>An&aacute;lisis Vencimiento&nbsp; 
			<cfif isdefined("form.Ocodigo_F") and form.Ocodigo_F gt -1>
				<cfquery dbtype="query" name="rsO">
					select Odescripcion as O
					from rsOficinas
					where Ocodigo = #form.Ocodigo_F#
				</cfquery>
				<cfoutput>#rsO.O#</cfoutput>
			</cfif></strong>
		</td>
	  </tr>
	  <tr>
		<td>	
			<cfset GraphParams = "">
			<cfif isdefined("form.Ocodigo_F") and form.Ocodigo_F gt -1>
				<cfset GraphParams = "&Ocodigo=#form.Ocodigo_F#">
			</cfif>
			<cfif isdefined("session.B2B.SNcodigo") and session.B2B.SNcodigo gt -1>
				<cfset GraphParams = GraphParams & "&SNcodigo=#session.B2B.SNcodigo#">
			</cfif>
						
 			<cfchart
				format = "flash"
				chartwidth = "450" 
				chartheight="250"
				scalefrom = "0"
				scaleto = "0"
				showxgridlines = "yes"
				showygridlines = "yes"
				gridlines = "5"
				seriesplacement = "stacked"
				showborder = "no"
				font = "Arial"
				fontsize = "10"
				fontbold = "no"
				fontitalic = "no"
				labelformat = "number"
				xaxistitle = "Vencimiento en Días"
				yaxistitle = "Monto Vencimiento"
				sortxaxis = "no"
				show3d = "yes"
				rotated = "no"
				showlegend = "yes"
				tipstyle = "MouseOver"
				showmarkers = "yes"
				markersize = "50"
				url = "/cfmx/sif/B2B/admin/Consultas/AntigSaldosDetCxC.cfm?venc=$ITEMLABEL$#GraphParams#"
				>
						<cfchartseries 
							type="bar" 
							query="rsGrafico" 
							valuecolumn="monto" 
							itemcolumn="venc"
							colorlist="##99CCFF,##FFCCCC,##99FFCC,##FFFFCC,##DCCCE6,##FFFF99,##CCCCFF">
			</cfchart> 
		</td>
	  </tr>
	</table>
<cfelse>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="Ayuda">
	  <tr>
		<td> *** No se encontraron datos para realizar el Gr&aacute;fico *** </td>
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