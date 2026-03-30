<cfquery name="referencia" datasource="sifcontrol">
	select HYMRcodigo, HYMRdescripcion, HYMRdesclaterna
	from HYMarcoReferencia
</cfquery>

<cfquery name="complejidad" datasource="sifcontrol">
	select HYCPgrado, HYCPdescripcion, HYCPdescalterna
	from HYComplejidadPensamiento
</cfquery>

<cfquery name="data" datasource="sifcontrol">
	select b.HYCPdescripcion, b.HYCPdescalterna, a.HYCPgrado, a.HYMRcodigo, a.HYTSPporcentaje,
	 c.HYMRdescripcion, c.HYMRdesclaterna , a.HYTSrestrict
	from HYTSolucionProblemas a, HYComplejidadPensamiento b, HYMarcoReferencia c
	where a.HYCPgrado=b.HYCPgrado
	and a.HYMRcodigo=c.HYMRcodigo
	order by a.HYMRcodigo, a.HYCPgrado
</cfquery>

<cfoutput>
<link type="text/css" rel="stylesheet" href="/cfmx/sif/css/asp.css">
<table width="100%" border="0" align="center">
	<tr>
		<td align="center">
			<strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
				<cf_translate key="LB_SOLUCIONDEPROBLEMAS">SOLUCIÓN DE PROBLEMAS</cf_translate>
			</strong>
		</td>
	</tr>
</table><br>

<table width="100%" border="1" style="border-collapse:collapse;" cellpadding="0" cellspacing="0">

	<tr>
		<td colspan="2">&nbsp;</td>
		<td valign="top" colspan="#complejidad.RecordCount#" align="center"><b>* * <cf_translate key="LB_ComplejidadDelPensamiento">Complejidad del Pensamiento</cf_translate></b></td>
	</tr>

	<tr>
		<td colspan="2" align="center"  valign="bottom" nowrap>
			<table width="100%" border="1" style="border-collapse:collapse;" cellpadding="0" cellspacing="0">
				<tr><td><b>* <cf_translate key="LB_ElPensamientoEstaGuiadoOCircunscritoPor">El pensamiento est&aacute; guiado o circunscrito por</cf_translate>:</b></td></tr>
			</table></td>
		<cfloop query="complejidad">
			<td valign="top">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr><td nowrap><b>#complejidad.HYCPgrado#. #complejidad.HYCPdescripcion#</b></td></tr>
					<tr><td>#complejidad.HYCPdescalterna#</td></tr>
				</table>
			</td>
		</cfloop>
	</tr>

	<cfloop query="referencia">
		<cfset vReferencia = referencia.HYMRcodigo >
		<cfset vRDescripcion = referencia.HYMRdescripcion >
		<cfset vRDescAlterna = referencia.HYMRdesclaterna >
		<cfset titulo = false>

		<tr>
			<cfif referencia.CurrentRow eq 1 and not titulo >
				<td width="1%" valign="middle"    style="text-align: center;   writing-mode:tb-rl;" rowspan="#referencia.RecordCount#" nowrap>
					<b>* <cf_translate key="LB_MarcoDeReferencia">Marco de Referencia</cf_translate></b>
				</td>
				<cfset  titulo = true >
			</cfif>
		
			<td width="35%"><b>#vReferencia#. #vRDescripcion#</b><br>#vRDescAlterna#</td>
		
		<cfloop query="complejidad">
			<cfset vComplejidad = complejidad.HYCPgrado >
			<cfquery name="data_1" dbtype="query">
				select * 
				from data
				where HYMRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vReferencia#">
				and HYCPgrado =  <cfqueryparam cfsqltype="cf_sql_integer" value="#vComplejidad#">
				order by HYTSPporcentaje
			</cfquery>
			<cfset tr1 = '' >
			<cfset tr2 = '' >
			<cfloop query="data_1">
				<cfif data_1.CurrentRow mod 2 eq 0>
					<cfif data_1.HYTSrestrict EQ 1>
						<cfset tr1 = tr1 & '<td></td><td align="center" style="color: ##990000;">#data_1.HYTSPporcentaje#%</td>'>
					<cfelse>
						<cfset tr1 = tr1 & '<td></td><td align="center" style="color: ##666666;" >#data_1.HYTSPporcentaje#%</td>'>
					</cfif>
				<cfelse>
					<cfif data_1.HYTSrestrict EQ 1>
						<cfset tr2 = tr2 & '<td align="center" style="color: ##990000;">#data_1.HYTSPporcentaje#%</td><td></td>'>	
					<cfelse>
						<cfset tr2 = tr2 & '<td align="center" style="color: ##666666;" >#data_1.HYTSPporcentaje#%</td><td></td>'>	
					</cfif>
				</cfif>
				
			</cfloop>
			<td width="15%" ><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr>#tr2#</tr><tr>#tr1#</tr></table></td>
		</cfloop>
		</tr>	
	</cfloop>
</table>
</cfoutput>