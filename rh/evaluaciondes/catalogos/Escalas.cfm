<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_RecursosHumanos"
Default="Recursos Humanos"
XmlFile="/rh/generales.xml"
returnvariable="LB_RecursosHumanos"/>



<cf_templateheader title="#LB_RecursosHumanos#">
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_Escalas_de_calificacion"
						Default="Escalas de calificaci&oacute;n"
						returnvariable="LB_Escalas_de_calificacion"/>
		            <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Escalas_de_calificacion#'>
						<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
						  <tr> 
							<td colspan="2">
							<cfinclude template="/rh/portlets/pNavegacion.cfm">
							  </td>
						  </tr>
						  <tr> 
							<td valign="top"> 
								<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="LB_Escala"
									Default="Escala"
									returnvariable="LB_Escala"/>
									
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="LB_Descripcion"
									Default="Descripci&oacute;n"
									returnvariable="LB_Descripcion"/>
									
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="LB_Predeterminado"
									Default="Predeterminado"
									returnvariable="LB_Predeterminado"/>
									
							  <cfinvoke component="rh.Componentes.pListas" method="pListaRH"
							 returnvariable="pLista">
								<cfinvokeargument name="tabla" value="RHEscalas"/>
								<cfinvokeargument name="columnas" value="RHEid,RHEdescripcion,case RHEdefault when 0 then '&nbsp;' else '<img src=''/cfmx/rh/imagenes/checked.gif'' border=''0''>' end  as RHEdefault"/>
								<cfinvokeargument name="desplegar" value="RHEid,RHEdescripcion,RHEdefault"/>
								<cfinvokeargument name="etiquetas" value="#LB_Escala#,#LB_Descripcion#,#LB_Predeterminado#"/>
								<cfinvokeargument name="formatos" value=""/>
								<cfinvokeargument name="filtro" value="Ecodigo=#session.Ecodigo# order by RHEid"/>
								<cfinvokeargument name="align" value="left, left, center"/>
								<cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="checkboxes" value="N"/>
								<cfinvokeargument name="irA" value="Escalas.cfm"/>
							  </cfinvoke>
							</td>
							<td  align="left" valign="top" width="50%"><cfinclude template="formEscalas.cfm"></td>
						  </tr>
						  <tr> 
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						  </tr>
						</table>
            	
		            <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>