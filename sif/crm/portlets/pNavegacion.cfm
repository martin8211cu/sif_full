<table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="<cfoutput>##DFDFDF</cfoutput>">
  <tr align="left">
    <td nowrap>
		<a href="/cfmx/sif/crm/index.cfm"><cfoutput>#Request.Translate('SistemaCRM','CRM','/sif/crm/Utiles/Generales.xml')#</cfoutput></a>
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
		<cfoutput><a href="javascript: #funcion#();">#Request.Translate('Regresar','Regresar','/sif/crm/Utiles/Generales.xml')#</a></cfoutput>
    <cfelseif isDefined("Regresar")>
		<cfoutput><a href="#Regresar#">#Request.Translate('Regresar','Regresar','/sif/crm/Utiles/Generales.xml')#</a></cfoutput>
    <cfelse>
    	<cfoutput>
			<a href="/cfmx/sif/crm/index.cfm">#Request.Translate('Regresar','Regresar','/sif/crm/Utiles/Generales.xml')#</a>
		</cfoutput>
    </cfif>
    </td>
  </tr>
</table>