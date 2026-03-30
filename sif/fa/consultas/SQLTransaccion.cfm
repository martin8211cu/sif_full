<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
    <cfoutput>#Request.Translate('ModuloFA','Facturación','/sif/Utiles/Generales.xml')#</cfoutput>
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
	
		<table width="100%" cellpadding="0" cellspacing="0" align="center">
			<tr>
			
				<td valign="top">
		            <cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Transacci&oacute;n'>
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr><td><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>

						<cfset parametros = ''>
						<cfif not isdefined("Form.btnConsultar_")>
							<cfset parametros = '?FCid=#url.FCid#&ETnumero=#url.ETnumero#'>
					    </cfif>		  
						
						<tr><td><cf_rhimprime datos="/sif/fa/consultas/formTransaccion.cfm" paramsuri="#parametros#" ></td></tr>

					</table>
				
		  <cfoutput>
		  <cfif isdefined("Form.btnConsultar_")>		  
		  	<cfinclude template="formTransaccion.cfm">
			<!---<cf_sifreporte principal="Transaccion.cfm" datos="/sif/fa/consultas/formTransaccion.cfm" modulo="Facturación">--->
		  <cfelse>
  		  	<cfinclude template="formTransaccion.cfm">
		  	<!---<cf_sifreporte principal="" datos="/sif/fa/consultas/formTransaccion.cfm" modulo="Facturación" paramsuri="?FCid=#url.FCid#&ETnumero=#url.ETnumero#">--->
		  </cfif>
		  </cfoutput>
            	
		            </cf_web_portlet>
				</td>	
			</tr>
		</table>	
</cf_templatearea>
</cf_template>