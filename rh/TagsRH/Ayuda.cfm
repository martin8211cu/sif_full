<cfif ThisTag.ExecutionMode is 'start'>
	<cfparam name="Attributes.width" default="30">
	<cfparam name="Attributes.height" default="38">
	<cfparam name="Attributes.id" type="string" >
	
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Ayuda" Default="Ayuda"returnvariable="LB_Ayuda"/> 
	

	<cfset params="id=#Attributes.id#&width=#Attributes.width#&height=#Attributes.height#">
	<cf_Lightbox name="Ayuda" url="/cfmx/rh/Cloud/Ayuda/AyudaFrame.cfm?#params#" link=""></cf_LightBox>

	<table width="100%">
		<tr align="left"><td align="left"><a onClick='fnLightBoxOpen_Ayuda();' style='cursor:pointer' ><cfoutput><img src="/cfmx/rh/imagenes/Help01_T.gif"/>#LB_Ayuda#</cfoutput></a></td></tr>
	</table>
</cfif>