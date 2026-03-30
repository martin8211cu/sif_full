<script type="text/javascript" language="javascript">
	<!--
	function tab_set_current_inst (n){
		<cfif isdefined("form.id_inst") and len(trim(form.id_inst))>
			location.href='<cfoutput>#GetFileFromPath(GetTemplatePath())#?id_inst=#JSStringFormat(form.id_inst)#</cfoutput>&tab='+escape(n);
		<cfelse>
			alert('Debe agregar o seleccionar una institución.');
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
					<cfinclude template="instituciones-datosgenerales.cfm">
				</cfif>
			</cf_tab>
			<cf_tab text="Sucursales y Ventanillas" id="2" selected="#form.tab eq 2#">
				<cfif form.tab eq 2>
					<cfinclude template="instituciones-sucursales.cfm">
				</cfif>
			</cf_tab>
			<cf_tab text="Funcionarios" id="3" selected="#form.tab eq 3#">
				<cfif form.tab eq 3>
					<cfinclude template="instituciones-funcionarios.cfm">
				</cfif>
			</cf_tab>
			<cf_tab text="Tr&aacute;mites" id="4" selected="#form.tab eq 4#">
				<cfif form.tab eq 4>
					<cfinclude template="instituciones-tramites.cfm">
				</cfif>
			</cf_tab>
			<cf_tab text="Requisitos" id="5" selected="#form.tab eq 5#">
				<cfif form.tab eq 5>
					<cfinclude template="instituciones-requisitos.cfm">
				</cfif>
			</cf_tab>
		</cf_tabs>
	</td>
  </tr>
</table>


