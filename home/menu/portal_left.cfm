<div class="menutable"><table width="100%" border="0" cellpadding="2" cellspacing="0">
      <!--DWLayoutTable-->
        <tr>
          <td width="4" valign="top"><img src="/cfmx/home/menu/spacer.gif"></td>
          <td width="4" valign="top"><img src="/cfmx/home/menu/spacer.gif"></td>
          <td valign="top">&nbsp;</td>
          <td width="4"></td>
        </tr>
        <tr>
          <td valign="top"></td>
          <td colspan="2" valign="top">Inicio</td>
          <td></td>
        </tr>
		<cfoutput query="rsModulos" group="SMcodigo">
		<cfset seleccionado = rsModulos.SScodigo is session.menues.SScodigo and
		      rsModulos.SMcodigo is session.menues.SMcodigo>
        <tr <cfif seleccionado and Not Len(session.menues.SPcodigo)>class="menutablesel"</cfif>>
          <td></td>
          <td colspan="2" valign="top"><div>
		  	<a href="/cfmx/home/menu/portal.cfm?_nav=1&s=#URLEncodedFormat(Trim(rsModulos.SScodigo))#&m=#URLEncodedFormat(Trim(rsModulos.SMcodigo))#" >
			  <strong>#HTMLEditFormat(ListFirst(rsModulos.SMdescripcion,' '))#</strong></a></div></td>
          <td></td>
        </tr>
		<cfif seleccionado>
		
		<cfoutput>
		<cfset seleccionado2 = seleccionado and rsModulos.SPcodigo is session.menues.SPcodigo>
        <tr <cfif seleccionado2 >class="menutablesel"</cfif>>
          <td></td>
          <td></td>
          <td  valign="top"><div>
		  	<a href="/cfmx/home/menu/portal.cfm?_nav=1&s=#URLEncodedFormat(Trim(rsModulos.SScodigo))#&m=#URLEncodedFormat(Trim(rsModulos.SMcodigo))#&p=#URLEncodedFormat(Trim(rsModulos.SPcodigo))#" >
				#HTMLEditFormat(ListFirst(rsModulos.SPdescripcion,' '))#</a></div></td>
          <td></td>
        </tr>

		</cfoutput>
		</cfif>
		</cfoutput>
        <tr>
          <td height="20"></td>
          <td>&nbsp;</td>
          <td></td>
          <td></td>
        </tr>
        </table></div>