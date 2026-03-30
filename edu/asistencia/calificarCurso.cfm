<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 8-2-2006.
		Motivo: Actualización del subproceso de sistentes.
 --->

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		<cfoutput>#nav__SPdescripcion#</cfoutput>
	</cf_templatearea> 
	<cf_templatearea name="body">
		<cf_web_portlet titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<cfoutput>#pNavegacion#</cfoutput>
			<cfif isdefined("url.filtroTipo") and not isdefined("form.filtroTipo")>
				<cfset "form.filtroTipo"  ="#url.filtroTipo#">
			</cfif>
				
				
			<cfset filtro = "">
			<cfset navegacion = "">
		
			<cfif isdefined("form.persona")>
				<cfset navegacion = navegacion & "persona=" & #form.persona#>				
			</cfif>
			<!--- <cfinclude template="../portlets/pNavegacionAST.cfm"> --->
		
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<cfif isdefined("url.persona") and not isdefined("form.persona")>
					<cfset form.persona = url.persona>
				</cfif>
				<tr id="verPagina">
					<td>
						<form name="formHeader" method="post" action="rh.cfm">
							<input name="persona" id="persona" value="<cfif isdefined('form.persona')><cfoutput>#form.persona#</cfoutput></cfif>" type="hidden">
						</form>
						<cfinclude template="/edu/docencia/calificarCurso_Form.cfm">
					</td>
				</tr>
			</table>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>