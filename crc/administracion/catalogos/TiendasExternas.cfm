<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Title" Default="Tiendas Externas" returnvariable="LB_Title"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Codigo" Default="Codigo" returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Activo" Default="Activo" returnvariable="LB_Activo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripcion" returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ExpREg" Default="Folio(Exp Reg.)" returnvariable="LB_ExpREg"/>


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
						tabla="CRCTiendaExterna"
						columnas="id,Codigo,Descripcion,Activo"
						desplegar="Codigo,Descripcion,Activo"
						etiquetas="#LB_Codigo#,#LB_Descripcion#,#LB_Activo#"
						formatos="S,S,L"
						filtro="Ecodigo=#session.Ecodigo#"
						align="left,left,left"
						checkboxes="N"
						ira="TiendasExternas.cfm"
						keys="id">
					</cfinvoke>
					<cf_exportarCatalogo tableName="CRCTiendaExterna" keyColumnName="Codigo">
				</td>
				<td width="50%">
					<cfinclude template="TiendasExternas_form.cfm">
				</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
		</table>
		<cfoutput>

		<cfif isdefined("form.resultT") and #form.resultT# neq ""> 
			<script type="text/javascript">
				alert("#form.resultT#");
			</script> 
		</cfif>					

	</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>