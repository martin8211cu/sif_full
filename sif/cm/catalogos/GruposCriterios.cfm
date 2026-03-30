<cf_templateheader title="	Compras - Grupos de Criterios">
	<cfinclude template="../../portlets/pNavegacion.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Grupos de Criterios'>
			  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr> 
					  <td valign="top" width="50%"> 
							<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
								<cfinvokeargument name="tabla" 		value="GruposCriteriosCM"/>
								<cfinvokeargument name="columnas" 	value="GCcritid, GCcritdesc"/>
								<cfinvokeargument name="desplegar" 	value="GCcritdesc"/>
								<cfinvokeargument name="etiquetas" 	value="Descripci&oacute;n"/>
								<cfinvokeargument name="formatos" 	value=""/>
								<cfinvokeargument name="filtro" 	value="Ecodigo = #Session.Ecodigo# order by GCcritdesc"/>
								<cfinvokeargument name="align" 		value="left"/>
								<cfinvokeargument name="ajustar" 	value="N"/>
								<cfinvokeargument name="checkboxes" value="N"/>
								<cfinvokeargument name="irA" 		value="GruposCriterios.cfm"/>
								<cfinvokeargument name="keys" 		value="GCcritid"/>
							</cfinvoke>
					  </td>
					  <td valign="top" width="50%">
						<cfinclude template="GruposCriterios-form.cfm">
					  </td>
				  </tr>
			  </table>
		<cf_web_portlet_end>	
<cf_templatefooter>