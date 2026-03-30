 <cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cf_importlibs>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_titulo" Default="#nav__SPdescripcion#" returnvariable="LB_titulo"/>
<cf_templateheader title="#LB_titulo#">

		<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="#LB_titulo#">
			<div class="row">
				<div class="col col-xs-12">
					<div class="well">
						<cfinclude  template="RepCambiosCreditUnion-form.cfm">	 
					</div><!--- fin del well---->
				</div><!--- fin del col 12--->
			</div><!---- fin del row--->
		<cf_web_portlet_end>
<cf_templatefooter>