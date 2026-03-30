<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">
<link href="/cfmx/sif/framework/css/sec.css" rel="stylesheet" type="text/css">
<cfset LvarCliente_empresarial = "3000000000000066">
<cfif LvarCliente_empresarial EQ "">
	<cfset LvarPpais = "CR">
	<cfset LvarIcodigo = "es">
<cfelse>
	<cfquery name="rsCCE" datasource="SDC">
		select Ppais, Icodigo
		from CuentaClienteEmpresarial
		where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCliente_empresarial#">
	</cfquery>
	<cfset LvarPpais = rsCCE.Ppais>
	<cfset LvarIcodigo = rsCCE.Icodigo>
</cfif>
<cfquery name="rsPais" datasource="SDC">
	select Ppais, Pnombre 
	from Pais
</cfquery>

<cfquery name="rsIdioma" datasource="SDC">
	select Icodigo, Descripcion
	from Idioma
	where Iactivo = 1
</cfquery>

<cfquery name="rsIdentificacion" datasource="SDC">
	select TIcodigo, TInombre 
	from TipoIdentificacion
</cfquery>

<cfoutput>

	<input type="hidden" name="cliente_empresarial" value="#LvarCliente_empresarial#">

   <table border="0" cellpadding="0" cellspacing="0" width="10%" align="center">
      <tr>
          <td align="center" valign="top">&nbsp;</td>
	  </tr>

      <tr> 
        <td width="1%">&nbsp;</td>
        <td width="40%" valign="top" rowspan="3"> 
				<table cellpadding="0" cellspacing="0" width="100%">
            <tr> 
              <td width="18%" nowrap></td>
              <td width="24%"></td>
              <td width="31%"></td>
              <td width="27%"></td>
            </tr>
            <tr class="itemtit"> 
              <td colspan="4"><font size="2"><b>Registro de Usuario</b></font></td>
            </tr>
            <tr> 
              <td colspan="4"> <br>
                Bienvenido al Registro de Usuarios de nuestro Portal, gracias 
                por preferirnos.<br>
                Por favor, complete este formulario para Registrarse como un nuevo 
                Usuario, y así aprovechar todos los servicios que le ofrecemos.<br> 
                <br> </td>
            </tr>
            <tr> 
              <td align="right" nowrap><strong>Email (*):</strong>&nbsp; </td>
              <td colspan="2"><input name="Pemail1" type="text" size="60" maxlength="60" onFocus="this.select()" > 
              </td>
              <td> </td>
            </tr>
            <tr> 
              <td align="right" nowrap><strong>Confirmar Email(*):</strong>&nbsp;</td>
              <td colspan="2"><input name="Pemail1b" type="text" id="Pemail1b" onFocus="this.select()" size="60" maxlength="60" ></td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="right" nowrap>&nbsp;</td>
              <td colspan="3" nowrap><font color="##0000FF" style="font:9px">Su 
                Email se utilizarán para enviarle el usuario y el password para 
                que ingrese al portal.</font></td>
            </tr>
            <tr> 
              <td colspan="4" nowrap>&nbsp;</td>
            </tr>
            <tr> 
              <td colspan="4" nowrap class="itemtit"><strong>REGIONALIZACION</strong></td>
            </tr>
            <tr> 
              <td colspan="4" nowrap>&nbsp;</td>
            </tr>
            <tr> 
              <td align="right" nowrap>Pa&iacute;s:&nbsp;</td>
              <td colspan="3" nowrap><select name="Ppais" onChange="javascript: Pprovincia_cambioLocale (this.form.Ppais.value, this.form.Icodigo.value);">
                  <cfloop query="rsPais">
                    <option value="#rsPais.Ppais#" <cfif LvarPpais EQ rsPais.Ppais>selected</cfif>>#rsPais.Pnombre#</option>
                  </cfloop>
                </select>
                &nbsp;&nbsp;Idioma:&nbsp;
                <select name="Icodigo" onChange="javascript: Pprovincia_cambioLocale (this.form.Ppais.value, this.form.Icodigo.value);">
                  <cfloop query="rsIdioma">
                    <option value="#rsIdioma.Icodigo#" <cfif LvarIcodigo EQ rsIdioma.Icodigo>selected</cfif>>#rsIdioma.Descripcion#</option>
                  </cfloop>
                </select></td>
            </tr>
            <tr> 
              <td colspan="4" nowrap>&nbsp;</td>
            </tr>
            <tr> 
              <td colspan="4" nowrap class="itemtit"><strong>DATOS PERSONALES</strong></td>
            </tr>
            <tr> 
              <td width="18%" align="right" nowrap>&nbsp;</td>
              <td><strong>Nombre (*)</strong></td>
              <td>Primer Apellido</td>
              <td>Segundo Apellido</td>
            </tr>
            <tr> 
              <td width="18%" align="right" nowrap>&nbsp;</td>
              <td><input name="Pnombre" type="text" size="30" maxlength="60" onFocus="this.select()" ></td>
              <td><input name="Papellido1" type="text" size="30" maxlength="60" onFocus="this.select()" ></td>
              <td> <input name="Papellido2" type="text" size="30" maxlength="60" onFocus="this.select()" ></td>
            <tr> 
              <td align="right" nowrap>&nbsp;</td>
              <td colspan="3"><font color="##0000FF" style="font:9px">Su nombre 
                y dos apellidos se utilizarán para enviarle mensajes y para identificarlo 
                en el portal.</font></td>
            </tr>
            <tr> 
              <td align="right" nowrap><strong>Identificacion (*):&nbsp;</strong></td>
              <td colspan="3"><select name="TIcodigo">
                  <cfloop query="rsIdentificacion">
                    <option value="#rsIdentificacion.TIcodigo#" <cfif rsIdentificacion.TIcodigo EQ 'CED'>selected</cfif> >#rsIdentificacion.TInombre#</option>
                  </cfloop>
                </select> &nbsp; <input name="Pid" type="text" size="20" maxlength="60" onFocus="this.select()" ></td>
            </tr>
            <tr> 
              <td width="18%" align="right" nowrap>Foto:&nbsp;</td>
              <td colspan="3"><input name="Pfoto" type="file" size="60" maxlength="60"> 
              </td>
            </tr>
            <tr> 
              <td align="right" nowrap> Fecha Nacimiento:&nbsp;</td>
              <td align="left"> <cf_sifcalendario name="Pnacimiento"> </td>
              <td align="left">&nbsp; </td>
              <td>&nbsp; </td>
            </tr>
            <tr> 
              <td align="right">Sexo:&nbsp;</td>
              <td><select name="Psexo">
                  <option value="M">Masculino</option>
                  <option value="F">Femenino</option>
                </select></td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="right" nowrap>&nbsp;</td>
              <td colspan="3">&nbsp;</td>
            </tr>
            <tr> 
              <td align="right" valign="top" nowrap>Direcci&oacute;n:&nbsp; </td>
              <td colspan="3"> <textarea name="Pdireccion" cols="60" rows="3"></textarea> 
              </td>
            </tr>
            <tr> 
              <td align="right" nowrap>Ciudad:&nbsp; </td>
              <td><input type="text" name="Pciudad" size="30" maxlength="30" onFocus="this.select()"></td>
              <td align="right">Tel. Oficina:&nbsp;</td>
              <td><input name="Poficina" type="text" size="20" maxlength="30" onFocus="this.select()"> 
              </td>
            </tr>
            <tr> 
              <td align="right" nowrap id="lbl__Pprovincia">Estado/Provin<span>:&nbsp;</span> 
              </td>
              <td> <cfinvoke component="aspAdmin.Componentes.pLocales" 
							  method="fnLocaleListConCambio">
                  <cfinvokeargument name="name" value="Pprovincia"/>
                  <cfinvokeargument name="value" value=""/>
                  <cfinvokeargument name="Ppais" value="#LvarPpais#"/>
                  <cfinvokeargument name="Icodigo" value="es"/>
                  <cfinvokeargument name="LOCcodigo" value="PROVINCIA"/>
                  <cfinvokeargument name="obligatorio" value="true"/>
                </cfinvoke> </td>
              <td align="right">Tel. Celular:&nbsp;</td>
              <td><input name="Pcelular" type="text" size="20" maxlength="30" onFocus="this.select()" ></td>
            </tr>
            <tr> 
              <td align="right" nowrap>C&oacute;digo Postal:&nbsp;</td>
              <td><input name="PcodPostal" type="text" size="15" maxlength="15"></td>
              <td align="right">Tel. Habitaci&oacute;n:&nbsp;</td>
              <td><input name="Pcasa" type="text" size="20" maxlength="30" onFocus="this.select()" ></td>
            </tr>
            <tr> 
              <td align="right" nowrap>&nbsp;</td>
              <td>&nbsp;</td>
              <td align="right">Tel. Fax:&nbsp;</td>
              <td> <input name="Pfax" type="text" size="20" maxlength="30" onFocus="this.select()" > 
              </td>
            </tr>
            <tr> 
              <td align="right" nowrap>&nbsp;</td>
              <td align="left">&nbsp; </td>
              <td align="right">Tel. Beeper:&nbsp;</td>
              <td align="left"><input type="text" name="Ppagertel" size="20" maxlength="30" onFocus="this.select()" > 
              </td>
            </tr>
            <tr> 
              <td align="right" nowrap>Email adicional:&nbsp;</td>
              <td><input name="Pemail2" type="text" size="30" maxlength="60" onFocus="this.select()" > 
              </td>
              <td align="right">&nbsp;Id. Beeper:&nbsp;</td>
              <td><input type="text" name="Ppagernum" size="30" maxlength="30" onFocus="this.select()" > 
              </td>
            </tr>
            <tr> 
              <td align="right" nowrap>P&aacute;g. Personal:&nbsp;</td>
              <td colspan="3"> <input name="Pweb" type="text" size="60" maxlength="60" onFocus="this.select()" > 
              </td>
            </tr>
            <tr> 
              <td colspan="5">&nbsp;</td>
            </tr>
            <tr> 
              <td colspan="5" align="center" valign="top" nowrap > <br> <input type="button" name="Aceptar" value="Aceptar" onClick="javascript:regresar();"> 
                &nbsp; <input type="button" name="Cancelar" value="Cancelar" onClick="javascript:regresar();"> 
              </td>
            </tr>
          </table>
		</td>
      </tr>
    </table>
</cfoutput>

<script src="/cfmx/aspAdmin/js/qForms/qforms.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/aspAdmin/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.Pnombre.required    = true;
	objForm.Pnombre.description = "Nombre";

	objForm.TIcodigo.required    = true;
	objForm.TIcodigo.description = "Tipo de Identificación";

	objForm.Pid.required    = true;
	objForm.Pid.description = "Identificación";

	objForm.Pemail1.required    = true;
	objForm.Pemail1.description = "Email";

	objForm.Ppais.required    = true;
	objForm.Ppais.description = "País";
	
	function regresar(){
		document.form1.action = 'CuentaPrincipal_tabs.cfm';
		document.form1.modo.value = "";
		<cfif isdefined("form.Usucodigo") and isdefined("form.Ulocalizacion")>
			document.form1.Usucodigo.value = '';
			document.form1.Ulocalizacion.value = '';		
		</cfif>		
		document.form1.submit();
	}
	
	function deshabilitarValidacion(){
		objForm.Pnombre.required  = false;
		objForm.TIcodigo.required = false;
		objForm.Pid.required      = false;
	}
	
</script>
