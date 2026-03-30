<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Otras Opciones">
	<!---Pintado de las opciones--->
	<table border="0" cellpadding="2" cellspacing="0">
			<cfoutput query="rsOtrosOrd">
				<tr>	
					<td width="1%" align="right" class="etiquetaProgreso"  valign="middle">
						<div align="right"> 
							<a href="#rsOtrosOrd.Link#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a> 
						</div>
					</td>
					<td width="99%" align="left" valign="middle" nowrap class="etiquetaProgreso" title="#rsOtrosOrd.LDescripcion#">
						<a href="#rsOtrosOrd.Link#">#rsOtrosOrd.LTitulo#</a>
					</td>
				</tr>
			</cfoutput>
	</table>
<cf_web_portlet_end>
