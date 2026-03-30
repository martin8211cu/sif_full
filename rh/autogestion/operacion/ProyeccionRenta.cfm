<cfinvoke key="LB_Proyeccion_de_Renta" default="Proyección de Renta" returnvariable="LB_Proyeccion_de_Renta" component="sif.Componentes.Translate" method="Translate"/>

<cfif isdefined('Autorizacion') and  Autorizacion>
	<cfinclude template="ProyeccionRenta-form.cfm">
<cfelse>
	<cf_templateheader title="#LB_Proyeccion_de_Renta#">
		<cf_web_portlet_start titulo="#LB_Proyeccion_de_Renta#">
			<cfinclude template="ProyeccionRenta-form.cfm">
		<cf_web_portlet_end>
	<cf_templatefooter>
</cfif>