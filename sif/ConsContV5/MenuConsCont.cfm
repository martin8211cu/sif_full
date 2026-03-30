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
				
              <div align="center"><span class="superTitulo"><font size="5">Consultas de Balance Contable</font></span></div>
			</td>
          </tr>
          <tr class="area"> 
            <td width="50%" valign="bottom" nowrap>
				<cfinclude template="jsMenuConsCont.cfm">
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
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Men&uacute; Principal de Consultas de Balance Contable'>
	 
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
                <td width="0"><font size="2"><img src="../imagenes/Graficos02_T.gif"></font></td>
                <td colspan="2" nowrap><font size="2"><strong>&nbsp;Contabilidad:</strong></font> 
                  <div align="right"></div>                </td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td><a href='/cfmx/sif/ConsContV5/Consultas/SaldosCuentas.cfm'><img src="../imagenes/Recordset.gif" width="18" height="18" border="0" align="absmiddle"></a></td>
                <td nowrap><font size="2"><a href='/cfmx/sif/ConsContV5/Consultas/SaldosCuentas.cfm'>Consulta de Saldos por Cuenta Contable </a></font></td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td><a href='/cfmx/sif/ConsContV5/Consultas/SaldosRangoCuentas.cfm'><img src="../imagenes/Recordset.gif" width="18" height="18" border="0" align="absmiddle"></a></td>
                <td nowrap><font size="2"><a href='/cfmx/sif/ConsContV5/Consultas/SaldosRangoCuentas.cfm'>Consulta de Saldos por un Rango de Cuentas Contables</a></font></td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td><a href='/cfmx/sif/ConsContV5/Consultas/SaldosAsientoCuentas.cfm'><img src="../imagenes/Recordset.gif" width="18" height="18" border="0" align="absmiddle"></a></td>
                <td nowrap><font size="2"><a href='/cfmx/sif/ConsContV5/Consultas/SaldosAsientoCuentas.cfm'>Consulta de Saldos por Asiento de las Cuentas Contables</a></font></td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
            </table>
            	
		</cf_web_portlet>
	<!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template><!-- InstanceEnd -->