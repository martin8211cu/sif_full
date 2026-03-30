
<cfquery name="habilidades" datasource="sifcontrol">
	select HYHEcodigo, HYHEdescripcion, HYHEdescalterna
	from HYHabilidadEspecializada
	order by HYHEcodigo
</cfquery>

<cfquery name="gerencia" datasource="sifcontrol">
	select HYHGcodigo, HYHGdescripcion, HYHGdescalterna
	from HYHabilidadGerencia
	order by HYHGcodigo
</cfquery>

<cfquery name="data" datasource="sifcontrol">
	select a.HYHEcodigo, b.HYHEdescripcion, b.HYHEdescalterna, a.HYHGcodigo, 
	c.HYHGdescripcion, c.HYHGdescalterna, a.HYIHgrado, a.HYTHpuntos , a.HYTHrestrict
	from HYTHabilidades a, HYHabilidadEspecializada b, HYHabilidadGerencia c
	where a.HYHEcodigo=b.HYHEcodigo
	and a.HYHGcodigo=c.HYHGcodigo
	order by a.HYHEcodigo, a.HYHGcodigo, a.HYIHgrado
</cfquery>

<cfquery name="grados" dbtype="query">
	select distinct HYIHgrado 
	from data
	order by HYIHgrado
</cfquery>

<cfoutput>
<link type="text/css" rel="stylesheet" href="/cfmx/sif/css/asp.css">
<table width="100%" border="0" align="center">
	<tr>
		<td align="center">
			<strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
				<cf_translate key="LB_HABILIDADES">HABILIDADES</cf_translate>
			</strong>
		</td>
	</tr>
</table><br>

<table width="100%" border="1" style="border-collapse:collapse;" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan="2">&nbsp;</td>
		<td valign="top" colspan="#grados.RecordCount*gerencia.recordCount#" align="center">
			<b>* * <cf_translate key="LB_HabilidadEnGerencia">Habilidad en Gerencia</cf_translate></b>
		</td>
	</tr>

	<tr>
		<td colspan="2">&nbsp;</td>
		<cfloop query="gerencia">
			<td width="12%" valign="top" colspan="#grados.RecordCount#" align="left">
				<b>#trim(gerencia.HYHGcodigo)#. #gerencia.HYHGdescripcion#</b><br>#gerencia.HYHGdescalterna#
			</td>
		</cfloop>
	</tr>

	<tr>
		<td align="center" nowrap colspan="2"><b>* * * <cf_translate key="LB_HabilidadEnRelacionesHumanas">Habilidad en Relaciones Humanas</cf_translate></b></td>
		<cfloop query="gerencia">
			<cfloop query="grados">
				<td align="center"><b>#grados.HYIHgrado#</b></td>
			</cfloop>
		</cfloop>
	</tr>

	<cfloop query="habilidades">
		<cfset vHabilidad = habilidades.HYHEcodigo >
		<cfset vHDescripcion = habilidades.HYHEdescripcion >
		<cfset vHDescAlterna = habilidades.HYHEdescalterna >
		<cfset titulo = false>
		<cfloop query="grados">
			<tr>
				<cfif habilidades.CurrentRow eq 1 and not titulo >
					<td width="1%" valign="middle"   style="text-align: center; writing-mode:tb-rl;" rowspan="#habilidades.RecordCount*grados.RecordCount#">
						<b>* <cf_translate key="LB_HabilidadEspecializada">Habilidad Especializada</cf_translate></b>
					</td>
					<cfset  titulo = true >
				</cfif>
				<cfif grados.HYIHgrado eq 1>
					<td rowspan="#grados.RecordCount#" width="35%"><b>#vHabilidad#. #vHDescripcion#</b><br>#vHDescAlterna#</td>
					<cfloop query="gerencia">
						<cfset vGerencia = trim(gerencia.HYHGcodigo)>
						<cfloop query="grados">
							<cfset vGrado = trim(grados.HYIHgrado) >
							<cfquery name="data_1" dbtype="query">
								select * 
								from data
								where HYHEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vHabilidad#">
								  and HYIHgrado = <cfqueryparam cfsqltype="cf_sql_integer" value="#TRIM(vGrado)#">
								  and HYHGcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vGerencia#">
								order by HYHGcodigo,HYTHpuntos
							</cfquery>	
							<td rowspan="#grados.RecordCount#" valign="top">
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<cfloop query="data_1">
									<tr>
									<cfif data_1.HYTHrestrict EQ 1>
										<td align="center" bgcolor="##CCCCCC">#data_1.HYTHpuntos#</td>
									<cfelse>
										<td align="center" >#data_1.HYTHpuntos#</td>	
									</cfif>
									</tr>
								</cfloop>
								</table>
							</td>
						</cfloop>
					</cfloop>
				</cfif>
			</tr>
		</cfloop>
	</cfloop>
</table>
</cfoutput>