
<style type="text/css">
<!--
.tabTitle {
	font-family: sans-serif;
	font-size: 12px;
	font-weight:bold;
	color: #fff;
	background-color:#6699CC;
	cursor: pointer;
}
.tabTitleBlue {
	background-image:url(images/tab_blue.gif);
	background-color:#6699CC;
}
.tabTitleGray {
	background-image:url(images/tab_gray.gif);
	background-color:#A1BAD0;
}
-->
</style>
<script type="text/javascript">
<!--
	<cfoutput>
	function setTab(n) {
		location.href='producto.cfm?id_producto=#URLEncodedFormat(url.id_producto)#&tabnumber=' + n;
	}
	</cfoutput>
//-->
</script>
<table width="800" border="0" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF">
  <tr>
    <td height="19" colspan="6" align="center" valign="middle">&nbsp;</td>
  </tr>
  <tr>
    <td width="126" height="24" align="center" valign="middle" onClick="setTab(1)"
		class="tabTitle <cfif url.tabnumber is 1>tabTitleBlue<cfelse>tabTitleGray</cfif>">B&aacute;sico<br>    </td>
    <td width="12" align="center" valign="middle" class="">&nbsp;</td>
    <td width="126" align="center" valign="middle" onClick="setTab(2)"
		class="tabTitle <cfif url.tabnumber is 2>tabTitleBlue<cfelse>tabTitleGray</cfif>">Presentaciones</td>
    <td width="12" align="center" valign="middle" class="">&nbsp;</td>
    <td width="126" align="center" valign="middle" onClick="setTab(3)"
		class="tabTitle <cfif url.tabnumber is 3>tabTitleBlue<cfelse>tabTitleGray</cfif>">Im&aacute;genes</td>
    <td width="" align="center" valign="middle">&nbsp;</td>
  </tr>
  <tr bgcolor="#6699CC">
    <td height="19" colspan="6" align="center" valign="bottom">&nbsp;</td>
  </tr>
</table>
