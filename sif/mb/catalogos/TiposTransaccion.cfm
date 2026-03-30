<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
<cfset navegacion = " " >
<cfif isdefined("Form.Pagina") and Form.Pagina NEQ "">
	<cfset Pagenum_lista = #Form.Pagina#>
</cfif>  	
<cfif not isdefined("session.modulo") or session.modulo eq "">
	<cfset session.modulo = 'MB' >
</cfif>	


<!---Redireccion TiposTransaccionTCE o TiposTransaccion--->

<cfset LvarABTtce = 0>
<cfset LvarIrATiposTransaccion = "../../mb/catalogos/TiposTransaccion.cfm">
<cfset LvarIrAformTiposTransaccion = "../../mb/catalogos/formTiposTransaccion.cfm">
<cfif isdefined("LvarTCETiposTransaccion")>
	<cfset LvarIrATiposTransaccion = "../../tce/catalogos/TCETiposTransaccion.cfm">
	<cfset LvarIrAformTiposTransaccion = "../../tce/catalogos/TCEformTiposTransaccion.cfm">
	<cfset LvarABTtce = 1>
</cfif>


<cf_templateheader title="SIF - Bancos">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Tipos de Transacci&oacute;n de Bancos'>
		<cfif isdefined("session.modulo") and session.modulo EQ "MB">
			<cfinclude template="../../portlets/pNavegacionMB.cfm">
			<cfset navegacion = "&desde=#session.modulo#" >
		<cfelseif isdefined("session.modulo") and session.modulo EQ "AD">
			<cfinclude template="../../portlets/pNavegacionAD.cfm">
			<cfset navegacion = "&desde=#session.modulo#" >
		</cfif>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
                	<td width="50%" valign="top"> 

					  <cfinvoke component="sif.Componentes.pListas" method="pListaRH" 
							tabla="BTransacciones a" 
							
							columnas="	BTid, 
										BTcodigo, 
										BTdescripcion,
										'#session.modulo#' as desde" 
							
							desplegar="BTcodigo, BTdescripcion"
							
							etiquetas="Tipo, Descripción"
							
							formatos=""
							filtro="
									Ecodigo=#session.Ecodigo#
									and BTtce = #LvarABTtce#"

							align="left, left"
							checkboxes="N"
							ira="#LvarIrATiposTransaccion#"
							keys="BTid"
							navegacion="#navegacion#">
					  </cfinvoke>
					</td>
					<td width="50%" valign="top">
						<cfinclude template="#LvarIrAformTiposTransaccion#">
					</td>
              </tr>
            </table>
	<cf_web_portlet_end>	
<cf_templatefooter>