<cfinclude template="tabs_Parametros.cfm">
<!---<table border="0" cellspacing="0" cellpadding="5" width="100%">
	<tr>
		<cfloop index="i" from="1" to="#ArrayLen(tabNames)#">
		<cfoutput>
			<td class="<cfif tabChoice eq i>#Session.Preferences.Skin#_tabsel<cfelse>#Session.Preferences.Skin#_tabnorm</cfif>" nowrap>
				<cfif len(tabLinks[i])>
					<a href="#tabLinks[i]#" onMouseOver="javascript: window.status='#tabStatusText[i]#'; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1">
				</cfif>
				<span style="color:<cfif tabChoice eq i>##000000<cfelse>##FFFFFF</cfif>;">#tabNames[i]#</span>
				<cfif len(tabLinks[i])></a></cfif></span>
			</td>
		</cfoutput>
		</cfloop>
		<td width="100%" style="border-bottom: 1px solid black;">&nbsp;</td>
	</tr>
</table>--->