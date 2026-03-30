
<cfparam name="url.tab" default="1">
<cfif ListFind("1,2", url.tab) EQ 0><cfset url.tab = 1></cfif>

		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr><td valign="top"><cfinclude template="gruposOficinas-tabs.cfm"></td></tr>
		</table>

