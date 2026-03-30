<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_nav__SPdescripcion" default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<cfinvoke key="LB_Todos" default="--- Todos ---" returnvariable="LB_Todos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Asociados" default="Asociados" returnvariable="LB_Asociados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_NoAsociados" default="No Asociados" returnvariable="LB_NoAsociados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Codigo" default="C&oacute;digo"	 returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Descripcion" default="Descripci&oacute;n"	 returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_NoSeEncontraronRegistros" default="No se encontraron registros"	 returnvariable="LB_NoSeEncontraronRegistros" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_ListaDeAnticipos" default="Lista de Anticipos"	 returnvariable="LB_ListaDeAnticipos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Nomina" default="N&oacute;mina" returnvariable="LB_Nomina" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_CalendarioDePago" default="Calendario de Pago"	 returnvariable="LB_CalendarioDePago" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Identificacion" default="Identificación"	 returnvariable="LB_Identificacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Empleado" default="Empleado"	 returnvariable="LB_Empleado" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_ListaDeEmpleados" default="Lista de Empleados"	 returnvariable="LB_ListaDeEmpleados" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">

	<cfinclude template="/rh/Utiles/params.cfm">
		<cfoutput>#pNavegacion#</cfoutput>
        <cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
            <form name="form1" method="post" action="ReciboAportes-form.cfm">
                <table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
                    <tr><td colspan="2">&nbsp;</td></tr>
                    <tr>
						<td width="50%" valign="top">
                       		<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
                            	<cf_translate key="LB_DescuentosPendientes">
                            		Reporte por tipo de ancitico, que detalla la información de los Asociados que lo tengan. Entre la información están
									los descuentos por aplicar y saldo de la operación.
                                </cf_translate>
                        	<cf_web_portlet_end>
                      	</td>
                        <td>
                        	<table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
								<tr>
                                	<td align="right"><cf_translate key="LB_Nomina">N&oacute;mina</cf_translate>:</td>
                                    <td><cf_rhcalendariopagos descsize="30" historicos="true" tabindex="1"></td>
                                </tr>
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
									<td align="right" nowrap><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:</td>
                                    <td><cf_rhcfuncional tabindex="1"></td>
								</tr>
								<tr>
                                	<td align="right" nowrap>&nbsp;</td>
                                    <td>
										<input name="dependencias" id="dependencias" type="checkbox" tabindex="1">
										<label for="dependencias" style="font-style:normal; font-variant:normal; font-weight:normal"><cf_translate key="LB_IncluirDependencias">Incluir Dependencias</cf_translate></label>
									</td>
                                </tr>
								<tr>
									<td align="right" nowrap><cf_translate key="LB_Estado">Estado</cf_translate>:</td>
									<td>
										<select name="Estado" tabindex="1">
											<option value="-1"><cf_translate key="LB_Todos">Todos</cf_translate></option>
											<option value="0"><cf_translate key="LB_Inactivo">Inactivo</cf_translate></option>
											<option value="1"><cf_translate key="LB_Activo">Activo</cf_translate></option>
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
<cf_qforms form="form1">
	<cf_qformsrequiredfield args="Tcodigo,#LB_Nomina#">
	<cf_qformsrequiredfield args="CPid,#LB_CalendarioDePago#">
</cf_qforms>