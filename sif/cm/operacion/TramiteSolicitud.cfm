<cfset consultar_Ecodigo = url.Ecodigo>
<cfset url.ESestado=20>

<cf_templateheader title="#Request.Translate('LB_DetlleDeSolicitud','Detalle de Solicitud','/sif/cm/Generales.xml')#">
	<cfinclude template="/home/menu/pNavegacion.cfm">
	<!---<cfinclude template="/sif/cm/consultas/MisSolicitudes-vistaForm.cfm">---->
	<form name="form1">
	<cfinclude template="../consultas/MisSolicitudes-vistaForm.cfm">
	<div align="center">
<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Regresar"
		Default="Regresar"
		XmlFile="/sif/generales.xml"
		returnvariable="BTN_Regresar"/>	
	<!---<input type="button" name="regresar" onClick="history.back(-1)" value="regresar; <cfoutput>#BTN_Regresar#</cfoutput>">--->
<!---	<input type="button"  onClick="volver()" value="<<<cfoutput>#BTN_Regresar#</cfoutput>">
--->	
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