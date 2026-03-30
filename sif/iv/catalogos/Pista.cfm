<cf_templateheader title="	Inventarios">
	
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Registro de Pistas'>
			<table width="100%">
				<tr><td>
					<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
					<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
						<cfset form.Pagina = url.Pagina>
					</cfif>
					<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
					<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
						<cfset form.Pagina = url.PageNum_Lista>
					</cfif>
					<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
					<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
						<cfset form.Pagina = form.PageNum>
					</cfif>
					<cfif isdefined('url.filtro_Codigo_pista') and not isdefined('form.filtro_Codigo_pista')>
						<cfset form.filtro_Codigo_pista = url.filtro_Codigo_pista>
					</cfif>
					<cfif isdefined('url.filtro_Descripcion_pista') and not isdefined('form.filtro_Descripcion_pista')>
						<cfset form.filtro_Descripcion_pista = url.filtro_Descripcion_pista>
					</cfif>
					<cfif isdefined('url.filtro_Pestado') and not isdefined('form.filtro_Pestado')>
						<cfset form.filtro_Pestado = url.filtro_Pestado>
					</cfif>
					<cfif isdefined('url.Pista_id') and not isdefined('form.Pista_id')>
						<cfset form.Pista_id = url.Pista_id>
					</cfif>
					
					<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
					<cfparam name="form.Pagina" default="1">
					<cfparam name="form.MaxRows" default="15">	
									
					<cfinclude template="Pista-form.cfm">
				</td></tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>