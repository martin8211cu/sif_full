<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SIFAdministracionDelSistema"
	Default="SIF - Administraci&oacute;n del Sistema"
	XmlFile="/sif/generales.xml"
	returnvariable="LB_SIFAdministracionDelSistema"/>
	
<cf_templateheader title="#LB_SIFAdministracionDelSistema#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cat&aacute;logo de Monedas'>
		<cfif isdefined("session.modulo") and session.modulo EQ "CG">
			<cfinclude template="../../portlets/pNavegacionCG.cfm">
		<cfelseif isdefined("session.modulo") and session.modulo EQ "AD">
			<cfinclude template="../../portlets/pNavegacionAD.cfm">
		</cfif>				
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td valign="top" width="45%"> 
						<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pLista">
							<cfinvokeargument name="tabla" value="Monedas"/>
							<cfinvokeargument name="columnas" value="Mcodigo, Mnombre, Miso4217, Msimbolo"/>
							<cfinvokeargument name="desplegar" value="Miso4217, Mnombre, Msimbolo"/>
							<cfinvokeargument name="etiquetas" value="Código, Descripción, Símbolo"/>
							<cfinvokeargument name="formatos" value=""/>
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