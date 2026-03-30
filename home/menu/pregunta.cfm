<cfset session.menues.Ecodigo="">
<cfset session.menues.SScodigo="">
<cfset session.menues.SMcodigo="">
<cfset session.menues.SPcodigo="">
<cfset session.menues.SMNcodigo = "-1">
<cfset session.menues.Empresa1=false>
<cfset session.menues.Sistema1=false>
<cfset session.menues.Modulo1=false>

<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Verificaci&oacute;n de datos personales
</cf_templatearea>
<cf_templatearea name="left">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<!---
	<cfinclude template="/sif/menu.cfm"> --->
</cf_templatearea><cf_templatearea name="body">


<!--- ver sif_login02.css <cfhtmlhead text='<link href="/cfmx/home/menu/menu.css" rel="stylesheet" type="text/css">'> --->

<cfinclude template="navegacion.cfm">
<form action="pregunta-apply.cfm" method="post" name="form1" id="form1" style="margin:0 " onSubmit="return checkform(this);">
<table border="0" cellpadding="0" cellspacing="0" align="center" width="100%">
	<tr>
	  <td colspan="6" align="center" style="font-size: 20px;background-color:#ccc;border:1px solid #999; padding:4px; border-bottom: 2px solid #333; border-right: 2px solid #333">&iexcl; 
	  <cfif session.datos_personales.sexo is 'F'>Bienvenida,
	  <cfelse>Bienvenido,</cfif>
	  <cfoutput>#session.datos_personales.nombre#
		#session.datos_personales.apellido1#
		#session.datos_personales.apellido2#</cfoutput> ! </td>
  </tr>
	<tr>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td colspan="4" style="font-size:14px ">
	  <p>Gracias por acceder el ambiente de operaci&oacute;n de <cfoutput>#session.CEnombre#</cfoutput>. Dentro de este entorno, usted tendr&aacute; acceso a una serie de servicios corporativos de acuerdo con el perfil que se le ha definido. </p>
	  </td>
	  
	  <td style="font-size:14px ">&nbsp;</td>
  </tr>
	<tr>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td colspan="4" style="font-size:14px ">&nbsp;</td>
	  <td style="font-size:14px ">&nbsp;</td>
  </tr>
	<tr>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td colspan="2" style="font-size:14px "><strong>Pregunta de identificaci&oacute;n personal. </strong></td>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td style="font-size:16px ">&nbsp;</td>
  </tr>
	<tr>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td colspan="2" style="font-size:14px ">&nbsp;</td>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td style="font-size:16px ">&nbsp;</td>
  </tr>
	<tr>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td colspan="2" style="font-size:14px ">Nuestros registros indican que usted a&uacute;n no ha registrado una pregunta personal de identificaci&oacute;n. <br>
	    Esta informaci&oacute;n es muy importante para usted en caso de que llegue a olvidar o perder su contrase&ntilde;a. 
Para actualizar su informaci&oacute;n ahora, haga clic en el bot&oacute;n de &quot;Actualizar datos&quot;. </td>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td style="font-size:16px ">&nbsp;</td>
  </tr>
	<tr>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td style="font-size:16px ">&nbsp;</td>
  </tr>
	<tr>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td style="font-size:14px ">Pregunta</td>
	  <td style="font-size:14px "><select name="pregunta" id="pregunta"style="font-size:14px ">
        <option>&iquest; Cu&aacute;l es mi n&uacute;mero de la suerte ?</option>
        <option>&iquest; C&oacute;mo se llama mi suegra ?</option>
        <option>&iquest; De qu&eacute; color fue mi primer auto ?</option>
        <option>&iquest; Cu&aacute;ntos hermanos tengo ?</option>
        <option selected>Nombre de mi mascota</option>
        <option>Segundo apellido de mi mam&aacute;</option>
      </select></td>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td style="font-size:16px ">&nbsp;</td>
  </tr>
	<tr>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td style="font-size:14px ">Respuesta</td>
	  <td style="font-size:14px "><input name="respuesta" type="text" value="" size="30" maxlength="60" style="font-size:14px "></td>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td style="font-size:16px ">&nbsp;</td>
  </tr>
	<tr>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td colspan="2" style="font-size:14px ">&nbsp;</td>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td style="font-size:16px ">&nbsp;</td>
  </tr>
	<tr>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td colspan="2" style="font-size:14px ">&nbsp;</td>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td style="font-size:16px ">&nbsp;</td>
  </tr>
	<tr>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td width="112" style="font-size:14px ">&nbsp;</td>
	  <td width="565" colspan="2" align="center" style="font-size:14px ">
      <input type="submit" value="Actualizar datos">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" value="Recordarme luego" onClick="javascript: mejorluego(this.form);"></td>
	  <td width="169" style="font-size:14px ">&nbsp;</td>
	  <td style="font-size:16px ">&nbsp;</td>
  </tr>
	<tr>
	  <td style="font-size:14px ">&nbsp;</td>
	  <td colspan="4" style="font-size:14px ">&nbsp;</td>
	  <td style="font-size:16px ">&nbsp;</td>
  </tr>
	<tr>
	  <td width="70" style="font-size:14px "><p>&nbsp;</p>
      </td>
      <td colspan="4" align="center" style="font-size:14px ">
      </td>
      <td width="70" style="font-size:16px ">&nbsp;</td>
  </tr>
	<tr>
	  <td colspan="6">&nbsp;</td>
  </tr>
	<tr>
	  <td colspan="6" align="justify">
	  
	  </td>
  </tr>
	<tr>
	  <td colspan="6">&nbsp;</td>
  </tr>
</table></form>
<cfinclude template="footer.cfm">
<script type="text/javascript">
<!--
	form1.respuesta.focus();
	function checkform(f){
		if (f.respuesta.value.match(/^\s*$/))
		{
			alert("Esta información es muy importante para nosotros \nen caso de que llegue a olvidar su contraseña.\n\nPor favor, indique su respuesta.");
			f.respuesta.focus();
			return false;
		}
		return true;
	}
	function mejorluego(f){
		if (confirm("Recuerde que esta información es muy importante para \nnosotros en caso de que llegue a olvidar su contraseña.\n\n\ Realmente desea ignorar este aviso?"))
		{
			location.href = 'index.cfm';
		} else {
			f.respuesta.focus();
		}
	}
//-->
</script>
</cf_templatearea>
</cf_template>