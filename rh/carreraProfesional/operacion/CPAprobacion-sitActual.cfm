<cfquery name="rsSitActual" datasource="#session.DSN#">
	select 	b.CCPid, CCPcodigo, CCPdescripcion,CCPvalor,
			UECPdescripcion,TCCPdesc,coalesce(b.valor,0) as valor
			,c.CCPequivalenciapunto as puntos
			,(coalesce(c.CCPmaxpuntos,0)-coalesce(b.valor,0)) as faltante
	from RHAccionesCarreraP a
		inner join LineaTiempoCP b
			on b.DEid = a.DEid
		inner join ConceptosCarreraP c
			on c.CCPid = b.CCPid
		inner join UnidadEquivalenciaCP d
			on d.UECPid = c.UECPid
		inner join TipoConceptoCP e
			on e.TCCPid = c.TCCPid
	where RHACPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHACPlinea#">
	order by TCCPdesc
</cfquery>
<cfinvoke component="rh.carreraProfesional.Componentes.CPAplicaAccion" method="CalculaPuntos"
	datasource="#session.dsn#"
	ecodigo = "#Session.Ecodigo#"
	DEid = "#rsDatos.DEid#" returnvariable="TotalPuntos"/>

	<table width="100%" border="0" cellspacing="0" cellpadding="3" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
		<cfoutput>
			<tr><td class="#Session.Preferences.Skin#_thcenter" colspan="5"><div align="center"><cf_translate key="LB_Situacion_Actual">Situaci&oacute;n Actual</cf_translate></div></td></tr>
			<tr>
				<td colspan="5" class="corteLista"><b><cf_translate key="LB_TotalDePuntos">Total de puntos</cf_translate>:</b>&nbsp;#TotalPuntos#</td>
			</tr>
			<tr class="listTitle">
				<td>#LB_Codigo#</td>
				<td>#LB_Descripcion#</td>
				<td>#LB_Valor#</td>
				<td>#LB_Puntos#</td>
				<td>#LB_Faltante#</td>
			</tr>
		</cfoutput>
		<cfif isdefined('rsSitActual') and rsSitActual.RecordCount>
			<cfoutput query="rsSitActual" group="TCCPdesc">
				<tr><td colspan="5" class="corteLista">#TCCPdesc#</td></tr>
				<cfoutput>
					<tr>
						<td>#CCPcodigo#</td>
						<td>#CCPDescripcion#</td>
						<td>#LSNumberFormat(valor,'9.99')#&nbsp;#UECPdescripcion#</td>
						<td>#LSNumberFormat(puntos,'9.99')#</td>
						<td>#faltante#</td>
					</tr>
				</cfoutput>
			</cfoutput>
		<cfelse>
			<tr><td align="center" colspan="5"><strong><cfoutput>#LB_NoTieneConceptosDePagoRegistrados#</cfoutput></strong></td></tr>
		</cfif>
	</table>
