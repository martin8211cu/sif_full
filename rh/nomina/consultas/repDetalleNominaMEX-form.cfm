<!--- Modified with Notepad --->
<cfsilent>
	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
	<cfsavecontent variable="pNavegacion">
		<cfinclude template="/home/menu/pNavegacion.cfm">
	</cfsavecontent>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Reporte_de_Planilla_INC"
		Default="#nav__SPdescripcion#"
		returnvariable="LB_Reporte_de_Planilla_INC"/>
</cfsilent>
<cf_templateheader title="#LB_Reporte_de_Planilla_INC#">
	<cf_web_portlet_start titulo="#LB_Reporte_de_Planilla_INC#">
		<cfoutput>#pNavegacion#</cfoutput>
		<cfset Gvar_Action = "repDetalleNominaMEX-rep.cfm">
		<cfinclude template="repDetalleNominasMEX-filtro.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>