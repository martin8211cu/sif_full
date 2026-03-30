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
		returnvariable="LB_Reporte_de_Conceptos_de_Pago_en_Acciones_de_Personal"/>
</cfsilent>
<cf_templateheader title="#LB_Reporte_de_Conceptos_de_Pago_en_Acciones_de_Personal#">
	<cf_web_portlet_start titulo="#LB_Reporte_de_Conceptos_de_Pago_en_Acciones_de_Personal#">
		<cfoutput>#pNavegacion#</cfoutput>
		<cfset Gvar_Action = "ConceptosPagoEnAccionesPersonal-sql.cfm">
		<cfinclude template="ConceptosPagoEnAccionesPersonal-form.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>