<cfsilent>
	<cfparam name="url.uri" default="/cfmx/home/menu/index.cfm">
	<cfparam name="url.errormsg" default="0">
	<cfset url.uri = htmlcodeformat(url.uri)>
	<cfset url.uri = reReplaceNoCase(url.uri,"<PRE>","","all")>
	<cfset url.uri = reReplaceNoCase(url.uri,"</PRE>","","all")>
	<cfif isDefined("session.Usucodigo") and session.Usucodigo NEQ 0>
		<cflocation url="/cfmx/home/menu/index.cfm">
	</cfif>
	<cfset pathImg = expandpath("/plantillas/erp/img/login")>
	<cfdirectory directory="#pathImg#" name="dirQuery" action="LIST">
	<cfquery dbtype="query" name="imgs">
		SELECT * FROM dirQuery
		WHERE TYPE='File'
		and UPPER(NAME) like '%.JPG'
	</cfquery>
</cfsilent>
<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>Enterprise Resource Planning</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width,height=device-height, initial-scale=1.0">
    	<link rel="stylesheet" href="/cfmx/commons/css/bootstrap.min.css">
		<link rel="stylesheet" href="css/login.css">
        <!-- Place favicon.ico and apple-touch-icon.png in the root directory -->
		 <!-- SlidesJS Optional: If you'd like to use this design -->
		 	 <!-- SlidesJS Required: Link to jQuery -->
		<script src="http://code.jquery.com/jquery-1.9.1.min.js"></script>
		<script src="/cfmx/jquery/librerias/bootstrap.min.js"></script>
    </head>
    <body>
	    <div class="container">
			<div>
			<!--[if lt IE 10]>
				<br>
				<strong style='color:red'>Esta utilizando un navegador desactualizado. <a href="http://browsehappy.com/?locale=es" > Actualice su navegador </a> para mejora la experiencia.</strong>

			<![endif]-->
			<div>

			<div class="row">
				<div class="col-sm-6 col-md-4 "> <!--- col-sm-offset-3 col-md-offset-4 --->
					<div class="panel panel-default">
						<cfif IsDefined('session.sitio.CEcodigo') and Len(session.sitio.CEcodigo)>
							<div class="panel-heading">
								<cfoutput>
								<img src="/cfmx/home/public/logo_cuenta.cfm?CEcodigo=#session.sitio.CEcodigo#" class="img-responsive"  alt="logo" border="0" height="100%" width="100%">
								</cfoutput>
							</div>
						</cfif>
						<div class="panel-body">
							<form name="login" id="login" action="<cfoutput>#url.uri#</cfoutput>" method="post" autocomplete="off">
								<fieldset>
									<div class="row">
										<div class="col-sm-12 col-md-10  col-md-offset-1 ">
											<div class="form-group">
												<img class="login-logo"src="img/logo_proyecto_login.png" alt="">
												<div class="center-block text-justify">
													<p>Nuestro sistema integrado, brinda al usuario las aplicaciones RH y SIF como una herramienta de suma importancia para las necesidades de su Empresa. </p>
												</div>
											</div>
										</div>
									</div>
									<div class="row">
										<div class="col-sm-12 col-md-10  col-md-offset-1">
											<cfinclude template="/home/menu/loginFormOpts.cfm">
										</div>
									</div>
									<div class="row">
										<div class="powered_login"><img src="img/powered_soin.png" width="120" height="21" alt=""/></div>

										<div class="col-sm-12 col-md-10  col-md-offset-1">
											<div class="form-group">
												<div class="center-block text-center" style="position:relative;top:18px;"><p>Release 1 - 2015</p></div>
											</div>
										</div>
									</div>
								</fieldset>
							</form>
						</div>
	                </div>

				</div>
			</div>
		</div>
    </body>
</html>