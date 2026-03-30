<cfoutput>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="left" titulo="Paquete">
		<script language="javascript" type="text/javascript">
			function goPage2(f, ppaso) {
				if (f.cue.value == '' && ppaso != '1') {
					alert('Debe seleccionar una cuenta antes de continuar');
				} else {
					
					if (ppaso == '4') {	<!---Limpia el id de contacto en caso de que exista alguno--->
						f.pqc.value = "";
					}
				
					f.ppaso.value = ppaso;
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
					<a href="javascript: goPage2(document.formCuadroOpt, 1);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
						<cfif Form.ppaso EQ 1><strong></cfif>Datos<cfif Form.ppaso EQ 1></strong></cfif>
					</a>
				</td>
			  </tr>
	
			  <!--- 2 --->
			  <tr>
				<td align="right"><img src="/cfmx/saci/images/number2_16.gif" border="0"></td>
				<td  nowrap>
					<cfif ExisteCuenta>
					<a href="javascript: goPage2(document.formCuadroOpt, 2);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
					</cfif>
						<cfif Form.ppaso EQ 2><strong></cfif>Cambio de Paquete<cfif Form.ppaso EQ 2></strong></cfif>
					<cfif ExisteCuenta>
					</a>
					</cfif>
				</td>
			  </tr>
	
			  <!--- 3 --->
			  <tr>
				<td align="right"><img src="/cfmx/saci/images/number3_16.gif" border="0"></td>
				<td  nowrap>
					<cfif ExisteCuenta>
					<a href="javascript: goPage2(document.formCuadroOpt, 3);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
					</cfif>
						<cfif Form.ppaso EQ 3><strong></cfif>Retiro de Servicio<cfif Form.ppaso EQ 3></strong></cfif>
					<cfif ExisteCuenta>
					</a>
					</cfif>
				</td>
			  </tr>
			</table>
		</form>
	<cf_web_portlet_end>  
</cfoutput>
