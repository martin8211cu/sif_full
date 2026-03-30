<!--- 
	Creado por Gustavo Fonseca H.
	Fecha: 5-1-2007.
	Motivo: Soporte del proceso de Cierre Anual.
 --->
 
 <cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>


<cf_templateheader title="#nav__SPdescripcion#">
	<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
		<cfoutput>#pNavegacion#</cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr> 
				<td valign="top">
					<cfinclude template="AsientoLimpiezaCierreAnual-form.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>


