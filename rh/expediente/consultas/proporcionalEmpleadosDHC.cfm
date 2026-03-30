<!--- Modified with Notepad --->
<cfsilent>
	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
	<cfsavecontent variable="pNavegacion">
		<cfinclude template="/home/menu/pNavegacion.cfm">
	</cfsavecontent>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Reporte_de_Relacion_de_Salarios:_Neto_vs_Liquido"
		Default="Reporte de Relación de Salarios: Neto vs Líquido (DHC)"
		returnvariable="LB_proporcionalEmpleadosDHC"/>
</cfsilent>
<cf_templateheader title="#LB_proporcionalEmpleadosDHC#">
	<cf_web_portlet_start titulo="#LB_proporcionalEmpleadosDHC#">
		<cfoutput>#pNavegacion#</cfoutput>
		<cfset Gvar_Action = "proporcionalEmpleadosDHC-sql.cfm">
		<cfinclude template="proporcionalEmpleadosDHC-form.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>