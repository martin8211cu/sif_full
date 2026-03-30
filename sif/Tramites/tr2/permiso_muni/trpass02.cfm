<cfinclude template="../../tpid.cfm">

<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
Trámites
</cf_templatearea>
<cf_templatearea name="left">

</cf_templatearea>
<cf_templatearea name="body">

<cf_web_portlet titulo="Confirmar trámite">

 <form name="form1" action="trpass02-apply.cfm" method="post">
              <table width="100%" border="0" cellspacing="1">
                <tr> 
                  <td width="6%"><input type="hidden" name="TPID" value="<cfoutput>#url.TPID#</cfoutput>"></td>
                  <td colspan="8" align="right">&nbsp;<cfinclude template="nav.cfm"></td>
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
                      2 de 5:</font></strong> <span class="subTitulo">Estado actual 
                      de su cuenta </span></p></td>
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
                  <td colspan="7">Seg&uacute;n los registros municipales, el portador de la c&eacute;dula <font color="#006699"><strong> 
				    <cfoutput>#tramite.Cedula#</cfoutput> 
                    </strong></font>
					<cfif #Len(Trim(tramite.Pnombre))# NEQ 0> 
						(<cfoutput>#tramite.Pnombre#</cfoutput>)</cfif>
					<br> 
					no	tiene	saldos	ni impuestos territoriales pendientes, por lo que el tr&aacute;mite puede proseguir.<br>
                    <br>
                    Le recordamos que a la hora de hacer entrega del permiso de construcci&oacute;n, usted deber&aacute; traer los planos con copia<br>
                    para ser cotejados por nuestros peritos. </td>
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
                  <td colspan="5"><strong>Usted puede:</strong></td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
				<cfquery datasource="sdc" name="accion">
					select a.Accion,a.AccionNombre
					from TramitePasaporte t, TramitePasaporteAccion a
					where t.TPID = #TPID#
					  and (t.Pestado = 'N' and a.Accion = 'N'
					   or  t.Pestado = 'E' and a.Accion = 'E'
					   or  t.Pestado = 'R' and a.Accion = 'R'
					   or  t.Pestado in ('R', 'V') and a.Accion = 'P')
				</cfquery>
				
                <tr> 
                  <td>&nbsp;</td>
                  <td colspan="4"><table width="100%" border="0">
        
                      <tr> 
                        <td width="11%">&nbsp;</td>
                        <td width="89%" colspan="3">
						<label> 
                          <input name="accion" type="radio" value="2" checked>
                          Permiso para construcci&oacute;n nueva </label></td>
                      </tr>
                    
                      <tr>
                        <td>&nbsp;</td>
                        <td colspan="3"><label>
                          <input name="accion" type="radio" value="5" > 
                          Permiso para remodelaci&oacute;n (menor a un 75% de la propiedad) </label></td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td width="89%">&nbsp;</td>
                        <td nowrap><input type="submit" value="Continuar">
                          <input type="button" name="Regresar" value="Regresar" onclick="history.back();"></td>
                        <td width="60%">&nbsp;</td>
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
              </table>
</form>

</cf_web_portlet>
</cf_templatearea>
</cf_template>


