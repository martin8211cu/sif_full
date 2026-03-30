<cfinvoke key="LB_DetalleAlcanceObjetivos" default="Detalles de Alcance de Objetivos"  returnvariable="LB_DetalleAlcanceObjetivos" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Objetivos" default="Objetivos"  returnvariable="LB_Objetivos" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="BTN_Cerrar" default="Cerrar"  returnvariable="BTN_Cerrar" component="sif.Componentes.Translate"  method="Translate"/>
<cf_templatecss>
<cf_dbtemp name="tbl_detalle" returnvariable="tbl_detalle">
	<cf_dbtempcol name="RHOSid"			type="numeric"		mandatory="no">
	<cf_dbtempcol name="RHOScodigo"		type="varchar(10)"	mandatory="no">
	<cf_dbtempcol name="RHOStexto"		type="varchar(1024)"mandatory="no">
	<cf_dbtempcol name="SumaNotas"		type="float"		mandatory="no">
	<cf_dbtempcol name="Evaluadores"	type="int"			mandatory="no">
</cf_dbtemp>
<cfquery name="rsParametro" datasource="#session.DSN#">
	select coalesce(Pvalor,'0') as Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo = 1030
</cfquery>
<cfquery datasource="#session.DSN#">
	insert into #tbl_detalle# (RHOSid,SumaNotas,Evaluadores)
	select 	d.RHOSid,
			sum(c.RHREnota),				
			0
	from RHRelacionSeguimiento x
		inner join RHDRelacionSeguimiento a
			on x.RHRSid = a.RHRSid
			and a.RHDRestado = 30			
			<!----======== FILTRO DE FECHAS (aplica para general, objetivos y persona) ========---->
			<cfif isdefined("form.finicio") and len(trim(form.finicio)) and isdefined("form.ffin") and len(trim(form.ffin))>
				<cfif DateCompare(LSParseDateTime(form.finicio), LSParseDateTime(form.ffin)) EQ -1>
					and (a.RHDRfinicio between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#">  and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#">
							or a.RHDRffin between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#">
						 )	
				<cfelse>
					and (a.RHDRfinicio between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#">
							or a.RHDRffin between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#">
						)
				</cfif>
			<cfelseif isdefined("form.finicio") and len(trim(form.finicio)) and not isdefined("form.ffin") and len(trim(form.ffin)) EQ 0>
				and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#"> between a.RHDRfinicio  and a.RHDRffin
			<cfelseif isdefined("form.ffin") and len(trim(form.ffin)) and not isdefined("form.finicio") and len(trim(form.finicio)) EQ 0>
				and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#"> between a.RHDRfinicio and a.RHDRffin
			</cfif>
		inner join RHRSEvaluaciones b
			on a.RHDRid = b.RHDRid
		inner join RHRERespuestas c
			on b.RHRSEid = c.RHRSEid
			<cfif isdefined("url.DEid") and len(trim(url.DEid))><!---======== POR PERSONA (Filtro de empleado) ========---->
				and c.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
			</cfif>
		inner join RHItemEvaluar d
			on c.RHIEid = d.RHIEid
			<cfif isdefined("url.RHOSid") and len(trim(url.RHOSid))><!---======== POR OBJETIVO (Filtro de objetivo) ========---->
				inner join RHObjetivosSeguimiento e
					on d.RHOSid = e.RHOSid
					and e.RHOSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHOSid#">
			</cfif>			
	where x.RHRStipo = 'O'
	group by 	d.RHOSid
</cfquery>
<cfquery datasource="#session.DSN#">
	update #tbl_detalle#
		set Evaluadores =  (select count(1)
							from RHRelacionSeguimiento x
								inner join RHDRelacionSeguimiento a
									on x.RHRSid = a.RHRSid
									and a.RHDRestado = 30
									<!----======== FILTRO DE FECHAS (aplica para general, objetivos y persona) ========---->
									<cfif isdefined("form.finicio") and len(trim(form.finicio)) and isdefined("form.ffin") and len(trim(form.ffin))>
										<cfif DateCompare(LSParseDateTime(form.finicio), LSParseDateTime(form.ffin)) EQ -1>
											and (a.RHDRfinicio between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#">  and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#">
													or a.RHDRffin between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#">
												 )	
										<cfelse>
											and (a.RHDRfinicio between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#">
													or a.RHDRffin between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#">
												)
										</cfif>
									<cfelseif isdefined("form.finicio") and len(trim(form.finicio)) and not isdefined("form.ffin") and len(trim(form.ffin)) EQ 0>
										and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#"> between a.RHDRfinicio  and a.RHDRffin
									<cfelseif isdefined("form.ffin") and len(trim(form.ffin)) and not isdefined("form.finicio") and len(trim(form.finicio)) EQ 0>
										and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#"> between a.RHDRfinicio and a.RHDRffin
									</cfif>
								inner join RHRSEvaluaciones b
									on a.RHDRid = b.RHDRid
								inner join RHRERespuestas c
									on b.RHRSEid = c.RHRSEid
									<cfif isdefined("url.DEid") and len(trim(url.DEid))><!---======== POR PERSONA (Filtro de empleado) ========---->
										and c.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
									</cfif>
								inner join RHItemEvaluar d
									on c.RHIEid = d.RHIEid
									and #tbl_detalle#.RHOSid = d.RHOSid
									<cfif isdefined("url.RHOSid") and len(trim(url.RHOSid))><!---======== POR OBJETIVO (Filtro de objetivo) ========---->
										inner join RHObjetivosSeguimiento e
											on d.RHOSid = e.RHOSid
											and e.RHOSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHOSid#">
									</cfif>	
							where x.RHRStipo = 'O'
							group by d.RHOSid	
							)
							
</cfquery>
<cfquery datasource="#session.DSN#">
	update #tbl_detalle#
		set RHOScodigo =(select RHOScodigo from RHObjetivosSeguimiento
						where RHOSid = #tbl_detalle#.RHOSid)
			,RHOStexto = (select <cf_dbfunction name="to_char" args="RHOStexto"> from RHObjetivosSeguimiento
						where RHOSid = #tbl_detalle#.RHOSid)
</cfquery>

<cfquery name="rsDatos" datasource="#session.DSN#">
	select RHOSid, RHOScodigo, RHOStexto, coalesce(SumaNotas,0) as SumaNotas, coalesce(Evaluadores,1) as Evaluadores
	from #tbl_detalle#
</cfquery>

<cf_web_portlet_start titulo="#LB_DetalleAlcanceObjetivos#">
	<table width="98%" cellpadding="2" cellspacing="0" align="center" border="0">
		<cfif isdefined("rsDatos") and rsDatos.RecordCount NEQ 0>
			<tr>
				<td align="center">
					<cfchart chartwidth="450" format="png" chartheight="400" show3d="yes" showBorder="no" showLegend="yes"><!---url="javascript: funcDetalle();"---->
						  <cfchartseries type="bar" seriescolor="##6699CC" seriesLabel="#LB_Objetivos#">
							<cfloop query="rsDatos">
								<cfset vn_temp = rsDatos.SumaNotas/Evaluadores>
								<cfchartdata item="#rsDatos.RHOScodigo#" value="#NumberFormat(vn_temp, '9.00')#">						
							</cfloop>
						  </cfchartseries>
					</cfchart>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>		
			<tr>
				<td>	
					<cfoutput><fieldset><legend><b>#LB_Objetivos#</b></legend></cfoutput>
						<table width="100%" cellpadding="2" cellspacing="0" border="0">
							<tr style="background-color:#CCCCCC;">
								<td><b><cf_translate key="LB_Codigo">C&oacute;digo</cf_translate></b></td>
								<td><b><cf_translate key="LB_Descripcion">Descripci&oacute;n</cf_translate></b></td>							
							</tr>
							<cfoutput query="rsDatos">
								<tr class="<cfif rsDatos.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
									<td>#rsDatos.RHOScodigo#</td>
									<td>#rsDatos.RHOStexto#</td>
								</tr>
							</cfoutput>
						</table>
					</fieldset>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="center"><cfoutput><input type="button" name="btnCerrar" value="#BTN_Cerrar#" onClick="javascript: window.close();"></cfoutput></td>
			</tr>
		<cfelse>
			<tr>
				<td align="center"><b>----- <cf_translate key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> -----</b></td>
			</tr>
		</cfif>
		<tr><td>&nbsp;</td></tr>
	</table>
<cf_web_portlet_end>	

