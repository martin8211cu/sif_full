<!--- <cfdump var="#form#">
<cfdump var="#url#"> 
<cfdump var="#cgi#"> --->
<table cellpadding="0" cellspacing="0" border="1" style="width:100%">
	<tr>
		<td style="width:50%; vertical-align:top">
			<iframe id="EmpresasTLC" name="EmpresasTLC" src="EmpresasTLC.cfm" frameborder="0" width="495" height="350"></iframe>
			<!--- <cfinclude template="EmpresasTLC.cfm"> --->
		</td>
		<td style="width:50%; vertical-align:top">
			<iframe id="TLCEmpresasImp" name="TLCEmpresasImp" src="TLCEmpresasImp.cfm" frameborder="0" width="495" height="350"></iframe>
			<!--- <cfinclude template="TLCEmpresasImp.cfm"> --->
		</td>
	</tr>
	<tr>
		<td colspan="2" align="center">
			<form name="FormConciliar" method="post" action="ConciliacionTLC_sql.cfm">
				<input name="ETLCid" type="hidden" value="">
				<input name="Company" type="hidden" value="">
				<cf_botones name="Conciliar" Values="Conciliar" formname="FormConciliar">
			</form>
		</td>
	</tr>
</table>
<script language="javascript" type="text/javascript">
	function funcConciliar(){
		<!--- alert(parent.EmpresasTLC.getElementById("listaEmpresas")); --->
		var doc1 = parent.document.getElementById("EmpresasTLC").contentDocument;
		var val1 = doc1.listaEmpresas.ETLCID_1.value;
		
		var doc2 = parent.document.getElementById("TLCEmpresasImp").contentDocument;
		var val2 = doc2.listaEmpresas2.COMPANY_1.value;

		document.FormConciliar.ETLCid.value  = val1;
		document.FormConciliar.Company.value = val2;

		if ( doc1.listaEmpresas.ETLCID_2 || doc2.listaEmpresas2.COMPANY_2){
			alert('Solo se puede conciliar una empresa a la vez. Debe filtrar hasta que vea solo una empresa en cada lista.');
			return false;
			}
		else {
			return true;
		     }
		
		
	}
</script>

<!--- 
if ( doc1.listaEmpresas.ETLCID_2.value > 0 || doc2.listaEmpresas2.COMPANY_2.value.length > 0){
			alert('Solo se puede conciliar una empresa a la vez. Debe filtrar hasta que vea solo una empresa en cada lista.');
			return false;
			}
		else {
			return false;
		     }
 --->