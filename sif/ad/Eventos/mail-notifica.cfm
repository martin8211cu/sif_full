<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>#args.titulo#</title>
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

<cfoutput>
  <table border="0" cellpadding="4" cellspacing="0" style="border:2px solid ##999999; ">
    <tr bgcolor="##999999">
      <td colspan="2" height="8"></td>
    </tr>
    <tr bgcolor="##003399">
      <td colspan="2" height="24"></td>
    </tr>
    <tr bgcolor="##999999">
      <td colspan="2"> <strong>#args.titulo#</strong> </td>
    </tr>
    <tr>
      <td width="70">&nbsp;</td>
      <td width="476">&nbsp;</td>
    </tr>
    <tr>
      <td><span class="style2">De</span></td>
      <td><span class="style7">#args.remitente#</span></td>
    </tr>
    <tr>
      <td><span class="style7"><strong>Para</strong></span></td>
	  <td><span class="style7"> #args.datos_personales#</span></td>
    </tr>
    <tr>
      <td><span class="style8"></span></td>
      <td><span class="style8"></span></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td><span class="style7">#args.titulo2#</span></td>
    </tr>
    <tr><td colspan="2">&nbsp;</td></tr>
		<tr>
		  <td><span class="style8"></span></td>
		  <td><span class="style7">
				<table border="0" cellpadding="4" cellspacing="0" style="border:2px solid ##999999; ">
					<tr>
						<td>Activo:
						</td>
						<td>#args.Activo#
						</td>
					</tr>
					<tr>
						<td>Responsable:
						</td>
						<td>#args.Responsable#
						</td>
					</tr>
					<tr>
						<td>Categoria/Clase:
						</td>
						<td>#args.CategoriaClase#
						</td>
					</tr>
				</table>
		  </span></td>
		</tr>
		<tr>
		  <td><span class="style8"></span></td>
		  <td>
		  		<span class="style7">#args.info#</span><BR>
		  		<span class="style7">Justificación: #args.justificacion#</span>
		  </td>
		</tr>	

    <tr>
      <td><span class="style8"></span></td>
      <td><span class="style8"></span></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>
	  	<span class="style1">
		Nota: En #args.hostname# respetamos su privacidad. <br>
      	Si usted considera que este correo le llegó por equivocación, 
		o si no desea recibir más información de nosotros, haga click 
		<a href="http://#args.hostname#/cfmx/home/public/optout.cfm">aquí</a>. </span></td>
    </tr>
  </table>
</cfoutput>
</body>
</html>
