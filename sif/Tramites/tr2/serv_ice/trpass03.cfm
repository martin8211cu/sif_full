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

   <form name="form1" action="trpass03-apply.cfm" method="post">
              <table width="100%" border="0" cellspacing="1">
                <tr> 
                  <td width="6%"><input type="hidden" name="TPID" value="<cfoutput>#url.TPID#</cfoutput>"></td>
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
                  <td><input type="hidden" name="cedula" value='<cfoutput>#tramite.Cedula#</cfoutput>'></td>
                  <td colspan="5"><p align="justify"><strong><font size="3">Paso 
                      3 de 5:</font></strong> <span class="subTitulo">Pago de la l&iacute;nea </span></p></td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td width="45%">
				  <input type="hidden" name="monto" value="<cfoutput>#tramite.Importe#</cfoutput>">
				  <input type="hidden" name="moneda" value="<cfoutput>#tramite.Mcodigo#</cfoutput>">
				  </td>
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
                  <td colspan="7"><div align="justify">Es necesario realizar el 
                      tr&aacute;mite de pago para lo cual, se realiz&aacute; una 
                      transferencia en l&iacute;nea de su cuenta a la cuenta del Instituto Costarricense de Electricidad.</div></td>
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
                  <td colspan="4"><table width="100%" border="0">
                      <tr> 
                        <td width="10%">&nbsp;</td>
                        <td width="31%" nowrap><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Fecha:</strong></font></div></td>
                        <td width="57%" nowrap><font color="#006699" size="2"> 
                          <cfif isdefined("rsfec")>
                            <cfoutput>#LSDateformat(rsfec.fecha,'dd-mm-yyyy')#</cfoutput> 
                          </cfif>
                          </font></td>
                        <td width="2%" nowrap>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td nowrap><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Tr&aacute;mite 
                            a realizar:</strong></font></div></td>
                        <td nowrap>Solicitud de L&iacute;nea telef&oacute;nica <font size="2" face="Arial, Helvetica, sans-serif">&nbsp;</font></td>
                        <td nowrap>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td nowrap><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>C&eacute;dula:</strong></font></div></td>
                        <td nowrap><font size="2" face="Arial, Helvetica, sans-serif"> 
                            <font color="#006699"><cfoutput>#Trim(tramite.cedula)#</cfoutput></font> 
                          </font></td>
                        <td nowrap>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td nowrap><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Monto 
                            a pagar por entero:</strong></font></div></td>
                        <td nowrap><font size="2" face="Arial, Helvetica, sans-serif">
						<cfoutput>#LSCurrencyFormat(tramite.importe)# #tramite.Miso4217#</cfoutput></font></td>
                        <td nowrap>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td> <div align="left"><font face="Arial, Helvetica, sans-serif"><font size="2"></font></font> 
                          </div></td>
                        <td><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;</font></td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Cuenta 
                            Bancaria a debitar:</strong></font></div></td>
                        <td><font size="2" face="Arial, Helvetica, sans-serif"> 
                          <cfif isdefined("rsdatos")>
                            <select name="cuentas">
                              <cfoutput query="rsdatos"> 
                                <option value="#rsdatos.CBcodigo#|#rsdatos.Iaba#|#rsdatos.CBTcodigo#">#rsdatos.CBdescripcion#</option>
                              </cfoutput> 
                            </select>
                          </cfif>
                          </font></td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td><div align="right">PIN: </div></td>
                        <td><input type="password" name="papa"></td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td colspan="2">&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td colspan="2"><strong>Nota:</strong> Esta clave no ser&aacute; 
                          almacenada en ning&uacute;n lugar y adem&aacute;s no 
                          podr&aacute; ser utilizada para otro prop&oacute;sito 
                          distinto al de esta transacci&oacute;n.</td>
                        <td>&nbsp;</td>
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
                        <td><input type="submit" name="Continuar" value="Continuar"> 
                          <input type="button" name="Regresar" value="Regresar" onclick="history.back();"></td>
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


