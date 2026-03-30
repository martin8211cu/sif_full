<!--- =============================================================== --->
<!--- Autor:  Rodrigo Rivera                                          --->
<!--- Nombre: Arrendamiento                                           --->
<!--- Fecha:  28/03/2014                                              --->
<!--- Última Modificación: 04/05/2014                                 --->
<!--- =============================================================== --->
<cf_templateheader title="Bancos">
	<cfinclude template="/sif/portlets/pNavegacionMB.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Lista de Cuentas de Mayor">
	 		<table width="100%" border="0" cellpadding="0" cellspacing="0">
             	<tr><td>&nbsp;</td></tr>
			    <tr><td class="etiquetaCampo">&nbsp;Seleccione el Socio al que desee actualizar sus Arrendamientos:</td>
			    </tr><tr><td>&nbsp;</td></tr>
                <tr> 
                	<td valign="top">
					  <cfinvoke component="sif.Componentes.pListas" method="pListaRH" 
							tabla="CatalogoArrend a inner join SNegocios b 
								on a.SNcodigo = b. SNcodigo and a.Ecodigo = b.Ecodigo"
							columnas="distinct b.SNnombre AS SNnombre, a.SNcodigo"
							desplegar="SNnombre"
							etiquetas="Socio de Negocios"
							formatos=""
							filtro="a.Ecodigo=#session.Ecodigo#"
							align="left"
							checkboxes="N"
							ira="RegistroCatalogoArrend.cfm?modosn=CAMBIO&modoarr=ALTA"
							keys="SNnombre">
					  </cfinvoke>
					</td>
					<tr>
					<td align="center">
						<input name="AgregarSocio" class="btnGuardar" tabindex="1" type="button" value="Agregar Socio" onclick="location.href='RegistroCatalogoArrend.cfm?modosn=alta&modoarr=ALTA'">
					</td>
					</tr>
				</tr>
			</table>
 		<cf_web_portlet_end>
<cf_templatefooter>