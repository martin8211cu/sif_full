<title>Lista de Voucher con Errores</title>

<cfset msg = "El voucher fue previamente digitado en un documento">

<table width="100%"  cellpadding="0" cellspacing="0" border="0">	
	<tr>
		<td>
			<fieldset style="background-color:#F3F4F8;  border-top: 1px solid #CCCCCC; border-left: 1px solid #CCCCCC; border-right: 1px solid #CCCCCC; border-bottom: 1px solid #CCCCCC; ">
				<legend align="left" style="color:#003366;font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:small-caps; font-weight:bolder;">
				Lista de Vouchers
				</legend>				
				<table width="100%"  cellpadding="2" cellspacing="2" border="0">
					<tr>
						<td width="50%" ><strong>Tarjeta</strong></td>
						<td><strong>Autorizaci&oacute;n</strong></td>
					</tr>											
					<cfloop list="#url.AUTORIZACION#" delimiters="|" index="idx1" >
						<tr>
							<td width="50%" >&nbsp;&nbsp;<cfoutput>#url.TARJETA#</cfoutput></td>
							<td>&nbsp;&nbsp;<cfoutput>#idx1#</cfoutput></td>
						</tr>	
					</cfloop>
				</table>
			</fieldset>	
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td><strong>Error: </strong></td></tr>
	<tr><td>&nbsp;&nbsp;<cfoutput>#msg#</cfoutput></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td align="center"><input type="button" name="btncerrar" value="Cerrar" onClick="javascript:window.close();"></td></tr>
</table>



