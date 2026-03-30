<cfinclude template="tabNames.cfm">

<cfif isdefined("Form.o")>
	<cfset tabChoice = Val(Form.o)>
</cfif>

<table border="0" cellspacing="0" cellpadding="5" width="100%">
	<tr>
	  <cfloop index="i" from="1" to="#ArrayLen(tabNames)#">
		<cfoutput>
		  <td class="<cfif tabChoice eq i>tabSelected<cfelse>tabNormal</cfif>" nowrap>
		  <cfif tabLinks[i] neq ""><a href="#tabLinks[i]#" onMouseOver="javascript: window.status='#tabStatusText[i]#'; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"></cfif>
		  #tabNames[i]#
		  <cfif tabLinks[i] neq ""></a></cfif>
		  </td>
		</cfoutput>
	  </cfloop>
	  <td width="100%" style="border-bottom: 1px solid black;">&nbsp;</td>
	</tr>
</table>
