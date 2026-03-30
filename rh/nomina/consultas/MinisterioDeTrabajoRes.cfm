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

<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">

	<cfinclude template="/rh/Utiles/params.cfm">
		<cfoutput>#pNavegacion#</cfoutput>
        <cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
            <form name="filtro" method="post" action="MinisterioDeTrabajoRes-form.cfm">
                <table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
                    <tr><td colspan="2">&nbsp;</td></tr>
                    <tr>
                      	<td width="50%">
                       		<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
                            	<cf_translate key="LB_ReporteResumidoDelMinisterioDeTrabajoConLaInformacionDeLosCentrosDeCosto. ">
                            	Reporte Resumido del Ministerio de Trabajo con la informaci&oacute;n de los Centros de Costo.
                                </cf_translate>
                        	<cf_web_portlet_end>
                      	</td>
                        <td>
                        	<table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
                            	 <tr>
                                        <td width="30%" align="right" nowrap> <strong>
                                      <cf_translate  key="LB_TipoDeNomina">Tipo de N&oacute;mina</cf_translate> :&nbsp;</strong></td>
                                  <td colspan="3">
								  			<cfoutput>
											<cf_rhtiponominaCombo index="0" form="filtro">
											</cfoutput>
											
                                        	<!---<select name="Tcodigo">
												<cfoutput query="rsTiposNomina"> 
                                                    <option value="#Tcodigo#">#Tdescripcion#</option>
                                                </cfoutput>
                                            </select>--->
                                      </td>
                                    </tr>
                                    <tr>
                                    	<td nowrap align="right"> <strong><cf_translate  key="LB_Mes">Mes</cf_translate> :&nbsp;</strong></td>
                                      <td width="8%"><cf_meses></td>
                                        <td width="7%" align="right" nowrap> <strong>
                                      <cf_translate  key="LB_Periodo">Periodo</cf_translate> :&nbsp;</strong></td>
                                      <td width="55%"><cf_rhperiodos name="anno"></td>
                                  </tr>
                            </table>
                        </td>
                   	</tr>
                    <tr><td colspan="2">&nbsp;</td></tr>
                    <tr><td nowrap align="center" colspan="2"><cf_botones values="Generar"></td></tr>
              </table>
          </form>
	<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms form="filtro">
	<cf_qformsrequiredfield args="Tcodigo,#LB_TipoDeNomina#">
    <cf_qformsrequiredfield args="Mes,#LB_Mes#">
	<cf_qformsrequiredfield args="anno,#LB_Anno#">
</cf_qforms>

