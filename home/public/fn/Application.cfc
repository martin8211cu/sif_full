<cfcomponent displayname="Application" output="true" hint="Handle the application.">
	<!--- Set up the application. --->	
	<cfset THIS.Name               = "SIF_ASP" />
	<cfset THIS.SessionManagement  = true />
	<cfset THIS.ClientManagement   = False/>
	<cfset THIS.ApplicationTimeout = CreateTimeSpan( 0, 10, 0, 0 ) />	
	<cfset THIS.SetClientCookies   = True />

	<!--- Define the page request properties. --->
	<cfsetting requesttimeout="20" showdebugoutput="false" enablecfoutputonly="false"/>


	<cffunction name="OnApplicationStart" access="public" returntype="boolean" output="false" hint="Fires when the application is first created.">

		<!--- Return out. --->
		<cfreturn true />
	</cffunction>


	<cffunction name="OnSessionStart" access="public" returntype="void" output="false" hint="Fires when the session is first created.">
		<cfparam name="Session.Idioma" 				 default="es_CR">		
		<cfparam name="Session.Preferences.Skin" 	 default="portlet">
		<cfparam name="Session.Preferences.SkinMenu" default="portlet">

		<!--- Return out. --->
		<cfreturn />
	</cffunction>


	<cffunction name="OnRequestStart" access="public" returntype="boolean" output="false" hint="Fires at first part of page processing.">

		<!--- Define arguments. --->
		<cfargument name="TargetPage" type="string" required="true"/>
			<cfset res = setLocale("English (Canadian)")>
			<cfheader name="Expires" value="0">
			<cfheader name="Cache-control" value="no-cache">

			<cfset CargarInfoSIF()>
			<cfinclude template="/home/check/aspmonitor.cfm">
			<cfinclude template="/home/check/dominio.cfm">
			<cfinclude template="/home/check/autentica.cfm">
			<cfinclude template="/home/check/acceso.cfm">
			<cfinclude template="/home/check/bienvenido.cfm">
			
			<cfif SERVER.ColdFusion.ProductName NEQ "Railo" AND (NOT IsDefined("Session.Debug") OR Session.Debug neq true)>
				<cferror type="exception" template="/home/public/error/handler.cfm">
				<cferror type="validation" template="/home/public/error/handler.cfm">
				<cferror type="request" template="/home/public/error/handler.cfm">
			</cfif>
			<!---Si es una llamada remota (AJAX), se elimina la funcion onRequest, este problema esta resuelto en CF9--->
			<cfif UCASE(ListLast(ARGUMENTS.TargetPage, ".")) EQ "CFC" >
				<cfset StructDelete(THIS, "onRequest")>
				<cfset StructDelete(VARIABLES, "onRequest")>
			</cfif>
		<!--- Return out. --->
		<cfreturn true />
	</cffunction>


	<cffunction name="OnRequest" access="public" returntype="void" output="true" hint="Fires after pre page processing is complete.">
		<!--- Define arguments. --->
		<cfargument name="TargetPage" type="string" required="true"/>
		<!--- Include the requested page. --->
		<cfinclude template="#ARGUMENTS.TargetPage#" />

		<!--- Return out. --->
		<cfreturn />
	</cffunction>


	<cffunction name="OnRequestEnd" access="public" returntype="void" output="true" hint="Fires after the page processing is complete.">
		<cf_dbtemp_deletes>	
		<cfsetting enablecfoutputonly="yes">
		<cfinclude template="/home/check/aspmonitor-end.cfm">
		<cfsetting enablecfoutputonly="no">
		<!--- Return out. --->
		<cfreturn />
	</cffunction>


	<cffunction name="OnSessionEnd" access="public" returntype="void" output="false" hint="Fires when the session is terminated.">
		<!--- Define arguments. --->
		<cfargument name="SessionScope" type="struct" required="true" />
		<cfargument name="ApplicationScope" type="struct" required="false" default="#StructNew()#"/>

		<!--- Return out. --->
		<cfreturn />
	</cffunction>


	<cffunction name="OnApplicationEnd" access="public" returntype="void" output="false" hint="Fires when the application is terminated.">

		<!--- Define arguments. --->
		<cfargument name="ApplicationScope" type="struct" required="false" default="#StructNew()#"/>

		<!--- Return out. --->
		<cfreturn />
	</cffunction>

	<cffunction name="onMissingTemplate" access="public" returntype="void" output="true" hint="Fires when when a non-existing CFM page was requested. ">
		<!--- Define arguments. --->
		<cfargument name="Exception" type="any" required="true" />
		<cfargument name="EventName" type="string" required="false" default=""/>
		<cfinclude template="/home/public/error/missingTemplate.cfm">
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
	
	<cffunction name="CargarInfoSIF">
		<!--- Si la empresa no ha sido parametrizada, direcciona al Wizard de Configuración --->

		<cfif isdefined("session.Ecodigo") and len(trim(session.Ecodigo)) and session.Ecodigo gt 0 and session.DSN NEQ 'asp' and session.DSN NEQ 'sdc2' and StructKeyExists(Application.dsinfo, session.dsn) >
			<cfquery name="rsConfig" datasource="#session.DSN#" debug="no">
				select Pvalor 
				from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Pcodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="5">
			</cfquery>
			<cfif rsConfig.Pvalor neq 'S'>
				<cfinclude template="/sif/ad/config/wizBienvenida.cfm">
			</cfif>

			<!--- Pone el valor de la variable session.traducir [esto no puede hacerse en el componente, pues da conflictos de base de datos] --->
			<cfif not isdefined("session.traducir")>
				<!--- Usar funcionalidad de traduccion, parametro 17 de RHParametros --->
				<cfquery name="rsTraducir" datasource="#session.DSN#">
					select Pvalor
					from RHParametros
					where Ecodigo = #session.Ecodigo#
					and Pcodigo = 17
				</cfquery>
				<cfif rsTraducir.Pvalor eq 0 >
					<cfset session.traducir = false >
				<cfelse>	
					<cfset session.traducir = true >
				</cfif>
			</cfif>
		
			<!--- Parametros de Compras --->
			<cfinclude template="/sif/cm/admin/defaults.cfm">
		</cfif>
		
	</cffunction>

<cfif not isdefined("Request.Translate")>
 
	<cffunction name="Translate" displayname="Translate" output="false" hint="Translate">
		<cfargument name="Etiqueta" default="" type="string" required="true">
		<cfargument name="default" default="" type="string" required="true">
		<cfargument name="File" default="" type="string" required="false">
		<cfargument name="Idioma" default="" type="String" required="false">
	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="#Arguments.Etiqueta#"
			Default="#Arguments.default#"
			XmlFile="#Arguments.File#"
			returnvariable="Traduccion"/>
			
			<cfreturn #Traduccion#>
	</cffunction>
	<cfset Request.Translate = Translate>
</cfif>

	
	<!---	
	<cffunction name="OnError" access="public" returntype="void" output="true" hint="Fires when an exception occures that is not caught by a try/catch.">

		<!--- Define arguments. --->
		<cfargument name="Exception" type="any" required="true" />

		<cfargument name="EventName" type="string" required="false" default=""/>

		<!--- Return out. --->
		<cfreturn />
	</cffunction>
	--->

	<cffunction name="onAbort" access="public" returntype="void" hint="Handles Aborted request"> 
    	<cfargument type="String" name="targetPage" required=true/> 
		
		<cfsetting enablecfoutputonly="yes">
		<!---- si existe un proceso en ejecucion se coloca como finalizado al abortar o en cflocation---->
		<cfinvoke component="home.Componentes.aspmonitor" method="MonitoreoEnd">
		<cfsetting enablecfoutputonly="no">
	
	</cffunction> 
	
</cfcomponent>