<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_nav__SPdescripcion" default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<cfinvoke key="LB_Planilla" default="Planilla" returnvariable="LB_Planilla" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_TipoAnticipo" default="Tipo de anticipo" returnvariable="LB_TipoAnticipo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Identificacion" default="Identificación"	 returnvariable="LB_Identificacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Empleado" default="Empleado"	 returnvariable="LB_Empleado" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_NoSeEncontraronRegistros" default="No se encontraron registros"	 returnvariable="LB_NoSeEncontraronRegistros" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_ListaDeEmpleados" default="Lista de Empleados"	 returnvariable="LB_ListaDeEmpleados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Codigo" default="C&oacute;digo"	 returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Descripcion" default="Descripci&oacute;n"	 returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_ListaDeAnticipos" default="Lista de Anticipos"	 returnvariable="LB_ListaDeAnticipos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_ListaDePlanillas" default="Lista de Planillas"	 returnvariable="LB_ListaDePlanillas" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">

	<cfinclude template="/rh/Utiles/params.cfm">
		<cfoutput>#pNavegacion#</cfoutput>
        <cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
            <form name="form1" method="post" action="DescuentoAnticiposSolidaristas-form.cfm">
                <table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
                    <tr><td colspan="2">&nbsp;</td></tr>                   
				    <tr>
						<td width="35%" valign="top">
                       		<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
                            	<cf_translate key="LB_ElReporteDescuentoDeAnticipoDeSolidaristasMuestraElDesgloceDelPagoDeLasCuotasRealizadosAUnAnticipo">
                            		El Reporte de Descuento de Anticipo de Solidaristas muestra el desglose del pago de las cuotas realizados a un anticipo, con el monto 
									correspondiente al abono y a los intereses.
                                </cf_translate>
                        	<cf_web_portlet_end>
                      	</td>
                        <td>
                        	<table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
                            	<tr>
                                	<td align="right" nowrap="nowrap"><cf_translate key="LB_Planilla">Planilla</cf_translate>:</td>
                                    <td>
										<cf_rhcalendariopagos descsize="20" historicos="true">
                                    	<!--- <cf_conlis
										   campos="RCNid,RCDescripcion"
										   desplegables="N,S"
										   modificables="N,N"
										   size="0,40"
										   title="#LB_ListaDePlanillas#"
										   tabla="HRCalculoNomina"
										   columnas="RCNid,RCDescripcion"
										   filtro="Ecodigo = #session.Ecodigo# order by RCdesde desc"
										   desplegar="RCDescripcion"
										   filtrar_por="RCDescripcion"
										   etiquetas="#LB_Descripcion#"
										   formatos="S"
										   align="left"
										   asignar="RCNid,RCDescripcion"
										   asignarformatos="S,S"
										   showemptylistmsg="true"
										   emptylistmsg="-- #LB_NoSeEncontraronRegistros# --"
										   tabindex="1"
										   MaxRowsQuery="1000"
										   >  --->
                                    </td>
                                </tr>
								<tr>
                                	<cfoutput><td align="right" nowrap="nowrap">#LB_TipoAnticipo#:</td></cfoutput>
                                    <td>
                                    	<cf_conlis
										   campos="ACCTid,ACCTcodigo,ACCTdescripcion"
										   desplegables="N,S,S"
										   modificables="N,S,N"
										   size="0,10,40"
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
                                	<td align="right" nowrap="nowrap"><cf_translate key="LB_EmpleadoDesde">Empleado Desde</cf_translate>:</td>
                                    <td>
                                    	<cf_conlis
										   campos="DEid,DEidentificacion,Nombre"
										   desplegables="N,S,S"
										   modificables="N,S,N"
										   size="0,10,40"
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
                                	<td align="right" nowrap="nowrap"><cf_translate key="LB_EmpleadoHasta">Empleado Hasta</cf_translate>:</td>
                                    <td>
                                    	<cf_conlis
										   campos="DEid_h,DEidentificacion_h,Nombre_h"
										   desplegables="N,S,S"
										   modificables="N,S,N"
										   size="0,10,40"
										   title="#LB_ListaDeEmpleados#"
										   tabla="DatosEmpleado a
												inner join ACAsociados b
													on b.DEid = a.DEid"
										   columnas="b.DEid as DEid_h, a.DEidentificacion as DEidentificacion_h , {fn concat({fn concat({fn concat({fn concat(a.DEapellido1 , ' ' )}, a.DEapellido2 )},  ' ' )}, a.DEnombre)} as Nombre_h"
										   filtro="a.Ecodigo = #session.Ecodigo# order by DEidentificacion"
										   desplegar="DEidentificacion_h,Nombre_h"
										   filtrar_por="a.DEidentificacion|{fn concat({fn concat({fn concat({fn concat(a.DEapellido1 , ' ' )}, a.DEapellido2 )},  ' ' )}, a.DEnombre)}"
										   filtrar_por_delimiters="|"
										   etiquetas="#LB_Identificacion#,#LB_Empleado#"
										   formatos="S,S"
										   align="left,left"
										   asignar="DEid_h,DEidentificacion_h,Nombre_h"
										   asignarformatos="S,S,S"
										   showemptylistmsg="true"
										   emptylistmsg="-- #LB_NoSeEncontraronRegistros# --"
										   tabindex="1"> 										
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
	<cf_qformsrequiredfield args="CPid,#LB_Planilla#">
	<cf_qformsrequiredfield args="ACCTid,#LB_TipoAnticipo#">
</cf_qforms>