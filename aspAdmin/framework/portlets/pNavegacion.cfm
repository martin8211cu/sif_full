<table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="<cfoutput>##DFDFDF</cfoutput>">
  <tr align="left">
    <td nowrap>
		<a href="/cfmx/sif/framework/index.cfm"><cfoutput>Framework</cfoutput></a>
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
			<a href="/cfmx/sif/framework/index.cfm">Regresar</a>
    </cfif>
    </td>
	<cfoutput>
		<cfif isdefined("recycle")>
			<td align="right">
				<a href="#recycle#"><img border="0" src="../../imagenes/w-recycle_black.gif"></a>
			</td>
		</cfif>
	</cfoutput>	
  </tr>
</table>