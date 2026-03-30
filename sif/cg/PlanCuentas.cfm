<!-- InstanceBegin template="/Templates/LMenu03.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		<!-- InstanceBeginEditable name="titulo" -->
        <div align="left">
          
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr class="area"> 
            <td width="47%" rowspan="2" valign="middle"> <cfinclude template="../portlets/pEmpresas2.cfm"> </td>
            <td align="left" nowrap> <div align="center"><span class="superTitulo"><font size="5">
			<cfoutput>#Request.Translate('TituloConta','Contabilidad General')#</cfoutput>
			</font></span></div></td>
          </tr>
          <tr class="area"> 
            <td align="left" valign="bottom" nowrap> <cfinclude template="jsMenuCG.cfm" > </td>
          </tr>
          <tr> 
            <td></td>
            <td></td>
          </tr>
        </table>
        </div>
        <!-- InstanceEndEditable -->">
		
		<br>
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td width="1%" valign="top">
					<!-- InstanceBeginEditable name="menu" -->
						<cfinclude template="/sif/menu.cfm">
					<!-- InstanceEndEditable -->
				</td>
			
				<td valign="top">
					<!-- InstanceBeginEditable name="mantenimiento" -->	
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#Request.Translate('TituloPortlet','Plan de Cuentas Contables')#'>
	
		  <cfinclude template="../Utiles/Parametrizado.cfm">
  		  <cfinclude template="../portlets/pNavegacionCG.cfm">
            <table width="80%" border="0" align="center" cellpadding="1" cellspacing="0">
              <tr> 
                <td width="1%"><font size="2">&nbsp;</font></td>
                <td width="5%" nowrap><font size="2">&nbsp;</font></td>
                <td width="1%" align="right" valign="middle"><div align="right"></div></td>
                <td width="31%" nowrap><font size="2">&nbsp;</font></td>
                <td width="4%">&nbsp;</td>
                <td width="1%">&nbsp;</td>
                <td width="5%" nowrap>&nbsp;</td>
                <td width="1%">&nbsp;</td>
                <td width="31%" nowrap>&nbsp;</td>
                <td width="9%">&nbsp;</td>
              </tr>
              <tr> 
                <td width="1%"><font size="2">&nbsp;<img src="../imagenes/Reporte01_T.gif" width="31" height="31"></font></td>
                <td colspan="3" valign="middle" nowrap><font size="2"><strong>&nbsp; 
                  <cfoutput>#Request.Translate('CatalogosTitle','Catálogos:')#</cfoutput> </strong></font> </td>
                <td>&nbsp;</td>
                <td width="1%">&nbsp;</td>
                <td width="5%" nowrap>&nbsp;</td>
                <td>&nbsp;</td>
                <td nowrap><font size="2">&nbsp;</font></td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td nowrap>&nbsp;</td>
                <td align="right" valign="middle"><div align="right"><a href="catalogos/MascarasCuentas.cfm" onMouseOver="MM_preloadImages('../imagenes/ftv4doc.gif')"><img src="../imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                <td nowrap> <font size="2">&nbsp; <a href="catalogos/MascarasCuentas.cfm"><cfoutput>#Request.Translate('Mascaras','Mascaras:')#</cfoutput></a> </font> </td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td nowrap>&nbsp;</td>
                <td>&nbsp;</td>
                <td nowrap>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td nowrap>&nbsp;</td>
                <td align="right" valign="middle"><div align="right"><a href="catalogos/Catalogos-lista.cfm" onMouseOver="MM_preloadImages('../imagenes/ftv4doc.gif')"><img src="../imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                <td nowrap> <a href="catalogos/Catalogos-lista.cfm"><font size="2">&nbsp; 
                  <cfoutput>#Request.Translate('Catalogos','Catálogos:')#</cfoutput> </font> </a></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td nowrap>&nbsp;</td>
                <td>&nbsp;</td>
                <td nowrap>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td width="1%"><font size="2">&nbsp;</font></td>
                <td nowrap>&nbsp;</td>
                <td align="right" valign="middle">&nbsp;</td>
                <td nowrap>&nbsp;</td>
                <td>&nbsp;</td>
                <td width="1%">&nbsp;</td>
                <td width="5%">&nbsp;</td>
                <td>&nbsp;</td>
                <td nowrap><font size="2">&nbsp;</font></td>
                <td>&nbsp;</td>
              </tr>
            </table>
            	
		<cf_web_portlet_end>
	<!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	<cf_templatefooter><!-- InstanceEnd -->