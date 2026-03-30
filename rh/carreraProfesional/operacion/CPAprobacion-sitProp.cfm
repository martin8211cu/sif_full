<script src="/cfmx/rh/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>

<!--- CONCEPTOS DE PAGO REGISTRADOS --->
<cfquery name="rsSitActual" datasource="#session.DSN#">
	select 	b.CCPid, CCPcodigo, CCPdescripcion,
			CCPvalor,
			UECPdescripcion
			,TCCPdesc
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
<!--- CONCEPTOS DE PAGO DE LA ACCION --->
<cfquery name="rsConceptoPA" datasource="#session.DsN#">
	select b.CCPid,b.CIid, rtrim(CCPcodigo) as CCPcodigo, rtrim(CCPdescripcion) as CCPdescripcion,
			<!---CCPvalor,---->
			valor as CCPvalor,
			UECPdescripcion,TCCPdesc
			,b.CCPequivalenciapunto as puntos
			,coalesce(a.Mcodigo,-1) as Mcodigo
			,coalesce(f.Msiglas,'') as Msiglas
			,coalesce(f.Mnombre,'') as Mnombre
			,coalesce(b.CCPmaxpuntos,0) as maximo
			,(coalesce(b.CCPmaxpuntos,0)-coalesce(CCPvalor,0)) as faltante		
	from DRHAccionesCarreraP a
		inner join ConceptosCarreraP b
			on b.CCPid = a.CCPid
			and b.CIid = a.CIid
		inner join UnidadEquivalenciaCP c
			on c.UECPid = b.UECPid
		inner join TipoConceptoCP e
			on e.TCCPid = b.TCCPid
		left outer join RHMateria f
			on a.Mcodigo = f.Mcodigo
	where RHACPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHACPlinea#">
	order by TCCPdesc
</cfquery>
<cfquery name="rsUnidadEq" datasource="#session.DSN#">
	select UECPid,UECPdescripcion
	from UnidadEquivalenciaCP 
	order by UECPid
</cfquery>
<cfquery name="rsMaterias" datasource="#session.DSN#">
	select Mcodigo,Msiglas,Mnombre
	from RHMateria
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
	<table width="100%" border="0" cellspacing="0" cellpadding="3" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">		
		<tr><td class="<cfoutput>#Session.Preferences.Skin#</cfoutput>_thcenter" colspan="5"><div align="center"><cf_translate key="LB_Situacion_Propuesta">Situaci&oacute;n Propuesta</cf_translate></div></td></tr>
		<tr>
			<td colspan="5" class="corteLista"><b><cf_translate key="LB_TotalDePuntos">Total de puntos</cf_translate>:</b>&nbsp;<cfoutput>#TotalPuntos#</cfoutput></td>
		</tr>
		<cfoutput>
		<tr class="listTitle">
			<td>#LB_Codigo#</td>
			<td>#LB_Descripcion#</td>
			<td >#LB_Valor#</td>
			<td>#LB_Puntos#</td>
			<td>#LB_Faltante#</td>
		</tr>
		</cfoutput>
		<cfif isdefined('rsSitActual') and rsSitActual.RecordCount>
			<cfoutput query="rsSitActual" group="TCCPdesc">
				<tr><td headers="20" colspan="5" class="corteLista">#TCCPdesc#</td></tr>
				<cfoutput>
					<tr height="20">
						<td nowrap="nowrap">&nbsp;#CCPcodigo#</td>
						<td nowrap="nowrap">&nbsp;#CCPdescripcion#</td>
						<td>&nbsp;&nbsp;#LSNumberFormat(CCPvalor,'9.99')#&nbsp;#UECPdescripcion#</td>
						<td>#LSNumberFormat(puntos,'9.99')#</td>
						<td>#faltante#</td>
					</tr>
				</cfoutput>
			</cfoutput>
		</cfif>
		<cfif isdefined('rsConceptoPA') and rsConceptoPA.RecordCount>
			<cfoutput query="rsConceptoPA" group="TCCPdesc">
				<tr><td headers="20" colspan="5" class="corteLista">#TCCPdesc#</td></tr>
				<cfoutput>
					<tr height="20">
						<td nowrap="nowrap">&nbsp;#CCPcodigo#</td>
						<td nowrap="nowrap">&nbsp;#CCPdescripcion#</td>
						<td>&nbsp;&nbsp;#LSNumberFormat(CCPvalor,'9.99')#&nbsp;#UECPdescripcion#</td>	
						<td>#LSNumberFormat(puntos,'9.99')#</td>
						<td>#LSNumberFormat(faltante,'9.99')#</td>
					</tr>
				</cfoutput>
			</cfoutput>
		</cfif>
		<tr><td colspan="3">&nbsp;</td></tr>
	</table>
