<!--- <cfset session.Idioma = 'en'> --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Titulo" Default="Consulta del Catálogo de Cuentas Contables" 
returnvariable="LB_Titulo" xmlfile = "RCuentas.xml"/>


	<cf_templateheader title="#LB_Titulo#">
		<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
		          <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_Titulo#">
		  			<cfinclude template="../../portlets/pNavegacionCG.cfm">
					<!---<table width="100%" align="center"><tr><td colspan="2" align="right"><cf_sifayudaRoboHelp name="imAyuda" imagen="1" Tip="true" width="500" url="Cuentas_contables.htm"></td></tr></table>--->
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<form name="form1" action="SQLRCuentas.cfm" method="get" onsubmit="return sinbotones()">
					  <tr><td colspan="2">&nbsp;</td></tr>			
					  <tr>
						<td width="35%" align="right"><cf_translate key=LB_CuentaIni>Cuenta Inicial</cf_translate>:&nbsp;</td>
						<td  nowrap><cf_cuentas NoVerificarPres="yes" AUXILIARES="S" ccuenta="Ccuenta1" cdescripcion="Cdescripcion1" cformato="Cformato1" CONLIS="S" form="form1" frame="fr1" MOVIMIENTO="N"></td>
					  </tr>
					
					  <tr>
						<td align="right"><cf_translate key=LB_CuentaFin>Cuenta Final</cf_translate>:&nbsp;</td>
						<td nowrap> <cf_cuentas NoVerificarPres="yes" AUXILIARES="S" ccuenta="Ccuenta2" cdescripcion="Cdescripcion2" cformato="Cformato2" CONLIS="S" form="form1" frame="fr2" MOVIMIENTO="N"></td>
					  </tr>
					
					  <tr><td colspan="2">&nbsp;</td></tr>
					
					  <tr>
						<td colspan="2" align="center">
							<cf_botones values="Consultar,Exportar" names="Consultar,Exportar">
						
						</td>
					  </tr>
					
					  <tr>
						<td colspan="2">&nbsp;</td>
					  </tr>
					</form>
					</table>            	
		          <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>