<cfset Lvar_Dias = 1>
<cfset Lvar_Fecha = Now()>

<cfquery name="rsData1" datasource="#Session.DSN#">
	select <cf_dbfunction name="to_float" args="FactorDiasSalario"> as Dias, RChasta as Fecha
	from TiposNomina t, HRCalculoNomina r
	where t.Ecodigo = r.Ecodigo
	  and t.Tcodigo = r.Tcodigo
	  and r.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfif rsData1.recordcount GT 0>
	<cfif len(trim(rsData1.Dias)) GT 0>
		<cfset Lvar_Dias = rsData1.Dias>
    </cfif>
    <cfif len(trim(rsData1.Fecha)) GT 0>
		<cfset Lvar_Fecha = rsData1.Fecha>
    </cfif>
</cfif>

<cfif len(trim(rsData1.Dias)) EQ 0>
    <cfquery name="rsData2" datasource="#Session.DSN#">
        select <cf_dbfunction name="to_float" args="Pvalor"> as Dias
        from RHParametros 
        where Pcodigo = 80 --Número de días para el Cálculo de la Nómina Mensual
    </cfquery>
    <cfif len(trim(rsData2.Dias)) GT 0>
		<cfset Lvar_Dias = rsData2.Dias>
    </cfif>
</cfif>

<cfquery name="rsPagosEmpleado" datasource="#Session.DSN#">
	select 	PEdesde, PEhasta, PEsalario, 
			<!---round((PEsalario/<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Dias#">),2) as PEdiario,---->
			case when PEcantdias > 0 then
					round((PEmontores/PEcantdias),2)
			else 0
			end	as PEdiario,
			PEcantdias, PEmontores, <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_Fecha#"> as RChasta
	from HPagosEmpleado 
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	order by PEdesde, PEhasta
</cfquery>

<cfset vHorasDiarias = 0 >
<cfquery name="rsHoras" datasource="#session.DSN#" >
	select RHJhoradiaria
	from RHJornadas a, LineaTiempo b
	where b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	and a.Ecodigo = #Session.Ecodigo#
	and b.Ecodigo = #Session.Ecodigo#
	and a.RHJid = b.RHJid
	and <cfqueryparam cfsqltype="cf_sql_date" value="#rsPagosEmpleado.RChasta#"> between LTdesde and LThasta 
</cfquery>
<cfset vHorasDiarias = rsHoras.RHJhoradiaria >

	<tr>
		<td nowrap colspan="8" class="tituloAlterno2"><cf_translate xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml"   key="LB_Salarios">Salarios</cf_translate></td>
	</tr>

	<cfif rsPagosEmpleado.RecordCount gt 0>
		<tr>
			<td nowrap align="left" class="FileLabel"><cf_translate xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml"   key="LB_FechaDesde">Fecha Desde</cf_translate></td>
			<td nowrap align="left" class="FileLabel"><cf_translate xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml"   key="LB_FechaHasta">Fecha Hasta</cf_translate></td>
			<td nowrap align="right" class="FileLabel"><cf_translate xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml"   key="LB_Salario">Salario</cf_translate></td>
			<td nowrap align="right" class="FileLabel"><cf_translate xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml"   key="LB_SalarioDiario">Salario Diario</cf_translate></td>
			<td nowrap align="right" class="FileLabel"><cf_translate xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml"   key="LB_SalarioHora">Salario por Hora</cf_translate></td>
			<td nowrap align="right" class="FileLabel"><cf_translate xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml"   key="LB_Dias">D&iacute;as</cf_translate></td>
			<td nowrap align="right" class="FileLabel"><cf_translate xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml"   key="LB_Monto">Monto</cf_translate></td>
			<td nowrap align="right" class="FileLabel">&nbsp;</td>
		</tr>
	
		<cfoutput query="rsPagosEmpleado">
			<tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
				<td nowrap align="left" >#LSDateFormat(PEdesde,'dd/mm/yyyy')#</td>
				<td nowrap align="left" >#LSDateFormat(PEhasta,'dd/mm/yyyy')#</td>
				<td nowrap align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(PEsalario,'none')# </td>
				<td nowrap align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(PEdiario,'none')# </td>
				<td nowrap align="right" ><cfif len(trim(vHorasDiarias)) and vHorasDiarias gt 0>#rsMoneda.Msimbolo# #LSCurrencyFormat(PEdiario/vHorasDiarias,'none')#</cfif></td>
				<td nowrap align="right" >#PEcantdias#</td>
				<td nowrap align="right" >#rsMoneda.Msimbolo# #LSCurrencyFormat(PEmontores,'none')# </td>
				<td nowrap align="right" >&nbsp;</td>
			</tr>
		</cfoutput>
	<cfelse>		
		<tr><td colspan="7" align="center"><b><cf_translate xmlfile="/rh/nomina/operacion/ResultadoCalculo.xml"   key="LB_NoHayPagosAsociadosAlEmpleado">No hay Pagos asociados al empleado</cf_translate></b></td></tr>
	</cfif>
