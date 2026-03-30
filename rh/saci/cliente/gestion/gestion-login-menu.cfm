<cfoutput>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="left" titulo="Cambiar">
		<script language="javascript" type="text/javascript">
			function goPage2(f, lpaso, pintaB) {
				if (f.cue.value == '' && lpaso != '1') {
					alert('Debe seleccionar una cuenta antes de continuar');
				} else {
					f.lpaso.value = lpaso;
					f.pintaBotones.value = pintaB;
					f.submit();
				}
			}
		</script>
		
		<form name="formCuadroOpt" action="#CurrentPage#" method="get" style="margin: 0;">
			<cfinclude template="gestion-hiddens.cfm">
			<table border="0" cellpadding="2" cellspacing="0" width="100%">
			  
			  <!--- 1 --->
			  <tr>
				<td width="1%" align="right"> <img src="/cfmx/saci/images/number1_16.gif" border="0"> </td>
				<td  nowrap>
					<a href="javascript: goPage2(document.formCuadroOpt, 1, 1);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
						<cfif Form.lpaso EQ 1><strong></cfif>Login<cfif Form.lpaso EQ 1></strong></cfif>
					</a>
				</td>
			  </tr>
	
			  <!--- 2 --->
			  <tr>
				<td align="right"><img src="/cfmx/saci/images/number2_16.gif" border="0"></td>
				<td  nowrap>
					<cfif ExisteLog>
					<a href="javascript: goPage2(document.formCuadroOpt, 2, 1);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
					</cfif>
						<cfif Form.lpaso EQ 2><strong></cfif>Tel&eacute;fono<cfif Form.lpaso EQ 2></strong></cfif>
					<cfif ExisteLog>
					</a>
					</cfif>
				</td>
			  </tr>
	
			  <!--- 3 --->
			  <tr>
				<td align="right"><img src="/cfmx/saci/images/number3_16.gif" border="0"></td>
				<td  nowrap>
					<cfif ExisteLog>
					<a href="javascript: goPage2(document.formCuadroOpt, 3, 1);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
					</cfif>
						<cfif Form.lpaso EQ 3><strong></cfif>Real Name<cfif Form.lpaso EQ 3></strong></cfif>
					<cfif ExisteLog>
					</a>
					</cfif>
				</td>
			  </tr>
			  
			  <!--- 4 --->
			  <tr>
				<td align="right"><img src="/cfmx/saci/images/number4_16.gif" border="0"></td>
				<td  nowrap>
					<cfif ExisteLog>
					<a href="javascript: goPage2(document.formCuadroOpt, 4, 1);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
					</cfif>
						<cfif Form.lpaso EQ 4><strong></cfif>Passwords<cfif Form.lpaso EQ 4></strong></cfif>
					<cfif ExisteLog>
					</a>
					</cfif>
				</td>
			  </tr>
			  
			  <!--- 5 --->
			  <tr>
				<td align="right"><img src="/cfmx/saci/images/number5_16.gif" border="0"></td>
				<td  nowrap>
					<cfif ExisteLog>
					<a href="javascript: goPage2(document.formCuadroOpt, 5, 1);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
					</cfif>
						<cfif Form.lpaso EQ 5><strong></cfif>Password Global<cfif Form.lpaso EQ 5></strong></cfif>
					<cfif ExisteLog>
					</a>
					</cfif>
				</td>
			  </tr>
			  
			   <!--- 6 --->
			  <tr>
				<td align="right"><img src="/cfmx/saci/images/number6_16.gif" border="0"></td>
				<td  nowrap>
					<cfif ExisteLog>
					<a href="javascript: goPage2(document.formCuadroOpt, 6, 1);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
					</cfif>
						<cfif Form.lpaso EQ 6><strong></cfif>Forwarding<cfif Form.lpaso EQ 6></strong></cfif>
					<cfif ExisteLog>
					</a>
					</cfif>
				</td>
			  </tr>
			  <!--- 7 --->
			  <tr><td colspan="2"> <hr /></td></tr>
				  <tr>
					<td align="right"><img src="/cfmx/saci/images/number7_16.gif" border="0"></td>
					<td  nowrap>
						<cfif ExisteLog>
						<a href="javascript: goPage2(document.formCuadroOpt, 8, 1);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
						</cfif>
							<cfif Form.lpaso EQ 8><strong></cfif>Bloqueo/Desbloqueo<cfif Form.lpaso EQ 8></strong></cfif>
						<cfif ExisteLog>
						</a>
						</cfif>
					</td>
				  </tr>
			  <tr>
				<td align="right"><img src="/cfmx/saci/images/number8_16.gif" border="0"></td>
				<td  nowrap>
					<cfif ExisteLog>
						<a href="javascript: goPage2(document.formCuadroOpt, 10, 0);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
					</cfif>
					<cfif Form.lpaso EQ 10><strong></cfif>
						Gestiones Realizadas
					<cfif Form.lpaso EQ 10></strong></cfif>
					<cfif ExisteLog>
						</a>
					</cfif>
				</td>
			  </tr>							  
			</table>
		</form>
	<cf_web_portlet_end>  
</cfoutput>
