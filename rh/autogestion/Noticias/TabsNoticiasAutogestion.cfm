	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_OtrasSoluciones"
		Default="Otras Soluciones"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_OtrasSoluciones"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_NoticiasAutogestion"
		Default="Noticias de Autogesti&oacute;n"
		returnvariable="LB_NoticiasAutogestion"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Noticia"
		Default="Noticia"
		returnvariable="LB_Noticia"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_PublicarNoticiaPara"
		Default="Publicar Noticia Para"
		returnvariable="LB_PublicarNoticiaPara"/>	

	<cf_templateheader title="#LB_OtrasSoluciones#" template="#session.sitio.template#">
		<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#LB_NoticiasAutogestion#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">

			<cfif isdefined("url.tab") and not isdefined("form.tab")>
				<cfset form.tab = url.tab >
			</cfif>
			<cfif IsDefined('url.tab')>
				<cfset form.tab = url.tab>
			<cfelse>
				<cfparam name="form.tab" default="1">
			</cfif>
			<cfif not (isdefined("form.tab") and ListContains('1,2', form.tab))>
				<cfset form.tab = 1 >
			</cfif>
			<cfif isdefined("url.IdNoticia") and not isdefined("form.IdNoticia")>
				<cfset form.IdNoticia = url.IdNoticia >
			</cfif>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td>					
					<cf_tabs width="100%" onclick="tab_set_current_param">
						<cf_tab text="#LB_Noticia#" id="1" selected="#form.tab is '1'#">
							<cfif isdefined('form.tab') and form.tab EQ '1'>								
								<cfinclude template="formNoticiasAutogestion.cfm">
							</cfif>
						</cf_tab>
						<cf_tab text="#LB_PublicarNoticiaPara#" id="2" selected="#form.tab is '2'#">
							<cfif isdefined('form.tab') and form.tab EQ '2'>
								<cfinclude template="formUsuariosNoticias.cfm">
							</cfif>
						</cf_tab>																			
					</cf_tabs>
				</td>
			  </tr>
			</table>
			<script language="javascript" type="text/javascript">
				function tab_set_current_param (n){										
					location.href='TabsNoticiasAutogestion.cfm?tab='+escape(n)+'&IdNoticia='+document.form1.IdNoticia.value;
				}		
			</script>		
		<cf_web_portlet_end>
	<cf_templatefooter>	


