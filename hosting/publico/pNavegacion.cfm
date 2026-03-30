<!--- Creado 2/12/03 --->
<cfoutput>
<table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="##DFDFDF">
  <tr align="left">
    <td nowrap>
		<a href="/cfmx/hosting/publico/index.cfm" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true; ">Inicio</a>
|		<cfif isdefined("navBarItems")>
			<cfloop index="i" from="1" to="#ArrayLen(navBarItems)#">

					<cfif navBarLinks[i] neq ""><a href="#navBarLinks[i]#" onMouseOver="javascript: window.status='#navBarStatusText[i]#'; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"></cfif>
					#navBarItems[i]#
					<cfif navBarLinks[i] neq ""></a></cfif>
|			</cfloop>
		</cfif> 
		<cfif isDefined("funcion")>
			<a href="javascript: #funcion#();" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true; ">Regresar</a>
		<cfelseif isDefined("Regresar")>
			<a href="#Regresar#" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true; ">Regresar</a>
		<cfelse>
			<a href="/cfmx/hosting/publico/index.cfm" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true; ">Regresar</a>
		</cfif>
    </td>
  </tr>
</table>
</cfoutput>