<cfinclude template="/home/menu/navegacion.cfm">
<cfexit>
<cfoutput>
	<cfif not isdefined("titulo") >
		<cfset titulo = "Ultimo Nivel">
	</cfif>
<!---
	<table width="100%" border="0" cellpadding="4" cellspacing="0" class="areaMenu">
	  <tr align="left"> 
		<td nowrap><a href="#Session.JSroot#/admin/menuAdmin.cfm" tabindex="-1">Men&uacute; Principal</a></td>
		<td><img src="#Session.JSroot#/imagenes/subcat_arrow.gif" border="0"></td>
		<cfif isdefined("navBarItems")>
			<cfloop index="i" from="1" to="#ArrayLen(navBarItems)#">
			<cfoutput>
				<td nowrap>
					<cfif isdefined("navBarLinks") and navBarLinks[i] neq ""><a href="#navBarLinks[i]#" <cfif isdefined("navBarStatusText")> onMouseOver="javascript: window.status='#navBarStatusText[i]#'; return true;" onMouseOut="javascript: window.status=''; return true;" </cfif>tabindex="-1"></cfif>
					#navBarItems[i]#
					<cfif isdefined("navBarLinks") and navBarLinks[i] neq ""></a></cfif>
				</td>
				<td nowrap><img src="#Session.JSroot#/imagenes/subcat_arrow.gif" border="0"></td>
			</cfoutput>
			</cfloop>
		</cfif>
		<td width="100%" nowrap><strong>#titulo#</strong></td>
	  </tr>
	</table>
!--->
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr><td height="2px"></td></tr>
		<tr align="left" valign="middle" bgcolor="##F4F4F4"> 
			<td sytle="border:solid 10px ##AAAAAA;">
			<cfif isdefined("session.usucodigo") and session.usucodigo NEQ "" and session.usucodigo NEQ "0">
				<a href="/cfmx/home/menu/modulo.cfm" tabindex="-1" style="">Men&uacute; Principal</a>
			<cfelse>
				<a href="/cfmx/home/" tabindex="-1" style="">Principal</a>
			</cfif>
				>
		<cfif isdefined("navBarItems")>
			<cfloop index="i" from="1" to="#ArrayLen(navBarItems)#">
			<cfoutput>
					<cfif isdefined("navBarLinks") and navBarLinks[i] neq ""><a href="#navBarLinks[i]#" <cfif isdefined("navBarStatusText")> onMouseOver="javascript: window.status='#navBarStatusText[i]#'; return true;" onMouseOut="javascript: window.status=''; return true;" </cfif>tabindex="-1"></cfif>
					#navBarItems[i]#
					<cfif isdefined("navBarLinks") and navBarLinks[i] neq ""></a></cfif>
				>
			</cfoutput>
			</cfloop>
		</cfif>
				<strong>#titulo#</strong>
			</td>
		</tr>
		<tr><td height="2px"></td></tr>
	</table>
</cfoutput>