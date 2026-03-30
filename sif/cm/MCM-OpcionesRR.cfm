<cfif ArrayLen(menu4) gt 0>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<cfloop from="1" to="#ArrayLen(menu4)#" index="i">
			<cfoutput>
			<tr>
				<td width="1%" align="right" valign="middle"><a href="/cfmx#menu4[i].uri#"><img src="../imagenes/16x16_flecha_right.gif" width="16" height="16" border="0"></a></td>
				<td align="left" valign="middle"><a href="/cfmx#menu4[i].uri#">#menu4[i].titulo#</a></td>
			</tr>
			<tr>
				<td colspan="2">
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="5%">&nbsp;</td>
								<td class="etiquetaProgreso">#menu4[i].descripcion#<br><br></td>
							</tr>
					</table>
				</td>
			</tr>
			</cfoutput>
		</cfloop>
	</table>
<cfelse>
	Usted No tiene acceso para realizar ninguna operaci&oacute;n en este M&oacute;dulo.
</cfif>

