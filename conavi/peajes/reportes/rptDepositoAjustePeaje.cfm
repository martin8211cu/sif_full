<cf_templateheader title="Peajes">
<cf_templatecss>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Depósitos y Ajustes por Peaje'>
	<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
	<cfsavecontent variable="pNavegacion">
		<cfinclude template="/home/menu/pNavegacion.cfm">
	</cfsavecontent>				
			<cfif isdefined('url.Fechadesde') and not isdefined('form.Fechadesde')>
				<cfset form.Fechadesde = url.Fechadesde>
			</cfif>
			<cfif isdefined('url.Fechahasta') and not isdefined('form.Fechahasta')>
				<cfset form.Fechahasta = url.Fechahasta>
			</cfif>
			<cfif isdefined("url.Pidincio") and not isdefined("form.Pidincio")>
				<cfset form.Pidincio = url.Pidincio>
			</cfif>
			<cfif isdefined("url.Pidfinal") and not isdefined("form.Pidfinal")>
				<cfset form.Pidfinal = url.Pidfinal>
			</cfif>
			<cfif isdefined("url.BTidinicio") and not isdefined("form.BTidinicio")>
				<cfset form.BTidinicio = url.BTidinicio>
			</cfif>
			<cfif isdefined("url.BTidfinal") and not isdefined("form.BTidfinal")>
				<cfset form.BTidfinal = url.BTidfinal>
			</cfif>
			<cfif isdefined("url.documento") and not isdefined("form.documento")>
				<cfset form.documento = url.documento>
			</cfif>
			<cfif isdefined("form.Pidincio") and isdefined("form.Pidfinal") and len(trim(form.Pidincio)) gt 0 and len(trim(form.Pidfinal)) gt 0
				and form.Pidincio gt 0 and form.Pidfinal gt 0
				and isdefined("form.BTidinicio") and isdefined("form.BTidfinal") and len(trim(form.BTidinicio)) gt 0 and len(trim(form.BTidfinal)) gt 0
				and form.BTidinicio gt 0 and form.BTidfinal gt 0>
				<cfset navegacion = "">
				<cfset navegacion = navegacion & "&Pidincio="&form.Pidincio>
				<cfset navegacion = navegacion & "&Pidfinal="&form.Pidfinal>
				<cfset navegacion = navegacion & "&BTidinicio="&form.BTidinicio>		
				<cfset navegacion = navegacion & "&BTidfinal="&form.BTidfinal>	
				<cfif isdefined('form.Fechadesde') and len(trim(form.Fechadesde)) gt 0 and form.Fechadesde gt 0>
					<cfset navegacion = navegacion & "&Fechadesde="&form.Fechadesde>
				</cfif>
				<cfif isdefined('form.Fechahasta') and len(trim(form.Fechahasta)) gt 0 and form.Fechahasta gt 0>
					<cfset navegacion = navegacion & "&Fechahasta="&form.Fechahasta>
				</cfif>	
				<cfif isdefined('form.documento') and len(trim(form.documento)) gt 0 and form.documento gt 0>
					<cfset navegacion = navegacion & "&documento="&form.documento>
				</cfif>
 				<cf_rhimprime datos="/conavi/peajes/reportes/rptDepositoAjustePeaje-sql.cfm" paramsuri="#navegacion#" regresar="/cfmx/conavi/peajes/reportes/rptDepositoAjustePeaje.cfm">
				<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe> 
				<cf_sifHTML2Word>
					<cfinclude template="rptDepositoAjustePeaje-sql.cfm">
				</cf_sifHTML2Word>	
			<cfelse>
				<cfinclude template="rptDepositoAjustePeaje-form.cfm">
			</cfif>
				<cf_web_portlet_end>
	<cf_templatefooter>
	