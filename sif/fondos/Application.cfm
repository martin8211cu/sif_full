<!--- 
	Aplication CFM, de produccin, 
	rutas sobre SPEAPL21
---->
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

<cfif isdefined("url.CARPETA")>
	<cfset session.carpeta = url.CARPETA>
</cfif>
<cfif isdefined("url.PANTALLA")>
	<cfset session.pantalla = url.PANTALLA>
</cfif>


<cfif IsDefined("Form.logout")>
 	<cflogout>
	<cflocation url="http://speapl21:8080/servlet/soin.sif.cjc.cjc_PU?CARPETA=#session.carpeta#&PANTALLA=#session.pantalla#">
</cfif>

<cfset CFDatasource = "">
<cfset valsesion = "">

<cfif isdefined("url.IDSESSION")>
	<cfset valsesion = #ltrim(rtrim(url.IDSESSION))#>
<cfelse>
	<cfif isdefined("session.usuario")>
		<cfset CFDatasource = #session.dsn#>
		<cfset DSNSERVER    = #session.dsn#>
	</cfif>	
</cfif>

<!---
<cfquery datasource="sifweb"  name="QueryID" > 
<cfquery datasource="FONDOSWEB6"  name="QueryID" >
	select CJINT02USR,CJINT02CC
	from CJINT02
	where ltrim(rtrim(CJINT02IDE))= '#valsesion#'
</cfquery>
--->


<!--- REVISA EN REGATA --->
<cfquery datasource="FONDOSWEB6"  name="QueryID">
	select CJINT02USR,CJINT02CC from CJINT02
	where ltrim(rtrim(CJINT02IDE))='#valsesion#'
</cfquery>


<cfif QueryID.recordcount gt 0>	
	<cfset DSNSERVER = "FONDOSWEB6">
<cfelse>	

	<!--- REVISA EN SPEAPL07 
	<cfquery datasource="sifweb"  name="QueryID">
		select CJINT02USR,CJINT02CC from CJINT02
		where ltrim(rtrim(CJINT02IDE))='#valsesion#'
	</cfquery>--->

	<cfif QueryID.recordcount eq 0>
		<cfif not isdefined("session.usuario")>			
			<cflocation url="http://speapl21:8080/nossesionPU.htm">
		</cfif>
	<cfelse>		
		<cfset DSNSERVER = "sifweb">
	</cfif>
	
	
</cfif>	


<cfif QueryID.recordcount GT 0 >
	<!--- ADVV - Para saber cual datasource usar 
	<cfset CFDatasource = QueryID.CJINT02CC>--->

	<!--- Se le asigna al CFDatasource el DSNSERVER y se ponen harcode los nombres 
	      porque el conection cache se llama diferente en Jaguar.--->
	<cfset CFDatasource = #DSNSERVER#>


	<!--- <cfquery datasource="FONDOSWEB6"  name="QueryDEL" > --->
	<cfquery datasource="#DSNSERVER#"  name="QueryDEL" >
		delete CJINT02
		where ltrim(rtrim(CJINT02IDE))='#ltrim(rtrim(url.IDSESSION))#'
	</cfquery>
		
</cfif>


<cfif not isdefined("session.usuario") or session.usuario EQ "" or session.dsn EQ "" 
		or (isdefined("CFDatasource") AND Trim(CFdatasource) neq session.dsn) 
		or (isdefined("QueryID.CJINT02USR") and session.usuario neq QueryID.CJINT02USR)>
	<cflogin>
		<cfif not isdefined("QueryID")>
			<cflocation url="http://speapl21:8080/nossesionPU.htm"> 
		</cfif>

		<!--- <cfquery datasource="sifweb"  name="loginQuery" > --->
		<cfquery datasource="#DSNSERVER#"  name="loginQuery" >
			select CGE20COD,CGE20PAS  
			from sSOIN..CGE020 where 
			CGE20NOL =   '#QueryID.CJINT02USR#' 
		</cfquery>


		<cfif loginQuery.CGE20COD NEQ "">
			<cfloginuser name="#QueryID.CJINT02USR#" Password = "#loginQuery.CGE20PAS#"
			roles="0">
		<cfelse>
			<cflogout>
			<cflocation url="http://speapl21:8080/servlet/soin.sif.cjc.cjc_PU?CARPETA=#session.carpeta#&PANTALLA=#session.pantalla#">
	</cfif>
	</cflogin>
	<cfif IsDefined("url.IDSESSION")>
		<cfif GetAuthUser() NEQ QueryID.CJINT02USR >
				<cflogout>
				<cflocation url="http://speapl21:8080/servlet/soin.sif.cjc.cjc_PU?CARPETA=#session.carpeta#&PANTALLA=#session.pantalla#">
	   </cfif>
	</cfif>	
	<cflog file="AccesoSistema" text="el usuario #GetAuthUser()# acaba de ingresar (Fondos)">
	<cfif GetAuthUser() NEQ "" >
		<cfset session.usuario 			= GetAuthUser()>
		
		<!--- Agregado por advv para identificar datasource --->		
		<cfset session.dsn 		= #trim(CFDatasource)#>
		<cfset session.Fondos.dsn 	= #trim(CFDatasource)#>			

	
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
		<cfset session.Fondos.Caja 	= sql.CJ01ID>
		<cfset session.Fondos.Fondo 	= sql.CJM00COD>
		<cfset session.Fondos.Moneda 	= sql.MONCOD>
		<cfset session.Fondos.MonedaDes	= sql.MONDES>

	</cfif>
</cfif>
