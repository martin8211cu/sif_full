<cf_template template="#session.sitio.template#">

	<cf_templatearea name="title">
		Diccionario de Datos
	</cf_templatearea>

	<cf_templatearea name="body">

		<cfinclude template="DiccDato-config.cfm">
		
		<script type="text/javascript">
			<!--
			function tab_set_current (n) {
				<cfoutput>
				var params = "";
				params = "?tab="+n;
				<cfif modo EQ "CAMBIO">
					params = params + "&id_tipo=#Form.id_tipo#"
				</cfif>
				location.href = "#CurrentPage#"+params;
				</cfoutput>
			}
			//-->
		</script>

		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Diccionario de Datos">
			<cfinclude template="/home/menu/pNavegacion.cfm">
			
			<cfinclude template="DiccDato-header.cfm">
			<cfif Form.tab EQ 0>
				<cfinclude template="DiccDato-lista.cfm">
			<cfelse>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				  <tr>
				  	<td>&nbsp;</td>
				  </tr>
				  <tr>
					<td valign="top">
						<cf_tabs width="98%">
							<cf_tab text="Datos Generales" selected="#Form.tab EQ 1#" id="1">
								<cfif Form.tab EQ 1>
									<cfinclude template="DiccDato-form1.cfm">
								</cfif>
							</cf_tab>
							<!--- Estos tabs solo aparecen en modo cambio --->
							<cfif modo EQ "CAMBIO">
								<!--- Solo se muestra si la clase es una lista de valores ---->
								<cfif rsTipoDato.clase_tipo EQ "L">
									<cf_tab text="Valores" selected="#Form.tab EQ 2#" id="2">
										<cfif Form.tab EQ 2>
											<cfoutput>
												<iframe src="DiccDato-form2.cfm?id_tipo=#Form.id_tipo#" frameborder="0" height="300" scrolling="auto" style="width:100%"></iframe>
											</cfoutput>
										</cfif>
									</cf_tab>
								</cfif>
								
								<!--- Solo se muestra si la clase es un tipo complejo ---->
								<cfif rsTipoDato.clase_tipo EQ "C">
									<cf_tab text="Composici&oacute;n" selected="#Form.tab EQ 3#" id="3">
										<cfif Form.tab EQ 3>
											<cfoutput>
												<iframe src="DiccDato-form3.cfm?id_tipo=#Form.id_tipo#" frameborder="0" height="350" scrolling="auto" style="width:100%"></iframe>
											</cfoutput>
										</cfif>
									</cf_tab>
								</cfif>
								
							</cfif>
						</cf_tabs>
					</td>
				  </tr>
				  <tr>
				  	<td>&nbsp;</td>
				  </tr>
				</table>
			</cfif>

		<cf_web_portlet_end>
	
	</cf_templatearea>
</cf_template>
