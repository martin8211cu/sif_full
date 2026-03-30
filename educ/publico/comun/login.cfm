<!-- InstanceBegin template="/Templates/tUniv.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template >
	<cf_templatearea name="title">
	<!-- InstanceBeginEditable name="titulo" -->
		
		<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="left">
	<!--- Coloque #N/A# para que desaparezca la zona left: #N/A# = pantalla completa --->
	<!-- InstanceBeginEditable name="left" -->
			<cfinclude template="/home/menu/menu.cfm">
		<!-- InstanceEndEditable -->			
	</cf_templatearea>
	<cf_templatearea name="header">
	<link rel="stylesheet" type="text/css" href="/cfmx/educ/css/educ.css">
	<cf_templatecss>
	<!-- InstanceBeginEditable name="Encabezado" -->
		
		<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="body">
	<!-- InstanceBeginEditable name="cuerpo" -->
		<link href="/cfmx/home/public/login.css" rel="stylesheet" type="text/css">
		
		<script type="text/javascript" src="/cfmx/home/public/login.js">//</script>
		<cfinclude template="login-form.cfm">
	
	
	
	
<!---
		<table width="24%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC">
		  <tr>
		    <td valign="top">&nbsp;
			</td>
		    <td>
<table width="100%" border="0" align="left" cellpadding="0" cellspacing="0">
				  <tr>
					<td align="center" valign="middle">
						<table width="147" border="0" cellpadding="0" cellspacing="0" background="">
							<tr>
								<td width="100" height="73">
									<img src="images/inicioSession.gif" alt="" border="0">										
								</td>
							</tr>
					  </table>			
					</td>
				  </tr>
				  <tr>
					<td align="center" valign="middle">
						<cfif Len(GetAuthUser()) EQ 0>
							<form action="" method="post" id="form1">
								<table border="0" class="bar01" style="font-size: 12px;">
									<tr>
										<td width="77"><strong><font color="#000000" size="3">Usuario</font></strong></td>
										<td width="66"><input type="Text" name="j_username" size="11"></td>
									    <td width="23">&nbsp;</td>
									</tr>
									<tr>
									<td><strong><font color="#000000" size="3">Contrase&ntilde;a</font></strong></td>
									<td><input type="password" name="j_password" size="11"></td>
									<td><input name="image" type="image" src="images/b_login.gif" alt="" align="absbottom" width="79" border="0" 
													onMouseDown="this.src='images/b_loginb.gif'" 
													onMouseUp="this.src='images/b_login.gif'" 
													onMouseOver="this.src='images/b_logina.gif'" 
													onMouseOut="this.src='images/b_login.gif'">
									  </td>
									</tr>
									<tr>
									  <td colspan="3" align="center"></td>
									</tr>
								</table>
						  </form>
						    <font color="#000000">
						    <cfelse>
								<cfoutput>Bienvenido, <strong>#GetAuthUser()#</strong></cfoutput>
						    </font>
						</cfif>			
					</td>
				  </tr>
			  </table>			
			</td>
		  </tr>
	</table>
--->
	
		<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="right">
	<!-- InstanceBeginEditable name="right" -->

		<!-- InstanceEndEditable -->			
	</cf_templatearea>
</cf_template>
<!-- InstanceEnd -->