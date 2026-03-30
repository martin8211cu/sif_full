<cfoutput>
<form name="form2" action="" method="post">
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr >
			<td >
				<table width="100%" border="0" class="navbar">
					<tr><td>  
						<table width="50" border="0" >				  
							<input type="hidden" name="RHSAid" value=""><!---- Detalle seleccionada de la lista ---->
							<input type="hidden" name="RHEid" value="<cfif isdefined("form.RHEid") and len(trim(form.RHEid))>#form.RHEid#</cfif>">	<!---Llave del escenario de la lista--->
							<input type="hidden" name="RHEfdesde" value="<cfif isdefined("data") and len(trim(data.RHEfdesde))>#data.RHEfdesde#</cfif>"><!---- Fecha desde del escenario seleccionado---->
							<input type="hidden" name="RHEfhasta" value="<cfif isdefined("data") and len(trim(data.RHEfhasta))>#data.RHEfhasta#</cfif>"><!---- Fecha hasta del escenario seleccionado---->
							  <tr>
								<td width="1%">&nbsp;</td>
								<td width="99%" id="nav_plazas" nowrap><a href="##">Cargas Patronales</a></td>
							  </tr>				  
						</table>		
					</td></tr>
				</table>							  		
			</td>
		</tr>
		<tr><td valign="top">
			<cfoutput>
				<iframe id="CargasP" frameborder="0" name="CargasP" width="950"  height="300" style="visibility:visible;border:none; vertical-align:top" src="SA-CargasPatronales.cfm?RHEid=#form.RHEid#"></iframe>
			</cfoutput>	
		</td></tr>	
	</table>
</form>	
</cfoutput>

