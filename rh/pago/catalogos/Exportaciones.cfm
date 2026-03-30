<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		<cf_translate key="LB_RecursosHumanos" XmlFile="/rh/generales.xml">Recursos Humanos</cf_translate>
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
					  <!--- <cfinclude template="/rh/portlets/pNavegacionPago.cfm"> --->
					   <form name="form1" method="post" action="Exportacion.cfm">
						  <input type="hidden" name="Bid" value="">
						  <input type="hidden" name="EIid" value="">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
							  <tr>
								  <td width="10">&nbsp;</td>
								  <td width= "1">&nbsp;</td>
								  <td width= "1">&nbsp;</td>
								  <td width="95">&nbsp;</td>
								  <td width="10">&nbsp;</td>
								  <td width="1000">&nbsp;</td>
							  </tr>
							  <tr>
								  <td rowspan="2">&nbsp;</td>
								  <td valign="top" colspan="5" class="menuhead plantillaMenuhead">
									 <cf_translate key="LB_Exportaciones_disponibles"> Exportaciones Disponibles</cf_translate>
								  </td>
							  </tr>
							  <tr>
								  <td valign="middle" colspan="5" class="menuhablada plantillaMenuhablada">

								  </td>
							  </tr>
							  <tr><td style="height:5px;">&nbsp;</td></tr>
							  <tr>
								  <td>&nbsp;</td>
								  <td class="" align="left" valign="top">
									  <a href="##" onClick="javascript: document.form1.submit();">

										  <img src="/cfmx/home/public/imagen.cfm?f=/home/menu/imagenes/option_arrow.gif" border="0">

									  </a>
								  </td>
								  <td>&nbsp;</td>

								  <cfquery name="id_cheque" datasource="sifcontrol">
									  select EIid
										from EImportador
										where EIexporta = 1
										and EIcodigo='EX_CHEQUE'
								  </cfquery>

								  <td class="" align="left" valign="top" colspan="3">
									  <a href="##" onClick="javascript: document.form1.EIid.value=<cfoutput>#id_cheque.EIid#</cfoutput>; document.form1.submit();"
										class="menutitulo plantillaMenutitulo"><cf_translate key="LB_Exportacion_de_cheques">Exportaci&oacute;n de Cheques</cf_translate></a><BR>
								  </td>
							  </tr>
							  <cfquery name="rsFORM" datasource="#Session.DSN#">
								  select a.Bid, a.EIid, RHEdescripcion, b.Bdescripcion as Banco, a.ts_rversion
									from RHExportaciones a, Bancos b
									where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								  and a.Bid = b.Bid
							  </cfquery>
							  <cfoutput query="rsFORM">
								<tr>
									<td>&nbsp;</td>
									<td class="" align="left" valign="top">
										<a href="##" onClick="javascript: document.form1.Bid.value=#Bid#; document.form1.EIid.value=#EIid#; document.form1.submit();">

											<img src="/cfmx/home/public/imagen.cfm?f=/home/menu/imagenes/option_arrow.gif" border="0">

										</a>
									</td>
									<td>&nbsp;</td>
									<td class="" align="left" valign="top" colspan="3">
										<cfset list1 =" ,.,á,é,í,ó,ú">
										<cfset list2 ="_,_,a,e,i,o,u">
										<cfset variable = "LB_"& ReplaceList(RHEdescripcion, list1, list2)>
										<a href="##" onClick="javascript: document.form1.Bid.value=#Bid#; document.form1.EIid.value=#EIid#; document.form1.submit();"
										class="menutitulo plantillaMenutitulo">+<cf_translate  key="#variable#">#RHEdescripcion#</cf_translate></a><BR>
									</td>
								</tr>
							  </cfoutput>
							  <tr><td colspan="6" style="border-bottom:solid 1px">&nbsp;</td></tr>
						  </table>
						</form>
					 <p align="justify">
					  	<cf_translate key="LB_EsteEsUnServicioBrindadoPorLaEmpresaSOIN">
					    	Este es un servicio brindado por la empresa SOIN, Soluciones Integrales.
						  	SOIN se reserva todos los derechos.  Información o preguntas relacionadas,
						  	favor comunicarse con: </cf_translate> <a href="mailto:webmaster@soin.net">
						  	webmaster@soin.net
					  </a>.</p>
				</td>
			</tr>
		</table>
	</cf_templatearea>
</cf_template>