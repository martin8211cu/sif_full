<cfif isdefined("form.Bid") and len(trim(form.Bid)) >
	<cfset regresar = "../MenuMB.cfm">
</cfif>
<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.Pagina") and Form.Pagina NEQ "">
	<cfset Pagenum_lista = Form.Pagina>
</cfif> 
<cf_templateheader title="Bancos">
	<cfinclude template="/sif/portlets/pNavegacionMB.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Lista de Cuentas de Mayor">
	 		<table width="100%" border="0" cellpadding="0" cellspacing="0">
             	<tr><td>&nbsp;</td></tr>
			    <tr><td class="etiquetaCampo">&nbsp;Seleccione el Banco al que desee actualizar sus Cuentas Bancarias:</td>
			    </tr><tr><td>&nbsp;</td></tr>
                <tr> 
                	<td valign="top">
					  <cfinvoke component="sif.Componentes.pListas" method="pListaRH" 
							tabla="Bancos" 
							columnas="Bid, Bdescripcion, Bdireccion, Btelefon, Bfax, Bemail , 'ALTA' as modo2" 
							desplegar="Bdescripcion, Bdireccion, Btelefon, Bfax, Bemail"
							etiquetas="Bancos, Direccion Física, Teléfono, Fax, E-mail"
							formatos=""
							filtro="Ecodigo=#session.Ecodigo#"
							align="left, Left,Left,left,left"
							checkboxes="N"
							ira="CuentasBancarias.cfm"
							keys="Bid">
					  </cfinvoke>
					</td>
				</tr>
			</table>
 		<cf_web_portlet_end>
<cf_templatefooter>