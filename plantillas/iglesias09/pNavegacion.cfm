<!--- Creado 2/12/03 --->
<cfoutput>
<table width="100%" border="0" cellpadding="4" cellspacing="0">
  <tr align="left">
    <td nowrap class="style0902">
		<a href="index.cfm" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true; ">Inicio</a>
    </td>
    <td nowrap class="style0902">|</td>
		<cfif isdefined("navBarItems")>
			<cfloop index="i" from="1" to="#ArrayLen(navBarItems)#">
				<td nowrap>
					<cfif navBarLinks[i] neq ""><a href="#navBarLinks[i]#" onMouseOver="javascript: window.status='#navBarStatusText[i]#'; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"></cfif>
					#navBarItems[i]#
					<cfif navBarLinks[i] neq ""></a></cfif>
				</td>
				<td nowrap>|</td>
			</cfloop>
		</cfif>
    <td nowrap class="style0902" width="100%">
		<cfif isDefined("funcion")>
			<a href="javascript: #funcion#();" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true; ">Regresar</a>
		<cfelseif isDefined("Regresar")>
			<a href="#Regresar#" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true; ">Regresar</a>
		<cfelse>
			<a href="index.cfm" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true; ">Regresar</a>
		</cfif>
    </td>
  </tr>
</table>
</cfoutput>