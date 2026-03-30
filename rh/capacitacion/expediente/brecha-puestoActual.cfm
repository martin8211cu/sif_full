<!----
<cfif isdefined("url.DEId") and len(trim(url.DEid))>
	<cfset form.DEid = url.DEid>
</cfif>

<!--- Instancia del componente de Expediente --->
<cfinvoke component="rh.capacitacion.expediente.expediente" method="init" returnvariable="expediente"> 
<cfset puesto = expediente.puestoEmpleado(form.DEid, session.Ecodigo) >
<cfset cf     = expediente.cfEmpleado(form.DEid, session.Ecodigo) >
<cfinclude template="competencias-querys.cfm">


<cfset total_competencias = 0 >
<cfif habilidades_requeridas.recordcount gt 0>
	<cfoutput query="habilidades_requeridas">
		<cfset total_competencias = total_competencias + habilidades_requeridas.peso>
	</cfoutput>
</cfif>
<cfif conocimientos_requeridos.recordcount gt 0>
	<cfoutput query="conocimientos_requeridos">
		<cfset total_competencias = total_competencias + conocimientos_requeridos.peso>
	</cfoutput>
</cfif>

<cfquery name="habilidades_obtenidas_pct" datasource="#Session.DSN#">
	select coalesce(sum(b.RHCEdominio * a.RHHpeso / 100.0), 0.0) as nota
	from RHHabilidadesPuesto a
		inner join RHCompetenciasEmpleado b
			on b.idcompetencia = a.RHHid
			and b.Ecodigo = a.Ecodigo
			and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and b.tipo = 'H'
			and b.RHCEfdesde >= (
								 select max(c.RHCEfdesde) from RHCompetenciasEmpleado c
								 where c.DEid = b.DEid
								   and c.Ecodigo = b.Ecodigo 
								   and c.tipo = b.tipo
								   and c.idcompetencia = b.idcompetencia
								 )

	where a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#puesto.RHPcodigo#">
	  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

<cfquery name="conocimientos_obtenidos_pct" datasource="#Session.DSN#">
	select coalesce(sum(b.RHCEdominio * a.RHCpeso / 100.0), 0.0) as nota
	from RHConocimientosPuesto a
		inner join RHCompetenciasEmpleado b
			on b.idcompetencia = a.RHCid
			and b.Ecodigo = a.Ecodigo
			and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and b.tipo = 'C'
			and b.RHCEfdesde >= (
								 select max(c.RHCEfdesde) from RHCompetenciasEmpleado c
								 where c.DEid = b.DEid
								   and c.Ecodigo = b.Ecodigo 
								   and c.tipo = b.tipo
								   and c.idcompetencia = b.idcompetencia
								 )

	where a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#puesto.RHPcodigo#">
	  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>
<cfset total_competencias_obtenidas = habilidades_obtenidas_pct.nota + conocimientos_obtenidos_pct.nota>

<!---<cfquery name="rsBrecha" datasource="#session.DSN#">
	
</cfquery>--->

<table width="100%" align="center" cellpadding="0" cellspacing="0" >
	<TR>
		<TD>
			<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Progreso en el Puesto">
			<table width="99%" align="center" cellpadding="0" cellspacing="0" >
			<cfif total_competencias gt 0 >
				<tr><td>&nbsp;</td></tr>
				<tr><td align="center">
				<cfset tiene = (100 * total_competencias_obtenidas) / total_competencias>
				<cfset falta = 100 - tiene>
				<CFOUTPUT>	
				<cfchart chartwidth="250" format="png" chartheight="250" show3d="yes" showBorder="yes">
					  <cfchartseries type="pie"  >
						<cfchartdata item="Porcentaje que falta" value="#NumberFormat(falta, '9.00')#">
						<cfchartdata item="Porcentaje que posee" value="#NumberFormat(tiene, '9.00')#">
					  </cfchartseries>
				</cfchart>
				</CFOUTPUT>
				</td></tr>
				<tr><td>&nbsp;</td></tr>
			<cfelse>
				<cfset tiene = (100 * total_competencias_obtenidas) >
				<cfset falta = 0 >
				<tr><td align="center">- No existe informaci&oacute;n para generar el reporte - </td></tr>
			</cfif>
			</table>
			<cf_web_portlet_end>
		</TD>
	</TR>		
</table>
---->
