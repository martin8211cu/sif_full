<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_ReporteDeMarcasPorEmpleado" Default="Reporte de Marcas por Empleado" returnvariable="LB_ReporteDeMarcasPorEmpleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_NominaAplicada" Default="N&oacute;mina Aplicada" returnvariable="MSG_NominaAplicada" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke Key="LB_Todos" Default="--- Todos ---" returnvariable="LB_Todos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FechaDesde" Default="Fecha Desde" returnvariable="LB_FechaDesde" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FechaHasta" Default="Fecha Hasta" returnvariable="LB_FechaHasta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_nav__SPdescripcion" Default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<!--- CONSULTA DE DEPARTAMENTOS --->
<!--- Departamentos--->



<!--- LISTA DE CENTROS FUNCIONALES --->
<cfset rsDepartamentos = queryNew("value,description","Integer,Varchar")>
<cfset queryAddRow(rsDepartamentos,1)>
<cfset querySetCell(rsDepartamentos,"value",-1,rsDepartamentos.recordcount)>
<cfset querySetCell(rsDepartamentos,"description",LB_Todos,rsDepartamentos.recordcount)>
<cfquery name="rsDeptos" datasource="#session.DSN#">
	select Dcodigo as v, Ddescripcion as d
	from Departamentos
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    order by Ddescripcion
</cfquery>
<cfloop query="rsDeptos">
	<cfset queryAddRow(rsDepartamentos,1)>
	<cfset querySetCell(rsDepartamentos,"value",v,rsDepartamentos.recordcount)>
	<cfset querySetCell(rsDepartamentos,"description",d,rsDepartamentos.recordcount)>
</cfloop>


<!--- JORNADAS --->
<cfset rsJornadas = queryNew("value,description","Integer,Varchar")>
<cfset queryAddRow(rsJornadas,1)>
<cfset querySetCell(rsJornadas,"value",-1,rsJornadas.recordcount)>
<cfset querySetCell(rsJornadas,"description",LB_Todos,rsJornadas.recordcount)>
<cfquery name="rsJ" datasource="#Session.DSN#">
    select RHJid as v, {fn concat(rtrim(RHJcodigo),{fn concat(' - ',RHJdescripcion)})} as d
    from RHJornadas 
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>
 <cfloop query="rsJ">
	<cfset queryAddRow(rsJornadas,1)>
	<cfset querySetCell(rsJornadas,"value",v,rsJornadas.recordcount)>
	<cfset querySetCell(rsJornadas,"description",d,rsJornadas.recordcount)>
</cfloop>


	<cfinclude template="/rh/Utiles/params.cfm">
		<cfoutput>#pNavegacion#</cfoutput>
        <cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
            <form name="filtro" method="post" action="ReporteAusentismo-form.cfm">
                <table width="700" border="0" cellpadding="1" cellspacing="1" align="center">
                    <tr><td colspan="2">&nbsp;</td></tr>
                    <tr>
                        <td width="350">
                            <table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
                                <tr>
                                    <td nowrap><cf_translate key="LB_FechaDesde">Fecha desde</cf_translate>:&nbsp;</td>
                                    <td><cf_sifcalendario form="filtro" name="Fdesde"></td>
                                </tr>
                                <tr>
                                    <td><cf_translate key="LB_FechaHasta">Fecha hasta</cf_translate>:&nbsp;</td>
                                    <td><cf_sifcalendario form="filtro" name="Fhasta"></td>
                                </tr>
                                <tr>
                                    <td align="right"> <cf_translate key="LB_Empleado">Empleado</cf_translate>:&nbsp;</td>
                                    <td><cf_rhempleado form="filtro"></td>
                                </tr>
                                 <tr>
                                    <td align="right"><cf_translate key="LB_Jornada">Jornada</cf_translate>:&nbsp;</td>
                                    <td>
                                        <select name="RHJid" id="RHJid">
                                          <cfoutput query="rsJornadas"> 
                                            <option value="#rsJornadas.value#">#rsJornadas.description#</option>
                                          </cfoutput> 
                                        </select>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td width="350" valign="top">
                            <table width="350" border="0" cellpadding="1" cellspacing="1" align="center">
                                <tr>
                                    <td width="350">
										<table width="350" border="0" cellspacing="0" cellpadding="1">
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
                                	<td width="350" align="left">
                                    	<table width="100%" cellpadding="0" cellspacing="0" border="0" align="left">
                                        	<tr>
                                            	<td width="22%" align="right" nowrap="nowrap"><cf_translate key="LB_CentroFuncional" XmlFile="/rh/generales.xml">Centro Funcional</cf_translate>:&nbsp;</td>
                                                <td width="78%"><cf_rhcfuncional size="20" tabindex="2" form="filtro"></td>
                                            </tr>
                                      	</table> 
                                    </td>
                              	</tr>
                                <tr id="div_OD" style="display:none;">
                                	<td width="350">
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
                         	</table>
                        </td>
                    </tr>
                    <tr><td width="700" nowrap align="center" colspan="2"><cf_botones values="Generar"></td></tr>
                </table>
          </form>
	<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms form="filtro">
	<cf_qformsrequiredfield args="Fdesde,#LB_FechaDesde#">
  	<cf_qformsrequiredfield args="Fhasta,#LB_FechaHasta#">
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