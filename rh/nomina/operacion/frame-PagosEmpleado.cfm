<cfquery name="rsPvalor" datasource="#session.DSN#">
	select <cf_dbfunction name="to_float" args="FactorDiasSalario"> as dias, RChasta
	from TiposNomina t, RCalculoNomina r
	where t.Ecodigo = r.Ecodigo
	  and t.Tcodigo = r.Tcodigo
	  and r.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
	  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfif len(trim(rsPvalor.dias)) eq 0 >
	<cfquery name="rsPvalor" datasource="#session.DSN#">
		select coalesce(<cf_dbfunction name="to_float" args="Pvalor">,1) as dias,
				( select RChasta from RCalculoNomina where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#"> ) as RChasta
		
		from RHParametros
		where Pcodigo = 80 --Número de días para el Cálculo de la Nómina Mensual
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<!---
<cfquery name="rsPagosEmpleado" datasource="#Session.DSN#">
	select 	a.PEdesde, a.PEhasta, a.PEsalario, 
			round((a.PEsalario/#rsPvalor.dias#),2) as PEdiario,
			a.PEcantdias, a.PEmontores, a.PEtiporeg, b.RHTcodigo
	from PagosEmpleado a, RHTipoAccion b 
	where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
    and a.RHTid=b.RHTid
	and b.Ecodigo = #Session.Ecodigo#
	order by a.PEdesde, a.PEhasta
</cfquery>
--->

<cfquery name="rsPagosEmpleado" datasource="#Session.DSN#">
	select 	a.PEdesde, a.PEhasta, a.PEsalario, 
			case when a.PEcantdias > 0 then round((a.PEmontores/a.PEcantdias),2) else 0 end as PEdiario,
			a.PEcantdias, a.PEmontores, a.PEtiporeg, b.RHTcodigo, a.LTporcplaza, a.RHPid
			,c.RHPdescripcion, c.RHPcodigo
	from PagosEmpleado a, RHTipoAccion b, RHPlazas c
	where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
    and a.RHTid=b.RHTid
	and a.RHPid=c.RHPid
	and b.Ecodigo = #Session.Ecodigo#
	order by a.PEdesde, a.PEhasta
</cfquery>

<cfquery name="rsPagosEmpleado_0" dbtype="query">
	select * from rsPagosEmpleado where PEtiporeg = 0
</cfquery>

<cfquery name="rsPagosEmpleado_1" dbtype="query">
	select * from rsPagosEmpleado where PEtiporeg = 1
</cfquery>
<cfquery name="rsPagosEmpleado_2" dbtype="query">
	select * from rsPagosEmpleado where PEtiporeg = 2
</cfquery>

<cfset vHorasDiarias = 0 >
<cfquery name="rsHoras" datasource="#session.DSN#" >
	select RHJhoradiaria
	from RHJornadas a, LineaTiempo b
	where b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	and a.Ecodigo = #Session.Ecodigo#
	and b.Ecodigo = #Session.Ecodigo#
	and a.RHJid = b.RHJid
	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsPvalor.RChasta#"> between LTdesde and LThasta 
</cfquery>
<cfset vHorasDiarias = rsHoras.RHJhoradiaria >

	<tr>
		<td nowrap colspan="12" class="<cfoutput>#Session.Preferences.Skin#_thcenter</cfoutput>"><div align="center"><cf_translate key="LB_Salarios">Salarios</cf_translate></div></td>
	</tr>
	<tr>
		<td nowrap align="left" class="FileLabel">&nbsp;</td>
		<td nowrap align="left" class="FileLabel"><cf_translate key="LB_FechaDesde">Fecha Desde</cf_translate></td>
		<td nowrap align="left" class="FileLabel"><cf_translate key="LB_FechaHasta">Fecha Hasta</cf_translate></td>
 		<td nowrap align="left" class="FileLabel"><cf_translate key="LB_CodigoAccion">Código Acci&oacute;n</cf_translate></td>
		<td nowrap align="right" class="FileLabel" title="Plaza que el empleado utiliza."><cf_translate key="LB_Salario">Plaza</cf_translate></td>
		<td nowrap align="right" class="FileLabel" title="Porcentaje de la plaza."><cf_translate key="LB_Salario">% de Plaza</cf_translate></td>
		<td nowrap align="right" class="FileLabel"><cf_translate key="LB_Salario">Salario</cf_translate></td>
		<td nowrap align="right" class="FileLabel"><cf_translate key="LB_SalarioDiario">Salario Diario</cf_translate></td>
		<td nowrap align="right" class="FileLabel"><cf_translate key="LB_SalarioHora">Salario por Hora</cf_translate></td>		
		<td nowrap align="right" class="FileLabel"><cf_translate key="LB_Dias">D&iacute;as</cf_translate></td>
		<td nowrap align="right" class="FileLabel"><cf_translate key="LB_Monto">Monto</cf_translate></td>
		<td nowrap align="right" class="FileLabel">&nbsp;</td>
	</tr>
<cfoutput query="rsPagosEmpleado_0">
	<tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
		<td nowrap align="left" class="FileLabel">&nbsp;</td>
		<td nowrap align="left" >#LSDateFormat(PEdesde,'dd/mm/yyyy')#</td>
		<td nowrap align="left" >#LSDateFormat(PEhasta,'dd/mm/yyyy')#</td>
 		<td nowrap align="center" >#RHTcodigo#</td>
		<td nowrap align="right" >#RHPcodigo#</td>
		<td nowrap align="right" >#LTporcplaza# &nbsp;&nbsp;&nbsp;</td>
		<td nowrap align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(PEsalario,'none')# </td>
		<td nowrap align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(PEdiario,'none')#</td>
		<td nowrap align="right" ><cfif len(trim(vHorasDiarias)) and vHorasDiarias gt 0>#rsMoneda.Msimbolo# #LSCurrencyFormat(PEdiario/vHorasDiarias,'none')#<cfelse>&nbsp;</cfif></td>
		<td nowrap align="right">#PEcantdias# &nbsp;&nbsp;&nbsp;</td>
		<td nowrap align="right" >&nbsp;#rsMoneda.Msimbolo# #LSCurrencyFormat(PEmontores,'none')# </td>
		<td nowrap align="right" >&nbsp;</td>
	</tr>
</cfoutput>
<cfif rsPagosEmpleado_1.RecordCount GT 0>
	<tr>
		<td nowrap colspan="11" class="<cfoutput>#Session.Preferences.Skin#_thcenter</cfoutput>"><div align="center"><strong><cf_translate key="LB_RetroactivosRecalculados">Retroactivos Recalculados</cf_translate></strong></div></td>
	</tr>
	<cfoutput query="rsPagosEmpleado_1">
		<tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
			<td nowrap align="left" class="FileLabel">&nbsp;</td>
			<td nowrap align="left" >#LSDateFormat(PEdesde,'dd/mm/yyyy')#</td>
			<td nowrap align="left" >#LSDateFormat(PEhasta,'dd/mm/yyyy')#</td>
			<td nowrap align="center" >#RHTcodigo#</td>
			<td nowrap align="right" >#RHPcodigo#</td>
			<td nowrap align="right" >#LTporcplaza# &nbsp;&nbsp;&nbsp;</td>
			<td nowrap align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(PEsalario,'none')# </td>
			<td nowrap align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(PEdiario,'none')# </td>
            <td>&nbsp;</td>
			<td nowrap align="right" >#PEcantdias# &nbsp;&nbsp;&nbsp;</td>
			<td nowrap align="right" >&nbsp;#rsMoneda.Msimbolo# #LSCurrencyFormat(PEmontores,'none')# </td>
			<td nowrap align="right" >&nbsp;</td>
		</tr>
	</cfoutput>
</cfif>
<cfif rsPagosEmpleado_2.RecordCount GT 0>
	<tr>
		<td nowrap colspan="11" class="<cfoutput>#Session.Preferences.Skin#_thcenter</cfoutput>"><div align="center"><strong><cf_translate key="LB_RetroactivosYaPagados">Retroactivos ya Pagados</cf_translate></strong></div></td>
	</tr>
	<cfoutput query="rsPagosEmpleado_2">
		<tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
			<td nowrap align="left" class="FileLabel">&nbsp;</td>
			<td nowrap align="left" >#LSDateFormat(PEdesde,'dd/mm/yyyy')#</td>
			<td nowrap align="left" >#LSDateFormat(PEhasta,'dd/mm/yyyy')#</td>
			<td nowrap align="center" >#RHTcodigo#</td>
			<td nowrap align="right" >#RHPcodigo#</td>
			<td nowrap align="right" >#LTporcplaza# &nbsp;&nbsp;&nbsp;</td>
			<td nowrap align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(PEsalario,'none')# </td>
			<td nowrap align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(PEdiario,'none')# </td>
            <td>&nbsp;</td>
			<td nowrap align="right">#PEcantdias# &nbsp;&nbsp;&nbsp;</td>
			<td nowrap align="right" >&nbsp;#rsMoneda.Msimbolo# #LSCurrencyFormat(PEmontores,'none')# </td>
			<td nowrap align="right" >&nbsp;</td>
		</tr>
	</cfoutput>
</cfif>