    <cf_translatedata name="get" tabla="RHConcursos" col="RHCdescripcion" returnvariable="LvarRHCdescripcion"> 
    <cf_translatedata name="get" tabla="CFuncional" col="CFdescripcion" returnvariable="LvarCFdescripcion">
    <cf_translatedata name="get" tabla="RHPuestos" col="RHPdescpuesto" returnvariable="LvarRHPdescpuesto">
<cfquery name="rsRHConcursos" datasource="#Session.DSN#">
	Select RHCconcurso, RHCcodigo, #LvarRHCdescripcion# as RHCdescripcion, 
		a.CFid, CFcodigo as CFcodigoresp, #LvarCFdescripcion# as CFdescripcionresp, 
		a.RHPcodigo, coalesce(b.RHPcodigoext,b.RHPcodigo) as RHPcodigoext,#LvarRHPdescpuesto# as RHPdescpuesto, RHCcantplazas, a.RHCfecha,
		RHCfapertura, RHCfcierre, a.RHCmotivo, a.RHCotrosdatos, RHCestado, a.Usucodigo, a.ts_rversion
	from RHConcursos a
		left outer join RHPuestos b
			on a.RHPcodigo = b.RHPcodigo
			and a.Ecodigo  = b.Ecodigo
		left outer join CFuncional c
			on a.CFid	   = c.CFid
			and a.Ecodigo  = c.Ecodigo
	where a.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#" >
	order by RHCdescripcion asc
</cfquery>

<cfquery name="rsBuscaPuesto" datasource="#Session.DSN#">
	select #LvarRHPdescpuesto# as RHPdescpuesto, coalesce(a.RHPcodigoext,a.RHPcodigo) as RHPcodigo
	from RHPuestos a inner join RHConcursos b
	  on a.Ecodigo   = b.Ecodigo and 
		 a.RHPcodigo = b.RHPcodigo
	where b.Ecodigo     = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and b.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#" >
</cfquery>

	<cfoutput>
		<table width="100%" height="80%" align="center" border="0" cellpadding="3" cellspacing="0">
			<tr><td colspan="2" align="center" bgcolor="##CCCCCC" style="padding:3px;"><strong><font size="2"><cf_translate key="LB_InformacionDelConcurso" xmlFile="/rh/generales.xml">Información del Concurso</cf_translate></font></strong></td></tr>
			<tr>
				<td width="15%" align="right" nowrap><strong><cf_translate key="LB_Concurso" xmlFile="/rh/generales.xml">Concurso</cf_translate>:&nbsp;</strong></td>
				<td width="65%">
					#rsRHConcursos.RHCcodigo# -  #rsRHConcursos.RHCdescripcion#
				</td>
			</tr>
			<tr>
				<td width="18%" align="right">&nbsp;&nbsp;<strong><cf_translate key="LB_Estado" xmlFile="/rh/generales.xml">Estado</cf_translate>:</strong>&nbsp;</td>
				<td align="left"> 
					<cfswitch expression="#rsRHConcursos.RHCestado#">
						<cfcase value="0"><cf_translate key="LB_EnProceso" xmlFile="/rh/generales.xml">En Proceso</cf_translate></cfcase>
						<cfcase value="10"><cf_translate key="LB_Solicitado" xmlFile="/rh/generales.xml">Solicitado</cf_translate></cfcase>
						<cfcase value="20"><cf_translate key="LB_Desierto" xmlFile="/rh/generales.xml">Desierto</cf_translate></cfcase>
						<cfcase value="30"><cf_translate key="LB_Cerrado" xmlFile="/rh/generales.xml">Cerrado</cf_translate></cfcase>
						<cfcase value="15"><cf_translate key="LB_Verificado" xmlFile="/rh/generales.xml">Verificado</cf_translate></cfcase>
						<cfcase value="40"><cf_translate key="LB_Revisión" xmlFile="/rh/generales.xml">Revisión</cf_translate></cfcase>
						<cfcase value="50"><cf_translate key="LB_Aplicado" xmlFile="/rh/generales.xml">Aplicado</cf_translate></cfcase>
						<cfcase value="60"><cf_translate key="LB_Evaluando" xmlFile="/rh/generales.xml">Evaluando</cf_translate></cfcase>
					</cfswitch>
				</td>
			</tr>					
			<tr>
				<td align="right" width="45%"><strong><cf_translate key="LB_CentroFuncional" xmlFile="/rh/generales.xml">Centro Funcional</cf_translate>:&nbsp;</strong></td>
				<td align="left"  width="55%">#rsRHConcursos.CFcodigoresp# - #rsRHConcursos.CFdescripcionresp#</td>
			</tr>
			<tr>
				<td align="right" width="22%" nowrap><strong><cf_translate key="LB_FechaApertura" xmlFile="/rh/generales.xml">Fecha Apertura</cf_translate>:&nbsp;</strong></td>
				<td align="left" width="10%"><cf_locale name="date" value="#rsRHConcursos.RHCfapertura#"/></td>
			</tr>
			<tr>
				<td align="right" width="15%" nowrap><strong><cf_translate key="LB_FechaCierre" xmlFile="/rh/generales.xml">Fecha Cierre</cf_translate>:</strong>&nbsp;</td>
				<td align="left" width="10%"><cf_locale name="date" value="#rsRHConcursos.RHCfcierre#"/></td>					
			</tr>
			<tr>
				<td align="right" width="15%"><strong><cf_translate key="LB_Puesto" xmlFile="/rh/generales.xml">Puesto</cf_translate>:&nbsp;</strong></td>
				<td align="left"  width="75%">#rsBuscaPuesto.RHPcodigo#- #rsBuscaPuesto.RHPdescpuesto#</td>
			</tr>
			<tr>
				<td align="right" width="15%"><strong><cf_translate key="LB_NPlazas" xmlFile="/rh/generales.xml">N° Plazas</cf_translate>;</strong></td>
				<td align="left"  width="10%">#rsRHConcursos.RHCcantplazas#</td>
			</tr>
	</table>
</cfoutput>