<!--- VARIBLES DE TRADUCCION --->
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" XmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_TITULOCOMPONENTE" Default="Reglas Componentes Salariales" returnvariable="LB_TITULOCOMPONENTE" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIBLES DE TRADUCCION --->

<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_templatecss>
	<cfinclude template="/rh/Utiles/params.cfm">
	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>
	<cfif isdefined('url.ERCid') and not isdefined('form.ERCid')><cfset form.ERCid = url.ERCid></cfif>
	<cfif isdefined('url.RHCAid') and not isdefined('form.RHCAid')><cfset form.RHCAid = url.RHCAid></cfif>
	<cfif isdefined('url.CSid') and not isdefined('form.CSid')><cfset form.CSid = url.CSid></cfif>
	<cfif isdefined('form.ERCid') and LEN(TRIM(form.ERCid)) GT 0>
		<cfset form.modo = 'CAMBIO'>
	<cfelse>	
		<cfset form.modo = 'ALTA'>
	</cfif>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cf_web_portlet_start titulo="#LB_TITULOCOMPONENTE#">
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
					<cfinclude template="formReglasComponentes.cfm">
				<cf_web_portlet_end>
			  </td>	
		</tr>
	</table>	
<cf_templatefooter>
