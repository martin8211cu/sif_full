<cfset consultar_Ecodigo = url.Ecodigo>
<!---<cfset url.ESestado=20>
--->
<cf_templateheader title="Detalle - Solicitud de Pago">
	<cfinclude template="/home/menu/pNavegacion.cfm">
	<form name="form1">
	<cfinclude template="/sif/tesoreria/Solicitudes/MisSolicitudesP-vistaForm.cfm">
	<div align="center">
<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Regresar"
		Default="Regresar"
		XmlFile="/sif/generales.xml"
		returnvariable="BTN_Regresar"/>	

		<cfif isdefined("url.from") and url.from NEQ "">
			<input type="button" onClick="location.href = '/cfmx/sif/tr/consultas/<cfoutput>#url.from#</cfoutput>.cfm';" value="&lt;&lt; <cfoutput>#BTN_Regresar#</cfoutput>" tabindex="1">
		<cfelse>
			<input type="button" onClick="history.back()" value="&lt;&lt; <cfoutput>#BTN_Regresar#</cfoutput>" tabindex="1">
		</cfif>
		
		<cfif isdefined('url.TipoSol') and  TipoSol eq 'PDCP'>
			<cfset createObject("component","sif.tesoreria.Componentes.TESafectaciones").sbImprimeCPCsTramites(#url.TESSPid#, true)>
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