<cf_templateheader title="Asignaci&oacute;n de Permisos">
	<cfif isdefined("url.Usucodigo") and not isdefined("form.Usucodigo")>
		<cfset form.Usucodigo = url.Usucodigo>
	</cfif>
    <table width="100%" border="0" cellpadding="4" cellspacing="0">
        <tr>
            <td valign="top">
                <cfinclude template="Permisos_Rol-form.cfm">
            </td>
        </tr>
    </table>
<cf_templatefooter>