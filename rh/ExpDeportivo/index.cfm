<style type="text/css">
<!--
.style7 {font-family: Geneva, Arial, Helvetica, sans-serif; font-size: 12px; color: ##FFFFFF; }
.style8 {color: ##FFFFFF}
-->
</style>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Expediente_Deportivo"
Default="Expediente Deportivo"
returnvariable="LB_Expediente_Deportivo"/>
<cf_templateheader title="#LB_Expediente_Deportivo#">
	 <!--- <cf_web_portlet_start titulo="<cfoutput>#LB_Expediente_Deportivo#</cfoutput>">   --->
		<cfinclude template="pMenu.cfm">
<!--- <cf_web_portlet_end> --->
<cf_templatefooter>
