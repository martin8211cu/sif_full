<cf_templateheader title="Gasto Empleados">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cat&aacute;logo Categor&iacute;a Destinos'>
			<cfinclude template="../../portlets/pNavegacion.cfm">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
                	<td width="50%" valign="top"> 

					  <cfinvoke component="sif.Componentes.pListas" method="pListaRH" 
							tabla="GEcategoriaDestino" 
							
							columnas="	 GECDid          
                                        ,Ecodigo
                                        ,GECDcodigo
                                        ,GECDdescripcion 
                                        ,GECDmonto" 
							
							desplegar="GECDcodigo, GECDdescripcion,GECDmonto"
							
							etiquetas="Codigo, Descripción,Monto"
							filtrar_por="GECDcodigo,GECDdescripcion,GECDmonto"
                            mostrar_filtro = "true"
                            filtrar_automatico="true"
							formatos="V,V,I"
							filtro="
									Ecodigo=#session.Ecodigo#"

							align="left, left, left"
							checkboxes="N"
							ira="GEcategoriaDestino.cfm"
							keys="GECDid"
							navegacion="">
					  </cfinvoke>
					</td>
					<td width="50%" valign="top">
						<cfinclude template="GEcategoriaDestino-form.cfm">
					</td>
              </tr>
            </table>
	<cf_web_portlet_end>	
<cf_templatefooter>