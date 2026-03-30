<cfinclude template="../../tpid.cfm">
<cfquery name="rsdatos" datasource="SDC">
	select Iaba, convert(varchar,CBTcodigo) as CBTcodigo, CBcodigo, SUcodigo, CBdescripcion, Mcodigo, Usucodigo, Ulocalizacion, CBofxusuario, CBofxpassword, CBofxacctkey, CBorden, CBofxdtend
	from CtaBancaria  
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
</cfquery>

<cfquery name="rsfec" datasource="sdc">
select getdate() as fecha
</cfquery>

<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
Trámites
</cf_templatearea>
<cf_templatearea name="left">

</cf_templatearea>
<cf_templatearea name="body">

<cf_web_portlet titulo="Iniciar tramite">


  <form name="form1" action="trpass04-apply.cfm" method="post">
              <table width="100%" border="0" cellspacing="1">
                <tr> 
                  <td width="6%">
				  <input type="hidden" name="TPID" value="<cfoutput>#url.TPID#</cfoutput>">
				  <input type="hidden" name="papa" value="<cfoutput>#url.papa#</cfoutput>"></td>
                  <td colspan="8" align="right"><cfinclude template="nav.cfm"></td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td colspan="5"><strong>
                    <cfinclude template="logo.cfm">
                  </strong></td>
                  <td width="17%">&nbsp;</td>
                  <td width="17%">&nbsp;</td>
                  <td width="17%">&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td colspan="5"><p align="justify"><strong><font size="3">Paso 
                      4 de 5:</font></strong> <span class="subTitulo">Saldo de 
                      Cuenta Bancaria</span></p></td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td width="45%">&nbsp;</td>
                  <td width="16%" colspan="-1">&nbsp;</td>
                  <td width="2%" colspan="-1">&nbsp;</td>
                  <td width="2%" colspan="-1">&nbsp;</td>
                  <td width="10%" colspan="-1">&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td colspan="7"><div align="justify">La cuenta <cfoutput><strong>#tramite.CBdescripcion#</strong></cfoutput>
                      con la que usted va a realizar la operaci&oacute;n de pago 
                      de derechos para solicitud de l&iacute;nea telef&oacute;nica tiene el siguiente 
                      estado: </div></td>
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
                  <td colspan="4"><table width="100%" border="0">
                      <tr> 
                        <td width="10%">&nbsp;</td>
                        <td width="31%" nowrap><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Fecha:</strong></font></div></td>
                        <td width="57%" nowrap><font size="2"><cfoutput>#LSDateFormat(Now(),"dd-mmm-yyyy")#</cfoutput></font></td>
                        <td width="2%" nowrap>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td nowrap><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Cuenta:</strong></font></div></td>
                        <td nowrap>XXXX-XXXXXXXX<font size="2" face="Arial, Helvetica, sans-serif">&nbsp; </font></td>
                        <td nowrap>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td nowrap><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Saldo:</strong></font></div></td>
                        <td nowrap><font size="2" face="Arial, Helvetica, sans-serif"><cfif isdefined("url.disponible")><cfoutput>#LSCurrencyFormat(url.disponible,'none')#</cfoutput></cfif>
                          </font></td>
                        <td nowrap>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td nowrap><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Importe por pagar:</strong></font></div></td>
                        <td nowrap><font size="2" face="Arial, Helvetica, sans-serif">
						<cfoutput>#LSCurrencyFormat(tramite.Importe)# #tramite.Miso4217#</cfoutput> </font></td>
                        <td nowrap>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td nowrap>&nbsp;</td>
                        <td nowrap>&nbsp;</td>
                        <td nowrap>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3">Si necesita seleccionar otra cuenta presione 
                          el bot&oacute;n <strong>Regresar</strong>.</td>
                        <td nowrap>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td colspan="2"><div align="justify"></div></td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3"><div align="justify"><strong>Nota:</strong> 
                            Esta operaci&oacute;n es irreversible y rebajar&aacute; 
                            los fondos de inmediato de su cuenta. </div></td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3"><div align="center">&iquest;Desea pagar su l&iacute;nea telef&oacute;nica ahora?</div></td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="3"><div align="center"> 
                            <input type="submit" name="Continuar" value="Continuar">
                            <input type="button" name="Regresar" value="Regresar" onclick="history.back();">
                          </div></td>
                        <td>&nbsp;</td>
                      </tr>
                    </table></td>
                  <td colspan="-1">&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
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
                  <td colspan="5">&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td colspan="5">&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
              </table>
</form>


</cf_web_portlet>
</cf_templatearea>
</cf_template>


