<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_nav__SPdescripcion" Default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<cfinvoke Key="LB_Todos" Default="--- Todos ---" returnvariable="LB_Todos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Asociados" Default="Asociados" returnvariable="LB_Asociados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_NoAsociados" Default="No Asociados" returnvariable="LB_NoAsociados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Codigo" Default="C&oacute;digo"	 returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Descripcion" Default="Descripci&oacute;n"	 returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_NoSeEncontraronRegistros" Default="No se encontraron registros"	 returnvariable="LB_NoSeEncontraronRegistros" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_ListaDeAnticipos" Default="Lista de Anticipos"	 returnvariable="LB_ListaDeAnticipos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Nomina" Default="N&oacute;mina" returnvariable="LB_Nomina" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_CalendarioDePago" Default="Calendario de Pago"	 returnvariable="LB_CalendarioDePago" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">

	<cfinclude template="/rh/Utiles/params.cfm">
		<cfoutput>#pNavegacion#</cfoutput>
        <cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
            <form name="form1" method="post" action="DescuentosPendientes-form.cfm">
                <table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
                    <tr><td colspan="2">&nbsp;</td></tr>
                    <tr>
						<td width="50%" valign="top">
                       		<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
                            	<cf_translate key="LB_DescuentosPendientes">
                            		Reporte por tipo de ancitipo, que detalla la información de los Asociados que lo tengan. Entre la información están
									los descuentos por aplicar y saldo de la operación.
                                </cf_translate>
                        	<cf_web_portlet_end>
                      	</td>
                        <td>
                        	<table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
                            	<tr>
                                	<td align="right" nowrap="nowrap"><cf_translate key="LB_TipoDeAnticipo">Tipo de Anticipo</cf_translate>:</td>
                                    <td>
                                    	<cf_conlis
										   campos="ACCTid,ACCTcodigo,ACCTdescripcion"
										   desplegables="N,S,S"
										   modificables="N,S,N"
										   size="0,20,40"
										   title="#LB_ListaDeAnticipos#"
										   tabla="ACCreditosTipo"
										   columnas="ACCTid,ACCTcodigo,ACCTdescripcion"
										   filtro="Ecodigo = #session.Ecodigo#"
										   desplegar="ACCTcodigo,ACCTdescripcion"
										   filtrar_por="ACCTcodigo,ACCTdescripcion"
										   etiquetas="#LB_Codigo#,#LB_Descripcion#"
										   formatos="S,S"
										   align="left,left"
										   asignar="ACCTid,ACCTcodigo,ACCTdescripcion"
										   asignarformatos="S,S,S"
										   showemptylistmsg="true"
										   emptylistmsg="-- #LB_NoSeEncontraronRegistros# --"
										   tabindex="1"> 
										
                                    </td>
                                </tr>
								<tr>
                                	<td align="right"><cf_translate key="LB_Nomina">N&oacute;mina</cf_translate>:</td>
                                    <td><cf_rhcalendariopagos descsize="30" historicos="true"></td>
                                </tr>
								<tr>
                                	<td align="right" nowrap>&nbsp;</td>
                                    <td>
										<input name="chkTotales" id="chkTotales" type="checkbox">
										<label for="chkTotales" style="font-style:normal; font-variant:normal; font-weight:normal"><cf_translate key="LB_TotalesDeColumna">Totales por Columna y Total General</cf_translate></label>
									</td>
                                </tr>
                            </table>
                        </td>
                   	</tr>
                    <tr><td colspan="2">&nbsp;</td></tr>
                    <tr><td nowrap align="center" colspan="2"><cf_botones values="Generar" tabindex="1"></td></tr>
              </table>
          </form>
	<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms form="form1">
	<cf_qformsrequiredfield args="Tcodigo,#LB_Nomina#">
	<cf_qformsrequiredfield args="CPid,#LB_CalendarioDePago#">
</cf_qforms>