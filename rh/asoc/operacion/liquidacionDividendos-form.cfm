<!--- Consultas de la Pantalla de Dividendos --->
<!--- Obtenemos el Periodo de ACParametros --->
<cfquery name="rsPeriodo" datasource="#Session.DSN#">
	select Pvalor from ACParametros where Pcodigo = 110
</cfquery>

<!--- Obtenemos el Mes de ACParametros --->
<cfquery name="rsMes" datasource="#Session.DSN#">
	select Pvalor from ACParametros where Pcodigo = 120
</cfquery>

<!--- Obtenemos el Tipo de Cálculo de Dividendos de ACParametros --->
<cfquery name="rsTipoFactorCalculo" datasource="#Session.DSN#">
	select Pvalor from ACParametros where Pcodigo = 50
</cfquery>

<!--- Consulta si hay registros capturados --->
<cfquery name="rsVerificaCapturados" datasource="#Session.DSN#">
	select 1 as valor
	from ACDividendos 
	where ACDperiodo = #rsPeriodo.Pvalor#
		and ACDmes = #rsMes.Pvalor#
		and ACDestado = 0
</cfquery>

<!--- Consulta si hay registros aplicados --->
<cfquery name="rsVerificaAplicados" datasource="#Session.DSN#">
	select 1 as valor
	from ACDividendos 
	where ACDperiodo = #rsPeriodo.Pvalor#
		and ACDmes = #rsMes.Pvalor#
		and ACDestado = 1
</cfquery>

<!--- Se valida un variable para mostrar la lista --->
<cfset mostrarLista = 0>
<cfif rsVerificaCapturados.RecordCount GT 0>
	<cfset mostrarLista = 1>
</cfif>
<cfif rsVerificaAplicados.RecordCount GT 0>
	<cfset mostrarLista = 1>
</cfif>

<!--- Se obtiene algunos datos despues de Calcular --->
<cfquery name="rsDatos" datasource="#Session.DSN#">
	select ACDid, ACDmonto, ACDfactor 
	from ACDividendos
	where ACDperiodo = #rsPeriodo.Pvalor#
		and ACDmes = #rsMes.Pvalor#
		and ACDestado in (0,1)
</cfquery>

<script language="JavaScript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>

<cfoutput>	
<table width="100%" cellpadding="2" cellspacing="0" style="vertical-align:top; ">

	<cfif (rsPeriodo.RecordCount GT 0 and len(trim(rsPeriodo.Pvalor)) gt 0) 
			and (rsMes.RecordCount GT 0 and len(trim(rsMes.Pvalor)) gt 0)>
		<tr>
			<td valign="top">
				<cfinclude template="liquidacionDividendos-calculo.cfm">
				<cfif mostrarLista EQ 1>
					<cfinclude template="liquidacionDividendos-lista.cfm">
				</cfif>
			</td>
		</tr>	
	<cfelse>
		<tr>
			<td valign="top">
				<cfinclude template="liquidacionDividendos-mensaje.cfm">
			</td>
		</tr>
	</cfif>
	
</table>
</cfoutput>

