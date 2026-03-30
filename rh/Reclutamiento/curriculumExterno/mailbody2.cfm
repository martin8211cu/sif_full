<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Envío de contraseñas</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.style1 {
	font-size: 10px;
	font-family: "Times New Roman", Times, serif;
}
.style2 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-weight: bold;
	font-size: 14;
}
.style7 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14; }
.style8 {font-size: 14}
-->
</style>
</head>
<body>
<cfparam name="hostname" default="localhost">
<cfparam name="_password" default="">
<cfoutput>
  <table border="0" cellpadding="4" cellspacing="0" style="border:2px solid ##999999; ">
    <tr bgcolor="##999999">
      <td colspan="2" height="8"></td>
    </tr>
    <tr bgcolor="##003399">
      <td colspan="2" height="24"></td>
    </tr>
    <tr bgcolor="##999999">
      <td colspan="2"><strong>Información de acceso a http://#hostname#</strong> </td>
    </tr>
    <tr>
      <td width="70">&nbsp;</td>
      <td width="476">&nbsp;</td>
    </tr>
    <tr>
      <td><span class="style2">De</span></td>
      <td><span class="style7"> Administrador de http://#hostname#</span></td>
    </tr>
    <tr>
      <td><span class="style7"><strong>Para</strong></span></td>
      <td><span class="style7"> #RS_user_datos_personales.RHOnombre# #RS_user_datos_personales.RHOapellido1# #RS_user_datos_personales.RHOapellido2# </span></td>
    </tr>
    <tr>
      <td><span class="style8"></span></td>
      <td><span class="style8"></span></td>
    </tr>
    <tr>
      <td><span class="style8"></span></td>
      <td><span class="style7"> &iexcl; Bienvenido  al sistema  http://#hostname# !</span></td>
    </tr>
    <tr>
      <td><span class="style8"></span></td>
      <td><span class="style8"></span></td>
    </tr>
    <tr>
      <td><span class="style8"></span></td>
      <td><span class="style7">Se ha creado un  nuevo usuario en la aplicaci&oacute;n con la siguiente informaci&oacute;n </span></td>
    </tr>
    <tr>
      <td><span class="style8"></span></td>
      <td><table border="0">
          <tr>
            <td class="style7"><strong>Usuario:</strong></td>
            <td class="style7">&nbsp;&nbsp;&nbsp;</td>
            <td class="style7"><code>#Form.Correo#</code></td>
          </tr>
          <tr>
            <td class="style7"><strong>Contraseña:</strong></td>
            <td class="style7">&nbsp;</td>
            <td class="style7"><code>#_password#</code></td>
          </tr>
		  
      </table></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>

     <tr>
    <td><span class="style8"></span></td>
    <td><span class="style7">antes de acceder a la aplicaci&oacute;n, es necesario autorizar el usuario. <a href="http://#hostname#/cfmx/rh/Reclutamiento/curriculumExterno/index.cfm?authentication=#authentication#">http://#hostname#/cfmx/rh/Reclutamiento/curriculumExterno/index.cfm?authentication=#authentication#</a> </span></td>
  </tr> 	
    <tr>
      <td><span class="style8"></span></td>
      <td><span class="style8"></span></td>
    </tr>
  </table>
  <br>

<br>
<br>
<br>
</cfoutput>
</body>
</html>
