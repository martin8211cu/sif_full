<cfinclude template="/hosting/publico/ApplicationPublic.cfm">
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
  	<td>
		<cf_template>
			<cf_templatearea name="title"><cfoutput>La Bíblia en Línea</cfoutput></cf_templatearea>
			<cf_templatearea name="left"><cfinclude template="pMenu.cfm"></cf_templatearea>	
			<cf_templatearea name="body">
				<tr><td>
					<cfinclude template="bibliaconsform.cfm">
				</td></tr>
			</cf_templatearea>
		</cf_template>
	</td>
  </tr>
</table>
