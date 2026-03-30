<cf_templateheader title="Anexos Financieros">
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					  <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Anexos'>
						  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
							  <tr>
								  <td colspan="3">
									  <cfinclude template="../../portlets/pNavegacion.cfm">
								  </td>
							  </tr>
					
							  <tr> 
								  <td valign="top"> 
									  <table width="100%" border="0" cellspacing="0" cellpadding="0">
									    <tr> 
										  <td>&nbsp;</td>
										  <td valign="top"> 
										  	<cf_dbfunction name="to_char" args="a.AnexoId"  returnvariable="AnexoId">
										     <cfinvoke 
												 component="sif.Componentes.pListas"
												 method="pListaRH"
												 returnvariable="pListaRet">
											   <cfinvokeargument name="tabla" value="Anexo a, AnexoEm b"/>
											   <cfinvokeargument name="columnas" value="#AnexoId# as AnexoId, a.AnexoDes"/>
											   <cfinvokeargument name="desplegar" value="AnexoDes"/>
											   <cfinvokeargument name="etiquetas" value="Descripción"/>
											   <cfinvokeargument name="formatos" value=""/>
											   <cfinvokeargument name="filtro" value="b.Ecodigo = #Session.Ecodigo# and a.AnexoId = b.AnexoId"/>
											   <cfinvokeargument name="align" value="left"/>
											   <cfinvokeargument name="ajustar" value="N"/>
											   <cfinvokeargument name="checkboxes" value="N"/>
											   <cfinvokeargument name="irA" value="Anexo.cfm"/>
										    </cfinvoke> </td>
										  <td valign="top"> <cfinclude template="formAnexo.cfm"> &nbsp;</td>
										  <td>&nbsp;</td>
									    </tr>
									  </table>

								  </td>
							  </tr>
						  </table>
					  <cf_web_portlet_end>	
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>