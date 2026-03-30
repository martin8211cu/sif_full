<cffunction name="getParam" access="private">
	<cfargument name="p" required="true">
	<cfif isdefined("url.#Arguments.p#") and Len(trim(Evaluate("url.#Arguments.p#"))) GT 0>
		<cfset Evaluate("form.#Arguments.p#=url.#Arguments.p#")>
	</cfif>
</cffunction>
<cfset getParam("EAcpidtrans")>
<cfset getParam("EAcpdoc")>
<cfset getParam("EAcplinea")>
<cfset getParam("DAlinea")>
<cfset getParam("lin")>
<cfif not (isdefined("Form.EAcpidtrans") 
			and isdefined("Form.EAcpdoc") 
			and isdefined("Form.EAcplinea"))>
    <cfset LvarUrl = 'adquisicion-lista.cfm'>
    <cfif isdefined("session.LvarJA") and session.LvarJA>
    	<cfset LvarUrl = 'adquisicion-lista_JA.cfm'>
    <cfelseif isdefined("session.LvarJA") and not session.LvarJA>
    	<cfset LvarUrl = 'adquisicion-lista_Aux.cfm'>
    </cfif>
	<cflocation addtoken="no" url="#LvarUrl#">
</cfif>

<cf_templateheader title="Activos Fijos">
		
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Adquisici&oacute;n de Activos'>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr> 
						<td valign="top" width="30%" align="left">
							<cfinclude template="adquisicion-arbol.cfm">
						</td>
						<td valign="top" width="70%" align="left">
							<cfinclude template="adquisicion-crform.cfm">
						</td>
					</tr>
				</table>
			<cf_web_portlet_end>
	<cf_templatefooter>