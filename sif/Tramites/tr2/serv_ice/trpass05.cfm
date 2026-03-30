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

 <form name="form1" action="trpass05-apply.cfm" method="post">
              <table width="100%" border="0" cellspacing="1">
                <tr> 
                  <td width="3%"><input type="hidden" name="TPID" value="<cfoutput>#url.TPID#</cfoutput>"></td>
                  <td colspan="8" align="right"><cfinclude template="nav.cfm">
				  </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td colspan="5"><strong>
                    <cfinclude template="logo.cfm">
                  </strong></td>
                  <td width="3%">&nbsp;</td>
                  <td width="8%">&nbsp;</td>
                  <td width="11%">&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td colspan="5"><p align="justify"><strong><font size="3">Paso 
                      5 de 5:</font></strong> <span class="subTitulo">Fin del 
                      Proceso </span></p></td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
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
                      el pago de su tr&aacute;mite de l&iacute;nea telef&oacute;nica.<br>
                      <br>
                      A continuaci&oacute;n 
                      le indicamos el c&oacute;digo de autorizaci&oacute;n as&iacute; 
                      como los pasos a seguir para la instalaci&oacute;n de su l&iacute;nea:</div></td>
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
                        <td nowrap><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Importe 
                            pagado: </strong></font></div></td>
                        <td nowrap><font size="2">
						<cfoutput>#LSCurrencyFormat(tramite.Importe)# #tramite.Miso4217#</cfoutput> </font></td>
                        <td nowrap>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td nowrap><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Tr&aacute;mite:</strong></font></div></td>
                        <td nowrap><font color="#006699" size="2">Solicitud de L&iacute;nea telef&oacute;nica </font></td>
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
                      <strong>imprima</strong> esta confirmaci&oacute;n y espere la llamada del ICE en los pr&oacute;ximos d&iacute;as para coordinar la instalaci&oacute;n de su l&iacute;nea telef&oacute;nica, o bien comun&iacute;quese al tel&eacute;fono 119 para coordinar la visita de los t&eacute;cnicos.</font></div></td>
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
                  <td colspan="7"><strong>Nota:</strong> Recuerde tener el d&iacute;a de la instalaci&oacute;n una copia de su c&eacute;dula de identidad y de un recibo por servicios (agua/luz/tel&eacute;fono) reciente.</td>
                  <td>&nbsp;</td>
                </tr>
              </table>
</form>


</cf_web_portlet>
</cf_templatearea>
</cf_template>


