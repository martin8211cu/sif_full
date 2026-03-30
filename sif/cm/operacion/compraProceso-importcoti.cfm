<!--- Form para mantener la navegación --->
<form name="form1" method="post" action="<cfoutput>#GetFileFromPath(GetTemplatePath())#</cfoutput>">
	<input type="hidden" name="opt" value="">
</form>
<!--- Importa Cotizaciones de sif publica --->
<cfif isdefined("Form.btnImportar")>
	<cfinvoke component="sif.Componentes.CM_ImportaCotizaciones" method="CM_ImportaCotizaciones">
		<cfinvokeargument name="CMPid" value="#Session.Compras.ProcesoCompra.CMPid#">
	</cfinvoke>
</cfif>
<!--- Pasa parámetros del url al form --->
<cfif (isdefined("url.ecid"))><cfset form.ecid = url.ecid></cfif>
<table width="99%%" align="center" border="0" cellspacing="0" cellpadding="0"><tr><td>
<!--- <cfif (isdefined("form.ecid") and len(trim(form.ecid)))>
	<!--- Vista de una Cotización --->
	<cfinclude template="compraProceso-importcoti-vista.cfm">
<cfelse>
	<!--- Lista de Cotizaciones --->
	<cfinclude template="compraProceso-importcoti-lista.cfm">
</cfif> --->
<cfinclude template="compraProceso-importcoti-lista.cfm">
</td></tr></table>