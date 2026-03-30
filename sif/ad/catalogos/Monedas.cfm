<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SIFAdministracionDelSistema"
	Default="SIF - Administraci&oacute;n del Sistema"
	XmlFile="/sif/generales.xml"
	returnvariable="LB_SIFAdministracionDelSistema"/>

<cfinvoke key="LB_Titulo" default="Cat&aacute;logo de Monedas" 	returnvariable="LB_Titulo" 	component="sif.Componentes.Translate" 
method="Translate" xmlfile="Monedas.xml"/>	
<cfinvoke key="LB_Codigo" default="Código" returnvariable="LB_Codigo" component="sif.Componentes.Translate" 
method="Translate" xmlfile="Monedas.xml"/>	
<cfinvoke key="LB_Descripcion" default="Descrpción" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate" xmlfile="Monedas.xml"/>
<cfinvoke key="LB_Simbolo" 	default="Símbolo" returnvariable="LB_Simbolo" component="sif.Componentes.Translate"
method="Translate" xmlfile="Monedas.xml"/>		

<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo# '>
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
							<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#, #LB_Simbolo#"/>
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
					<!---<td valign="top" align="right">
						<cf_sifayudaRoboHelp name="imAyuda" imagen="1" Tip="true" width="500" url="Monedas.htm">
					</td>--->
				</tr>
			</table>
	<cf_web_portlet_end>	
<cf_templatefooter>