<cfoutput>
  <table width="100%" border="0" cellpadding="2" cellspacing="2">
    <tr>
      <td width="50%" valign="top"><table border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="10">&nbsp;</td>
            <td width="17">&nbsp;</td>
            <td width="20">&nbsp;</td>
            <td width="104">&nbsp;</td>
            <td width="146">&nbsp;</td>
            <td width="12">&nbsp;</td>
          </tr>
          
          <tr>
            <td>&nbsp;</td>
            <td colspan="4" class="subTitulo"><strong>Expiraci&oacute;n de la sesi&oacute;n</strong></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="2"><label for="sesion_duracion_default">Valor general &Dagger;</label></td>
            <td><input name="sesion_duracion_default" type="text" class="flat right" id="sesion_duracion_default" onFocus="this.select()" value="#data.sesion.duracion.default#" size="6" maxlength="6" onblur="solonumero(this,'#data.sesion.duracion.default#')">
                <label for="sesion_duracion_default">minutos</label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="2"><label for="sesion_duracion_min">Rango v&aacute;lido &dagger;</label></td>
            <td><input name="sesion_duracion_min" type="text" class="flat right" id="sesion_duracion_min" onFocus="this.select()" value="#data.sesion.duracion.min#" size="6" maxlength="6" onblur="solonumero(this,'#data.sesion.duracion.min#')">
                <label for="sesion_duracion_max"> a </label>
                <input name="sesion_duracion_max" type="text" class="flat right" id="sesion_duracion_max" onFocus="this.select()" value="#data.sesion.duracion.max#" size="6" maxlength="6" onblur="solonumero(this,'#data.sesion.duracion.max#')">            </td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td valign="middle"><input id="sesion_duracion_modo_1" name="sesion_duracion_modo" type="radio" value="1" <cfif data.sesion.duracion.modo neq '2'>checked</cfif>>            </td>
            <td colspan="2" valign="middle"><label for="sesion_duracion_modo_1">Contar desde el inicio de la sesi&oacute;n </label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td valign="middle"><input id="sesion_duracion_modo_2" name="sesion_duracion_modo" type="radio" value="2" <cfif data.sesion.duracion.modo eq '2'>checked</cfif>>            </td>
            <td colspan="2" valign="middle"><label for="sesion_duracion_modo_2">Contar solamente tiempo inactivo </label></td>
            <td>&nbsp;</td>
          </tr>
          
          
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="3">(Estos valores aplicarán para sesiones nuevas) </td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="4">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="4" class="subTitulo"><strong>Método de autenticación </strong></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="2"><label for="auth_orden">Orden</label></td>
            <td><select name="auth_orden" id="auth_orden">
			<option value="asp" <cfif data.auth.orden is 'asp'>selected</cfif>>asp</option>
			<option value="ldap"<cfif data.auth.orden is 'ldap'>selected</cfif>>ldap</option>
			<option value="asp,ldap"<cfif data.auth.orden is 'asp,ldap'>selected</cfif>>asp,ldap</option>
			<option value="ldap,asp"<cfif data.auth.orden is 'ldap,asp'>selected</cfif>>ldap,asp</option>
            </select>            </td>
            <td>&nbsp;</td>
          </tr>
          
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="2"><label for="auth_nuevo">Usuarios nuevos</label> </td>
            <td><select name="auth_nuevo" id="auth_nuevo">
			<option value="admit"<cfif data.auth.nuevo is 'admit'>selected</cfif>>Admitir y crear perfil</option>
			<option value="reject"<cfif data.auth.nuevo is 'reject'>selected</cfif>>Rechazar</option>
            </select></td>
            <td>&nbsp;</td>
          </tr>
          
			<cfif IsDefined('data.auth.validar.ip') Or IsDefined('data.auth.validar.horario')>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td valign="top">&nbsp;</td>
            <td colspan="2" valign="top">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="4" class="subTitulo"><strong>Acceso Remoto</strong></td>
            <td>&nbsp;</td>
          </tr></cfif>
			<cfif IsDefined('data.auth.validar.ip')>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td valign="top">
			<input type="checkbox" id="auth_validar_ip"  name="auth_validar_ip" value="1" <cfif data.auth.validar.ip is 1>checked</cfif> /></td>
            <td colspan="2" valign="top"><label for="auth_validar_ip">Validar dirección IP</label></td>
            <td>&nbsp;</td>
          </tr></cfif>
			<cfif IsDefined('data.auth.validar.horario')>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td valign="top">
			<input type="checkbox" id="auth_validar_horario"  name="auth_validar_horario" value="1" <cfif data.auth.validar.horario is 1>checked</cfif> /></td>
            <td colspan="2" valign="top"><label for="auth_validar_horario">Validar horario</label></td>
            <td>&nbsp;</td>
          </tr></cfif>
          <tr>
            <td>&nbsp;</td>
            <td colspan="4">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
      </table></td>
      <td width="50%" valign="top"><table border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="32">&nbsp;</td>
            <td width="27">&nbsp;</td>
            <td width="27">&nbsp;</td>
            <td width="180">&nbsp;</td>
            <td width="153">&nbsp;</td>
            <td width="10">&nbsp;</td>
          </tr>
          
          <tr>
            <td colspan="5" class="subTitulo"><strong>M&uacute;ltiples sesiones por usuario</strong></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td valign="top"><input id="sesion_multiple_1" name="sesion_multiple" type="radio" value="1" <cfif data.sesion.multiple is 1>checked</cfif>></td>
            <td colspan="3" valign="top"><label for="sesion_multiple_1"><strong>Permitir m&uacute;ltiples sesiones por usuario. 
                    <br>
            </strong></label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td valign="top"><label>
              <input id="sesion_multiple_2" name="sesion_multiple" type="radio" value="2" <cfif data.sesion.multiple is 2>checked</cfif>>
            </label></td>
            <td colspan="3" valign="top"><label for="sesion_multiple_2" ><strong>Desconectar sesiones anteriores.</strong>             Si se realiza una segunda conexi&oacute;n por el mismo
            usuario, se desconectar&aacute;n la sesiones anteriores.
            </label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td valign="top"><input id="sesion_multiple_3" name="sesion_multiple" type="radio" value="3" <cfif data.sesion.multiple is 3>checked</cfif>></td>
            <td colspan="3" valign="top"><label for="sesion_multiple_3"><strong>Permitir s&oacute;lo una sesi&oacute;n por usuario. </strong>No se realizar&aacute;n nuevas conexiones para el 
            mismo usuario mientras las anteriores no 
            finalicen o expiren. </label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td valign="top">&nbsp;</td>
            <td colspan="3" valign="top">&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
		  <cfif IsDefined('data.monitor.habilitar')>
          <tr>
            <td colspan="5" class="subTitulo"><strong>Seguimiento de sesiones </strong></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td valign="top"><input id="monitor_habilitar_0" name="monitor_habilitar" type="radio" value="0" <cfif data.monitor.habilitar is 0>checked</cfif> /></td>
            <td colspan="3" valign="top"><label for="monitor_habilitar_0"><strong>Solamente limitar al control de acceso múltiple.            </strong></label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td valign="top"><label>
              <input id="monitor_habilitar_1" name="monitor_habilitar" type="radio" value="1" <cfif data.monitor.habilitar is 1>checked</cfif> />
            </label></td>
            <td colspan="3" valign="top"><label for="monitor_habilitar_1" ><strong>Rastrear las operaciones realizadas.</strong>               La actividad del usuario quedará registrada en una bitácora que incluye la página solicitada, los datos enviados y el tiempo de respuesta. 
              <br />
            </label></td>
            <td>&nbsp;</td>
          </tr></cfif>
      </table>        </td>
    </tr>
    <tr>
      <td colspan="2" align="left" class="subTitulo"><input name="submit-sess" type="submit" id="submit-sess" value="Aplicar" class="btnGuardar">
          <input type="reset" name="Reset" value="Cancelar" class="btnLimpiar">      </td>
    </tr>
  </table>
<script type="text/javascript">
function funcvalidar(){
	var f = document.form1;
	solonumero(f.sesion_duracion_default, '#data.sesion.duracion.default#');
	solonumero(f.sesion_duracion_min, '#data.sesion.duracion.min#');
	solonumero(f.sesion_duracion_max, '#data.sesion.duracion.max#');
	if(parseInt(f.sesion_duracion_max.value) < parseInt(f.sesion_duracion_min.value)){
		f.sesion_duracion_max.value = f.sesion_duracion_min.value;
	}
	return true;
}
</script>
</cfoutput>

