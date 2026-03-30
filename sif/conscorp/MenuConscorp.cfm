<!-- InstanceBegin template="/Templates/LMenu03.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		<!-- InstanceBeginEditable name="titulo" -->
        <div align="left">
          
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr class="area"> 
            <td width="275" rowspan="2" valign="middle">
				<cfinclude template="../portlets/pEmpresas2.cfm">
			</td>
            <td nowrap>
              <div align="center"><span class="superTitulo"><font size="5">Consultas Corporativas</font></span></div>
			</td>
          </tr>
          <tr> 
            <td></td>
            <td></td>
          </tr>
        </table>
        </div>
        <!-- InstanceEndEditable -->
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
		<br>
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<!-- InstanceBeginEditable name="mantenimiento" -->	
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Men&uacute; Principal de Consultas Administrativas'>
	 
		  <cfinclude template="../portlets/pNavegacionAdmin.cfm">
		  <cfinclude template="../Utiles/Parametrizado.cfm">
            <table width="100%" border="0" align="center" cellpadding="1" cellspacing="0">
              <tr> 
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td width="4%">&nbsp;</td>
                <td width="90%">&nbsp;</td>
              </tr>
              <tr> 
                <td width="6%">&nbsp;</td>
                <td width="0"><a href='Consultas/conscorp.cfm'><img border="0" src="../imagenes/menues/cofre.JPG"></a></td>
                <td colspan="2" nowrap><a href='Consultas/conscorp.cfm'><font size="2"><strong>&nbsp;Planillas Pagadas por Empresa </strong></font></a> 
				</td>
              </tr>
              <tr> 
                <td width="6%">&nbsp;</td>
                <td width="0%">&nbsp;</td>
                <td>&nbsp;</td>
                <td nowrap>&nbsp;</td>
              </tr>
            </table>
            	
		</cf_web_portlet>
	<!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template><!-- InstanceEnd -->
