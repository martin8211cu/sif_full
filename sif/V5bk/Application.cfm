<!--- <cfinclude template="../Application.cfm"> --->
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
	<cflocation url="http://10.7.7.23/servlet/soin.sif.cjc.cjc_PU?CARPETA=#url.CARPETA#&PANTALLA=#url.PANTALLA#">
</cfif>
<cfif IsDefined("url.IDSESSION")>
	<cfquery datasource="sifweb"  name="QueryID" >
		select CJINT02USR,CJINT02CC from CJINT02
		where ltrim(rtrim(CJINT02IDE))='#ltrim(rtrim(url.IDSESSION))#'
	</cfquery>
	<cfif isdefined("QueryID") and QueryID.recordcount eq 0>	
		<cflocation url="http://10.7.7.23/nossesionPU.htm"> 
	</cfif>
	<cfquery datasource="sifweb"  name="QueryDEL" >
		delete CJINT02
		where ltrim(rtrim(CJINT02IDE))='#ltrim(rtrim(url.IDSESSION))#'
	</cfquery>
</cfif>

<cflogin>
	<cfif not isdefined("QueryID")>
		<cflocation url="http://10.7.7.23/nossesionPU.htm"> 
	</cfif>
	<cfquery datasource="sifweb"  name="loginQuery" >
		select CGE20COD,CGE20PAS  from sSOIN..CGE020 where 
		CGE20NOL =   '#QueryID.CJINT02USR#' 
	</cfquery>
	<cfif loginQuery.CGE20COD NEQ "">
		<cfloginuser name="#QueryID.CJINT02USR#" Password = "#loginQuery.CGE20PAS#"
		roles="0">
	<cfelse>
 		<cflogout>
		<cflocation url="http://10.7.7.23/servlet/soin.sif.cjc.cjc_PU?CARPETA=#url.CARPETA#&PANTALLA=#url.PANTALLA#">
</cfif>
</cflogin>
<cfif IsDefined("url.IDSESSION")>
	<cfif GetAuthUser() NEQ QueryID.CJINT02USR >
 			<cflogout>
			<cflocation url="http://10.7.7.23/servlet/soin.sif.cjc.cjc_PU?CARPETA=#url.CARPETA#&PANTALLA=#url.PANTALLA#">
   </cfif>
</cfif>	
<cfif GetAuthUser() NEQ "" >
	<cfset session.usuario 			= GetAuthUser()>
	<cfset session.dsn 				= "sifweb">
	<cfset session.Fondos.dsn 		= "sifweb">

	<cfquery datasource="#session.Fondos.dsn#"  name="sql" >	
		select CJ1PER ,CJ1MES from CJP001
	</cfquery>
	<cfset session.Fondos.Anno 		= sql.CJ1PER>
	<cfset session.Fondos.Mes  		= sql.CJ1MES>
	<cfquery datasource="#session.Fondos.dsn#"  name="sql" >	
		SELECT CJ01ID,CJM00COD,CGE1COD,CGE5COD,CJM001.MONCOD,MONDES  
		FROM CJM001,CCM001 
		WHERE CJM001.MONCOD = CCM001.MONCOD 
		AND CJ1LOG = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#" >
	</cfquery>
	<cfset session.Fondos.Empresa 	= sql.CGE1COD>
	<cfset session.Fondos.Sucursal 	= sql.CGE5COD>
	<cfset session.Fondos.Caja 		= sql.CJ01ID>
	<cfset session.Fondos.Fondo 	= sql.CJM00COD>
	<cfset session.Fondos.Moneda 	= sql.MONCOD>
	<cfset session.Fondos.MonedaDes	= sql.MONDES>
<!--- 	<cfoutput>
		<form  action="" method="Post">
			<input type="submit" Name="Logout" value="Logout">
		</form>
	</cfoutput>  --->
</cfif>



