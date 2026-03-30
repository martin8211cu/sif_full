<cfinclude template="/home/menu/pNavegacion.cfm"><!---
<table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="<cfoutput>##DFDFDF</cfoutput>">
  <tr align="left">
    <td nowrap>
		<a href="/cfmx/sif/index.cfm"><cfoutput>Inicio</cfoutput></a>
    </td>
    <td nowrap>|</td>
    <td nowrap>
		<a href="/cfmx/asp/portal/index.cfm"><cfoutput>Administrar</cfoutput></a>
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
		<cfoutput><a href="javascript: #funcion#();">Regresar</a></cfoutput>
    <cfelseif isDefined("Regresar")>
		<cfoutput><a href="#Regresar#">Regresar</a></cfoutput>
    <cfelse>
			<a href="javascript:history.back()">Regresar</a>
    </cfif>
    </td>
  </tr>
</table>--->