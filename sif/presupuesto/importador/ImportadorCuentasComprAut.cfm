<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Titulo = t.Translate('LB_Titulo','Importador de Cuentas de Presupuesto Comprometidas Automáticamente')>
<cf_templateheader title="#LB_Titulo#">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr> 
			<td valign="top">
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_Titulo#">
					<cfinclude template="/sif/portlets/pNavegacion.cfm">
					<table width="100%" border="0" cellspacing="1" cellpadding="1">
						<tr>
							<td valign="top" width="60%">
								<cf_sifFormatoArchivoImpr EIcodigo = 'CTASCPRAUT'>
							</td>
							<td valign="top" align="center">
								<cf_sifimportar eicodigo="CTASCPRAUT" mode="in" />
							</td>
							<td valign="top"><cf_botones exclude="ALTA,CAMBIO,BAJA,LIMPIAR"></td>
						</tr>
					</table>	
				<cf_web_portlet_end>
			</td>	
	 	</tr>
<cf_templatefooter>