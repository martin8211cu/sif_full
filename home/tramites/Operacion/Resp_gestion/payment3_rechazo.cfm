<cfparam name="url.importe_pago" type="numeric" default="45">
<cfparam name="url.moneda_pago" type="string" default="USR">
<cfparam name="url.id_tarjeta" type="numeric" default="0">
<cfparam name="url.msg" type="string" default="Denegada">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Transacci&oacute;n denegada</title>
<cf_templatecss>
</head>
<body style="border:0;margin:0 ">

	<cfoutput>
	<table width="98%" align="center" style="border-top-width:1px; border-top-style:solid; border-top-color:##999999; border-left-width:1px; border-left-style:solid; border-left-color:##999999; border-right-width:1px; border-right-style:solid; border-right-color:##999999; border-bottom-width:1px; border-bottom-style:solid; border-bottom-color:##999999;">
		<tr>
		  <td align="center">
			<b><font size="+1">La transacci&oacute;n   ha sido denegada .</font></b><br>		    
			Su pago no se ha podido procesar debido a que la autorizaci&oacute;n de la tarjeta que nos proporcion&oacute; fue denegada. <br>
			Importe de la transacci&oacute;n: #LSNumberFormat(url.importe_pago,',9.00')# #url.moneda_pago#</td>
		</tr>
		<tr>
		  <td align="center"><b><font color="red">&quot;#HTMLEditFormat(url.msg)#&quot;</font></b></td>
		</tr>

		<tr><td align="center">
			<table border="0" width="50%" align="center" cellpadding="3" cellspacing="3" >
				<tr>
				  <td colspan="2" align="left"><cf_tarjeta action="display" key="#url.id_tarjeta#">&nbsp;</td>
			  </tr>
			</table>
		</td></tr>

		<tr>
		  <td align="center" nowrap><b><font size="1">Seg&uacute;n cual sea el mensaje de error, podr&iacute;a intentar de nuevo en un momento.</font></b></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td align="center"><input type="button" name="regresar" value="Reintentar" onClick="history.go(-1)"></td></tr>
		<tr><td>&nbsp;</td></tr>
	</table>
	</cfoutput>

</body>
</html>
