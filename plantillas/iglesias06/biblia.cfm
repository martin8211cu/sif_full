<cfinclude template="/hosting/publico/ApplicationPublic.cfm">
<style type="text/css">
<!--
.style1 {font-family: Verdana, Arial, Helvetica, sans-serif}
.style3 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9px; }
.style5 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #006633;
	font-size: 16px;
}
.style6 {font-size: 12px}
-->
</style>
<cf_template>
	<cf_templatearea name="title"></cf_templatearea>
	<cf_templatearea name="header"><cfinclude template="pUbica.cfm"></cf_templatearea>
	<cf_templatearea name="left"></cf_templatearea>	
	<cf_templatearea name="body">
		<tr><td>
		<cfinclude template="bibliaconsform.cfm">
		</td></tr>
	</cf_templatearea>
</cf_template>
