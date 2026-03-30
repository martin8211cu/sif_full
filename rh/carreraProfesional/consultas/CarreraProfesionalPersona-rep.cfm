<cf_templatecss>
<style>
	.cortetipo{ background-color:#FFFFEE;}
	.titulo{background-color:#CCCCCC;}
</style>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ConsultaCarreraProfesionalPorPersona" Default="Consulta de Carrera Profesional Por Persona" returnvariable="LB_Titulo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Indefinido" Default="Indefinido" returnvariable="LB_Indefinido"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NoSeEncontraronRegistros" Default="No se encontraron registros" returnvariable="LB_NoSeEncontraronRegistros"/>
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
	from LineaTiempoCP a
		inner join ConceptosCarreraP b
			on a.CCPid = b.CCPid
		inner join TipoConceptoCP c
			on b.TCCPid = c.TCCPid
		inner join UnidadEquivalenciaCP e
			on b.UECPid = e.UECPid
		inner join DatosEmpleado d
			on a.DEid = d.DEid
		inner join CIncidentes f
			on b.CIid = f.CIid	
	where 1 = 1	
	<cfif isdefined("url.DEid") and len(trim(url.DEid))>
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	</cfif>
	<cfif isdefined("url.desde") and len(trim(url.desde)) and isdefined("url.hasta") and len(trim(url.hasta))>
		and a.LTdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.desde)#">
		and a.LThasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.hasta)#">		
	<cfelseif isdefined("url.desde") and len(trim(url.desde)) and (not isdefined("url.hasta") or len(trim(url.hasta)) EQ 0)>
		and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.desde)#"> between a.LTdesde and a.LThasta
	<cfelseif isdefined("url.hasta") and len(trim(url.hasta)) and (not isdefined("url.desde") or len(trim(url.desde)) EQ 0)>
		and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.hasta)#"> between a.LTdesde and a.LThasta
	</cfif>
	order by d.DEapellido1,d.DEapellido2,d.DEnombre,d.DEid,TCCPid, a.LTdesde
</cfquery>
<cfset parametros = '?1=1'>
<cfif isdefined("url.DEid") and len(trim(url.DEid))>
	<cfset parametros = parametros & '&DEid=#url.DEid#'>
</cfif>
<cfif isdefined("url.desde") and len(trim(url.desde))>
	<cfset parametros = parametros & '&desde=#url.desde#'>
</cfif>
<cfif isdefined("url.hasta") and len(trim(url.hasta))>
	<cfset parametros = parametros & '&hasta=#url.hasta#'>
</cfif>

<cfset irA='CarreraProfesionalPersona.cfm'>
<cfif isdefined("url.masivo")>
	<cfif isdefined("url.CFid") and len(trim(url.CFid))>
		<cfset parametros = parametros & '&CFid=#url.CFid#'>
	</cfif>
	<cfif isdefined("url.CCPid") and len(trim(url.CCPid))>
		<cfset parametros = parametros & '&CCPid=#url.CCPid#'>
	</cfif>
	<cfif isdefined("url.TCCPid") and len(trim(url.TCCPid))>
		<cfset parametros = parametros & '&TCCPid=#url.TCCPid#'>
	</cfif>
	<cfset irA='CarreraProfesionalMasivo-form.cfm#parametros#'>
</cfif>

<cfoutput>
	<cf_htmlReportsHeaders 
		irA="#irA#"
		FileName="CarreraProfesional_#session.usuario#.xls"					
		title="#LB_Titulo#"
		param="#parametros#">
</cfoutput>
<table width="98%" cellpadding="0" cellspacing="0" align="center">
	<cfif rsDatos.RecordCount EQ 0>
		<tr>
			<td><cfoutput>------ #LB_NoSeEncontraronRegistros# ------</cfoutput></td>
		</tr>
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
						<td class="titulo" width="1%">&nbsp;</td>
						<td class="titulo" width="1%">&nbsp;</td>
						<td class="titulo" width="1%">&nbsp;</td>
						<td class="titulo" width="35%"><strong><cf_translate key="LB_ConceptoCarreraProfesional">Concepto Carrera Profesional</cf_translate></strong></td>
						<td class="titulo" width="25%"><strong><cf_translate key="LB_ConceptoPago">Concepto de Pago</cf_translate></strong></td>
						<td class="titulo" width="10%"><strong><cf_translate key="LB_Desde">Desde</cf_translate></strong></td>
						<td class="titulo" width="10%"><strong><cf_translate key="LB_Hasta">Hasta</cf_translate></strong></td>
						<td class="titulo" width="5%"><strong><cf_translate key="LB_Valor">Valor</cf_translate></strong></td>
						<td class="titulo" width="5%"><strong><cf_translate key="LB_Equivalencia">Equivalencia</cf_translate></strong></td>
						<td class="titulo" width="5%">&nbsp;<strong><cf_translate key="LB_Factor">Factor</cf_translate></strong></td>
					</tr>
					<cfoutput query="rsDatos" group="DEid">
						<tr>						
							<td>&nbsp;</td>
							<td class="cortetipo" colspan="9"><strong>#Empleado#</strong></td>
						</tr>
						<cfset cortetipo = ''>
						<cfoutput>
							<cfif cortetipo NEQ TCCPid>
								<tr>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td class="titulolistas" colspan="8"><strong>#TCCPdesc#</strong></td>
								</tr>
							</cfif>
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
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
							<cfset cortetipo = TCCPid>
						</cfoutput>
					</cfoutput>
				</table>
			</td>
		</tr>
	</cfif>
</table>
