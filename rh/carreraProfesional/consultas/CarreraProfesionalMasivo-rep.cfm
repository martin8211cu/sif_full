<cf_templatecss>
<style>
	.cortefuncional{ background-color:#FFFFEE;}
</style>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ConsultaCarreraProfesionalMasivo" Default="Consulta de Carrera Profesional Masivo" returnvariable="LB_Titulo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Indefinido" Default="Indefinido" returnvariable="LB_Indefinido"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NoSeEncontraronRegistros" Default="No se encontraron registros" returnvariable="LB_NoSeEncontraronRegistros"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_EmpleadosInactivos" Default="Empleados Inactivos" returnvariable="LB_EmpleadosInactivos"/>
<cfquery name="rsDatos" datasource="#session.DSN#">
	select 	d.DEid
			,d.DEidentificacion
			,<cf_dbfunction name="concat" args="d.DEapellido1,' ',d.DEapellido2,' ',d.DEnombre"> as Empleado
			,<cf_dbfunction name="concat" args="b.CCPcodigo,' - ',b.CCPdescripcion"> as ConceptoCarreraP
			,a.LTvalor
			,b.CCPvalor
			,c.TCCPid
			,c.TCCPdesc
			,e.UECPdescripcion
			,a.LTdesde
			,a.LThasta
			,<cf_dbfunction name="concat" args="f.CIcodigo,' - ',f.CIdescripcion"> as ConceptoPago
			,b.CCPequivalenciapunto
			,b.CCPfactorpunto
			,coalesce((select max(y.CFid)
						from LineaTiempo x , RHPlazas y
						where  x.DEid = a.DEid
							and x.RHPid = y.RHPid
							and (a.LTdesde between x.LTdesde and x.LThasta
									or  a.LThasta between x.LTdesde and x.LThasta
								)				
						),0) as CFid
			,coalesce((select max(<cf_dbfunction name="concat" args="z.CFcodigo,' - ',z.CFdescripcion">)
						from LineaTiempo x , RHPlazas y,CFuncional z
						where  x.DEid = a.DEid
							and x.RHPid = y.RHPid
							and y.CFid = z.CFid
							and (a.LTdesde between x.LTdesde and x.LThasta
									or  a.LThasta between x.LTdesde and x.LThasta
								)				
						),'#LB_EmpleadosInactivos#') as Cfuncional
			,b.CCPid			
	from LineaTiempoCP a
		inner join ConceptosCarreraP b
			on a.CCPid = b.CCPid
			<cfif isdefined("url.TCCPid") and len(trim(url.TCCPid))>
				and b.TCCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TCCPid#">
			</cfif>
			<cfif isdefined("url.CCPid") and len(trim(url.CCPid))>
				and b.CCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CCPid#">
			</cfif>
		inner join TipoConceptoCP c
			on b.TCCPid = c.TCCPid
		inner join UnidadEquivalenciaCP e
			on b.UECPid = e.UECPid
		inner join DatosEmpleado d
			on a.DEid = d.DEid
		inner join CIncidentes f
			on b.CIid = f.CIid	
	where 1 = 1	
	<cfif isdefined("url.CFid") and len(trim(url.CFid))>
		and exists (select 1
					from LineaTiempo x , RHPlazas y
					where  x.DEid = a.DEid
						and x.RHPid = y.RHPid
						and (a.LTdesde between x.LTdesde and x.LThasta
								or  a.LThasta between x.LTdesde and x.LThasta
							)
						and y.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
					)
	</cfif>
	<cfif isdefined("url.desde") and len(trim(url.desde)) and isdefined("url.hasta") and len(trim(url.hasta))>
		and a.LTdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.hasta)#">
		and a.LThasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.desde)#">
	<cfelseif isdefined("url.desde") and len(trim(url.desde)) and (not isdefined("url.hasta") or len(trim(url.hasta)) EQ 0)>
		and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.desde)#"> between a.LTdesde and a.LThasta
	<cfelseif isdefined("url.hasta") and len(trim(url.hasta)) and (not isdefined("url.desde") or len(trim(url.desde)) EQ 0)>
		and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.hasta)#"> between a.LTdesde and a.LThasta
	</cfif>
	order by a.DEid
</cfquery>
<cfquery name="rsDatos" dbtype="query">
	select * from rsDatos 
	order by CFid desc,Empleado,TCCPid,CCPid,LTdesde
</cfquery>

<cfset parametros = '?1=1'>
<cfif isdefined("url.CCPid") and len(trim(url.CCPid))>
	<cfset parametros = parametros & '&CCPid=#url.CCPid#'>
</cfif>
<cfif isdefined("url.TCCPid") and len(trim(url.TCCPid))>
	<cfset parametros = parametros & '&TCCPid=#url.TCCPid#'>
</cfif>
<cfif isdefined("url.CFid") and len(trim(url.CFid))>
	<cfset parametros = parametros & '&CFid=#url.CFid#'>
</cfif>
<cfif isdefined("url.desde") and len(trim(url.desde))>
	<cfset parametros = parametros & '&desde=#url.desde#'>
</cfif>
<cfif isdefined("url.hasta") and len(trim(url.hasta))>
	<cfset parametros = parametros & '&hasta=#url.hasta#'>
</cfif>

<cfoutput>
	<cf_htmlReportsHeaders 
		irA="CarreraProfesionalMasivo.cfm"
		FileName="CarreraProfesionalMasivo_#session.usuario#.xls"					
		title="#LB_Titulo#"
		param="#parametros#">
</cfoutput>

<table width="98%" cellpadding="0" cellspacing="0" align="center">
	<cfif rsDatos.RecordCount EQ 0>
		<tr><td align="center">------ <cfoutput>#LB_NoSeEncontraronRegistros#</cfoutput> ------</td></tr>
	<cfelse>
		<tr>
			<td align="center"><strong style="font-size:16px;"><cfoutput>#session.Enombre#</cfoutput></strong></td>
		</tr>
		<tr>
			<td align="center"><strong style="font-size:14px;"><cfoutput>#LB_Titulo#</cfoutput></strong></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td width="100%">
				<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
					<tr>
						<td style="background-color:#CCCCCC;" width="1%">&nbsp;</td>
						<td style="background-color:#CCCCCC;" width="1%">&nbsp;</td>
						<td style="background-color:#CCCCCC;" width="15%"><strong><cf_translate key="LB_Tipo">Tipo</cf_translate></strong></td>
						<td style="background-color:#CCCCCC;" width="30%"><strong><cf_translate key="LB_ConceptoDeCarreraProfesional">Concepto de Carrera Profesional</cf_translate></strong></td>
						<td style="background-color:#CCCCCC;" width="15%"><strong><cf_translate key="LB_ConceptoPago">Concepto de Pago</cf_translate></strong></td>
						<td style="background-color:#CCCCCC;" width="10%"><strong><cf_translate key="LB_Desde">Desde</cf_translate></strong></td>
						<td style="background-color:#CCCCCC;" width="10%"><strong><cf_translate key="LB_Hasta">Hasta</cf_translate></strong></td>
						<td style="background-color:#CCCCCC;" width="5%"><strong><cf_translate key="LB_Valor">Valor</cf_translate></strong></td>
						<td style="background-color:#CCCCCC;" width="5%"><strong><cf_translate key="LB_Equivalencia">Equivalencia</cf_translate></strong></td>
						<td style="background-color:#CCCCCC;" width="5%" nowrap>&nbsp;<strong><cf_translate key="LB_Factor">Factor</cf_translate></strong></td>
					</tr>
					<cfoutput query="rsDatos" group="CFid">
						<tr>												
							<td class="titulolistas" colspan="10"><strong>#Cfuncional#</strong></td>
						</tr>
						<cfset corteempleado = ''>
						<cfoutput>						
							<cfif corteempleado NEQ DEid>
								<tr>
									<td style="cursor:pointer;" onClick="javascript:funcDetalle(#DEid#);">&nbsp;</td>
									<td colspan="9" style="cursor:pointer;" onClick="javascript:funcDetalle(#DEid#);">
										<strong>#DEidentificacion#&nbsp;-&nbsp;#Empleado#</strong>
									</td>
								</tr>
							</cfif>							
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>#TCCPdesc#</td>
								<td>#ConceptoCarreraP#</td>
								<td>#ConceptoPago#</td>
								<td>#LSdateFormat(LTdesde,'dd/mm/yyyy')#</td>
								<td>
									<cfif LSdateFormat(LThasta,'dd/mm/yyyy') EQ '01/01/6100'>
										#LB_Indefinido#
									<cfelse>
										#LSdateFormat(LThasta,'dd/mm/yyyy')#
									</cfif>
								</td>
								<td>#LSNumberFormat(valor,'0.99')#&nbsp;#UECPdescripcion#</td>
								<td  width="5%" align="center">#LSNumberFormat(CCPequivalenciapunto,'0.99')#</td>							
								<td width="7%" align="center">#LSNumberFormat(CCPfactorpunto,'0.99')#</td>			
							</tr>
							<cfset corteempleado = DEid>
						</cfoutput>
					</cfoutput>
				</table>
			</td>
		</tr>
	</cfif>
</table>
<script type="text/javascript" language="javascript1.2">
	function funcDetalle(prn_deid){
		<cfset parametros = parametros & '&masivo=1&DEid='>
		<cfoutput>location.href='CarreraProfesionalPersona-form.cfm#parametros#'+prn_deid;</cfoutput>
	}
</script>
