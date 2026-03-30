	
<cf_templateheader title="Modulo Indicadores Gesti&oacute;n">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cat&aacute;logo de Monedas'>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td valign="top" width="45%"> 
						<cfinvoke component="commons.Componentes.pListas" method="pListaRH" returnvariable="pLista">
							<cfinvokeargument name="tabla" value="MIGMonedas"/>
							<cfinvokeargument name="columnas" value="Mcodigo, Mnombre, Miso4217, Msimbolo"/>
							<cfinvokeargument name="desplegar" value="Miso4217, Mnombre, Msimbolo"/>
							<cfinvokeargument name="etiquetas" value="Código, Descripción, Símbolo"/>
							<cfinvokeargument name="formatos" value=""/>
							<cfinvokeargument name="keys" value="Mcodigo">
							<cfinvokeargument name="filtro" value="Ecodigo = #session.Ecodigo# order by Miso4217, Mnombre"/>
							<cfinvokeargument name="align" value="left,left,left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="irA" value="Monedas.cfm"/>
						</cfinvoke>
					</td>
					<td valign="top">
						<cfinclude template="formMonedas.cfm">
					</td>
					<td valign="top" align="right">
						<cf_sifayudaRoboHelp name="imAyuda" imagen="1" Tip="true" width="500" url="Monedas.htm">
					</td>
				</tr>
			</table>
	<cf_web_portlet_end>	
<cf_templatefooter>