<cf_templateheader title="#Request.Translate('LB_DetlleDeTraslado','Detalle de Traslado Finalizado','/sif/presupuesto/Generales.xml')#">
	<cfinclude template="/home/menu/pNavegacion.cfm">
	<div align="center">
	<form name="form1" style="border:1px solid #CCCCCC;">
		<cfset LvarReporteFinal = true>
		<cfinclude template="../consultas/MisTraslados-vistaForm.cfm">
		<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Regresar"
				Default="Regresar"
				XmlFile="/sif/generales.xml"
				returnvariable="BTN_Regresar"
		/>	
		<cfif isdefined("url.from") and url.from NEQ "">
			<input type="button" onClick="location.href = '/cfmx/sif/tr/consultas/<cfoutput>#url.from#</cfoutput>.cfm';" value="&lt;&lt; <cfoutput>#BTN_Regresar#</cfoutput>" tabindex="1">
		<cfelse>
			<input type="button" onClick="history.back()" value="&lt;&lt; <cfoutput>#BTN_Regresar#</cfoutput>" tabindex="1">
		</cfif>
	</form>
	</div>
<cf_templatefooter>
<script language="JavaScript1.2">
function volver()
{
	location.href = '/cfmx/sif/tr/consultas/solicitados.cfm';
}
</script> 
