<cfparam name="params_anotaciones" default="">
<cfoutput>
	<cf_web_portlet_start tituloalign="left" titulo="Opciones">
		<script language="javascript" type="text/javascript">
			function goPage(f, paso) {
				if (paso == 99) {
					f.paso.value = '1';
				} else {
					f.paso.value = paso;
				}
				f.submit();
			}
		</script>
		
		<form name="formCuadroOpt" action="#CurrentPage#" method="post" style="margin: 0;">
			<cfinclude template="u900-hiddens.cfm">
			<table border="0" cellpadding="2" cellspacing="0">
			  <!--- 1 --->
			  <tr>
				<td width="1%" align="right">
				  <cfif Form.paso EQ 1>
					<img src="/cfmx/saci/images/addressGo.gif" border="0">
				  <cfelse>
					&nbsp;
				  </cfif>
				</td>
				<td width="1%" align="right"> <img src="/cfmx/saci/images/number1_16.gif" border="0"> </td>
				<td  nowrap>
					<a href="javascript: goPage(document.formCuadroOpt, 1);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
						<cfif Form.paso EQ 1><strong></cfif>
						Bloquear
						<cfif Form.paso EQ 1></strong></cfif>
					</a>
				</td>
			  </tr>
			  <!--- 2 --->
			  <tr>
				<td width="1%" align="right">
				  <cfif Form.paso EQ 2>
					<img src="/cfmx/saci/images/addressGo.gif" border="0">
				  <cfelse>
					&nbsp;
				  </cfif>
				</td>
				<td align="right"><img src="/cfmx/saci/images/number2_16.gif" border="0"></td>
				<td  nowrap>
					<a href="javascript: goPage(document.formCuadroOpt, 2);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
						<cfif Form.paso EQ 2><strong></cfif>
							Desbloquear
						<cfif Form.paso EQ 2></strong></cfif>
					</a>
				</td>
			  </tr>
			  <!--- 3 --->
			  <tr>
				<td width="1%" align="right">
				  <cfif Form.paso EQ 3>
					<img src="/cfmx/saci/images/addressGo.gif" border="0">
				  <cfelse>
					&nbsp;
				  </cfif>
				</td>
				<td align="right"><img src="/cfmx/saci/images/number3_16.gif" border="0"></td>
				<td  nowrap>
					<a href="javascript: goPage(document.formCuadroOpt, 3);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
						<cfif Form.paso EQ 3><strong></cfif>Limitaci&oacute;n de Acceso<cfif Form.paso EQ 3></strong></cfif>
					</a>
				</td>
			  </tr>
			  <!--- 4 --->
			  <tr>
				<td width="1%" align="right">
				  <cfif Form.paso EQ 4>
					<img src="/cfmx/saci/images/addressGo.gif" border="0">
				  <cfelse>
					&nbsp;
				  </cfif>
				</td>
				<td align="right"><img src="/cfmx/saci/images/number4_16.gif" border="0"></td>
				<td  nowrap>
					<a href="javascript: goPage(document.formCuadroOpt, 4);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
						<cfif Form.paso EQ 4><strong></cfif>Bloqueo Masivo<cfif Form.paso EQ 4></strong></cfif>
					</a>
				</td>
			  </tr>			  
			</table>
		</form>
	<cf_web_portlet_end>  
</cfoutput>
