<cfif isdefined('url.tipoCuenta') >
	<cfset form.tipoCuenta = url.tipoCuenta>
</cfif>

<cf_templateheader title="Reversión Masiva de Estimación">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reverso Masivo de Estimaci&oacute;n'>

	<cfinclude template="../../sif/portlets/pNavegacion.cfm">
    <cfoutput>
    <table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
		<tr>
<!---        <td>
        #application.myappvarCC#
        </td>
--->			<td>
				<form  method="post" name="lista" style="margin:0;" >
					<script language="JavaScript1.2" type="text/javascript">
						alert('Se estan aplicando reversos');
					</script>
    				<cfif #form.tipoCuenta# EQ 0>
						<cflock type="EXCLUSIVE" timeout="10"><cfset application.myappvarCC="0"></cflock>
					<cfelse>
						<cflock type="EXCLUSIVE" timeout="10"><cfset application.myappvarCP="0"></cflock>
					</cfif>
				</form>
			</td>
		</tr>
    </table>
    </cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>