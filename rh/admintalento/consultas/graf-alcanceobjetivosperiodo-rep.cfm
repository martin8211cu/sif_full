<cfinvoke key="LB_nav__SPdescripcion" default="Reporte de Alcance de Objetivos por Per&iacute;odo"  returnvariable="LB_nav__SPdescripcion" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_SiAlcanzaron" default="Si alcanzaron"  returnvariable="LB_SiAlcanzaron" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_NoAlcanzaron" default="No alcanzaron"  returnvariable="LB_NoAlcanzaron" component="sif.Componentes.Translate"  method="Translate"/>
<cf_templatecss>
<!----VARIABLES--->
<cfset vn_alcanzados = 0>
<cfset vn_sinalcanzar = 0>
<cfset vn_datosalcanzados = 0>
<cfset vn_datossinalcanzar = 0>
<cfset vn_total = 1>
<cfquery name="rsDatos" datasource="#session.DSN#">
	select 	max(a.RHDRfinicio), c.DEideval, c.RHIEid, 
			coalesce(c.RHIEestado,0) as estado, <cf_dbfunction name="concat" args="h.DEnombre,' ',h.DEapellido1,' ',h.DEapellido2"> as colaborador,
			<cf_dbfunction name="concat" args="i.DEnombre,' ',i.DEapellido1,' ',i.DEapellido2"> as evaluador
	from RHDRelacionSeguimiento a
		inner join RHRSEvaluaciones b
			on a.RHDRid = b.RHDRid
		
		inner join DatosEmpleado h
			on b.DEid = h.DEid	
		inner join DatosEmpleado i
			on b.DEideval = i.DEid	

		inner join RHRERespuestas c
			on b.RHRSEid = c.RHRSEid
			<cfif isdefined("form.opt") and form.opt EQ 2 and isdefined("form.RHOSid") and len(trim(form.RHOSid))><!---======== POR OBJETIVO (Filtro de objetivo) ========---->
				inner join RHItemEvaluar d
					on c.RHIEid = d.RHIEid 
				inner join RHObjetivosSeguimiento e
					on d.RHOSid = e.RHOSid
					and e.RHOSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOSid#">
			</cfif>
			<cfif isdefined("form.opt") and form.opt EQ 3 and isdefined("form.DEid") and len(trim(form.DEid))><!---======== POR PERSONA (Filtro de empleado) ========---->
				and c.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			</cfif>
	where a.RHDRestado = 30 <!---Solo las instancias cerradas---->
		<!---========= FILTRO DE EVALUACION  =========---->
		<cfif isdefined("form.RHDRid") and len(trim(form.RHDRid))>
			and a.RHDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDRid#">
		</cfif>
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
	group by c.DEideval, c.RHIEid, coalesce(c.RHIEestado,0),
			<cf_dbfunction name="concat" args="h.DEnombre,' ',h.DEapellido1,' ',h.DEapellido2">,
			<cf_dbfunction name="concat" args="i.DEnombre,' ',i.DEapellido1,' ',i.DEapellido2">
</cfquery>

<cfquery name="rsDetalle" datasource="#session.DSN#">
	select 	c.DEid, c.DEideval, c.RHIEid, a.RHDRid, a.RHDRfinicio,a.RHDRffin,
			coalesce(c.RHIEestado,0) as estado, <cf_dbfunction name="concat" args="h.DEnombre,' ',h.DEapellido1,' ',h.DEapellido2"> as colaborador,
			<cf_dbfunction name="concat" args="i.DEnombre,' ',i.DEapellido1,' ',i.DEapellido2"> as evaluador,
			j.RHRSdescripcion, a.RHRSid
			,o.RHOSid, o.RHOScodigo, o.RHOStexto
			
	from RHDRelacionSeguimiento a
		inner join RHRSEvaluaciones b
			on a.RHDRid = b.RHDRid
		
		inner join DatosEmpleado h
			on b.DEid = h.DEid	
		inner join DatosEmpleado i
			on b.DEideval = i.DEid
		inner join RHRelacionSeguimiento j
			on a.RHRSid = j.RHRSid		

		inner join RHRERespuestas c
			on b.RHRSEid = c.RHRSEid
			<cfif isdefined("form.opt") and form.opt EQ 2 and isdefined("form.RHOSid") and len(trim(form.RHOSid))><!---======== POR OBJETIVO (Filtro de objetivo) ========---->
				inner join RHItemEvaluar d
					on c.RHIEid = d.RHIEid 
				inner join RHObjetivosSeguimiento e
					on d.RHOSid = e.RHOSid
					and e.RHOSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOSid#">
			</cfif>
			<cfif isdefined("form.opt") and form.opt EQ 3 and isdefined("form.DEid") and len(trim(form.DEid))><!---======== POR PERSONA (Filtro de empleado) ========---->
				and c.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			</cfif>
		inner join RHItemEvaluar m
			on c.RHIEid = m.RHIEid
		inner join RHObjetivosSeguimiento o
			on m.RHOSid = o.RHOSid
							
	where a.RHDRestado = 30 <!---Solo las instancias cerradas---->
		<!---========= FILTRO DE EVALUACION  =========---->
		<cfif isdefined("form.RHDRid") and len(trim(form.RHDRid))>
			and a.RHDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDRid#">
		</cfif>
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
	order by a.RHDRid,o.RHOSid		
</cfquery>

<cfquery name="rsAlcanzados" dbtype="query">
	select count(1) as alcanzados
	from rsDatos
	where estado = 1
</cfquery>
<cfquery name="rsSinAlcanzar" dbtype="query">
	select count(1) sinalcanzar
	from rsDatos
	where estado = 0
</cfquery>

<cfif isdefined("form.opt") and form.opt EQ 2>
	<!--- DATOS DEL OBJETIVO--->
	<cfquery name="rsObjetivo" datasource="#session.DSN#">
		select RHOScodigo, RHOStexto
		from RHObjetivosSeguimiento
		where RHOSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOSid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
<cfelseif isdefined("form.opt") and form.opt EQ 3>
	<!----DATOS DE LA PERSONA ----->
	<cfquery name="rsPersona" datasource="#session.DSN#">
		select <cf_dbfunction name="concat" args="DEapellido1,' ',DEapellido2,' ',DEnombre"> as Persona
		from DatosEmpleado
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<cfif isdefined("rsAlcanzados") and rsAlcanzados.RecordCount NEQ 0>
	<cfset vn_datosalcanzados = rsAlcanzados.alcanzados>
</cfif>
<cfif isdefined("rsSinAlcanzar") and rsSinAlcanzar.RecordCount NEQ 0>
	<cfset 	vn_datossinalcanzar = rsSinAlcanzar.sinalcanzar>
</cfif>
<cfset vn_total = rsDatos.RecordCount>

<cfif rsDatos.RecordCount NEQ 0>
	<cfset vn_alcanzados = (100*vn_datosalcanzados)/vn_total>
	<cfset vn_sinalcanzar = (100*vn_datossinalcanzar)/vn_total>
</cfif>

	<cfset LvarFileName = "GraficoAlcanceObjetivos#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
	<cf_htmlReportsHeaders 
		title="#LB_nav__SPdescripcion#" 
		filename="#LvarFileName#"
		irA="graf-alcanceobjetivosperiodo-filtro.cfm"
		download="no">
	<table width="98%" cellpadding="1" cellspacing="0" border="0" align="center">
		<!---- Encabezado ---->
		<CFOUTPUT>	
		<tr>
			<td colspan="2" valign="top">
				<table width="98%" align="center">
					<tr>
						<td>
							<cfinvoke key="LB_Periodo" default="Per&iacute;odo" returnvariable="LB_Periodo" component="sif.Componentes.Translate"  method="Translate"/>
							<cfinvoke key="LB_del" default="del" returnvariable="LB_del" component="sif.Componentes.Translate"  method="Translate"/>
							<cfinvoke key="LB_al" default="al" returnvariable="LB_al" component="sif.Componentes.Translate"  method="Translate"/>
							<cfinvoke key="LB_Indefinido" default="Indefinido" returnvariable="LB_Indefinido" component="sif.Componentes.Translate"  method="Translate"/>
							<cfinvoke key="LB_Objetivo" default="Objetivo" returnvariable="LB_Objetivo" component="sif.Componentes.Translate"  method="Translate"/>
							<cfinvoke key="LB_Colaborador" default="Colaborador" returnvariable="LB_Colaborador" component="sif.Componentes.Translate"  method="Translate"/>
							<cfset filtro1='#LB_Periodo#'>								
							<cfset filtro2 = ''>
							<cfif isdefined("form.finicio") and len(trim(form.finicio)) and isdefined("form.ffin") and len(trim(form.ffin))>
								<cfset filtro1=filtro1 & ' #LB_del# #LSDateFormat(form.finicio,'dd/mm/yyyy')# #LB_al# #LSDateFormat(form.ffin,'dd/mm/yyyy')#'>										
							<cfelseif (not isdefined("form.finicio") or len(trim(form.finicio)) EQ 0) and (not isdefined("form.ffin") or len(trim(form.ffin)) EQ 0)>
								<cfset filtro1=filtro1 & ' #LB_Indefinido#'>
							</cfif>
							<cfif isdefined("form.opt") and form.opt EQ 2>
								<cfset filtro2= '#LB_Objetivo#: #rsObjetivo.RHOScodigo# - #rsObjetivo.RHOStexto#'>
							<cfelseif isdefined("form.opt") and form.opt EQ 3>
								<cfset filtro2= '#LB_Colaborador#: #rsPersona.Persona#'>
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
			</td>
		</tr>	
		</CFOUTPUT>
		<!----- Reporte ----->
		<cfif rsDatos.RecordCount NEQ 0>
			<tr>
				<td width="30%" valign="top"><!----Grafico---->
					<table width="100%" cellpadding="1" cellspacing="0" border="0" align="center">													
						<tr>
							<td align="center">				
								<CFOUTPUT>	
									<cfchart chartwidth="450" format="png" chartheight="400" show3d="yes" showBorder="no" showLegend="yes" url="javascript: funcDetalle();">
										  <cfchartseries type="pie">
											<cfchartdata item="#LB_SiAlcanzaron#" value="#NumberFormat(vn_alcanzados, '9.00')#">
											<cfchartdata item="#LB_NoAlcanzaron#" value="#NumberFormat(vn_sinalcanzar, '9.00')#">
										  </cfchartseries>
									</cfchart>
								</CFOUTPUT>					
							</td>
						</tr>												
					</table>	
				</td>				
				<td width="60%" valign="top"><!----Detalle(Datos)---->
					<div style="height:450;overflow:auto; vertical-align:text-top">
						<table width="100%" cellpadding="2" cellspacing="0" align="center" border="0">						
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
									<td width="5%" nowrap><b><cf_translate key="LB_Alcanzado">Alcanzado</cf_translate></b></td>
								</tr>
								<cfoutput group="RHDRid">
									<tr>
										<td style="background-color:##F1F1F1;">&nbsp;</td>
										<td colspan="4" style="background-color:##F1F1F1;">
										<b>Del #LSDateFormat(rsDetalle.RHDRfinicio,'dd/mm/yyyy')# al #LSDateFormat(rsDetalle.RHDRffin,'dd/mm/yyyy')#</b>
										</td>
									</tr>
									<cfset vb_bandera = false>
									<cfoutput group="RHOSid">
										<tr>
											<td>&nbsp;</td>
											<td colspan="3"><b><cf_translate key="LB_Objetivo">Objetivo</cf_translate>:&nbsp;#rsDetalle.RHOScodigo#</b></td>
										</tr>
										<cfset vb_bandera = true>
										<cfoutput>
											<tr class="<cfif rsDetalle.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
												<td>&nbsp;</td>
												<td>&nbsp;</td>												
												<td><cfif vb_bandera>#rsDetalle.colaborador# <cfset vb_bandera = false><cfelse>&nbsp;</cfif></td>
												<td>#rsDetalle.evaluador#</td>
												<td align="center">
													<cfif rsDetalle.estado EQ 1>
														<img border="0" src="/cfmx/rh/imagenes/checked.gif">
													<cfelse>
														<img border="0" src="/cfmx/rh/imagenes/unchecked.gif">
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
			<tr><td align="center"><b>----- <cf_translate key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> -----</b></td></tr>
		</cfif>	
		<tr><td>&nbsp;</td></tr>
	</table>
	<cfoutput>
		<script type="text/javascript">
			function funcDetalle(){
				var params ="";			
				<cfif isdefined("form.opt") and form.opt EQ 2 and isdefined("form.RHOSid") and len(trim(form.RHOSid))>
					params = params + '&RHOSid=#form.RHOSid#';
				</cfif>
				<cfif isdefined("form.opt") and form.opt EQ 3 and isdefined("form.DEid") and len(trim(form.DEid))>
					params = params + '&DEid=#form.DEid#';
				</cfif>
				<cfif isdefined("form.finicio") and len(trim(form.finicio))>
					params = params + '&finicio=#form.finicio#';
				</cfif>
				<cfif isdefined("form.ffin") and len(trim(form.ffin))>
					params = params + '&ffin=#form.ffin#';
				</cfif>
				window.open("/cfmx/rh/admintalento/consultas/graf-alcanceobjetivosperiodo-det.cfm?1=1"+params,"DetalleAlcanceObjetivos", "top=110,left=200,width=850,height=500,toolbar=false,resizable=yes,scrollbars=yes");			
			}
		</script>
	</cfoutput>
