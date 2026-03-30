<cfoutput>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Pasos'>
		<script language="javascript" type="text/javascript">
			function goPage(f, paso) {
				if (paso != 99) {
					f.paso.value = paso;
				} else {
					f.RHASid.value = '';
					f.paso.value = '1';
				}
				f.submit();
			}
		</script>
		
		<form name="formProgreso" action="#CurrentPage#" method="post" style="margin: 0;">
			<cfinclude template="analisis-salarial-hiddens.cfm">
			<table border="0" cellpadding="2" cellspacing="0">
			  
			  <!--- 0 --->
			  <tr>
				<td style="border-bottom: 1px solid black; ">
				  <cfif Form.paso EQ 0>
					<img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
				  <cfelse>
					&nbsp;
				  </cfif>
				</td>
				<td align="center" style="border-bottom: 1px solid black; "> <img src="/cfmx/rh/imagenes/home.gif" border="0"> </td>
				<td class="etiquetaProgreso" style="border-bottom: 1px solid black; " nowrap>
					<a href="javascript: goPage(document.formProgreso, 0);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
						<strong>Lista de Reportes</strong>
					</a>
				</td>
			  </tr>
	
			  <!--- 1 --->
			  <tr>
				<td width="1%" align="right">
				  <cfif Form.paso GT 1>
					<img src="/cfmx/rh/imagenes/w-check.gif" border="0">
				  <cfelseif Form.paso EQ 1>
					<img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
				  </cfif>
				</td>
				<td width="1%" align="right"> <img src="/cfmx/rh/imagenes/number1_16.gif" border="0"> </td>
				<td class="etiquetaProgreso" nowrap>
					<a href="javascript: goPage(document.formProgreso, 1);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
						Seleccionar Encuesta
					</a>
				</td>
			  </tr>
	
			  <!--- 2 --->
			  <tr>
				<td width="1%" align="right">
				  <cfif Form.paso GT 2>
					<img src="/cfmx/rh/imagenes/w-check.gif" border="0">
				  <cfelseif Form.paso EQ 2>
					<img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
				  </cfif>
				</td>
				<td align="right"><img src="/cfmx/rh/imagenes/number2_16.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap>
					<cfif modo EQ "CAMBIO">
					<a href="javascript: goPage(document.formProgreso, 2);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
					</cfif>
						Incluir Conceptos de Pago
					<cfif modo EQ "CAMBIO">
					</a>
					</cfif>
				</td>
			  </tr>
	
			  <!--- 3 --->
			  <tr>
				<td width="1%" align="right">
				  <cfif Form.paso GT 3>
					<img src="/cfmx/rh/imagenes/w-check.gif" border="0">
				  <cfelseif Form.paso EQ 3>
					<img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
				  </cfif>
				</td>
				<td align="right"><img src="/cfmx/rh/imagenes/number3_16.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap>
					<cfif modo EQ "CAMBIO">
					<a href="javascript: goPage(document.formProgreso, 3);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
					</cfif>
						Asignar Puestos
					<cfif modo EQ "CAMBIO">
					</a>
					</cfif>
				</td>
			  </tr>
	
			  <!--- 4 --->
			  <tr>
				<td width="1%" align="right">
				  <cfif Form.paso GT 4>
					<img src="/cfmx/rh/imagenes/w-check.gif" border="0">
				  <cfelseif Form.paso EQ 4>
					<img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
				  </cfif>
				</td>
				<td align="right"><img src="/cfmx/rh/imagenes/number4_16.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap>
					<cfif modo EQ "CAMBIO">
					<a href="javascript: goPage(document.formProgreso, 4);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
					</cfif>
						Asignar Unidad de Negocio
					<cfif modo EQ "CAMBIO">
					</a>
					</cfif>
				</td>
			  </tr>

			  <!--- 5 --->
			  <tr>
				<td width="1%" align="right">
				  <cfif Form.paso GT 5>
					<img src="/cfmx/rh/imagenes/w-check.gif" border="0">
				  <cfelseif Form.paso EQ 5>
					<img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
				  </cfif>
				</td>
				<td align="right"><img src="/cfmx/rh/imagenes/number5_16.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap>
					<cfif modo EQ "CAMBIO">
					<a href="javascript: goPage(document.formProgreso, 5);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
					</cfif>
						Generar Reporte
					<cfif modo EQ "CAMBIO">
					</a>
					</cfif>
				</td>
			  </tr>
				
			  <!--- Nuevo --->
			  <tr>
				<td style="border-top: 1px solid black; ">&nbsp;</td>
				<td align="center" style="border-top: 1px solid black; "> <img src="/cfmx/rh/imagenes/file.png" border="0"> </td>
				<td class="etiquetaProgreso" style="border-top: 1px solid black; " nowrap><a href="javascript: goPage(document.formProgreso, 99);" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">Nuevo Reporte</a></td>
			  </tr>
			</table>
		</form>
	<cf_web_portlet_end> 
</cfoutput>
