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
<cfinvoke Key="LB_Fecha" Default="Fecha"	 returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FechaHasta" Default="Fecha hasta"	 returnvariable="LB_FechaHasta" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">

	<cfinclude template="/rh/Utiles/params.cfm">
		<cfoutput>#pNavegacion#</cfoutput>
        <cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
            <form name="form1" method="post" action="ResumenMensual-form.cfm">
                <table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
                    <tr><td colspan="2">&nbsp;</td></tr>
                    <tr>
						<td width="50%" valign="top">
                       		<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
                            	<cf_translate key="LB_ReporteResumenMensual">
                            	Resumen Mensual muestra la informaci&oacute;n de los pr&eacute;stamos del empleado, indicando el detalle de cada uno de ellos.
                                </cf_translate>
                        	<cf_web_portlet_end>
                      	</td>
                        <td>
                        	<table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
                            	<tr>
                                	<td align="right" nowrap="nowrap"><cf_translate key="LB_EmpleadoDesde">Empleado desde</cf_translate>:</td>
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
                                	<td align="right"><cf_translate key="LB_EmpleadoHasta">Empleado hasta</cf_translate>:</td>
                                    <td>
                                    	<cf_conlis
										   campos="DEid1,DEidentificacion1,Nombre1"
										   desplegables="N,S,S"
										   modificables="N,S,N"
										   size="0,20,40"
										   title="#LB_ListaDeEmpleados#"
										   tabla="DatosEmpleado a
												inner join ACAsociados b
													on b.DEid = a.DEid"
										   columnas="b.DEid as DEid1, a.DEidentificacion as DEidentificacion1, {fn concat({fn concat({fn concat({fn concat(a.DEapellido1 , ' ' )}, a.DEapellido2 )},  ' ' )}, a.DEnombre)} as Nombre1"
										   filtro="a.Ecodigo = #session.Ecodigo# order by DEidentificacion"
										   desplegar="DEidentificacion1,Nombre1"
										   filtrar_por="a.DEidentificacion|{fn concat({fn concat({fn concat({fn concat(a.DEapellido1 , ' ' )}, a.DEapellido2 )},  ' ' )}, a.DEnombre)}"
										   filtrar_por_delimiters="|"
										   etiquetas="#LB_Identificacion#,#LB_Empleado#"
										   formatos="S,S"
										   align="left,left"
										   asignar="DEid1,DEidentificacion1,Nombre1"
										   asignarformatos="S,S,S"
										   showemptylistmsg="true"
										   emptylistmsg="-- #LB_NoSeEncontraronRegistros# --"
										   tabindex="1"> 
										
                                    </td>
                                </tr>
                            	<tr>
                                	<td align="right" nowrap><cf_translate key="LB_Fecha">Fecha</cf_translate>:</td>
                                    <td>
										<cfset Lvar_Fecha = LSDateFormat(now(),'dd/mm/yyyy')>
										<cf_sifcalendario name="Fecha" tabindex="1" value="#Lvar_Fecha#">
									</td>
                                </tr>
								<tr>
                                	<td align="right" nowrap>&nbsp;</td>
                                    <td>
										<input name="chkTotales" id="chkTotales" type="checkbox" checked="checked">
										<label for="chkTotales" style="font-style:normal; font-variant:normal; font-weight:normal"><cf_translate key="LB_TotalesDeColumna">Totales de Columna</cf_translate></label>
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
	<cf_qformsrequiredfield args="Fecha,#LB_Fecha#">
</cf_qforms>