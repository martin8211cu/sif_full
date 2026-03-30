<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_nav__SPdescripcion" default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<cfinvoke key="LB_Periodo" default="Per&iacute;odo" returnvariable="LB_Periodo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_PeriodoJ" default="Período" returnvariable="LB_PeriodoJ" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Identificacion" default="Identificación"	 returnvariable="LB_Identificacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Empleado" default="Empleado"	 returnvariable="LB_Empleado" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_NoSeEncontraronRegistros" default="No se encontraron registros"	 returnvariable="LB_NoSeEncontraronRegistros" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_ListaDeAsociados" default="Lista de Asociados"	 returnvariable="LB_ListaDeAsociados" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cfquery name="rsPeriodos" datasource="#session.DSN#">	
	select distinct ACDDEperiodo
	from ACDistribucionDividendosE 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>
<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	<cfinclude template="/rh/Utiles/params.cfm">
		<cfoutput>#pNavegacion#</cfoutput>
        <cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
            <form name="form1" method="post" action="BonoEscolarSolidaristas-form.cfm">
                <table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
                    <tr><td colspan="2">&nbsp;</td></tr>                   
				    <tr>
						<td width="35%" valign="top">
                       		<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
                            	<cf_translate key="LB_ReporteDeBonoEscolarSociosSolidaristas">
                            		Reporte de Bono Escolar Socios Solidaristas.
                                </cf_translate>
                        	<cf_web_portlet_end>
                      	</td>
                        <td>
                        	<cfoutput>
								<table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
									<tr>
										<td align="right" nowrap="nowrap">#LB_Periodo#:</td>
										<td>
											<select name="ACDDEPERIODO">												
												<cfloop query="rsPeriodos">
													<option value="#rsPeriodos.ACDDEPERIODO#">#rsPeriodos.ACDDEPERIODO#</option>
												</cfloop>
											</select>	
										</td>
									</tr>
									<tr>
										<td align="right"><cf_translate key="LB_AsociadoDesde">Asociado Desde</cf_translate>:</td>
										<td>
											<cf_conlis
											   campos="DEid,DEidentificacion,Nombre"
											   desplegables="N,S,S"
											   modificables="N,S,N"
											   size="0,20,40"
											   title="#LB_ListaDeAsociados#"
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
										<td align="right"><cf_translate key="LB_AsociadoHasta">Asociado Hasta</cf_translate>:</td>
										<td>
											<cf_conlis
											   campos="DEid_h,DEidentificacion_h,Nombre_h"
											   desplegables="N,S,S"
											   modificables="N,S,N"
											   size="0,20,40"
											   title="#LB_ListaDeAsociados#"
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
							</cfoutput>
                        </td>
                   	</tr>
                    <tr><td colspan="2">&nbsp;</td></tr>
                    <tr><td nowrap align="center" colspan="2"><cf_botones values="Generar" tabindex="1"></td></tr>
              </table>
          </form>
	<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms form="form1">	
	<cf_qformsrequiredfield args="ACDDEPERIODO,#LB_PeriodoJ#">
	<!----<cf_qformsrequiredfield args="ACCTid,#LB_TipoAnticipo#">---->
</cf_qforms>