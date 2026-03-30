<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="UsuariosCaja" datasource="#Session.DSN#">
			set nocount on			
			<cfif isdefined("Form.Alta")>
				if not exists 
				(
					select * 
					from UsuariosCaja 
					where 
						FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
						and EUcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EUcodigo#">
				)				
					insert UsuariosCaja (FCid, EUcodigo, Usucodigo, Ulocalizacion, Usulogin)
					values
					(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EUcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ulocalizacion#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#JSStringFormat(Form.Usulogin)#">
					)
				select 1
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
				delete from FCajasActivas
				where 
					FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
					and EUcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EUcodigo#">
				delete from UsuariosCaja 
				where 
					FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
					and EUcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EUcodigo#">
				<cfset modo="BAJA">
			</cfif>
			set nocount off
		</cfquery>
	<cfcatch type="database">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<form action="UsuariosCaja.cfm" method="post" name="sql">
	<cfif isDefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="<cfoutput>#Form.Nuevo#</cfoutput>">
	</cfif>	
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="FCid" type="hidden" value="<cfif isdefined("Form.FCid")><cfoutput>#Form.FCid#</cfoutput></cfif>">
	<input name="EUcodigo" type="hidden" value="<cfif isdefined("Form.EUcodigo")><cfoutput>#Form.EUcodigo#</cfoutput></cfif>">
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">		
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>