<!--- <cfquery name="rsPagosEmpleado" datasource="#Session.DSN#">
	set nocount on
	declare @dias float
	
	select @dias = <cf_dbfunction name="to_float" args="FactorDiasSalario">
	from TiposNomina t, HRCalculoNomina r
	where t.Ecodigo = r.Ecodigo
	  and t.Tcodigo = r.Tcodigo
	  and r.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

	select @dias = coalesce(@dias, <cf_dbfunction name="to_float" args="Pvalor">)
	from RHParametros 
	where Pcodigo = 80 --Número de días para el Cálculo de la Nómina Mensual

	select 	PEdesde, PEhasta, PEsalario, 
			PEdiario = round((PEsalario/@dias),2),
			PEcantdias, PEmontores
	from PagosEmpleado 
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	order by PEdesde, PEhasta
	set nocount off
</cfquery> --->
<cfset Lvar_dias = 0>
<cfquery name="rsPagosEmpleado" datasource="#Session.DSN#">
	select FactorDiasSalario
	from TiposNomina t, HRCalculoNomina r
	where t.Ecodigo = r.Ecodigo
	  and t.Tcodigo = r.Tcodigo
	  and r.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfif rsPagosEmpleado.RecordCount and rsPagosEmpleado.FactorDiasSalario>
<cfset Lvar_dias = rsPagosEmpleado.FactorDiasSalario>
</cfif>
<cfquery name="rsPagosEmpleado" datasource="#Session.DSN#">
	select Pvalor as dias
	from RHParametros 
	where Pcodigo = 80 <!--- --Número de días para el Cálculo de la Nómina Mensual --->
</cfquery>
<cfif Lvar_dias EQ 0>
	<cfset Lvar_dias = rsPagosEmpleado.dias>
</cfif>

<cfquery name="rsPagosEmpleado" datasource="#Session.DSN#">
	select 	a.PEdesde, a.PEhasta, a.PEsalario, 
			 round((a.PEsalario/#Lvar_dias#),2) as PEdiario,
			a.PEcantdias, a.PEmontores, a.RHPid, b.RHPcodigo, b.RHPdescripcion, a.LTporcplaza
	from PagosEmpleado a, RHPlazas b
	where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	and a.RHPid = b.RHPid
	order by a.PEdesde, a.PEhasta
</cfquery>

	<tr>
		<td nowrap colspan="9" class="tituloAlterno2">Salarios</td>
	</tr>

	<cfif rsPagosEmpleado.RecordCount gt 0>
		<tr>
			<td nowrap align="left" class="FileLabel">Fecha Desde</td>
			<td nowrap align="left" class="FileLabel">Fecha Hasta</td>
			<td nowrap align="right" class="FileLabel">Salario</td>
			<td nowrap align="right" class="FileLabel">Salario Diario</td>
			<td nowrap align="right" class="FileLabel" title="Plaza que ocupa el empleado">Plaza</td>
			<td nowrap align="right" class="FileLabel" title="Porcentaje de ocupacion de la Plaza">Porcentaje</td>
			<td nowrap align="right" class="FileLabel">D&iacute;as</td>
			<td nowrap align="right" class="FileLabel">Monto</td>
			<td nowrap align="right" class="FileLabel">&nbsp;</td>
		</tr>
	
		<cfoutput query="rsPagosEmpleado">
			<tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
				<td nowrap align="left" >#LSDateFormat(PEdesde,'dd/mm/yyyy')#</td>
				<td nowrap align="left" >#LSDateFormat(PEhasta,'dd/mm/yyyy')#</td>
				<td nowrap align="right">#rsMoneda.Msimbolo# #LSCurrencyFormat(PEsalario,'none')# </td>
				<td nowrap align="right">#rsMoneda.Msimbolo# #LSCurrencyFormat(PEdiario,'none')# </td>
				<td nowrap align="right">#RHPcodigo#</td>
				<td nowrap align="right">#LTporcplaza# &nbsp;&nbsp;&nbsp; </td>
				<td nowrap align="right">#PEcantdias#</td>
				<td nowrap align="right">#rsMoneda.Msimbolo# #LSCurrencyFormat(PEmontores,'none')# </td>
				<td nowrap align="right">&nbsp;</td>
			</tr>
		</cfoutput>
	<cfelse>		
		<tr><td colspan="9" align="center"><b>No hay Pagos asociados al empleado</b></td></tr>
	</cfif>
