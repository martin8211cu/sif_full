<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_nav__SPdescripcion" Default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<cfinvoke Key="LB_Todos" Default="--- Todos ---" returnvariable="LB_Todos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Asociados" Default="Asociados" returnvariable="LB_Asociados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_NoAsociados" Default="No Asociados" returnvariable="LB_NoAsociados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Identificacion" Default="Identificación"	 returnvariable="LB_Identificacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Empleado" Default="Empleado"	 returnvariable="LB_Empleado" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_NoSeEncontraronRegistros" Default="No se encontraron registros"	 returnvariable="LB_NoSeEncontraronRegistros" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_ListaDeEmpleados" Default="Lista de Empleados"	 returnvariable="LB_ListaDeEmpleados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FechaDelAnticipoDesde" Default="Fecha del Anticipo desde"	 returnvariable="LB_FechaDelAnticipoDesde" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FechaDelAnticipoHasta" Default="Fecha del Anticipo hasta"	 returnvariable="LB_FechaDelAnticipoHasta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Codigo" Default="C&oacute;digo"	 returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Descripcion" Default="Descripci&oacute;n"	 returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_ListaDeAnticipos" Default="Lista de Anticipos"	 returnvariable="LB_ListaDeAnticipos" component="sif.Componentes.Translate" method="Translate"/>

<!--- FIN VARIABLES DE TRADUCCION --->

<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">

	<cfinclude template="/rh/Utiles/params.cfm">
		<cfoutput>#pNavegacion#</cfoutput>
        <cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
            <form name="form1" method="post" action="AnticiposEmpleado-form.cfm">
                <table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
                    <tr><td colspan="2">&nbsp;</td></tr>
                    <tr>
						<td width="50%" valign="top">
                       		<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
                            	<cf_translate key="LB_ReporteAnticipos">
                            	Reporte de Anticipos por Empleado muestra el estado de cuenta de un pr&eacute;stamo. Puede ser para un empleado o todos en un rango de fechas espec&iacute;fico.
                                </cf_translate>
                        	<cf_web_portlet_end>
                      	</td>
                        <td>
                        	<table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
                            	<tr>
                                	<td align="right"><cf_translate key="LB_Empleado">Empleado</cf_translate>:</td>
                                    <td>
                                    	<cf_conlis
										   campos="DEid,DEidentificacion,Nombre"
										   desplegables="N,S,S"
										   modificables="N,S,N"
										   size="0,20,40"
										   title="#LB_ListaDeEmpleados#"
										   tabla="DatosEmpleado a
												inner join ACAsociados b
													on b.DEid = a.DEid"
										   columnas="b.DEid, a.DEidentificacion , {fn concat({fn concat({fn concat({fn concat(a.DEapellido1 , ' ' )}, a.DEapellido2 )},  ' ' )}, a.DEnombre)} as Nombre"
										   filtro="a.Ecodigo = #session.Ecodigo# order by DEidentificacion"
										   desplegar="DEidentificacion,Nombre"
										   filtrar_por="a.DEidentificacion|{fn concat({fn concat({fn concat({fn concat(a.DEapellido1 , ' ' )}, a.DEapellido2 )},  ' ' )}, a.DEnombre)}"
										   filtrar_por_delimiters="|"
										   etiquetas="#LB_Identificacion#,#LB_Empleado#"
										   formatos="S,S"
										   align="left,left"
										   asignar="DEid,DEidentificacion,Nombre"
										   asignarformatos="S,S,S"
										   showemptylistmsg="true"
										   emptylistmsg="-- #LB_NoSeEncontraronRegistros# --"
										   tabindex="1"> 
										
                                    </td>
                                </tr>
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
                                	<td align="right" nowrap><cf_translate key="LB_FechaDesde">Fecha del Anticipo desde</cf_translate>:</td>
                                    <td>
										<cf_sifcalendario name="Fdesde" tabindex="1">
									</td>
                                </tr>
								<tr>
                                	<td align="right" nowrap><cf_translate key="LB_FechaHasta">Fecha del Anticipo hasta</cf_translate>:</td>
                                    <td>
										<cf_sifcalendario name="Fhasta" tabindex="1">
									</td>
                                </tr>
								<tr>
                                    <td>&nbsp;</td>
                                	<td align="left" nowrap>
										<input name="chkSaldoCero" id="chkSaldoCero" type="checkbox" tabindex="1"/>
										<label for="chkSaldoCero" style="font-style:normal; font-variant:normal; font-weight:normal">
											<cf_translate key="LB_MostrarSaldoCero">Mostrar saldos en cero</cf_translate>
										</label>
									</td>
                                </tr>
								<tr>
                                    <td>&nbsp;</td>
                                	<td align="left" nowrap>
										<input name="chkCorte" id="chkCorte" type="checkbox" tabindex="1"/>
										<label for="chkCorte" style="font-style:normal; font-variant:normal; font-weight:normal">
											<cf_translate key="LB_CorteDePaginaPorTipoDeCredito">Corte de p&aacute;gina por tipo de cr&eacute;dito</cf_translate>
										</label>
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
	<cf_qformsrequiredfield args="Fdesde,#LB_FechaDelAnticipoDesde#">
	<cf_qformsrequiredfield args="Fhasta,#LB_FechaDelAnticipoHasta#">
</cf_qforms>