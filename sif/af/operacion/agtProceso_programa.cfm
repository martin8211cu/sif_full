<cfset LvarPar = ''>
<cfif isdefined("session.LvarJA") and session.LvarJA>
	<cfset LvarPar = '_JA'>
<cfelseif isdefined("session.LvarJA") and not session.LvarJA>
	<cfset LvarPar = '_Aux'>
</cfif>

<!--- FILTROS DE LA LISTA --->

<cfset params = ''>
<cfif isdefined('url.Filtro_AGTPdescripcion')>
	<cfset params = params & 'Filtro_AGTPdescripcion=#url.Filtro_AGTPdescripcion#'>
</cfif>
<cfif isdefined('url.Filtro_AGTPestadoDesc')>
	<cfset params = params & '&Filtro_AGTPestadoDesc=#url.Filtro_AGTPestadoDesc#'>
</cfif>
<cfif isdefined('url.Filtro_AGTPfalta')>
	<cfset params = params & '&Filtro_AGTPfalta=#url.Filtro_AGTPfalta#'>
</cfif>
<cfif isdefined('url.Filtro_AGTPmesDesc')>
	<cfset params = params & '&Filtro_AGTPmesDesc=#url.Filtro_AGTPmesDesc#'>
</cfif>
<cfif isdefined('url.Filtro_AGTPperiodo')>
	<cfset params = params & '&Filtro_AGTPperiodo=#url.Filtro_AGTPperiodo#'>
</cfif>
<cfif isdefined('url.HFiltro_AGTPdescripcion')>
	<cfset params = params & '&HFiltro_AGTPdescripcion=#form.HFiltro_AGTPdescripcion#'>
</cfif>
<cfif isdefined('url.HFiltro_AGTPestadoDesc')>
	<cfset params = params & '&HFiltro_AGTPestadoDesc=#url.HFiltro_AGTPestadoDesc#'>
</cfif>
<cfif isdefined('url.HFiltro_AGTPfalta')>
	<cfset params = params & '&HFiltro_AGTPfalta=#url.HFiltro_AGTPfalta#'>
</cfif>
<cfif isdefined('url.HFiltro_AGTPmesDesc')>
	<cfset params = params & '&HFiltro_AGTPmesDesc=#url.HFiltro_AGTPmesDesc#'>
</cfif>
<cfif isdefined('url.HFiltro_AGTPperiodo')>
	<cfset params = params & '&HFiltro_AGTPperiodo=#url.HFiltro_AGTPperiodo#'>
</cfif>
<cfif isdefined('IDtrans')>
	<cfset params = params & '&IDtrans=#IDtrans#'>
</cfif>
<cfif isdefined('url.Pagina')>
	<cfset params = params & '&Pagina=#url.Pagina#'>
</cfif>

<!---IDtrans--->
<cfif isdefined("url.IDtrans") and not (isdefined("IDtrans") and len(trim(IDtrans)))><cfset idtrans = url.IDtrans></cfif>
<cfif isdefined("form.IDtrans") and not (isdefined("IDtrans") and len(trim(IDtrans)))><cfset idtrans = form.IDtrans></cfif>
<cfparam name="IDtrans">
<!---filtro--->
<cfset filtro = "Ecodigo=#session.Ecodigo# and IDtrans=#IDtrans#">
<!---navegacion--->
<cfset navegacion = "&IDtrans=#IDtrans#">
<!---curentPage obtiene la pagina actual porque este fuente puede estar incluido en varios archivos.--->
<cfset currentPage = GetFileFromPath(GetTemplatePath())>
<!---botonAccion define la descripcion y la acción del boton de acuerdo con el IDtrans recibido --->
<cfset botonAccion = ArrayNew(2)>
<cfset botonAccion[4][1] = "DEPRECIACION">
<cfset botonAccion[4][2] = "Programación de Aplicación de Grupos de Transacciones de Depreciaci&oacute;n">
<cfset botonAccion[3][1] = "REVALUACION">
<cfset botonAccion[3][2] = "Generaci&oacute;n de Grupos de Transacciones de Revaluaci&oacute;n">
<!---lista--->
<cf_templateheader title="Activos Fijos">
	  <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#botonAccion[IDtrans][2]#">
			<form action="agtProceso_sql_<cfoutput>#botonAccion[IDtrans][1]##LvarPar#</cfoutput>.cfm" method="post" name="fagtproceso">
				<cfoutput><input name="params" type="hidden" value="#params#"></cfoutput>
				<table border="0" cellspacing="0" cellpadding="0" align="center">
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td>
						<fieldset><legend>Ingrese la Fecha y hora en que desea programar el evento: </legend>
							<cfinclude template="agtProceso_frProgramacion.cfm">
						</fieldset>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
			<cf_botones values="Aplicar, Programar, Regresar" names="btnAplicar, btnProgramarAplicacion, btnRegresar">
			<br>
			<input name="chk" id="chk" type="hidden" value="<cfoutput>#form.chk#</cfoutput>">
		</form>
		<cf_web_portlet_end>
	<cf_templatefooter>

<!---funciones en javascript de los botones--->
<script language="javascript" type="text/javascript">
<!--//
	function funcbtnRegresar(){
		<cfoutput>
			document.fagtproceso.action = "agtProceso_#botonAccion[IDtrans][1]##LvarPar#.cfm?#params#";
		</cfoutput>
	}
//-->
</script>