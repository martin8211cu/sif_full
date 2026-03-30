<html>
<head>
<title>Recordar Contrase&ntilde;a</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>
	<p>&nbsp;</p>
	<p>&nbsp;</p>
    <form name="form1" method="post" action="/cfmx/home/">
		<table width="50%" align="center" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td width="28%">&nbsp;</td>
			<td width="72%" align="right"><a href="/cfmx/sif/">iniciar sesi&oacute;n</a></td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
			<td><hr></td>
		  </tr>
		  <tr>
			<td colspan="2">&nbsp;</td>
		  </tr>	  	
		  <tr>
			<td colspan="2">
				<cf_web_portlet border="true" skin="ocean" tituloalign="center" titulo="Problemas iniciando la sesi&oacute;n">
					<table align="center" width="90%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td>&nbsp;</td>
					  </tr>					
					  <tr>
						<td class="etiqueta">
							<p>Su usuario <strong><c:out value="${param.login}" /> </strong> tiene
							  problemas para recuperar la contrase&ntilde;a, y es posible que haya
							  sido bloqueado. Por favor cont&aacute;ctenos para desbloquear su usuario
							  y poderle brindar una contrase&ntilde;a v&aacute;lida.</p>
							<p>Lamentamos los inconvenientes que esto le pueda causar.</p></td>
					  </tr>
					  <tr>
						<td>&nbsp;</td>
					  </tr>					
					</table>
				</cf_web_portlet>		
			</td>
		  </tr>
		  <tr>
			<td colspan="2">&nbsp;</td>
		  </tr>
		  <tr>
			<td colspan="2" align="center"><input name="btnIniciarSesion" type="submit" id="btnIniciarSesion" value="Regresar"></td>
		  </tr>	  	  
		</table>
    </form>
</body>
</html>
