<cf_templateheader title="Cat&aacute;logo Auxiliar de Soluci&oacute;n Problemas">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cat&aacute;logo Auxiliar de Soluci&oacute;n Problemas HAY'>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td colspan="2">
						<cfinclude template="/rh/portlets/pNavegacion.cfm">
					</td>
				</tr>

				<tr> 
					<td valign="top"> 
						<cfquery name="rsLista" datasource="sifcontrol">
							select HYTAptshab, {fn concat(<cf_dbfunction name="to_char" args="HYTAporcentaje" datasource="sifcontrol"> ,'%')} as porcentaje, HYTAporcentaje,HYTApts , HYTASrestrict
							from HYTASolucionProblemas
							order by HYTAporcentaje desc, HYTAptshab
						</cfquery>

						<cfinvoke 
						component="rh.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="conexion" value="sifcontrol">
							<cfinvokeargument name="desplegar" value="HYTAptshab,  HYTApts, HYTASrestrict"/>
							<cfinvokeargument name="etiquetas" value="Puntos Habilidad,  Valor, Habilitado"/>
							<cfinvokeargument name="formatos" value="S,S,S"/>
							<cfinvokeargument name="align" value="left,left,center"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="cortes" value="porcentaje"/>
							<cfinvokeargument name="irA" value="AuxSolucionProblemasHAY.cfm"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="HYTAptshab, HYTAporcentaje"/>
						</cfinvoke>
					</td>
					<td width="55%" valign="top">
						<cfinclude template="AuxSolucionProblemasHAY-form.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>