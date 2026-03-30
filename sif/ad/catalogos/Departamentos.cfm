<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_SIFAdministracionDelSistema"
Default="SIF - Administraci&oacute;n del Sistema"
XmlFile="/sif/generales.xml"
returnvariable="LB_SIFAdministracionDelSistema"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_CatalogoDeDepartamentos"
Default="Cat&aacute;logo de Departamentos"
returnvariable="LB_CatalogoDeDepartamentos"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Codigo"
Default="C&oacute;digo"
XmlFile="/sif/generales.xml"
returnvariable="LB_Codigo"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Descripcion"
Default="Descripci&oacute;n"
XmlFile="/sif/generales.xml"
returnvariable="LB_Descripcion"/>

<cf_templateheader title="#LB_SIFAdministracionDelSistema#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_CatalogoDeDepartamentos#'>
		<cfinclude template="../../portlets/pNavegacionAD.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr> 
				<td valign="top">
					<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet"
						tabla="Departamentos"
						columnas="Ecodigo,Dcodigo, Deptocodigo, Ddescripcion"
						desplegar="Deptocodigo, Ddescripcion"
						etiquetas="#LB_Codigo#,#LB_Descripcion#"
						formatos="S,S"
						filtro="Ecodigo=#session.Ecodigo# order by Deptocodigo"
						align="left, left"
						ajustar="N,N"
						checkboxes="N"
						MaxRows="15"
						filtrar_automatico="true"
						mostrar_filtro="true"												
						keys="Ecodigo,Dcodigo"
						irA="Departamentos.cfm"
						showEmptyListMsg="true">
					</cfinvoke>
				</td>
				<td align="left" valign="top" width="50%">
					<cfinclude template="formDepartamentos.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>	
<cf_templatefooter>