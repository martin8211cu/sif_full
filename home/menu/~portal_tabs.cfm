<cfset Request.PNAVEGACION_SHOWN = 1>



<cfinclude template="portal_control.cfm">
	<table width="955"  border="0" cellpadding="2" cellspacing="0" xclass="tabs">
        <!--DWLayoutTable-->
        <tr>
          <td width="1" valign="top" class="tabnor"><!--DWLayoutEmptyCell-->&nbsp;</td>
		  <!---
          <td width="1" height="19" valign="top"><!--DWLayoutEmptyCell-->&nbsp; <td width="161"></td>
		  --->
          <td width="134" align="center" valign="top" class="tabnor"><a href="/cfmx/home/index.cfm">Inicio</a></td>
		  
		  <cfoutput query="rsSistemas">
		  <!---
          <td width="3" align="center" valign="top"><!--DWLayoutEmptyCell-->&nbsp;<td width="61"></td>
		  --->
          <td width="111" align="center" valign="top" class="<cfif rsSistemas.SScodigo is session.menues.SScodigo>tabsel<cfelse>tabnor</cfif>">
		  	<a href="/cfmx/home/menu/portal.cfm?_nav=1&s=#URLEncodedFormat(Trim(rsSistemas.SScodigo))#">
				#HTMLEditFormat(rsSistemas.SSdescripcion)#</a></td>
		  </cfoutput>
          <td width="15" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
          <td width="67" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
          <td width="207" rowspan="2" align="right">
		  <cfif session.Usucodigo>
			  <cfif rsEmpresas.RecordCount>
				  <form name="form_empresas" style="margin:0" action="" method="get">
				  <input type="hidden" name="_nav" value="1">
				  <select name="seleccionar_EcodigoSDC" style="width:100%" onChange="this.form.submit();">
				  <cfoutput query="rsEmpresas">
				  <option value="#rsEmpresas.Ecodigo#" <cfif rsEmpresas.Ecodigo is session.EcodigoSDC>selected</cfif> >#HTMLEditFormat(rsEmpresas.Enombre)#</option>
				  </cfoutput>
				  </select>
				  </form>
			  </cfif>
		  <cfelse>
		  	<a href="../../home/public/login.cfm">Ingresar al sistema</a>
		  </cfif>
		  
		  </td>
        </tr>
        <tr>
          <td height="8" colspan="10" valign="top" class="tabsel"><img src="/cfmx/home/menu/spacer.gif" width="1" height="1"></td>
        </tr>
        <tr>
          <td align="right" class="tabsel"><!--DWLayoutEmptyCell-->&nbsp;</td>
          <td height="8" colspan="10" valign="top" class="tabsel">
		  
		  
		  
		  <table ><tr>
	<td nowrap><cfoutput><a tabindex="-1" href="/cfmx/home/menu/portal.cfm?_nav=1&s=#URLEncodedFormat(Trim(ubicacionSS.SScodigo))#">#HTMLEditFormat(ubicacionSS.SSdescripcion)#</a></cfoutput></td>
	<td nowrap>&gt;</td>
	<td nowrap><cfoutput><a tabindex="-1" href="/cfmx/home/menu/portal.cfm?_nav=1&s=#URLEncodedFormat(Trim(ubicacionSS.SScodigo))#&m=#URLEncodedFormat(Trim(ubicacionSM.SMcodigo))#">#HTMLEditFormat(ubicacionSM.SMdescripcion)#</a></cfoutput></td>
	<td nowrap>&gt;</td>
	<td nowrap><cfoutput><a tabindex="-1" href="/cfmx/home/menu/portal.cfm?_nav=1&s=#URLEncodedFormat(Trim(ubicacionSS.SScodigo))#&m=#URLEncodedFormat(Trim(ubicacionSM.SMcodigo))#&p=#URLEncodedFormat(Trim(ubicacionSP.SPcodigo))#">#HTMLEditFormat(ubicacionSP.SPdescripcion)#</a></cfoutput></td>

	<cfif IsDefined("Regresar") and Len(Regresar) Neq 0>
		<cfset Regresar2 = Replace(Regresar,'/cfmx','')>
			<cfif (Regresar2 neq nav__SPhomeuri) and acceso_uri(Regresar2)>
			<td nowrap>&gt;</td>
			<td nowrap><cfoutput><a tabindex="-1" href="/cfmx#Regresar2#">Regresar</a></cfoutput></td>
		</cfif>
	</cfif>
	
	<td width="100%">&nbsp;</td>
	<td nowrap><a tabindex="-1" href="/cfmx/home/menu/passch.cfm">Cambiar contrase&ntilde;a </a></td>
	<td nowrap>|</td>
	<td nowrap><a tabindex="-1" href="/cfmx/home/public/logout.cfm">Salir</a></td>
</tr>
</table>
		  
		  
		  </td>
        </tr>
        <tr>
          <td align="right" class="tabsel"><!--DWLayoutEmptyCell-->&nbsp;</td>
          <td height="8" colspan="10" valign="top" align="left" class="tabsel" style="font-size:larger;text-align:left">
		  <cfoutput>#HTMLEditFormat(ubicacionSP.SPdescripcion)#</cfoutput></td>
        </tr>
    </table>
