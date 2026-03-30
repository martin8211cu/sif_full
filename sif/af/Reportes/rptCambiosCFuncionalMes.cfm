<cf_templateheader title="Activos Fijos">
<cf_templatecss>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Movimientos de Activos por Centro Funcional'>
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<cfset Regresar = "/sif/af/MenuConsultasAF.cfm">
	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
	<cfsavecontent variable="pNavegacion">
		<cfinclude template="/home/menu/pNavegacion.cfm">
	</cfsavecontent>
	
			<cfif isdefined('url.periodoInicial') and not isdefined('form.periodoInicial')>
				<cfset form.periodoInicial = url.periodoInicial>
			</cfif>
			<cfif isdefined('url.periodoFinal') and not isdefined('form.periodoFinal')>
				<cfset form.periodoFinal = url.periodoFinal>
			</cfif>
			
			<cfif isdefined('url.mesInicial') and not isdefined('form.mesInicial')>
				<cfset form.mesInicial = url.mesInicial>
			</cfif>
			<cfif isdefined('url.mesFinal') and not isdefined('form.mesFinal')>
				<cfset form.mesFinal = url.mesFinal>
			</cfif>
			
			<cfif isdefined('url.ACcodigo') and not isdefined('form.ACcodigo')>
				<cfset form.ACcodigo = url.ACcodigo>
			</cfif>
			<cfif isdefined('url.ACid') and not isdefined('form.ACid')>
				<cfset form.ACid = url.ACid>
			</cfif>
			<cfif isdefined('url.Fechadesde') and not isdefined('form.Fechadesde')>
				<cfset form.Fechadesde = url.Fechadesde>
			</cfif>
			<cfif isdefined('url.Fechahasta') and not isdefined('form.Fechahasta')>
				<cfset form.Fechahasta = url.Fechahasta>
			</cfif>
			<cfif isdefined('url.Aplaca') and not isdefined('form.Aplaca')>
				<cfset form.Aplaca = url.Aplaca>
			</cfif>
			
			<cfif isdefined("url.CFcodigoinicio") and not isdefined("form.CFcodigoinicio")>
			<cfset form.CFcodigoinicio = url.CFcodigoinicio>
			</cfif>
			
			<cfif isdefined("url.CFcodigofinal") and not isdefined("form.CFcodigofinal")>
			<cfset form.CFcodigofinal = url.CFcodigofinal>
			</cfif>
			
			<cfif isdefined("url.CFDcodigoinicio") and not isdefined("form.CFDcodigoinicio")>
			<cfset form.CFDcodigoinicio = url.CFDcodigoinicio>
			</cfif>
			
			<cfif isdefined("url.CFDcodigofinal") and not isdefined("form.CFDcodigofinal")>
			<cfset form.CFDcodigofinal = url.CFDcodigofinal>
			</cfif>

			<cfif isdefined("form.periodoInicial") and isdefined("form.periodoFinal") and len(trim(form.periodoInicial)) gt 0 and len(trim(form.periodoFinal)) gt 0
			and form.periodoInicial gt 0 and form.periodoFinal gt 0
				and isdefined("form.mesInicial") and isdefined("form.mesFinal")
				 and len(trim(form.mesInicial)) gt 0  and len(trim(form.mesFinal)) gt 0 and form.mesInicial gt 0 and form.mesFinal gt 0>
				<cfset navegacion = "">
				<cfset navegacion = navegacion & "&periodoInicial="&form.periodoInicial>
				<cfset navegacion = navegacion & "&periodoInicial="&form.periodoFinal>
				<cfset navegacion = navegacion & "&mesInicial="&form.mesInicial>		
				<cfset navegacion = navegacion & "&mesInicial="&form.mesFinal>		
				<cfif isdefined('form.ACcodigo') and len(trim(form.ACcodigo)) gt 0 and form.ACcodigo gt 0>
					<cfset navegacion = navegacion & "&ACcodigo="&form.ACcodigo>
				</cfif>
				<cfif isdefined('form.ACid') and len(trim(form.ACid)) gt 0 and form.ACid gt 0>
					<cfset navegacion = navegacion & "&ACid="&form.ACid>
				</cfif>
				<cfif isdefined('form.Fechadesde') and len(trim(form.Fechadesde)) gt 0 and form.Fechadesde gt 0>
					<cfset navegacion = navegacion & "&Fechadesde="&form.Fechadesde>
				</cfif>
				<cfif isdefined('form.Fechahasta') and len(trim(form.Fechahasta)) gt 0 and form.Fechahasta gt 0>
					<cfset navegacion = navegacion & "&Fechahasta="&form.Fechahasta>
				</cfif>
				<cfif isdefined('form.Aplaca') and len(trim(form.Aplaca)) gt 0 and form.Aplaca gt 0>
					<cfset navegacion = navegacion & "&Aplaca="&form.Aplaca>
				</cfif>
			
				<cfif isdefined('url.CFcodigoinicio') and len(trim(url.CFcodigoinicio)) gt 0 and url.CFcodigoinicio gt 0>
					<cfset navegacion = navegacion & "&CFcodigoinicio="&url.CFcodigoinicio>
				</cfif>
				
				<cfif isdefined('url.CFcodigofinal') and len(trim(url.CFcodigofinal)) gt 0 and url.CFcodigofinal gt 0>
					<cfset navegacion = navegacion & "&CFcodigofinal="&url.CFcodigofinal>
				</cfif>
			
				<cf_rhimprime datos="/sif/af/Reportes/rptCambiosCFuncionalMes-sql.cfm" paramsuri="#navegacion#" regresar="/cfmx/sif/af/Reportes/rptCambiosCFuncionalMes.cfm">
				<cf_sifHTML2Word>
					<cfinclude template="rptCambiosCFuncionalMes-sql.cfm">
				</cf_sifHTML2Word>	
			<cfelse>
				<cfinclude template="rptCambiosCFuncionalMes-form.cfm">
			</cfif>
				<cf_web_portlet_end>
	<cf_templatefooter>

