<style type="text/css">
<!--
.style7 {font-family: Geneva, Arial, Helvetica, sans-serif; font-size: 12px; color: ##FFFFFF; }
.style8 {color: ##FFFFFF}
-->
</style>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Tratado_De_Libre_Comercio"
Default="Tratado de Libre Comercio"
returnvariable="LB_Tratado_De_Libre_Comercio"/>
<cf_templateheader title="#LB_Tratado_De_Libre_Comercio#">
	<cf_web_portlet_start titulo="<cfoutput>#LB_Tratado_De_Libre_Comercio#</cfoutput>"> 
		<cfinclude template="pMenu.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>
