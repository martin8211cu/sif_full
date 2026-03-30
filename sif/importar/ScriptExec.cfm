<!-- InstanceBegin template="/Templates/LMenu03.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		<!-- InstanceBeginEditable name="titulo" -->
			Ejecuci&oacute;n de Scripts de Importaci&oacute;n/Exportaci&oacute;n
		<!-- InstanceEndEditable -->
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
		<br>
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td width="1%" valign="top">
					<!-- InstanceBeginEditable name="menu" -->
						
					<!-- InstanceEndEditable -->
				</td>
			
				<td valign="top">
					<!-- InstanceBeginEditable name="mantenimiento" -->
					<cfsetting requesttimeout="3600">
						<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Ejecuci&oacute;n de Scripts de Importaci&oacute;n/Exportaci&oacute;n'>
							<cfif isdefined("Form.paso") and Form.paso EQ '3'>
								<cfinclude template="ScriptExec-form3.cfm">
							<cfelseif isdefined("Form.paso") and Form.paso EQ '2'>
								<cfinclude template="ScriptExec-form2.cfm">
							<cfelse>
								<cfinclude template="ScriptExec-form1.cfm">
							</cfif>
						<cf_web_portlet_end>	
					<!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template><!-- InstanceEnd -->