<!-- InstanceBegin template="/Templates/LMenuRH1.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		Recursos Humanos
	</cf_templatearea>
	
	<cf_templatearea name="body">

<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>

	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<!-- InstanceBeginEditable name="head" -->
<style type="text/css">
<!--
.style1 {
	font-size: 14px;
	font-weight: bold;
}
-->
</style>
<style type="text/css">
<!--
.style2 {font-size: 12px}
-->
</style>
<!-- InstanceEndEditable -->	
                    <!-- InstanceBeginEditable name="MenuJS" --> 
		  <!-- InstanceEndEditable -->					
					<!-- InstanceBeginEditable name="Mantenimiento" --> 

	<cfquery name="raDatos" datasource="#session.DSN#" >
		select Tdescripcion, ERNdescripcion, c.CPcodigo 
		from ERNomina a, TiposNomina b, CalendarioPagos c
		where a.Tcodigo=b.Tcodigo
		and c.Ecodigo=a.Ecodigo
		and a.RCNid=c.CPid
		and ERNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarERNid#">
	</cfquery>	

	  <cf_web_portlet_start border="true" titulo="Pago de Nómina - Errores" skin="#Session.Preferences.Skin#">
		<table border="0" width="100%" cellpadding="0" cellspacing="0">
			<cfset regresar = "javascript:regresar();">
			<tr><td><cfinclude template="/rh/portlets/pNavegacionPago.cfm"></td></tr>
			
			<tr>
				<td align="center">
					<form style="margin:0;" name="lista" action="" method="post">
						<table border="0" width="90%" cellpadding="0" cellspacing="2" align="center">
							<tr><td colspan="4" align="center"><span class="style1"><cf_translate  key="LB_ErroresEnElProcesoContable">Errores en el Proceso Contable</cf_translate></span></td>
							</tr>
							<tr><td></td></tr>
							

							<cfoutput>
							<tr>
								<td colspan="4" align="center">
									<table width="100%" align="center">
									<tr>
											<td nowrap width="1%"><font size="2"><b><cf_translate  key="LB_CalendarioDePagos">Calendario de Pagos</cf_translate>:</b></font></td>
											<td nowrap><font size="2">#raDatos.CPcodigo#</font></td>

											<td nowrap width="1%"><b><font size="2"><cf_translate  key="LB_TipoDeNomina">Tipo de Nomina</cf_translate>:</b></font></td>
											<td nowrap><font size="2">#raDatos.Tdescripcion#</font></td>
											<td nowrap width="1%"><font size="2"><b><cf_translate  key="LB_Descripcion">Descripci&oacute;n</cf_translate>:</b></font></td>
											<td nowrap><font size="2">#raDatos.ERNdescripcion#</font></td>
										</tr>	
									</table> 		
								</td>
							</tr>
							</cfoutput>
							
							<tr>
								<td class="tituloListas" colspan="4"><cf_translate  key="LB_DescripcionDelError">Descripci&oacute;n del Error</cf_translate></td>
							</tr>
							<cfoutput query="data">
								<tr onClick="javascript:procesar('#data.tiporeg#');" class="<cfif data.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>" onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif data.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
									<td width="1%">&nbsp;</td>
									<td colspan="3"><a href="javascript:procesar('#data.tiporeg#');" class="style2">#data.descripcion#</a></td>
								</tr>
							</cfoutput>
								<tr><td colspan="2">&nbsp;</td></tr>
								<tr><td colspan="4" align="center">
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="BTN_Regresar"
									Default="Regresar"
									XmlFile="/rh/generales.xml"
									returnvariable="BTN_Regresar"/>								

								
									<input type="submit" name="btnRegresar" value="<cfoutput>#BTN_Regresar#</cfoutput>" onClick="javascript:regresar();">
									<input type="hidden" name="ERNid" value="<cfoutput>#form.ERNid#</cfoutput>">
								</td></tr>

						</table>
					</form>
				</td>
			</tr>
			
			<tr><td>&nbsp;</td></tr>
			
		</table>	  
	  <cf_web_portlet_end>
	  
	  <script language="javascript1.2" type="text/javascript">
	  		function procesar( tipo ){
				var irA = '' ;
				switch ( tipo ) {
				   case '10':
					   irA = '/cfmx/rh/admin/catalogos/TipoAccion.cfm';
					   break;
				   case '20':
					   irA = '/cfmx/rh/admin/catalogos/TiposIncidencia.cfm';
					   break;
				   case '25':
						irA = '/cfmx/rh/admin/catalogos/TiposIncidencia.cfm';
					   break;
				   case '30':
					   irA = '/cfmx/rh/admin/catalogos/listaCargasOP.cfm';
					   break;
				   case '40':
					   irA = '/cfmx/rh/admin/catalogos/listaCargasOP.cfm';
					   break;
				   case '50':
					   irA = '/cfmx/rh/admin/catalogos/listaCargasOP.cfm';
					   break;
				   case '60':
					   irA = 'Socios';
					   break;
				} 

				if ( tipo != 0 && tipo != 60){
					document.lista.action = irA;
					document.lista.submit();
				}
			}
	
			function regresar(){
				<cfif chkDefinido > 
					document.lista.action = 'listaPNomina.cfm';
				<cfelse>
					document.lista.action = 'PNomina.cfm';
				</cfif>
				document.lista.submit();
			}

	  </script>
	  
	  
	  
      <!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template><!-- InstanceEnd -->