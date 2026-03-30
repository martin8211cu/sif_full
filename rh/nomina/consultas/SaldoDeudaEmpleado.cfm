<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_ReporteDeSaldosDeDeudaPorEmpleado" Default="Reporte de Saldos de Deuda por Empleado" returnvariable="LB_ReporteDeSaldosDeDeudaPorEmpleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_NominaAplicada" Default="N&oacute;mina Aplicada" returnvariable="MSG_NominaAplicada" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke Key="LB_Todos" Default="--- Todos ---" returnvariable="LB_Todos" component="sif.Componentes.Translate" method="Translate"/>

<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<!--- CONSULTA DE DEPARTAMENTOS --->
<cfset rsDepartamentos = queryNew("value,description","Integer,Varchar")>
<cfset queryAddRow(rsDepartamentos,1)>
<cfset querySetCell(rsDepartamentos,"value",-1,rsDepartamentos.recordcount)>
<cfset querySetCell(rsDepartamentos,"description",LB_Todos,rsDepartamentos.recordcount)>
<cfquery name="rsDeptos" datasource="#session.DSN#">
	select Dcodigo as v, Ddescripcion as d
	from Departamentos
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    order by Dcodigo
</cfquery>
<cfloop query="rsDeptos">
	<cfset queryAddRow(rsDepartamentos,1)>
	<cfset querySetCell(rsDepartamentos,"value",v,rsDepartamentos.recordcount)>
	<cfset querySetCell(rsDepartamentos,"description",d,rsDepartamentos.recordcount)>
</cfloop>

	<cfinclude template="/rh/Utiles/params.cfm"><strong></strong>
        <cf_web_portlet_start titulo="#LB_ReporteDeSaldosDeDeudaPorEmpleado#">
            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td>
                </tr>
                <tr>
                    <td width="50%" align="center" valign="top">
                        <cf_web_portlet_start titulo="#LB_ReporteDeSaldosDeDeudaPorEmpleado#" skin="info1">
                            <table width="85%">
                                <tr>
                                    <td align="center">
                                        <p>
                                        <cf_translate  key="LB_ReporteDeEstadoDeCuentaDeEmpleados">
                                            Estado de Cuenta de Empleados. 
                                        </cf_translate>
                                        </p>
                                    </td>
                                </tr>
                            </table>
                        <cf_web_portlet_end>
                    </td>
                    <td align="center">
                        <form name="filtro" method="post" action="SaldoDeudaEmpleado-form.cfm">
                            <table border="0" cellpadding="1" cellspacing="1" align="center">
                            <tr><td colspan="2">&nbsp;</td></tr>
                                <tr>
                                    <td align="right"> <cf_translate key="LB_Empleado">Empleado</cf_translate>:&nbsp;</td>
                                  <td><cf_rhempleado form="filtro"></td>
                              </tr>
                               	<tr>
                                    <td colspan="2">
                                  <table width="100%" border="0" cellspacing="0" cellpadding="1">
                                     <tr>
                         <td width="1%" height="26" valign="middle"><input type="radio" name="opt" value="0" tabindex="1" onClick="javascript: mostrar_div('CF');"></td>
                         <td valign="middle" nowrap="nowrap"><cf_translate key="LB_CentroFuncional" XmlFile="/rh/generales.xml">Centro Funcional</cf_translate></td>
                                    <td valign="middle" width="1%"><input type="radio" name="opt" value="1" tabindex="1" onClick="javascript: mostrar_div('OD');"></td>
                                    <td valign="middle" nowrap="nowrap"><cf_translate key="LB_Departamento">Departamento</cf_translate></td>			
                                            </tr>
                                  </table>	
                                    </td>
                              </tr>
                                <tr id="div_CF" style="display:;" >
                                	<td colspan="2" align="left">
                                        <table width="100%" cellpadding="0" cellspacing="0" border="0" align="left">
	                                        <tr>
            <td width="22%" align="right" nowrap="nowrap"><cf_translate key="LB_CentroFuncional" XmlFile="/rh/generales.xml">Centro Funcional</cf_translate>:&nbsp;</td>
                                           	  <td width="78%"><cf_rhcfuncional size="20" tabindex="2" form="filtro"></td>
                                          </tr>
                                        </table> 
                                	</td>
                                </tr>
                                <tr id="div_OD" style="display:none;">
                                	<td colspan="2">
                                        <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                            <tr> 
                                                <td>
                                                    <select name="Dcodigo" tabindex="2">
                                                        <cfoutput query="rsDepartamentos">
                                                            <option value="#rsDepartamentos.value#">#rsDepartamentos.description#</option>
                                                        </cfoutput>		
                                                    </select>
                                                </td>
                                 			</tr>
                                        </table>
                                	</td>
                                </tr>
								
                             	<tr>									
									 <table width="100%" cellpadding="0" cellspacing="0" border="0">									  
										  <td align="right"><cf_translate key="LB_DEduccionDesde">Deducci&oacute;n Desde</cf_translate>:&nbsp;<td> 
										  <td> &nbsp; </td>
										  <td> <cf_rhtipodeduccion form="filtro" name="nameDesde" desc="descDesde" id="idDesde" size= "20" tabindex="1">&nbsp;</td>	
										  <td> &nbsp; </td>
										  <td> <cf_translate key="LB_DEduccionhasta">Deducci&oacute;n Hasta</cf_translate>:&nbsp;</td>	
										  <td> <cf_rhtipodeduccion form="filtro" name="nameHasta" desc="descHasta" id="idHasta"  size= "20" tabindex="2"></td>	
									 </table> 							 							
								</tr>													 								
                                <tr><td nowrap align="center" colspan="2"><cf_botones values="Generar"></td></tr>
                            </table>
                      </form>
                    </td>
                </tr>
            </table>
        <cf_web_portlet_end>
    </td>	
</tr>
</table>
<cf_templatefooter>
<cf_qforms form="filtro">
</cf_qforms>

<script language="javascript1.2" type="text/javascript">
	function mostrar_div(which){
		var div_cf = document.getElementById("div_CF");
		var div_od = document.getElementById("div_OD");
		document.filtro.DEid.value = '';
		document.filtro.DEidentificacion.value = '';
		document.filtro.NombreEmp.value = '';
		if (which=="CF"){
			div_cf.style.display = '';
			div_od.style.display = 'none';
			document.filtro.opt[0].checked = true;
			document.filtro.opt[1].checked = false;
			document.filtro.Dcodigo.value = -1;
			}
		else{
			div_cf.style.display = 'none';
			div_od.style.display = '';
			document.filtro.opt[0].checked = false;
			document.filtro.opt[1].checked = true;
			document.filtro.CFid.value = '';
			document.filtro.CFcodigo.value = '';
			document.filtro.CFdescripcion.value = '';
			}
	}
	mostrar_div('CF');
</script>