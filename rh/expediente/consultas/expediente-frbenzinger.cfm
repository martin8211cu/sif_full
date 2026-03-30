
<table width="100%" cellpadding="0" cellspacing="0">	
	<tr>
		<td>
			<cfif isdefined("rsEmpleado.DEid") and Len(Trim(rsEmpleado.DEid)) NEQ 0>
				<tr> 
				  <td>&nbsp;</td>
				</tr>
				<tr> 
				  <td>
					  <cfinclude template="frame-infoEmpleado.cfm">
				  </td>
				</tr>
			</cfif>
		</td>
	</tr>
	<!---
	<tr class="#Session.preferences.Skin#_thcenter"> 
	  <td class="#Session.preferences.Skin#_thcenter">ANOTACIONES</td>
	</tr>
	---->
<tr><td>
<cfset session.DEid = rsEmpleado.DEid>
<center>
  <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" 
	codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="897" height="519" id="benzinger" align="middle">
    <param name="allowScriptAccess" value="sameDomain" />
    <param name="movie" value="perfil_benzinger.swf" />
    <param name="quality" value="high" />
    <param name="bgcolor" value="#ffffff" />
    <embed src="perfil_benzinger.swf" quality="high" bgcolor="#ffffff" width="897" height="519" name="benzinger" 
	align="middle" allowscriptaccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />  
</object>
</center>
</td></tr>
<tr><td>&nbsp;</td></tr>
<tr>
	<td align="center">
		<form name="form1" action="expediente-globalcons.cfm">			
			<input type="hidden" name="DEid" value="<cfif isdefined("rsEmpleado.DEid") and len(trim(rsEmpleado.DEid))><cfoutput>#rsEmpleado.DEid#</cfoutput></cfif>">			
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Regresar"
				Default="Regresar"
				XmlFile="/rh/generales.xml"
				returnvariable="BTN_Regresar"/>			
			<input type="submit" value="<cfoutput>#BTN_Regresar#</cfoutput>" name="regresar" tabindex="1"><!---onClick="javascript: location.href = 'expediente-globalcons.cfm?sel=1&o=1&DEid=#rsEmpleado.DEid#'"---->
		</form>
	</td>
</tr>
<tr><td>&nbsp;</td></tr>
</table>