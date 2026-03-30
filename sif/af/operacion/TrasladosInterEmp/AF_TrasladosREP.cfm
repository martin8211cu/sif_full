<title> Listado Borrador de la Transacción</title>
<cfif  not isDefined("url.Formato")>
	<cfset url.Formato = "flashpaper">
</cfif>

 <table  id="tablabotones" width="100%" cellpadding="0" cellspacing="0" border="0" >
	<tr>
		<td align="right" nowrap>
			<form action="AF_TrasladosREP.cfm"  method="get" name="form1" id="form1">
				 <table  width="100%" cellpadding="0" cellspacing="0" border="0">
				 	<tr align="right" nowrap>
						<td align="left" width="10%" nowrap><strong>Formato:&nbsp;</strong></td>
						<td align="left" width="10%">
							<select name="Formato" id="Formato" tabindex="1">
								<option value="flashpaper" <cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato eq 'flashpaper'>selected</cfif>>FLASHPAPER</option>
								<option value="pdf" <cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato eq 'pdf'>selected</cfif>>PDF</option>
							</select>					  
						</td>
						<td width="80%">
							<input type="submit"  id="Generar" name="Generar"  value="Generar"  >					  
						</td>
					</tr>
				 </table>
				 <input name="AFMovsID" type="hidden" value="<cfoutput>#url.AFMovsID#</cfoutput>">
			</form>		
		</td>
	</tr>
	<tr>
		<td colspan="3" align="center">
		&nbsp;
		</td>
	</tr>
	<tr>
	  <td colspan="3" align="center">
	  				 <iframe 
					id="reporte" 
					name="reporte"
					marginwidth="0"
					marginheight="0"
					src="AF_TrasladosREP2.cfm?Formato=<cfoutput>#url.Formato#</cfoutput>&AFMovsID=<cfoutput>#url.AFMovsID#</cfoutput>" 
					frameborder="0" 
					width="810"  
					height="440"
					scrolling="yes"> 
				</iframe>
	  </td>
	</tr>
</table>

