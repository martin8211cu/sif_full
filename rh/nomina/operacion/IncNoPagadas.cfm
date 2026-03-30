<cfsilent>
    <cfinvoke component="sif.Componentes.Translate"
        method="Translate"
        Key="LB_Incidencias_pendientes_de_pagar"
        Default="Incidencias pendientes de pagar"
        returnvariable="LB_Incidencias_pendientes_de_pagar"/>
</cfsilent>

<cf_templateheader title="#LB_Incidencias_pendientes_de_pagar#">
	<cfinclude template="/rh/Utiles/params.cfm">
    <cf_web_portlet_start titulo="#LB_Incidencias_pendientes_de_pagar#">
   		 <cfinclude template="IncNoPagadas-form.cfm">
    <cf_web_portlet_end>
<cf_templatefooter>    
    