<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_Anno" Default="A&ntilde;o" returnvariable="LB_Anno" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Mes" Default="Mes" returnvariable="LB_Mes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_TipoDeNomina" Default="Tipo de N&oacute;mina" returnvariable="LB_TipoDeNomina" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_nav__SPdescripcion" Default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<!--- CONSULTAS --->
<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
    select ltrim(rtrim(Tcodigo)) as Tcodigo, Tdescripcion
    from TiposNomina
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<!--- FIN DE CONSULTAS --->
<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">

	<cfinclude template="/rh/Utiles/params.cfm">
		<cfoutput>#pNavegacion#</cfoutput>
        <cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
            <form name="filtro" method="post" action="RepMensualIGSS-form.cfm">
                <table width="100%" border="0" cellpadding="1" cellspacing="2" align="center">
                    <tr><td colspan="4">&nbsp;</td></tr>
                    <tr>
                        <td width="41%" align="right" nowrap> <strong>
                            <cf_translate  key="LB_Periodo">Periodo</cf_translate> :&nbsp;</strong>
                        </td>
                        <td width="4%"><cf_rhperiodos name="anno"></td>
                        <td align="right" nowrap width="11%"> <strong>
                            <cf_translate  key="LB_Mes">Mes</cf_translate> :&nbsp;</strong>
                        </td>
                        <td width="44%"><cf_meses></td>
                    </tr>
					<tr>
						<td align="right"><strong><cf_translate key="LB_TipoDeNomina">Tipo de N&oacute;mina</cf_translate>:&nbsp;</strong></td>
						<td colspan="3">
							<cfoutput>
							<cf_rhtiponominaCombo index="0" form="filtro">
							</cfoutput>
							<!---<select name="Tcodigo" id="Tcodigo" tabindex="1">
								<option value=""><cf_translate key="LB_Todos">Todos</cf_translate></option>
								<cfoutput query="rsTiposNomina">
									<option value="#Tcodigo#">#Tdescripcion#</option>
								</cfoutput>
							</select>--->
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td colspan="3">
							<input name="Tipo" id="Urbano" type="radio" tabindex="1" checked="checked" value="U">
							<label for="Urbano" style="font-style:normal;font-weight:normal"><strong><cf_translate  key="LB_Urbano">Urbano</cf_translate></strong></label>
							<input name="Tipo" id="Rural" type="radio" tabindex="1" value="R">
							<label for="Rural" style="font-style:normal;font-weight:normal"><strong><cf_translate  key="LB_Urbano">Rural</cf_translate></strong></label>
						</td>
					</tr>
					<tr>
						<td align="right" valign="top"><strong><cf_translate key="LB_Observaciones">Observaciones</cf_translate>:&nbsp;</strong></td>
						<td colspan="3"><textarea name="Obsv" cols="50" rows="5"></textarea></td>
					</tr>
                    <tr><td colspan="4">&nbsp;</td></tr>
                    <tr><td nowrap align="center" colspan="4"><cf_botones values="Generar"></td></tr>
                </table>
            </form>
		<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms form="filtro">
    <cf_qformsrequiredfield args="Mes,#LB_Mes#">
	<cf_qformsrequiredfield args="anno,#LB_Anno#">
</cf_qforms>

