<table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="<cfoutput>##DFDFDF</cfoutput>">
  <tr align="left">

    <td nowrap>
		<a href="/cfmx/home/menu/modulo.cfm?s=sys&m=admin" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true; ">Inicio</a>
    </td>
    <td nowrap>|</td>
    <td nowrap>
		<a href="/cfmx/asp/portal/index.cfm" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true; ">Administrar</a>
    </td>
    <td nowrap>|</td>
	<cfif isdefined("navBarItems")>
		<cfloop index="i" from="1" to="#ArrayLen(navBarItems)#">
		<cfoutput>
			<td nowrap>
				<cfif navBarLinks[i] neq ""><a href="#navBarLinks[i]#" onMouseOver="javascript: window.status='#navBarStatusText[i]#'; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"></cfif>
				#navBarItems[i]#
				<cfif navBarLinks[i] neq ""></a></cfif>
			</td>
			<td nowrap>|</td>
		</cfoutput>
		</cfloop>
	</cfif>
    <td nowrap width="100%">
	<cfif isDefined("funcion")>
		<cfoutput><a href="javascript: #funcion#();" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true; ">Regresar</a></cfoutput>
    <cfelseif isDefined("Regresar")>
		<cfoutput><a href="#Regresar#" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true; ">Regresar</a></cfoutput>
    <cfelse>
    	<cfoutput>
			<a href="/cfmx/asp/portal/index.cfm" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true; ">Regresar</a>
		</cfoutput>
    </cfif>
    </td>
  </tr>
</table>