<cftry>
	
	<cfquery name="rsUsuario" datasource="asp">
		update Usuario
		set LOCIdioma = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.LOCIdioma#">
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	</cfquery>
	<cfset session.Idioma = Form.LOCIdioma>

	<cfif IsDefined('form.skin')>

		<cfset UserCSS = GetDirectoryFromPath(session.sitio.css) & form.skin>
		<cfif FileExists (ExpandPath(UserCSS)) or Len(form.skin) EQ 0>
			<cfquery name="abc_skin" datasource="asp">
				update Preferencias 
				set skin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.skin#" null="#Len(form.skin) EQ 0#">
					,enterActionDefault = <cfqueryparam cfsqltype="cf_sql_char" value="#form.enterActionDefault#">
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			</cfquery>
			<cfset session.sitio.enterActionDefault = form.enterActionDefault>
			<cfoutput>#GetDirectoryFromPath(session.sitio.css) & form.skin#</cfoutput>
			<cfif Len(form.skin)>
				<cfset session.sitio.css = UserCSS >
			</cfif>
		<cfelse>
			<cfthrow message="CSS no existe:#UserCSS#">
		</cfif>
	</cfif>

<cfcatch type="database">
	<cfinclude template="/sif/errorPages/BDerror.cfm">
	<cfabort>
</cfcatch>
</cftry>

<cflocation url="index.cfm?tab=3">