<cfoutput>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="left" titulo="Cambiar">
		<script language="javascript" type="text/javascript">
			function goPage2(f, paso) {
				if (f.cue.value == '' && paso != '1') {
					alert('Debe seleccionar una cuenta antes de continuar');
				} else {
					f.paso.value = paso;
					f.submit();
				}
			}
		</script>
		
		<form name="formCuadroOpt" action="#CurrentPage#" method="get" style="margin: 0;">
			<cfinclude template="gestion-hiddens.cfm">
			<table border="0" cellpadding="2" cellspacing="0" width="100%">
			  
			  <!--- 1 --->
			  <tr>
				<td width="1%" align="right">
				  <cfif Form.paso GT 1>
					<img src="/cfmx/saci/images/w-check.gif" border="0">
				  <cfelseif Form.paso EQ 1>
					<img src="/cfmx/saci/images/addressGo.gif" border="0">
				  <cfelse>
					&nbsp;
				  </cfif>
				</td>
				<td width="1%" align="right"> <img src="/cfmx/saci/images/number1_16.gif" border="0"> </td>
				<td  nowrap>
					<a href="javascript: goPage2(document.formCuadroOpt, 1);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
						<cfif Form.paso EQ 1><strong></cfif>Login<cfif Form.paso EQ 1></strong></cfif>
					</a>
				</td>
			  </tr>
	
			  <!--- 2 --->
			  <tr>
				<td width="1%" align="right">
				  <cfif Form.paso GT 2>
					<img src="/cfmx/saci/images/w-check.gif" border="0">
				  <cfelseif Form.paso EQ 2>
					<img src="/cfmx/saci/images/addressGo.gif" border="0">
				  <cfelse>
					&nbsp;
				  </cfif>
				</td>
				<td align="right"><img src="/cfmx/saci/images/number2_16.gif" border="0"></td>
				<td  nowrap>
					<cfif ExisteLog>
					<a href="javascript: goPage2(document.formCuadroOpt, 2);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
					</cfif>
						<cfif Form.paso EQ 2><strong></cfif>Tel&eacute;fono<cfif Form.paso EQ 2></strong></cfif>
					<cfif ExisteLog>
					</a>
					</cfif>
				</td>
			  </tr>
	
			  <!--- 3 --->
			  <tr>
				<td width="1%" align="right">
				  <cfif Form.paso GT 3>
					<img src="/cfmx/saci/images/w-check.gif" border="0">
				  <cfelseif Form.paso EQ 3>
					<img src="/cfmx/saci/images/addressGo.gif" border="0">
				  <cfelse>
					&nbsp;
				  </cfif>
				</td>
				<td align="right"><img src="/cfmx/saci/images/number3_16.gif" border="0"></td>
				<td  nowrap>
					<cfif ExisteLog>
					<a href="javascript: goPage2(document.formCuadroOpt, 3);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
					</cfif>
						<cfif Form.paso EQ 3><strong></cfif>Real Name<cfif Form.paso EQ 3></strong></cfif>
					<cfif ExisteLog>
					</a>
					</cfif>
				</td>
			  </tr>
			  
			  <!--- 4 --->
			  <tr>
				<td width="1%" align="right">
				  <cfif Form.paso GT 4>
					<img src="/cfmx/saci/images/w-check.gif" border="0">
				  <cfelseif Form.paso EQ 4>
					<img src="/cfmx/saci/images/addressGo.gif" border="0">
				  <cfelse>
					&nbsp;
				  </cfif>
				</td>
				<td align="right"><img src="/cfmx/saci/images/number4_16.gif" border="0"></td>
				<td  nowrap>
					<cfif ExisteLog>
					<a href="javascript: goPage2(document.formCuadroOpt, 4);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
					</cfif>
						<cfif Form.paso EQ 4><strong></cfif>Passwords<cfif Form.paso EQ 4></strong></cfif>
					<cfif ExisteLog>
					</a>
					</cfif>
				</td>
			  </tr>
			  
			  <!--- 5 --->
			  <tr>
				<td width="1%" align="right">
				  <cfif Form.paso GT 5>
					<img src="/cfmx/saci/images/w-check.gif" border="0">
				  <cfelseif Form.paso EQ 5>
					<img src="/cfmx/saci/images/addressGo.gif" border="0">
				  <cfelse>
					&nbsp;
				  </cfif>
				</td>
				<td align="right"><img src="/cfmx/saci/images/number5_16.gif" border="0"></td>
				<td  nowrap>
					<cfif ExisteLog>
					<a href="javascript: goPage2(document.formCuadroOpt, 5);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
					</cfif>
						<cfif Form.paso EQ 5><strong></cfif>Password Global<cfif Form.paso EQ 5></strong></cfif>
					<cfif ExisteLog>
					</a>
					</cfif>
				</td>
			  </tr>
			  
			   <!--- 6 --->
			  <tr>
				<td width="1%" align="right">
				  <cfif Form.paso GT 6>
					<img src="/cfmx/saci/images/w-check.gif" border="0">
				  <cfelseif Form.paso EQ 6>
					<img src="/cfmx/saci/images/addressGo.gif" border="0">
				  <cfelse>
					&nbsp;
				  </cfif>
				</td>
				<td align="right"><img src="/cfmx/saci/images/number6_16.gif" border="0"></td>
				<td  nowrap>
					<cfif ExisteLog>
					<a href="javascript: goPage2(document.formCuadroOpt, 6);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
					</cfif>
						<cfif Form.paso EQ 6><strong></cfif>Forwarding<cfif Form.paso EQ 6></strong></cfif>
					<cfif ExisteLog>
					</a>
					</cfif>
				</td>
			  </tr>
			  
			</table>
		</form>
	<cf_web_portlet_end> 
</cfoutput>
