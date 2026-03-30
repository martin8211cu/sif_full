<table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="<cfoutput>##DFDFDF</cfoutput>">
  <tr align="left">
    <td nowrap>
		<a href="/cfmx/sif/me/index.cfm"><cfoutput>#Request.Translate('SistemaME','Sistema Modulo Entidad','/sif/me/Utiles/Generales.xml')#</cfoutput></a>
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
		<cfoutput><a href="javascript: #funcion#();">#Request.Translate('Regresar','Regresar','/sif/me/Utiles/Generales.xml')#</a></cfoutput>
    <cfelseif isDefined("Regresar")>
		<cfoutput><a href="#Regresar#">#Request.Translate('Regresar','Regresar','/sif/me/Utiles/Generales.xml')#</a></cfoutput>
    <cfelse>
    	<cfoutput>
			<a href="/cfmx/sif/me/index.cfm">#Request.Translate('Regresar','Regresar','/sif/me/Utiles/Generales.xml')#</a>
		</cfoutput>
    </cfif>
    </td>
	<cfif isdefined("navRightItems")>
		<cfloop index="i" from="1" to="#ArrayLen(navRightItems)#">
		<cfoutput>
			<cfif i gt 1>
			<td nowrap>|</td>
			</cfif>
			<td nowrap>
				<cfif navRightItems[i] neq ""><a href="#navRightLinks[i]#" onMouseOver="javascript: window.status='#navRightStatusText[i]#'; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"></cfif>
				#navRightItems[i]#
				<cfif navRightLinks[i] neq ""></a></cfif>
			</td>			
		</cfoutput>
		</cfloop>
	</cfif>
  </tr>
</table>