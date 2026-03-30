<!--- ReporteLibroSalariosFiltro.cfm --->
<cfinvoke Key="LB_EmpleadoInicial" Default="Empleado Inicial" returnvariable="LB_EmpleadoInicial" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_EmpleadoFinal" Default="Empleado Final" returnvariable="LB_EmpleadoFinal" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FechaRige" Default="Fecha Rige" returnvariable="LB_FechaRige"  component="sif.Componentes.Translate" method="Translate" />
<cfinvoke Key="LB_FechaVence" Default="Fecha Vence" returnvariable="LB_FechaVence" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_nav__SPdescripcion" Default="Filtros Reporte Libro de Salarios (CR)" returnvariable="LB_nav__SPdescripcion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_ListaDePuestos" Default="Lista de Puestos" returnvariable="LB_ListaDePuestos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="BTN_Consultar" Default="Consultar" returnvariable="BTN_Consultar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="C&oacute;digo"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>
<cfoutput>
  <table width="98%" align="center" border="0">
    <tr>
      <td width="80%" valign="top"><cf_web_portlet_start style="box" titulo="#LB_nav__SPdescripcion#">
          <table width="100%" align="center">
            <tr>
              <td><form action="ReporteLibroSalariosReporteCR.cfm" method="get" name="form1" style="margin:0">
                  <table width="100%" align="center" border="0" cellpadding="2" cellspacing="0" style="margin:0">
                    <tr>
                      <td scope="col" colspan="4" class="fileLabel" valign="middle" height="60" align="left">&nbsp;<strong><cf_translate key="IndicacionesReporte">Favor indicar el Empleado y el Rango de Fechas para Generar el Libro de Salarios.</cf_translate></strong>&nbsp; </td>
                    </tr>
                    <tr>
                      <td width="45%" align="right" nowrap="nowrap"><strong><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:</strong>&nbsp;</td>
                      <td width="5%"><cf_rhcfuncional size="30"></td>
                      <td width="50%" align="left"><input name="chkDependencias" type="checkbox" id="chkDependencias" value="1" />
                          <strong>Incluir dependencias</strong> </td>
                    </tr>
                    <tr>
                      <td align="right" valign="top"><strong>Puesto:&nbsp;</strong></td>
                      <td colspan="2">
					  		<cf_conlis
								campos="RHPcodigo,RHPdescpuesto"
								desplegables="S,S"
								modificables="S,N"
								size="10,25"
								title="#LB_ListaDePuestos#"
								tabla="RHPuestos"
								columnas="RHPcodigo,RHPdescpuesto"
								filtro="Ecodigo=#SESSION.ECODIGO# "
								desplegar="RHPcodigo,RHPdescpuesto"
								filtrar_por="RHPcodigo,RHPdescpuesto"
								etiquetas="#LB_Codigo#, #LB_Descripcion#"
								formatos="S,S"
								align="left,left"
								asignar="RHPcodigo,RHPdescpuesto"
								asignarformatos="S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No hay tipos de puesto definidos --"
								tabindex="1">
                      </td>
                    </tr>
                    <tr>
                      <td align="right" valign="top"><strong>#LB_EmpleadoInicial#&nbsp;:&nbsp;</strong></td>
                      <td colspan="2"><cf_rhempleado tabindex="1">
                        &nbsp;</td>
                    </tr>
                    <tr>
                      <td align="right" valign="top"><strong>#LB_EmpleadoFinal#&nbsp;:&nbsp;</strong></td>
                      <td colspan="2"><cf_rhempleado tabindex="1" index="1">
                        &nbsp;</td>
                    </tr>
                    <tr>
                      <td nowrap align="right"><strong><cf_translate  key="LB_FechaRige">Fecha Rige</cf_translate> :&nbsp;</strong></td>
                      <td colspan="2"><cf_sifcalendario form="form1" tabindex="1" name="Fdesde"></td>
                    </tr>
                    <tr>
                      <td nowrap align="right"><strong><cf_translate  key="LB_FechaVence">Fecha Vence</cf_translate> :&nbsp;</strong></td>
                      <td colspan="2"><cf_sifcalendario form="form1" tabindex="1" name="Fhasta"></td>
                    </tr>
                    <tr>
                      <th scope="row"  colspan="3" class="fileLabel"><cf_botones values="#BTN_Consultar#" tabindex="1">
                        &nbsp;</th>
                    </tr>
                  </table>
              </form></td>
            </tr>
          </table>
        <cf_web_portlet_end>
      </td>
    </tr>
  </table>
  <cf_qforms>
    <cf_qformsrequiredfield name="Fdesde" description="#LB_FechaRige#">
    <cf_qformsrequiredfield name="Fhasta" description="#LB_FechaVence#">
</cf_qforms>
</cfoutput>