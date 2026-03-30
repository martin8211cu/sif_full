<!--- 	Reporte de Transacciones Aplicadas.
 		Creado por Dorian A.G. el 5 de Agosto del 2005. 
		Modificado: Rodolfo Jimenez Jara
		Fecha: 22 de Noviembre de 2005
		Motivo: Separar reporte HTML del webportlet
--->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<cfif not isdefined("form.btnGenerar")>
				<!--- Filtro --->
				<cfinclude template="RPTrpttran-filtro.cfm">
			<cfelse>
				<cfinclude template="RPTrpttran-form.cfm">
			</cfif>
		<cf_web_portlet_end>
<cf_templatefooter>
