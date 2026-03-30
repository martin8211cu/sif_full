	<!--- Competencias requeridas por el puesto --->
	<table width="100%" cellpadding="1" cellspacing="0" border="0">
		<tr>
			<td colspan="4"><strong><cf_translate key="LB_Competencias_Requeridas_por_el_Puesto">Competencias Requeridas por el Puesto</cf_translate></strong></td>
		</tr>
		<tr>
			<!---<td class="tituloCorte">Habilidades Requeridas</td>--->
			<td class="listaCorte" align="left" height="17" style="padding-right: 3px; " nowrap><cf_translate key="LB_Habilidades_Requeridas">Habilidades Requeridas</cf_translate></td>
			<td nowrap class="listaCorte" style="padding-right: 3px; "><cf_translate key="LB_Nivel">Nivel</cf_translate></td>
			<td nowrap class="listaCorte" style="padding-right: 3px; "><cf_translate key="LB_Peso">Peso</cf_translate></td>
			
			<td  nowrap class="listaCorte"><cf_translate key="LB_Minimo">M&iacute;nimo</cf_translate></td>
		</tr>
		<cfset total_competencias = 0 >
		<!--- Competencias requeridas del puesto --->


		<!--- se agrega para pintar la info desde autogestion --->
		<cf_translatedata name="get" tabla="RHHabilidades" col="b.RHHdescripcion" returnvariable="LvarRHHdescripcion">
		<cf_translatedata name="get" tabla="RHConocimientos" col="b.RHCdescripcion" returnvariable="LvarRHCdescripcion">

		<cfquery name="habilidades_requeridas" datasource="#session.DSN#">
			select a.RHHid, b.RHHcodigo, #LvarRHHdescripcion# as RHHdescripcion, coalesce(a.RHNnotamin,0)*100 as nota, a.RHHpeso as peso, n.RHNcodigo as nivel
			from RHHabilidadesPuesto a
			
			inner join RHHabilidades b
			on a.Ecodigo=b.Ecodigo
			and a.RHHid=b.RHHid

			inner join RHNiveles n
			on n.Ecodigo = a.Ecodigo
			and n.RHNid = a.RHNid
			
			where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#otrosdatos.RHPcodigo#">
			  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			order by b.RHHcodigo
		</cfquery>


		<cfquery name="total_conocimientos" datasource="#session.DSN#">
			select sum (RHCpeso) as peso
			from RHConocimientosPuesto a
			where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#otrosdatos.RHPcodigo#">
		   	  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>

		<cfif isdefined("form.debug")>
			<cfdump var="#total_conocimientos#">
		</cfif>


		<cfif total_conocimientos.recordcount gt 0 and total_conocimientos.peso gt 0>
			<cfset totalpesos =  total_conocimientos.peso>
		<cfelse>
			<cfset totalpesos =  1>
		</cfif>

		<cfquery name="conocimientos_requeridos" datasource="#session.DSN#">
			select a.RHCid, b.RHCcodigo, #LvarRHCdescripcion# as RHCdescripcion, coalesce(a.RHCnotamin,0)*100 as nota, a.RHCpeso as peso,(a.RHCpeso /#totalpesos#)*100  as pesoSP, n.RHNcodigo as nivel
			from RHConocimientosPuesto a
			
			inner join RHConocimientos b
			on a.Ecodigo=b.Ecodigo
			and a.RHCid=b.RHCid
			
			inner join RHNiveles n
			on n.Ecodigo = a.Ecodigo
			and n.RHNid = a.RHNid

			where a.RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#otrosdatos.RHPcodigo#">
		   	  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			order by b.RHCcodigo
		</cfquery>

		<!--- **************** --->
		<cfif habilidades_requeridas.recordcount gt 0>
			<cfoutput query="habilidades_requeridas">
				<tr>
					<td style="padding-right: 3px; ">#habilidades_requeridas.RHHdescripcion#</td>
					<td align="right" style="padding-right: 3px; ">#habilidades_requeridas.nivel#</td>
					<td align="right" style="padding-right: 3px; ">#LSNumberFormat(habilidades_requeridas.peso,'9')#</td>
					<td align="right">#LSNumberFormat(habilidades_requeridas.nota,',9.00')#%</td>
				</tr>
				<cfset total_competencias = total_competencias + habilidades_requeridas.nota >
			</cfoutput>
		<cfelse>
			<tr><td colspan="4" align="center">-<cf_translate key="LB_No_se_encontraron_registros">No se encontraron registros</cf_translate>-</td></tr>
		</cfif>
		<tr>
			<!---<td class="tituloCorte">Conocimientos Requeridos</td>--->
			<td class="listaCorte" align="left" height="17" style="padding-right: 3px; " nowrap><cf_translate key="LB_Conocimientos_Requeridos">Conocimientos Requeridos</cf_translate></td>
			<td nowrap class="listaCorte" style="padding-right: 3px; "><cf_translate key="LB_Nivel">Nivel</cf_translate></td>
			<td nowrap class="listaCorte" style="padding-right: 3px; "><cf_translate key="LB_Peso">Peso</cf_translate></td>
			<td nowrap class="listaCorte"><cf_translate key="LB_Minimo">M&iacute;nimo</cf_translate></td>
		</tr>
		<cfif conocimientos_requeridos.recordcount gt 0>
			<cfoutput query="conocimientos_requeridos">
				<tr>
					<td style="padding-right: 3px; ">#conocimientos_requeridos.RHCdescripcion#</td>
					<td align="right" style="padding-right: 3px; ">#conocimientos_requeridos.nivel#</td>
					<td align="right" style="padding-right: 3px; ">#LSNumberFormat(conocimientos_requeridos.peso,'9')#</td>
					<td align="right">#LSNumberFormat(conocimientos_requeridos.nota,',9.00')#%</td>
				</tr>
				<cfset total_competencias = total_competencias + conocimientos_requeridos.nota >
			</cfoutput>
		<cfelse> 
			<tr><td colspan="3" align="center">-<cf_translate key="LB_No_se_encontraron_registros">No se encontraron registros</cf_translate>-</td></tr>
		</cfif>

	</table>
