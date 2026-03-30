<cfif isdefined('url.debug')>
	<cfset session.debug = true>
<cfelse>
	<cfset session.debug = false>
</cfif>

<!---para colocar un Header mas descriptivo--->
<cfif (isdefined('form.MIGMid') and len(trim(form.MIGMid))) OR (isdefined('url.MIGMid') and len(trim(url.MIGMid)))>
	<cfif isdefined('url.MIGMid') and len(trim(url.MIGMid))>
		<cfset form.MIGMid = url.MIGMid>
	</cfif>
	<cfquery datasource="#Session.DSN#" name="rsGetDat">
		select
				MIGMid,
				MIGMcodigo,
				MIGMnombre,
				Dactiva
		from MIGMetricas
		where MIGMid= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MIGMid#">
	</cfquery>

</cfif>

<cf_templateheader title="Catalogo Maestro Indicadores">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Catálogo Maestro Indicadores'>
	<cfif isdefined('rsGetDat.MIGMcodigo') and len(trim(rsGetDat.MIGMcodigo))>
		<table cellpadding="0" cellspacing="" border="0" width="100%">
			<tr><td align="center" style=" height:20; background-color:F3F3F3; color:666666"><cfoutput><strong>#rsGetDat.MIGMcodigo# - #rsGetDat.MIGMnombre#</strong></cfoutput></td></tr>
		</table>
	</cfif>

		<cfif  (isdefined('form.MIGMid') and len(trim(form.MIGMid))) OR (isdefined('form.Nuevo')) or isdefined(('url.MIGMid'))OR (isdefined('url.Nuevo'))>
			<cfinclude template="IndicadoresForm.cfm">
		<cfelse>
			<cfinclude template="IndicadoresLista.cfm">
		</cfif>
		<cfif isdefined ('form.Importar')>
			<cflocation url="IndicadoresImportador.cfm">
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>