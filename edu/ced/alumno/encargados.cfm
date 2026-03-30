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
			<cfif isdefined('url.Filtro_Estado') and not isdefined('form.Filtro_Estado')>
				<cfparam name="form.Filtro_Estado" default="#url.Filtro_Estado#">
			</cfif>
			<cfif isdefined('url.Filtro_Grado') and not isdefined('form.Filtro_Grado')>
				<cfparam name="form.Filtro_Grado" default="#url.Filtro_Grado#">
			</cfif>
			<cfif isdefined('url.Filtro_Ndescripcion') and not isdefined('form.Filtro_Ndescripcion')>
				<cfparam name="form.Filtro_Ndescripcion" default="#url.Filtro_Ndescripcion#">
			</cfif>
			<cfif isdefined('url.Filtro_Nombre') and not isdefined('form.Filtro_Nombre')>
				<cfparam name="form.Filtro_Nombre" default="#url.Filtro_Nombre#">
			</cfif>
			<cfif isdefined('url.Filtro_Pid') and not isdefined('form.Filtro_Pid')>
				<cfparam name="form.Filtro_Pid" default="#url.Filtro_Pid#">
			</cfif>
			<cfif isdefined('url.NoMatr') and not isdefined('form.NoMatr')>
				<cfparam name="form.NoMatr" default="#url.NoMatr#">
			</cfif>
			<cfif isdefined('url.tab') and not isdefined('form.tab')>
				<cfparam name="form.tab" default="#url.tab#">
			</cfif>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
			  <tr>
				<td>
					<cfinclude template="formEncargados.cfm">
				</td>
			  </tr>
			</table>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>