<cfinvoke key="LB_nav__SPdescripcion" default="Reporte de Competencias/Objetivos Evaluados"  returnvariable="LB_nav__SPdescripcion" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Indefinido" default="Indefinido"  returnvariable="LB_Indefinido" component="sif.Componentes.Translate"  method="Translate"/>

<cfif isdefined("form.opt") and form.opt EQ 1><!----============== OBJETIVOS ==============------>
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select  count(1) as cantidad, d.RHOSid , e.RHOScodigo as Item
		from RHRelacionSeguimiento a
			inner join RHDRelacionSeguimiento b
				on a.RHRSid = b.RHRSid
				and b.RHDRestado = 30	<!----Terminadas---->
				<!----========== FILTRO DE FECHA ==========----->
				<cfif isdefined("form.finicio") and len(trim(form.finicio)) and isdefined("form.ffin") and len(trim(form.ffin))>
					<cfif DateCompare(LSParseDateTime(form.finicio), LSParseDateTime(form.ffin)) EQ -1>
						and (b.RHDRfinicio between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#">  and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#">
								or b.RHDRffin between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#">
							 )	
					<cfelse>
						and (b.RHDRfinicio between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#">
								or b.RHDRffin between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#">
							)
					</cfif>
				<cfelseif isdefined("form.finicio") and len(trim(form.finicio)) and not isdefined("form.ffin") and len(trim(form.ffin)) EQ 0>
					and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#"> between b.RHDRfinicio  and b.RHDRffin
				<cfelseif isdefined("form.ffin") and len(trim(form.ffin)) and not isdefined("form.finicio") and len(trim(form.finicio)) EQ 0>
					and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#"> between b.RHDRfinicio and b.RHDRffin
				</cfif>
			inner join RHEvaluados c
				on a.RHRSid = c.RHRSid
				<cfif isdefined("form.DEid") and len(trim(form.DEid))><!----============ FILTRO DE EMPLEADO ============----->
					and c.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				</cfif>
			inner join RHItemEvaluar d
				on c.RHEid = d.RHEid
				and d.RHOSid is not null
			inner join RHObjetivosSeguimiento e
				on d.RHOSid = e.RHOSid	
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.RHRStipo = 'O'		<!---Relaciones de tipo objetivo--->
			and a.RHRSestado in (20,30)	<!---Relaciones publicadas o cerradas---->
		group by d.RHOSid, e.RHOScodigo
	</cfquery>	
<cfelseif isdefined("form.opt") and form.opt EQ 2><!----============== COMPETENCIAS ==============------>
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select  count(1) as cantidad, d.RHHid , e.RHHcodigo as Item
		from RHRelacionSeguimiento a
			inner join RHDRelacionSeguimiento b
				on a.RHRSid = b.RHRSid
				and b.RHDRestado = 30	<!----Publicadas o terminadas---->
				<!----========== FILTRO DE FECHA ==========----->
				<cfif isdefined("form.finicio") and len(trim(form.finicio)) and isdefined("form.ffin") and len(trim(form.ffin))>
					<cfif DateCompare(LSParseDateTime(form.finicio), LSParseDateTime(form.ffin)) EQ -1>
						and (b.RHDRfinicio between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#">  and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#">
								or b.RHDRffin between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#">
							 )	
					<cfelse>
						and (b.RHDRfinicio between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#">
								or b.RHDRffin between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#">
							)
					</cfif>
				<cfelseif isdefined("form.finicio") and len(trim(form.finicio)) and not isdefined("form.ffin") and len(trim(form.ffin)) EQ 0>
					and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#"> between b.RHDRfinicio  and b.RHDRffin
				<cfelseif isdefined("form.ffin") and len(trim(form.ffin)) and not isdefined("form.finicio") and len(trim(form.finicio)) EQ 0>
					and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#"> between b.RHDRfinicio and b.RHDRffin
				</cfif>
			inner join RHEvaluados c
				on a.RHRSid = c.RHRSid
				<cfif isdefined("form.DEid") and len(trim(form.DEid))><!----============ FILTRO DE EMPLEADO ============----->
					and c.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				</cfif>
			inner join RHItemEvaluar d
				on c.RHEid = d.RHEid
				and d.RHHid is not null
			inner join RHHabilidades e
				on d.RHHid = e.RHHid
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.RHRStipo = 'C'		<!----Relaciones de tipo competencia---->
			and a.RHRSestado in (20,30)	<!---Relaciones publicadas o cerradas---->
		group by d.RHHid , e.RHHcodigo
	</cfquery>
</cfif>

<!----====================== DETALLE ======================---->
<cfquery name="rsDetalle" datasource="#session.DSN#">
	select 	c.DEid, c.DEideval, c.RHIEid, a.RHDRid, a.RHDRfinicio,a.RHDRffin,
			coalesce(c.RHIEestado,0) as estado, c.RHREnota,
			<cf_dbfunction name="concat" args="h.DEnombre,' ',h.DEapellido1,' ',h.DEapellido2"> as colaborador,
			<cf_dbfunction name="concat" args="i.DEnombre,' ',i.DEapellido1,' ',i.DEapellido2"> as evaluador,
			j.RHRSdescripcion, a.RHRSid, case when m.RHOSid is not null then 'O' else 'C' end as tipo
			<cfif isdefined("form.opt") and form.opt EQ 1><!----============== OBJETIVOS ==============------>
				,o.RHOSid as Item, o.RHOScodigo as CodItem, o.RHOStexto as DescItem
			<cfelseif isdefined("form.opt") and form.opt EQ 2><!----============== COMPETENCIAS ==============------>
				,o.RHHid as Item, o.RHHcodigo as CodItem, o.RHHdescripcion as DescItem
			</cfif>
	from RHDRelacionSeguimiento a
		inner join RHRSEvaluaciones b
			on a.RHDRid = b.RHDRid
			<cfif isdefined("form.DEid") and len(trim(form.DEid))><!----============ FILTRO DE EMPLEADO ============----->
				and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			</cfif>
		inner join DatosEmpleado h
			on b.DEid = h.DEid	
		inner join DatosEmpleado i
			on b.DEideval = i.DEid
		inner join RHRelacionSeguimiento j
			on a.RHRSid = j.RHRSid			
		inner join RHRERespuestas c
			on b.RHRSEid = c.RHRSEid
		inner join RHItemEvaluar m
			on c.RHIEid = m.RHIEid
		<cfif isdefined("form.opt") and form.opt EQ 1><!----============== OBJETIVOS ==============------>
			inner join RHObjetivosSeguimiento o
				on m.RHOSid = o.RHOSid
		<cfelseif isdefined("form.opt") and form.opt EQ 2><!----============== COMPETENCIAS ==============------>
			inner join RHHabilidades o
				on m.RHHid = o.RHHid
		</cfif>										
	where a.RHDRestado = 30 <!---Solo las instancias cerradas---->
		<!----========== FILTRO DE FECHA ==========----->
		<cfif isdefined("form.finicio") and len(trim(form.finicio)) and isdefined("form.ffin") and len(trim(form.ffin))>
			<cfif DateCompare(LSParseDateTime(form.finicio), LSParseDateTime(form.ffin)) EQ -1>
				and (a.RHDRfinicio between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#">  and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#">
						or a.RHDRffin between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#">
					 )	
			<cfelse>
				and (b.RHDRfinicio between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#">
						or a.RHDRffin between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#">
					)
			</cfif>
		<cfelseif isdefined("form.finicio") and len(trim(form.finicio)) and not isdefined("form.ffin") and len(trim(form.ffin)) EQ 0>
			and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.finicio)#"> between a.RHDRfinicio  and a.RHDRffin
		<cfelseif isdefined("form.ffin") and len(trim(form.ffin)) and not isdefined("form.finicio") and len(trim(form.finicio)) EQ 0>
			and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.ffin)#"> between a.RHDRfinicio and a.RHDRffin
		</cfif>
	<cfif isdefined("form.opt") and form.opt EQ 1><!----============== OBJETIVOS ==============------>			
		order by a.RHDRid,o.RHOSid		
	<cfelseif isdefined("form.opt") and form.opt EQ 2><!----============== COMPETENCIAS ==============------>
		order by a.RHDRid,o.RHHid			
	</cfif>	
</cfquery>

<cfif isdefined("form.DEid") and len(trim(form.DEid))>
	<cfquery name="rsEmpleado" datasource="#session.DSN#">
		select <cf_dbfunction name="concat" args="i.DEnombre,' ',i.DEapellido1,' ',i.DEapellido2"> as empleado
		from DatosEmpleado i
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	</cfquery>
</cfif>
	
<!---Calcular el total---->
<cfif isdefined("rsDatos") and rsDatos.RecordCount NEQ 0>
	<cfquery name="rsTotal" dbtype="query">
		select sum(cantidad) as total
		from rsDatos
	</cfquery>
</cfif>

<cf_templatecss>

<cfset LvarFileName = "GraficoCompetenciasObjetivosEvaluados#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
<cf_htmlReportsHeaders 
	title="#LB_nav__SPdescripcion#" 
	filename="#LvarFileName#"
	irA="graf-competenciasevaluadas-filtro.cfm"
	download="no">
<table width="98%" cellpadding="2" cellspacing="0" align="center" border="0">
	<!---================ ENCABEZADO ================---->
	<tr>
		<td colspan="2" valign="top">
			<cfoutput>
			<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center">
				<tr>
					<td>
						<cfinvoke key="LB_Periodo" default="Per&iacute;odo" returnvariable="LB_Periodo" component="sif.Componentes.Translate"  method="Translate"/>
						<cfinvoke key="LB_del" default="del" returnvariable="LB_del" component="sif.Componentes.Translate"  method="Translate"/>
						<cfinvoke key="LB_al" default="al" returnvariable="LB_al" component="sif.Componentes.Translate"  method="Translate"/>
						<cfinvoke key="LB_Indefinido" default="Indefinido" returnvariable="LB_Indefinido" component="sif.Componentes.Translate"  method="Translate"/>
						<cfinvoke key="LB_Objetivo" default="Objetivo" returnvariable="LB_Objetivo" component="sif.Componentes.Translate"  method="Translate"/>
						<cfinvoke key="LB_Colaborador" default="Colaborador" returnvariable="LB_Colaborador" component="sif.Componentes.Translate"  method="Translate"/>
						<cfinvoke key="LB_EnAdelante" default="en adelante" returnvariable="LB_EnAdelante" component="sif.Componentes.Translate"  method="Translate"/>
						<cfinvoke key="LB_HastaEl" default="hasta el" returnvariable="LB_HastaEl" component="sif.Componentes.Translate"  method="Translate"/>
						<cfinvoke key="LB_Colaborador" default="Colaborador" returnvariable="LB_Colaborador" component="sif.Componentes.Translate"  method="Translate"/>
						<cfset filtro1='#LB_Periodo#'>
						<cfset filtro2=''>
						<cfif (not isdefined("form.finicio") or len(trim(form.finicio)) EQ 0) and (not isdefined("form.ffin") or len(trim(form.ffin)) EQ 0)><!---No se selecciono ninguna fecha--->
							<cfset filtro1= filtro1 & ' #LB_Indefinido#'>
						<cfelseif isdefined("form.finicio")	and len(trim(form.finicio)) and isdefined("form.ffin") and len(trim(form.ffin))><!---Se seleccionaron ambas fechas--->
							<cfset filtro1= filtro1 & ' #LB_del#'>							
							<cfif DateCompare(form.finicio, form.ffin) EQ 1>
								<cfset filtro1= filtro1 & ' #LSDateFormat(form.ffin,'dd/mm/yyyy')# #LB_al# #LSDateFormat(form.finicio,'dd/mm/yyyy')#'>																
							<cfelse>
								<cfset filtro1= filtro1 & ' #LSDateFormat(form.finicio,'dd/mm/yyyy')# #LB_al# #LSDateFormat(form.ffin,'dd/mm/yyyy')#'>								
							</cfif>
						<cfelseif isdefined("form.finicio") and len(trim(form.finicio)) and not isdefined("form.ffin") or len(trim(form.ffin)) EQ 0><!---Solo se selecciono fecha inicio---->
							<cfset filtro1= filtro1 & ' #LB_del# #LSDateFormat(form.finicio,'dd/mm/yyyy')# #LB_EnAdelante#'>
						<cfelseif isdefined("form.ffin") and len(trim(form.ffin)) and not isdefined("form.finicio") or len(trim(form.finicio)) EQ 0><!---Solo se selecciono fecha fin--->
							<cfset filtro1= filtro1 & ' #LB_HastaEl# #LSDateFormat(form.ffin,'dd/mm/yyyy')#'>							
						</cfif>
						<cfif isdefined("form.DEid") and len(trim(form.DEid))><!----============== OBJETIVOS ==============------>
							<cfset filtro2 = '#LB_Colaborador#: #rsEmpleado.empleado#'>
						</cfif>
						<cf_EncReporte
							Titulo="#LB_nav__SPdescripcion#"
							Color="##E3EDEF"
							filtro1="#filtro1#"	
							filtro2="#filtro2#"								
						>
					</td>
				</tr>
			</table>
			</cfoutput>
		</td>
	</tr>
	<!---================ DETALLE ================---->
	<cfif isdefined("rsDatos") and rsDatos.RecordCount NEQ 0>
		<tr>
			<cfoutput>
			<td width="40%" valign="top"><!----GRAFICO---->
				<table>
					<tr>
						<td align="center">
							<cfchart chartwidth="450" format="png" chartheight="400" show3d="yes" showBorder="no" showLegend="yes"><!----url="javascript: funcBrecha();" ---->
								  <cfchartseries type="pie">
									<cfset vn_temp = 0>
									<cfloop query="rsDatos">
										<cfset vn_temp = (rsDatos.cantidad*100)/rsTotal.total>
										<cfchartdata item="#rsDatos.Item#" value="#NumberFormat(vn_temp, '9.00')#">						
									</cfloop>
								  </cfchartseries>
							</cfchart>						
						</td>
					</tr>
				</table>
			</td>
			</cfoutput>
			<td width="60%" valign="top"><!----DETALLE---->
				<div style="height:450;overflow:auto; vertical-align:text-top">
					<table width="100%" cellpadding="2" cellspacing="0" border="0">
						<tr style="background-color:#CCCCCC;"><td colspan="5" align="center"><b><cf_translate key="LB_Detalle">DETALLE</cf_translate></b></td></tr>	
						<cfoutput query="rsDetalle" group="RHRSdescripcion">
							<tr style="background-color:##CCCCCC;">
								<td colspan="5"><b>#rsDetalle.RHRSdescripcion#</b></td>
							</tr>
							<tr style="background-color:##F1F1F1;">
								<td width="1%">&nbsp;</td>
								<td width="1%">&nbsp;</td>
								<td><b>#LB_Colaborador#</b></td>
								<td><b><cf_translate key="LB_Evaluador">Evaluador</cf_translate></b></td>
								<td width="5%" nowrap><b>
									<cfif rsDetalle.tipo EQ 'O'>
										<cf_translate key="LB_Alcanzado">Alcanzado</cf_translate></b>
									<cfelse>
										<cf_translate key="LB_Nota">Nota</cf_translate></b>
									</cfif>
								</td>
							</tr>
							<cfoutput group="RHDRid">
								<tr>
									<td style="background-color:##F1F1F1;">&nbsp;</td>
									<td colspan="4" style="background-color:##F1F1F1;">
									<b><cf_translate key="LB_EvaluacionDel">Evaluaci&oacute;n del</cf_translate> #LSDateFormat(rsDetalle.RHDRfinicio,'dd/mm/yyyy')# #LB_al# #LSDateFormat(rsDetalle.RHDRffin,'dd/mm/yyyy')#</b>
									</td>
								</tr>
								<cfoutput group="Item">
									<tr>
										<td>&nbsp;</td>
										<td colspan="3">
											<b>
												<cfif rsDetalle.tipo EQ 'O'>
													<cf_translate key="LB_Objetivo">Objetivo</cf_translate>:&nbsp;
												<cfelse>
													<cf_translate key="LB_Competencia">Competencia</cf_translate>:&nbsp;
												</cfif>
												#rsDetalle.CodItem#
											</b>
										</td>
									</tr>
									<cfoutput>
										<tr class="<cfif rsDetalle.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
											<td>&nbsp;</td>
											<td>&nbsp;</td>
											<td>#rsDetalle.colaborador#</td>
											<td>#rsDetalle.evaluador#</td>
											<td align="center">												
												<cfif rsDetalle.tipo EQ 'O'>
													<cfif rsDetalle.estado EQ 1>
														<img border="0" src="/cfmx/rh/imagenes/checked.gif">
													<cfelse>
														<img border="0" src="/cfmx/rh/imagenes/unchecked.gif">
													</cfif>
												<cfelse>
													#LSNumberFormat(rsDetalle.RHREnota,'999.99')#
												</cfif>
											</td>
										</tr>
									</cfoutput>
								</cfoutput>									
							</cfoutput>
						</cfoutput>
					</table>
				</div>
			</td>
		</tr>		
	<cfelse>
		<tr>
			<td align="center"><b>------ <cf_translate key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> ------</b></td>
		</tr>
	</cfif>	
	<tr><td>&nbsp;</td></tr>
</table>