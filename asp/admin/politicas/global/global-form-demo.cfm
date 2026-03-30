<!--- El combo de cache para demos depende de la cuenta empresarial, por eso se usa este query --->
<cfquery name="caches" datasource="asp">
	select b.CEcodigo, b.CEClinea, b.Cid, a.Ccache,a.Cexclusivo
		from CECaches b, Caches a
		where b.Cid = a.Cid
		  and b.CEcodigo != 1
	order by b.CEcodigo
</cfquery>

<script type="text/javascript">
<!--
	function factory_presets(){
		if (confirm("¿Está seguro de que desea restablecer todo a los valores predeterminados?")) {
			location.href = 'global-apply.cfm?action=factory_presets';
		}
	}

	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}

	function funcvalidar(){
		if (trim(document.form1.demo_vigencia.value) == ''){
			alert("Debe ingresar una vigencia para el usuario de las demostraciones")
			return false;
		}		
		return true;
	}

	function cache(cuenta, seleccionado){
		var c = document.form1.demo_cache;
		var cuenta_asp = '';
		c.options.length = 0;
		if ( cuenta != '' ){
			<cfoutput query="caches">
				cuenta_asp = #caches.CEcodigo#;
				if ( cuenta_asp == cuenta ){
					c.options.length++;
					c.options[c.options.length-1].text = '#caches.Ccache#';
					c.options[c.options.length-1].value = '#caches.Ccache#';
					
					if ( seleccionado == '#caches.Ccache#'){
						c.options[c.options.length-1].selected = true;
					}
					
				}
			</cfoutput>
		}
	}
//-->
</script>

<cfquery name="rsCuentasEmpresariales" datasource="asp">
	select CEcodigo,CEnombre
	from CuentaEmpresarial
	where CEcodigo != 1
	order by CEnombre
</cfquery>

<cfoutput>
  <table width="100%" border="0" cellpadding="2" cellspacing="2">
    <tr>
      <td valign="top"><table width="451" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td width="11">&nbsp;</td>
          <td width="18">&nbsp;</td>
          <td width="422">&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td class="subTitulo" colspan="2"><strong>Demostraciones</strong></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td colspan="2" valign="top"><label for="demo_vigencia">Vigencia</label>
              <label for="demo_vigencia">en días</label></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td><input  name="demo_vigencia" class="flat" type="text" id="demo_vigencia" onfocus="this.select()" value="#data.demo.vigencia#" size="6" maxlength="6" onblur="solonumero(this,'#data.demo.vigencia#')" /></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td colspan="2"><label for="demo_CuentaEmpresarial">Cuenta Empresarial demos&nbsp;</label></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td><select name="demo_CuentaEmpresarial" id="demo_CuentaEmpresarial" onchange="javascript:cache(this.value,'#data.demo.cache#');" <cfif data.demo.CuentaEmpresarial is 0>disabled</cfif>>
              <cfloop query="rsCuentasEmpresariales">
                <option value="#rsCuentasEmpresariales.CEcodigo#" <cfif trim(rsCuentasEmpresariales.CEcodigo) EQ trim(data.demo.CuentaEmpresarial)>selected</cfif>>#trim(rsCuentasEmpresariales.CEnombre)#</option>
              </cfloop>
            </select>          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td colspan="2"><label for="demo_cache">Cache demos&nbsp;</label></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td><select name="demo_cache" id="demo_cache">
            </select></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
      </table></td>  
    </tr>
    <tr>
      <td align="left" class="subTitulo"><input name="submit-demo" type="submit" id="submit-demo" value="Aplicar" class="btnGuardar">
          <input type="reset" name="Reset" value="Cancelar" class="btnLimpiar">      </td>
    </tr>
  </table>
<script type="text/javascript" language="JavaScript1.2">
	cache(document.form1.demo_CuentaEmpresarial.value, '#data.demo.cache#');

function funcvalidar(){
	var f = document.form1;
	solonumero(f.demo_vigencia, '#data.demo.vigencia#');
	return true;
}
</script>
</cfoutput>

