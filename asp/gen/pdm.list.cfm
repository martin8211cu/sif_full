<cfinclude template="env.cfm" >
<cfoutput>
<form name="form1" method="get" action="pdm.set.cfm"><table>
<tr><td>Modelo activo:
  	<cfdirectory action="list" directory="#ExpandPath('/asp/gen/pdm')#" name="listing" filter="*.pdm">
  <select name="pdm" >
	<cfloop query="listing">
		<option value="#HTMLEditFormat(listing.name)#" <cfif listing.name is session.pdm.file>selected </cfif>  >
			#HTMLEditFormat(listing.name)#</option>
	</cfloop>
  </select></td>
  <td>Ruta de-generaci&oacute;n:
  <input type="text" name="path"  value="#HTMLEditFormat(session.pdm.path)#" /></td>
  <td>App:
    <input type="text" name="app" value="#HTMLEditFormat(session.pdm.app)#" />
  </td><td>
  <input type="hidden" name="Diagram" value="#HTMLEditFormat(url.Diagram)#" />
  <input type="hidden" name="code" value="#HTMLEditFormat(url.code)#" />
  <input type="submit" name="Submit" value="Aplicar" />
  </td></tr>
</table></form>
</cfoutput>