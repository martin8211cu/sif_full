<cfinvoke component="mig.Componentes.Translate"
method="Translate"
Key="LB_MIGEstructuraJ"
Default="MIG - Estructura Jer&aacute;rquica"
XmlFile="/sif/generales.xml"
returnvariable="LB_MIGEstructuraJ"/>

<cfinvoke component="mig.Componentes.Translate"
method="Translate"
Key="LB_CatalogoDeDepartamentos"
Default="Cat&aacute;logo de Departamentos"
returnvariable="LB_CatalogoDeDepartamentos"/>

<cfinvoke component="mig.Componentes.Translate"
method="Translate"
Key="LB_Codigo"
Default="C&oacute;digo de Departamento"
XmlFile="/sif/generales.xml"
returnvariable="LB_Codigo"/>

<cfinvoke component="mig.Componentes.Translate"
method="Translate"
Key="LB_CodigoG"
Default="C&oacute;digo Gerencia"
XmlFile="/sif/generales.xml"
returnvariable="LB_CodigoG"/>

<cfinvoke component="mig.Componentes.Translate"
method="Translate"
Key="LB_DescripcionG"
Default="Descripci&oacute;n Gerencia"
XmlFile="/sif/generales.xml"
returnvariable="LB_DescripcionG"/>

<cfinvoke component="mig.Componentes.Translate"
method="Translate"
Key="LB_Descripcion"
Default="Descripci&oacute;n de Departamento"
XmlFile="/sif/generales.xml"
returnvariable="LB_Descripcion"/>

<cf_templateheader title="#LB_MIGEstructuraJ#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_CatalogoDeDepartamentos#'>
		<cfinclude template="../portlets/pNavegacion.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr> 

				<td valign="top" width="50%"> 
					<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
				tabla="Departamentos a 
						left join MIGGerencia b
							on a.MIGGid=b.MIGGid"
				columnas="a.Dcodigo, a.Deptocodigo, a.Ddescripcion, b.MIGGid, b.MIGGcodigo,b.MIGGdescripcion"
				desplegar="Deptocodigo,Ddescripcion,MIGGcodigo,MIGGdescripcion"
				etiquetas="#LB_Codigo#,#LB_Descripcion#,#LB_CodigoG#,#LB_DescripcionG#"
				formatos="S,S,S,S"
				filtro="a.Ecodigo=#session.Ecodigo# order by a.Deptocodigo"
				align="left, left,left,left"
				checkboxes="N"
				keys="Dcodigo"
				MaxRows="15"
				pageindex="65"
				filtrar_automatico="true"
				mostrar_filtro="true"
				filtrar_por=""
				ira="Departamentos.cfm"
				showEmptyListMsg="true">
				</td>
				<td align="left" valign="top" width="50%">
					<cfinclude template="formDepartamentos.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>	
<cf_templatefooter>