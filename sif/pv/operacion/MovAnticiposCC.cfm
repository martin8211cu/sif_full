<!--- 
	Creado por Gustavo Fonseca H.
		Fecha: 16-1-2006.
		Motivo: Nuevo proceso de Movimiento de anticipos de PV a CxC.
 --->

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>"> <cfoutput>#pNavegacion#</cfoutput>
			<cfinclude template="MovAnticiposCC_form.cfm">
		<cf_web_portlet_end>
<cf_templatefooter>
