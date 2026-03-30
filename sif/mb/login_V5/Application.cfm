<cfsetting enablecfoutputonly="yes">
	<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="Yes"
	setclientcookies="Yes"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>
<cfset res = setLocale("English (Canadian)")>
<cfheader name = "Expires" value = "0">
<cfparam name="Session.Idioma" default="ES_CR">
<cfinclude template="../Utiles/SIFfunciones.cfm">
<cfparam name="Session.Preferences.Skin" default="ocean">
<cfparam name="Session.Preferences.SkinMenu" default="ocean">
<cfsetting enablecfoutputonly="no">

<cfif IsDefined("Form.logout")>
 	<cflogout>
	<!--- <cflocation  url="loginform.cfm"> --->
	<script language="JavaScript">
		top.location.href="http://desarrollo/cfmx/sif/login_V5/menu.cfm"
	</script>
	
</cfif>
<cflogin>
	<cfif NOT IsDefined("cflogin")>
		<cfinclude template="loginform.cfm">
		<cfabort>
	<cfelse>
		<cfif cflogin.name IS "" OR cflogin.password IS "">
			<cfoutput>
				<H2>Ingresar login y password</H2>
			</cfoutput>
			<cfinclude template="loginform.cfm">
			<cfabort>
		<cfelse>
			<cfquery datasource="sifweb"  name="loginQuery" >
				select CGE20COD  from sSOIN..CGE020 where 
				CGE20NOL = '#cflogin.name#' 
				and CGE20PAS ='#cflogin.password#'
			</cfquery>
			
			<cfif loginQuery.recordcount gt 0>		
				<cfset session.usrID 	= loginQuery.CGE20COD>
				<cfloginuser name="#cflogin.name#" Password = "#cflogin.password#"
				roles="0">
			<cfelse>
				<cfoutput>
					<H2>Login invalido<br>
					intente de nuevo</H2>
				</cfoutput>	
				<cfinclude template="loginform.cfm">
				<cfabort>
			</cfif>
		</cfif>	
	</cfif>
</cflogin>
<cfif GetAuthUser() NEQ "">
	<cfset session.usuario = GetAuthUser()>
	<cfset session.ID 		= CreateUUID()>
	<cfset session.dsn 		= "sifweb">
	


	<cfquery datasource="#session.dsn#"  name="sql" >	
		select CJ1PER ,CJ1MES from CJP001
	</cfquery>
	<cfset session.Fondos.Anno 		= sql.CJ1PER>
	<cfset session.Fondos.Mes  		= sql.CJ1MES>
	
	<!--- <cfquery datasource="#session.dsn#"  name="RS_agregar">	
	 	insert	CJINT02 (
				CJINT02IDE,
				CJINT02USR,
				CJINT02CC ) 
		values (
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ID#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
		'sifweb')
	</cfquery> --->
</cfif>



