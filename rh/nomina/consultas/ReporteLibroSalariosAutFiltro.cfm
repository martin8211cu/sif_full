<!--- ReporteLibroSalariosAutFiltro.cfm --->
<cfinvoke key="LB_EmpleadoInicial" default="Empleado Inicial" returnvariable="LB_EmpleadoInicial" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_EmpleadoFinal" default="Empleado Final" returnvariable="LB_EmpleadoFinal" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_FechaRige" default="Fecha Rige" returnvariable="LB_FechaRige"  component="sif.Componentes.Translate" method="Translate" />
<cfinvoke key="LB_FechaVence" default="Fecha Vence" returnvariable="LB_FechaVence" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_DebeIngresarElFolio" default="Debe ingresar el folio" returnvariable="MSG_DebeIngresarElFolio" component="sif.Componentes.Translate" method="Translate"/>
<cfoutput>
<table width="90%" align="center">
	<tr>
    	<td width="80%" valign="top">
			<cf_web_portlet_start style="box" titulo="#LB_nav__SPdescripcion#">
        		<table width="100%" align="center">
                	<tr>
                    	<td>
                          	<form action="ReporteLibroSalariosAut.cfm" method="get" name="form1" style="margin:0">
                           		<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0" style="margin:0">
              						<tr>
                                        <td scope="col" colspan="2" class="fileLabel" valign="middle" height="60" align="left">
                                        &nbsp;<strong><cf_translate key="IndicacionesReporte">Favor indicar el Empleado y el Rango de Fechas para Generar el Libro de Salarios Autorizado.</cf_translate></strong>&nbsp;
                                        </td>
                            		</tr>
                                  	<tr>
                                    	<td align="right" valign="top"><strong>#LB_EmpleadoInicial#&nbsp;:&nbsp;</strong></td>
                                    	<td ><cf_rhempleado tabindex="1">&nbsp;</td>
                                  	</tr>
									<tr>
                                    	<td align="right" valign="top"><strong>#LB_EmpleadoFinal#&nbsp;:&nbsp;</strong></td>
                                    	<td ><cf_rhempleado tabindex="1" index="1">&nbsp;</td>
                                  	</tr>
                                    <tr>
                                        <td nowrap align="right"> <strong><cf_translate  key="LB_FechaRige">Fecha Rige</cf_translate> :&nbsp;</strong></td>
                                        <td><cf_sifcalendario form="form1" tabindex="1" name="Fdesde"></td>
                                    </tr>
                                    <tr>
                                        <td nowrap align="right"> <strong><cf_translate  key="LB_FechaVence">Fecha Vence</cf_translate> :&nbsp;</strong></td>
                                        <td><cf_sifcalendario form="form1" tabindex="1" name="Fhasta"></td>
                                    </tr>
									<tr>
										<td align="right"><input name="formatoImp" type="checkbox" value="1" id="formatoImp" onclick="funcImprimeF(this);"></td>
										<td><label for="formatoImp" style="font-style:normal; font-variant:normal; font-weight:normal"><strong><cf_translate key="LB_Machote">Imprimir Formato</cf_translate></strong></label></td>
									</tr>
									<tr>
                                        <td nowrap align="right"> <strong><cf_translate  key="LB_Folio">Folio</cf_translate> :&nbsp;</strong></td>
                                        <td><cf_monto name="Folio" size="10" comas="NO" decimales="0" negativos="NO"></td>
                                    </tr>
									<tr>
                                        <td nowrap align="right"> <strong><cf_translate  key="LB_CantidadDocumentos">Cantidad de Documentos</cf_translate> :&nbsp;</strong></td>
                                        <td><cf_monto name="Cantidad" size="10" comas="NO" decimales="0" negativos="NO" value="1"></td>
                                    </tr>
                                    <tr><th scope="row"  colspan="2" class="fileLabel"><cf_botones values="Ver" tabindex="1">&nbsp;</th></tr>
                                </table>
                          </form>
                        </td>
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

<script type="text/javascript">
	function funcImprimeF(obj){
		if(obj.checked){
			deshabilitarValidacion();
		}else{
			habilitarValidacion();
			return false;
		}
	}
	function funcVer(){
		if(document.form1.formatoImp.checked && document.form1.Folio.value == 0){
			alert('<cfoutput>#MSG_DebeIngresarElFolio#</cfoutput>');
			return false;
		}
		return true;
	}
</script>