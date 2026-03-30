<!--- VARIBLES DE TRADUCCION --->
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" XmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_TITULOCOMPONENTE" Default="Componentes Salariales" returnvariable="LB_TITULOCOMPONENTE" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIBLES DE TRADUCCION --->
<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_templatecss>
	<cfinclude template="/rh/Utiles/params.cfm">
	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cf_web_portlet_start titulo="#LB_TITULOCOMPONENTE#">
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
					<cfinclude template="formComponentes.cfm">
				<cf_web_portlet_end>
			  </td>	
		</tr>
	</table>	
<cf_templatefooter>