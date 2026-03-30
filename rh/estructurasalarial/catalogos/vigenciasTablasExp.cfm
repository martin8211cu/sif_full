<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		 Exportaci&oacute;n de Escalas Salariales
	</cf_templatearea>
	<cf_templatearea name="body">

		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Exportac&oacute;n de Escalas Salariales">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">

			<cfif isdefined("url.RHTTid")>
				<cfparam name="form.RHTTid" default="url.RHTTid">
			</cfif>
			<cfif isdefined("url.RHVTid")>
				<cfparam name="form.RHVTid" default="url.RHVTid">
			</cfif>			

			<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
				<tr><td colspan="3" align="center">&nbsp;</td></tr>
				<tr>
					<td align="center" width="2%">&nbsp;</td>
					<td align="center" valign="top" width="55%">
						<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Pasos de la importaci&oacute;n">
							<u>Seleccione la opci&oacute;n:</u> Generar HTML creará una página HTML con los datos, 
								y generar línea de encabezados un archivo de texto.<bR><br>
							<u>Importaci&oacute;n:</u>&nbsp;Una vez seleccionada presione el bot&oacute;n <strong>Generar</strong>.<br>							
					  	<cf_web_portlet_end>
				  	</td>					
					<td align="center" style="padding-left: 15px " valign="top">
						<cf_sifimportar EIcodigo="E_RH_TABSAL" mode="out">
							<cf_sifimportarparam name="Origen" value= "TS">							
							<cf_sifimportarparam name="Escenario" value= "0">
							<cfif isdefined("form.RHTTid") and len(trim(form.RHTTid))>
								<cf_sifimportarparam name="Tabla" value= "#Form.RHTTid#"> 
							</cfif>
							<cfif isdefined("form.RHVTid") and len(trim(form.RHVTid))>
								<cf_sifimportarparam name="Vigencia" value= "#form.RHVTid#">
							</cfif>
						</cf_sifimportar>
					</td>		
				</tr>				
				<tr><td colspan="3" align="center">&nbsp;</td></tr>
			</table>
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>