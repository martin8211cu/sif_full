
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
		<cfoutput>#pNavegacion#</cfoutput>
		<cfif IsDefined('form.CCTcodigo')><cfset url.CCTcodigo = form.CCTcodigo></cfif>
		<cfif IsDefined('form.Ddocumento')><cfset url.Ddocumento = form.Ddocumento></cfif>
		<cfparam name="url.CCTcodigo" default="">
		<cfparam name="url.Ddocumento" default="">
		<cfset form.params = ''>
		<cfif isdefined('url.Pagina') and LEN(TRIM(url.Pagina)) and not isdefined('form.Pagina')>
			<cfset form.Pagina = url.Pagina>
		</cfif>
		<cfif isdefined('url.Filtro_CCTdescripcion') and LEN(TRIM(url.Filtro_CCTdescripcion)) and not isdefined('form.Filtro_CCTdescripcion')>
			<cfset form.Filtro_CCTdescripcion = url.Filtro_CCTdescripcion>
		</cfif>
		<cfif isdefined('url.Filtro_Ddocumento') and LEN(TRIM(url.Filtro_Ddocumento)) and not isdefined('form.Filtro_Ddocumento')>
			<cfset form.Filtro_Ddocumento = url.Filtro_Ddocumento>
		</cfif>
		<cfif isdefined('url.Filtro_Dfecha') and LEN(TRIM(url.Filtro_Dfecha)) and not isdefined('form.Filtro_Dfecha')>
			<cfset form.Filtro_Dfecha = url.Filtro_Dfecha>
		</cfif>
		<cfif isdefined('url.Filtro_Dsaldo') and LEN(TRIM(url.Filtro_Dsaldo)) and not isdefined('form.Filtro_Dsaldo')>
			<cfset form.Filtro_Dsaldo = url.Filtro_Dsaldo>
		</cfif>
		<cfif isdefined('url.Filtro_Dtotal') and LEN(TRIM(url.Filtro_Dtotal)) and not isdefined('form.Filtro_Dtotal')>
			<cfset form.Filtro_Dtotal = url.Filtro_Dtotal>
		</cfif>
		<cfif isdefined('url.Filtro_FechasMayores') and not isdefined('form.Filtro_FechasMayores')>
			<cfset form.Filtro_FechasMayores = url.Filtro_FechasMayores>
		</cfif>
		<cfif isdefined('url.Filtro_Mnombre') and LEN(TRIM(url.Filtro_Mnombre)) and not isdefined('form.Filtro_Mnombre')>
			<cfset form.Filtro_Mnombre = url.Filtro_Mnombre>
		</cfif>
		<cfif isdefined('url.Filtro_SNidentificacion') and LEN(TRIM(url.Filtro_SNidentificacion)) and not isdefined('form.Filtro_SNidentificacion')>
			<cfset form.Filtro_SNidentificacion = url.Filtro_SNidentificacion>
		</cfif>
		<cfif isdefined('url.Filtro_SNnombre') and LEN(TRIM(url.Filtro_SNnombre)) and not isdefined('form.Filtro_SNnombre')>
			<cfset form.Filtro_SNnombre = url.Filtro_SNnombre>
		</cfif>
		
		<cfif isdefined('form.Pagina')>
			<cfset form.params = form.params & "Pagina=#form.Pagina#">
		</cfif>
		<cfif isdefined('form.Filtro_CCTdescripcion')>
			<cfset form.params = form.params & "&Filtro_CCTdescripcion=#form.Filtro_CCTdescripcion#">
		</cfif>
		<cfif isdefined('form.Filtro_Ddocumento')>
			<cfset form.params = form.params & "&Filtro_Ddocumento=#form.Filtro_Ddocumento#&hFiltro_Ddocumento=#form.Filtro_Ddocumento#">
		</cfif>
		<cfif isdefined('form.Filtro_Dfecha')>
			<cfset form.params = form.params & "&Filtro_Dfecha=#form.Filtro_Dfecha#&hFiltro_Dfecha=#form.Filtro_Dfecha#">
		</cfif>
		<cfif isdefined('form.Filtro_Dsaldo')>
			<cfset form.params = form.params & "&Filtro_Dsaldo=#form.Filtro_Dsaldo#&hFiltro_Dsaldo=#form.Filtro_Dsaldo#">
		</cfif>
		<cfif isdefined('form.Filtro_Dtotal')>
			<cfset form.params = form.params & "&Filtro_Dtotal=#form.Filtro_Dtotal#&hFiltro_Dtotal=#form.Filtro_Dtotal#">
		</cfif>
		<cfif isdefined('form.Filtro_FechasMayores')>
			<cfset form.params = form.params & "&Filtro_FechasMayores=#form.Filtro_FechasMayores#&hFiltro_FechasMayores=#form.Filtro_FechasMayores#">
		</cfif>
		<cfif isdefined('form.Filtro_Mnombre')>
			<cfset form.params = form.params & "&Filtro_Mnombre=#form.Filtro_Mnombre#&hFiltro_Mnombre=#form.Filtro_Mnombre#">
		</cfif>
		<cfif isdefined('form.Filtro_SNidentificacion')>
			<cfset form.params = form.params & "&Filtro_SNidentificacion=#form.Filtro_SNidentificacion#&hFiltro_SNidentificacion=#form.Filtro_SNidentificacion#">
		</cfif>
		<cfif isdefined('form.Filtro_SNnombre')>
			<cfset form.params = form.params & "&Filtro_SNnombre=#form.Filtro_SNnombre#&hFiltro_SNnombre=#form.Filtro_SNnombre#">
		</cfif>
		
		<table>
			<tr><td colspan="4"><cfinclude template="ver_factura.cfm"></td></tr>
			<tr>
				<td width="450" valign="top"><cfinclude template="plan_actual.cfm"></td>
				<td width="0"></td><td width="451" valign="top">
					<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Nuevo plan de Financiamiento">
						<cfinclude template="index2_form.cfm">
					<cf_web_portlet_end>
				</td>
			</tr>
		</table>
	<cf_templatefooter>