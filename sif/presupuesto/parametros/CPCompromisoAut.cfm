<cf_templateheader title="Cuentas de Presupuesto con Compromiso Automatico">
		<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
		<script language="JavaScript" type="text/JavaScript">
		<!--//
			// specify the path where the "/qforms/" subfolder is located
			qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
			// loads all default libraries
			qFormAPI.include("*");
		//-->	
		</script>
        <!---ERBG Parametrización Compromiso Automático INICIA--->
		
        
        <!---ERBG Parametrización Compromiso Automático FIN--->
		
		<cf_web_portlet_start border="true" titulo="Cuentas de Presupuesto con Compromiso Automatico" >
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
        <cfquery name="rsComprAut" datasource="#session.dsn#">
            select CPCompromiso 
			from CPparametros
			where Ecodigo = #session.Ecodigo#
				and CPPid = #session.CPPid#
        </cfquery>
        <table width="100%">
			<tr>
            	<td>
        <!---ERBG Parametrización Compromiso Automático INICIA--->
        		<cfif rsComprAut.recordCount GT 0 and rsComprAut.CPCompromiso eq 'True'>
                	<cfinclude template="CPComprAutPerMes-form.cfm">
                <cfelse>
               		<cfinclude template="CPCompromisoAut-form.cfm">
                </cfif>     
        <!---ERBG Parametrización Compromiso Automático FIN--->
                </td>					
			</tr>
		</table>
<cf_templatefooter>