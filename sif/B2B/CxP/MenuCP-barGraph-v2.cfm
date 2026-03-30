<cfif not isdefined("Form.SNcodigo")>
	<cfset 	Form.SNcodigo = '-1'>
</cfif> 
<cfif not isdefined("Form.FORMATO")>
	<cfset 	Form.FORMATO = '1'>
</cfif> 

<cfset venc1 = Trim(get_val(310).Pvalor)>
<cfset venc2 = Trim(get_val(320).Pvalor)>
<cfset venc3 = Trim(get_val(330).Pvalor)>
<cfset venc4 = Trim(get_val(340).Pvalor)>

<cf_dbfunction name="now" returnvariable="Hoy">
<cf_dbfunction name="datediff"   args="d.Dfechavenc, #Hoy#" 						returnvariable="diasVencidos">
<cf_dbfunction name="date_part"	 args="mm, d.Dfecha" 	    						returnVariable="mesDfecha">
<cf_dbfunction name="date_part"	 args="mm, #Hoy#" 									returnVariable="mesHoy">
<cf_dbfunction name="sPart"		 args="di.SNnombre,1,36" 							returnvariable="SNnombre">
<cf_dbfunction name="length"     args="coalesce(di.SNnombre, s.SNnombre)"         	returnvariable="LenSNnombre">

<!--- 
	Si viene el socio de negocios definido, se presentan los saldos para TODAS las direcciones del SOCIO de negocios indicado.
	Se modifica el query de seleccion de datos.
	Se separa el query en dos para evitar problemas de rendimiento con los queries
--->
<cfif isdefined("form.SNcodigo") and form.SNcodigo gt -1> 
	<cfquery name="rsGraficoBar" datasource="#session.dsn#">
		select
			 <cfif isdefined('form.Ocodigo_F') and form.Ocodigo_F NEQ ''>
				<CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.Ocodigo_F#"> as Ocodigo_F,
			 <cfelse>
				'-1' as Ocodigo_F,
			 </cfif>
			 <CF_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.SNcodigo#"> as SNcodigo,
			 coalesce(di.SNDcodigo, s.SNnumero) as SNnumero,	 
			 coalesce(di.id_direccion, 1) as id_direccion,
			 coalesce(case when #PreserveSingleQuotes(LenSNnombre)# > 36 
			 	then 
					coalesce(di.SNnombre, s.SNnombre) <cf_dbfunction name="OP_concat"> '...'
				else 
					coalesce(di.SNnombre, s.SNnombre)
				end, 
			'-- N/A --') 
				as direccion,

			 coalesce(sum(round(case when 
					d.Dfechavenc >= #Hoy#
					and #PreserveSingleQuotes(mesDfecha)# <> #PreserveSingleQuotes(mesHoy)#
				  then EDsaldo else 0.00 end * case when t.CPTtipo = 'C' then 1.00 else -1.00 end * d.EDtcultrev 
				  ,2 )),0.00)
				  as SinVencer
			,	

			 coalesce(sum(round(case when 
					d.Dfechavenc >= #Hoy#
					and #PreserveSingleQuotes(mesDfecha)# = #PreserveSingleQuotes(mesHoy)#
				  then EDsaldo else 0.00 end * case when t.CPTtipo = 'C' then 1.00 else -1.00 end * d.EDtcultrev
				  ,2 )) ,0.00)
				  as Corriente
			,
			
			 coalesce(sum(round(case when 
  			 	  d.Dfechavenc <= #Hoy#
				  and #PreserveSingleQuotes(diasVencidos)#
					between 1 and <CF_jdbcquery_param cfsqltype="cf_sql_integer" value="#venc1#"> 
				  then EDsaldo else 0.00 end * case when t.CPTtipo = 'C' then 1.00 else -1.00 end * d.EDtcultrev
				  ,2)) ,0.00)
				  as P1
		  ,
			 coalesce(sum(round(case when
				 #PreserveSingleQuotes(diasVencidos)# between <CF_jdbcquery_param cfsqltype="cf_sql_integer" value="#venc1 + 1#"> and <CF_jdbcquery_param cfsqltype="cf_sql_integer" value="#venc2#">
				  then EDsaldo else 0.00 end * case when t.CPTtipo = 'C' then 1.00 else -1.00 end * d.EDtcultrev
				,2 )),0.00) as P2

			,
			 coalesce(sum(round(case when
				  #PreserveSingleQuotes(diasVencidos)# between <CF_jdbcquery_param cfsqltype="cf_sql_integer" value="#venc2 + 1#"> and <CF_jdbcquery_param cfsqltype="cf_sql_integer" value="#venc3#">
				  then EDsaldo else 0.00 end * case when t.CPTtipo = 'C' then 1.00 else -1.00 end * d.EDtcultrev
				, 2 )),0.00) as P3

			,
			 coalesce(sum(round(case when
				  #PreserveSingleQuotes(diasVencidos)# between <CF_jdbcquery_param cfsqltype="cf_sql_integer" value="#venc3 + 1#"> and <CF_jdbcquery_param cfsqltype="cf_sql_integer" value="#venc4#">
				  then EDsaldo else 0.00 end * case when t.CPTtipo = 'C' then 1.00 else -1.00 end * d.EDtcultrev
				, 2)),0.00) as P4

			,
			 coalesce(sum(round(case when
				 #PreserveSingleQuotes(diasVencidos)# > <CF_jdbcquery_param cfsqltype="cf_sql_integer" value="#venc4#">
				  then EDsaldo else 0.00 end * case when t.CPTtipo = 'C' then 1.00 else -1.00 end * d.EDtcultrev
				, 2)),0.00) as P5

			,
			 coalesce(sum(case when
				  #PreserveSingleQuotes(diasVencidos)# > 0
					  then EDsaldo else 0.00 end * case when t.CPTtipo = 'C' then 1.00 else -1.00 end * d.EDtcultrev
				),00) as Morosidad

			,
			  sum(round(coalesce(d.EDsaldo * case when t.CPTtipo = 'C' then 1.00 else -1.00 end * d.EDtcultrev,0),2)) as Dsaldo
			from EDocumentosCP d
            	inner join SNegocios s
                on s.Ecodigo = d.Ecodigo
                and s.SNcodigo = d.SNcodigo

				left outer join SNDirecciones di
                 on di.Ecodigo      = d.Ecodigo
                and di.SNcodigo     = d.SNcodigo
                and di.id_direccion = d.id_direccion

				inner join CPTransacciones t
					on  t.CPTcodigo = d.CPTcodigo
					and t.Ecodigo   = d.Ecodigo
			where d.Ecodigo =  #Session.Ecodigo# 
			  and d.SNcodigo = #form.SNcodigo#
			<!---  condicion de oficina de la empresa seleccionada  --->
            <cfif isdefined("form.Ocodigo_F") and form.Ocodigo_F gt -1>
                  and d.Ocodigo = <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.Ocodigo_F#">
            </cfif>
			group by 
            	coalesce(di.SNDcodigo, s.SNnumero), 
                coalesce(di.id_direccion, 1), 
            	coalesce(
                	case when #PreserveSingleQuotes(LenSNnombre)# > 36 
                    then 
                        coalesce(di.SNnombre, s.SNnombre) <cf_dbfunction name="OP_concat"> '...'
                    else 
                        coalesce(di.SNnombre, s.SNnombre)
                    end
				, '-- N/A --')
			order by 3
	</cfquery>
<cfelse>
	<cfquery name="rsGraficoBar" datasource="#session.dsn#">
		select
			d.Ecodigo,
			<cfif isdefined('form.Ocodigo_F') and form.Ocodigo_F NEQ ''>
				<CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.Ocodigo_F#"> as Ocodigo_F,
			<cfelse>
				'-1' as Ocodigo_F,
			</cfif>
			coalesce(sum(round(
			 	case when d.Dfechavenc >= #Hoy# and #PreserveSingleQuotes(mesDfecha)# <> #PreserveSingleQuotes(mesHoy)#
				  then EDsaldo else 0.00 
				 end * case when t.CPTtipo = 'C' then 1.00 else -1.00 end * d.EDtcultrev,2 )),0.00)
			as SinVencer,

			coalesce(sum(round(
			 	case when d.Dfechavenc >= #Hoy# and #PreserveSingleQuotes(mesDfecha)# = #PreserveSingleQuotes(mesHoy)#
				  then EDsaldo else 0.00 end * case when t.CPTtipo = 'C' then 1.00 else -1.00 end * d.EDtcultrev,2 )),0.00)
			as Corriente,

			coalesce(sum(round(
			 	case when #PreserveSingleQuotes(diasVencidos)# between 1 and <CF_jdbcquery_param cfsqltype="cf_sql_integer" value="#venc1#">
				  then EDsaldo else 0.00 end * case when t.CPTtipo = 'C' then 1.00 else -1.00 end * d.EDtcultrev,2 )),0.00) 
			as P1,
	
			coalesce(sum(round(
				case when #PreserveSingleQuotes(diasVencidos)# between <CF_jdbcquery_param cfsqltype="cf_sql_integer" value="#venc1+1#"> and <CF_jdbcquery_param cfsqltype="cf_sql_integer" value="#venc2#">
				  then EDsaldo else 0.00 end * case when t.CPTtipo = 'C' then 1.00 else -1.00 end * d.EDtcultrev,2 )),0.00) 
			as P2,
	
			coalesce(sum(round(
				case when #PreserveSingleQuotes(diasVencidos)# between <CF_jdbcquery_param cfsqltype="cf_sql_integer" value="#venc2+1#"> and <CF_jdbcquery_param cfsqltype="cf_sql_integer" value="#venc3#">
				  then EDsaldo else 0.00 end * case when t.CPTtipo = 'C' then 1.00 else -1.00 end * d.EDtcultrev, 2 )),0.00) 
			as P3,
	
			coalesce(sum(round(
				case when #PreserveSingleQuotes(diasVencidos)# between <CF_jdbcquery_param cfsqltype="cf_sql_integer" value="#venc3+1#"> and <CF_jdbcquery_param cfsqltype="cf_sql_integer" value="#venc4#">
				  then EDsaldo else 0.00 end * case when t.CPTtipo = 'C' then 1.00 else -1.00 end * d.EDtcultrev, 2)),0.00) 
			as P4,

			coalesce(sum(round(
				case when #PreserveSingleQuotes(diasVencidos)# > <CF_jdbcquery_param cfsqltype="cf_sql_integer" value="#venc4#">
				  then EDsaldo else 0.00 end * case when t.CPTtipo = 'C' then 1.00 else -1.00 end * d.EDtcultrev, 2)),0.00) 
			as P5,
	
			coalesce(sum(round(
				case when #PreserveSingleQuotes(diasVencidos)# > 0
				  then EDsaldo else 0.00 end * case when t.CPTtipo = 'C' then 1.00 else -1.00 end * d.EDtcultrev, 2)),00) as Morosidad,
			sum(round(coalesce(d.EDsaldo * case when t.CPTtipo = 'C' then 1.00 else -1.00 end * d.EDtcultrev,0),2)) as Dsaldo
		from EDocumentosCP d
				inner join CPTransacciones t
					on t.CPTcodigo = d.CPTcodigo
					and t.Ecodigo = d.Ecodigo
		where d.Ecodigo =  #Session.Ecodigo# 
		  and d.EDsaldo > 0.00
		<cfif isdefined("form.Ocodigo_F") and form.Ocodigo_F gt -1>
		  and d.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo_F#">
		</cfif>
		group by d.Ecodigo
	</cfquery>
</cfif>

<cfif isdefined('form.id_direccion') and form.id_direccion NEQ '' and isdefined("form.SNcodigo") and form.SNcodigo gt -1>
 	<cfquery name="rsDocumentos" datasource="#session.dsn#">
			select
				coalesce(d.id_direccion, 1) as id_direccion,
				coalesce(di.direccion1, '-- N/A --')  as direccion,
				d.CPTcodigo as Tipo,
				d.Ddocumento as Documento,
				d.Dfecha as Fecha,
				d.Dfechavenc as Vencimiento,
				coalesce(ofi.Oficodigo, ' N/A') as Oficina,
				round(d.Dtotal * d.EDtcultrev * case when t.CPTtipo = 'C' then 1.00 else -1.00 end, 2) as Monto,
				round(d.EDsaldo  * d.EDtcultrev * case when t.CPTtipo = 'C' then 1.00 else -1.00 end, 2) as Saldo
			from
				 EDocumentosCP d
					inner join CPTransacciones t
						on t.CPTcodigo = d.CPTcodigo
						and t.Ecodigo = d.Ecodigo
					left outer join Oficinas ofi
						on ofi.Ecodigo = d.Ecodigo
						and ofi.Ocodigo = d.Ocodigo
					left outer join DireccionesSIF di
						on  di.id_direccion = d.id_direccion
			where d.Ecodigo =  #session.Ecodigo# 
			  and d.EDsaldo <> 0.00
			  and d.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
	
			  <cfif isdefined("form.Ocodigo_F") and form.Ocodigo_F gt -1>
				  and d.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo_F#">
			  </cfif>
			  <cfif isdefined("form.id_direccion") and form.id_direccion gt -1>
				  and d.id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">
			  </cfif>
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
		<td class="smenu56" align="center"><strong>An&aacute;lisis de Vencimiento en D&iacute;as para 
			<cfif isdefined("form.Ocodigo_F") and form.Ocodigo_F gt -1>
				<cfquery dbtype="query" name="rsO">
					select Odescripcion as O
					from rsOficinas
					where Ocodigo = #form.Ocodigo_F#
				</cfquery>
				la oficina <cfoutput>#rsO.O#</cfoutput>
			<cfelse>
				todas las oficinas
			</cfif></strong>
		</td>
	  </tr>
	  <tr>
		<td>	
			<cfset GraphParams = "">
			<cfif isdefined("form.Ocodigo_F") and form.Ocodigo_F gt -1>
				<cfset GraphParams = "&Ocodigo=#form.Ocodigo_F#">
			</cfif>
			<cfif isdefined("form.SNcodigo") and form.SNcodigo gt -1>
				<cfset GraphParams = GraphParams & "&SNcodigo=#form.SNcodigo#">
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
				url = "/cfmx/sif/admin/Consultas/AntigSaldosDetCxP.cfm?venc=$ITEMLABEL$#GraphParams#"
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
		<td> *** No se encontraron datos para realizar el Gráfico *** </td>
	  </tr>
	</table>
</cfif>

<cffunction name="get_val" access="public" returntype="query">
	<cfargument name="valor" type="numeric" required="true" default="">
		<cfquery datasource="#Session.DSN#" name="rsget_val">
			select ltrim(rtrim(Pvalor)) as Pvalor from Parametros
			where Ecodigo =  #Session.Ecodigo# 
			and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#valor#">
		</cfquery>
	<cfreturn #rsget_val#>
</cffunction>