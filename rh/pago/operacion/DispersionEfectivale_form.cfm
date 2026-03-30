<!--- OPARRALES 2018-08-29
	- Layut de dispersion EFECTIVALE
 --->

<cfinvoke key="LB_Titulo" default="Dispersi&oacute;n OMONEL" xmlfile="/rh/generales.xml" returnvariable="LB_Titulo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_TipoNomina" default="Tipo de N&oacute;mina" xmlfile="/rh/generales.xml" returnvariable="LB_TipoNomina" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Seleccione" default="Seleccione" xmlfile="/rh/generales.xml" returnvariable="LB_Seleccione" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_CalendarioPago" default="Calendario de Pago" xmlfile="/rh/generales.xml" returnvariable="LB_CalendarioPago" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Generar" default="Generar" xmlfile="/rh/generales.xml" returnvariable="LB_Generar" component="sif.Componentes.Translate" method="Translate"/>

<cf_templateheader title="#LB_Titulo#" template="#session.sitio.template#">
	<cf_web_portlet_start titulo="#LB_Titulo#">
		<cfoutput>
			<form name="form1" action="DispersionEfectivale_sql.cfm" method="post" >
				<table align="center" width="60%" border="0">
					<tr>
						<td align="right" nowrap>
							<strong>#LB_CalendarioPago#:&nbsp;</strong>
						</td>

						<td align="left">
							<cf_rhcalendariopagos form="form1" MostrarTodos="true" tcodigo="true" >
						</td>
					</tr>
					<tr>
						<td colspan="2" align="center"><input type="submit" value="#LB_Generar#" name="btnGenerar"></td>
					</tr>
				</table>
			</form>
		</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>