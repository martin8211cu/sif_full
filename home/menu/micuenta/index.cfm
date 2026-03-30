<cf_templateheader>
<cfparam name="url.tab" default="3">
<cfif ListFind("1,2,3,4,5,6", url.tab) EQ 0><cfset url.tab = 3></cfif>
<cf_web_portlet_start>
	<table width="90%" class="Container" cellpadding="0" cellspacing="0" border="0" align="center">
		<tr><td valign="top"><cfinclude template="left.cfm"></td></tr>
	</table>
<cf_web_portlet_end>