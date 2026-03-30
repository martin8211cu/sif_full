﻿<!--- Asiganción de Variables del URL --->
<cfif isdefined("Url.o") and not isdefined("Form.o")>
	<cfset Form.o = Url.o>
</cfif>
<cfif isdefined("Url.sel") and not isdefined("Form.sel")>
	<cfset Form.sel = Url.sel>
</cfif>
<cfif isdefined("Url.tab") and not isdefined("Form.tab")>
	<cfset Form.tab = Url.tab>
</cfif>
<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfset Form.DEid = Url.DEid>
</cfif>

<!--- Pintado de la Pantalla --->
<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
	<!--- Línea No. 1 --->
	<tr>
    	<td><cfinclude template="/rh/portlets/pEmpleado.cfm"></td>
  	</tr>
	<!--- Línea No 2 --->
  	<tr>
    	<td><cfinclude template="ObjetosEmpleado-form.cfm"></td>	
  	</tr>
</table>
