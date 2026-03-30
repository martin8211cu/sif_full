<!---  --->
<style type="text/css" >
.ayuda {
	background-color: #e4e4e4;
	padding: 4px;
	border: 1px solid #000000;
}
.error {
	font-weight: bold;
	color: #FF0000;
	font-family: Arial, Helvetica, sans-serif;
	font-size:small;
}
</style>

<cfinvoke component="home.Componentes.Politicas" method="trae_parametros_cuenta" returnvariable="data" CEcodigo="#session.CEcodigo#"/>

<cfoutput>

<input type="hidden" name="user" value="#HTMLEditFormat(session.usuario)#" /></cfoutput>
<table border="0" width="100%">
  <tr>
   <!--- <td width="253" class="subTitulo">Instrucciones</td>
    <td width="520"  class="subTitulo">Contrase&ntilde;a nueva</td>--->
	<td width="40%" class="subTitulo"><cf_translate  key="LB_Instrucciones">Instrucciones</cf_translate></td>
	<td width="1%" class="subTitulo"></td>
    <td width="60%"  class="subTitulo"><cf_translate  key="LB_ContrasenaNueva">Contrase&ntilde;a nueva</cf_translate></td>
  </tr>
  <tr>
    <td valign="top" class="ayuda">
		<cf_translate  key="AYUDA_SeRecomiendaRealizarEsteCambioDeManeraPeriodica">
		Se recomienda realizar este cambio de manera peri&oacute;dica, con el fin de incrementar la seguridad de su informaci&oacute;n.<br>
  		Junto con la contrase&ntilde;a, usted podr&aacute; modificar la informaci&oacute;n personal que lo identifica como due&ntilde;o de la cuenta, y que solamente usted deber&iacute;a conocer. Si omite esta identificaci&oacute;n, y si llega a olvidar su contrase&ntilde;a deber&aacute; comunicarse con el administrador.
        <p>Por su propia seguridad, seleccione una contrase&ntilde;a que cumpla con las siguientes caracter&iacute;sticas:</p>
		</cf_translate>
		<div id="div_test_msg">
<cfinvoke component="home.Componentes.ValidarPassword" method="reglas" data="#data#" returnvariable="reglas"/>
	<cfif ArrayLen(reglas.errpass)>
	<ul>
	<li><cfoutput>#ArrayToList( reglas.errpass, '</li><li>')#</cfoutput></li>
	</ul>
	</cfif>
</div></td>
<td width="1%" class="subTitulo"></td>
    <td valign="top">
	<table border="0" cellspacing="4" cellpadding="4"  width="100%">
    <!--DWLayoutTable-->
    <tr>
      <td colspan="3" valign="top" align="center" class="error">

		<cfif isdefined("url.error") and url.error eq '1'>
			<cf_translate  key="LB_CompleteLosDatosSolicitados">Complete los datos solicitados</cf_translate>
		<cfelseif isdefined("url.error") and url.error eq '2'>
			<cf_translate  key="LB_LaContrasenaAnteriorEsIncorrecta">La contrase&ntilde;a anterior es incorrecta</cf_translate>
		<cfelseif isdefined("url.error") and url.error eq '3'>
			<cf_translate  key="LB_SuContrasenaYaExpiroPorFavorSeleccioneUnaNuevaContrasena">Su contrase&ntilde;a ya expir&oacute;. Por favor, seleccione una nueva contrase&ntilde;a</cf_translate>.
		<cfelseif isdefined("url.error") and url.error eq '4'>
			<cfparam name="url.days" default="7">
			<cf_translate  key="LB_SuContrasenaExpiraEn">
			Su contrase&ntilde;a expira en
			</cf_translate>
			<cfoutput>#url.days#</cfoutput>
			<cf_translate  key="LB_DiasSeleccioneUnaNuevaContrasenaOPresioneCancelarParaRegresarMasTarde">
			d&iacute;as. Seleccione una nueva contrase&ntilde;a, o presione cancelar para regresar m&aacute;s tarde
			</cf_translate>
		<cfelseif isdefined("url.error") and url.error eq '5'>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_ContrasenaDebil"
			Default="Contraseña débil"
			returnvariable="LB_ContrasenaDebil"/>

			<cfparam name="session.errpass" default="#LB_ContrasenaDebil#">
			<cfoutput>#session.errpass#</cfoutput>
			<cfset StructDelete(session,'errpass')>
		<cfelseif isdefined("url.error") and url.error eq '6'>
        	<cfoutput>
			<cf_translate  key="LB_SuContrasenanopuedeserrepetida">Su contrase&ntilde;a NO puede ser igual con las #data.pass.valida.lista# anteriores. Por favor, seleccione una nueva contrase&ntilde;a</cf_translate>.
            </cfoutput>
		</cfif>
		</td>
    </tr>
    <tr>
      <td colspan="2"  valign="top"> <label><cf_translate  key="LB_ContrasenaActual">Contrase&ntilde;a actual</cf_translate></label></td>
      <td width="262" valign="top" > <input name="oldpass" type="password" id="oldpass" value="" size="30" onFocus="this.select()" />      </td>
    </tr>
    <tr>
      <td colspan="3"  valign="top"><cf_translate  key="LB_SeRequiereSuContrasenaActualParaGarantizarLaSeguridadDeSuCuenta">Se requiere su contraseña actual para garantizar la seguridad de su cuenta</cf_translate>.</td>
    </tr>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ContrasenaAceptada"
	Default="Contraseña aceptada"
	returnvariable="LB_ContrasenaAceptada"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ContrasenaRechazada"
	Default="Contraseña rechazada"
	returnvariable="LB_ContrasenaRechazada"/>
	<cfoutput>
    <tr>
      <td colspan="2" valign="top" ><label><cf_translate  key="LB_ContrasenaDeseada">Contrase&ntilde;a deseada</cf_translate></label></td>
      <td valign="top" ><input name="newpass" type="password" id="newpass" value="" size="30" onFocus="this.select()" onkeyup="valid_password( &quot;# HTMLEditFormat( JSStringFormat(session.usuario)) #&quot;, this.form.newpass.value, this.form.newpass2.value)" />
			<img src="/cfmx/asp/admin/politicas/global/aceptado.gif" alt="ok" name="img_pass_ok" width="13" height="12" id="img_pass_ok" longdesc="#LB_ContrasenaAceptada#" style="display:none" />
			<img src="/cfmx/asp/admin/politicas/global/rechazado.gif" alt="ok" name="img_pass_mal" width="13" height="12" id="img_pass_mal" longdesc="#LB_ContrasenaRechazada#" />
		</td>
    </tr>
    <tr>
      <td colspan="2" valign="top" ><label><cf_translate  key="LB_ConfirmeLaNuevaContrasena">Confirme la nueva contrase&ntilde;a</cf_translate></label></td>
      <td valign="top" ><input name="newpass2" type="password" id="newpass2" value="" size="30" onFocus="this.select()" onkeyup="valid_password( &quot;# HTMLEditFormat( JSStringFormat(session.usuario)) #&quot;, this.form.newpass.value,this.form.newpass2.value)" />
	  		<img src="/cfmx/asp/admin/politicas/global/aceptado.gif" alt="ok" name="img_pass2_ok" width="13" height="12" id="img_pass2_ok" longdesc="#LB_ContrasenaAceptada#" style="display:none" />
			<img src="/cfmx/asp/admin/politicas/global/rechazado.gif" alt="ok" name="img_pass2_mal" width="13" height="12" id="img_pass2_mal" longdesc="#LB_ContrasenaRechazada#" />
	</td>
    </tr>
    </cfoutput>
    <tr>
      <td colspan="3" valign="top" class="subTitulo"> <cf_translate  key="LB_IdentificacionPersonal">Identificaci&oacute;n personal</cf_translate></td>
    </tr>
    <tr>
      <td width="38"  valign="top" ><input type="radio" name="preg" id="pregno" value="0" checked></td>
      <td colspan="2" valign="top" ><label for="pregno">
	  <cf_translate  key="LB_DeseoQueLaPreguntaYRespuestaPersonalesPermanezcanComoEstan">
	  Deseo que la pregunta y respuesta personales permanezcan como est&aacute;n.
	  </cf_translate></label></td>
    </tr>
    <tr>
      <td  valign="top" ><input type="radio" name="preg" id="pregsi" value="1" ></td>
      <td colspan="2" valign="top" ><label for="pregsi">
	  <cf_translate  key="LB_DeseoModificarLaPreguntaYRespuestaPersonalesComoMedioDeIdentificacion">
	  Deseo modificar la pregunta y respuesta personales como medio de identificaci&oacute;n.
	  </cf_translate></label></td>
    </tr>
    <tr>
      <td colspan="2" valign="top"><label><cf_translate  key="LB_Pregunta">Pregunta</cf_translate></label></td>
      <td valign="top" ><select name="pregunta" id="pregunta" onChange="document.f.pregsi.checked = true" >
          <option>&iquest; <cf_translate  key="LB_CualEsMiNumeroDeLaSuerte">Cu&aacute;l es mi n&uacute;mero de la suerte</cf_translate>?</option>
          <option>&iquest; <cf_translate  key="LB_ComoSeLlamaMiSuegra">C&oacute;mo se llama mi suegra </cf_translate>?</option>
          <option>&iquest; <cf_translate  key="LB_DeQueColorFueMiPrimerAuto">De qu&eacute; color fue mi primer auto</cf_translate>?</option>
          <option>&iquest; <cf_translate  key="LB_CuantosHermanosTengo">Cu&aacute;ntos hermanos tengo</cf_translate>?</option>
          <option selected><cf_translate  key="LB_NombreDeMiMascota">Nombre de mi mascota</cf_translate></option>
          <option><cf_translate  key="LB_SegundoApellidoDeMiMama">Segundo apellido de mi mam&aacute;</cf_translate></option>
        </select>		</td>
    </tr>

    <tr>
      <td colspan="2" valign="top"><label><cf_translate  key="LB_Respuesta">Respuesta</cf_translate></label></td>
      <td valign="top"> <input name="respuesta" type="text" value="" size="30" maxlength="60" onChange="document.f.pregsi.checked = true" /></td>
    </tr>
    <tr>
      <td colspan="3" align="center" valign="top"><p>
	   <cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Cancelar"
		Default="Cancelar"
		returnvariable="BTN_Cancelar"/>

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Continuar"
		Default="Continuar"
		returnvariable="BTN_Continuar"/>
		<cfoutput>
			<input name="button" type="button" class="btnAnterior" onclick="self.location.href='?'" value="#BTN_Cancelar#" />
			<input type="submit" class="btnGuardar" value="#BTN_Continuar#" />
		</cfoutput>
        </p></td>
    </tr>
    <tr>
      <td></td>
      <td width="180"></td>
      <td></td>
    </tr>
  </table></td>
  </tr>
</table>

<script type="text/javascript" src="/cfmx/home/menu/passch.js">//</script>

<cfinvoke component="home.Componentes.ValidarPassword" method="javascript" data="#data#"/>
<script type="text/javascript">
	document.f.oldpass.focus();

</script>