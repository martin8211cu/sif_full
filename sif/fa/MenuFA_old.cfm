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
				<div align="center"><span class="superTitulo"><font size="5">Facturación</font></span></div>
			</td>
          </tr>
          <tr class="area"> 
            <td width="50%" valign="bottom" nowrap>
				<cfinclude template="jsMenuFA.cfm" >
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
				<td width="1%" valign="top">
					<!-- InstanceBeginEditable name="menu" -->
						<cfinclude template="/sif/menu.cfm">
					<!-- InstanceEndEditable -->
				</td>
			
				<td valign="top">
					<!-- InstanceBeginEditable name="mantenimiento" -->	
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Men&uacute; 
            Principal de Facturaci&oacute;n'>
	
		  <cfinclude template="../Utiles/Parametrizado.cfm">
		  <cfinclude template="../portlets/pNavegacionFA.cfm">
            <table width="80%" border="0" align="center" cellpadding="1" cellspacing="0">
              <tr> 
                <td width="1%"><font size="2">&nbsp;</font></td>
                <td width="5%" nowrap><font size="2">&nbsp;</font></td>
                <td width="1%" align="right" valign="middle"><div align="right"></div></td>
                <td width="31%" nowrap><font size="2">&nbsp;</font></td>
                <td width="4%">&nbsp;</td>
                <td width="1%">&nbsp;</td>
                <td width="5%">&nbsp;</td>
                <td width="0%">&nbsp;</td>
                <td width="1%" nowrap><font size="2">&nbsp;</font></td>
                <td width="9%">&nbsp;</td>
              </tr>
              <tr> 
                <td width="1%"><font size="2"><img src="../imagenes/Computer01_T2.gif"></font></td>
                <td width="5%" nowrap><font size="2"><strong>Operaci&oacute;n</strong>:</font></td>
                <td width="1%" align="right" valign="middle"><div align="right"></div></td>
                <td nowrap><font size="2">&nbsp;</font></td>
                <td>&nbsp;</td>
                <td width="1%"><font size="2"><img src="../imagenes/Graficos02_T.gif"></font></td>
                <td width="5%" nowrap><font size="2"><strong>&nbsp;Consultas</strong>:</font></td>
                <td align="right" valign="middle"><div align="right"></div></td>
                <td nowrap><font size="2">&nbsp;</font></td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td nowrap>&nbsp;</td>
                <td align="right" valign="middle"><a href="operacion/listaTransaccionesFA.cfm"><img src="../imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                <td nowrap><font size="2"><a href="operacion/listaTransaccionesFA.cfm">Registro de Transacciones</a></font></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right" valign="middle"><a href="consultas/repTransacciones.cfm"><img src="../imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                <td nowrap><font size="2"><a href="consultas/repTransacciones.cfm">Transacciones de Facturaci&oacute;n</a></font></td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td nowrap>&nbsp;</td>
                <td align="right" valign="middle"><a href="operacion/CierreCaja.cfm"><img src="../imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                <td nowrap><font size="2"><a href="operacion/CierreCaja.cfm">Cierre
                      de Caja Usuario</a></font></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right" valign="middle"><a href="consultas/repTransacciones.cfm?tipo=CO"><img src="../imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                <td nowrap><font size="2"><a href="consultas/repTransacciones.cfm?tipo=CO">Transacciones de Contado</a></font></td>
                <td>&nbsp;</td>
              </tr>
			  
			  <!--- Esto lo hace solo el supervisor de Cierre de Cajas definido en parametros. 
			        Se guarda el Usucodigo, por eso compara contra el Usucodigo de la session 
			   --->
			   <cfquery name="rsSupervisor" datasource="#session.DSN#">
			   		select Pvalor 
					from Parametros 
					where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and Pcodigo=430
			   </cfquery>
				<script language="JavaScript1.2" type="text/javascript">
					function cierre(){
						<cfif rsSupervisor.RecordCount eq 0 >
							alert('No se ha definido el Supervisor de Cierre de Cajas.');
						<cfelseif trim(rsSupervisor.Pvalor) eq session.Usucodigo>
							location.href = "operacion/CalculoCierreSis.cfm";
						</cfif>
					}
				</script>
              <tr>
                <td>&nbsp;</td>
                <td nowrap>&nbsp;</td>
                <td align="right" valign="middle"><a href="javascript:cierre();"><img src="../imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                <td nowrap><font size="2"><a href="javascript:cierre();">Cierre
                      de Caja Supervisor</a></font></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right" valign="middle"><a href="consultas/repTransacciones.cfm?tipo=CR"><img src="../imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                <td nowrap><font size="2"><a href="consultas/repTransacciones.cfm?tipo=CR">Transacciones de Cr&eacute;dito</a> </font></td>
                <td>&nbsp;</td>
              </tr>			  
              <tr>
                <td>&nbsp;</td>
                <td nowrap>&nbsp;</td>
                <td align="right" valign="middle"><a href="operacion/ImpresionFacturasFA.cfm?tipo=I"><img src="../imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                <td nowrap><font size="2"><a href="operacion/ImpresionFacturasFA.cfm?tipo=I">Impresi&oacute;n
                      de Facturas</a></font></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right" valign="middle"><a href="consultas/repTransacciones.cfm?tipo=NC"><img src="../imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                <td nowrap><font size="2"><a href="consultas/repTransacciones.cfm?tipo=NC">Notas de Cr&eacute;dito</a></font></td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td nowrap>&nbsp;</td>
                <td align="right" valign="middle"><a href="operacion/ImpresionFacturasFA.cfm?tipo=R"><img src="../imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                <td nowrap><font size="2"><a href="operacion/ImpresionFacturasFA.cfm?tipo=R">Reimpresi&oacute;n
                de Facturas</a></font></td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="right" valign="middle"><a href="consultas/repTransacciones.cfm?tipo=AN"><img src="../imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
                <td nowrap><font size="2"><a href="consultas/repTransacciones.cfm?tipo=AN">Transacciones Anuladas</a></font></td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td width="1%"><font size="2">&nbsp;<img src="../imagenes/Reporte01_T.gif" width="31" height="31"></font></td>
                <td width="5%" nowrap><font size="2"><strong>&nbsp;Cat&aacute;logos</strong>:</font></td>
                <td width="1%" align="right" valign="middle">&nbsp;</td>
                <td nowrap>&nbsp;</td>
                <td>&nbsp;</td>
                <td width="1%">&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td nowrap>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td width="1%">&nbsp;</td>
                <td width="5%" nowrap><font size="2">&nbsp;</font></td>
                <td width="1%" align="right" valign="middle"><div align="right"><a href="catalogos/Cajas.cfm"><img src="../imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                <td nowrap><font size="2"><a href="catalogos/Cajas.cfm">Cajas</a></font></td>
                <td>&nbsp;</td>
                <td width="1%">&nbsp;</td>
                <td width="5%">&nbsp;</td>
                <td>&nbsp;</td>
                <td nowrap><font size="2">&nbsp;</font></td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td width="1%">&nbsp;</td>
                <td width="5%" nowrap><font size="2">&nbsp;</font></td>
                <td width="1%" align="right" valign="middle"><div align="right"><a href="catalogos/TipoTransaccionCaja.cfm"><img src="../imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                <td nowrap><font size="2"><a href="catalogos/TipoTransaccionCaja.cfm">Tipos de Transaccion por Caja</a></font></td>
                <td>&nbsp;</td>
                <td width="1%">&nbsp;</td>
                <td width="5%">&nbsp;</td>
                <td>&nbsp;</td>
                <td nowrap><font size="2">&nbsp;</font></td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td width="1%">&nbsp;</td>
                <td width="5%" nowrap><font size="2">&nbsp;</font></td>
                <td width="1%" align="right" valign="middle"><div align="right"><a href="catalogos/Talonarios.cfm"><img src="../imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                <td nowrap><font size="2"><a href="catalogos/Talonarios.cfm">Talonarios</a></font></td>
                <td>&nbsp;</td>
                <td width="1%">&nbsp;</td>
                <td width="5%">&nbsp;</td>
                <td>&nbsp;</td>
                <td nowrap><font size="2">&nbsp;</font></td>
                <td>&nbsp;</td>
              </tr>
              <tr> 
                <td width="1%">&nbsp;</td>
                <td width="5%" nowrap><font size="2">&nbsp;</font></td>
                <td width="1%" align="right" valign="middle"><div align="right"><a href="catalogos/Vendedores.cfm"><img src="../imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                <td nowrap><font size="2"><a href="catalogos/Vendedores.cfm">Vendedores</a></font></td>
                <td>&nbsp;</td>
                <td width="1%">&nbsp;</td>
                <td width="5%">&nbsp;</td>
                <td>&nbsp;</td>
                <td nowrap><font size="2">&nbsp;</font></td>
                <td>&nbsp;</td>
              </tr>
			  <tr> 
                <td width="1%">&nbsp;</td>
                <td width="5%" nowrap><font size="2">&nbsp;</font></td>
                <td width="1%" align="right" valign="middle"><div align="right"><a href="catalogos/listaLPrecios.cfm"><img src="../imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
                <td nowrap><font size="2"><a href="catalogos/listaLPrecios.cfm">Lista de Precios</a></font></td>
                <td>&nbsp;</td>
                <td width="1%">&nbsp;</td>
                <td width="5%">&nbsp;</td>
                <td>&nbsp;</td>
                <td nowrap><font size="2">&nbsp;</font></td>
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