<cf_templateheader title="Reportes Dinamicos de Contabilidad General ">
	<cfinclude template="/home/menu/pNavegacion.cfm">
	<cf_web_portlet_start border="true" skin="#session.preferences.skin#" tituloalign="center" titulo="Reportes Dinamicos de Contabilidad General">
    <form name="form1" id="form1" method="post" action="ReportDinamic-sql.cfm" onsubmit="return validaGenerar();">
        <table align="center">
            <tr>
                <td>
                    <cfinclude template="ReportDinamic-form.cfm">
                </td>
            </tr>
        </table>
	</form>
	<cf_web_portlet_end>
<cf_templatefooter>
<script type="text/javascript">
	function validaGenerar(){
		if(document.form1.ERDid.value==""){
			alert("Debe seleccionar un reporte");
			return false;
		}
		return true;
	}
</script>