<cf_templateheader title="Cierre de Cajas">
    <table width="100%" cellpadding="2" cellspacing="0">
        <tr>
            <td valign="top">
                <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cierre de Caja Supervisor'>
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr><td><cfinclude template="../../portlets/pNavegacionFA.cfm"></td></tr>
                        <cfset RolAdministrador = true>
                        <cfif isdefined('form.VistaCaja')>
                           <cfset CajaVer = true>
                           <cfset IdCaja = form.IdCaja>
                        </cfif>
                        <tr>
                          <td>
                             <cfinclude template="formCierreCaja.cfm">
                          </td>
                        </tr>
                    </table>
                <cf_web_portlet_end>
            </td>	
        </tr>
    </table>	
<cf_templatefooter>