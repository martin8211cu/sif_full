<cfquery name="anos" datasource="#session.dsn#">
	select distinct CPCano
	from CPTipoCambioProyectadoMes
	where Ecodigo = #session.ecodigo#
	order by CPCano
</cfquery>
<cfquery name="monedas" datasource="#session.dsn#">
	Select distinct a.Mcodigo, b.Mnombre
	from CPTipoCambioProyectadoMes a inner join Monedas b on a.Ecodigo = b.Ecodigo and a.Mcodigo = b.Mcodigo
	where a.Ecodigo = #session.ecodigo#
	order by Mnombre
</cfquery>
<cfquery name="meses" datasource="#session.dsn#">
	select distinct CPCmes, '*' as mes
	from CPTipoCambioProyectadoMes
	where Ecodigo = #session.ecodigo#
	order by CPCmes
</cfquery>
<cfset meses = convertMes(meses,'CPCmes','mes')>
<form action="ConsProyTiposCambio.cfm" method="post" name="formfiltroConsProyTC">
<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" class="AreaFiltro">
    <tr>
        <td><label for="FCPCano"><strong>A&ntilde;o : </strong></label>
	        	<select name="FCPCano" accesskey="1" tabindex="1" onchange="javascript:this.form.submit();">
						<option value="">Todos</option>
            <cfoutput query="anos">
                <option value="#anos.CPCano#" <cfif isdefined("form.FCPCano") and (anos.CPCano EQ form.FCPCano)>selected</cfif>>#anos.CPCano#</option>
            </cfoutput>        </select></td>
        <td><label for="FCPCmes"><strong>Mes : </strong></label>
        		<select name="FCPCmes" accesskey="2" tabindex="2" onchange="javascript:this.form.submit();">
						<option value="">Todos</option>
            <cfoutput query="meses">
                <option value="#meses.CPCmes#" <cfif isdefined("form.FCPCmes") and (meses.CPCmes EQ form.FCPCmes)>selected</cfif>>#meses.mes#</option>
            </cfoutput>        </select></td>
        <td><label for="FMcodigo"><strong>Moneda : </strong></label>
        		<select name="FMcodigo" accesskey="2" tabindex="2" onchange="javascript:this.form.submit();">
						<option value="">Todos</option>
            <cfoutput query="monedas">
                <option value="#monedas.Mcodigo#" <cfif isdefined("form.FMcodigo") and (monedas.Mcodigo EQ form.FMcodigo)>selected</cfif>>#monedas.Mnombre#</option>
            </cfoutput>        </select></td>
    </tr>
</table>
</form>