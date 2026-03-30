<cf_templateheader title="Cuentas de Presupuesto con Compromiso Obligatorio">
		<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
		<script language="JavaScript" type="text/JavaScript">
		<!--//
			// specify the path where the "/qforms/" subfolder is located
			qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
			// loads all default libraries
			qFormAPI.include("*");
		//-->	
		</script>
        		
		<cf_web_portlet_start border="true" titulo="Cuentas de Presupuesto con Compromiso Obligatorio" >
		<cfinclude template="../../portlets/pNavegacion.cfm">
        <table border="0">
            <tr>
                <td colspan="2">&nbsp;</td>
                <td colspan="2">
                    <strong>Período del Presupuesto</strong>:&nbsp;
                </td>
            </tr>
    
            <tr>
                <td colspan="2">&nbsp;</td>
                <td colspan="2">
                    <cf_cboCPPid IncluirTodos="false" createform="frmCPPid" session="true" CPPestado="0,1" CPPid="CPPid" onChange="document.frmCPPid.submit();">
                </td>
            </tr>
        </table>
        <table width="100%">
			<tr>
            	<td>
        <!---ERBG Parametrización Compromiso Automático INICIA--->
        		<cfinclude template="CPComprObligatorio-form.cfm">
        <!---ERBG Parametrización Compromiso Automático FIN--->
                </td>					
			</tr>
		</table>
<cf_templatefooter>