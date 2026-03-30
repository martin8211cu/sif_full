<cf_template>
<cf_templatearea name="body">

<cf_web_portlet titulo="Agenda">

	<cfinclude template="/home/menu/pNavegacion.cfm">
	<cfoutput>
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td><cfinclude template="agenda.cfm"></td></tr>
		</table>
	</cfoutput>
</cf_web_portlet>

</cf_templatearea>
</cf_template>