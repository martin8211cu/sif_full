<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		
			Mantenimiento de Parentesco
	
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
		<br>
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					  <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Mantenimiento de Parentesco'>
						  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
							  <tr>
							  	<td colspan="3">
								<cfinclude template="/rh/portlets/pNavegacion.cfm">
								</td>
							  </tr>
							  <tr>
								  <td colspan="3" a align="center">
									 <font size="+1">Mantenimiento de Parentesco</font>
								  </td>
							  </tr>
					
							  <tr> 
								  <td valign="top" >  
									  <cfinvoke 
										component="rh.Componentes.pListas"
										method="pListaRH"
										returnvariable="pListaRet">
										<cfinvokeargument name="conexion" value="#form.Ccache#"/>
										<cfinvokeargument name="columnas" value="Pid, Pdescripcion, '#form.Ccache#' as Ccache"/>
										<cfinvokeargument name="tabla" value="RHParentesco"/>
										<cfinvokeargument name="desplegar" value="Pdescripcion"/>
										<cfinvokeargument name="etiquetas" value="Descripción"/>
										<cfinvokeargument name="formatos" value="S"/>
										<cfinvokeargument name="align" value="left"/>
										<cfinvokeargument name="irA" value="Parentesco.cfm"/>
										<cfinvokeargument name="filtro" value=""/>
										<cfinvokeargument name="ajustar" value="N"/>
										<cfinvokeargument name="keys" value="Pid"/>
									</cfinvoke>
								  </td>
									<td colspan="2"><cfinclude template="Parentesco-form.cfm"></td>
							  </tr>
						  </table>
					  <cf_web_portlet_end>	
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>