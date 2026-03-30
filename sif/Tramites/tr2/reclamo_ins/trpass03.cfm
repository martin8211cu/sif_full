<cfinclude template="../../tpid.cfm">
<cfparam name="url.numerito" default="10000">


<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
Trámites
</cf_templatearea>
<cf_templatearea name="left">

</cf_templatearea>
<cf_templatearea name="body">

<cf_web_portlet titulo="Confirmar trámite">

 <form name="form1" action="trpass03-apply.cfm" method="post">
              <table width="100%" border="0" cellspacing="1">
                <tr> 
                  <td width="6%"><input type="hidden" name="TPID" value="<cfoutput>#url.TPID#</cfoutput>"></td>
                  <td colspan="8" align="right"><cfinclude template="nav.cfm">
				  </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td colspan="8"><strong>
                    <cfinclude template="logo.cfm">
                  </strong></td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td colspan="5"><p align="justify"><strong><font size="3">Paso 
                      3 de 3:</font></strong> <span class="subTitulo">Fin del 
                      Proceso </span></p></td>
                  <td width="3%">&nbsp;</td>
                  <td width="8%">&nbsp;</td>
                  <td width="11%">&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td width="18%">&nbsp;</td>
                  <td width="19%" colspan="-1">&nbsp;</td>
                  <td width="4%" colspan="-1">&nbsp;</td>
                  <td width="0%" colspan="-1">&nbsp;</td>
                  <td width="34%" colspan="-1">&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td colspan="7"><div align="justify">Usted ha realizado satisfactoriamente 
                      el reclamo de seguros.<br>
                      <br>
                      A continuaci&oacute;n 
                      le indicamos el c&oacute;digo de autorizaci&oacute;n as&iacute; 
                      como los pasos a seguir para la acreditaci&oacute;n de su reclamo:</div></td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td colspan="-1">&nbsp;</td>
                  <td colspan="-1">&nbsp;</td>
                  <td colspan="-1">&nbsp;</td>
                  <td colspan="-1">&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td colspan="4"><table width="95%" border="0">
                      <tr> 
                        <td width="5%">&nbsp;</td>
                        <td width="41%" nowrap><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Fecha:</strong></font></div></td>
                        <td width="35%" nowrap><font size="2"><cfoutput>#tramite.FechaFin#</cfoutput></font></td>
                        <td width="19%" nowrap>&nbsp;</td>
                      </tr>
                      <tr>
                        <td>&nbsp;</td>
                        <td nowrap><div align="right"><strong><font size="2">N&uacute;mero 
                            de Confirmaci&oacute;n:</font></strong></div></td>
                        <td nowrap><font size="2"><cfoutput>#tramite.TPID#</cfoutput></font></td>
                        <td nowrap>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td nowrap><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>N&uacute;mero 
                            de Transferencia:</strong></font></div></td>
                        <td nowrap><font size="2"><cfoutput>#Replace( url.numerito,"00","","all")#
						#Replace (tramite.TIsrvrtid, "00", "","all")#</cfoutput></font></td>
                        <td nowrap>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td nowrap><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Tr&aacute;mite:</strong></font></div></td>
                        <td nowrap><font color="#006699" size="2">Reclamo de seguros </font></td>
                        <td nowrap>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td colspan="2" nowrap><div align="center"> 
                            <input type="button" name="Submit" value="Imprimir" onclick="javascript:window.print();">
                            <input type="submit" name="Finalizar" value="Finalizar">
                          </div></td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3"><div align="justify"></div></td>
                        <td>&nbsp;</td>
                      </tr>
                    </table></td>
                  <td colspan="4" valign="top"><div align="justify"></div></td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td colspan="7"><div align="justify"><font size="2">Por favor, 
                      <strong>imprima</strong> esta confirmaci&oacute;n y dir&iacute;jase 
                      al INS dentro de siete d&iacute;as h&aacute;biles,
                      a la ventanilla de Tr&aacute;mites en L&iacute;nea para 
                      realizar la revisi&oacute;n de sus papeles y hacerle entrega del cheque. 
                      Este tr&aacute;mite es personal y debe presentarse con su 
                      c&eacute;dula de identidad vigente y en buen estado.</font></div></td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td colspan="5">&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td colspan="7">&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
              </table>
</form>


</cf_web_portlet>
</cf_templatearea>
</cf_template>


