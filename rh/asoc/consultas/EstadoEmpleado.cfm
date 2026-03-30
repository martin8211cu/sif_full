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
<!--- FIN VARIABLES DE TRADUCCION --->

<!--- CONSULTA DE DEPARTAMENTOS --->
<cfset rsTipo = queryNew("value,description","Varchar,Varchar")>
<cfset queryAddRow(rsTipo,3)>
<cfset querySetCell(rsTipo,"value",'1',1)>
<cfset querySetCell(rsTipo,"description",LB_Todos,1)>
<cfset querySetCell(rsTipo,"value",'2',2)>
<cfset querySetCell(rsTipo,"description",LB_Asociados,2)>
<cfset querySetCell(rsTipo,"value",'3',3)>
<cfset querySetCell(rsTipo,"description",LB_NoAsociados,3)>

<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">

	<cfinclude template="/rh/Utiles/params.cfm">
		<cfoutput>#pNavegacion#</cfoutput>
        <cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
            <form name="form1" method="post" action="EstadoEmpleado-form.cfm">
                <table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
                    <tr><td colspan="2">&nbsp;</td></tr>
                    <tr>
						<td width="50%">
                       		<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
                            	<cf_translate key="LB_ReporteEstadoAsociado">
                            	Reporte de Estado del Empleado muestra los datos de ingreso a la Empresa, a la Asociaci&oacute;n 
								y si la hay Fecha de salida de la Asociaci&oacute;n.
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
                                	<td align="right"><cf_translate key="LB_Tipo">Tipo</cf_translate>:</td>
                                    <td>
										<select name="Tipo" tabindex="1">
											<cfoutput query="rsTipo">
											<option value="#value#">#description#</option>
											</cfoutput>
										</select>
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
