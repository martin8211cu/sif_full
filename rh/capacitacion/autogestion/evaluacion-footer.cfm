		</fieldset>
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="center" valign="top">
		<cfoutput>
			<cfif isdefined("form.RHRCid") and len(form.RHRCid)>
				<cfset action = CurrentPage>
			<cfelse>
				<cfset action = "../../autogestion/plantilla/menu.cfm">
			</cfif>
			<form action="#action#" method="post" name="formNav99">
				<cfif isdefined("form.RHRCid") and len(form.RHRCid)
					and isdefined("form.DEid") and len(form.DEid)>
					<input type="hidden" name="RHRCid" value="#form.RHRCid#">
				</cfif>				
				<input type="submit" name="Regresar" value="Regresar">
			</form>
		</cfoutput>
	</td>
  </tr>
</table>
