<cf_templateheader title="Cat&aacute;logo de Habilidades">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cat&aacute;logo de Habilidades HAY'>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td colspan="2">
						
					</td>
				</tr>

				<tr> 
					<td valign="top"> 
						<cfquery name="rsLista" datasource="sifcontrol">
							select a.HYTHid,a.HYHEcodigo, b.HYHEdescripcion, b.HYHEdescalterna, 
							a.HYHGcodigo, c.HYHGdescripcion, c.HYHGdescalterna, a.HYIHgrado, a.HYTHpuntos , HYTHrestrict
							from HYTHabilidades a, HYHabilidadEspecializada b, HYHabilidadGerencia c
							where a.HYHEcodigo=b.HYHEcodigo
							and a.HYHGcodigo=c.HYHGcodigo
							order by a.HYHEcodigo, a.HYHGcodigo, a.HYIHgrado
							
						</cfquery>

						<cfinvoke 
						component="rh.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="conexion" value="sifcontrol">
							<cfinvokeargument name="desplegar" value="HYIHgrado, HYTHpuntos, HYTHrestrict"/>
							<cfinvokeargument name="etiquetas" value="Grado, Puntos, Habilitado"/>
							<cfinvokeargument name="formatos" value="S,S,V"/>
							<cfinvokeargument name="align" value="left,center,center"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="cortes" value="HYHEdescripcion, HYHGdescripcion"/>
							<cfinvokeargument name="irA" value="HabilidadesHAY.cfm"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="HYTHid"/>
						</cfinvoke>
					</td>
					<td width="55%" valign="top">
						<cfinclude template="HabilidadesHAY-form.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>