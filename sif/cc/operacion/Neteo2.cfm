
<cf_templateheader title="Eliminaci&oacute;n de Documentos con Saldos Despreciables">
		<cfinclude template="../../portlets/pNavegacion.cfm">
		<cf_web_portlet_start titulo="Eliminaci&oacute;n de Documentos con Saldos Despreciables">
			<!--- Define el Tipo de Neteo para las pantallas comunes --->
			<cfset TipoNeteo = 2>
			<!--- Pasa Lave que puede venir por url al form --->
			<cfif isdefined("url.idDocumentoNeteo") and len(trim(url.idDocumentoNeteo))>
				<cfset form.idDocumentoNeteo = url.idDocumentoNeteo>
			</cfif>
			<!--- Pintado del Form  --->
			<br>
			<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td class="subTitulo" style="text-transform:uppercase" align="center">Documento Neteo</td>
			  </tr>
			  <tr>
				<td><cfinclude template="Neteo-Common-formneteo.cfm"></td>
			  </tr>
			</table>
			<br>
			<cfif (modoneteo neq "ALTA")>
			<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<cfif Session.monitoreo.smcodigo EQ 'CC'>
					<td valign="top" width="100%">
						<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td class="subTitulo" style="text-transform:uppercase" align="center">Documento a Netear CXC</td>
						  </tr>
						  <tr>
							<td valign="top">
							  <cfinclude template="Neteo-Common-formcxc.cfm">
							</td>
						  </tr>
						  <tr>
							<td valign="top">
							  <cfinclude template="Neteo-Common-listacxc.cfm">
							</td>
						  </tr>
						</table>
					</td>
				<cfelse>
					<td valign="top" width="100%">
						<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td class="subTitulo" style="text-transform:uppercase" align="center">Documento a Netear CXP</td>
						  </tr>
						  <tr>
							<td valign="top">
							  <cfinclude template="Neteo-Common-formcxp.cfm">
							</td>
						  </tr>
						  <tr>
							<td valign="top">
							  <cfinclude template="Neteo-Common-listacxp.cfm">
							</td>
						  </tr>
						</table>
					</td>
				</cfif>
			  </tr>
			</table>
			<br>
			</cfif>
		<cf_web_portlet_end> 
	<cf_templatefooter>