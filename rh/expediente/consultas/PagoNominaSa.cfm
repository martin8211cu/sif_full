<!--- Modified with Notepad --->
<cfsilent>
	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
	<cfsavecontent variable="pNavegacion">
		<cfinclude template="/home/menu/pNavegacion.cfm">
	</cfsavecontent>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Reporte_de_Planilla_SA"
		Default="#nav__SPdescripcion#"
		returnvariable="LB_Reporte_de_Planilla_SA"/>
</cfsilent>
<cf_templateheader title="#LB_Reporte_de_Planilla_SA#">
	<cf_web_portlet_start titulo="#LB_Reporte_de_Planilla_SA#">
		<cfoutput>#pNavegacion#</cfoutput>
		<cfset Gvar_Action = "PagoNominaSa-sql.cfm">
		<cfinclude template="PagoNominaForm.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>