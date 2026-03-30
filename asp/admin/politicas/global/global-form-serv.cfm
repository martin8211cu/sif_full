<cfinvoke component="home.Componentes.aspmonitor" method="GetHostName" returnvariable="localhostname"/>

<cfquery datasource="aspmonitor" name="hosts" maxrows="240">
	select distinct hostname, upper(hostname) as hostupper, max (last_access) as last_accessed
	from MonServerProcess
	where last_access > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',-30,Now())#">
	group by upper(hostname), hostname
	order by hostupper, hostname
</cfquery>

<cfoutput>
  <table width="100%" border="0" cellpadding="2" cellspacing="2">
    <tr>
      <td width="50%" valign="top"><table border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td width="10">&nbsp;</td>
            <td colspan="4" class="subTitulo"><strong>Bit&aacute;coras para auditor&iacute;a</strong></td>
            <td width="12">&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td width="17">&nbsp;</td>
            <td width="20"><input name="monitor_historia_auto" id="monitor_historia_0" type="radio" value="0" <cfif data.monitor.historia is 0>checked</cfif>   onClick="form.monitor_historia.disabled = true;"  >            </td>
            <td width="250" colspan="2"><label for="monitor_historia_0">Borrado manual </label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td><input name="monitor_historia_auto" id="monitor_historia_1" type="radio" value="1" <cfif data.monitor.historia neq 0>checked</cfif>  onClick="with(form.monitor_historia){disabled = false;focus()}"  >            </td>
            <td colspan="2"><label for="monitor_historia_1">Conservar informaci&oacute;n por</label>
                <input name="monitor_historia" type="text" class="flat right" id="monitor_historia" onFocus="this.select()" value="<cfif data.monitor.historia neq 0>#data.monitor.historia#<cfelse>90</cfif>" <cfif data.monitor.historia is 0>disabled</cfif> size="6" maxlength="6" onblur="solonumero(this,'<cfif data.monitor.historia neq 0>#data.monitor.historia#<cfelse>90</cfif>')">
                <label for="monitor_historia">d&iacute;as.</label>            </td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="4">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="4" class="subTitulo"><strong>Reporte de errores</strong></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td width="20"><input name="error_detalles" id="error_detalles_0" type="radio" value="0" <cfif data.error.detalles is 0>checked</cfif>>            </td>
            <td colspan="2"><label for="error_detalles_0">Mostrar detalles técnicos</label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td><input name="error_detalles" id="error_detalles_1" type="radio" value="1" <cfif data.error.detalles is 1>checked</cfif>>            </td>
            <td colspan="2"><label for="error_detalles_1">Colapsar detalles técnicos</label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td><input name="error_detalles" id="error_detalles_2" type="radio" value="2" <cfif data.error.detalles is 2>checked</cfif>>            </td>
            <td colspan="2"><label for="error_detalles_2">Ocultar totalmente los detalles técnicos</label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="4">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
      </table></td>
	  	<td width="50%" valign="top"><table width="419" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="2%">&nbsp;</td>
            <td width="11%">&nbsp;</td>
            <td width="87%">&nbsp;</td>
          </tr>

          <tr>
            <td>&nbsp;</td>
            <td class="subTitulo" colspan="2"><strong>Correo</strong></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="2" valign="top" ><label for="correo_cuenta">Cuenta origen de los correos de salida del portal&nbsp;</label></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td valign="top" >&nbsp;</td>
            <td><input name="correo_cuenta" type="text" class="flat" id="correo_cuenta" onfocus="this.select()" value="#data.correo.cuenta#" size="25" maxlength="60"/>            </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td valign="top" >&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td class="subTitulo" colspan="2"><strong>Múltiples servidores </strong></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="2" valign="top" ><label for="servidor_principal">Servidor principal </label></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td valign="top" >&nbsp;</td>
            <td><select name="servidor_principal">
                <option value="">(sin especificar)</option>
                <cfloop query="hosts">
                  <option value="# HTMLEditFormat(Trim(hostname)) #" <cfif Trim(hostname) EQ data.servidor.principal >selected</cfif>># HTMLEditFormat(hostname) #
                    <cfif hostname EQ localhostname>
                      [local]
                    </cfif>
                  </option>
                </cfloop>
            </select></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td valign="top" >&nbsp;</td>
            <td>El servidor principal es el encargado de realizar las tareas programadas comunes,
			 como envío de correos, mantenimiento de la historia, etcétera. Si hay más de un servidor 
			 de aplicaciones conectado a las mismas bases de datos de asp, indique cuál de ellos es el 
			 servidor principal. Este parámetro puede estar en blanco</td>
          </tr>
        </table></td>
    </tr>
    <tr>
      <td colspan="2" align="left" class="subTitulo"><input name="submit-serv" type="submit" id="submit-serv" value="Aplicar" class="btnGuardar">
          <input type="reset" name="Reset" value="Cancelar" class="btnLimpiar">      </td>
    </tr>
  </table>
<script type="text/javascript">
function funcvalidar(){
	var f = document.form1;
	solonumero(f.monitor_historia, '#data.monitor.historia#');
	return true;
}
</script>
</cfoutput>
