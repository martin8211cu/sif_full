<cf_template>
<cf_templatearea name="title">Inicio</cf_templatearea>
<cf_templatearea name="body">

	<cfinclude template="../../portal_control.cfm">

	<table width="955"  border="0" cellspacing="2" cellpadding="0">

		<tr>
			<td width="162" valign="top">
				<!--- AGENDA - INI --->
				<cf_web_portlet titulo="Agenda" skin="portlet" width="164">
					<form action="../agenda/agenda.cfm" name="calform">
						<cf_calendario form="calform" includeForm="no" name="fecha" fontSize="10" onChange="document.getElementById('pendientes').src='/cfmx/home/menu/portlets/agenda/lista_hoy-form.cfm?fecha='+escape(dmy)">
					</form>
				</cf_web_portlet>
				<br>
				<!--- AGENDA - FIN --->
	
				<!--- HOY - INI --->
				<cf_web_portlet titulo="Pendientes para hoy" skin="portlet" width="164">
					<cfinclude template="../agenda/lista-hoy.cfm">
				</cf_web_portlet>
				<!--- HOY - FIN --->
			</td>
			
			<td width="787" valign="top">


	<cfquery datasource="asp" name="datos_indicador">
		select i.cfm_detalle
		from Indicador i
		where i.indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.indicador#">
	</cfquery>
		<cfif Len(Trim(datos_indicador.cfm_detalle)) And FileExists(ExpandPath(datos_indicador.cfm_detalle))>
			<cfinclude template="#datos_indicador.cfm_detalle#">
		<cfelse>
			<cfinclude template="detalle-form.cfm">
		</cfif>
	</td>
		</tr>
		
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>

</cf_templatearea>
</cf_template>