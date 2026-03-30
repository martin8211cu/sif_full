	<cfif isdefined('url.tipo')  and url.tipo EQ 'D'>
	<cfset regresa = 'RegistroFacturas.cfm?'>
	<cfelseif isdefined('url.tipo')  and url.tipo EQ 'C'>
	<cfset regresa = 'RegistroNotasCredito.cfm?'>
	</cfif>
	<cfif isdefined('url.tipo')>
		<cfset regresa = regresa & 'tipo=#url.tipo#'>
	</cfif>
	<cfif isdefined('url.Filtro_CCTdescripcion')>
		<cfset regresa = regresa & '&Filtro_CCTdescripcion=#url.Filtro_CCTdescripcion#'>
	</cfif>
	<cfif isdefined('url.Filtro_EDdocumento')>
		<cfset regresa = regresa & '&Filtro_EDdocumento=#url.Filtro_EDdocumento#'>
	</cfif>
	<cfif isdefined('url.Filtro_EDFecha')>
		<cfset regresa = regresa & '&Filtro_EDFecha=#url.Filtro_EDFecha#'>
	</cfif>
	<cfif isdefined('url.Filtro_EDUsuario')>
		<cfset regresa = regresa & '&Filtro_EDUsuario=#url.Filtro_EDUsuario#'>
	</cfif>
	<cfif isdefined('url.Filtro_Mnombre')>
		<cfset regresa = regresa & '&Filtro_Mnombre=#url.Filtro_Mnombre#'>
	</cfif>
	<cfif isdefined('url.hFiltro_CCTdescripcion')>
		<cfset regresa = regresa & '&hFiltro_CCTdescripcion=#url.hFiltro_CCTdescripcion#'>
	</cfif>
	<cfif isdefined('url.hFiltro_EDdocumento')>
		<cfset regresa = regresa & '&hFiltro_EDdocumento=#url.hFiltro_EDdocumento#'>
	</cfif>
	<cfif isdefined('url.hFiltro_EDFecha')>
		<cfset regresa = regresa & '&hFiltro_EDFecha=#url.hFiltro_EDFecha#'>
	</cfif>
	<cfif isdefined('url.hFiltro_EDUsuario')>
		<cfset regresa = regresa & '&hFiltro_EDUsuario=#url.hFiltro_EDUsuario#'>
	</cfif>
	<cfif isdefined('url.hFiltro_Mnombre')>
		<cfset regresa = regresa & '&hFiltro_Mnombre=#url.hFiltro_Mnombre#'>
	</cfif>
	<cfif isdefined('url.Filtro_FechasMayores')>
		<cfset regresa = regresa & '&Filtro_FechasMayores=#url.Filtro_FechasMayores#'>
	</cfif>
	<cfif isdefined('url.Pagina')>
		<cfset regresa = regresa & '&Pagina=#url.Pagina#'>
	</cfif>
<cf_templateheader title="Importador Ventas">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importación de Ventas">
					<table width="100%" border="0" cellspacing="1" cellpadding="1">
						<tr>
							<td valign="top" width="60%"><cf_sifFormatoArchivoImpr EIcodigo = 'VENTAS'></td>
							<td valign="top" align="center"><cf_sifimportar eicodigo="VENTAS" mode="in"/></td>
							<td valign="top"><cf_botones exclude="ALTA,CAMBIO,BAJA,LIMPIAR" Regresar='#regresa#'></td>
					 	</tr>
				   </table>	
		<cf_web_portlet_end>
<cf_templatefooter>