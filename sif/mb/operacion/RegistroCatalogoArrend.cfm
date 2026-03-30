<!--- =============================================================== --->
<!--- Autor:  Rodrigo Rivera                                          --->
<!--- Nombre: Arrendamiento                                           --->
<!--- Fecha:  28/03/2014                                              --->
<!--- Última Modificación: 04/05/2014                                 --->
<!--- =============================================================== --->
<cfprocessingdirective pageencoding = "utf-8">
<!--- 	VARIABLES	 --->
<cfparam name="modosn"	default="ALTA">




<cf_templateheader title="Catalogo de Arrendamientos">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
	            <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Arrendamientos Por Socio'>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>

					</tr>
				  <tr>
					<td width="49%" valign="top"> 
					  <cfif isdefined('Form.PageNum') and Form.PageNum NEQ "" >
					  		<cfset Form.PageNum = 1>
					  </cfif>
					  <cfif isdefined("Form.Pagina") and Form.Pagina NEQ "">
								<cfset Pagenum_lista = #Form.Pagina#>
					  </cfif>
					  <cfif modosn NEQ "ALTA">							
					  	<cfinvoke component="sif.Componentes.pListas" method="pListaRH" 
							tabla="CatalogoArrend a 
								inner join SNegocios b on a.SNcodigo = b.SNcodigo and a.SNcodigo = #form.SNcodigo#  and a.Ecodigo = b.Ecodigo"
							columnas="distinct a.IDCatArrend, b.SNnombre AS SNnombre, a.ArrendNombre as ArrendNombre, a.SNcodigo" 
							desplegar="SNnombre, ArrendNombre"
							etiquetas="Socio de Negocios, Arrendamiento"
							formatos=""
							filtro="a.Ecodigo=#session.Ecodigo#"
							align="left,left"
							checkboxes="N"
							ira="RegistroCatalogoArrend.cfm?modosn=CAMBIO&modoarr=CAMBIO"
							keys="IDCatArrend">
					  	</cfinvoke>
					  </cfif>
						</td>
						<td width="50%"><cfinclude template="formCatalogoArrend.cfm"></td>
					  </tr>
					  <tr><td colspan="2">&nbsp;</td></tr>
					  <tr><td colspan="2">&nbsp;</td></tr>
					</table>
		            <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>

 

