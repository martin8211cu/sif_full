<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_Anno" Default="A&ntilde;o" returnvariable="LB_Anno" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_CODIGO" Default="C&oacute;digo" XmlFile="/rh/generales.xml" returnvariable="LB_CODIGO" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_DESCRIPCION" Default="Descripci&oacute;n" XmlFile="/rh/generales.xml" returnvariable="LB_DESCRIPCION" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<!--- FIN VARIABLES DE TRADUCCION --->

	<cf_templateheader>
		<cf_web_portlet_start>
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
				<tr>
					<td width="50%" valign="top">

                            <cfset navegacion = ''>
                            <cfinvoke component="rh.Componentes.pListas" method="pListaRH">
								<cfinvokeargument name="tabla" value="RHReportesDinamicoE "/>
								<cfinvokeargument name="columnas" value="RHRDEid, RHRDEcodigo, RHRDEdescripcion"/>
								<cfinvokeargument name="desplegar" value="RHRDEcodigo, RHRDEdescripcion"/>
								<cfinvokeargument name="etiquetas" value="#LB_CODIGO#, #LB_DESCRIPCION#"/>
								<cfinvokeargument name="formatos" value="S,S"/>
								<cfinvokeargument name="filtro" value="1=1 and CEcodigo = #session.CEcodigo# order by RHRDEdescripcion"/>
								<cfinvokeargument name="align" value="left, left"/>
								<cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="irA" value="RepDinamicosColumna.cfm"/>
								<cfinvokeargument name="botones" value="Nuevo"/>
								<cfinvokeargument name="keys" value="RHRDEid"/>
								<cfinvokeargument name="debug" value="N"/>
								<cfinvokeargument name="navegacion" value="#navegacion#"/>
								<cfinvokeargument name="mostrar_filtro" value="true"/>
								<cfinvokeargument name="filtrar_automatico" value="true"/>
							</cfinvoke>
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>
