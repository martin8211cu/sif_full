
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

			<table width="100%" border="0" cellpadding="0" cellspacing="0">
			  <tr>
				<td>
				
					<cfinclude template="formMateriasSustitutivas.cfm">
				
				</td>
			  </tr>
			</table>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>