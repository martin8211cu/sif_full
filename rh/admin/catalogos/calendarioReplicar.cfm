<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>
<cfif isdefined("url.CPid") and not isdefined("form.CPid")>
	<cfset form.CPid = url.CPid >
</cfif>

<cf_templateheader title="#LB_RecursosHumanos#">
<cf_templatecss>
	<table width="100%" cellpadding="2" cellspacing="0">
		<cfif not isdefined("form.CPid")>
			<cfinvoke Key="LB_Error._No_ha_seleccionado_el_Calendario_de_Pagos_para_replicar" Default="Error. No ha seleccionado el Calendario de Pagos para replicar." XmlFile="/rh/admin/catalogos/calendarioPagos.xml" returnvariable="vError" component="sif.Componentes.Translate" method="Translate"/>
			<cf_throw message="#vError#" errorCode="2005">
		</cfif>
		<tr>
			<td valign="top">
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_ReplicarCalendarioDePagos"
					Default="Replicaci&oacute;n de Calendario de Pagos"
					returnvariable="LB_CalendarioDePagos"/>	
		
				<cf_web_portlet_start titulo="#LB_CalendarioDePagos#" skin="#Session.Preferences.Skin#" border="true">
					<cfinclude template="calendarioReplicar-form.cfm">
				<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>