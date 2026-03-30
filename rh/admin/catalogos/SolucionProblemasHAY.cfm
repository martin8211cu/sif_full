<cf_templateheader title="Cat&aacute;logo de Soluci&oacute;n Problemas">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cat&aacute;logo de Soluci&oacute;n Problemas HAY'>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td colspan="2">
						<cfinclude template="/rh/portlets/pNavegacion.cfm">
					</td>
				</tr>

				<tr> 
					<td valign="top"> 
						<cfquery name="rsLista" datasource="sifcontrol">
							select b.HYCPdescripcion, a.HYCPgrado, a.HYMRcodigo, a.HYTSPporcentaje, c.HYMRdescripcion, c.HYMRdesclaterna , a.HYTSrestrict
							from HYTSolucionProblemas a, HYComplejidadPensamiento b, HYMarcoReferencia c
							where a.HYCPgrado=b.HYCPgrado
							and a.HYMRcodigo=c.HYMRcodigo
							order by a.HYMRcodigo, a.HYCPgrado
						</cfquery>

						<cfinvoke 
						component="rh.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="conexion" value="sifcontrol">
							<cfinvokeargument name="desplegar" value="HYCPdescripcion,  HYCPgrado, HYMRcodigo, HYTSPporcentaje, HYTSrestrict"/>
							<cfinvokeargument name="etiquetas" value="Descripci&oacute;n,  Grado, C&oacute;digo, Porcentaje, Habilitado"/>
							<cfinvokeargument name="formatos" value="S,S,S,S,V"/>
							<cfinvokeargument name="align" value="left,center,center,center,center"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="cortes" value="HYMRdescripcion"/>
							<cfinvokeargument name="irA" value="SolucionProblemasHAY.cfm"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="HYMRcodigo,HYCPgrado,HYTSPporcentaje"/>
						</cfinvoke>
					</td>
					<td width="55%" valign="top">
						<cfinclude template="SolucionProblemasHAY-form.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>