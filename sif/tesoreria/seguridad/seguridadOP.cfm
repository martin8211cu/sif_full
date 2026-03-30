<cfinvoke key="LB_Titulo" default="Usuarios que pueden procesar Órdenes de Pago"	returnvariable="LB_Titulo"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="seguridadOP.xml"/>

<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start _start titulo="#LB_Titulo#">

		<cf_navegacion name="Usucodigo" default="" navegacion="">

		<table width="100%" align="center">
			<tr>
				<td valign="top" align="center" width="50%">
					<cfinclude template="seguridadOP_list.cfm">
				</td>
				<td valign="top" align="center" width="50%">
					<cfinclude template="seguridadOP_form.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_start _end>
<cf_templatefooter>

