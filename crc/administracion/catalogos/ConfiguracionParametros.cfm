<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Title" Default="Configuracion de Parametros" returnvariable="LB_Title"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Codigo" Default="Codigo" returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripcion" returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Modulo" Default="Modulo" returnvariable="LB_Modulo"/>


<cf_templateheader title="#LB_Title#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Title#'>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="2">
					<cfinclude template="/home/menu/pNavegacion.cfm">
				</td>
			</tr>
			<tr>
				<td width="50%" valign="top">
					<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
						tabla="CRCParametros"
						columnas="id,Pcodigo,Mcodigo,Pdescripcion"
						desplegar="Pcodigo,Mcodigo,,Pdescripcion"
						etiquetas="#LB_Codigo#,#LB_Modulo#,#LB_Descripcion#"
						mostrar_filtro="true"
						filtrar_automatico="true"
						formatos="S,S,S"
						filtro="Ecodigo=#session.Ecodigo#"
						align="left,left,left"
						checkboxes="N"
						ira="ConfiguracionParametros.cfm"
						keys="id">
					</cfinvoke>
					<!--- <cfinclude template="../../commons/transferenciaDatos.cfm"> --->
					<!---
					<cfset tableName="CRCParametros">
					<cfset keyColumnName="Pcodigo">
					<cfinclude template="Exportar_form.cfm"> --->
					<cf_exportarCatalogo tableName="CRCParametros" keyColumnName="Pcodigo">
					
				</td>
				<td width="50%">
					<cfinclude template="ConfiguracionParametros_form.cfm">
				</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>