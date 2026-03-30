<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">Recursos Humanos</cf_templatearea>
	<cf_templatearea name="body">

	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					  <script language="javascript" type="text/javascript">
							function funcRegresar() {
								document.form1.action = 'Expediente.cfm';
							}
						</script>
					  <cfinclude template="frame-expediente-portada.cfm">
				</td>
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>
