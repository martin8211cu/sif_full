<cfoutput>
  <table width="100%" border="0" cellpadding="2" cellspacing="2">
    <tr>
      <td valign="top"><table border="0" cellspacing="0" cellpadding="0">
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
            <td colspan="4" class="subTitulo"><strong>Autenticación mediante LDAP </strong></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="3"><label for="ldap_server">Equipo y puerto del servicio </label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td><label for="ldap_port"></label></td>
            <td colspan="2" nowrap="nowrap"><input name="ldap_server" type="text" class="flat" id="ldap_server" onfocus="this.select()" value="#data.ldap.server#" size="26" maxlength="60" />:<input name="ldap_port" type="text" class="flat right" id="ldap_port" onfocus="this.select()" value="#data.ldap.port#" size="5" maxlength="5" /></td>
            <td>&nbsp;</td>
          </tr>

          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="3"><label for="ldap_server">Forma de Autenticaci&oacute;n</label></td>
            <td>&nbsp;</td>
          </tr>

		<!---	
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td><label for="ldap_tipo"></label></td>
            <td colspan="2" nowrap="nowrap">
				<select class="flat" id="ldap_tipo" name="ldap_tipo" onchange="javascript: if (this.value == 0){ this.form.ldap_dominio.disabled = true; } else this.form.ldap_dominio.disabled = false;">
					<option value="0" <cfif len(trim(data.ldap.dominio)) eq 0>selected</cfif> >usuario</option>
					<option value="1" <cfif len(trim(data.ldap.dominio)) gt 0>selected</cfif> >usuario@dominio</option>
				</select>
            <td>&nbsp;</td>
          </tr>
		  --->
		  
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td><label for="ldap_tipo"></label></td>
            <td colspan="2" nowrap="nowrap">
				<input type="radio" name="ldap_tipo" id="ldap_tipo" value="0" <cfif len(trim(data.ldap.dominio)) eq 0>checked</cfif>  onclick="javascript: if (this.checked){ this.form.ldap_dominio.disabled = true; }" /><label for="ldap_tipo">usuario</label>
				<input type="radio" name="ldap_tipo" id="ldap_tipo" value="1" <cfif len(trim(data.ldap.dominio)) gt 0>checked</cfif> onclick="javascript: if (this.checked){ this.form.ldap_dominio.disabled = false; }" /><label for="ldap_tipo">usuario@dominio</label>
				<!---
				<select class="flat" id="ldap_tipo" name="ldap_tipo" onchange="javascript: if (this.value == 0){ this.form.ldap_dominio.disabled = true; } else this.form.ldap_dominio.disabled = false;">
					<option value="0" <cfif len(trim(data.ldap.dominio)) eq 0>selected</cfif> >usuario</option>
					<option value="1" <cfif len(trim(data.ldap.dominio)) gt 0>selected</cfif> >usuario@dominio</option>
				</select>
				--->
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="3"><label for="ldap_server">Dominio</label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td><label for="ldap_tipo"></label></td>
            <td colspan="2" nowrap="nowrap">
				<input name="ldap_dominio" type="text" class="flat" id="ldap_dominio" onfocus="this.select()" value="#data.ldap.dominio#" size="26" maxlength="60" <cfif len(trim(data.ldap.dominio)) eq 0>disabled="disabled"</cfif> />
            <td>&nbsp;</td>
          </tr>

          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="3"><label for="ldap_baseDN">Raíz del árbol (Base DN) </label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="2"><input name="ldap_baseDN" type="text" class="flat" id="ldap_baseDN" onfocus="this.select()" value="#data.ldap.baseDN#" size="35" maxlength="60" /></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="3"><label for="ldap_adminDN">Usuario administrador (DN) </label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="2"><input name="ldap_adminDN" type="text" class="flat" id="ldap_adminDN" onfocus="this.select()" value="#data.ldap.adminDN#" size="35" maxlength="60" /></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="3"><label for="ldap_adminPass">Contraseña del administrador </label></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="2"><input name="ldap_adminPass" type="password" class="flat" id="ldap_adminPass" onfocus="this.select()" value="<cfif Len(Trim(data.ldap.adminPass))>**secret**</cfif>" size="35" maxlength="60" autocomplete="off" /></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td colspan="2">&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
          </tr>
      </table></td>
      </tr>
    <tr>
      <td align="left"><input name="submit-ldap" type="submit" id="submit-ldap" value="Aplicar" class="btnGuardar">
          <input type="reset" name="Reset" value="Cancelar" class="btnLimpiar">      </td>
    </tr>
  </table>
</cfoutput>
