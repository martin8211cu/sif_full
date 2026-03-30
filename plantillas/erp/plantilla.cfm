<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!-->
<cfparam name="session.origen" default="sistema">
<cfset session.sitio.skinlist = 'erp.css,Sapiens'>
<html class="no-js"> <!--<![endif]-->
    <head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<title>$$TITLE$$</title>
		<cfset Request.TemplateCSS = true>
        <meta charset="utf-8">
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Place favicon.ico and apple-touch-icon.png in the root directory -->

		<cf_importLibs>
		<cfhtmlhead text='<link href="#cgi.CONTEXT_PATH##session.sitio.css#" rel="stylesheet" type="text/css"/>'>
		<cfoutput>
			<link href="#cgi.CONTEXT_PATH#/commons/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
		</cfoutput>
    </head>
    <body>
		<!--- Simple splash screen--->
		<!--- <div class="splash">
			<div class="color-line"></div>
			<div class="splash-title">
				<h1>SOIN/ERP V7</h1>
				<p>Cargando... </p>
				<i class="fa fa-spinner fa-spin fa-5x"></i>
			</div>
		</div> --->
        <!--[if lt IE 7]>
            <p class="browsehappy">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
        <![endif]-->

		<cfset request.mlm_part1 = true>
		<div id="element"></div>
		<div style="margin:0;padding:0" class="noprint">
			<cfinclude template="header.cfm">
		</div>
		<cfinclude template="/home/menu/portal_control.cfm">

		<!------ determinar si se muestra la navegacion a la izquierda---->
		<cfset showNavegacionLeft=true>
		<cfif findnocase('/menu/empresa.cfm',cgi.script_name)
			or findnocase('home/menu/micuenta/',cgi.script_name)
			or findnocase('home/public/recordar.cfm',cgi.script_name)>
		    <cfset showNavegacionLeft=false>
		</cfif>

		<!------ determinar si se muestra comprimida la navegacion---->
		<cfset cookieOcutarNav=true>
		<cfif isdefined('cookie.CFSHOWNAV') and cookie.CFSHOWNAV eq 1
				and !findnocase('home/menu/micuenta/',cgi.script_name)
				and !findnocase('home/public/recordar.cfm',cgi.script_name)
				or findnocase('/home/menu/sistema.cfm',cgi.script_name)>
			<cfset cookieOcutarNav=false>
		</cfif>

		<div class="bodyContent <cfif showNavegacionLeft and cookieOcutarNav>navHide</cfif>">
			<div class="row">
				<cfif showNavegacionLeft>
					<div class="col col-sm-2 header-col" id="divNavegacionOpciones">
						<cfinclude template="/home/menu/navegacionLeft.cfm">
					</div>
				</cfif>
				<div class="col <cfif showNavegacionLeft>col-sm-10<cfelse>col-sm-12</cfif> header-col" id="divContenido">
					$$BODY$$
				</div>
			</div>
		</div>

		<cfset Request.templatefooterdata=''>
		<cfif isdefined('session.sitio.footer') and LEN(trim(session.sitio.footer))>
			<cf_templatefooter>
		<cfelse>
			<cfinclude template="footer.cfm">
		</cfif>
		<script>
			$(window).bind("load", function () {
			    // Remove splash screen after load
			    $('.splash').css('display', 'none')
			});
		</script>
    </body>
</html>