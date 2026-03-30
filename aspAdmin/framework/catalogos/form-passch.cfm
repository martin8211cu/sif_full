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

<form method="post" name="f" action="SQLpassch.cfm" onSubmit="return valida(this, '#session.usuario#');" >
  <table border="0" cellspacing="4" cellpadding="4"  width="100%">
    <!--DWLayoutTable-->
    <tr> 
      <td width="377" valign="top" class="subTitulo">Instrucciones</td>
      <td colspan="3" valign="top" class="subTitulo">Contrase&ntilde;a nueva</td>
    </tr>
    <tr> 
      <td rowspan="11" valign="top" class="ayuda">Se recomienda realizar este 
          cambio de manera peri&oacute;dica, con el fin de incrementar la seguridad 
          de su informaci&oacute;n.<br>
          Junto con la contrase&ntilde;a, usted podr&aacute; modificar la informaci&oacute;n 
          personal que lo identifica como due&ntilde;o de la cuenta, y que solamente 
          usted deber&iacute;a conocer. Si omite esta identificaci&oacute;n, y si llega a olvidar su 
	  contrase&ntilde;a deber&aacute; comunicarse con el administrador.
        <p>Por su propia seguridad, seleccione una contrase&ntilde;a que cumpla 
          con las siguientes caracter&iacute;sticas:</p>
        <ul>
          <li>Tener un m&iacute;nimo de seis caracteres.</li>
          <li>Contener letras y n&uacute;meros.</li>
          <li>Ser diferente al usuario. Debe haber al menos cuatro diferencias.</li>
          <li>No puede ser parte del usuario ni viceversa.</ul>
		  
		  <strong>Despu&eacute;s de realizar el cambio de contrase&ntilde;a, terminar&aacute; la sesi&oacute;n
		  actual por lo que deber&aacute; iniciar otra sesi&oacute;n especificando su usuario y la nueva Contrase&ntilde;a</strong>
		  </td>
      <td colspan="3" valign="top" align="center" class="error">

		<cfif isdefined("form.error") and form.error eq '1'>
			Complete los datos solicitados
		<cfelseif isdefined("form.error") and form.error eq '2'>
			La contrase&ntilde;a anterior es incorrecta
		</cfif>
      </td>
    </tr>
    <tr> 
      <td colspan="2"  valign="top"> <p>Contrase&ntilde;a anterior</p></td>
      <td width="412" valign="top" > <input name="oldpass" type="password" id="oldpass" value="" size="30" onFocus="this.select()" /> 
      </td>
    </tr>
    <tr> 
      <td colspan="3"  valign="top">Esto se solicita para mantener la seguridad del sitio.</td>
    </tr>
    <tr> 
      <td colspan="2" valign="top" >Contrase&ntilde;a deseada</td>
      <td valign="top" ><input name="newpass" type="password" id="newpass" value="" size="30" onFocus="this.select()" /></td>
    </tr>
    <tr> 
      <td colspan="2" valign="top" >Confirme la nueva contrase&ntilde;a</td>
      <td valign="top" ><input name="newpass2" type="password" id="newpass2" value="" size="30" onFocus="this.select()"  /></td>
    </tr>
    <tr> 
      <td colspan="3" valign="top" class="subTitulo"> Identificaci&oacute;n personal</td>
    </tr>
    <tr> 
      <td width="62"  valign="top" ><input type="radio" name="preg" id="pregno" value="0" checked></td>
      <td colspan="2" valign="top" >Deseo que la pregunta y respuesta personales permanezcan como est&aacute;n.</td>
    </tr>
    <tr> 
      <td width="62"  valign="top" ><input type="radio" name="preg" id="pregsi" value="1" ></td>
      <td colspan="2" valign="top" >Deseo modificar la pregunta y respuesta personales como medio de identificaci&oacute;n.</td>
    </tr>
    <tr> 
      <td colspan="2" valign="top">Pregunta</td>
      <td valign="top" ><select name="pregunta" id="pregunta" onChange="document.f.pregsi.checked = true" >
          <option>&iquest; Cu&aacute;l es mi n&uacute;mero de la suerte ?</option>
          <option>&iquest; C&oacute;mo se llama mi suegra ?</option>
          <option>&iquest; De qu&eacute; color fue mi primer auto ?</option>
          <option>&iquest; Cu&aacute;ntos hermanos tengo ?</option>
          <option selected>Nombre de mi mascota</option>
          <option>Segundo apellido de mi mam&aacute;</option>
          <option value="">Otra (especifique)</option>
        </select> </td>
    </tr>

    <tr> 
      <td colspan="2" valign="top">Respuesta</td>
      <td valign="top"> <input name="respuesta" type="text" value="" size="30" maxlength="60" onChange="document.f.pregsi.checked = true" /></td>
    </tr>
    <tr> 
      <td colspan="3" align="center" valign="top"><p> 
          <input type="button" value="Cancelar" onClick="self.location.href='../../'" />
          <input type="submit" value="Continuar &gt; " />
        </p></td>
    </tr>
    <tr> 
      <td></td>
      <td></td>
      <td width="9"></td>
      <td></td>
    </tr>
  </table>
  </form>
		
<script type="text/javascript">

	document.f.oldpass.focus();


// Validacion de la contraseña (lado del cliente)
// Esto deberia ir en js aparte

// distancia minima entre dos hileras, se usa para validar el password
// http://www.csse.monash.edu.au/~lloyd/tildeAlgDS/Dynamic/Edit.html
function DPA(s1, s2)
 { var m = new Array();
   var i, j;
   for(i=0; i < s1.length + 1; i++) m[i] = new Array(); // i.e. 2-D array

   m[0][0] = 0; // boundary conditions

   for(j=1; j <= s2.length; j++)
      m[0][j] = m[0][j-1]-0 + 1; // boundary conditions

   for(i=1; i <= s1.length; i++)                            // outer loop
    { m[i][0] = m[i-1][0]-0 + 1; // boundary conditions

      for(j=1; j <= s2.length; j++)                         // inner loop
       { var diag = m[i-1][j-1];
         if( s1.charAt(i-1) != s2.charAt(j-1) ) diag++;

         m[i][j] = Math.min( diag,               // match or change
                   Math.min( m[i-1][j]-0 + 1,    // deletion
                             m[i][j-1]-0 + 1 ) ) // insertion
       }//for j
    }//for i

   return m[s1.length][s2.length];
 }//DPA

function letrasYNumeros (s)
{
    var letras = false, numeros = false, i;
    for (i = 0; i < s.length; i++) {
        var ch = s.charAt(i);
        letras  |= (ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z');
        numeros |= (ch >= '0' && ch <= '9');
        if (letras && numeros) return true;
    }
    return false;
}

// regresa null si el password es valido, de lo contrario, regresa el mensaje de error
function validarPassword (user, pass){
    var msg = null;
         
    if (pass.length < 6) {
        msg = "La contraseña debe medir al menos seis caracteres.";
    } else if (!letrasYNumeros (pass)) {
        msg = "La contraseña debe contener letras y números.";
    } else if (user == pass) {
        msg = "El usuario y la contraseña no deben coincidir.";
    } else if (user.indexOf(pass) != -1) {
        msg = "La contraseña no puede ser parte del usuario.";
    } else if (pass.indexOf(user) != -1) {
        msg = "El usuario no puede ser parte de la contraseña.";
    } else if (DPA(user,pass) < 4) {
        msg = "La contraseña no puede ser tan parecida al usuario.";
    }
    return msg;
}

function valida(f, lusername){
	if (f.oldpass) { // porque tambien se usa en signup3
		if (f.oldpass.value == '') {
			alert("Captura la contraseña anterior");
			f.oldpass.focus();
			return false;
		}
	}
	if (f.newpass.value == '') {
		alert("Captura la contraseña nueva");
		f.newpass.focus();
		return false;
	}
	if (f.newpass.value != f.newpass2.value) {
        alert("La contraseña debe coincidir en ambas casillas.");
		f.newpass.value = "";
		f.newpass2.value = "";
		f.newpass.focus();
		return false
	}
	var msg = validarPassword(lusername, f.newpass.value);
	if (msg != null) {
		alert (msg);
		f.newpass.focus();
		return false;
	}
	if (f.pregsi && f.respuesta) { // porque tambien se usa en signup3
		if (f.pregsi.checked && f.respuesta.value == '') {
			alert("Capture la respuesta a la pregunta");
			f.respuesta.focus();
			return false;
		}
	}
	return true;
}
</script>