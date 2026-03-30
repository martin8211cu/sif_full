<cfinvoke component="home.Componentes.Politicas" method="trae_parametros_globales"
	returnvariable="dataPoliticas"/>

<cfparam name="url.emp" default="0" type="numeric">
<cfif url.emp is 0>
	<cfset titulo="Crear empresa">
<cfelse>
	<cfset titulo="Modificar empresa">
</cfif>

<cfif url.emp>
	<cfquery datasource="asp" name="empq">
		select e.Ecodigo,
			e.Enombre, e.Eidentificacion,
			e.Etelefono1, e.Etelefono2, e.Efax,
			ce.CEaliaslogin,
			m.Mnombre, c.Ccache, e.id_direccion, e.ts_rversion
		from Empresa e
			join Moneda m
				on e.Mcodigo = e.Mcodigo
			join Caches c
				on c.Cid = e.Cid
			join CuentaEmpresarial ce
				on ce.CEcodigo = e.CEcodigo
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.emp#">
	</cfquery>
<cfelse>
	<cfquery datasource="asp" name="modelos">
		select e.Ecodigo, e.Enombre
		from Empresa e
		where e.Enombre like '%'
		and e.Cid in (
			select Cid
			from Caches
			where Ccache in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#StructKeyList(Application.dsinfo)#" list="yes">) )
		and exists(
			select 1
			from ModulosCuentaE x
			where x.SScodigo = 'aspweb' and x.CEcodigo = e.CEcodigo )
		order by 2
	</cfquery>
	<cfquery name="rsCaches" datasource="asp">
		select b.Cid, 
			   b.Ccache
		from Caches b
		where b.Cexclusivo = 0
		  and b.Ccache in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#StructKeyList(Application.dsinfo)#" list="yes">)
		order by 2
	</cfquery>
	<cfquery name="rsMonedas" datasource="asp">
		select Mcodigo, 
			   Mnombre
		from Moneda	
		order by Mnombre
	</cfquery>
</cfif>


<!--- Idiomas --->
<cfquery name="rsIdiomas" datasource="sifcontrol">
	select rtrim(Icodigo) as LOCIdioma, Descripcion as LOCIdescripcion
	from Idiomas
	order by 1, 2
</cfquery>

<cf_templateheader title="#titulo#">

<cf_web_portlet_start titulo="#titulo#">

<cfoutput>

<cfinvoke component="home.Componentes.ValidarPassword" method="javascript" data="#dataPoliticas#"/>
<script type="text/javascript">
<!--
	function $(x){return document.all?document.all[x]:document.getElementById(x);}
	function validar_form(f) {
		var errores = new Array();
		if(f.username) {<!--- Validación de usuario solamente en modo ALTA --->
			var valida = validarPassword(f.username.value, f.password.value);
			if(f.Enombre.value.length == 0)
				errores.push('Especifique el nombre de la nueva empresa.');
			if(f.Eidentificacion.value.length == 0)
				errores.push('Especifique la identificación (Cédula Jurídica, RFC, RUC, etc) de la nueva empresa.');
			if(f.telefono1.value.length == 0)
				errores.push('Especifique el teléfono de la nueva empresa.');
			if(f.Mcodigo.value.length == 0)
				errores.push('Especifique la moneda de la nueva empresa.');
				
			if(f.CEaliaslogin.value.length == 0)
				errores.push('Especifique el alias para login de la nueva empresa.');
				
			if(f.username.value.length == 0)
				errores.push('Especifique el usuario administrador');
			else if (valida.erruser.length)
				errores = errores.concat(valida.erruser);
			if(f.password.value.length == 0)
				errores.push('Especifique la contrase\u00f1a del administrador');
			else if (valida.errpass.length)
				errores = errores.concat(valida.errpass);

			if(f.password.value != f.password2.value) {
				if (f.password2.value.length == 0)
					valida.errpass.push("Por favor confirme la contrase\u00f1a del usuario administrador.");
				else
					valida.errpass.push("La contrase\u00f1a del usuario administrador debe coincidir en ambas casillas.");
			}
			
			if(f.nombre.value.length == 0)
				errores.push('Especifique el nombre del usuario administrador.');
			if(f.apellido1.value.length == 0)
				errores.push('Especifique el apellido del usuario administrador.');
			if(f.username.value.length == 0 && f.email1.value.length == 0)
				errores.push('Especifique el email del usuario administrador.');
			
			$('img_user_ok').style.display = !valida.erruser.length ? '' : 'none';
			$('img_user_mal').style.display = valida.erruser.length ? '' : 'none';
	
			$('img_pass_ok').style.display = !valida.errpass.length ? '' : 'none';
			$('img_pass_mal').style.display = valida.errpass.length ? '' : 'none';
			$('img_pass2_ok').style.display = !(valida.errpass.length) ? '' : 'none';
			$('img_pass2_mal').style.display = (valida.errpass.length) ? '' : 'none';
		}
		return errores;
	}
	function valid_onsubmit(f) {
		var errores = validar_form(f);
		if(errores.length) {
			alert('Por favor corriga los siguientes errores:\n - ' + errores.join('\n - ') );
		}
		return errores.length == 0;
	}
	function valid_password(f) {
		var div = $('div_test_msg');
		if (!document.origMsg) {
			document.origMsg = div.innerHTML;
		}
		var errores = validar_form(f);
		if ( errores.length == 0 )
			div.innerHTML = 'Datos aceptados:<ul><li>Usuario y contrase\u00f1a v\u00e1lidos</li></ul>';
		else
			div.innerHTML = 'Complete lo siguiente:<ul style="margin:0"><li>' + errores.join('<li>') + '</li></ul>';
	}	
-->
</script>

<form action="crear-sql.cfm" method="post" name="form1" onsubmit="return valid_onsubmit(this)" enctype="multipart/form-data">
<cfif url.emp>
	<input type="hidden" name="emp" value="# HTMLEditFormat( url.emp ) #" />
	<input type="hidden" name="ctae" value="# HTMLEditFormat( url.ctae ) #" />
</cfif>
<table width="950" border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td width="127" class="subTitulo"><img src="../blank.gif" width="1" height="1" border="0" alt=""/></td>
    <td width="161" class="subTitulo"><img src="../blank.gif" width="1" height="1" border="0" alt=""/></td>
    <td width="106" class="subTitulo"><img src="../blank.gif" width="1" height="1" border="0" alt=""/></td>
    <td width="109" class="subTitulo"><img src="../blank.gif" width="1" height="1" border="0" alt=""/></td>
    <td width="100" class="subTitulo"><img src="../blank.gif" width="1" height="1" border="0" alt=""/></td>
    <td width="323" class="subTitulo"><img src="../blank.gif" width="1" height="1" border="0" alt=""/></td>
  </tr>
  <tr>
    <td colspan="6" class="subTitulo tituloListas">#titulo#</td>
  </tr>
  <cfif url.emp is 0>
  <tr>
    <td class="etiquetaCampo" align="right" nowrap="nowrap">Empresa modelo:&nbsp;</td>
    <td colspan="5"><select name="emodelo" style="width:280px">
	<cfloop query="modelos">
	<option value="#Ecodigo#">#HTMLEditFormat(Enombre)#</option>
	</cfloop>
	</select></td>
  </tr></cfif>
  <tr>
    <td class="etiquetaCampo" align="right" nowrap="nowrap"><cfif url.emp is 0>País:&nbsp;</cfif></td>
    <td colspan="4" align="left" nowrap="nowrap"><cfif url.emp is 0><select name="select2" style="width:280px">
      <option>-Seleccione-</option>
      <option>Costa Rica</option>
      <option>El Salvador</option>
      <option>Guatemala</option>
      <option>Honduras</option>
      <option>Nicaragua</option>
    </select></cfif></td>
    <td rowspan="7" align="left" nowrap="nowrap" valign="top"><cfif url.emp>
      <cfinvoke 
					 component="sif.Componentes.DButils"
					 method="toTimeStamp"
					 returnvariable="tsurl" arTimeStamp="#empq.ts_rversion#"></cfinvoke>
      <img src="/cfmx/home/public/logo_empresa.cfm?EcodigoSDC=#url.emp#&amp;ts=#Hash(tsurl)#" height="110" /></cfif>    </td>
  </tr>
  <tr>
    <td class="etiquetaCampo" align="right" nowrap="nowrap"><cfif url.emp is 0>Giro:&nbsp;</cfif></td>
    <td colspan="4" align="left" nowrap="nowrap"><cfif url.emp is 0><select name="select" style="width:280px">
      <option>-Seleccione-</option>
      <option>Abarrotes</option>
      <option>Consultorías y Servicios</option>
      <option>Profesional independiente</option>
      <option>Peluquería</option>
      <option>Tiendas y boutiques</option>
      <option>Turismo</option>
    </select></cfif></td>
    </tr>
  <tr>
            <td class="etiquetaCampo" align="right" nowrap="nowrap"><em>(*) </em>Nombre:&nbsp;</td>
            <td colspan="4" align="left" nowrap="nowrap"><input name="Enombre" type="text" id="Enombre" onfocus="this.select(); this.style.backgroundColor='##FFFFFF';" value="<cfif url.emp>#HTMLEditFormat(empq.Enombre)#</cfif>" size="60" maxlength="100"  />          </td>
      </tr>
          <tr>
            <td align="right" nowrap="nowrap" class="etiquetaCampo"><em>(*) </em>Identificaci&oacute;n:&nbsp;</td>
            <td><input name="Eidentificacion" type="text" id="Eidentificacion" value="<cfif url.emp>#HTMLEditFormat(empq.Eidentificacion)#</cfif>" size="15" maxlength="30"  /></td>
            <td class="etiquetaCampo" align="right" nowrap="nowrap">Cache:&nbsp;</td>
            <td colspan="2" align="left" nowrap="nowrap"><cfif url.emp> #HTMLEditFormat(empq.Ccache)# <cfelse>
              <select name="Cid" onchange="javascript: CrearCache(this);">
                <cfloop query="rsCaches">
                  <option value="#rsCaches.Cid#">#rsCaches.Ccache#</option>
                </cfloop>
              </select></cfif></td>
          </tr>
          <tr>
            <td class="etiquetaCampo" align="right" nowrap="nowrap"><em>(*) </em>Telef&oacute;no 1:&nbsp;</td>
            <td align="left" nowrap="nowrap"><input name="telefono1" type="text" id="telefono1" onfocus="this.select();" value="<cfif url.emp>#HTMLEditFormat(empq.Etelefono1)#</cfif>" size="15" maxlength="30" ></td>
            <td class="etiquetaCampo" align="right" nowrap="nowrap"><em>(*) </em>Moneda:&nbsp;</td>
            <td colspan="2" align="left" nowrap="nowrap">
			<cfif url.emp># HTMLEditFormat(empq.Mnombre) #<cfelse>
			<select name="Mcodigo" style="width:200px">
			<option value="">- Seleccione -</option>
              <cfloop query="rsMonedas">
                <option value="#rsMonedas.Mcodigo#">#HTMLEditFormat(rsMonedas.Mnombre)#</option>
              </cfloop>
              </select></cfif></td>
          </tr>
          <tr>
            <td class="etiquetaCampo" align="right" nowrap="nowrap">Telef&oacute;no 2:&nbsp;</td>
            <td align="left" nowrap="nowrap"><input name="telefono2" type="text" id="telefono2" onfocus="this.select();" value="<cfif url.emp>#HTMLEditFormat(empq.Etelefono2)#</cfif>" size="15" maxlength="30" ></td>
            <td class="etiquetaCampo" align="right" nowrap="nowrap">Idioma:&nbsp;</td>
            <td colspan="2" align="left" nowrap="nowrap"><select name="LOCIdioma">
              <cfloop query="rsIdiomas">
                <option value="#rsIdiomas.LOCIdioma#" >#rsIdiomas.LOCIdescripcion#</option>
              </cfloop>
              </select>          </td>
          </tr>
          <tr>
            <td class="etiquetaCampo" align="right" nowrap="nowrap">Fax:&nbsp;</td>
            <td align="left" nowrap="nowrap"><input name="fax" type="text" id="fax" onfocus="this.select();" value="<cfif url.emp>#HTMLEditFormat(empq.Efax)#</cfif>" size="15" maxlength="30"  ></td>
            <td class="etiquetaCampo" align="right" nowrap="nowrap">Logo:&nbsp;</td>
            <td colspan="2" align="left" nowrap="nowrap"><input type="file" name="logo"  ></td>
          </tr>
          <tr>
            <td align="right" valign="top" nowrap="nowrap" class="etiquetaCampo"><input type="checkbox" value="1" name="auditar" id="auditar" onchange="if (!this.checked &amp;&amp; !confirm('Al deshabilitar la auditoría, no será posible rastrear las modificaciones hechas por los usuarios a su propia información. ¿Desea proceder?')) this.checked=true;" checked="checked"/></td>
            <td align="left" valign="top" nowrap="nowrap"><label for="label"><strong>&nbsp;Habilitar auditor&iacute;a</strong></label></td>
            <td align="right" valign="top" nowrap="nowrap" class="etiquetaCampo"><em>(*) </em>Alias para login:&nbsp;</td>
            <td align="left" nowrap="nowrap" valign="top"><input type="text" name="CEaliaslogin" size="15" maxlength="30" value="<cfif url.emp>#HTMLEditFormat(Trim(empq.CEaliaslogin))#</cfif>" onfocus="this.select();"  /></td>
            <td colspan="2" align="left" valign="top" nowrap="nowrap"><em>Empresa para pantalla de login, debe ser &uacute;nico.</em></td>
          </tr><tr>
            <td colspan="6" class="subTitulo"><img src="../blank.gif" width="1" height="1" border="0" /></td>
          </tr><cfif url.emp is 0><tr>
            <td colspan="6" class="subTitulo tituloListas">Usuario administrador </td>
          </tr>
          <tr>
            <td colspan="2"><table width="287" border="0" cellspacing="0" cellpadding="2">
              <tr>
                <td width="123" align="right" class="etiquetaCampo"> <em>(*) </em>Usuario:</td>
                <td width="120"><input name="username" type="text" id="username" 
			size="20" maxlength="30" value="admin"
			onfocus="this.select()"
			onkeyup="valid_password( this.form )" /></td>
                <td width="32"  valign="middle"><img src="/cfmx/asp/admin/politicas/global/aceptado.gif" alt="ok" name="img_user_ok" width="13" height="12" id="img_user_ok" longdesc="Usuario aceptado" style="display:none" /> <img src="/cfmx/asp/admin/politicas/global/rechazado.gif" alt="ok" name="img_user_mal" width="13" height="12" id="img_user_mal" longdesc="Usuario rechazado" /></td>
              </tr>
              <tr>
                <td align="right" class="etiquetaCampo"> <em>(*) </em>Contrase&ntilde;a: </td>
                <td><input name="password" type="password" id="password"  size="20" maxlength="30" value=""
			onfocus="this.select()"
			onkeyup="valid_password( this.form )" /></td>
                <td valign="middle"><img src="/cfmx/asp/admin/politicas/global/aceptado.gif" alt="ok" name="img_pass_ok" width="13" height="12" id="img_pass_ok" longdesc="Contraseña aceptada" style="display:none" /><img src="/cfmx/asp/admin/politicas/global/rechazado.gif" alt="ok" name="img_pass_mal" width="13" height="12" id="img_pass_mal" longdesc="Contraseña rechazada" /></td>
              </tr>
              <tr>
                <td align="right" class="etiquetaCampo"> Confirmar: </td>
                <td><input name="password2" type="password" id="password2"  size="20" maxlength="30" value="" onfocus="javascript: this.select();"  onkeyup="valid_password( this.form )" />                </td>
                <td><img src="/cfmx/asp/admin/politicas/global/aceptado.gif" alt="ok" name="img_pass2_ok" width="13" height="12" id="img_pass2_ok" longdesc="Contraseña aceptada" style="display:none" /><img src="/cfmx/asp/admin/politicas/global/rechazado.gif" alt="ok" name="img_pass2_mal" width="13" height="12" id="img_pass2_mal" longdesc="Contraseña rechazada" /></td>
              </tr>
              
            </table></td>
            <td colspan="3"><table width="317" border="0" cellspacing="0" cellpadding="2">
              <tr>
                <td width="105"align="right" class="etiquetaCampo"> <em>(*) </em>Nombre: </td>
                <td width="204" colspan="2"><input type="text" name="nombre" size="30"
		value="" onfocus="this.select()" onkeyup="valid_password( this.form )"/></td>
              </tr>
              <tr>
                <td align="right" class="etiquetaCampo"> <em>(*) </em>Apellido: </td>
                <td colspan="2"><input type="text" name="apellido1" size="30"
		value="" onfocus="this.select()" onkeyup="valid_password( this.form )"/></td>
              </tr>
              <tr>
                <td align="right" class="etiquetaCampo">Email: </td>
                <td colspan="2"><input type="text" name="email1" size="30"
		value="" onfocus="this.select()" onkeyup="valid_password( this.form )"/></td>
              </tr>
            </table></td>
            <td rowspan="3" valign="top"><div id="div_test_msg">&nbsp;</div></td>
          </tr>
          
</cfif>
          <tr>
            <td colspan="5"><img src="../blank.gif" width="1" height="1" border="0" /></td>
			<cfif url.emp>#'<'#td rowspan="2" valign="top"><div id="div_test_msg">&nbsp;</div>#'<'#/td></cfif>
          </tr>
          
          <tr>
            <td colspan="5"><cfif url.emp>
			<cf_direccion action="input" key="#empq.id_direccion#"><cfelse><cf_direccion action="input"></cfif></td></tr>
  <tr>
    <td colspan="6" class="subTitle">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="6" class="subTitle">
	<cfif url.emp><input type="submit" name="guardar" value="#titulo#" class="btnGuardar">
	<cfelse><input type="submit" name="crear" value="#titulo#" class="btnGuardar"></cfif>
	<input name="regresar" type="button" id="regresar" value="Cancelar" class="btnLimpiar" onclick="this.disabled=true;window.open('../empresas.cfm','_self')"/></td>
  </tr>
</table>


</form>
</cfoutput>


<cf_web_portlet_end>

<cf_templatefooter>