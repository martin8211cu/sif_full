<cfparam name="URL.debug" default="false">

<cfset fnFiltros_AGT()>
<cfif isdefined("btnImportar")>
	<cflocation url="agtProceso_Importa.cfm?number=1&IDtrans=#IDtrans#">
</cfif>
<!---lista--->

<cfif isdefined('form.BTNNUEVO') and IDtrans eq 11 and isdefined("session.LvarJA")>
	<cfset StructDelete(session,'LvarJA')>
</cfif>

<cfset LvarPar = ''>
<cfif isdefined("session.LvarJA") and session.LvarJA and botonAccion[IDtrans][1] NEQ botonAccion[8][1] and botonAccion[IDtrans][1] NEQ botonAccion[6][1] and botonAccion[IDtrans][1] NEQ botonAccion[3][1] and botonAccion[IDtrans][1] NEQ botonAccion[7][1] and botonAccion[IDtrans][1] NEQ botonAccion[10][1]>
	<cfset LvarPar = '_JA'>
<cfelseif isdefined("session.LvarJA") and not session.LvarJA and botonAccion[IDtrans][1] NEQ botonAccion[8][1] >
	<cfset LvarPar = '_Aux'>
</cfif>


<cf_templateheader title="Activos Fijos">
  <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#botonAccion[IDtrans][3]#">
		<form name="fagtproceso" action="agtProceso_sql_<cfoutput>#botonAccion[IDtrans][1]##LvarPar#</cfoutput>.cfm" method="post">
			<table border="0" align="center" width="100%">
				<tr>
						<cfif isdefined('descripProcess')><td valign="top" align="right" width="45%"><cfoutput>#descripProcess#</cfoutput></td></cfif>
					<td>
						<cfif IDtrans EQ 4 or IDtrans EQ 3>
							<input name="params" type="hidden" value="<cfoutput>#params#</cfoutput>">
						</cfif>
                        <cfif IDtrans NEQ 11>
							<input name="debug" type="hidden" value="<cfoutput>#URL.debug#</cfoutput>">
                        </cfif>
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
	
	<cfset botonAccion[4][1] = "DEPRECIACION">
	<cfset botonAccion[4][2] = "filtro">
	<cfset botonAccion[4][3] = "Generaci&oacute;n de Grupos de Transacciones de Depreciaci&oacute;n">
	<cfset botonAccion[4][4] = "Depreciación">
	
	<cfset botonAccion[3][1] = "REVALUACION">
	<cfset botonAccion[3][2] = "filtro">
	<cfset botonAccion[3][3] = "Generaci&oacute;n de Grupos de Transacciones de Revaluaci&oacute;n">
	<cfset botonAccion[3][4] = "Revaluación">
	
	<cfset botonAccion[5][1] = "RETIRO">
	<cfset botonAccion[5][2] = "registro">
	<cfset botonAccion[5][3] = "Grupos de Transacciones de Retiro">
	<cfset botonAccion[5][4] = "Retiro">
	
	<cfset botonAccion[8][1] = "TRASLADO">
	<cfset botonAccion[8][2] = "registro">
	<cfset botonAccion[8][3] = "Grupos de Transacciones de Traslado">
	<cfset botonAccion[8][4] = "Traslado">
	
	<cfset botonAccion[6][1] = "CAMCATCLAS">
	<cfset botonAccion[6][2] = "registro_camcatclas">
	<cfset botonAccion[6][3] = "Grupos de Transacciones de Cambio de Categoría Clase">
	<cfset botonAccion[6][4] = "Cambio Categoría Clase">
	
	<cfset botonAccion[7][1] = "CAMTIPO">
	<cfset botonAccion[7][2] = "registro_camtipo">
	<cfset botonAccion[7][3] = "Grupos de Transacciones de Cambio de tipo">
	<cfset botonAccion[7][4] = "Cambio de tipo">
	
	<cfset botonAccion[2][1] = "MEJORA">
	<cfset botonAccion[2][2] = "registro_mejora">
	<cfset botonAccion[2][3] = "Grupos de Transacciones de Mejora">
	<cfset botonAccion[2][4] = "Mejora">
	
	<cfset botonAccion[10][1] = "CAMPLACA">
	<cfset botonAccion[10][2] = "registro_camplaca">
	<cfset botonAccion[10][3] = "Grupos de Transacciones de Cambio de placa">
	<cfset botonAccion[10][4] = "Cambio de placa">
    
    	
	<cfset botonAccion[11][1] = "Salida">
	<cfset botonAccion[11][2] = "registro_salida">
	<cfset botonAccion[11][3] = "Grupos de Transacciones de Salida de Activo">
	<cfset botonAccion[11][4] = "Salida de Activo">
    
</cffunction>
