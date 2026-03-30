<!--- VARIABLES DE TRADUCCION --->
<cfsilent>
<cfinvoke key="LB_Boleta_del_Empleado" default="Boleta del Empleado" returnvariable="LB_Boleta_del_Empleado" component="sif.Componentes.Translate" method="Translate"/>
</cfsilent>
<!--- FIN VARIABLES DE TRADUCCION --->

<cf_templateheader title="#LB_Boleta_del_Empleado#">
	<cf_web_portlet_start titulo="#LB_Boleta_del_Empleado#">
			<cfinclude template="Boleta-lista.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>