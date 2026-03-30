<cfparam name="URL.debug" default="false">

<cfset LvarPar = ''>
<cfif isdefined("session.LvarJA") and session.LvarJA>
	<cfset LvarPar = ''>
<cfelseif isdefined("session.LvarJA") and not session.LvarJA>
	<cfset LvarPar = ''>
</cfif>

<cfset fnFiltros_AGT()>
<cfif isdefined("btnImportar")>
	<cflocation url="agtProceso_Importa.cfm?number=1&IDtrans=#IDtrans#">
</cfif>
<!---lista--->

<cf_templateheader title="Activos Fijos">
  <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#botonAccion[IDtrans][3]#">
		<form name="fagtproceso" action="agtProceso_sql_<cfoutput>#botonAccion[IDtrans][1]##LvarPar#</cfoutput>.cfm" method="post">
			<table border="0" align="center" width="100%">
				<tr>
						<cfif isdefined('descripProcess')><td valign="top" align="right" width="45%"><cfoutput>#descripProcess#</cfoutput></td></cfif>
					<td>
						<cfif IDtrans EQ 14 or IDtrans EQ 3>
							<input name="params" type="hidden" value="<cfoutput>#params#</cfoutput>">
						</cfif>
							<input name="debug" type="hidden" value="<cfoutput>#URL.debug#</cfoutput>">                           
						<cfinclude template="agtProceso_#botonAccion[IDtrans][2]#.cfm">
					</td>
				</tr>
			</table>
		</form>
	<cf_web_portlet_end>
<cf_templatefooter>

<cffunction name="fnFiltros_AGT" access="private" output="no" hint="Genera las variables de control">
	<!--- FILTRO POR URL --->
	<cfif isdefined('url.Filtro_AGTPdescripcion') and not isdefined('form.Filtro_AGTPdescripcion')>
		<cfset form.Filtro_AGTPdescripcion = url.Filtro_AGTPdescripcion>
	</cfif>
	<cfif isdefined('url.Filtro_AGTPestadoDesc') and not isdefined('form.Filtro_AGTPestadoDesc')>
		<cfset form.Filtro_AGTPestadoDesc = url.Filtro_AGTPestadoDesc>
	</cfif>
	<cfif isdefined('url.Filtro_AGTPfalta') and not isdefined('form.Filtro_AGTPfalta')>
		<cfset form.Filtro_AGTPfalta = url.Filtro_AGTPfalta>
	</cfif>
	<cfif isdefined('url.Filtro_AGTPmesDesc') and not isdefined('form.Filtro_AGTPmesDesc')>
		<cfset form.Filtro_AGTPmesDesc = url.Filtro_AGTPmesDesc>
	</cfif>
	<cfif isdefined('url.Filtro_AGTPperiodo') and not isdefined('form.Filtro_AGTPperiodo')>
		<cfset form.Filtro_AGTPperiodo = url.Filtro_AGTPperiodo>
	</cfif>
	<cfif isdefined('url.HFiltro_AGTPdescripcion') and not isdefined('form.Filtro_AGTPdescripcion')>
		<cfset form.HFiltro_AGTPdescripcion = url.HFiltro_AGTPdescripcion>
	</cfif>
	<cfif isdefined('url.HFiltro_AGTPestadoDesc') and not isdefined('form.Filtro_AGTPestadoDesc')>
		<cfset form.HFiltro_AGTPestadoDesc = url.HFiltro_AGTPestadoDesc>
	</cfif>
	<cfif isdefined('url.HFiltro_AGTPfalta') and not isdefined('form.Filtro_AGTPfalta')>
		<cfset form.HFiltro_AGTPfalta = url.HFiltro_AGTPfalta>
	</cfif>
	<cfif isdefined('url.HFiltro_AGTPmesDesc') and not isdefined('form.Filtro_AGTPmesDesc')>
		<cfset form.HFiltro_AGTPmesDesc = url.HFiltro_AGTPmesDesc>
	</cfif>
	<cfif isdefined('url.HFiltro_AGTPperiodo') and not isdefined('form.HFiltro_AGTPperiodo')>
		<cfset form.HFiltro_AGTPperiodo = url.HFiltro_AGTPperiodo>
	</cfif>
	
	<cfif isdefined('url.Pagina') and not isdefined('form.Pagina')>
		<cfset form.Pagina = url.Pagina>
	</cfif>
	<!--- FIN FILTRO POR URL --->
	
	<!---IDtrans--->
	<cfif isdefined("url.IDtrans") and not (isdefined("IDtrans") and len(trim(IDtrans)))><cfset idtrans = url.IDtrans></cfif>
	<cfif isdefined("form.IDtrans") and not (isdefined("IDtrans") and len(trim(IDtrans)))><cfset idtrans = form.IDtrans></cfif>
	
	<cfparam name="IDtrans">
	<!--- FILTROS DE LA LISTA --->
	<cfset params = ''>
	<cfif isdefined('form.Filtro_AGTPdescripcion')>
		<cfset params = params & 'Filtro_AGTPdescripcion=#form.Filtro_AGTPdescripcion#'>
	</cfif>
	<cfif isdefined('form.Filtro_AGTPestadoDesc')>
		<cfset params = params & '&Filtro_AGTPestadoDesc=#form.Filtro_AGTPestadoDesc#'>
	</cfif>
	<cfif isdefined('form.Filtro_AGTPfalta')>
		<cfset params = params & '&Filtro_AGTPfalta=#form.Filtro_AGTPfalta#'>
	</cfif>
	<cfif isdefined('form.Filtro_AGTPmesDesc')>
		<cfset params = params & '&Filtro_AGTPmesDesc=#form.Filtro_AGTPmesDesc#'>
	</cfif>
	<cfif isdefined('form.Filtro_AGTPperiodo')>
		<cfset params = params & '&Filtro_AGTPperiodo=#form.Filtro_AGTPperiodo#'>
	</cfif>
	<cfif isdefined('form.HFiltro_AGTPdescripcion')>
		<cfset params = params & '&HFiltro_AGTPdescripcion=#form.HFiltro_AGTPdescripcion#'>
	</cfif>
	<cfif isdefined('form.HFiltro_AGTPestadoDesc')>
		<cfset params = params & '&HFiltro_AGTPestadoDesc=#form.HFiltro_AGTPestadoDesc#'>
	</cfif>
	<cfif isdefined('form.HFiltro_AGTPfalta')>
		<cfset params = params & '&HFiltro_AGTPfalta=#form.HFiltro_AGTPfalta#'>
	</cfif>
	<cfif isdefined('form.HFiltro_AGTPmesDesc')>
		<cfset params = params & '&HFiltro_AGTPmesDesc=#form.HFiltro_AGTPmesDesc#'>
	</cfif>
	<cfif isdefined('form.HFiltro_AGTPperiodo')>
		<cfset params = params & '&HFiltro_AGTPperiodo=#form.HFiltro_AGTPperiodo#'>
	</cfif>
	<cfif isdefined('IDtrans')>
		<cfset params = params & '&IDtrans=#IDtrans#'>
	</cfif>
	
	<cfif isdefined('form.Pagina')>
		<cfset params = params & '&Pagina=#form.Pagina#'>
	</cfif>
	<cfif isdefined('form.params') and LEN(TRIM(form.params))>
		<cfset params = form.params>
	</cfif>
	
	<!---filtro--->
	<cfset filtro = "Ecodigo=#session.Ecodigo# and IDtrans=#IDtrans#">
	<!---navegacion--->
	<cfset navegacion = "&IDtrans=#IDtrans#">
	<!---curentPage obtiene la pagina actual porque este fuente puede estar incluido en varios archivos.--->
	<cfset currentPage = GetFileFromPath(GetTemplatePath())>
	<!---botonAccion define la descripcion y la acción del boton de acuerdo con el IDtrans recibido --->
	<cfset botonAccion = ArrayNew(2)>
	
	<cfset botonAccion[14][1] = "Retiro_Fiscal">
	<cfset botonAccion[14][2] = "filtro_Retiro_Fiscal">
	<cfset botonAccion[14][3] = "Generaci&oacute;n de Grupos de Transacciones de Retiro Fiscal">
	<cfset botonAccion[14][4] = "Retiro_Fiscal">
</cffunction>
