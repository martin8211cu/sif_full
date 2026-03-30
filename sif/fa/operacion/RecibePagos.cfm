<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Recibo de Pagos
      
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
	
		<cfif isdefined("url.VentaID") and not isdefined("form.VentaID")>
			<cfset form.VentaID = url.VentaID >
		</cfif>

		<cfif isdefined("url.Cambio") and not isdefined("form.Cambio")>
			<cfset form.Cambio = url.Cambio >
		</cfif>

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
			
				<td valign="top">
		            <cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Recibo de Pagos'>
	 
			<table width="100%" cellpadding="0" cellspacing="0">
            	
				<tr> 
                	<td ><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
				<!--- <tr><td class="tituloAlterno" colspan="6">Recibo de Pagos</td></tr>---->
				<tr>
					<td class="subTitulo" align="center">
						<strong><font size="2">Datos de la Factura Presente</font></strong>
					</td>
				</tr>
				<tr>
					<td>
						<table width="100%" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td><cfinclude template="revisionCredito-factPrese.cfm"></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td class="subTitulo" align="center">
						<strong><font size="2">Detalle del Pago</font></strong>
					</td>
				</tr>
				<tr><td><cfinclude template="RecibePagosForm.cfm"></td></tr>
				
				<tr>
					<td>
					
					</td>
				</tr>
				
			</table>		  
            	
		            </cf_web_portlet>
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>
