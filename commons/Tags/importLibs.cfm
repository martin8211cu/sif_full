<cfsilent>
	<cfparam name="Attributes.Importbootstrap" 	type="boolean" default="true">
	<cfparam name="Attributes.ImportJqueryui"	type="boolean" default="true">
	<cfparam name="Attributes.ImportJqueryuiAdapter"	type="boolean" default="true">
	<cfparam name="Attributes.ImportUnderscore" type="boolean" default="true">
	<cfparam name="Attributes.ImportJquery" 	type="boolean" default="true">
	<cfparam name="Attributes.ImportFonts" 		type="boolean" default="true">
	<cfparam name="Attributes.ImportMenuLeft" 	type="boolean" default="true">
	<cfparam name="Attributes.ExportaExcel" 	type="boolean" default="false">
	<cfparam name="Attributes.notify" 	type="boolean" default="true">
	<!--- <cfparam name="Attributes.IntroLoader" 	type="boolean" default="true"> --->


	<cfset fullUrlPath = 'http://'><cfif findnocase('HTTPS',ucase(cgi.SERVER_PROTOCOL))><cfset fullUrlPath = 'https://'></cfif>
	<cfset fullUrlPath&=cgi.HTTP_HOST & cgi.CONTEXT_PATH>


	<cfsavecontent variable="Imports">
		<cfoutput>
			<cfif not isdefined('request.jquery') and Attributes.ImportJquery>
				<script src="/cfmx/jquery/Core/jquery-2.1.1.min.js"></script>
				<cfset request.jquery = true>
			</cfif>
			<cfif not isdefined('request.jqueryui') and Attributes.ImportJqueryui>
				<script src="/cfmx/jquery/librerias/jquery-ui.js"></script>
				<cfset request.jqueryui = true>
			</cfif>
			<cfif not isdefined('request.jqueryuiAdapter') and Attributes.ImportJqueryuiAdapter>
				<script src="/cfmx/jquery/librerias/jquery-ui-adapterui.js"></script>
				<cfset request.jqueryuiAdapter = true>
			</cfif>
			<cfif not isdefined('request.underscore') and Attributes.ImportUnderscore>
				<script src="/cfmx/jquery/librerias/underscore-min.js"></script>
				<cfset request.underscore = true>
			</cfif>
			<cfif not isdefined('request.bootstrap') and Attributes.Importbootstrap>
				<script src="/cfmx/jquery/librerias/bootstrap.min.js"></script>
				<link href="#fullUrlPath#/commons/css/style.css" rel="stylesheet" type="text/css" />
				<link href="#fullUrlPath#/commons/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
				<cfset request.bootstrap = true>
			</cfif>
			<cfif not isdefined('request.ImportFonts') and Attributes.ImportFonts>
				<link href="#fullUrlPath#/commons/css/fonts/font-awesome.min.css" rel="stylesheet" type="text/css" />
				<cfset request.ImportFonts = true>
			</cfif>
			<cfif not isdefined('request.notify') and Attributes.notify>
				<link href="#fullUrlPath#/jquery/estilos/jquery.notifyBar.css" rel="stylesheet" type="text/css" />
				<script src="/cfmx/jquery/librerias/jquery.notifyBar.js"></script>
				<cfset request.notify = true>
			</cfif>
			<!---
			<cfif not isdefined('request.IntroLoader') and Attributes.IntroLoader>
				<link href="#fullUrlPath#/jquery/librerias/jqueyIntroLoader/css/introLoader.css" rel="stylesheet">
				<script src="/cfmx/jquery/librerias/jqueyIntroLoader/helpers/jquery.easing.1.3.js"></script>
				<script src="/cfmx/jquery/librerias/jqueyIntroLoader/helpers/spin.min.js"></script>
				<script src="/cfmx/jquery/librerias/jqueyIntroLoader/jquery.introLoader.js"></script>
				<cfset request.IntroLoader = true>
			</cfif>
			--->
			<!--- <cfif not isdefined('request.ImportMenuLeft') and Attributes.ImportMenuLeft>
				<link href="#fullUrlPath#/commons/css/menuleft.css" rel="stylesheet" type="text/css" />
				<cfset request.ImportMenuLeft = true>
			</cfif> ---> <!--- No se incluye este css para estandarizar los estilos en los menus de los modulos --->

			<!--- para graficas --->
			<cfif isdefined('request.bootstrap') and Attributes.Importbootstrap>
				<script src="/cfmx/jquery/librerias/bootstrap-table.js"></script>
				<cfset request.bootstrap = true>
			</cfif>
		</cfoutput>
	</cfsavecontent>








</cfsilent>
<cfif LEN(TRIM(Imports))>
	<cfhtmlhead text="#Imports#">
</cfif>