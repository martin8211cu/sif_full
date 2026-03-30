<cfif isdefined("form.Mcodigo")><cfparam name="form.Fmcodigo" default="#form.Mcodigo#"></cfif>
<cfif isdefined("form.CPCano")><cfparam name="form.Fano" default="#form.CPCano#"></cfif>
<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0"><tr><td>
<cfset monedas = getmonedas(form.cvtid)>
<cfparam name="form.Fmcodigo" default="#monedas.mcodigo#">
<cfset showEmptyMsg = false>
<cfif len(form.Fmcodigo)>
	<cfset anos = getAnosFromEscenario(form.cvtid,form.fmcodigo)>
	<cfparam name="form.Fano" default="#anos.ano#">
	<cfif len(form.Fano) and form.Fano NEQ "">
		<cfset escenariomesmonedas = getCVTCEscenarioMesMonedas(form.cvtid,form.Fano,0,form.Fmcodigo,form.PAGENUM)>
		<cfinclude template="mesesFiltro.cfm">
		<cfinvoke component='sif.Componentes.pListas'	method='pListaQuery' returnvariable='pListaRet'>
			<cfinvokeargument name='cortes' value='Mnombre'>
			<cfinvokeargument name='query' value='#escenariomesmonedas#'>
			<cfinvokeargument name='desplegar' value='mes,CPTipoCambioCompra,CPTipoCambioVenta'>
			<cfinvokeargument name='etiquetas' value='Mes,TC.Compra,TC.Venta'>
			<cfinvokeargument name='formatos' value='S,M,M'>
			<cfinvokeargument name='align' value='left,right,right'>
			<cfinvokeargument name='ajustar' value='S'>
			<cfinvokeargument name='irA' value='#GCurrentPage#'>
			<cfinvokeargument name="maxrows" value="0">
			<cfinvokeargument name='keys' value='CVTid,CPCano,CPCmes,Mcodigo'>
			<cfinvokeargument name='pageindex' value='2'>
			<cfinvokeargument name='formname' value='lista2'>
		</cfinvoke>
	<cfelse>
		<cfset showEmptyMsg = true>
	</cfif>
<cfelse>
	<cfset showEmptyMsg = true>
</cfif>
<cfif showEmptyMsg>
	<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" class="AreaFiltro">
    <tr>
        <td align="center"><strong>Lista de Tipos de Cambio<br>No se encontr&oacute; ning&uacute;n tipo de cambio.</strong></td>
    </tr>
	</table>
</cfif>
</td></tr></table>