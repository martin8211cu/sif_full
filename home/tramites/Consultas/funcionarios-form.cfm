<script type="text/javascript" language="javascript">
	<!--
	function tab_set_current_inst (n){
		<cfif isdefined("form.id_inst") and len(trim(form.id_inst)) and isdefined("form.id_funcionario") and len(trim(form.id_funcionario))>
			location.href='<cfoutput>#GetFileFromPath(GetTemplatePath())#?id_inst=#JSStringFormat(form.id_inst)#&id_funcionario=#JSStringFormat(form.id_funcionario)#</cfoutput>&tab='+escape(n);
		<cfelse>
			alert('Debe agregar o seleccionar un funcionario.');
		</cfif>
	}
	//-->
</script>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>
		<cf_tabs width="100%" onclick="tab_set_current_inst">
			<cf_tab text="Datos Generales" id="1" selected="#form.tab eq 1#">
				<cfif form.tab eq 1>
					<cfinclude template="funcionarios-datosgenerales.cfm">
				</cfif>
			</cf_tab>
			<cf_tab text="Ventanillas" id="2" selected="#form.tab eq 2#">
				<cfif form.tab eq 2>
					<cfinclude template="funcionarios-ventanillas.cfm">
				</cfif>
			</cf_tab>
			<cf_tab text="Funciones y Servicios" id="3" selected="#form.tab eq 3#">
				<cfif form.tab eq 3>
					<cfinclude template="funcionarios-funciones.cfm">
				</cfif>
			</cf_tab>
			<cf_tab text="Bit&aacute;cora" id="4" selected="#form.tab eq 4#">
				<cfif form.tab eq 4>
					<cfinclude template="funcionarios-bitacora.cfm">
				</cfif>
			</cf_tab>
		</cf_tabs>
	</td>
  </tr>
</table>


