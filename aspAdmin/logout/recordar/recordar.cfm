<html>
<head>
<title>Recordar Contrase&ntilde;a</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../css/sif.css" rel="stylesheet" type="text/css">
</head>

<body>
	<p>&nbsp;</p>
	<p>&nbsp;</p>
	<cfset contIntentos = 0>
	<cfif isdefined('form.retry') and form.retry GT 0>
		<cfset contIntentos = form.retry>
	</cfif>

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
			<cfif contIntentos GT 2>
				<form name="form1" method="post" action="/cfmx/sif/">
					<table width="50%" align="center" border="0" cellspacing="0" cellpadding="0">	  	
					  <tr>
						<td width="100%">
							<cf_web_portlet border="true" skin="ocean" tituloalign="center" titulo="Contrase&ntilde;a Enviada">
								<table align="center" width="90%" border="0" cellspacing="0" cellpadding="0">
								  <tr>
									<td>&nbsp;</td>
								  </tr>					
								  <tr>
									<td class="etiqueta">
										<p>Sus 2 intentos por ingresar la respuesta correcta han finalizado.</p>
									</td>
								  </tr>
								  <tr>
									<td>&nbsp;</td>
								  </tr>					
								</table>
							</cf_web_portlet>		
						</td>
					  </tr>
					  <tr>
						<td>&nbsp;</td>
					  </tr>
					  <tr>
						<td align="center"><input name="btnIniciarSesion" type="submit" id="btnIniciarSesion" value="Iniciar Sesi&oacute;n"></td>
					  </tr>	  	  
					</table>
				</form>	
			<cfelse>
				<cf_web_portlet border="true" skin="ocean" tituloalign="center" titulo="Problemas inci&aacute;ndo la sesi&oacute;n">
					<table align="center" width="90%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td>&nbsp;</td>
					  </tr>					
					  <tr>
						<td class="etiqueta">
							&iquest;Olvid&oacute; su contrase&ntilde;a? Si es as&iacute;, llene este
							formulario para obtener estos datos nuevamente.<br>
							Deber&aacute; responder a una pregunta personal antes de poder obtener
							su	contrase&ntilde;a, la cual le ser&aacute; enviada por correo electr&oacute;nico.					
						</td>
					  </tr>
					  <tr>
						<td>&nbsp;</td>
					  </tr>
					  <cfif isdefined('form.error') and form.error NEQ ''>
						  <tr>
							<td><strong><font color="#FF0000"><cfoutput>!! #form.error#</cfoutput></font></strong></td>
						  </tr>
						  <tr>
							<td>&nbsp;</td>
						  </tr>					  				  					
					  </cfif>
					</table>
				</cf_web_portlet>				
			</cfif>
		</td>
	  </tr>
	</table>
    <p>&nbsp;</p>	

	
	<cfif contIntentos LT 3>
		<script src="/cfmx/sif/js/qForms/qforms.js"></script>	
		<form name="form1" method="post" action="SQLrecordar.cfm">
			<cfoutput>
				<table width="50%" align="center" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td>
						<cf_web_portlet border="true" skin="ocean" tituloalign="center" titulo="&iquest; Olvid&oacute; su contrase&ntilde;a ?">
							<table align="center" width="90%" border="0" cellspacing="0" cellpadding="0">
							  <tr>
								<td width="42%">&nbsp;</td>
								<td width="58%">&nbsp;</td>
							  </tr>					
							  <tr>
								<td width="42%">Digite su usuario:</td>
								<td width="58%">
									<cfif isdefined('form.login') and form.login NEQ ''>
										<strong>#form.login#</strong>
									<cfelse>
										<input name="login" type="text" id="login" size="30" value="<cfif isdefined('form.login') and form.login NEQ ''>#form.login#</cfif>">
									</cfif>
									
								</td>
							  </tr>
							  <tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							  </tr>
							  <cfif isdefined('form.login') and form.login NEQ ''>
								  <tr>
									<td colspan="2">Por favor, responda a la siguiente pregunta con la misma
									  respuesta que suministr&oacute; cuando ingres&oacute; al portal por
									  primera vez.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
									<td>
								  </tr>
								  <tr>
									<td colspan="2"><td>
								  </tr>							  
								  <tr>
									<td>
										<cfif isdefined('form.pregunta') and form.pregunta NEQ ''>#form.pregunta#<cfelse>&nbsp;</cfif></td>
									<td>
										<input name="respuesta" type="text" id="respuesta" size="30">								
										<input type="hidden" name="retry" value="<cfif isdefined('form.retry') and form.retry NEQ ''>#form.retry#</cfif>">
										<input type="hidden" name="login" value="<cfif isdefined('form.login') and form.login NEQ ''>#form.login#</cfif>">
									</td>
								  </tr>							  
							  <cfelse>
								  <tr>
									<td>&nbsp;</td>
									<td>Por ejemplo: <strong>dmontero</strong> o <strong>rmata</strong> </td>
								  </tr>
								<input type="hidden" name="retry" value="0">							  
							  </cfif>					  
							  <tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							  </tr>
							  <tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							  </tr>						  					  
							  <tr>
								<td colspan="2" align="center"><input name="btnCancelar" type="button" id="btnCancelar" value="Cancelar" onClick="location.href='/cfmx/sif/'">
								<input name="btnContinuar" type="submit" id="btnContinuar" value="Continuar &gt;"></td>
							  </tr>
							  <tr>
								<td width="42%">&nbsp;</td>
								<td width="58%">&nbsp;</td>
							  </tr>					  
							</table>
						</cf_web_portlet>		
					</td>
				  </tr>
				</table>	
			</cfoutput>			
		</form>
		
		<script language="JavaScript1.2" type="text/javascript">
			<!--//
			// specify the path where the "/qforms/" subfolder is located
			qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
			// loads all default libraries
			qFormAPI.include("*");
			//-->
		
			qFormAPI.errorColor = "#FFFFCC";
			objForm = new qForm("form1");
			<cfif isdefined('form.login') and form.login NEQ ''>
				objForm.respuesta.required    = true;
				objForm.respuesta.description = "Respuesta de la pregunta";
			<cfelse>
				objForm.login.required    = true;
				objForm.login.description = "Usuario";		
			</cfif>
		</script>
	
	</cfif>
	
</body>
</html>
