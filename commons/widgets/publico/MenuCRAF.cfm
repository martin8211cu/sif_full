<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
		<cf_web_portlet_start>
			<cf_importlibs>
			<link href="/cfmx/plantillas/erp/css/erp.css" rel="stylesheet" type="text/css">
			<style>body {background-color:#dee7e5}</style>
				<div class="row">
					<div class="col col-md-12 centered">	
						<cfinclude template="MenuCRAF-principal.cfm">
					</div>
				</div>
				<div class="row">&nbsp;</div>
		<cf_web_portlet_end>
