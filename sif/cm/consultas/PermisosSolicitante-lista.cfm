<cf_templateheader title="Compras - Consulta de Permisos por Solicitante">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Permisos por Solicitante'>
			<script language="JavaScript" type="text/JavaScript">
				<!--
				 function funcRegresar() {
					document.form1.action='/cfmx/sif/cm/MenuCM.cfm';
					document.form1.submit();
				}
				//-->
			</script>
			<cfoutput>
				<form name="form1" method="post" action="PermisosSolicitante-lista.cfm" style="margin: 0">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr><td><cfinclude template="../../portlets/pNavegacionCM.cfm"></td></tr>
						<tr><td><cfinclude template="PermisosSolicitante-Filtro.cfm"></td></tr>
						<tr><td>
							<cfset params = "">
							<cfif isdefined("form.CMScodigoD") and len(trim(form.CMScodigoD)) >
								<cfset params = "&CMScodigoD=#form.CMScodigoD#">
							</cfif>
							<cfif (isdefined("form.CMScodigoH") and len(trim(form.CMScodigoH))) >
								<cfset params = params & "&CMScodigoH=#form.CMScodigoH#">
							</cfif>
							<cfif (isdefined("form.fCFcodigoD") and len(trim(form.fCFcodigoD))) >
								<cfset params = params & "&fCFcodigoD=#form.fCFcodigoD#">
							</cfif>
							<cfif (isdefined("form.fCFcodigoH") and len(trim(form.fCFcodigoH))) >
								<cfset params = params & "&fCFcodigoH=#form.fCFcodigoH#">
							</cfif>
							
							<cfif isdefined("form.btnFiltro")>
								<cf_rhimprime datos="/sif/cm/consultas/PermisosSolicitante-Imprime.cfm" paramsuri="#params#">
							</cfif>
						</td></tr>
						<cfif isdefined("form.btnFiltro")>
							
							<tr><td><cfinclude template="PermisosSolicitante-Imprime.cfm"></td></tr>					
						</cfif>
						<tr><td><cf_botones  tabindex="1" include="Regresar" exclude="Baja,Cambio,Alta,Limpiar"></td></tr>
					</table>						
				</form>
			</cfoutput>
			
		<cf_web_portlet_end>
	<cf_templatefooter>